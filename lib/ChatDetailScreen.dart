import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_webservice/staticmap.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:photo_view/photo_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/Network/constant.dart';
import 'package:intl/intl.dart';
import 'Constraint/AppLoadingScreen.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/ChatMessage.dart';
import 'Model/ChatUser.dart';
import 'Model/User.dart';
import 'Network/network.dart';
import 'main.dart';
import 'Constraint/globals.dart' as global;
// import 'package:http/http.dart' as http;

class ChatDetailWidget extends StatefulWidget {
  @override
  _ChatDetailWidgetState createState() => _ChatDetailWidgetState();
}

class _ChatDetailWidgetState extends State<ChatDetailWidget> with RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  // ScrollController _scrollController = new ScrollController();
  FlutterSoundPlayer _flutterSoundPlayer;
  FlutterSoundRecorder _soundRecorder;
  bool _initSoundPlayer = false;
  bool _initRecorder = false;
  User user;
  ScrollController _scrollController;
  bool showProgress = false;
  Chat chat;
  List<ChatMessages> messages = [];
  String message = "";
  final messageCtrl = TextEditingController();
  FirebaseMessaging _firebaseMessaging;
  bool _initialized = false;
  bool _error = false;
  bool isRecording = false;
  String curl = '';
  double miliSeconds = 0;
  double mcTimer = 0;
  bool bottomSheet = false;
  bool firstLoading = true;

  List imageList = [];

  _scrollListener() async {
    if (_scrollController.position.atEdge) {
      if (_scrollController.position.pixels == 0) {
        // You're at the top.
        // print("top");
        setState(() {
          showProgress = true;
        });
        await Future.delayed(Duration(seconds: 1));
        setState(() {
          showProgress = false;
        });
      } else {
        // print("bottom");
        // You're at the bottom.
      }
    }
  }

  void play(url) async {
    if (url.length > 0) {
      File file = File(url);
      print(file);
      // print("i am done" + url);

      await _flutterSoundPlayer.startPlayer(
          fromURI: url,
          codec: Codec.mp3,
          whenFinished: () {
            setState(() {
              stopPlayer();
            });
          });
    } else {
      showToast("no file found");
    }
    setState(() {});
  }

  Future<void> stopPlayer() async {
    if (_flutterSoundPlayer != null) {
      await _flutterSoundPlayer.stopPlayer();
    }
  }

  Future<void> record() async {
    try {
      if (await Permission.microphone.request().isDenied) {
        print("granted");
      }
      if (await Permission.storage.request().isGranted) {
        print("granted");
      }
      final directory = await getApplicationDocumentsDirectory();
      setState(() {
        isRecording = true;
      });
      var tempDir = await getTemporaryDirectory();
      String path = '${tempDir.path}/flutter_sound.aac';
      await _soundRecorder
          .startRecorder(
        toFile: path,
        codec: Codec.aacADTS,
      )
          .whenComplete(() {
        // _soundRecorder.setSubscriptionDuration(duration)
      });
      curl = '${tempDir.path}/flutter_sound.aac';
    } catch (e) {
      showToast("error occured");
      setState(() {
        isRecording = false;
      });
      print(e);
    }
  }

  Future<String> stopRecorder() async {
    setState(() {
      isRecording = false;
    });
    if (!await checkFilePath(curl)) {
      showToast("no file found");
      return "";
    }
    await _soundRecorder.stopRecorder();
    var data = {
      "path": curl,
      "requestType": "audio_message",
      "userId": user.id
    };
    var res = await uploadAudioFile(data);
    try {
      if (res.length > 0) {
        print(url + res);
        return res.trim();
      } else {
        return "";
      }
    } catch (e) {
      return '';
    }
  }

  cancelRecorder() async {
    setState(() {
      isRecording = false;
    });
    await _soundRecorder.stopRecorder();
  }

  initRecorder() async {
    try {
      print("here");
      var permission = await Permission.microphone.request();
      if (!permission.isGranted) {
        showToast("Permission Denied");
        return;
      }
      if (permission.isGranted) {
        print("here2");

        _soundRecorder = new FlutterSoundRecorder();
        print("here3");

        _soundRecorder.openAudioSession().then((value) {
          setState(() {
            _initRecorder = true;
          });
        });
      }
      print("here2");
    } catch (e) {
      print(e);
    }
  }

  disposeRecorder() {
    timer.cancel();
    _soundRecorder.closeAudioSession();
    _soundRecorder = null;
  }

  initSoundPlayer() {
    _flutterSoundPlayer = new FlutterSoundPlayer();
    _flutterSoundPlayer.openAudioSession().then((value) {
      setState(() {
        _initSoundPlayer = true;
      });
    });
  }

  disposePlayer() {
    _flutterSoundPlayer.closeAudioSession();
    _flutterSoundPlayer = null;
  }

  initDownloader() async {
    try {
      WidgetsFlutterBinding.ensureInitialized();
      await FlutterDownloader.initialize();
    } catch (e) {}
  }

  void initScroll() async {
    try {
      _scrollController = ScrollController();
      await Future.delayed(Duration(microseconds: 100));
      _scrollController.addListener(_scrollListener);
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 10), curve: Curves.easeOut);
      setState(() {
        _scrollController = _scrollController;
      });
    } catch (e) {}
  }

  moveToBottomScroll() async {
    if (_scrollController.hasClients) {
      print("here");
      print(_scrollController.position.maxScrollExtent);
      _scrollController.animateTo(_scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 600), curve: Curves.easeOut);
    }
    setState(() {
      _scrollController = _scrollController;
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_scrollListener);
    disposePlayer();
    disposeRecorder();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    var request = {
      "requestType": "getMessages",
      "userId": user.id,
      "otherUserId": chat.userId,
      "chat_id": chat.id,
    };
    print(request);
    var data = await getConversationList(request);
    setState(() {
      firstLoading = false;
    });
    if (data != null) {
      var res = data["response"]["chat"];
      messages.clear();
      for (int i = 0; i < res.length; i++) {
        messages.add(ChatMessages.fromJson(res[i]));
      }
      setState(() {
        messages = messages;
      });
    }
    setState(() {
      moveToBottomScroll();
    });
  }

  sendNotification() async {
    Map<String, dynamic> data = Map();
    Map<String, dynamic> to = Map();
    data["title"] = user.userName;
    data["message"] = "message";
    to["notification"] = {
      "title": "Message from " + user.userName,
      "body": message
    };
    to["to"] = chat.otherFcm.toString();
    // to["to"] = "allDevices";
    to["data"] = data;

    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
      HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
      "Authorization": "Key=" + FCM_SERVER_KEY,
    };
    var response =
        await post(NOTIFICATION_URL, headers: headers, body: jsonEncode(to))
            .then((value) {
      print("fcm response");
      print(value.body);
    }, onError: (err) {
      print("fcm error");
      print(err);
    });
    //print(response.body);
  }

  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  sendImageMessage() async {
    DateTime now = DateTime.now();
    // String formattedDate = DateFormate('kk:mm:ss \n EEE d MMM').format(now);
    showDynamicToast("Sending.....",
        color: Colors.blue, textColor: Colors.white, gravity: ToastGravity.TOP);
    var images = [];
    var imgs = [];
    for (int i = 0; i < imageList.length; i++) {
      final bytes = imageList[i].readAsBytesSync();
      String base = base64Encode(bytes);
      imgs.add(base);
      String name = imageList[i].path.split("/").last;
    }
    var bimgs = jsonEncode(imgs);
    var request = {
      "requestType": "send_image_message",
      "userId": user.id,
      "otherUserId": chat.userId,
      "images": bimgs,
      "chat_id": chat.id,
      "time_send": now.hour.toString() + ":" + now.minute.toString(),
    };
    var data = await getConversationList(request);
    if (data != null) {
      getPageData();
      imageList.clear();
      sendNotification();
      showToast("image sent successfully");
    } else {
      showToast("send image failed");
    }
  }

//Send Messages
  sendAudio() async {
    setState(() {
      mcTimer = miliSeconds;
    });
    stopRecordingTimer();

    print("here");
    DateTime now = DateTime.now();
    // String formattedDate = DateFormate('kk:mm:ss \n EEE d MMM').format(now);
    var dateTime = now.year.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.day.toString() +
        " " +
        now.hour.toString() +
        ":" +
        now.minute.toString() +
        ":" +
        now.second.toString();
    ChatMessages chatMessages = new ChatMessages();
    chatMessages.message = message;
    chatMessages.type = "Sender";
    chatMessages.fileType = "audio";
    var p = await getApplicationDocumentsDirectory();
    chatMessages.fileUrl = "";
    chatMessages.updatedAt = dateTime;

    chatMessages.senderId = user.id;
    chatMessages.userName = user.firstName;
    chatMessages.lenght = mcTimer.toString();
    chatMessages.sendDate = dateTime;
    chatMessages.isLoading = true;
    setState(() {
      messages.insert(0, chatMessages);
      print("===========++<" + messages[0].lenght);
      messages = messages;
      moveToBottomScroll();
    });

    showToast("uploading");
    String murl = await stopRecorder();
    print("here " + murl);
    var request = {
      "requestType": "send_audio_message",
      "userId": user.id,
      "otherUserId": chat.userId,
      "url": murl,
      "length": mcTimer,
      "chat_id": chat.id,
      "time_send": now.hour.toString() + ":" + now.minute.toString(),
    };
    sendAudioMessage(request);
  }

  sendAudioMessage(request) async {
    var data = await getConversationList(request);

    if (data != null) {
      setState(() {
        messages[0].isLoading = false;
      });
      getPageData();
    } else {
      setState(() {
        messages[messages.length - 1].isLoading = false;
        messages.removeAt(messages.length - 1);
      });
    }
    sendNotification();
  }

  sendMessage() async {
    DateTime now = DateTime.now();
    // String formattedDate = DateFormate('kk:mm:ss \n EEE d MMM').format(now);
    var request = {
      "requestType": "messageRequest",
      "userId": user.id,
      "otherUserId": chat.userId,
      "message": message,
      "chat_id": chat.id,
      "time_send": now.hour.toString() + ":" + now.minute.toString(),
    };
    ChatMessages chatMessages = new ChatMessages();
    chatMessages.message = message;
    chatMessages.type = "Sender";
    chatMessages.updatedAt = now.year.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.day.toString() +
        " " +
        now.hour.toString() +
        ":" +
        now.minute.toString() +
        ":" +
        now.second.toString();

    chatMessages.senderId = user.id;
    chatMessages.userName = user.firstName;
    chatMessages.sendDate = now.year.toString() +
        "-" +
        now.month.toString() +
        "-" +
        now.day.toString() +
        " " +
        now.hour.toString() +
        ":" +
        now.day.toString();
    chatMessages.isLoading = true;
    messages.insert(0, chatMessages);

    setState(() {
      messages = messages;
    });
    setState(() {
      moveToBottomScroll();
    });
    var data = await getConversationList(request);
    if (data != null) {
      setState(() {
        messages[messages.length - 1].isLoading = false;
      });
      getPageData();
    } else {
      setState(() {
        messages[messages.length - 1].isLoading = false;
        messages.removeAt(messages.length - 1);
      });
    }
    sendNotification();
    message = '';
  }

  @override
  void initState() {
    initSoundPlayer();
    initRecorder();
    startTimer();
    initDownloader();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitDown,
      DeviceOrientation.portraitUp,
    ]);
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // showSnakBar("Test", "Some Test Notification");
    var args = ModalRoute.of(context).settings.arguments;
    setState(() {
      chat = args;
    });
    getPageData();
    initScroll();
    fcmInit();
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  void didPopNext() {
    fcmInit();
  }

  void FCMMesseging(message) {
    print("onMessage Chat detail: $message");
    if (message["data"]["type"] == "Intransfer") {
      hammerDialog(context);
    }
    getPageData();
  }

  fcmInit() {
    print("init chat detail");
    global.onInnerMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }

  // Widget Player(murl) {
  //   bool isPlaying = false;
  //   return Container(
  //       child: IconButton(
  //           onPressed: () {
  //             playNetworkAudio(murl);
  //             isPlaying = !isPlaying;
  //           },
  //           icon: Icon(
  //             Icons.play_arrow,
  //             color: Colors.black,
  //             size: 30,
  //           )));
  // }
  Timer timer;

  startTimer() {
    timer = Timer.periodic(Duration(milliseconds: 10000), (timer) {
      // setState(() {
      //   miliSeconds = miliSeconds + 100;
      // });
      getPageData();
      print(miliSeconds);
    });
  }

  stopRecordingTimer() {
    if (timer != null) timer.cancel();
    miliSeconds = 0;
  }

  showFileBottomSheet() async {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        // barrierColor: Colors.blueGrey.withOpacity(.5),
        // bounc : true,
        builder: (context) => StatefulBuilder(builder: (cont, setState) {
              return Container(
                height: getHeight(context),
                width: getWidth(context),
                decoration: BoxDecoration(
                  color: darkTheme["primaryBackgroundColor"],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                        size: 30,
                      ),
                      onPressed: () {
                        Navigator.of(cont).pop();
                      },
                    ),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Wrap(
                          children: [
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.camera,
                                    color: Colors.white,
                                    size: 70,
                                  ),
                                  onPressed: () async {
                                    var c = await openCamera();
                                    Navigator.of(cont).pop();
                                  },
                                  iconSize: 70,
                                ),
                                Text(
                                  "Camera",
                                  style: TextStyle(
                                    color: darkTheme["secondaryColor"],
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(width: 30),
                            Column(
                              children: [
                                IconButton(
                                  icon: Icon(
                                    Icons.image,
                                    color: Colors.white,
                                    size: 70,
                                  ),
                                  onPressed: () async {
                                    var g = await openGallery();
                                    Navigator.of(cont).pop();
                                  },
                                  iconSize: 70,
                                ),
                                Text(
                                  "Gallery",
                                  style: TextStyle(
                                    color: darkTheme["secondaryColor"],
                                    fontSize: 16,
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }));
  }

  Future<bool> openCamera() async {
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 20);

    if (image != null) {
      File _file = await cropImage(image);
      if (_file != null) {
        final bytes = _file.readAsBytesSync();
        print(bytes.toString());

        String base = base64Encode(bytes);
        String name = image.path.split("/").last;

        imageList.add(_file);
        setState(() {
          imageList = imageList;
        });
      }
      // } else {
      //   showToast("No image selected");
      // }
    } else {
      showToast("No image selected");
    }
    return true;
  }

  Future<bool> openGallery() async {
    try {
      final picker = ImagePicker();
      final image =
          await picker.getImage(source: ImageSource.gallery, imageQuality: 20);

      // PickedFile image = await picker
      //     .pickImage(source: ImageSource.gallery, imageQuality: 10);
      if (image != null) {
        // File _file = await cropImage(image);
        File _file = File(image.path);
        if (_file != null) {
          final bytes = _file.readAsBytesSync();
          print(bytes.toString());
          String base = base64Encode(bytes);
          String name = image.path.split("/").last;
          setState(() {
            imageList.add(_file);
          });
        } else {
          showToast("No image selected");
        }
      } else {
        showToast("No image selected");
      }
    } catch (e) {
      showToast(e.toString());
    }
    return true;
  }

  Future<File> cropImage(imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      // maxWidth: 1080,
      // maxHeight: 500,
      // aspectRatio: CropAspectRatio(ratioX: 2.0, ratioY: 1.5),
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      //   CropAspectRatioPreset.ratio3x2,
      //   CropAspectRatioPreset.original,
      //   CropAspectRatioPreset.ratio4x3,
      //   CropAspectRatioPreset.ratio16x9
      // ],
      // androidUiSettings: AndroidUiSettings(
      //     toolbarTitle: 'Cropper',
      //     toolbarColor: Colors.deepOrange,
      //     toolbarWidgetColor: Colors.white,
      //     initAspectRatio: CropAspectRatioPreset.original,
      //     lockAspectRatio: false
      // ),
      // iosUiSettings: IOSUiSettings(
      //   minimumAspectRatio: 1.0,
      // )
    );

    return croppedFile;
  }

  showFullImage(url) {
    print(url);
    Navigator.push(
        context,
        MaterialPageRoute(
          fullscreenDialog: true,
          builder: (_) {
            return Scaffold(
              body: Stack(
                children: [
                  GestureDetector(
                    child: Center(
                      child: InteractiveViewer(
                        boundaryMargin: EdgeInsets.all(100),
                        child: PhotoView(
                          heroAttributes:
                              PhotoViewHeroAttributes(tag: genrateMarkerId()),
                          imageProvider: NetworkImage(url),
                        ),
                      ),
                    ),
                  ),
                  Material(
                    color: Colors.black38,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15.0, 40, 0, 0),
                      child: IconButton(
                        icon: Icon(
                          Icons.arrow_back_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pop(_);
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }

  invloveSupport() async {
    // return;
    // $arr["detail"] = $input["detail"];
    // $arr["type"] = $input["type"];
    // $arr["chat_id"] = $input["chat_id"];
    // $arr["history"] = $input["history_id"];
    // $arr["status"] = "Active";
    var request = {
      "detail": "user added -user_id=" + user.id,
      "type": chat.type,
      "history_id": chat.historyId,
      // "": message,
      "chat_id": chat.id,
      // "time_send": now.hour.toString() + ":" + now.minute.toString(),
    };
    ProgressDialog progressDialog = showProgressDialog(ProgressDialog(context));
    var data = await invloveSupportChatRequest(request);
    hideProgressDialog(progressDialog);
    if (data != null) {}
  }

  actionMenuClick(index) {
    print(index);
    if (index == 0) {
      //Involve Support
      invloveSupport();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkTheme["primaryBackgroundColor"],
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton<int>(
            onSelected: (item) => actionMenuClick(item),
            itemBuilder: (context) => [
              PopupMenuItem<int>(
                  value: 0, child: Text('Involve Support Member')),
            ],
          ),
        ],
        toolbarHeight: 80,
        title: Flex(
          direction: Axis.horizontal,
          //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
          // child: null,
          children: [
            Expanded(
              flex: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: FadeInImage(
                  placeholder: AssetImage("assets/images/profile.png"),
                  image: NetworkImage(url + chat.profileImage),
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            // SizedBox(
            //   width: 10,
            // ),
            Expanded(
              flex: 4,
              child: Column(
                children: [
                  Text(
                    chat.name,
                    // maxLines: 1,
                  ),
                  if (chat.otherName != null && chat.otherName != "null")
                    Text(
                      "${chat.otherName} (${chat.supportName})",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
      ),
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: [
            Flex(
              direction: Axis.vertical,
              children: <Widget>[
                Expanded(
                  flex: orientation == Orientation.landscape
                      ? (getHeight(context) * 0.25).round()
                      : (getHeight(context) * 0.90).round(),
                  child: Container(
                    height: getHeight(context),
                    child: ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      reverse: true,
                      // controller: _scrollController,
                      padding: EdgeInsets.only(top: 10, bottom: 10),
                      itemBuilder: (context, index) {
                        // print(messages[index].fileType == "audio");
                        return Container(
                          // color: Colors.white,
                          padding: EdgeInsets.only(
                              left: 14, right: 14, top: 10, bottom: 10),
                          child: Align(
                              alignment: (messages[index].type == "Receiver" ||
                                      messages[index].type == "Support"
                                  ? Alignment.topLeft
                                  : Alignment.topRight),
                              child: messages[index].type == "Receiver" ||
                                      messages[index].type == "Support"
                                  ? Container(
                                      decoration: BoxDecoration(
                                        //  borderRadius: BorderRadius.circular(20),
                                        borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20)),
                                      ),
                                      // padding: EdgeInsets.all(16),
                                      child: Flex(
                                        direction: Axis.horizontal,
                                        children: [
                                          Container(
                                            height: 80,
                                            alignment: Alignment.topLeft,
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: FadeInImage(
                                                width: 40,
                                                height: 40,
                                                fit: BoxFit.cover,
                                                placeholder: AssetImage(
                                                    "assets/images/profile.png"),
                                                image: NetworkImage(url +
                                                    messages[index]
                                                        .profileImage),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            flex: 8,
                                            child: Container(
                                              padding: EdgeInsets.only(
                                                  left: 20,
                                                  right: 20,
                                                  bottom: 16,
                                                  top: 16),
                                              decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topRight:
                                                              Radius.circular(
                                                                  20),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  20),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  20))),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    messages[index].type !=
                                                            "Sender"
                                                        ? messages[index]
                                                                    .type ==
                                                                "Support"
                                                            ? messages[index]
                                                                    .userName +
                                                                " (Support)"
                                                            : messages[index]
                                                                    .userName +
                                                                ""
                                                        : messages[index]
                                                            .userName,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  messages[index].fileType ==
                                                          "audio"
                                                      ? AudioPlayerWidget(
                                                          message:
                                                              messages[index])
                                                      : messages[index]
                                                                  .fileType ==
                                                              "image"
                                                          ? GestureDetector(
                                                              onTap: () {
                                                                showFullImage(url +
                                                                    messages[
                                                                            index]
                                                                        .fileUrl);
                                                              },
                                                              child:
                                                                  GestureDetector(
                                                                onTap: () {
                                                                  showFullImage(url +
                                                                      messages[
                                                                              index]
                                                                          .fileUrl);
                                                                },
                                                                child: FadeInImage(
                                                                    placeholder:
                                                                        AssetImage(
                                                                            "assets/images/loading2.gif"),
                                                                    image: NetworkImage(url +
                                                                        messages[index]
                                                                            .fileUrl)),
                                                              ),
                                                            )
                                                          : Text(
                                                              messages[index]
                                                                  .message,
                                                              style: TextStyle(
                                                                  fontSize: 15),
                                                            ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 5,
                                          ),
                                          Expanded(
                                            flex: 2,
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  DateFormat.jm()
                                                      .format(
                                                          DateFormat("hh:mm:ss")
                                                              .parse(
                                                        messages[index]
                                                            .updatedAt
                                                            .split(" ")[1],
                                                      ))
                                                      .toString(),
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      color: Colors.white),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          messages[index].isLoading
                                              ? SizedBox(
                                                  height: 20,
                                                  width: 20,
                                                  child:
                                                      CircularProgressIndicator(
                                                    strokeWidth: 1,
                                                  ))
                                              : SizedBox(),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                        //  borderRadius: BorderRadius.circular(20),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            topRight: Radius.circular(20),
                                            bottomLeft: Radius.circular(20)),
                                      ),
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Flex(
                                                direction: Axis.horizontal,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    flex: 2,
                                                    child: Column(
                                                      /* mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,*/
                                                      children: [
                                                        Text(
                                                          DateFormat.jm().format(
                                                              DateFormat(
                                                                      "hh:mm")
                                                                  .parse(
                                                            messages[index]
                                                                .updatedAt
                                                                .split(" ")[1],
                                                          )),
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color:
                                                                  Colors.white),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Expanded(
                                                    flex: 9,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      children: [
                                                        Container(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  top: 16,
                                                                  left: 20,
                                                                  right: 20,
                                                                  bottom: 16),
                                                          decoration: BoxDecoration(
                                                              color:
                                                                  Colors.blue,
                                                              borderRadius: BorderRadius.only(
                                                                  bottomLeft: Radius
                                                                      .circular(
                                                                          20),
                                                                  topRight: Radius
                                                                      .circular(
                                                                          20),
                                                                  topLeft: Radius
                                                                      .circular(
                                                                          20))),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                messages[index]
                                                                            .type !=
                                                                        "Sender"
                                                                    ? messages[index].type ==
                                                                            "Support"
                                                                        ? messages[index].userName +
                                                                            " (Support)"
                                                                        : messages[index].userName +
                                                                            ""
                                                                    : messages[
                                                                            index]
                                                                        .userName,
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                    color: Colors
                                                                        .white),
                                                              ),
                                                              messages[index]
                                                                          .fileType ==
                                                                      "audio"
                                                                  ? AudioPlayerWidget(
                                                                      message:
                                                                          messages[
                                                                              index])
                                                                  : messages[index]
                                                                              .fileType ==
                                                                          "image"
                                                                      ? GestureDetector(
                                                                          onTap:
                                                                              () {
                                                                            showFullImage(url +
                                                                                messages[index].fileUrl);
                                                                          },
                                                                          child: FadeInImage(
                                                                              placeholder: AssetImage("assets/images/loading2.gif"),
                                                                              image: NetworkImage(url + messages[index].fileUrl)),
                                                                        )
                                                                      : Text(
                                                                          messages[index]
                                                                              .message,
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Colors.white),
                                                                        ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  messages[index].isLoading
                                                      ? SizedBox(
                                                          height: 20,
                                                          width: 20,
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 1,
                                                          ))
                                                      : SizedBox(),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  visible: imageList.length > 0,
                  child: Expanded(
                      flex: imageList.length > 0
                          ? (getHeight(context) * .20).round()
                          : 0,
                      child: Container(
                        color: Colors.grey.withOpacity(.4),
                        height: 40,
                        child: Stack(
                          alignment: Alignment.topRight,
                          children: [
                            ListView(
                              scrollDirection: Axis.horizontal,
                              children: List.generate(
                                imageList.length,
                                (index) => Stack(
                                  children: [
                                    Container(
                                      margin: EdgeInsets.fromLTRB(0, 0, 5, 0),
                                      child: Image.file(
                                        imageList[index],
                                        width: 150,
                                        height: getHeight(context),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            imageList.removeAt(index);
                                          });
                                        },
                                        iconSize: 30,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ElevatedButton(
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateColor.resolveWith((states) =>
                                          Colors.blue.withOpacity(.6)),
                                  elevation: MaterialStateProperty.resolveWith(
                                      (states) => 0.0),
                                ),
                                onPressed: () {
                                  setState(() {
                                    imageList.clear();
                                  });
                                },
                                child: Text("Clear")),
                          ],
                        ),
                      )),
                ),
                Expanded(
                  flex: (getHeight(context) *
                          (getHeight(context) * .10 - getHeight(context))
                              .round())
                      .round(),
                  child: Container(
                    margin: EdgeInsets.all(10),
                    height: getHeight(context) * .06,
                    decoration: BoxDecoration(
                      color: darkTheme['cardBackground'],
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.withOpacity(.5),
                            spreadRadius: 1.0)
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        FloatingActionButton(
                          heroTag: "tag1",
                          onPressed: () {
                            showFileBottomSheet();
                          },
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          child: Container(
                            child: Image(
                              image: AssetImage('assets/images/attachment.png'),
                              color: Colors.grey,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: isRecording
                              ? Container(
                                  child: Text(
                                    (miliSeconds / 1000).toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25),
                                  ),
                                )
                              : Container(
                                  // margin: EdgeInsets.only(top: 18),
                                  child: imageList.length > 0
                                      ? SizedBox(
                                          child: Text(
                                            "Send Images",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )
                                      : TextField(
                                          controller: messageCtrl,
                                          onChanged: (val) {
                                            message = val;
                                          },
                                          cursorColor: Colors.white,
                                          style: TextStyle(color: Colors.white),
                                          decoration: InputDecoration(
                                              hintText: "Type a Message",
                                              hintStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16),
                                              border: InputBorder.none),
                                        ),
                                ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        FloatingActionButton(
                          heroTag: "tag2",
                          backgroundColor: Colors.transparent,
                          highlightElevation: 0,
                          // foregroundColor: Colors.red,
                          elevation: 0,
                          onPressed: () async {
                            if (imageList.length > 0) {
                              showToast("clear images first");
                              return;
                            }
                            if (isRecording) {
                              cancelRecorder();
                              setState(() {
                                mcTimer = miliSeconds;
                              });
                              stopRecordingTimer();
                              print("-------->" + mcTimer.toString());
                            } else {
                              record();
                              stopRecordingTimer();
                              startTimer();
                            }
                          },
                          child: !isRecording
                              ? Image(
                                  image: AssetImage(
                                      'assets/images/microphone.png'),
                                  // Icons.attachment,
                                  color: Colors.grey,
                                  // size: 20,
                                )
                              : Icon(
                                  Icons.clear,
                                  color: Colors.red,
                                ),
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 2, right: 10),
                          child: FloatingActionButton(
                            heroTag: "tag3",
                            onPressed: () {
                              if (imageList.length > 0) {
                                sendImageMessage();
                              }
                              print(message);
                              // print(updatedAt);
                              messageCtrl.clear();
                              // print(isRecording);
                              isRecording
                                  ? sendAudio()
                                  : message.length > 0
                                      ? isRecording
                                          ? sendAudio()
                                          : sendMessage()
                                      : null;
                            },
                            child: Image(
                              image: AssetImage('assets/images/msg.png'),
                              // Icons.send,
                              color: Colors.blue,
                              // size: 18,
                            ),
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            if (firstLoading)
              AppLoadingScreen(
                backgroundOpactity: .6,
              )
          ],
        );
      }),
    );
  }
}

class AudioPlayerWidget extends StatefulWidget {
  ChatMessages message;

  AudioPlayerWidget({this.message});

  @override
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  @override
  setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isPlaying = false;
  bool isDownloading = false;
  double currentTime = 0.0;
  double minTime = 0.0;
  double maxTime = 0.0;
  int seekVal = 0;

  AssetsAudioPlayer get assetsAudioPlayer => AssetsAudioPlayer.withId('music');

  playNetworkAudio(playurl) async {
    print(url + playurl);
    var d = playurl.split("/");
    var filename = d[d.length - 1];
    print(filename);
    var path2 = await getApplicationDocumentsDirectory();
    var path = path2.path + "/" + MAIN_APP_DIRECTAORY + "/" + AUDIO_DIRECTORY;
    bool exists = await checkDirectoryPath(path);

    print(exists);
    if (!exists) {
      await createDirectory(MAIN_APP_DIRECTAORY + "/" + AUDIO_DIRECTORY);
    }
    //bool exists2 = await checkDirectoryPath(path);
    var audioDir = await getAudioDirectory();
    print("Audio Dir : " + audioDir);
    var fexists = await checkFilePath(audioDir + "/" + filename);
    print(fexists);
    print(exists);

    if (!fexists && exists) {
      setState(() {
        isDownloading = true;
      });
      final taskId = await FlutterDownloader.enqueue(
        url: url + playurl,
        savedDir: path,
        showNotification: true,
        fileName: filename,

        // show download progress in status bar (for Android)
        openFileFromNotification:
            true, // click on notification to open downloaded file (for Android)
      )
          .catchError((err) {
            print(err);
            showToast("error while downloading");
            playLiveAudio(url + playurl);
          })
          .whenComplete(() {})
          .then((value) async {
            setState(() {
              print("+++++++++++++++++++++>>>>>>>>" + "Success");
              DownloadTask(taskId: value).status;
              isDownloading = false;
            });
            playLocalAudio(await getAudioDirectory() + "/" + filename);
          });
    } else {
      if (fexists && exists) {
        playLocalAudio(await getAudioDirectory() + "/" + filename);
        // playLocalAudio(await getAudioDirectory() + "/" + filename);
      } else {
        showToast("internal Error Trying to play from direct link");
        playLiveAudio(url + playurl);
      }
    }
  }

  playLocalAudio(locUrl) async {
    try {
      print("local Url" + locUrl);

      setState(() {
        isPlaying = true;
      });
      Audio audio = await Audio.file(locUrl);
      // assetsAudioPlayer.currentPosition;
      var playingAudio = await assetsAudioPlayer
          .open(
            audio,
            autoStart: true,
            seek: Duration(seconds: seekVal),
            // audioFocusStrategy: AudioFocusStrategy.request(),
            // showNotification: true,
          )
          .then((value) {});
      var state = assetsAudioPlayer.playerState;
      Timer timer;
      print("-------------------");
      timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        print("-------------------");
        print(assetsAudioPlayer.isPlaying.value);
        if (assetsAudioPlayer.isPlaying.value) {
          print(seekVal);
          if (seekVal != 0) {
            setState(() {
              // assetsAudioPlayer.seekBy(Duration(seconds: seekVal));
              // print("==========++>" +
              //     assetsAudioPlayer.currentPosition.value.inSeconds.toString());
              //
              // currentTime = double.tryParse(seekVal.toString());
              // assetsAudioPlayer.builderCurrentPosition(builder: null)
            });
            seekVal = 0;
          }
          setState(() {
            isPlaying = true;
            var cTime = assetsAudioPlayer.currentPosition.value.inSeconds;

            if (cTime > maxTime) {
              currentTime = maxTime;
            } else {
              currentTime = double.tryParse(
                  assetsAudioPlayer.currentPosition.value.inSeconds.toString());
            }
          });
        } else {
          timer.cancel();
          setState(() {
            isPlaying = false;
            currentTime = 0;
            seekVal = 0;
          });
        }
      });
    } catch (t) {
      print(t);
      playLiveAudio(url + "" + widget.message.fileUrl);
      setState(() {
        isPlaying = false;
      });
    }
  }

  playLiveAudio(liveUrl) async {
    try {
      Timer timer;
      print(liveUrl);
      Audio audio = await Audio.network(liveUrl);
      setState(() {
        isPlaying = true;
      });
      // await Permission.speech.request();
      var d = await assetsAudioPlayer
          .open(
        audio,
        autoStart: true,
        showNotification: true,
      )
          .catchError((e) {
        print(e);
        print('here');
      });
      timer = Timer.periodic(Duration(milliseconds: 500), (timer) {
        // print(assetsAudioPlayer.isPlaying.value);
        print(assetsAudioPlayer.isPlaying.value);
        print(assetsAudioPlayer.currentPosition.value.inSeconds.toString());
        if (assetsAudioPlayer.isPlaying.value) {
          print(currentTime);
          setState(() {
            isPlaying = true;
            var cTime = assetsAudioPlayer.currentPosition.value.inSeconds;
            if (cTime > maxTime) {
              currentTime = maxTime;
            } else {
              currentTime = double.tryParse(
                  assetsAudioPlayer.currentPosition.value.inSeconds.toString());
            }
          });
        } else {
          timer.cancel();
          setState(() {
            isPlaying = false;
            currentTime = 0.0;
          });
        }
      });
    } catch (e) {
      print(e);
      showToast("somthing went wrong");
      setState(() {
        isPlaying = false;
      });
    }
  }

  @override
  void dispose() {
    assetsAudioPlayer.dispose();

    // TODO: implement dispose

    super.dispose();
  }

  @override
  void initState() {
    print(widget.message.lenght + "");
    maxTime = double.tryParse(widget.message.lenght) > 0.0
        ? (double.tryParse(widget.message.lenght) * 1.1) / 1000
        : 0.0;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                flex: 2,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                        width: 50,
                        height: 50,
                        child: isDownloading
                            ? CircularProgressIndicator()
                            : SizedBox()),
                    FloatingActionButton(
                        heroTag: genrateMarkerId(),
                        elevation: 0,
                        highlightElevation: 0,
                        mini: true,
                        // backgroundColor: Colors.black,
                        child: Icon(
                          isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          if (isPlaying) {
                            assetsAudioPlayer.stop();
                            setState(() {
                              isPlaying = !isPlaying;
                            });
                            return;
                          }
                          playNetworkAudio(widget.message.fileUrl);
                        }),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Slider(
                      value: currentTime,
                      activeColor:
                          isPlaying ? Colors.white : Colors.blueGrey[600],
                      onChanged: (val) {
                        setState(() {
                          print(val);
                          currentTime = val;
                          seekVal = val.floor();
                          print("=----=-==-=-=->>>>>>>>" +
                              val.floor().toString());
                          assetsAudioPlayer
                              .seek(Duration(seconds: val.floor()));
                          // assetsAudioPlayer
                          //     .seek(Duration(seconds: val.round()));
                          // assetsAudioPlayer.currentPosition.value. . = 1;
                        });
                      },
                      min: minTime,
                      max: maxTime,
                    ),
                  ],
                ),
              ),
              // assetsAudioPlayer.builderRealtimePlayingInfos(
              //     builder: (context, RealtimePlayingInfos infos) {
              //   if (infos == null) {
              //     return SizedBox();
              //   }
              //   if (infos.current == null) {
              //     return SizedBox();
              //   }
              //   return Column(children: <Widget>[
              //     assetsAudioPlayer.builderLoopMode(builder: (context, loopMode) {
              //       return SizedBox();
              //     })
              //   ]);
              // })
            ],
          ),
          Text(
            currentTime.roundToDouble().toString() +
                " / " +
                maxTime.roundToDouble().toString(),
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

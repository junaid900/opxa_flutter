import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:clipboard/clipboard.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/Model/OwnerAccount.dart';
import 'package:qkp/Model/Package.dart';
import 'package:qkp/Network/URLS.dart';
import 'package:qkp/Network/http_requests.dart';

import 'CircularInputField.dart';
import 'Constraint/Dialog.dart';
import 'CustomeElivatedButton.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/User.dart';
import 'Network/constant.dart';
import 'Network/network.dart';
import 'main.dart';
import 'Constraint/globals.dart' as global;

class DirectDepositScreenWidget extends StatefulWidget {
  @override
  _DirectDepositScreenWidgetState createState() =>
      _DirectDepositScreenWidgetState();
}

class _DirectDepositScreenWidgetState extends State<DirectDepositScreenWidget>
    with RouteAware {
  bool isTopLoading = false;
  User user;
  String details, amount, slipNo = "";
  Map<String, dynamic> _image = {};
  Package package;
  List<OwnerAccounts> ownerAccounts = [];

  getPageData() async {
    user = await getUser();
    var res = await getRequest(OWNER_ACCOUNTS);
    if (res != null) {
      var accountsListMap = res['accounts'];
      for (int i = 0; i < accountsListMap.length; i++) {
        ownerAccounts.add(OwnerAccounts.fromJson(accountsListMap[i]));
      }
      setState(() {
        ownerAccounts = ownerAccounts;
      });
    }
  }

  submit() async {
    if (isTopLoading) {
      showToast(
          "you are clicking too fast please wait your request is in process");
      playStopSound();
      return;
    }
    if(details == null){
      showToast("invalid details must be greater then 10 characters");
      playStopSound();
      return;
    }
    if (details.length < 10) {
      showToast("invalid details must be greater then 10 characters");
      playStopSound();
      return;
    }
    if (_image["base64"] == null) {
      showToast("cannot find slip");
      playStopSound();
      return;
    }
    var request = {
      "user": user.id,
      "image": _image["base64"],
      "detail": details,
      "package": package != null ? package.id : "1",
      'slipNo': slipNo,
      "qty" : 1,
      'amount': amount
    };
    setState(() {
      isTopLoading = true;
    });
    ProgressDialog p = showShortDialog(context);
    var data = await submitDirectDepositRequestService(request);
    p.hide();
    if (data != null) {
      setState(() {
        isTopLoading = false;
        Navigator.of(context).pop();
      });
      showDynamicToast(
          "request has been submitted check the direct deposit report for further update.amount will be added to your wallet you have to repurchase the bid.",
          length: Toast.LENGTH_LONG);
    }
  }

  FirebaseMessaging _firebaseMessaging;

  Future<bool> showActionSheet() async {
    await showAdaptiveActionSheet(
      context: context,
      title: const Text('Trade Now'),
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: Text(
              'Camera',
              style: TextStyle(
                color: darkTheme["redText"],
              ),
            ),
            onPressed: () async {
              // Navigator.of(context).pop();
              await openCamera();
              try {
                // await _initializeControllerFuture;
                print("Done image");
              } catch (e) {
                print("error =>" + e.toString());
              }
            }),
        BottomSheetAction(
            title: Text(
              'Gallery',
              style: TextStyle(
                color: darkTheme["redText"],
              ),
            ),
            onPressed: () {
              // Navigator.of(context).pop();
              openGallery();
              // Navigator.pushNamed(context, "bid_file",
              //     arguments: widget.file.toJson());
              //CancelAction();
            }),
      ],
      cancelAction: CancelAction(
          title: const Text(
              'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
    return true;
  }

  // Future<Map<String, dynamic>> uploadImage(data) async {
  //   try {
  //     var request = data;
  //     // var data;
  //     showToast("uploading image...");
  //     var response = await post(baseUrl + "/upload_user_image",
  //         headers: headers, body: jsonEncode(request));
  //     print(response.body.toString());
  //     if (response.body == null) {
  //       showToast("Cannot get response");
  //       return null;
  //     }
  //     data = jsonDecode(response.body);
  //     if (data["status"] == 0) {
  //       //showToast(data["ResponseHeader"]["ResponseMessage"]);
  //       return null;
  //     }
  //     if (data["status"] == 1) {
  //       updateUserImage(data["res"]);
  //       user.profilePicture = data["res"];
  //       showToast("updated..");
  //     }
  //     // showToast(data["ResponseHeader"]["ResponseMessage"]);
  //   } catch (exp) {
  //     print(exp.toString());
  //     showToast("Unfortunate Error");
  //     return null;
  //   }
  // }

  openCamera() async {
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 20);

    if (image != null) {
      File _file = await cropImage(image);
      if (_file != null) {
        final bytes = _file.readAsBytesSync();
        print(bytes.toString());

        String base = base64Encode(bytes);
        String name = image.path.split("/").last;

        // var request = {"image": base, "user_id": user.id, "file": _file};
        setState(() {
          _image = {"base64": base, "file": _file};
        });
      } else {
        showToast("No image selected");
      }
    } else {
      showToast("No image selected");
    }
  }

  openGallery() async {
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (image != null) {
      File _file = await cropImage(image);
      if (_file != null) {
        final bytes = _file.readAsBytesSync();
        print(bytes.toString());
        String base = base64Encode(bytes);
        String name = image.path.split("/").last;
        setState(() {
          _image = {"base64": base, "file": _file};
        });
      } else {
        showToast("No image selected");
      }
    } else {
      showToast("No image selected");
    }
  }

  Future<File> cropImage(imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile.path,
        // maxWidth: 1080,
        // maxHeight: 500,
        // aspectRatio: CropAspectRatio(ratioX: 2.0, ratioY: 2.0),
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          minimumAspectRatio: 1.0,
        ));
    return croppedFile;
  }

  @override
  void didPopNext() {
    fcmInit();
  }

  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }

  void FCMMesseging(message) {
    getPageData();
    onNotificationReceive(context, data: {"message": message});
  }

  // void FCMMesseging() {
  //   _firebaseMessaging = FirebaseMessaging();
  //   _firebaseMessaging.configure(
  //     onMessage: (Map<String, dynamic> message) async {
  //       // print("onMessage Property Market: $message");
  //       // getPageData();
  //       // if (message["data"]["type"] == "Intransfer") {
  //       //   hammerDialog(context);
  //       // }
  //       onNotificationReceive(context, data: {"message": message});
  //
  //       // _showItemDialog(message);
  //     },
  //     onBackgroundMessage: Platform.isIOS ? null : null,
  //     onLaunch: (Map<String, dynamic> message) async {
  //       // print("onLaunch: $message");
  //       onNotificationReceive(context, data: {"message": message});
  //
  //       // getCPageData();
  //       // _navigateToItemDetail(message);
  //     },
  //     onResume: (Map<String, dynamic> message) async {
  //       print("onResume: $message");
  //       // getCPageData();
  //
  //       // _navigateToItemDetail(message);
  //     },
  //   );
  // }

  @override
  void didChangeDependencies() {
    var data = ModalRoute.of(context).settings.arguments;
    package = data;
    routeObserver.subscribe(this, ModalRoute.of(context));
    fcmInit();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    getPageData();
    // FCMMesseging();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkTheme["primaryBackgroundColor"],
      appBar: AppBar(
        title: Text("Deposit Detail"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(7.0),
          child: isTopLoading ? LinearProgressIndicator() : SizedBox(),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(3, 2, 3, 0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "NOTE: 'SUBMIT YOUR PAYED SLIP DETAILS' \nwe will repond you"
                        " in 24 hours after checking your details please provide other contact details.\nPACKAGE AMOUNT: " +

                    "10000 PKR",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 15),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        height: getHeight(context) * .30,
                        width: getWidth(context),
                        child: TouchableOpacity(
                          // onTap(){},
                          onTap: () {
                            showActionSheet();
                          },
                          child: _image["file"] != null
                              ? Image.file(
                                  _image["file"],
                                  width: getWidth(context),
                                  height: getHeight(context),
                                  fit: BoxFit.cover,
                                )
                              : Image.asset(
                                  "assets/images/placeholder.jpeg",
                                  width: getWidth(context),
                                  height: getHeight(context),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularInputField(
                        hintText: "More Details",
                        onChanged: (val) {
                          details = val;
                        },
                        minLines: 3,
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularInputField(
                        hintText: "Amount",
                        type: TextInputType.number,
                        onChanged: (val) {
                          amount = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularInputField(
                        hintText: "Slip No",
                        onChanged: (val) {
                          slipNo = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: getWidth(context) * .70,
                        child: CustomeElivatedButtonWidget(
                          onPress: () {
                            submit();
                          },
                          name: "Submit",
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Accounts",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w400),
                      ),
                      SizedBox(
                        height: 2,
                      ),
                      for (int i = 0; i < ownerAccounts.length; i++)
                        TouchableOpacity(
                          onTap: () {
                            FlutterClipboard.copy(ownerAccounts[i].accountNo)
                                .then((value) => showToast("copied"));
                          },
                          child: Stack(
                            children: [
                              Container(
                                color: darkTheme["cardBackground"],
                                margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 2,
                                      child: FadeInImage(
                                        placeholder: AssetImage(
                                            "assets/images/app_logo.gif"),
                                        image: NetworkImage(ownerAccounts[i].image),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Padding(
                                          padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                ownerAccounts[i].accountName,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.bold),
                                              ),
                                              Text(
                                                "Account NO:",
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                " " + ownerAccounts[i].accountNo,
                                                style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(right:8.0),
                                                child: Text(
                                                  "${ownerAccounts[i].description}",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontStyle: FontStyle.italic,
                                                      fontSize: 14),
                                                ),
                                              )
                                            ],
                                          ),
                                        ))
                                  ],
                                ),
                              ),
                              Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.copy,color: Colors.white,),
                                  ))
                            ],
                          ),
                        )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

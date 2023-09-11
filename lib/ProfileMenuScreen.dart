import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'package:qkp/main.dart';

import 'Constraint/colors.dart';
import 'Helpers/SessionHelper.dart';
import 'Network/URLS.dart';
import 'Network/network.dart';
import 'Constraint/globals.dart' as global;

class ProfileScreen extends StatefulWidget {
  int chatCount = 0;

  ProfileScreen({this.chatCount});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<MenuItem> menuItems = [];
  User user;

  getPageData() async {
    initMenu();
    user = await getUser();
    setState(() {
      user = user;
    });
  }

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
              openGallery();
            }),
      ],
      cancelAction: CancelAction(
          title: const Text(
              'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
    return true;
  }

  Future<Map<String, dynamic>> uploadImage(data) async {
    try {
      Navigator.pop(context);
      var request = data;
      // var data;
      showToast("uploading image...");
      ProgressDialog progressDialog =
          showProgressDialog(ProgressDialog(context));
      var response = await postRequest(UPLOAD_USER_IMAGE, jsonEncode(request));
      progressDialog.hide();
      if (data["status"] == 0) {
        return null;
      }
      if (data["status"] == 1) {
        updateUserImage(data["res"]);
        user.profilePicture = data["res"];
        showToast("updated..");
      }
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
    } catch (exp) {
      print(exp.toString());
      showToast("Unfortunate Error");
      return null;
    }
  }

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

        var request = {"image": base, "user_id": user.id};
        setState(() {
          isLoading = true;
        });
        var response = await uploadImage(request);
        setState(() {
          isLoading = false;
        });
        if (response != null) {}
        // print("Base 64 Gallary => " + base64);
        // images.add();

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
        var request = {"image": base, "user_id": user.id};
        var response = await uploadImage(request);
        if (response != null) {}
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
      aspectRatio: CropAspectRatio(ratioX: 2.0, ratioY: 1.5),
    );
    return croppedFile;
  }

  @override
  void didChangeDependencies() {
    fcmInit();
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  void FCMMesseging(message) {
    getPageData();
    print("inside main profile");
    onNotificationReceive(context, data: {"message": message});

    // if (message["data"]["type"] == "Intransfer") {
    //   hammerDialog(context);
    // }
  }

  @override
  void initState() {
    getPageData();
    // FCMMesseging();
    // TODO: implement initState
    super.initState();
  }

  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }

  initMenu() {
    menuItems = [
      MenuItem(
          IconWidget: SvgPicture.asset('assets/images/MarketPerformance.svg'),
          name: "Portfolio",
          click: () {
            Navigator.pushNamed(context, 'portfolio');
          }),
      MenuItem(
          IconWidget: Image.asset(
            "assets/images/wallet.png",
            color: darkTheme["secondaryColor"],
          ),
          name: "Wallet",
          click: () {
            Navigator.pushNamed(context, 'wallet');
          }),
      MenuItem(
          IconWidget: SvgPicture.asset('assets/images/MarketPerformance.svg'),
          name: "Market Performers",
          click: () {
            Navigator.pushNamed(context, 'market_performers');
          }),
      MenuItem(
          IconWidget: SvgPicture.asset('assets/images/MarketWatch.svg'),
          name: "Market Watch",
          click: () {
            Navigator.pushNamed(context, 'market_watch');
          }),
      //
      MenuItem(
          IconWidget: SvgPicture.asset('assets/images/AWTReport.svg'),
          name: "Area Wise Trade Report",
          click: () {
            Navigator.pushNamed(context, 'area_wise_trade_report');
          }),
      MenuItem(
          IconWidget: SvgPicture.asset('assets/images/Newsfeed.svg'),
          name: "News Feed",
          click: () {
            Navigator.pushNamed(context, 'news_feed');
          }),
      MenuItem(
          IconWidget: SvgPicture.asset('assets/images/MapReport.svg'),
          name: "Map Report",
          click: () {
            Navigator.pushNamed(context, 'map_report');
          }),
      MenuItem(
          IconWidget: SvgPicture.asset('assets/images/TransactionHistory.svg'),
          name: "Account Statment",
          click: () {
            Navigator.pushNamed(context, 'transaction_history');
          }),
      MenuItem(
          IconWidget: SvgPicture.asset('assets/images/TransactionHistory.svg'),
          name: "Withdraw Report",
          click: () {
            Navigator.pushNamed(context, 'withdraw_report');
          }),
      MenuItem(
          IconWidget: SvgPicture.asset('assets/images/TransactionHistory.svg'),
          name: "Direct Deposit Report",
          click: () {
            Navigator.pushNamed(context, 'direct_deposit_report');
          }),
      //AX
      MenuItem(
          IconWidget: SizedBox(
            width: widget.chatCount > 0?40:20,
            child: Stack(
              children: [
                Icon(
                  Icons.chat_bubble,
                  color: Colors.blue,
                  size: 18,
                ),
                widget.chatCount > 0
                    ? Positioned(
                        left: 10,
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            widget.chatCount.toString(),
                            style: TextStyle(
                                fontSize: 10,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      )
                    : SizedBox(),
              ],
            ),
          ),
          name: "Chat",
          click: () async {
           await Navigator.pushNamed(context, "conversation");
           initMenu();
          }),
      MenuItem(
          IconWidget: Icon(
            FontAwesomeIcons.solidStar,
            color: darkTheme["secondaryColor"],
            size: 18,
          ),
          name: "Rating",
          click: () {
            ratingPopUp(context);
          }),
      MenuItem(
          IconWidget: Icon(
            FontAwesomeIcons.userCircle,
            color: darkTheme["secondaryColor"],
          ),
          name: "User Profile",
          click: () async {
            var d = await Navigator.pushNamed(context, 'user_profile');
            getPageData();
          }),
      MenuItem(
          IconWidget: Icon(
            FontAwesomeIcons.dyalog,
            color: darkTheme["secondaryColor"],
          ),
          name: "Package Log",
          click: () async {
            var d = await Navigator.pushNamed(context, 'package_log');
            getPageData();
          }),
      //
      MenuItem(
          IconWidget: Icon(
            FontAwesomeIcons.envelope,
            color: Colors.blue,
          ),
          name: "Contact Center",
          click: () async {
            Navigator.pushNamed(context, "complain_center");
          }),

      MenuItem(
          IconWidget: Icon(
            Icons.history_toggle_off,
            color: Colors.blue,
            size: 26,
          ),
          name: "Intransfer History",
          click: () async {
            Navigator.pushNamed(context, "intransfer_history");
          }),
      MenuItem(
          IconWidget: Icon(
            Icons.library_books_sharp,
            color: Colors.blue,
            size: 26,
          ),
          name: "How it works?",
          click: () async {
            Navigator.pushNamed(context, "intro");
          }),
      MenuItem(
          IconWidget: SvgPicture.asset('assets/images/logout.svg'),
          name: "Logout",
          click: () async {
            logout();
            Navigator.pushReplacementNamed(context, "login");
            return;
          }),
    ];
    setState(() {
      menuItems = menuItems;
    });
  }

  uploadProfile() {}

  // Context context;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundprofile,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 40,
              ),
              Text(
                "Profile",
                style: TextStyle(color: whitecolor, fontSize: 30),
              ),
              SizedBox(
                height: 50,
              ),
              Container(
                width: 120,
                height: 120,
                child: Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Center(
                      child: Container(
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border:
                                Border.all(width: 2, color: Colors.blueAccent)),
                        height: 120,
                        width: 120,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                // showActionSheet();
                              },
                              child: FadeInImage(
                                fit: BoxFit.cover,
                                image: NetworkImage(user != null
                                    ? url + user.profilePicture
                                    : ""),
                                placeholder:
                                    AssetImage("assets/images/profile.png"),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Positioned(
                    //   top: 11,
                    //   right: 10,
                    //   child: Container(
                    //       // transform: Matrix4.solve(10.0, -10.0, 0.0),
                    //       decoration: BoxDecoration(
                    //         color: whitecolor,
                    //         border:
                    //             Border.all(width: 2, color: profileinfocolor),
                    //         shape: BoxShape.circle,
                    //       ),
                    //       height: 25,
                    //       width: 25,
                    //       child: Center(
                    //           child: Image(
                    //               image:
                    //                   AssetImage("assets/images/pencil.png")))),
                    // )
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                user != null
                    ? user.firstName + " " + user.lastName
                    : "User Name",
                style: TextStyle(color: whitecolor, fontSize: 26),
              ),
              SizedBox(
                height: 50,
              ),
              for (int i = 0; i < menuItems.length; i++)
                Builder(
                  builder: (BuildContext context) {
                    Color color;
                    if (i % 2 == 0) {
                      color = profileinfocolor;
                    } else {
                      color = Colors.transparent;
                    }
                    return Material(
                      color: color,
                      child: InkWell(
                        onTap: menuItems[i].click,
                        child: Container(
                          // color: profileinfocolor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    alignment: Alignment.bottomLeft,
                                    margin: EdgeInsets.all(20.0),
                                    child: Container(
                                      child: menuItems[i].IconWidget,
                                    ),
                                  ),
                                  Text(
                                    menuItems[i].name,
                                    style: TextStyle(color: whitecolor),
                                  ),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(right: 20),
                                child: Image(
                                    alignment: Alignment.bottomRight,
                                    image:
                                        AssetImage("assets/images/next.png")),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class MenuItem {
  Widget IconWidget;
  String name;
  Function click;

  MenuItem({this.IconWidget, this.name, this.click});
}

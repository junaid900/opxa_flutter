import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qkp/FavouritesScreen.dart';
import 'package:qkp/Helpers/PreferanceHelper.dart';
import 'package:qkp/MainMenuListScreen.dart';
import 'package:qkp/MarketScreen.dart';
import 'package:qkp/Network/URLS.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'package:qkp/Network/network.dart';
import 'package:qkp/NoInternetLayout.dart';
import 'package:qkp/NotificationCenterScreen.dart';
import 'package:qkp/ProfileMenuScreen.dart';
import 'package:qkp/Property/MarketPropertyScreen.dart';
import 'package:qkp/WalletScreen.dart';
import 'package:qkp/WizardIntroScreen.dart';
import 'package:url_launcher/url_launcher.dart';

import 'Helpers/SessionHelper.dart';
import 'Model/User.dart';

class BottomTabNavigationWidget extends StatefulWidget {
  @override
  _BottomTabNavigationWidgetState createState() =>
      _BottomTabNavigationWidgetState();
}

class _BottomTabNavigationWidgetState extends State<BottomTabNavigationWidget>
    with TickerProviderStateMixin {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isMenuOpen = false;
  TabController controller;
  bool _initialized = false;
  bool _error = false;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  int unreadNotifications = 0;

  List<Map> Tabs = [
    {"widget": MarketPropertyScreen, "index": 0},
    {"widget": MarketPropertyScreen, "index": 1},
    {"widget": MarketPropertyScreen, "index": 2},
    {"widget": MarketPropertyScreen, "index": 3},
  ];
  int _currentIndex = 0;

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

  checkSession() async {
    if (!await isLogin()) {
      Navigator.pushReplacementNamed(context, "login");
    } else {
      _firebaseMessaging.getToken().then((value) async {
        print("token");
        User user = await getUser();
        var request = <String, dynamic>{
          // "name": fileName,
          "token": value,
          "user_id": user.id
        };
        _firebaseMessaging.subscribeToTopic("all");

        var res = await updateUserFCMToken(request);
        print(value);
      }, onError: (er) {
        print(er);
      });
    }
  }

  createAppDirectory() async {
    var path = await getApplicationDocumentsDirectory();
    print(path);
    bool exists =
        await checkDirectoryPath(path.path + "/" + MAIN_APP_DIRECTAORY);
    print(exists.toString() + "main_app");
    if (!exists) {
      var val = await createDirectory(MAIN_APP_DIRECTAORY);
      await createDirectory(MAIN_APP_DIRECTAORY + "/" + AUDIO_DIRECTORY);
    }
    bool exists2 = await checkDirectoryPath(
        path.path + "/" + MAIN_APP_DIRECTAORY + "/" + AUDIO_DIRECTORY);
    print(exists2.toString() + "audio");
    if (!exists2) {
      await createDirectory(MAIN_APP_DIRECTAORY + "/" + AUDIO_DIRECTORY);
    }
  }

  int chatCount = 0;

  getAppData() async {
    try {
      var user = await getUser();
      var request = {"user_id": user.id, "session_id": user.sessionId};
      var res = await appSettingsService(request);
      if (res != null) {
        var appData = res["response"];
        setState(() {
          if ((convertToNumber(appData["num_of_notifications"]) !=
                  unreadNotifications) &&
              convertToNumber(appData["num_of_notifications"]) != 0) {
            // playBidSound();
            // showDynamicSnakBar(
            //     "A New Notification", "A new notification received.",
            //     snackPosition: SnackPosition.BOTTOM, duration: 2000);
          }
          if ((convertToNumber(appData["chat_count"]) != unreadNotifications) &&
              convertToNumber(appData["chat_count"]) != 0) {
            // playBidSound();
            showDynamicSnakBar(
                "You have unread messages in inbox", "Go to chat and check",
                snackPosition: SnackPosition.BOTTOM, duration: 2000);
          }
          unreadNotifications =
              convertToNumber(appData["num_of_notifications"]);
          chatCount = convertToNumber(appData["chat_count"]);
        });

        // print("------------------------------------------------------");
        // print(unreadNotifications);
      }
    } catch (e) {
      print(e);
      print("cannot get notification number ===============++>");
    }
  }

  checkInternet() async {
    bool isOnline = await hasNetwork();
    print("================.>>" + isOnline.toString());
    if (!isOnline) {
      popAllPreviousAndStart(context, NoInternetWidget());
    }
  }

  void checkAppSettings() async {
    await Future.delayed(Duration(milliseconds: 1000));
    try {
      var appSetting = await getAppSetting();
      print(
          "appSetting ====:::::::::====>" + appSetting["app_version"]["value"]);
      if (appSetting["maintenance"]["value"] == "yes") {
        Navigator.pushReplacementNamed(context, "maintenance");
        return;
      }
      if (appSetting["app_version"]["value"] != APP_VERSION) {
        showDialog(
            context: context,
            child: AlertDialog(
              backgroundColor: darkTheme["primaryBackgroundColor"],
              title: Text(
                "New Update",
                style: TextStyle(color: Colors.white),
              ),
              content: Text(
                "An new update available",
                style: TextStyle(color: Colors.white),
              ),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Later")),
                FlatButton(
                    onPressed: () async {
                      if (Platform.isIOS) {
                        var iosUri = appSetting["ios_app_link"]["value"];
                        if (await canLaunch(iosUri)) {
                          await launch(iosUri);
                          Navigator.pop(context);
                        } else {
                          showToast("cannot open update");
                        }
                      } else if (Platform.isAndroid) {
                        var androidUri =
                            appSetting["android_app_link"]["value"];
                        if (await canLaunch(androidUri)) {
                          await launch(androidUri);
                        } else {
                          showToast("cannot open update");
                        }
                      }
                    },
                    child: Text("Update")),
              ],
            ));
      }
    } catch (e) {
      print(e);
    }
  }

  bool termsAgree = false;

  void showWizard() async {
    print("0000" + await getString(FIRST_TIME));
    var data = await getString("${FIRST_TIME}");
    if (data == null || data == '' || data.length < 1) {
      setString(FIRST_TIME, "OK");
      Get.to(WizardIntroScreenWidget());
    }
  }

  bool initTimer = false;
  Timer timer;

  initializeTimer() {
    if (!initTimer) {
      new Timer.periodic(Duration(milliseconds: 50000), (timer) {
        if (!mounted) timer.cancel();
        getAppData();
      });
      initTimer = true;
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  void initState() {
    getAppData();
    showWizard();
    initializeTimer();
    createAppDirectory();
    initializeFlutterFire();
    checkSession();

    getRequest(REFRESH_MARKET_FIREBASE_DATA);

    controller = TabController(length: 5, vsync: this);
    // TODO: implement initState
    controller.addListener(() {
      // getAppData();
    });
    checkAppSettings();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    checkInternet();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageStorage(
          bucket: PageStorageBucket(),
          child: TabBarView(
            controller: controller,
            children: [
              MarketWidget(),
              MarketPropertyScreen(),
              FavouritesWidget(),
              NotificationCenterWidget(),
              ProfileScreen(chatCount: chatCount),
            ],
          )),
      bottomNavigationBar: Container(
        // height:60,
        child: Material(
          color: darkTheme["tabsColor"],
          child: TabBar(
            controller: controller,
            tabs: [
              Tab(
                icon: new Image.asset("assets/images/fileIcon.png"),
                // text: "Home",
              ),
              Tab(
                icon: new Image.asset("assets/images/propertyhome.png"),

                // text: "Home",
              ),
              Tab(
                icon: new Image.asset("assets/images/watchfile.png"),
                // text: "Home",
              ),
              Tab(
                icon: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    new Image.asset(
                      "assets/images/bell.png",
                      width: 24,
                      height: 24,
                      color: Colors.white,
                    ),
                    unreadNotifications > 0
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 3),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              unreadNotifications.toString(),
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                // text: "Home",
              ),
              Tab(
                icon: Stack(
                  children: [
                    new Image.asset("assets/images/avatar.png"),
                    chatCount > 0
                        ? Container(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            margin: EdgeInsets.fromLTRB(10, 0, 0, 10),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Text(
                              chatCount.toString(),
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          )
                        : SizedBox(),
                  ],
                ),
                // text: "Home",
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

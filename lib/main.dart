// import 'dart:js' ;

import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:qkp/AddFileFormScreen.dart';
import 'package:qkp/AnimatedSideBar.dart';
import 'package:qkp/BidFileScreen.dart';
import 'package:qkp/BottomTabNavigation.dart';
import 'package:qkp/ChatDetailScreen.dart';
import 'package:qkp/CommissionPaymentScreen.dart';
import 'package:qkp/ComplainCenter.dart';
import 'package:qkp/ConversationListScreen.dart';
import 'package:qkp/ConvertBidsToPayment.dart';

// import 'package:qkp/ChartPainterDep.dart';
import 'package:qkp/CustomeDrawer.dart';
import 'package:qkp/DirectDepositReport.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/HomeScreen.dart';
import 'package:qkp/IntrasferHistoryScreen.dart';
import 'package:qkp/MapReportListWidget.dart';
import 'package:qkp/MarketFileChartScreen.dart';
import 'package:qkp/MarketFileDetailsWidget.dart';
import 'package:qkp/Model/PropertyBids.dart';
import 'package:qkp/MyPortfolioScreen.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/NewsFeedListScreen.dart';
import 'package:qkp/OnlineDepositScreen.dart';
import 'package:qkp/PackageLogHistory.dart';
import 'package:qkp/Property/AddPropertyScreen.dart';
import 'package:qkp/Property/PropertyBidScreen.dart';
import 'package:qkp/Property/PropertyFeaturesScreen.dart';
import 'package:qkp/Property/PropertyImagesTypesScreen.dart';
import 'package:qkp/Property/PropertyMoreFeatures.dart';
import 'package:qkp/Property/PropertySearchMap.dart';
import 'package:qkp/PropertyMapReportDetail.dart';
import 'package:qkp/PropertyNewsFeedDetails.dart';
import 'package:qkp/SplashScreen.dart';
import 'package:qkp/UnderMaintenanceScreen.dart';
import 'package:qkp/UserProfile.dart';
import 'package:qkp/WithdrawReport.dart';
import 'package:qkp/WizardIntroScreen.dart';
import 'package:qkp/forgotpassword.dart';
import 'package:qkp/login.dart';
import 'package:qkp/providers/opxa_providers.dart';
import 'package:qkp/resetpassword.dart';
import 'package:qkp/signup.dart';

import 'AccountStatement.dart';
import 'AreaWiseTradeReport.dart';
import 'DirectDepositScreen.dart';
import 'MarketPerformers.dart';
import 'MarketWatchScreen.dart';
import 'Network/network.dart';
import 'NotificationCenterScreen.dart';
import 'Packages.dart';
import 'PaymentScreen.dart';
import 'Property/Filters.dart';
import 'Property/PropertyDetail.dart';
import 'Property/PropertyDetailMapScreen.dart';
import 'Property/PropertyMapScreen.dart';
import 'Property/TradeProperty.dart';
import 'TransactionHistoryScreen.dart';
import 'WalletScreen.dart';
import 'WithdrawScreen.dart';
import 'Constraint/globals.dart' as global;

RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

void main() {
  runApp(MainWidget());
}

void initFirebaseMessageing() {}

class MainWidget extends StatefulWidget {
  @override
  _MainWidgetState createState() => _MainWidgetState();
}

class _MainWidgetState extends State<MainWidget> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;

  void initFirebaseMesseging() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp(
        options: Platform.isIOS
            ? FirebaseOptions(
                appId: '1:159182377535:ios:b048df3b1c9181722d1e8a',
                apiKey: 'AIzaSyCECrf3A_UeqTHmePcsFg-DkUeNJ1kPkfo',
                projectId: 'opxa-50777',
                messagingSenderId: '159182377535',
                databaseURL: 'https://opxa-50777-default-rtdb.firebaseio.com',
                storageBucket: "opxa-50777.appspot.com"
              )
            : FirebaseOptions(
                appId: '1:159182377535:android:20f0ce0cbcfdf1992d1e8a',
                apiKey: 'AIzaSyDwi9YFWPDOwNKWxjl26tJ_erRW8WCBIM4',
                messagingSenderId: '159182377535',
                projectId: 'opxa-50777',
                storageBucket: 'opxa-50777.appspot.com',
                databaseURL: 'https://opxa-50777-default-rtdb.firebaseio.com',
              ),
      );
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _initialized = false;
      });
    }
    // _firebaseMessaging = FirebaseMessaging();
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("On message received=> ${message}");
        try {
          global.onMessageReceiveFunction(message);
        } catch (e) {
          print(e);
        }
      },
      onBackgroundMessage: Platform.isIOS ? null : null,
      onLaunch: (Map<String, dynamic> message) async {},
      onResume: (Map<String, dynamic> message) async {},
    );
  }

  showNotification(title, message) {
    if (title == null) {
      return;
    }
    if (title == '') {
      return;
    }
    if (title.length < 1) {
      return;
    }
    showSnakBar(title, message);
  }

  convertMessage(message) {
    message["data"] = message;
    var notification = {
      "title": message['aps']['title'],
      "body": message['aps']['body'],
      "data": message,
    };

    return notification;
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    print("initialized");
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("=====>MM" + message.toString());
        if (Platform.isIOS) {
          message = convertMessage(message);
        } else {
          message = {
            "title": message['notification']['title'],
            "body": message['notification']['body'],
            "data": message,
          };
        }
        try {
          global.onMessageReceiveFunction(message);
        } catch (e) {
          print(e);
        }
        try {
          showNotification(message['title'], message['body']);
        } catch (e) {
          print(e);
        }
        //  _showItemDialog(message);
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
        print("onMessage: $message");
        print("On message received=> ${message}");
        try {
          global.onMessageReceiveFunction(message);
        } catch (e) {
          print(e);
        }
        //   _navigateToItemDetail(message);
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
        //   _navigateToItemDetail(message);
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(
            sound: true, badge: true, alert: true, provisional: false));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });

    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      setState(() {
        //_homeScreenText = "Push Messaging token: $token";
      });

      _firebaseMessaging.subscribeToTopic("all");
      Function fun = (tkn) async {
        var request = <String, dynamic>{
          "token": tkn,
          "user_id": (await getUser()).id
        };
        var res = await updateUserFCMToken(request);
      };
      if (await isLogin()) {
        fun(token);
      }
      print(token);
      // print(_homeScreenText);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: <SingleChildWidget>[...providers],
        child: GetMaterialApp(
          theme: ThemeData(
              primaryColor: isDarkTheme
                  ? darkTheme["primaryBackgroundColor"]
                  : lightTheme["primaryColor"],
              primarySwatch: Colors.blueGrey,
              fontFamily: "Poppins",
              unselectedWidgetColor: Colors.white),
          navigatorObservers: [routeObserver],
          initialRoute: 'splash_screen',
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (context) => BottomTabNavigationWidget(),
            'splash_screen': (context) => SplashScreenWidget(),
            'add_file': (context) => AddPropertyFormWidget(),
            'login': (context) => Login(),
            'signup': (context) => SignUp(),
            'bid_file': (context) => BidFileScreen(),
            'forget_password': (context) => ForgotPassword(),
            'file_chart': (context) => MarketFileChartWidget(),
            'file_detail': (context) => MarketFileDetailWidget(),
            'packages': (context) => Packages(),
            'wallet_history': (context) => WalletWidget(),
            'transaction_history': (context) => TransactionHistory(),
            'property_detail': (context) => PropertyDetail(),
            'features': (context) => PropertyFeatureWidget(),
            'trade_property': (context) => TradeProperty(),
            'add_property': (context) => AddPropertyScreen(),
            'property_more_feature': (context) => PropertyMoreFeatures(),
            'view_property_bids': (context) => PropertyBidWidget(),
            'portfolio': (context) => MyPortfolioWidget(),
            'map': (context) => MapSample(),
            'filters': (context) => Filters(),
            'property_map': (context) => GoogleMapProperty(),
            'market_watch': (context) => MarketWatchScreen(),
            'market_performers': (context) => MarketPerformers(),
            'news_feed': (context) => NewsFeedListWidget(),
            'news_details': (context) => PropertyNewsFeedDetails(),
            'map_report': (context) => MapReportListWidget(),
            'map_details': (context) => PropertyMapDetailsWidget(),
            'area_wise_trade_report': (context) => AreaWiseTradeReport(),
            'type_images': (context) => PropertyImagesTypeWidget(),
            'property_map_detail': (context) => PropertyDetailMapWidget(),
            'payment_screen': (context) => PaymentScreen(),
            'account_statement': (context) => AccountStatement(),
            'conversation': (context) => ConversationListWidget(),
            'chat_detail': (context) => ChatDetailWidget(),
            'commission_payment': (context) => CommissionPaymentScreen(),
            'user_profile': (context) => UserProfileWidget(),
            'notification_center': (context) => NotificationCenterWidget(),
            'wallet': (context) => WalletWidget(),
            'reset_password': (context) => ResetPasswordScreen(),
            'withdraw': (context) => WithdrawWidgetScreen(),
            'direct_deposit': (context) => DirectDepositScreenWidget(),
            'package_log': (context) => PackageLogHistoryWidget(),
            'intro': (context) => WizardIntroScreenWidget(),
            'complain_center': (context) => ComplainCenterWidget(),
            'convert_bids': (context) => ConvertBidsToPaymentWidget(),
            'intransfer_history': (context) => IntransferHistoryScreen(),
            'withdraw_report': (context) => WithdrawReportWidget(),
            'direct_deposit_report': (context) => DirectDepositReportWidget(),
            'maintenance': (context) => UnderMaintenanceWidget(),
            'online_deposit': (context) => OnlineDepositScreen(),
            // 'conversation': (context) => ConversationListWidget(),
            // 'chat_detail': (context) => ChatDetailWidget(),
          },
        ));
  }
}

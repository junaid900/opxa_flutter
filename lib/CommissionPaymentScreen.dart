import 'dart:convert';

import 'package:encrypt/encrypt.dart' as encrypt;
import 'package:flutter/material.dart';
import 'package:qkp/EmptyLayout.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'dart:io' show Platform;

import 'package:webview_flutter/webview_flutter.dart';
import 'Constraint/globals.dart' as global;

import 'main.dart';

class CommissionPaymentScreen extends StatefulWidget {
  @override
  _CommissionPaymentScreenState createState() =>
      _CommissionPaymentScreenState();
}

class _CommissionPaymentScreenState extends State<CommissionPaymentScreen> with RouteAware {
  User user;
  String paymentUrl = '';
  int user_id = 0;
  bool isLoading = false;
  String data = '';

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
      user_id = int.tryParse(user.id);
    });
  }


  @override
  void didChangeDependencies() {
    // var data = ModalRoute.of(context).settings.arguments;
    var dd = ModalRoute.of(context).settings.arguments;
    Map d = dd;
    Map reqPayload  = Map();
    reqPayload["users_id"] = d["user_id"];
    reqPayload["intransfer_id"] = d["id"];
    reqPayload["amount"] = d["amount"];
    reqPayload["total"] = d["total"];
    reqPayload["tp"] = d["type"];
    String eString = jsonEncode(reqPayload);

    Function func = () async {
      String enData = await encryptString(eString);
      print(enData);
      String decText = await decryptString(enData);
      print(decText);
      setState(() {
        this.data = enData;
      });
    };
    func();
    routeObserver.subscribe(this, ModalRoute.of(context));
    fcmInit();

    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void initState() {
    this.getPageData();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    // TODO: implement initStatec
    super.initState();
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
  @override
  void didUpdateWidget(covariant CommissionPaymentScreen oldWidget) {
    // TODO: implement didUpdateWidget

    super.didUpdateWidget(oldWidget);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("JazzCash")),
      body: user_id > 0
          ? Stack(
              children: [

                WebView(
                  onPageFinished: (d) {
                    setState(() {
                      isLoading = false;
                    });
                    if(d == "https://opxa.com/login" || d=="https://opxa.com/wallet"){
                      // showToast("Thank You");
                      Navigator.of(context).pop();
                    }
                    print(d);
                    print("loaded");
                  },
                  onPageStarted: (link) {
                    print("started");
                    if(link == "https://opxa.com/login" || link=="https://opxa.com/wallet") {
                      Navigator.of(context).pop();
                    }
                    setState(() {
                      isLoading = true;
                    });
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: BaseUrl +
                      'api/commission_checkout?payload='+Uri.encodeQueryComponent(data)+''
                  // "&type=commission",
                ),
                if (isLoading)
                  Center(
                    child: SizedBox(
                      height: 50,
                      width: 50,
                      child: CircularProgressIndicator(
                        // backgroundColor: Colors.black,
                      ),
                    ),
                  ),
              ],
            )
          : EmptyLayoutWidget(
              message: "Invalid request try again",
            ),
    );
  }
}

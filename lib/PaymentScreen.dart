import 'package:flutter/material.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'dart:io' show Platform;

import 'package:webview_flutter/webview_flutter.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';

class PaymentScreen extends StatefulWidget {
  @override
  _PaymentScreenState createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> with RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  User user;
  String paymentUrl = '';
  int user_id = 0;
  bool isLoading = false;

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
      user_id = int.tryParse(user.id);
    });
  }

  @override
  void initState() {
    this.getPageData();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    // TODO: implement initStatec
    super.initState();
  }
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    fcmInit();
    super.didChangeDependencies();
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
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments;
    Map data = arguments;
    // print(BaseUrl+'api/jazz_checkout?users_id='+user.id+'&package_id='+data["id"]+"&qty="+data["qty"].toString());
    return Scaffold(
      appBar: AppBar(title: Text("JazzCash")),
      body: user_id > 0
          ? Stack(
            children: [
              WebView(
                  onPageFinished: (d) {
                    print(d);
                    setState(() {
                      isLoading = false;
                    });
                    if(d == "https://web.opxa.com/login" || d=="https://web.opxa.com/wallet"){
                      Navigator.of(context).pop();
                    }
                  },
                  onPageStarted: (link) {
                    setState(() {
                      isLoading = true;
                    });
                    if(link == "https://web.opxa.com/login" || link=="https://web.opxa.com/wallet"){
                      Navigator.of(context).pop();
                    }
                  },
                  javascriptMode: JavascriptMode.unrestricted,
                  initialUrl: BaseUrl +
                      'api/jazz_checkout?users_id=' +
                      user.id +
                      '&package_id=' +
                      data["id"] +
                      "&qty=" +
                      data["qty"].toString(),
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
          : Container(),
    );
  }
}

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:qkp/Helpers/PreferanceHelper.dart';
import 'package:qkp/Model/TypeImages.dart';
import 'package:qkp/Network/URLS.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';

import 'Helpers/SessionHelper.dart';

class SplashScreenWidget extends StatefulWidget {
  @override
  _SplashScreenWidgetState createState() => _SplashScreenWidgetState();
}

class _SplashScreenWidgetState extends State<SplashScreenWidget> {
  checkSession() async {

    // var request = {"user_id":user.id,"session_id":user.sessionId};
    try {
      var response = await getRequest(GET_APP_SETTING_URL);
      if (response != null) {
        var data = response['response'];
        var setSetting = await setValue(APP_SETTING, jsonEncode(data));
        print("----"+setSetting.toString());
      }
    }catch(e){
      print(e);
      showToast("no internet");
    }
    if (!await isLogin()) {
      Navigator.pushReplacementNamed(context, "login");
    } else {
      Navigator.pushReplacementNamed(context, "/");
    }
  }
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    checkSession();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(46, 64, 105,1),
      body: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Center(
            child: Image.asset("assets/images/splash_logo.gif",width: getWidth(context)*.9,),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("v"+APP_VERSION.toString(),style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Powered By",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w600
                    ),),
                  Image.asset('assets/images/mjcoders2.png',width: getWidth(context)*.30),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qkp/CustomeElivatedButton.dart';
import 'package:qkp/Network/constant.dart';

class NoInternetWidget extends StatefulWidget {
  @override
  _NoInternetWidgetState createState() => _NoInternetWidgetState();
}

class _NoInternetWidgetState extends State<NoInternetWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkTheme["primaryBackgroundColor"],
        width: getWidth(context),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/no_internet.png",
              width: getWidth(context) * .60,
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0,0,10,0),
              child: Text(
                "No Internet please connect with internet and try again",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              width: getWidth(context)*.50,
              child: CustomeElivatedButtonWidget(
                name: "Retry",
                fontSize: 20,
                onPress: () {
                  Navigator.pushNamed(context, "/");
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

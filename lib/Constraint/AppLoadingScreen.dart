import 'package:flutter/material.dart';
import 'package:qkp/Network/constant.dart';

class AppLoadingScreen extends StatefulWidget {
  String message;
  double backgroundOpactity = 1;
  double messageSize;

  AppLoadingScreen(
      {this.message = '', this.messageSize = 16, this.backgroundOpactity = 1});

  @override
  _AppLoadingScreenState createState() => _AppLoadingScreenState();
}

class _AppLoadingScreenState extends State<AppLoadingScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromRGBO(46, 64, 105, widget.backgroundOpactity),
      // width: getWidth(context),
      // height: getHeight(context),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(500),
                  child: Container(
                    color: Color.fromRGBO(46, 64, 105, 1),
                    width: 220,
                    height: 220,
                    padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                    child: Image.asset(
                      "assets/images/app_logo.gif",
                      width: 200,
                      height: 200,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                // Text("data"),
                SizedBox(
                    height: 230,
                    width: 230,
                    child: CircularProgressIndicator(
                      strokeWidth: .3,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )),
              ],
            ),

            Text(
              widget.message,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: widget.messageSize,
                  fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
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


          ],
        ),
      ),
    );
  }
}

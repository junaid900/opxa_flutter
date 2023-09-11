import 'package:flutter/material.dart';

class EmptyLayoutWidget extends StatelessWidget {
  String message;
  Color color;

  EmptyLayoutWidget({this.message,this.color = Colors.white,});

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset(
            "assets/images/empty_box.png",
            height: _height / 4,
            width: _width / 3,
            color: color,
          ),
          Text(
            message,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color
            ),
          )
        ]);
  }
}

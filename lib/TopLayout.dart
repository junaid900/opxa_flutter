import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qkp/Network/constant.dart';

class TopLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    return Container(
      width: _width,
      height: _height / 3,
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [darkTheme["primaryBackgroundColor"],darkTheme["cardBackground"]]),
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(_width / 2),
            bottomRight: Radius.circular(_width)),
      ),
    );
  }
}

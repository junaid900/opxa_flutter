import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:progress_dialog/progress_dialog.dart';

class CommensModel {
  var WIDTH;
  var HEIGHT;
  var RADIUS;
  static var ROUNDED_BORDER_RADIUS = BorderRadius.circular(200);
  static var CURVED_BORDER_RADIUS = BorderRadius.circular(30);
  static var GREY_CONTAINER_BORDER = Border.all(color: Colors.grey, width: 3);
  static var MEDIUM_HEADING_TEXT = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w900,
    color: Colors.black,
  );

  CommensModel(context) {
    WIDTH = MediaQuery.of(context).size.width;
    HEIGHT = MediaQuery.of(context).size.height;
  }

  static void showSnakeBar(String text, context) {
    // final _scaffoldKey = GlobalKey<ScaffoldState>();

    Scaffold.of(context)
        .showSnackBar(SnackBar(content: Text('Processing Data')));
  }



}

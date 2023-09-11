import 'package:flutter/material.dart';

import 'Network/constant.dart';

class HomeWidget extends StatefulWidget {
  final openDrawer;
  final closeDrawer;

  HomeWidget({this.openDrawer, this.closeDrawer});

  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  bool isOpen = false;

  drawer() {
    print(isOpen);
    if (isOpen) {
      setState(() {
        isOpen = !isOpen;
      });
      widget.closeDrawer();
      print("here1");
    } else {
      setState(() {
        isOpen = !isOpen;
      });
      widget.openDrawer();
      print("here");
    }
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
          title: Text("Home"),
          leading: IconButton(
            onPressed: () {
              widget.openDrawer();
              // setState(() {
              //   isOpen = true;
              // });
            },
            icon: Icon(Icons.menu),
          )),
      body: Container(
        height: _height,
        width: _width,
        color: isDarkTheme
            ? darkTheme["primaryBackgroundColor"]
            : lightTheme["primaryBackgroundColor"],
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Dashboard",
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w500,
                  color: isDarkTheme
                      ? darkTheme["primaryTextColor"]
                      : lightTheme["primaryTextColor"]),
            )
          ],
        ),
      ),
    );
  }
}

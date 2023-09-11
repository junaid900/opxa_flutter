import 'package:flutter/material.dart';

import 'Network/constant.dart';

class CustomeElivatedButtonWidget extends StatefulWidget {
  String name;
  final onPress;
  double fontSize;
  bool isDisable = false;
  bool isLoading = false;
  Color color = Color.fromRGBO(36, 154, 255, 1.0);

  CustomeElivatedButtonWidget(
      {this.onPress,
      this.name,
      this.fontSize = 15,
      this.color = const Color.fromRGBO(36, 154, 255, 1.0),
      this.isDisable = false,
      this.isLoading = false});

  @override
  _CustomeElivatedButtonWidgetState createState() =>
      _CustomeElivatedButtonWidgetState();
}

class _CustomeElivatedButtonWidgetState
    extends State<CustomeElivatedButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          widget.onPress();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(widget.color),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18.0),
                side: BorderSide(color: Colors.red),
              ),
              // primary: darkTheme["secondaryColor"],
            )),
        child: Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          // direction: Axis.horizontal,
          children: [
            Text(widget.name, style: TextStyle(fontSize: widget.fontSize)),
            SizedBox(width: 1.3,),
            widget.isLoading
                ? SizedBox(
                height: 10.0,
                width: 10,
                child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                    strokeWidth: 2.0)): SizedBox()

          ],
        ));
  }
}

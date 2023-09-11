import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'CommensModel.dart';
import 'Network/constant.dart';

class MaterialButtonWidget extends StatefulWidget {
  String name;
  final onPressed;
  bool isDisable = false;
  bool isLoading = false;

  MaterialButtonWidget(
      {this.onPressed,
      this.name,
      this.isDisable = false,
      this.isLoading = false});

  @override
  _MaterialButtonWidgetState createState() => _MaterialButtonWidgetState();
}

class _MaterialButtonWidgetState extends State<MaterialButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: !widget.isDisable
            ? widget.onPressed
            : () {
                print("In Button" + widget.isLoading.toString());
                print("In Button" + widget.isDisable.toString());
              },
        style: ButtonStyle(
            backgroundColor:
                MaterialStateColor.resolveWith((states) => Colors.transparent),
            padding:
                MaterialStateProperty.all(EdgeInsets.fromLTRB(0, 0, 0, 0))),
        child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.all(14),
            width: new CommensModel(context).WIDTH,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(color: Colors.white),
                ),
                SizedBox(
                  width: 5,
                ),
                widget.isLoading
                    ? SizedBox(
                        height: 20.0,
                        width: 20,
                        child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.white),
                            strokeWidth: 2.0))
                    : SizedBox(),
              ],
            ),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                boxShadow: [BoxShadow(color: Colors.grey, blurRadius: 10)],
                gradient: LinearGradient(colors: [
                  darkTheme["primaryBackgroundColor"],
                  darkTheme["cardBackground"]
                ]))));
  }
}

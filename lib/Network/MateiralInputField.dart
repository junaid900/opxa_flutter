import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'Constant.dart';

class MaterialInputFieldCustom extends StatefulWidget {
  final OnChange;
  String label;
  Widget icon;
  bool  Obscure;
  String value;
  MaterialInputFieldCustom({this.OnChange, this.label, this.icon, this.Obscure,this.value});

  @override
  _MaterialInputFieldCustomState createState() => _MaterialInputFieldCustomState();
}

class _MaterialInputFieldCustomState extends State<MaterialInputFieldCustom> {

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          padding: const EdgeInsets.only(top: 10),
          child: Material(
            elevation: 2.0,
            shadowColor: darkTheme["primaryBlack"],
            borderRadius: BorderRadius.circular(10.0),
            child: TextFormField(
              onChanged: widget.OnChange,
              initialValue: widget.value,
              obscureText: widget.Obscure,
              style: TextStyle(
              ),
              decoration: InputDecoration(
                contentPadding: new EdgeInsets.symmetric(vertical: 16.0, horizontal: 10.0),
                fillColor: darkTheme["primaryWhite"],
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: darkTheme["primaryColor"],
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(
                    color: darkTheme["primaryColor"],
                    width: 1.0,
                  ),
                ),

              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topLeft,
          child: Container(
            color: darkTheme["primaryWhite"],
            margin: EdgeInsets.fromLTRB(22, 0, 0, 0),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 6.0, vertical: 2.0),
              child: Wrap(
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 2, 0, 0),
                    child: widget.icon
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    widget.label,
                    style: TextStyle(color: darkTheme["primaryColor"]),
                    //style:isFocused ? TextStyle(color: Colors.blue[800]) : null,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

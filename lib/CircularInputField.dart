import 'package:flutter/material.dart';

class CircularInputField extends StatefulWidget {
  Icon rightIcon;
  String label;
  String value;
  String hintText;
  Icon leftIcon;
  Color labelColor;
  Color barColor;
  final onChanged;
  bool readOnly=false;
  TextInputType type = TextInputType.text;
  Color TextColor;
  int maxLines;
  int minLines;

  CircularInputField(
      {this.label,
        this.hintText,
        this.value,
        this.rightIcon,
        this.leftIcon,
        this.barColor,
        this.labelColor,
        this.readOnly=false,
        this.onChanged,
        this.type = TextInputType.text,
        this.TextColor = Colors.black,
        this.maxLines = 1,
        this.minLines = 1,
      });

  @override
  _CircularInputFieldState createState() => _CircularInputFieldState();
}

class _CircularInputFieldState extends State<CircularInputField> {
  @override
  Widget build(BuildContext context) {
    return  TextFormField(
      onChanged: widget.onChanged,
      cursorColor: Theme.of(context).cursorColor,
      initialValue: widget.value,
      showCursor: true,//add this line
      readOnly: widget.readOnly,
      maxLines: widget.maxLines,
      minLines: widget.minLines,
      // maxLength: ,
      keyboardType: widget.type,
      style: TextStyle(color: widget.TextColor),
      decoration: InputDecoration(
        labelText: widget.label,
        labelStyle: TextStyle(
          color: widget.labelColor,
        ),
        filled: true,
        fillColor: Colors.white,
        hintText: widget.hintText,
        contentPadding:
        const EdgeInsets.only(left: 14.0, bottom: 8.0, top: 8.0),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25.7),
        ),
      ),
    );
  }
}

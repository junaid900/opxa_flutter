import 'package:flutter/material.dart';

class MaterialInputField extends StatefulWidget {
  Icon rightIcon;
  String label;
  String value;
  Icon leftIcon;
  Color labelColor;
  Color barColor;
  final onChanged;
  bool readOnly=false;
  TextInputType textInputType = TextInputType.text;
  Color textColor;
  MaterialInputField(
      {
        this.textColor=Colors.black,
        this.label = "",
      this.value = "",
      this.rightIcon,
      this.leftIcon,
      this.barColor,
      this.labelColor,
      this.readOnly=false,
      this.onChanged = null,
        this.textInputType
      });

  @override
  _MaterialInputFieldState createState() => _MaterialInputFieldState();
}

class _MaterialInputFieldState extends State<MaterialInputField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: widget.onChanged,
      cursorColor: Theme.of(context).cursorColor,
      initialValue: widget.value,
      showCursor: true,//add this line
      readOnly: widget.readOnly,
      // maxLength: ,
      keyboardType: widget.textInputType,
      style: TextStyle(
          color: widget.textColor
      ),
      decoration: InputDecoration(
        icon: widget.leftIcon,
        labelText: widget.label,
        labelStyle: TextStyle(
          color: widget.labelColor,
          fontSize: 15,
        ),

        // helperText: 'length',
        suffixIcon: widget.rightIcon,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.blueGrey[400]),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide:BorderSide(color: Colors.grey[600]),
        )
      ),
    );
  }
}

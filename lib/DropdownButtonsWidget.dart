import 'package:flutter/material.dart';

class DropdownButtonsWidget extends StatefulWidget {
  List items;
  final onChanged;
  String value;
  DropdownButtonsWidget({this.onChanged,this.items,this.value});

  @override
  _DropdownButtonsWidgetState createState() => _DropdownButtonsWidgetState();
}

class _DropdownButtonsWidgetState extends State<DropdownButtonsWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Symbol"),
        DropdownButton<String>(
          isExpanded: true,
          value: widget.value,
          icon: Icon(Icons.keyboard),
          items: widget.items.map((val) {
            return new DropdownMenuItem<String>(
              value: val,
              child: new Text(val),
            );
          }).toList(),
          onChanged: widget.onChanged,
        ),
      ],
    );
  }
}

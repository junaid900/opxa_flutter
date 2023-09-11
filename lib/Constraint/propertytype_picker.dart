import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qkp/Network/constant.dart';

class PropertyTypePicker extends StatefulWidget {
  final Function(String) onChange;

  const PropertyTypePicker({Key key, this.onChange}) : super(key: key);

  @override
  _PropertyTypePickerState createState() => _PropertyTypePickerState();
}

class _PropertyTypePickerState extends State<PropertyTypePicker> {
  @override
  void initState(){
    widget.onChange('$currentTimeInHour');
  }
  Widget durationPicker({bool inMinutes = false}) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 0),
      magnification: 1.1,
      backgroundColor: darkTheme['primaryBackgroundColor'],
      onSelectedItemChanged: (x) {
        if (x == 0) {
          currentTimeInHour = 'Residential';
        } else if (x == 1) {
          currentTimeInHour = 'Commercial';
        } else if (x == 2) {
          currentTimeInHour = 'Plot';
        }
        setState(() {});
        widget.onChange('$currentTimeInHour');
      },
      children: [
        // Text('Select Type',
        //     style: TextStyle(color: Colors.white, fontSize: 16)),
        Text('Residential',
            style: TextStyle(color: Colors.white, fontSize: 16)),
        Text('Commerical', style: TextStyle(color: Colors.white, fontSize: 16)),
        Text('Plots', style: TextStyle(color: Colors.white, fontSize: 16))
      ],
      /* List.generate(100 , (index) {
        int amount = index;
       if(index%2 ==1){
         return;
       }
        return Text('$amount M',
            style: TextStyle(color: Colors.white, fontSize: 16));
      }),*/
      itemExtent: 40,
    );
  }
  String currentTimeInHour = 'Residential';
  String currentTimeInMin = '';

  @override
  Widget build(BuildContext context) {
    return DefaultTextStyle(
      style: TextStyle(color: Colors.white),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                    padding: EdgeInsets.only(top: 3.0),
                    child: RichText(
                      text: TextSpan(
                          style: TextStyle(fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              text: 'Selected: ',
                            ),
                            TextSpan(
                                style:
                                    const TextStyle(color: Color(0xffe6e6ea)),
                                text: '$currentTimeInHour'),
                            // TextSpan(text: ' $budgetinLakh Lakhs'),
                          ]),
                    )),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop('close'),
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop('ok'),
                      icon: Icon(
                        Icons.check,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              color: darkTheme['primaryBackgroundColor'],
              width: MediaQuery.of(context).size.width,
              child: Center(
                child: Container(
                    color: darkTheme['primaryBackgroundColor'],
                    width: MediaQuery.of(context).size.width * 0.7,
                    height: MediaQuery.of(context).size.height * 0.27,
                    child: durationPicker()),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

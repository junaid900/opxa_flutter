import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qkp/Network/constant.dart';
import 'package:intl/intl.dart';

class TimePickerWidget extends StatefulWidget {
  final Function(String) onChange;

  const TimePickerWidget({Key key, this.onChange}) : super(key: key);

  @override
  _TimePickerWidgetState createState() => _TimePickerWidgetState();
}

class _TimePickerWidgetState extends State<TimePickerWidget> {
  var formatter = NumberFormat.compact();

  Widget durationPicker({bool inMinutes = false}) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 0),
      magnification: 1.1,
      backgroundColor: darkTheme['primaryBackgroundColor'],
      onSelectedItemChanged: (x) {
        print(x);
        x = 1000000 + (((x) * 100) * 10000);
        if (inMinutes) {
          currentTimeInMin = x.toString();
        } else {
          currentTimeInHour = x.toString();
        }
        setState(() {});
        widget.onChange('$currentTimeInHour  $currentTimeInMin');
      },
      children: List.generate(100, (index) {
        int amount = 1000000 + (((index) * 100) * 10000);
        return Text(formatter.format(amount) + ' PKR',
            style: TextStyle(color: Colors.white, fontSize: 16));
      }),
      itemExtent: 40,
    );
  }

  String currentTimeInHour = '1000000';
  String currentTimeInMin = '1000000';
  @override
  void initState() {
    widget.onChange('$currentTimeInHour  $currentTimeInMin');
    // TODO: implement initState
    super.initState();
  }

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
                                text:
                                    '$currentTimeInHour to  $currentTimeInMin '),
                            // TextSpan(text: ' $budgetinLakh Lakhs'),
                          ]),
                    )),
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop("close"),
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop("ok"),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(child: durationPicker()),
                        Text(
                          'to',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        Expanded(child: durationPicker(inMinutes: true)),
                      ],
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

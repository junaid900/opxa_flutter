import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qkp/Model/PropertyUnit.dart';
import 'package:qkp/Model/Unit.dart';
import 'package:qkp/Network/constant.dart';

class AreaPicker extends StatefulWidget {
  final Function(String) onChange;
  List<PropertyUnit> units = [];

  AreaPicker({Key key, this.onChange,this.units}) : super(key: key);
  @override
  _AreaPickerState createState() => _AreaPickerState();
}

class _AreaPickerState extends State<AreaPicker> {
  Widget durationPicker({bool inMinutes = false}) {
    return CupertinoPicker(
      scrollController: FixedExtentScrollController(initialItem: 0),
      magnification: 1.1,

      backgroundColor: darkTheme['primaryBackgroundColor'],
      onSelectedItemChanged: (x) {
        //if(x%2 ==1){
          if (inMinutes) {
            currentTimeInMin = x.toString();
          } else {
            currentTimeInHour = x.toString();
          }
          setState(() {});
          widget.onChange('$currentTimeInHour  $currentTimeInMin');
       // }

      },
      children: [
         for(var i=0;i<1000;i++)
           if(i%2 ==1)
         Text('$i M',style: TextStyle(color: Colors.white, fontSize: 16))
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

  String currentTimeInHour = '';
  String currentTimeInMin = '';

  @override
  Widget build(BuildContext context) {
    resetValues(){
      setState(() {
        currentTimeInHour = '1';
        currentTimeInMin = '1';
      });

     // Navigator.of(context).pop();
    }
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
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.clear,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
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
                        Text('to', style: TextStyle(color:Colors.white,fontSize: 16),),
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

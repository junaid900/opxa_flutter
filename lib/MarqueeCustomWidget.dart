import 'dart:async';

import 'package:countup/countup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// import 'package:nb_utils/nb_utils.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:qkp/Model/MarketFiles.dart';

import 'Network/constant.dart';

class MarqueeCustomWidget extends StatefulWidget {
  List<MarketFiles> list = [];
  List<MarketFiles> prevList = [];

  MarqueeCustomWidget({this.prevList, this.list});

  @override
  _MarqueeCustomWidgetState createState() => _MarqueeCustomWidgetState();
}

class _MarqueeCustomWidgetState extends State<MarqueeCustomWidget>
    with WidgetsBindingObserver {
  double top = 0;
  double left = 0;
  double right = 0;
  Timer timer;
  int animationDuration = 1000;
  int marketSize = 160;
  int marketEndSize = 60;

  List<MarketFiles> items = [];
  List<MarketFiles> prevItems = [];

  getPageData() {
    setState(() {
      items = widget.list;
      prevItems = widget.prevList;
      left = double.parse(((-1 * (items.length * marketSize))).toString());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    timer.cancel();
  }

  @override
  void deactivate() {
    timer.cancel();
  }

  @override
  void initState() {
    getPageData();

    timer = new Timer.periodic(new Duration(milliseconds: animationDuration),
        (timer) {
//      getFilesData();
      setState(() {
        left += 15;
        animationDuration = 1500;
        if (items.length * marketEndSize < left) {
          animationDuration = 0;
          left = double.parse((-1 * (items.length * marketSize)).toString());
        }
      });
      // print(left);
    });
    // setState(() {
    //   left = double.parse((-1 * (items.length * 80)).toString());
    // });

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
        top: top,
        left: left,
        child: Container(
          // padding: EdgeInsets.all(20),
          width: MediaQuery.of(context).size.width * 1000,
          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: List.generate(items.length, (index) {
              if(items[index] == null){
                return SizedBox();
              }
              return MarketMerueeItemWidget(
                       file: items[index]);

            }),
          ),
        ),
        duration: Duration(milliseconds: animationDuration));
  }
}

class MarketMerueeItemWidget extends StatefulWidget {
  MarketFiles file;
  MarketFiles prevfile;

  MarketMerueeItemWidget({this.file, this.prevfile});

  @override
  _MarketMerueeItemWidgetState createState() => _MarketMerueeItemWidgetState();
}

class _MarketMerueeItemWidgetState extends State<MarketMerueeItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: [
          Text(
            widget.file.symbol,
            style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: darkTheme["secondaryColor"]),
          ),
          SizedBox(
            width: 10,
          ),
          Row(
            children: [
              Stack(
                children: [
                  Text(
                    "${widget.file.latestClosingPrice}",
                    // begin: checkDouble(
                    //     double.tryParse(widget.prevfile.latestClosingPrice)),
                    // end: checkDouble(
                    //     double.tryParse(widget.file.latestClosingPrice)),
                    // duration: Duration(seconds: 3),
                    // separator: ',',
                    style: TextStyle(
                        fontSize: 16,
                        //fontWeight: FontWeight.w700,
                        color: Colors.white
                        // int.tryParse(
                        //     widget.file.latestClosingPrice) >=
                        //     int.tryParse(
                        //         widget.file.lastClosingPrice)
                        //     ?  darkTheme["greenText"]
                        //     : darkTheme["redText"],
                        ),
                  ),
                ],
              ),
              SizedBox(
                width: 8,
              ),
              Icon(
                checkDouble(int.tryParse(widget.file.latestClosingPrice)) >=
                        checkDouble(int.tryParse(widget.file.lastClosingPrice)) || checkDouble(double.parse(widget.file.latestClosingPrice)) == 0
                    ? Icons.arrow_upward
                    : Icons.arrow_downward,
                color: checkDouble(int.tryParse(widget.file.latestClosingPrice)) >=
                        checkDouble(int.tryParse(widget.file.lastClosingPrice)) || checkDouble(double.parse(widget.file.latestClosingPrice)) == 0
                    ? darkTheme["greenText"]
                    : darkTheme["redText"],
                size: 20,
              ),
            ],
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            widget.file.transactionPercentage + " %",
            style: TextStyle(
                fontSize: 16,
                // fontWeight: Font Weight.bold,
                color: Colors.white),
          ),
          SizedBox(
            width: 10,
          ),
          // Divider(thickness: 10,color: Colors.grey,)
        ],
      ),
    );
  }
}

checkDouble(parse) {
  //print('check --- '+parse.toString());
  if(parse == null){
    return 0.0;
  }
  try {
    return parse;
  } catch (e) {
    showToast("Error Occured" + e.toString());
    return 0.0;
  }
}

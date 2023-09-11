import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Model/File.dart';
import 'package:qkp/Network/constant.dart';

import 'Model/MarketFiles.dart';
import 'Network/network.dart';
import 'dart:math' as math;
import 'Constraint/globals.dart' as global;
import 'main.dart';

class MarketFileDetailWidget extends StatefulWidget {
  @override
  _MarketFileDetailWidgetState createState() => _MarketFileDetailWidgetState();
}

class _MarketFileDetailWidgetState extends State<MarketFileDetailWidget> with RouteAware {
  File myFile;
  bool isLoading = false;

  getFileData(file_id) async {
    myFile = new File();
    print('file_id ' + file_id);
    //  var req = {"id",file_id};
    setState(() {
      isLoading = true;
    });
    var data = await getFileDetailsService(file_id);
    setState(() {
      isLoading = false;
    });
    myFile.fromJson(data['Files']);
    setState(() {
      myFile = myFile;
    });
    print(myFile.fileName);
  }
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    fcmInit();
    super.didChangeDependencies();
  }
  @override
  void didPopNext() {
    fcmInit();
  }
  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }
  void FCMMesseging(message) {
    // getPageData();
    onNotificationReceive(context, data: {"message": message});
  }
  @override
  void initState() {
    super.initState();
  }

  int count = 0;

  @override
  Widget build(BuildContext context) {
    count++;
    // TODO: implement initState
    final arguments = ModalRoute.of(context).settings.arguments;
    MarketFiles file = new MarketFiles();
    file.fromJson(arguments);
    if (count == 1) getFileData(file.fileId);

    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 80,
        title: Text(
          myFile.fileName != null ? myFile.fileName : "",
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          if (myFile.societyPercentage != null &&
              myFile.societyPercentage != "0")
            Container(
              // width: 50,
              // height: 20,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 24,
                  ),
                  Transform.rotate(
                    angle: -math.pi / -4,
                    // angle:0,
                    child: Container(
                      width: 80,
                      // height: 20,
                      // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                      ),
                      child: Center(
                        child: Text(
                          'TF-' + myFile.societyPercentage + "%",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: _width,
            height: _height,
            color: darkTheme["primaryBackgroundColor"],
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    myFile.symbol != null ? myFile.symbol : "",
                    style: TextStyle(
                      fontSize: 22,
                      color: darkTheme["primaryTextColor"],
                      fontWeight: FontWeight.bold,
                      // fontFamily: 'Londrina_Solid',
                    ),
                  ),
                  Text(
                    myFile.fileName != null ? myFile.fileName : "",
                    style: TextStyle(
                      fontSize: 14,
                      color: darkTheme["primaryTextColor"],
                      fontWeight: FontWeight.w600,
                      // fontFamily: 'Londrina_Solid',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "City",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          myFile.cityName != null ? myFile.cityName : "",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Unit",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Flexible(
                          child: Text(
                            myFile.area != null
                                ? myFile.area + " " + myFile.unitName
                                : "",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if(myFile.townName != null && myFile.townName != "null" && myFile.townName != '')
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Town",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          myFile.townName != null ? myFile.townName : "",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Society",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            myFile.societyName != null
                                ? myFile.societyName
                                : "",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  if(myFile.sectorName != null && myFile.sectorName != "null")
                    Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Sector",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            myFile.sectorName != null
                                ? myFile.sectorName
                                : "",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // if(myFile.phase != null && myFile.phase != "null")
                  if(myFile.phaseName != null && myFile.phaseName != "null")
                    Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Phase",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            myFile.phaseName,
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "File Type",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            myFile.fileType != null ? myFile.fileSubType : "",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Type Name",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            myFile.typeName != null ? myFile.typeName : "",
                            style: TextStyle(
                              color: darkTextColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Details",
                          style: TextStyle(
                              color: darkTextColor,
                              fontSize: 26,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          myFile.detail != null ? myFile.detail : "",
                          style: TextStyle(
                            color: darkTextColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            AppLoadingScreen(
              backgroundOpactity: .6,
            ),
        ],
      ),
    );
  }
}

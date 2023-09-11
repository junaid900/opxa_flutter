import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:countup/countup.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/CustomeElivatedButton.dart';
import 'package:qkp/Network/constant.dart';
import 'Constraint/Dialog.dart';
import 'EmptyLayout.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/MarketFiles.dart';
import 'Model/Property.dart';
import 'Model/User.dart';
import 'Network/network.dart';
import 'Constraint/globals.dart' as global;

class FavouritesWidget extends StatefulWidget {
  final openDrawer;
  final closeDrawer;

  FavouritesWidget({this.openDrawer, this.closeDrawer});

  @override
  _FavouritesWidgetState createState() => _FavouritesWidgetState();
}

class _FavouritesWidgetState extends State<FavouritesWidget> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<MarketFiles> marketFilesList = new List();
  List<MarketFiles> prMarketFilesList = [];
  Timer timer;
  bool isLoading = true;
  bool firstLoading = true;
  int globalCounter = 0;
  double marqueeHeight = 40;
  User user;
  List<Property> propertyList = [];
  bool fileTab = true;
  bool propertyTab = false;
  Property list;
  bool isTopLoading = false;
  FirebaseMessaging _firebaseMessaging;

  @override
  void initState() {
    startTimer();
    this.getPageData();
    super.initState();
  }

  startTimer() {
    timer = new Timer.periodic(new Duration(seconds: 6), (timer) {
      this.globalCounter++;
      getPageData();
      // this.getFilesData();
      // this.getpropertyData();
    });
  }

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    print('user id: ' + user.id);
    this.getFilesData();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    print("Back To old Screen");
    timer.cancel();
    super.dispose();
  }

  getpropertyData() async {
    var res = await getPropertyWatchList(user.id);
    print(res);
    setState(() {
      isTopLoading = false;
    });
    propertyList.clear();
    if (res != null) {
      if (res["ResponseCode"] == 1) {
        var propertyMapList = res["list"];
        for (int i = 0; i < propertyMapList.length; i++) {
          Property asset = new Property();
          await asset.fromJson(propertyMapList[i]);
          setState(() {
            propertyList.add(asset);
          });
        }
        setState(() {
          propertyList = propertyList;
        });
        print(propertyList);
      } else {
        setState(() {
          //assetsQty = '';
        });
      }
    } else {
      propertyList.clear();
      setState(() {
        propertyList = propertyList;
      });
    }
    print(res.toString());
  }

  //getPropertyWatchList

  getFilesData() async {
    if (globalCounter == 0)
      setState(() {
        isTopLoading = true;
      });

    var res = await getWatchList(user.id);

    //print("res" + res.toString());
    marketFilesList.clear();
    if (res != null) {
      if (res["ResponseCode"] == 1) {
        // print(loginResponse.body);

        if (this.globalCounter > 0) {
          prMarketFilesList.addAll(marketFilesList);
          //print('temp=--'+marketFilesList[0].toJson().toString());
        }

        marketFilesList.clear();

        // print(data["ResponseHeader"]["Files"]);;
        //marketFiles.fromJson(data["ResponseHeader"]["Files"]);
        for (var i = 0; i < res["Files"].length; i++) {
          MarketFiles marketFiles = new MarketFiles();
          marketFiles.fromJson(res["Files"][i]);
          marketFilesList.add(marketFiles);
        }

        setState(() {
          if (this.globalCounter > 0) {
            prMarketFilesList = prMarketFilesList;
            marketFilesList = marketFilesList;
          } else {
            //List temp = marketFilesList;
            prMarketFilesList.addAll(marketFilesList);
            marketFilesList = marketFilesList;
            // print('ya else');
          }

          // marketFilesList = marketFilesList;
        });
      }
      // await setUser(currentUser);
      // Navigator.pushReplacementNamed(this.context, "/main");
      else {
        //showToast("Cannot Proceed Request",Colors.red, Colors.white, Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
      }
    } else {
      marketFilesList.clear();
      setState(() {
        marketFilesList = marketFilesList;
      });
    }
    this.getpropertyData();
  }

  bool isOpen = false;

  drawer() {
    print(isOpen);
    if (isOpen) {
      setState(() {
        isOpen = !isOpen;
      });
      widget.closeDrawer();
      print("here1");
    } else {
      setState(() {
        isOpen = !isOpen;
      });
      widget.openDrawer();
      print("here");
    }
  }

  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }

  @override
  void didChangeDependencies() {
    fcmInit();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void FCMMesseging(message) {
    print("onMessage Property Market: $message");
    getPageData();
    if (message["data"]["type"] == "Intransfer") {
      hammerDialog(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Watch List")),
        // leading: IconButton(
        //   onPressed: () {
        //     widget.openDrawer();
        //     // drawer();
        //     // setState(() {
        //     //   isOpen = true;
        //     // });
        //   },
        //   icon: Icon(Icons.menu),
        // )
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.1),
          child: isTopLoading ? LinearProgressIndicator() : SizedBox(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            width: _width,
            height: _height,
            color: isDarkTheme
                ? darkTheme["primaryBackgroundColor"]
                : lightTheme["primaryBackgroundColor"],
            child: SingleChildScrollView(
              child: Wrap(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: FlatButton(
                          // padding: EdgeInsets.all(30.0),
                          color: fileTab
                              ? darkTheme["cardBackground"]
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              side: BorderSide(
                                  color: fileTab
                                      ? darkTheme["cardBackground"]
                                      : darkTheme["cardBackground"],
                                  width: 1)),
                          child: Text(
                            "File",
                            style: TextStyle(
                                color: fileTab
                                    ? darkTheme["primaryWhite"]
                                    : darkTheme["primaryWhite"]),
                          ),
                          onPressed: () {
                            setState(() {
                              fileTab = true;
                              propertyTab = false;
                            });
                            print('Button pressed');
                          },
                        ),
                      ),
                      SizedBox(
                        width: 12,
                      ),
                      Expanded(
                        child: FlatButton(
                          // padding: EdgeInsets.all(30.0),
                          color: propertyTab
                              ? darkTheme["cardBackground"]
                              : Colors.transparent,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              side: BorderSide(
                                  color: propertyTab
                                      ? darkTheme["cardBackground"]
                                      : darkTheme["cardBackground"],
                                  width: 1)),
                          child: Text(
                            "Property",
                            style: TextStyle(
                                color: propertyTab
                                    ? darkTheme["primaryWhite"]
                                    : darkTheme["primaryWhite"]),
                          ),
                          onPressed: () {
                            setState(() {
                              fileTab = false;
                              propertyTab = true;
                            });
                            print('Button pressed');
                          },
                        ),
                      ),
                    ],
                  ),
                  Visibility(
                    visible: fileTab,
                    child: Column(
                      children: marketFilesList.length > 0
                          ? List.generate(marketFilesList.length, (index) {
                              //print(marketFilesList[index]);
                              return prMarketFilesList.length > 0 &&
                                      marketFilesList[index] != null &&
                                      prMarketFilesList[index] != null
                                  ? WatchListFileItemWidget(
                                      fileFunc: () {
                                        getFilesData();
                                      },
                                      user: user,
                                      file: marketFilesList[index],
                                      preFile: prMarketFilesList[index])
                                  : Container();
                            })
                          : [
                              Center(
                                child: EmptyLayoutWidget(
                                  message: "No data found!",
                                ),
                              )
                            ],
                    ),
                  ),
                  Visibility(
                    visible: propertyTab,
                    child: Column(
                      //   propertyList
                      children: propertyList == null
                          ? [
                              Center(
                                child: EmptyLayoutWidget(
                                  message: "No data found!",
                                ),
                              )
                            ]
                          : propertyList.length > 0
                              ? List.generate(propertyList.length, (index) {
                                  //print(marketFilesList[index]);
                                  return propertyList[index] != null
                                      ? WatchListPropertyItemWidget(
                                          propFunc: () {
                                            getpropertyData();
                                          },
                                          user: user,
                                          property: propertyList[index])
                                      : Container();
                                })
                              : [
                                  Center(
                                    child: EmptyLayoutWidget(
                                      message: "No data found!",
                                    ),
                                  )
                                ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isTopLoading)
            AppLoadingScreen(
              backgroundOpactity: .6,
            ),
        ],
      ),
    );
  }
}

class WatchListPropertyItemWidget extends StatefulWidget {
  Property property;
  Function propFunc;
  User user;

  WatchListPropertyItemWidget({this.property, this.propFunc, this.user});

  @override
  _WatchListPropertyItemWidgetState createState() =>
      _WatchListPropertyItemWidgetState();
}

class _WatchListPropertyItemWidgetState
    extends State<WatchListPropertyItemWidget> {
  bool isLiked;

  @override
  Widget build(BuildContext context) {
    setState(() {
      isLiked = widget.property.isLike;
    });

    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Card(
          color: darkTheme["cardBackground"],
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 12, 10, 0),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: darkTheme["secondaryColor"],
                  style: BorderStyle.solid,
                  width: 7,
                ),
              ),
            ),
            child: Column(
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.property.propertyName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                // SizedBox(width: 10),

                                // SizedBox(width: 8),
                                // Icon(
                                //   Icons.circle,
                                //   color: Colors.grey,
                                //   size: 8,
                                // )
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.shower,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        widget.property.bathRooms != null
                                            ? checkDouble(int.tryParse(widget
                                                        .property.bathRooms)) >
                                                    1
                                                ? widget.property.bathRooms +
                                                    " Baths"
                                                : widget.property.bathRooms +
                                                    " Bath"
                                            : "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      Icon(
                                        FontAwesomeIcons.externalLinkSquareAlt,
                                        color: Colors.white,
                                        size: 15,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        widget.property.unitName != null
                                            ? widget.property.unitName +
                                                " ${widget.property.size}"
                                            : "",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 13,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/Seller.svg",
                                        width: 16,
                                        height: 16,
                                        // color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        widget.property.price + ' PKR',
                                        style: TextStyle(
                                            color: Colors.white,
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        "assets/images/Buyer.svg",
                                        width: 16,
                                        height: 16,
                                        // color: Colors.white,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        widget.property.maxBid + ' PKR ',
                                        style: TextStyle(
                                            color: Colors.white,
                                            // fontWeight: FontWeight.bold,
                                            fontSize: 10),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: InkWell(
                            onTap: () {
                              Navigator.pushNamed(context, 'property_detail',
                                  arguments: widget.property);
                            },
                            child: Image.network(
                              url + widget.property.images[0].image,
                              width: 140,
                              height: 81,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Container(
                        width: getWidth(context) / 2,
                        margin: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        // width: getWidth(context)/2.5,
                        // width: getWidth(context) * .50,
                        child: CustomeElivatedButtonWidget(
                          onPress: () {
                            Navigator.pushNamed(context, 'trade_property',
                                arguments: widget.property);
                          },
                          name: "Bid Now",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 50,
                        width: 50,
                        child: InkWell(
                          onTap: () async {
                            await propWatchList(
                                widget.property.id, widget.user.id, isLiked);
                            widget.propFunc();
                          },
                          child: Icon(
                            FontAwesomeIcons.solidTrashAlt,
                            size: 23,
                            color: isLiked
                                ? Colors.blue
                                : darkTheme['secondaryColor'],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class WatchListFileItemWidget extends StatefulWidget {
  MarketFiles file;
  MarketFiles preFile;
  User user;
  Function fileFunc;

  WatchListFileItemWidget({this.file, this.preFile, this.user, this.fileFunc});

  @override
  _WatchListFileItemWidgetState createState() =>
      _WatchListFileItemWidgetState();
}

class _WatchListFileItemWidgetState extends State<WatchListFileItemWidget> {
  bool isLiked;

  @override
  Widget build(BuildContext context) {
    setState(() {
      isLiked = widget.file.isLiked;
    });
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Card(
          color: darkTheme["cardBackground"],
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(
                  color: darkTheme["secondaryColor"],
                  style: BorderStyle.solid,
                  width: 7,
                ),
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.pushNamed(context, "file_detail",
                            arguments: widget.file.toJson());
                      },
                      child: Text(
                        widget.file.symbol,
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                    ),
                    Row(
                      children: [
                        Icon(
                          checkDouble(int.tryParse(
                                      widget.file.latestClosingPrice)) >=
                                  checkDouble(int.tryParse(
                                      widget.file.lastClosingPrice))
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: checkDouble(int.tryParse(
                                          widget.file.latestClosingPrice)) >=
                                      checkDouble(int.tryParse(
                                          widget.file.lastClosingPrice)) ||
                                  checkDouble(double.parse(
                                          widget.file.latestClosingPrice)) ==
                                      0
                              ? darkTheme["greenText"]
                              : darkTheme["redText"],
                          size: 17,
                        ),
                        Stack(
                          children: [
                            Countup(
                              begin: checkDoubleValue(double.parse(
                                  widget.preFile.latestClosingPrice)),
                              end: checkDoubleValue(
                                  double.parse(widget.file.latestClosingPrice)),
                              duration: Duration(seconds: 3),
                              separator: ',',
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.w700,
                                color: int.tryParse(widget
                                                .file.latestClosingPrice) >=
                                            int.tryParse(
                                                widget.file.lastClosingPrice) ||
                                        double.parse(widget
                                                .file.latestClosingPrice) ==
                                            0
                                    ? darkTheme["greenText"]
                                    : darkTheme["redText"],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.file.fileName,
                      style: TextStyle(fontSize: 10, color: Colors.white),
                    ),
                    Flexible(
                      child: Row(
                        children: [
                          Countup(
                            begin: checkDouble(double.parse(
                                widget.preFile.transactionPoints.toString())),
                            end: checkDouble(
                                double.parse(widget.file.transactionPoints)),
                            duration: Duration(seconds: 3),
                            separator: ',',
                            style: TextStyle(
                                fontSize: 12,
                                color: int.tryParse(
                                            widget.file.transactionPoints) >=
                                        0
                                    ? darkTheme["greenText"]
                                    : darkTheme["redText"]),
                          ),
                          SizedBox(width: 20),
                          Flexible(
                            child: Text(
                              '(' + widget.file.transactionPercentage + '%)',
                              style: TextStyle(
                                  fontSize: 12,
                                  color: double.tryParse(widget
                                              .file.transactionPercentage) !=
                                          null
                                      ? double.tryParse(widget.file
                                                  .transactionPercentage) >=
                                              0
                                          ? darkTheme["greenText"]
                                          : darkTheme["redText"]
                                      : darkTheme["greenText"]),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          color: darkTheme["primaryBackgroundColor"],
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                      'assets/images/Seller.svg',
                                      width: 14,
                                      height: 14,
                                      fit: BoxFit.fill,
                                    ),
                                    SizedBox(
                                      width: 4,
                                    ),
                                    Text(
                                      "Seller",
                                      style: TextStyle(
                                          fontSize: 10, color: Colors.white),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/file.svg',
                                            width: 14,
                                            height: 14,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Countup(
                                            begin: checkDoubleValue(
                                                double.parse(
                                                    widget.preFile.quantity)),
                                            end: checkDoubleValue(double.parse(
                                                widget.file.quantity)),
                                            duration: Duration(seconds: 3),
                                            separator: ',',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: darkTheme[
                                                    'primaryTextColor'],
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Row(
                                        children: [
                                          SvgPicture.asset(
                                            'assets/images/dollar.svg',
                                            width: 14,
                                            height: 14,
                                            fit: BoxFit.fill,
                                          ),
                                          SizedBox(
                                            width: 4,
                                          ),
                                          Flexible(
                                            child: Countup(
                                              begin: checkDoubleValue(
                                                  double.parse(
                                                      widget.preFile.price)),
                                              end: checkDoubleValue(
                                                  double.parse(
                                                      widget.file.price)),
                                              duration: Duration(seconds: 3),
                                              separator: ',',
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: darkTheme[
                                                      'primaryTextColor'],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(6, 0, 0, 0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Container(
                            color: darkTheme["primaryBackgroundColor"],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/images/Buyer.svg',
                                        width: 14,
                                        height: 14,
                                        fit: BoxFit.fill,
                                      ),
                                      SizedBox(
                                        width: 4,
                                      ),
                                      Text(
                                        'Buyer',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: darkTheme['primaryTextColor'],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/file.svg',
                                              width: 14,
                                              height: 14,
                                              fit: BoxFit.fill,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Expanded(
                                              child: Countup(
                                                begin: checkDoubleValue(
                                                    double.parse(widget.preFile
                                                        .highestQuantity)),
                                                end: checkDoubleValue(
                                                    double.parse(widget
                                                        .file.highestQuantity)),
                                                duration: Duration(seconds: 3),
                                                separator: ',',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: darkTheme[
                                                        'primaryTextColor'],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        flex: 2,
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                              'assets/images/dollar.svg',
                                              width: 14,
                                              height: 14,
                                              fit: BoxFit.fill,
                                            ),
                                            SizedBox(
                                              width: 4,
                                            ),
                                            Flexible(
                                              child: Countup(
                                                begin: checkDoubleValue(
                                                    double.parse(widget
                                                        .preFile.highestPrice)),
                                                end: checkDoubleValue(
                                                    double.parse(widget
                                                        .file.highestPrice)),
                                                duration: Duration(seconds: 3),
                                                separator: ',',
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: darkTheme[
                                                        'primaryTextColor'],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: getWidth(context) / 2,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        child: CustomeElivatedButtonWidget(
                          onPress: () {
                            Navigator.pushNamed(context, "bid_file",
                                arguments: widget.file.toJson());
                          },
                          name: "Bid Now",
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: InkWell(
                          onTap: () async {
                            await addWatchList(
                                widget.file.fileId, widget.user.id, isLiked);
                            widget.fileFunc();
                            /* setState(() {
                            isLiked = !isLiked;
                          }); */
                          },
                          child: Icon(
                            FontAwesomeIcons.solidTrashAlt,
                            size: 23,
                            color: isLiked
                                ? Colors.blue
                                : darkTheme['secondaryColor'],
                          ),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> propWatchList(property_id, userId, isLiked) async {
  var request = {"property_id": property_id, "users_id": userId};
  print(request);

  var response = await addPropertyWatchList(request);
  if (response["ResponseCode"] == 1) {
    if (isLiked == false) {
      showToast("Likes added successfully!");
    }
  }
}

Future<bool> addWatchList(file_id, userId, isLiked) async {
  var request = {"file_id": file_id, "users_id": userId};
  print(request);

  var response = await addFileWatchList(request);
  if (response["ResponseCode"] == 1) {
    if (isLiked == false) {
      showToast("Likes added successfully!");
    }
  }
  return true;
}

checkDouble(parse) {
  //print('check --- '+parse.toString());
  if (parse == null) {
    return 0.0;
  }
  try {
    return parse;
  } catch (e) {
    showToast("Error Occured" + e.toString());
    return 0.0;
  }
}

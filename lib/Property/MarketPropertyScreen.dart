import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/Constraint/area_picker.dart';
import 'package:qkp/Constraint/globals.dart';
import 'package:qkp/Constraint/picker_widget.dart';
import 'package:qkp/Constraint/propertytype_picker.dart';
import 'package:qkp/EmptyLayout.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/MaterialInputField.dart';
import 'package:qkp/Model/Property.dart';
import 'package:qkp/Model/PropertyUnit.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';
import 'package:intl/intl.dart';
import 'package:qkp/main.dart';
import 'dart:core';
import '../Constraint/globals.dart' as global;

class MarketPropertyScreen extends StatefulWidget {
  final openDrawer;
  final closeDrawer;

  MarketPropertyScreen({this.openDrawer, this.closeDrawer});

  @override
  _MarketPropertyScreenState createState() => _MarketPropertyScreenState();
}

class _MarketPropertyScreenState extends State<MarketPropertyScreen>
    with WidgetsBindingObserver, RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isOpen = false;
  User user;
  List<Property> propertyList = [];
  List<Property> prePropertyList = [];
  String price = '';
  String area = '';
  String propertyType = '';
  int propertyTypeID;
  String startPrice;
  String endPrice;
  String startArea;
  String endArea;
  bool btnReset = false;
  bool mainReset = false;
  bool isLoading = false;
  bool showError = false;
  List<PropertyUnit> propertyUnits = [];
  Timer timer;
  FirebaseMessaging _firebaseMessaging;
  bool _initialized = false;
  bool _error = false;
  int page = 0;
  var _controller = ScrollController();
  bool isPaginateLoading = false;
  int totalPages = 1;
  bool isTopLoading = false;
  RefreshController _refreshController = RefreshController();
  bool pageLoading = false;

  //double num = widget.list.price;

  int globalCounter = 0;

  ResetFilters() async {
    price = '';
    area = '';
    propertyType = '';
    propertyTypeID = 0;
    startPrice = '';
    endPrice = '';
    startArea = '';
    endArea = '';
    btnReset = false;
    page = 0;
    totalPages = 1;
    mainReset = false;

    var a = await propertyData(from: "filters");
    // _controller.animateTo(_controller.position.minScrollExtent,
    //     duration: Duration(milliseconds: 10), curve: Curves.easeOut);
  }

  // void initializeFlutterFire() async {
  //   try {
  //     // Wait for Firebase to initialize and set `_initialized` state to true
  //     await Firebase.initializeApp();
  //     setState(() {
  //       _initialized = true;
  //     });
  //   } catch (e) {
  //     // Set `_error` state to true if Firebase initialization fails
  //     setState(() {
  //       _error = true;
  //     });
  //   }
  // }

  final formatter = NumberFormat.compact();

  void _showCustomTimePicker() {
    String val;
    showModalBottomSheet(
        backgroundColor: darkTheme['primaryBackgroundColor'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) => TimePickerWidget(
              onChange: (newTime) => price = newTime,
            )).then((value) {
      // print(value);
      val = value;
    }).whenComplete(() {
      print("here");
      if (val == 'ok') {
        var pr = price.split(' ');
        if (pr.length < 1) {
          return;
        }
        setState(() {
          startPrice = pr[0];
          endPrice = pr[2];
        });
        if (price.length > 0) {
          btnReset = true;
          page = 1;
          setState(() {
            isLoading = true;
          });
          getCPageData();
        }
      }
    });
  }

  void FCMMesseging(message) {
    getCPageData();
    onNotificationReceive(context, data: {"message": message});
  }

  void _showCustomAreaPicker() {
    showModalBottomSheet(
        backgroundColor: darkTheme['primaryBackgroundColor'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) => AreaPicker(
              onChange: (areas) => area = areas,
            )).whenComplete(() {
      if (area.length > 0) {
        var ar = area.split(' ');
        startArea = getAreaList(ar[0]);
        endArea = getAreaList(ar[2]);
        setState(() {
          startArea = startArea;
          endArea = endArea;
        });
        if (area.length > 0) {
          btnReset = true;
          page = 1;
          getCPageData();
        }
      }
    });
  }

  void _showCustomPropertyTypePicker() {
    String val;
    showModalBottomSheet(
        backgroundColor: darkTheme['primaryBackgroundColor'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) => PropertyTypePicker(
              onChange: (newTime) => propertyType = newTime,
            )).then((value) => val = value).whenComplete(() {
      if (val == 'ok') {
        if (propertyType == 'Residential') {
          propertyTypeID = 1;
        } else if (propertyType == 'Commercial') {
          propertyTypeID = 2;
        } else if (propertyType == 'Plot') {
          propertyTypeID = 3;
        }
        setState(() {
          propertyTypeID = propertyTypeID;
        });
        if (propertyType.length > 0) {
          btnReset = true;
          page = 1;
          isLoading = true;
          getCPageData();
        }
      }
    });
  }

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    var data = await propertyData();
    await Future.delayed(Duration(milliseconds: 1000));
    // var data2 = await getCPageData();
  }

  getCPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    var data = await getCurrentPageData();
    await Future.delayed(Duration(milliseconds: 1000));
    var data2 = await getCurrentPageData();
  }

  Future<bool> propertyData({from: ""}) async {
    setState(() {
      if (globalCounter == 0) isLoading = true;
    });
    if (globalCounter != 0) {
      prePropertyList.clear();
      prePropertyList.addAll(propertyList);
    }
    setState(() {
      isTopLoading = true;
    });
    var request = {
      "user_id": user.id,
      "type_id": propertyTypeID,
      "start_price": startPrice,
      "end_price": endPrice,
      "start_area": startArea,
      "end_area	": endArea,
      "page": page + 1,
      "user_city": user.city
    };
    print("request======>" + request.toString());
    var res = await getPropertyData(request);
    //print("res" + res.toString());
    setState(() {
      globalCounter++;
      isTopLoading = false;
      isLoading = false;
      prePropertyList = prePropertyList;
    });
    if (res != null) {
      if (res["ResponseCode"] == 1) {
        if (from == "filters") {
          propertyList.clear();
        }
        var propertyMapList = res["list"]["properties"];
        for (int i = 0; i < propertyMapList.length; i++) {
          Property asset = new Property();
          await asset.fromJson(propertyMapList[i]);
          setState(() {
            propertyList.add(asset);
          });
        }
        setState(() {
          propertyList = propertyList;
          showError = false;
          page = int.tryParse(res["list"]["currentPage"].toString());
          totalPages = int.tryParse(res["list"]["totalPages"].toString());
        });
        print(res["list"]["currentPage"].toString() +
            "==========> Current Page" +
            res["list"]["totalPages"].toString());
      } else {
        setState(() {
          //assetsQty = '';
          showError = true;
        });
      }
    } else {
      setState(() {
        showError = true;
      });
    }
    // _refreshController.loadComplete();
    _refreshController.refreshCompleted();

    // _refreshController.
    return true;
  }

  getCurrentPageData() async {
    setState(() {
      if (globalCounter == 0) isLoading = true;
    });
    if (globalCounter != 0) {
      prePropertyList.clear();
      prePropertyList.addAll(propertyList);
    }
    var request = {
      "user_id": user.id,
      "type_id": propertyTypeID,
      "start_price": startPrice,
      "end_price": endPrice,
      "start_area": startArea,
      "end_area	": endArea,
      "current_page": page,
      "user_city": user.city,
      // "page": page
    };
    setState(() {
      isTopLoading = true;
    });

    //print(request.toString());
    var res = await getCurrentPagePropertyData(request);
    //print("res" + res.toString());
    setState(() {
      globalCounter++;
      isLoading = false;
      isTopLoading = false;
      prePropertyList = prePropertyList;
    });
    if (res != null) {
      if (res["ResponseCode"] == 1) {
        propertyList.clear();
        var propertyMapList = res["list"]["properties"];
        for (int i = 0; i < propertyMapList.length; i++) {
          Property asset = new Property();
          await asset.fromJson(propertyMapList[i]);
          setState(() {
            propertyList.add(asset);
          });
        }
        print(res["list"]["currentPage"].toString() +
            "==========> Current Page" +
            res["list"]["totalPages"].toString());

        setState(() {
          propertyList = propertyList;
          showError = false;
          page = int.tryParse(res["list"]["currentPage"].toString());
          totalPages = int.tryParse(res["list"]["totalPages"].toString());
        });
      } else {
        setState(() {
          //assetsQty = '';
          showError = true;
        });
      }
    } else {
      setState(() {
        showError = true;
      });
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
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

  @override
  void didChangeDependencies() {
    getPageData();
    fcmInit();
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  // @override
  // void didChangeAppLifecycleState(AppLifecycleState state) {
  //   if (state == AppLifecycleState.resumed) {
  //     // user returned to our app
  //     print("resumed");
  //   } else if (state == AppLifecycleState.inactive) {
  //     // app is inactive
  //     print("inactive");
  //   } else if (state == AppLifecycleState.paused) {
  //     // user is about quit our app temporally
  //     print("paused");
  //   } else if (state == AppLifecycleState.detached) {
  //     // app suspended (not used in iOS)
  //     print("dispached");
  //   }
  // }

  _onRefresh() async {
    print("=====>refersh");
    setState(() {
      page = 0;
    });
    propertyList.clear();
    getPageData();
  }

  _onLoading() async {
    print("=====++>=========+<" +
        page.toString() +
        " total Pages" +
        totalPages.toString());

    if (mainReset) {
      print("return");
      return;
    }
    print(page.toString() + " total Pages" + totalPages.toString());

    if (page != totalPages) {
      print(page.toString() + " total inside Pages" + totalPages.toString());
      var d = await getPageData();
    }
    // await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: isDarkTheme
          ? darkTheme["primaryBackgroundColor"]
          : lightTheme["primaryBackgroundColor"],
      appBar: AppBar(
        title: TouchableOpacity(
          onTap: () async {
            var arguments = await Navigator.pushNamed(context, 'filters');
            if (arguments != null) {
              print(arguments);
              propertyList.clear();
              btnReset = true;
              setState(() {
                propertyList.addAll(arguments);
              });
            }
          },
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: TextField(
              style: TextStyle(color: Colors.white),
              // onTap: () async {
              //
              // },
              enabled: false,
              decoration: new InputDecoration(
                contentPadding: const EdgeInsets.fromLTRB(25, 12, 22, 12),
                filled: true,
                fillColor: darkTheme["cardBackground"],
                hintText: "Property",
                hintStyle: TextStyle(color: Color.fromRGBO(118, 129, 154, 1.0)),
                prefixIcon: Icon(
                  Icons.search,
                  color: darkTheme["secondaryColor"],
                ),
                enabledBorder: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.transparent)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(30.0)),
                    borderSide: BorderSide(color: Colors.transparent)),
              ),
            ),
          ),
        ),
        iconTheme: IconThemeData(
          color: darkTheme["primaryColor"],
          //change your color here
        ),
        backgroundColor: darkTheme["bgGreyColor"],
        elevation: 0,
        actions: [
          // Image.asset('assets/images/map.png',width: 30,),
          // Padding( padding: EdgeInsets.fromLTRB(2, 22, 10, 0) , child: Text('Map')),
          TouchableOpacity(
            onTap: () async {
              print(propertyList.length);
              List<Property> prList = [];
              prList.addAll(propertyList);
              var filteredList = await Navigator.pushNamed(
                  context, "property_map",
                  arguments: prList);
              // print(filteredList);
              print(filteredList);
              if (filteredList != null) {
                print("here");
                List<Property> data = filteredList;
                if (data.length > 0) {
                  propertyList.clear();
                  propertyList.addAll(data);
                  setState(() {
                    propertyList = propertyList;
                  });
                }
              }
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/map.png',
                  width: 30,
                ),
                Padding(
                    padding: EdgeInsets.fromLTRB(2, 6, 10, 0),
                    child: Text('Map')),
              ],
            ),
          ),
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(7.0),
          child: isTopLoading ? LinearProgressIndicator() : SizedBox(),
        ),
      ),
      body: isLoading
          ? AppLoadingScreen(
              backgroundOpactity: .6,
            )
          : Wrap(children: [
              Container(
                height: 50,
                width: getWidth(context),
                child: ListView(
                  shrinkWrap: false,
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Visibility(
                          visible: btnReset,
                          child: FlatButton(
                            // padding: EdgeInsets.all(30.0),
                            color: darkTheme["primaryBackgroundColor"],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                                side: BorderSide(
                                    color: darkTheme["cardBackground"],
                                    width: 1)),
                            child: Icon(
                              Icons.reset_tv,
                              color: darkTheme["primaryWhite"],
                            ),

                            onPressed: () async {
                              setState(() {
                                isLoading = true;
                              });
                              ResetFilters();
                            },
                          ),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FlatButton(
                          color: darkTheme["cardBackground"],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              side: BorderSide(
                                  color: darkTheme["cardBackground"],
                                  width: 1)),
                          child: Text(
                            "Filters",
                            style: TextStyle(color: darkTheme["primaryWhite"]),
                          ),
                          onPressed: () async {
                            var arguments =
                                await Navigator.pushNamed(context, 'filters');
                            if (arguments != null) {
                              print(arguments);
                              propertyList.clear();
                              btnReset = true;
                              mainReset = true;
                              setState(() {
                                propertyList.addAll(arguments);
                              });
                            }

                            print('Button pressed');
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FlatButton(
                          // padding: EdgeInsets.all(30.0),
                          color: darkTheme["cardBackground"],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              side: BorderSide(
                                  color: darkTheme["cardBackground"],
                                  width: 1)),
                          child: Text(
                            "Property Type",
                            style: TextStyle(color: darkTheme["primaryWhite"]),
                          ),
                          onPressed: () {
                            _showCustomPropertyTypePicker();
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FlatButton(
                          // padding: EdgeInsets.all(30.0),
                          color: darkTheme["cardBackground"],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              side: BorderSide(
                                  color: darkTheme["cardBackground"],
                                  width: 1)),
                          child: Text(
                            "Price",
                            style: TextStyle(color: darkTheme["primaryWhite"]),
                          ),
                          onPressed: () {
                            _showCustomTimePicker();
                          },
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        FlatButton(
                          // padding: EdgeInsets.all(30.0),
                          color: darkTheme["cardBackground"],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(22.0),
                              side: BorderSide(
                                  color: darkTheme["cardBackground"],
                                  width: 1)),
                          child: Text(
                            "Add Property",
                            style: TextStyle(color: darkTheme["primaryWhite"]),
                          ),
                          onPressed: () async {
                            var d = await Navigator.of(context)
                                .pushNamed("add_property");
                            getCPageData();
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              !showError
                  ? Column(
                      children: [
                        Container(
                          height: _height - 200,
                          width: _width,
                          child: SmartRefresher(
                            enablePullDown: true,
                            enablePullUp: true,
                            header: WaterDropMaterialHeader(),
                            footer: CustomFooter(
                              builder: (BuildContext context, LoadStatus mode) {
                                Widget body;
                                print(mode);
                                if (page == totalPages) {
                                  print("here");
                                  body = Text(
                                    "No more Data",
                                    style: TextStyle(color: Colors.white),
                                  );
                                } else if (mode == LoadStatus.loading) {
                                  print("spin page" + page.toString());
                                  body = SizedBox(
                                      height: 30,
                                      width: 30,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 1.4,
                                          valueColor: AlwaysStoppedAnimation(
                                              Colors.white)));
                                } else {
                                  body = Text("Cannot get data");
                                }
                                return Container(
                                  height: 55.0,
                                  child: Center(child: body),
                                );
                              },
                            ),
                            controller: _refreshController,
                            onRefresh: _onRefresh,
                            onLoading: _onLoading,
                            child: ListView.builder(
                              itemCount: propertyList.length,
                              controller: _controller,
                              itemBuilder: (context, index) {
                                return propertyList.length > 0
                                    ? Column(
                                        children: [
                                          PropertyListitem(
                                              list: propertyList[index],
                                              user: user,
                                              prelist: prePropertyList.length ==
                                                      propertyList.length
                                                  ? prePropertyList[index]
                                                  : null,
                                              func: () {
                                                getCPageData();
                                                fcmInit();
                                              }),
                                          // if (index == propertyList.length - 1)
                                          //   isPaginateLoading
                                          //       ? Container(
                                          //           margin: EdgeInsets.fromLTRB(
                                          //               0, 10, 0, 40),
                                          //           height: 30,
                                          //           width: page != totalPages
                                          //               ? 30
                                          //               : getWidth(context),
                                          //           child: page != totalPages
                                          //               ? CircularProgressIndicator()
                                          //               : Center(
                                          //                   child: Text(
                                          //                     "no more data",
                                          //                     style: TextStyle(
                                          //                         color: Colors
                                          //                             .white),
                                          //                   ),
                                          //                 ),
                                          //         )
                                          //       : SizedBox(),
                                        ],
                                      )
                                    : Container();
                              },
                            ),
                          ),
                        ),
                      ],
                    )
                  : Center(
                      child: EmptyLayoutWidget(
                      message: "No Property Found",
                    )),

              // SizedBox(height: 400,),
            ]),
    );
  }
}

class PropertyListitem extends StatefulWidget {
  Property list;
  Property prelist;
  User user;
  Function func;

  PropertyListitem({this.list, this.user, this.prelist, this.func});

  @override
  _PropertyListitemState createState() => _PropertyListitemState();
}

class _PropertyListitemState extends State<PropertyListitem> {
  int _current = 0;
  bool isLiked = false;

  @override
  void initState() {
    setState(() {
      isLiked = widget.list.isLike == null ? widget.list.isLike : false;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.compact(locale: 'en');

    return Padding(
      padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 0),
      child: Card(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        color: darkTheme['cardBackground'],
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(12.0)),
              child: Container(
                alignment: Alignment.center,
                child: Stack(alignment: Alignment.topRight, children: [
                  CarouselSlider(
                    options: CarouselOptions(
                        height: 180.0,
                        viewportFraction: 1,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 10),
                        autoPlayAnimationDuration: Duration(milliseconds: 1000),
                        autoPlayCurve: Curves.fastOutSlowIn,
                        onPageChanged: (index, reason) {
                          setState(() {
                            _current = index;
                          });
                        }),
                    items: widget.list.images.map((image) {
                      return Builder(
                        builder: (BuildContext context) {
                          return Container(
                              width: MediaQuery.of(context).size.width,
                              //margin: EdgeInsets.symmetric(horizontal: 5.0),
                              decoration: BoxDecoration(
                                color: darkTheme["cardBackground"],
                              ),
                              child: TouchableOpacity(
                                onTap: () async {
                                  var d = await Navigator.pushNamed(
                                      context, 'property_detail',
                                      arguments: widget.list);
                                  widget.func();
                                },
                                child: FadeInImage(
                                  // height: 170,
                                  // width: MediaQuery.of(context).size.width,
                                  fit: BoxFit.fill,
                                  placeholder: AssetImage(
                                    'assets/images/placeholder.jpeg',
                                  ),
                                  image: NetworkImage(url + image.image),
                                ),
                              )
                              //  Text(baseUrl +'/'+ image.image, style: TextStyle(fontSize: 16.0),)
                              );
                        },
                      );
                    }).toList(),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 170,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widget.list.images.map((url) {
                          int index = widget.list.images.indexOf(url);
                          return Container(
                            width: 8.0,
                            height: 8.0,
                            margin: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 2.0),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: _current == index
                                  ? Colors.white
                                  : Color.fromRGBO(255, 255, 255, 0.4),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 7, 0, 0),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        shape: CircleBorder(),
                      ),
                      child: Icon(
                        widget.list.typeId == "1"
                            ? FontAwesomeIcons.houseUser
                            : widget.list.typeId == "2"
                                ? FontAwesomeIcons.building
                                : FontAwesomeIcons.tree,
                        size: 18,
                        color:
                            isLiked ? Colors.red : darkTheme['secondaryColor'],
                      ),
                      onPressed: () {
                        addWatchList(widget.list.id, widget.user.id, isLiked);
                        setState(() {
                          isLiked = !isLiked;
                        });
                      },
                    ),
                  ),
                ]),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  /* widget.list.unitName != null
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  widget.list.unitName + " " + widget.list.size,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            )
                          : SizedBox(),
                      widget.list.typeId != 3
                          ? Padding(
                              padding: const EdgeInsets.fromLTRB(2.0, 0, 0, 0),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.single_bed,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 2),
                                  Text(
                                    widget.list.bedRooms != null &&
                                            widget.list.bedRooms != ""
                                        ? int.tryParse(widget.list.bedRooms) > 1
                                            ? '${widget.list.bedRooms} Beds'
                                            : '${widget.list.bedRooms} Bed'
                                        : "",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                  SizedBox(width: 10),
                                  Icon(
                                    Icons.bathtub,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                  SizedBox(width: 3),
                                  Text(
                                    widget.list.bathRooms != null &&
                                            widget.list.bathRooms != ""
                                        ? int.tryParse(widget.list.bathRooms) > 1
                                            ? '${widget.list.bathRooms} Baths'
                                            : '${widget.list.bathRooms} Bath'
                                        : "",
                                    style:
                                        TextStyle(color: Colors.grey, fontSize: 12),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(),
                      */
                  Container(
                    padding: EdgeInsets.fromLTRB(2, 0, 2, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/Seller.svg",
                                    width: 15,
                                    height: 15,
                                    // color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    widget.list.maximumOffer + ' PKR ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      // fontSize: 18
                                    ), //   widget.list.price + ' PKR',
                                    // style: TextStyle(
                                    //     color: Colors.white,
                                    //  ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        AnimatedContainer(
                          duration: Duration(milliseconds: 1000),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                children: [
                                  SvgPicture.asset(
                                    "assets/images/Buyer.svg",
                                    width: 15,
                                    height: 15,
                                    // color: Colors.white,
                                  ),
                                  SizedBox(
                                    width: 6,
                                  ),
                                  Text(
                                    widget.list.maxBid + ' PKR ',
                                    style: TextStyle(
                                      color: Colors.white,
                                      // fontWeight: FontWeight.bold,
                                      // fontSize: 18
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(2.0, 2.0, 2.0, 2.0),
                    child: Flex(
                      direction: Axis.horizontal,
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Wrap(
                            children: [
                              Text(
                                widget.list.propertyName + ' . ',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                              Text(
                                widget.list.societyName != null
                                    ? widget.list.societyName
                                    : "",
                                //widget.list.societyName,
                                style: TextStyle(
                                    color: darkTheme['secondaryColor'],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                              Text(
                                widget.list.unitName != null
                                    ? " (" +
                                        widget.list.size +
                                        " " +
                                        widget.list.unitName +
                                        ")"
                                    : "",
                                //widget.list.societyName,
                                style: TextStyle(
                                    color: darkTheme['secondaryColor'],
                                    fontWeight: FontWeight.w500,
                                    fontSize: 14),
                              ),
                            ],
                          ),
                        ),
                        // SizedBox(width: 10),
                        // Icon(
                        //   FontAwesomeIcons.stroopwafel,
                        //   size: 16,
                        //   color: Colors.white,
                        // ),
                        // SizedBox(width: 4),
                        // Text(
                        //   '2 Rooms',
                        //   style: TextStyle(color: Colors.grey, fontSize: 12),
                        // ),
                        SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                              onPressed: () async {
                                var d = await Navigator.pushNamed(
                                    context, 'trade_property',
                                    arguments: widget.list);
                                widget.func();
                              },
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          darkTheme['secondaryColor']),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                      side: BorderSide(
                                          color: darkTheme["redText"]),
                                    ),
                                    // primary: darkTheme["secondaryColor"],
                                  )),
                              child: Text("Bid Now",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PricePicker extends StatefulWidget {
  @override
  _PricePickerState createState() => _PricePickerState();
}

class _PricePickerState extends State<PricePicker> {
  String price = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(),
    );
  }
}

addWatchList(property_id, userId, isLiked) async {
  var request = {"property_id": property_id, "users_id": userId};
  print(request);

  var response = await addPropertyWatchList(request);
  if (response["ResponseCode"] == 1) {
    if (isLiked == false) {
      showToast("Property added to watchlist successfully!");
    } else {
      showToast("Property removed from watchlist successfully!");
    }
  }
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
  }

  // Or do other work.
}

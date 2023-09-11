import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qkp/BuyOrderTabScreen.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/CustomeDrawer.dart';
import 'package:qkp/IntransferTabScreen.dart';
import 'package:qkp/Model/IntranferFile.dart';
import 'package:qkp/Model/PropertyAsset.dart';
import 'package:qkp/Model/PropertyBuyOrder.dart';
import 'package:qkp/Model/PropertyIntransfer.dart';
import 'package:qkp/MyAssetTabScreen.dart';
import 'package:qkp/Network/network.dart';
import 'package:qkp/SellOrderTabScreen.dart';

import 'BottomTabNavigation.dart';
import 'Constraint/Dialog.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/MyAsset.dart';
import 'Model/User.dart';
import 'Network/constant.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';

class MyPortfolioWidget extends StatefulWidget {
  final openDrawer;
  final closeDrawer;

  MyPortfolioWidget({this.openDrawer, this.closeDrawer});

  @override
  _MyPortfolioWidgetState createState() => _MyPortfolioWidgetState();
}

class _MyPortfolioWidgetState extends State<MyPortfolioWidget>
    with SingleTickerProviderStateMixin, RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isOpen = false;
  int percent = 0;
  List<bool> isSelected = [true, false];
  bool isFABVisible = true;
  bool isTopLoading = false;
  bool isFileLoading = false;
  bool isPALoading = true;
  bool isPSLoading = true;
  bool isPBLoading = true;
  bool isPILoading = true;

  // bool firstLoad = false;

  List<MyAsset> assetList = [];
  List<IntransferFile> intranferList = [];
  List<MyAsset> sellOrderList = [];
  List<MyAsset> buyOrderList = [];
  List<PropertyAsset> propertyAssetList = [];
  List<PropertyAsset> propertySellList = [];
  List<PropertyAsset> propertyBuyList = [];
  List<PropertyIntransfer> propertyIntransferList = [];
  List<PropertyBuyOrder> propertyBuyOrderList = [];
  bool prevApiCall = false;

  // List<PropertyAsset> Int = [];

  User user;
  bool isLoading = false;
  TabController _tabController;
  bool firstTimeLoad = true;
  FirebaseMessaging _firebaseMessaging;

  void FCMMesseging(message) {
    print("onMessage Files Market: $message");
    // if (message["data"]["type"] == "Intransfer") {
    //   hammerDialog(context);
    // }
    onNotificationReceive(context, data: {"message": message});
    getTabsData();
  }

  percentIndicator() {
    setState(() {
      percent += 20;
    });
  }

  getTabsData() async {
    try {
      setState(() {
        isLoading = true;
        isFileLoading = true;
      });
      user = await getUser();
      // data.clear();

      var owner_id = await user.id;
      var request = {"owner_id": owner_id};
      if (prevApiCall) {
        return;
      }
      prevApiCall = true;
      setState(() {
        isTopLoading = true;
      });
      var res = await getMyAssetsService(request);
      //print("my res=>" + res.toString());
      if (res != null) {
        var assetsMapList = res["Tabs"]["Assets"];
        var intrasferMapList = res["Tabs"]["intransfer"];
        var sellOrderMapList = res["Tabs"]["sell"];
        var buyOrderMapList = res["Tabs"]["buy"];
        //print("My Orders" + buyOrderMapList.toString());
        print("when here2");
        assetList.clear();
        intranferList.clear();
        buyOrderList.clear();
        if (firstTimeLoad) showToast(res["ResponseMessage"]);

        for (int i = 0; i < assetsMapList.length; i++) {
          MyAsset asset = new MyAsset();
          asset.fromJson(assetsMapList[i]);
          assetList.add(asset);
        }
        setState(() {
          assetList = assetList;
        });
        for (int j = 0; j < intrasferMapList.length; j++) {
          IntransferFile intransferFile = new IntransferFile();
          intransferFile.fromJson(intrasferMapList[j]);
          intranferList.add(intransferFile);
        }
        sellOrderList.clear();
        for (int i = 0; i < sellOrderMapList.length; i++) {
          MyAsset asset = new MyAsset();
          asset.fromJson(sellOrderMapList[i]);
          sellOrderList.add(asset);
        }
        print(sellOrderList.length.toString());
        // return;

        for (int i = 0; i < buyOrderMapList.length; i++) {
          MyAsset asset = new MyAsset();
          //print("here =>" + buyOrderList.toString());
          asset.fromJson(buyOrderMapList[i]);
          buyOrderList.add(asset);
        }
        setState(() {
          assetList = assetList;
          sellOrderList = sellOrderList;
          buyOrderList = buyOrderList;
          isFileLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isFileLoading = false;
        // isLoading = false;
      });
    }
    getPropertyData();
    percentIndicator();
    return "Ok";
  }

  getPropertyData() async {
    var owner_id = await user.id;
    var request = {"owner_id": owner_id, "status": "Pending"};
    //Property Assets
    try {
      var res = await getPropertyPorfolioService(request);
      var data = res["list"];
      var assetMapList = data["assets"];
      propertyAssetList.clear();
      for (int i = 0; i < assetMapList.length; i++) {
        propertyAssetList.add(PropertyAsset.fromJson(assetMapList[i]));
      }

      setState(() {
        propertyAssetList = propertyAssetList;
      });
    } catch (e) {
      setState(() {
        isPALoading = false;
      });
    }
    percentIndicator();

    //Property Sell
    try {
      var selRequest = {"owner_id": owner_id, "status": "Post"};
      var sellRes = await getPropertyPorfolioService(selRequest);

      if (sellRes == null) {
        return;
      }
      var sellData = sellRes["list"];
      var sellMapList = sellData["assets"];
      propertySellList.clear();
      for (int i = 0; i < sellMapList.length; i++) {
        propertySellList.add(PropertyAsset.fromJson(sellMapList[i]));
      }

      setState(() {
        propertySellList = propertySellList;
        isPSLoading = false;
      });
    } catch (e) {
      setState(() {
        isPSLoading = false;
      });
    }
    percentIndicator();

    // Intransfer

    try {
      var intRequest = {"owner_id": owner_id};
      var intRes = await getPropertyIntransferService(intRequest);
      // var intData = intRes["Files"];
      var intMapList = intRes["Files"];
      propertyIntransferList.clear();
      for (int i = 0; i < intMapList.length; i++) {
        propertyIntransferList.add(PropertyIntransfer.fromJson(intMapList[i]));
      }

      setState(() {
        propertyIntransferList = propertyIntransferList;
      });
    } catch (e) {
      setState(() {});
    }
    percentIndicator();

//
    var owRequest = {"owner_id": owner_id};
    var owRes = await getPropertyBuyIntransfer(owRequest);
    // var intData = intRes["Files"];
    if (owRes != null) {
      var owMapList = owRes["list"];
      propertyBuyOrderList.clear();
      for (int i = 0; i < owMapList.length; i++) {
        propertyBuyOrderList.add(PropertyBuyOrder.fromJson(owMapList[i]));
      }
    }
    percentIndicator();

    setState(() {
      propertyBuyOrderList = propertyBuyOrderList;
    });
    setState(() {
      prevApiCall = false;
      isTopLoading = false;
      isLoading = false;
      firstTimeLoad = false;
      percent = 0;
    });
  }

  @override
  void initState() {
    getTabsData();
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() {
        if (_tabController.index != 0) {
          setState(() {
            isFABVisible = false;
          });
        } else {
          setState(() {
            isFABVisible = true;
          });
        }
        getTabsData();
      });
  }

  @override
  void didPopNext() {
    fcmInit();
  }

  fcmInit() {
    global.onInnerMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }

  moveController(data) {
    if (data == "1") {
      if (_tabController != null) {
        if (firstTimeLoad) {
          _tabController.animateTo(3);
          setState(() {
            isSelected[1] = true;
            isSelected[0] = false;
          });
        }
      }
    } else if (data == "0") {
      if (_tabController != null) {
        if (firstTimeLoad) {
          _tabController.animateTo(3);
          setState(() {
            isSelected[1] = false;
            isSelected[0] = true;
          });
        }
      }
    } else if (data == "2") {
      if (_tabController != null) {
        if (firstTimeLoad) {
          _tabController.animateTo(1);
          setState(() {
            isSelected[1] = true;
            isSelected[0] = false;
          });
        }
      }
    } else if (data == "3") {
      if (_tabController != null) {
        if (firstTimeLoad) {
          _tabController.animateTo(2);
          setState(() {
            isSelected[1] = true;
            isSelected[0] = false;
          });
        }
      }
    }
  }

  @override
  void didChangeDependencies() {
    fcmInit();
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context).settings.arguments;
    moveController(data);
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    int currentTabIndex = 0;
    // var tabController = DefaultTabController(length: 4);
    drawer() {
      //  print(isOpen);
      if (isOpen) {
        setState(() {
          isOpen = !isOpen;
        });
        widget.closeDrawer();
        // print("here1");
      } else {
        setState(() {
          isOpen = !isOpen;
        });
        widget.openDrawer();
        //   print("here");
      }
    }

    return Scaffold(
      // drawer: Drawer(),
      appBar: AppBar(
        actions: [
          Row(
            // direction: Axis.horizontal,
            children: [
              SizedBox(
                width: 4,
              ),
              Container(
                color: darkTheme['primaryColor'],
                child: ToggleButtons(
                  splashColor: darkTheme['primaryColor'],
                  fillColor: darkTheme['secondaryColor'],
                  children: [
                    SvgPicture.asset(
                      "assets/images/file.svg",
                      fit: BoxFit.cover,
                      width: 20,
                    ),
                    SvgPicture.asset(
                      "assets/images/Seller.svg",
                      fit: BoxFit.cover,
                      width: 30,
                    ),
                  ],
                  isSelected: isSelected,
                  onPressed: (int index) {
                    for (int i = 0; i < isSelected.length; i++) {
                      if (index != i) {
                        setState(() {
                          isSelected[i] = false;
                        });
                      } else {
                        setState(() {
                          isSelected[i] = true;
                        });
                      }
                    }
                  },
                ),
              ),
            ],
          )
        ],
        title: Flex(
          direction: Axis.horizontal,
          children: [
            if (isLoading && !firstTimeLoad)
              Expanded(
                flex: 1,
                child: Text(
                  percent.toString() + "%",
                  style: TextStyle(
                      color: Colors.white,
                      // fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            Expanded(
                flex: 4,
                child: Center(
                  child: Text(
                    "My Portfolio",
                    textAlign: TextAlign.start,
                  ),
                )),
          ],
        ),
        // toolbarHeight: MediaQuery.of(context).viewInsets.top,
        // backgroundColor: Colors.blueGrey[900],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Column(
            children: [
              isTopLoading ? LinearProgressIndicator() : SizedBox(),
              TabBar(
                indicatorColor: Colors.cyan,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 4.0, color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal: 30.0),
                ),
                isScrollable: true,
                controller: _tabController,
                tabs: [
                  Tab(
                    text: "My Assets",
                  ),
                  Tab(
                    text: "Sell Orders",
                  ),
                  Tab(text: "Buy Orders"),
                  Tab(text: "In Transfer"),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children: [
          Container(
            height: _height,
            color: darkTheme["primaryBackgroundColor"],
            child: TabBarView(
              controller: _tabController,
              children: [
                MyAssetTabWidget(
                    assets: assetList,
                    stateChanged: () {
                      getTabsData();
                    },
                    isSelected: isSelected,
                    propertyAssetList: propertyAssetList),
                SellOrderTabWidget(
                  sells: sellOrderList,
                  stateChanged: () {
                    getTabsData();
                  },
                  propertySell: propertySellList,
                  isSelected: isSelected,
                ),
                BuyOrderTabWidget(
                  buyOrder: buyOrderList,
                  stateChanged: () {
                    getTabsData();
                  },
                  isSelected: isSelected,
                  propertyBuyOrderList: propertyBuyOrderList,
                ),
                IntransferTabWidget(
                  intransferList: intranferList,
                  stateChanged: () {
                    getTabsData();
                  },
                  propertyIntransferList: propertyIntransferList,
                  isSelected: isSelected,
                ),
              ],
            ),
          ),
          if (isLoading && firstTimeLoad)
            AppLoadingScreen(
              backgroundOpactity: .6,
              message: percent.toString() + " %",
              messageSize: 30.0,
            ),
        ],
      ),
      floatingActionButton: Visibility(
        visible: !isSelected[0],
        child: FloatingActionButton(
          backgroundColor: darkTheme['secondaryColor'],
          onPressed: () async {
            if (isSelected[0]) {
              var args = await Navigator.pushNamed(context, "add_file");
              getTabsData();
            } else {
              var args = await Navigator.pushNamed(context, "add_property");
              getTabsData();
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'package:flutter/widgets.dart';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:countup/countup.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart' as op_get;
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qkp/CircularInputField.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/CustomeElivatedButton.dart';
import 'package:qkp/Helpers/FirebaseHelper.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/MaterialInputField.dart';
import 'package:qkp/Model/FileSymbol.dart';
import 'package:qkp/Model/Symbol.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'package:qkp/main.dart';
import 'MarqueeCustomWidget.dart';
import 'Model/City.dart';
import 'Model/MarketFiles.dart';
import 'Network/network.dart';
import 'Constraint/globals.dart' as global;
import 'login.dart';
import 'dart:math' as math;

class MarketWidget extends StatefulWidget {
  final openDrawer;
  final closeDrawer;

  MarketWidget({this.openDrawer, this.closeDrawer});

  @override
  _MarketWidgetState createState() => _MarketWidgetState();
}

class _MarketWidgetState extends State<MarketWidget>
    with WidgetsBindingObserver, RouteAware {
  List<MarketFiles> marketFilesList = new List();
  List<MarketFiles> prMarketFilesList = [];
  Timer timer;
  bool isLoading = false;
  int globalCounter = 0;
  double marqueeHeight = 40;
  bool isTopLoading = false;
  String strprice = "", endPrice = "", sity = "", symbol = "", fileId = "";
  String fId, cty, enDate = "", stDate = "";
  List<MarketFiles> mFiles = [];
  City selectedCity;
  MarketFiles selectedMarketFiles;
  int totalPages = 0;
  int currentPage = 0;
  RefreshController _refreshController = RefreshController();
  bool isScrollTop = false;

  // bool isLoading;
  // int loadingCount = 0;
  List<City> cities = [];
  FirebaseMessaging _firebaseMessaging;
  bool _initialized = false;
  bool _error = false;
  User user;
  bool requesting;
  var referance;
  var _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    getFilesCurrentData();
    getDropDownData();
    WidgetsBinding.instance.addObserver(this);
    // timer = Timer.periodic(Duration(milliseconds: 50), (timer) {
    //   scrollTop();
    // });
  }

  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }

  List<FileSymbol> symbolList = [];
  FileSymbol selectedSymbol = null;

  getDropDownData() async {
    var res = await fileDropDownService();
    if (res != null) {
      var citiesMap = res["Files"]["cities"];
      var symbolsMap = res["Files"]["symbols"];
      cities.clear();
      for (int i = 0; i < citiesMap.length; i++) {
        City city = new City();
        city.fromJson(citiesMap[i]);
        setState(() {
          cities.add(city);
        });
      }
      symbolList.clear();
      for (int i = 0; i < symbolsMap.length; i++) {
        FileSymbol city = new FileSymbol();
        city.fromJson(symbolsMap[i]);
        symbolList.add(city);
      }
      setState(() {
        symbolList = symbolList;
      });
    }
  }

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    var a = await getFilesData();
    return true;
  }

  getCPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    var data = await getFilesCurrentData();
    await Future.delayed(Duration(milliseconds: 1000));
    var data1 = await getFilesCurrentData();
    return true;
  }

  @override
  void dispose() {
    // timer.cancel();
    if(referance != null)
      referance.cancel();
    super.dispose();
  }

  Future<bool> getFilesCurrentData() async {
    // _scrollController.jumpTo(_scrollController.position.maxScrollExtent);

    prMarketFilesList.clear();
    if (this.globalCounter > 0) {
      prMarketFilesList.addAll(marketFilesList);
    }
    setState(() {
      isTopLoading = true;
    });
    requesting = true;
    print("Current Files");

    var loginResponse = null;
    referance = FirebaseDatabaseHelper.getMarketDataFromFirebase(
        onSuccess: (Event e) async {
      isTopLoading = false;
      print("=======> Market Snapshot");
      print(e.snapshot.value);
      dynamic marketFiles = e.snapshot.value as dynamic;
      List<MarketFiles> markData = [];
      if (marketFiles != null)
        for(int k = 0 ; k < marketFiles.length ; k++){
          if (marketFiles[k] == null) {
            continue;
          }
          if (marketFiles[k] == -1) {
            continue;
          }
          markData.add(MarketFiles.fromJson(marketFiles[k]));
        }
        // marketFiles.forEach((k, v) {
        //   if (k == -1) {
        //     return;
        //   }
        //   markData.add(MarketFiles.fromJson(v));
        // });
      print("refresh market = ============>");
      prMarketFilesList.clear();
      prMarketFilesList.addAll(marketFilesList);
      print(prMarketFilesList.length);
      marketFilesList.clear();
      marketFilesList.addAll(markData);
      setState(() {
        marketFilesList = marketFilesList;
        prMarketFilesList = prMarketFilesList;
      });
      await Future.delayed(Duration(milliseconds: 1000));
      prMarketFilesList.clear();
      prMarketFilesList.addAll(marketFilesList);
      print(prMarketFilesList.length.toString());


      setState(() {
        marketFilesList = marketFilesList;
        prMarketFilesList = prMarketFilesList;
      });
      print(marketFiles);
    }, onError: (o) async {
      requesting = false;
    });

    if (loginResponse == null) {
      return false;
    }
    setState(() {
      isLoading = false;
      isTopLoading = false;
      globalCounter++;
    });

    return true;

  }
scrollTop() async {
    if(isScrollTop){
      return;
    }

    // await Future.delayed(Duration(milliseconds: 100));
    print("------> go top");
  try {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: Duration(milliseconds: 10),
      curve: Curves.fastOutSlowIn,
    );
    setState(() {
      isScrollTop = true;
      isLoading = true;
    });
  }catch(e){
    print(e);
  }
    // await Future.delayed(Duration(milliseconds: 100));
    setState(() {
    _scrollController = _scrollController;
    isLoading = false;
  });
}
  Future<bool> getFilesData() async {
    return false;
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
      HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
      'ApiKey': await getApiToken()
    };
    // print(headers);
    prMarketFilesList.clear();
    if (this.globalCounter > 0) {
      prMarketFilesList.addAll(marketFilesList);
    }
    if (isTopLoading) {
      await Future.delayed(Duration(milliseconds: 1000));
      if (isTopLoading) {
        getFilesData();
      }
    }
    setState(() {
      isTopLoading = true;
    });
    requesting = true;
    var loginResponse = await getRequest("/get_all_files?user_id=" +
        user.id +
        "&city=" +
        sity +
        "&file_id=" +
        fileId +
        "&st_price=" +
        strprice +
        "&en_price=" +
        endPrice +
        "&user_city=" +
        user.city +
        "&page=${currentPage + 1}");
    requesting = false;

    if (loginResponse == null) {
      return false;
    }
    setState(() {
      isLoading = false;
      isTopLoading = false;
      globalCounter++;
    });

    if (loginResponse != null) {
      print(loginResponse);
      var data = loginResponse;
      var responseCode = data["ResponseCode"];
      if (responseCode == 1) {
        // marketFilesList.clear();
        for (var i = 0; i < data["filesData"]["files"].length; i++) {
          MarketFiles marketFiles = new MarketFiles();
          marketFiles.fromJson(data["filesData"]["files"][i]);
          marketFilesList.add(marketFiles);
        }

        if (this.globalCounter < 2) {
          // marketFilesList
          mFiles.clear();
          mFiles.addAll(marketFilesList);
          setState(() {
            mFiles = mFiles;
          });
        }

        setState(() {
          _refreshController.loadComplete();
          currentPage = convertToNumber(data["filesData"]["currentPage"]);
          totalPages = convertToNumber(data["filesData"]["totalPages"]);
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
    } else {}
    return true;
  }

  void FCMMesseging(message) {
    print("onMessage Files Market: $message");
    onNotificationReceive(context, data: {"message": message});
  }

  bool isOpen = false;

  drawer() {
    print(isOpen);
    if (isOpen) {
      setState(() {
        isOpen = !isOpen;
      });
      widget.closeDrawer();
    } else {
      setState(() {
        isOpen = !isOpen;
      });
      widget.openDrawer();
    }
  }

  _onRefresh() async {
    print("=====>refersh");
    setState(() {
      currentPage = 0;
    });
    marketFilesList.clear();
    await getPageData();
    _refreshController.refreshCompleted();
  }

  bool isPageLoading = false;

  _onLoading() async {
    print(currentPage.toString() + " total Pages" + totalPages.toString());
    setState(() {
      isPageLoading = true;
    });
    if (currentPage < totalPages) {
      print(currentPage.toString() +
          " total inside Pages" +
          totalPages.toString());
      var d = await getPageData();
      print("loading Complete");
    }
    setState(() {
      isPageLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Market")),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(7.0),
          child: isTopLoading ? LinearProgressIndicator() : SizedBox(),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.filter_alt),
              onPressed: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  context: context,
                  // barrierColor: Colors.red,
                  // bounc : true,
                  builder: (context) =>
                      StatefulBuilder(builder: (context, setState) {
                    return Padding(
                      padding: MediaQuery.of(context).viewInsets,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(15),
                                topLeft: Radius.circular(15)),
                            color: darkTheme["primaryBackgroundColor"]),
                        height: _height,
                        width: _width,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              SizedBox(height: 5),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(),
                                  SizedBox(),
                                  SizedBox(),
                                  SizedBox(
                                    height: 60,
                                    width: 150,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(2, 16, 0, 0),
                                      child: Text(
                                        "Market Filters",
                                        style: TextStyle(
                                          color: darkTheme["secondaryColor"],
                                          fontSize: 20,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(),
                                  Material(
                                    color: Colors.transparent,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close),
                                        color: Colors.white),
                                  )
                                ],
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("File",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                height: 50,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(60.0),
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60.0),
                                  child: DropdownSearch<FileSymbol>(
                                    mode: Mode.DIALOG,
                                    items: symbolList,
                                    selectedItem: selectedSymbol,

                                    // popupBackgroundColor: Colors.grey,
                                    label: "Select File",
                                    onChanged: (_) {
                                      fId = _.fileId;
                                      // print("=>"+_.id);
                                      setState(() {
                                        // selectedMarketFiles = _;
                                      });
                                      // filterTowns(_);
                                    },

                                    // selectedItem: selectedCity,
                                    showSearchBox: true,
                                    searchBoxDecoration: InputDecoration(
                                      // border: OutlineInputBorder(),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(12, 12, 8, 0),
                                      fillColor: Colors.red,
                                      hoverColor: Colors.red,
                                      focusColor: Colors.red,
                                      labelText: "Search a File",
                                    ),
                                    popupTitle: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color:
                                            darkTheme["primaryBackgroundColor"],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'File',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    popupShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text("City",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600)),
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                                height: 50,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(60.0),
                                  color: Colors.white,
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(60.0),
                                  child: DropdownSearch<City>(
                                    mode: Mode.DIALOG,
                                    items: cities,
                                    selectedItem: selectedCity,
                                    // popupBackgroundColor: Colors.grey,
                                    label: "Select City",
                                    onChanged: (_) {
                                      // fId = _.fileId;
                                      setState(() {
                                        cty = _.id;
                                      });
                                      // print("=>"+_.id);
                                      setState(() {
                                        selectedCity = _;
                                      });
                                      // filterTowns(_);
                                    },

                                    // selectedItem: selectedCity,
                                    showSearchBox: true,
                                    searchBoxDecoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding:
                                          EdgeInsets.fromLTRB(12, 12, 8, 0),
                                      fillColor: Colors.red,
                                      hoverColor: Colors.red,
                                      focusColor: Colors.red,
                                      labelText: "Search a City",
                                    ),
                                    popupTitle: Container(
                                      height: 50,
                                      decoration: BoxDecoration(
                                        color:
                                            darkTheme["primaryBackgroundColor"],
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                        ),
                                      ),
                                      child: Center(
                                        child: Text(
                                          'City',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                    popupShape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(24),
                                        topRight: Radius.circular(24),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Text("Start Price",
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600)),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                      child: Text("End Price",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 5,
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: CircularInputField(
                                        onChanged: (val) {
                                          stDate = val;
                                        },
                                        hintText: "Start Price",
                                        value: "",
                                        type: TextInputType.number),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                                      child: CircularInputField(
                                          onChanged: (val) {
                                            enDate = val;
                                          },
                                          hintText: "End Price",
                                          type: TextInputType.number),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 18,
                              ),
                              CustomeElivatedButtonWidget(
                                  onPress: () async {
                                    // print(" fileId" + fId);
                                    sity = cty != null ? cty : "";
                                    fileId = fId != null ? fId : "";
                                    strprice = stDate.length > 0 ? stDate : "";
                                    endPrice = enDate.length > 0 ? enDate : "";
                                    ProgressDialog progressDialog =
                                        new ProgressDialog(context);
                                    // progressDialog.update(
                                    //     message: "Filtering Files");
                                    // progressDialog.show();
                                    // currentPage = 1;
                                    // await getFilesCurrentData();
                                    // progressDialog.hide();
                                    Navigator.of(context).pop();
                                  },
                                  name: "Apply Now")
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ).then((value) => print(value.toString()));
              }),
          IconButton(
            icon: Icon(Icons.refresh),
            color: Colors.white,
            onPressed: () {
              setState(() {
                cty = null;
                fId = null;
                stDate = "";
                enDate = "";
                sity = "";
                fileId = "";
                strprice = "";
                endPrice = "";
                // marketFilesList.clear();
                // prMarketFilesList.clear();
                selectedMarketFiles = null;
                selectedCity = null;
                currentPage = 0;
                totalPages = 0;
              });

              getFilesData();
            },
          )
        ],
      ),
      body: Stack(
        children: [
          Container(
            width: _width,
            height: _height,
            color: isDarkTheme
                ? darkTheme["primaryBackgroundColor"]
                : lightTheme["primaryBackgroundColor"],
            child: Wrap(
                    children: [
                      Container(
                        height: marqueeHeight,
                        //padding: EdgeInsets.fromLTRB(6, 10, 6, 10),
                        margin: EdgeInsets.fromLTRB(15, 10, 15, 6),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(6),
                            color: darkTheme["cardBackground"]),
                        // padding: EdgeInsets.all(8),

                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                                child: marketFilesList.length > 0
                                    ? MarqueeCustomWidget(
                                        prevList: prMarketFilesList.length > 0? prMarketFilesList:marketFilesList,
                                        list: marketFilesList)
                                    : SizedBox()),
                          ],
                        ),
                      ),
                      Container(
                        // margin: EdgeInsets.fromLTRB(0, 6, 0, 6),

                        // color: Colors.red,
                        // height: _height - 80,
                        width: _width,
                        height: _height - (marqueeHeight + _height / 5),
                        child: FirebaseAnimatedList(
                          scrollDirection: Axis.vertical,
                          // reverse: true,
                          // controller: _scrollController,

                          query: FirebaseDatabaseHelper.database
                              .reference()
                              .child("Market")
                              .orderByChild(' '),

                           sort: (a, b) => FirebaseDatabaseHelper.mySortComparison(a, b),
                          itemBuilder: (BuildContext context, DataSnapshot snapshot,
                              Animation<double> animation, int index) {
                            // if(snapshot == null){
                            //   scrollTop();
                            // }
                            MarketFiles mrFiles =
                                MarketFiles.fromJson(snapshot.value);
                            if (mrFiles.fileId == "-1") {
                              return SizedBox();
                            }
                            if(fId != null){
                              if(mrFiles.fileId != fId){
                                return SizedBox();
                              }
                            }
                            if(cty != null){
                              if(mrFiles.cityId != cty){
                                return SizedBox();
                              }
                            }
                            // enDate
                            // stDate
                            if(stDate != null && convertToDouble(stDate) != 0){
                              if(convertToDouble(stDate) > convertToDouble(mrFiles.latestClosingPrice)){
                                return SizedBox();
                              }
                            }
                            if(enDate != null && convertToDouble(stDate) != 0){
                              if(convertToDouble(enDate) < convertToDouble(mrFiles.latestClosingPrice)){
                                return SizedBox();
                              }
                            }



                            return Column(
                              children: [
                                MarketItem(
                                    user: user,
                                    file: mrFiles,
                                    preFile: prMarketFilesList.length>0
                                        ? prMarketFilesList
                                            .where((element) =>
                                                element.fileId == mrFiles.fileId)
                                            .first
                                        : mrFiles,
                                    refreshFunctions: () {
                                      // FCMMesseging();
                                    }),
                                if (index == marketFilesList.length - 1 &&
                                    totalPages > 1)
                                  Container(
                                      height: 30,
                                      width: getWidth(context),
                                      margin: EdgeInsets.fromLTRB(10, 4, 10, 20),
                                      // color: Colors.white,
                                      child: Center(
                                        child: !isPageLoading
                                            ? currentPage < totalPages
                                                ? TouchableOpacity(
                                                    onTap: () {
                                                      _onLoading();
                                                    },
                                                    child: Text(
                                                      "Tap To Load More",
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : Text(
                                                    "No More Data",
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  )
                                            : SizedBox(
                                                width: 30,
                                                height: 30,
                                                child: CircularProgressIndicator(
                                                  valueColor:
                                                      AlwaysStoppedAnimation(
                                                          Colors.white),
                                                  strokeWidth: 1,
                                                ),
                                              ),
                                      ))
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
          ),
          if(isLoading)
          AppLoadingScreen(),
        ],
      ),
    );
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  void didPopNext() {
    print("router poped");
    fcmInit();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        // --
        print('Resumed');
        break;
      case AppLifecycleState.inactive:
        // --
        print('Inactive');
        break;
      case AppLifecycleState.paused:
        // --
        print('Paused');
        break;
      case AppLifecycleState.detached:
        // --
        print('Detached');
        break;
    }
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    fcmInit();
    super.didChangeDependencies();
  }
}

class MarketItem extends StatefulWidget {
  MarketFiles file;
  MarketFiles preFile;
  User user;
  final refreshFunctions;

  MarketItem({this.file, this.preFile, this.user, this.refreshFunctions});

  @override
  _MarketItemState createState() => _MarketItemState();
}

class _MarketItemState extends State<MarketItem> {
  double _opacity = 0;
  bool isLiked;

  void initState() {
    setState(() {
      isLiked = widget.file.isLiked;
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    void changeOpacity() async {
      setState(() {
        _opacity = 1;
      });
      await Duration(milliseconds: 400);
      setState(() {
        _opacity = 0;
      });
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(10, 2, 10, 2),
            child: Card(
              color: darkTheme["cardBackground"],
              child: ClipPath(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: darkTheme["secondaryColor"], width: 8))),
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      //Check if symbol or price is exceeding screen Limit
                      widget.file.symbol.length < 12 ||
                              widget.file.latestClosingPrice.length < 10
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              // direction: Axis.horizontal,
                              // crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Expanded(
                                  child: Text(
                                    widget.file.symbol,
                                    style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.w700,
                                      color: darkTheme["primaryTextColor"],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      checkDouble(int.tryParse(widget.file
                                                      .latestClosingPrice)) >=
                                                  checkDouble(int.tryParse(
                                                      widget.file
                                                          .lastClosingPrice)) ||
                                              checkDouble(int.tryParse(widget
                                                      .file
                                                      .latestClosingPrice)) ==
                                                  0
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color: checkDouble(int.tryParse(widget
                                                      .file
                                                      .latestClosingPrice)) >=
                                                  checkDouble(int.tryParse(
                                                      widget.file
                                                          .lastClosingPrice)) ||
                                              checkDouble(int.tryParse(widget
                                                      .file
                                                      .latestClosingPrice)) ==
                                                  0
                                          ? darkTheme["greenText"]
                                          : darkTheme["redText"],
                                      size: 20,
                                    ),
                                    Stack(
                                      children: [
                                        Countup(
                                          begin: widget.preFile != null
                                              ? checkDouble(double.tryParse(
                                                  widget.preFile
                                                      .latestClosingPrice))
                                              : checkDouble(double.tryParse(
                                                  widget.file
                                                      .latestClosingPrice)),
                                          end: checkDouble(double.tryParse(
                                              widget.file.latestClosingPrice)),
                                          duration: Duration(seconds: 3),
                                          separator: ',',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                            color: checkDouble(int.tryParse(widget
                                                            .file
                                                            .latestClosingPrice)) >=
                                                        checkDouble(
                                                            int.tryParse(widget
                                                                .file
                                                                .lastClosingPrice)) ||
                                                    checkDouble(int.tryParse(widget
                                                            .file
                                                            .latestClosingPrice)) ==
                                                        0
                                                ? darkTheme["greenText"]
                                                : darkTheme["redText"],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            )
                          : Wrap(
                              direction: Axis.horizontal,
                              crossAxisAlignment: WrapCrossAlignment.end,
                              children: [
                                Text(
                                  widget.file.symbol,
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: darkTheme["primaryTextColor"],
                                  ),
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      checkDouble(int.tryParse(widget.file
                                                      .latestClosingPrice)) >=
                                                  checkDouble(int.tryParse(
                                                      widget.file
                                                          .lastClosingPrice)) ||
                                              checkDouble(int.tryParse(widget
                                                      .file
                                                      .latestClosingPrice)) ==
                                                  0
                                          ? Icons.arrow_upward
                                          : Icons.arrow_downward,
                                      color: checkDouble(int.tryParse(widget
                                                      .file
                                                      .latestClosingPrice)) >=
                                                  checkDouble(int.tryParse(
                                                      widget.file
                                                          .lastClosingPrice)) ||
                                              checkDouble(int.tryParse(widget
                                                      .file
                                                      .latestClosingPrice)) ==
                                                  0
                                          ? darkTheme["greenText"]
                                          : darkTheme["redText"],
                                      size: 20,
                                    ),
                                    Stack(
                                      children: [
                                        Countup(
                                          begin: widget.preFile != null
                                              ? checkDouble(double.tryParse(
                                                  widget.preFile
                                                      .latestClosingPrice))
                                              : checkDouble(double.tryParse(
                                                  widget.file
                                                      .latestClosingPrice)),
                                          end: checkDouble(double.tryParse(
                                              widget.file.latestClosingPrice)),
                                          duration: Duration(seconds: 3),
                                          separator: ',',
                                          style: TextStyle(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w700,
                                            color: checkDouble(int.tryParse(widget
                                                            .file
                                                            .latestClosingPrice)) >=
                                                        checkDouble(
                                                            int.tryParse(widget
                                                                .file
                                                                .lastClosingPrice)) ||
                                                    checkDouble(int.tryParse(widget
                                                            .file
                                                            .latestClosingPrice)) ==
                                                        0
                                                ? darkTheme["greenText"]
                                                : darkTheme["redText"],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(widget.file.fileName,
                                  maxLines: 1,
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: darkTheme["secondaryColor"],
                                  )),
                            ),
                            Row(
                              children: [
                                Countup(
                                  begin: widget.preFile != null
                                      ? checkDouble(double.parse(widget
                                          .preFile.transactionPoints
                                          .toString()))
                                      : double.parse(
                                          widget.file.transactionPoints),
                                  end: checkDouble(double.parse(
                                      widget.file.transactionPoints)),
                                  duration: Duration(seconds: 3),
                                  separator: ',',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: int.tryParse(widget
                                                  .file.transactionPoints) >=
                                              0
                                          ? darkTheme["greenText"]
                                          : darkTheme["redText"]),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  '(' +
                                      widget.file.transactionPercentage +
                                      '%)',
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: double.tryParse(widget.file
                                                  .transactionPercentage) !=
                                              null
                                          ? double.tryParse(widget.file
                                                      .transactionPercentage) >=
                                                  0
                                              ? darkTheme["greenText"]
                                              : darkTheme["redText"]
                                          : darkTheme["greenText"]),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                              flex: 1,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: darkTheme['bgCellColor'],
                                    ),
                                    margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/Seller.svg',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.fill,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Seller',
                                                style: TextStyle(
                                                  color: darkTheme[
                                                      'primaryTextColor'],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 3,
                                          color: darkTheme['secondaryColor'],
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/file.svg',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.fill,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Countup(
                                                begin: widget.preFile != null
                                                    ? checkDouble(
                                                        double.tryParse(widget
                                                            .preFile.quantity))
                                                    : checkDouble(
                                                        double.tryParse(widget
                                                            .file.quantity)),
                                                end: checkDouble(
                                                    double.tryParse(
                                                        widget.file.quantity)),
                                                duration: Duration(seconds: 3),
                                                separator: ',',
                                                style: TextStyle(
                                                    color: darkTheme[
                                                        'primaryTextColor'],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                            thickness: 3,
                                            color: Color.fromRGBO(
                                                199, 124, 49, 1.0)),
                                        Column(
                                          children: [
                                            Container(
                                              padding: EdgeInsets.fromLTRB(
                                                  0, 0, 0, 0),
                                              child: Row(
                                                children: [
                                                  SvgPicture.asset(
                                                    'assets/images/dollar.svg',
                                                    width: 20,
                                                    height: 20,
                                                    fit: BoxFit.fill,
                                                  ),
                                                  SizedBox(
                                                    width: 10,
                                                  ),
                                                  Expanded(
                                                    child: Countup(
                                                      begin: widget.preFile !=
                                                              null
                                                          ? checkDouble(
                                                              double.tryParse(
                                                                  widget.preFile
                                                                      .price))
                                                          : checkDouble(
                                                              double.tryParse(
                                                                  widget.file
                                                                      .price)),
                                                      end: checkDouble(
                                                          double.tryParse(widget
                                                              .file.price)),
                                                      duration:
                                                          Duration(seconds: 3),
                                                      separator: ',',
                                                      style: TextStyle(
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
                                        ),
                                      ],
                                    ),
                                  ),
                                  // AnimatedOpacity(
                                  //   opacity: widget.preFile != null
                                  //       ? widget.preFile.price == widget.file.price
                                  //           ? .0
                                  //           : .7
                                  //       : 0,
                                  //   duration: Duration(milliseconds: 700),
                                  //   child: Container(
                                  //     height: 130,
                                  //     color: widget.preFile != null
                                  //         ? int.parse(widget.preFile.price) !=
                                  //                 int.tryParse(widget.file.price)
                                  //             ? int.parse(widget.preFile.price) >
                                  //                     int.tryParse(
                                  //                         widget.file.price)
                                  //                 ? darkTheme["greenText"]
                                  //                 : darkTheme["redText"]
                                  //             : Colors.transparent
                                  //         : Colors.transparent,
                                  //     width: MediaQuery.of(context).size.width / 2 -
                                  //         40,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child: Stack(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5.0),
                                      color: darkTheme['bgCellColor'],
                                    ),
                                    // width: MediaQuery.of(context).size.width/2-30,
                                    //  color: darkTheme['bgCellColor'],
                                    margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                                    padding: EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/Buyer.svg',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.fill,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                'Buyer',
                                                style: TextStyle(
                                                  color: darkTheme[
                                                      'primaryTextColor'],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                          thickness: 3,
                                          color:
                                              Color.fromRGBO(163, 83, 242, 1.0),
                                        ),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 5, 0, 5),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/file.svg',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.fill,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Countup(
                                                begin: widget.preFile != null
                                                    ? checkDouble(double.parse(
                                                        widget.preFile
                                                            .highestQuantity))
                                                    : checkDouble(double.parse(
                                                        widget.file
                                                            .highestQuantity)),
                                                end: checkDouble(double.parse(
                                                    widget
                                                        .file.highestQuantity)),
                                                duration: Duration(seconds: 3),
                                                separator: ',',
                                                style: TextStyle(
                                                    color: darkTheme[
                                                        'primaryTextColor'],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Divider(
                                            thickness: 3,
                                            color: Color.fromRGBO(
                                                179, 60, 113, 1.0)),
                                        Container(
                                          padding:
                                              EdgeInsets.fromLTRB(0, 0, 0, 0),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset(
                                                'assets/images/dollar.svg',
                                                width: 20,
                                                height: 20,
                                                fit: BoxFit.fill,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Flexible(
                                                child: Countup(
                                                  begin: widget.preFile != null
                                                      ? checkDouble(
                                                          double.parse(widget
                                                              .preFile
                                                              .highestPrice))
                                                      : 0,
                                                  end: checkDouble(double.parse(
                                                      widget
                                                          .file.highestPrice)),
                                                  duration:
                                                      Duration(seconds: 3),
                                                  separator: ',',
                                                  style: TextStyle(
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
                                    ),
                                  ),
                                  // AnimatedOpacity(
                                  //   opacity: widget.preFile != null
                                  //       ? widget.preFile.highestPrice ==
                                  //               widget.file.highestPrice
                                  //           ? 0.0
                                  //           : 0.7
                                  //       : 0,
                                  //   duration: Duration(milliseconds: 700),
                                  //   child: Container(
                                  //     margin: EdgeInsets.fromLTRB(8, 5, 5, 0),
                                  //     height: 130,
                                  //     color: widget.preFile != null
                                  //         ? int.parse(widget
                                  //                     .preFile.highestPrice) !=
                                  //                 int.tryParse(
                                  //                     widget.file.highestPrice)
                                  //             ? int.parse(widget
                                  //                         .preFile.highestPrice) >
                                  //                     int.tryParse(
                                  //                         widget.file.highestPrice)
                                  //                 ? darkTheme["redText"]
                                  //                 : darkTheme["greenText"]
                                  //             : Colors.transparent
                                  //         : Colors.transparent,
                                  //     width: MediaQuery.of(context).size.width / 2 -
                                  //         40,
                                  //   ),
                                  // ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Stack(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5.0),
                                color: darkTheme['bgCellColor'],
                              ),
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Total Trd Vol.",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color:
                                                  darkTheme['primaryTextColor'],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            // "10000000000000000000000000",
                                            widget.file.totalFileVolume,
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: darkTheme[
                                                    'primaryTextColor'],
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "LT Vol.",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color:
                                                  darkTheme['primaryTextColor'],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Countup(
                                            begin: widget.preFile != null
                                                ? checkDouble(double.tryParse(
                                                    widget.preFile
                                                        .lastFileVolume))
                                                : 0,
                                            end: checkDouble(double.tryParse(
                                                widget.file.lastFileVolume)),
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
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Average",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color:
                                                  darkTheme['primaryTextColor'],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Countup(
                                            begin: widget.preFile != null
                                                ? checkDouble(double.tryParse(
                                                    widget.preFile.avgPrice))
                                                : 0,
                                            end: checkDouble(double.tryParse(
                                                widget.file.avgPrice)),
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
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Text(
                                            "LDCP",
                                            style: TextStyle(
                                              fontSize: 11,
                                              color:
                                                  darkTheme['primaryTextColor'],
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            widget.file.ltcp != null
                                                ? widget.file.ltcp
                                                : "0",
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: darkTheme[
                                                    'primaryTextColor'],
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          AnimatedOpacity(
                            opacity: widget.preFile != null
                                ? widget.preFile.lastFileVolume ==
                                        widget.file.lastFileVolume
                                    ? 0.0
                                    : 0.7
                                : 0,
                            duration: Duration(milliseconds: 700),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                              height: 58,
                              color: widget.preFile != null
                                  ? checkDouble(int.tryParse(
                                              widget.preFile.lastFileVolume)) !=
                                          checkDouble(int.tryParse(
                                              widget.file.lastFileVolume))
                                      ? checkDouble(int.tryParse(widget
                                                  .preFile.lastFileVolume)) >
                                              checkDouble(int.tryParse(
                                                  widget.file.lastFileVolume))
                                          ? darkTheme["redText"]
                                          : darkTheme["greenText"]
                                      : Colors.transparent
                                  : Colors.transparent,
                              // width: MediaQuery.of(context).size.width/2-40,
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                  child: ElevatedButton(
                                      onPressed: () =>
                                          {showActionSheet(widget.file)},
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  darkTheme['secondaryColor']),
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(18.0),
                                              side: BorderSide(
                                                  color: darkTheme["redText"]),
                                            ),
                                            // primary: darkTheme["secondaryColor"],
                                          )),
                                      child: Text("Trade Now",
                                          style: TextStyle(fontSize: 15))),
                                ),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
                clipper: ShapeBorderClipper(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5))),
              ),
            )),
        if (widget.file.societyPercentage != null &&
            widget.file.societyPercentage != "0")
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 0, 20, 20),
              child: Transform.rotate(
                angle: -math.pi / 4,
                child: Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  decoration: BoxDecoration(
                    color: Colors.blue,
                  ),
                  child: Text(
                    'TF',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ))
      ],
    );
  }

  showActionSheet(MarketFiles actionMarketFile) {
    showAdaptiveActionSheet(
      context: context,

      title: const Text('Trade Now'),
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: Text(
              'Trade',
              style: TextStyle(
                color: darkTheme["redText"],
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              var a = await Navigator.pushNamed(context, "bid_file",
                  arguments: widget.file.toJson());
              widget.refreshFunctions();
              //CancelAction();
            }),
        BottomSheetAction(
            title: Text(actionMarketFile.isLiked
                ? 'Remove From Watch List'
                : "Add To Watch List"),
            onPressed: () async {
              // Navigator.pushNamed(context, "file_detail",
              //     arguments: widget.file.toJson());
              Navigator.of(context).pop();
              User user = await getUser();
              addWatchList(
                  actionMarketFile.fileId, user.id, actionMarketFile.isLiked);

              setState(() {
                widget.file.isLiked = !widget.file.isLiked;
              });
              // Navigator.of(context).pop;
            }),
        BottomSheetAction(
            title: const Text('Detail'),
            onPressed: () async {
              Navigator.of(context).pop();
              var data = await Navigator.pushNamed(context, "file_detail",
                  arguments: widget.file.toJson());
              widget.refreshFunctions();
            }),
        BottomSheetAction(
            title: const Text('Charts'),
            onPressed: () async {
              Navigator.of(context).pop();
              var d = await Navigator.pushNamed(context, "file_chart",
                  arguments: widget.file.toJson());
              widget.refreshFunctions();
            }),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }
}

Future addWatchList(file_id, userId, isLiked) async {
  var request = {"file_id": file_id, "users_id": userId};
  print(request);

  var response = await addFileWatchList(request);
  if (response["ResponseCode"] == 1) {
    if (!isLiked)
      showToast("File added to watchlist successfully!");
    else
      showToast("File removed from watchlist successfully!");
  }
}

checkDouble(parse) {
  if (parse == null) {
    return 0.0;
  }
  //print('check --- '+parse.toString());
  try {
    return parse;
  } catch (e) {
    showToast("Error Occured" + e.toString());
    return 0.0;
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

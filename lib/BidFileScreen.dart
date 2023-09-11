import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:countup/countup.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/MaterialButton.dart';
import 'package:qkp/MaterialInputField.dart';
import 'package:qkp/Model/MarketFiles.dart';
import 'package:qkp/main.dart';

import 'BottomTabNavigation.dart';
import 'CircularInputField.dart';
import 'Constraint/Dialog.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/MyAsset.dart';
import 'Model/User.dart';
import 'Network/URLS.dart';
import 'Network/constant.dart';
import 'Network/http_requests.dart';
import 'Network/network.dart';
// routeObserver.subscribe(this, ModalRoute.of(context));
import 'Constraint/globals.dart' as global;


class BidFileScreen extends StatefulWidget  {
  @override
  _BidFileScreenState createState() => _BidFileScreenState();
}

class _BidFileScreenState extends State<BidFileScreen> with RouteAware  {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  GlobalKey<FormState> _formKey;
  GlobalKey<FormState> _formKey1;
  MarketFiles marketfile;
  String qty;
  String price;
  User user;
  String assetsQty;
  List<MyAsset> sellOrderList = [];
  List<MyAsset> buyOrderList = [];
  bool isTopLoading = false;
  FirebaseMessaging _firebaseMessaging;
  int numberOfBids = -1;
  Timer timer;
  bool firstLoading = true;
  bool requesting = false;

  @override
  void didPopNext() {
    fcmInit();
    getPageData();
  }
  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });

    ownerFile();
    getFileData();
  }

  getFileData() async {
    var headers = {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      HttpHeaders.cacheControlHeader: 'no-cache',
      HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    };
    if (isTopLoading) {
      return;
    }
    // prMarketFilesList.clear();
    // if (this.globalCounter > 0) {
    //   prMarketFilesList.addAll(marketFilesList);
    // }
    // setState(() {
    //   isTopLoading = true;
    // });
    // print(marketfile.fileId);
    requesting = true;
    var loginResponse = await getRequest("/get_all_files?user_id=" +
            user.id +
            "&file_id=" +
            marketfile.fileId +
            "&user_city=" +
            user.city
        // headers: headers,
        );
    requesting = false;

    if (loginResponse == null) {
      print("n/a");
      return;
    }

    if (loginResponse != null) {
      // print(loginResponse.body);
      var data = loginResponse;
      if (data["filesData"].length > 0) {
        // print(data);
        // MarketFiles
        var fileMap = data["filesData"]['files'][0];
        print(fileMap);
        marketfile.fromJson(fileMap);
        print("m");
        setState(() {
          marketfile = marketfile;
        });
      }
    } else {
      //showToast("Cannot Proceed Request",Colors.red, Colors.white, Toast.LENGTH_SHORT, ToastGravity.BOTTOM);
    }
    return true;
  }

  ownerFile() async {
    setState(() {
      isTopLoading = true;
    });
    var res2 = await getUserBidsService({"user_id": user.id});

    if (res2 != null) {
      numberOfBids = int.tryParse(res2["list"]["bids"].toString());
    } else {
      numberOfBids = 0;
    }
    var request = <String, dynamic>{
      "owner_id": user.id,
      "file_id": marketfile.fileId
    };
    print("request market--" + marketfile.mPostId);
    var res = await ownerFilesService(request);
    //print("res"+res.toString());
    if(res == null){
      return;
    }
    if (res["ResponseCode"] == 1) {
      setState(() {
        assetsQty = res["Files"]['available_quantity'].toString();
        // showToast("Bid sent Successfully"+assetsQty);
        //print('assets_id: '+assetsQty);
      });
      // showToast("Bid sent Successfully");
      //clearForm();
    } else {
      setState(() {
        assetsQty = '';
      });
    }
    ownerActionAssets();
  }

  ownerActionAssets() async {
    var request = <String, dynamic>{
      "owner_id": user.id,
      "file_id": marketfile.fileId
    };
    var res = await getOwnerAction(request);

    //print("res"+res.toString());
    sellOrderList.clear();
    buyOrderList.clear();
    if (res == null) {
      return;
    }
    if (res["ResponseCode"] == 1) {
      var sellOrderMapList = res["Tabs"]["sell"];
      var buyOrderMapList = res["Tabs"]["buy"];
      for (int i = 0; i < sellOrderMapList.length; i++) {
        MyAsset asset = new MyAsset();
        asset.fromJson(sellOrderMapList[i]);
        setState(() {
          sellOrderList.add(asset);
        });
      }
      for (int i = 0; i < buyOrderMapList.length; i++) {
        MyAsset asset = new MyAsset();
        print("here =>" + buyOrderList.toString());
        asset.fromJson(buyOrderMapList[i]);
        setState(() {
          buyOrderList.add(asset);
        });
      }
      setState(() {
        sellOrderList = sellOrderList;
        buyOrderList = buyOrderList;
      });
    } else {
      setState(() {
        //assetsQty = '';
      });
    }

    setState(() {
      isTopLoading = false;
      firstLoading = false;
    });
  }

  clearForm() {
    setState(() {
      qty = '';
      price = '';
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    getPageData();
    fileTimer();
    super.initState();
  }

  void fileTimer() async {
    int i = 0;
    timer = Timer.periodic(Duration(seconds: 10), (timer) {
      if (!requesting) {
        getFileData();
        i++;
        if (i % 2 == 0) {
          ownerFile();
        }
      }
      // getPageData();
    });
  }

  @override
  void dispose() {
    timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }
  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }
  void FCMMesseging(message) {
    onNotificationReceive(context,data: {"message":message});
  }
  @override
  void didChangeDependencies() {
    final arguments = ModalRoute.of(context).settings.arguments;
    MarketFiles file = new MarketFiles();
    file.fromJson(arguments);
    setState(() {
      marketfile = file;
    });
    fcmInit();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context));
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: !_mFuncLoading
          ? AppBar(
              title: Column(
                children: [
                  Text(marketfile.symbol),
                  Text("("+marketfile.fileName+")",maxLines: 1,style: TextStyle(fontSize: 10),)
                ],
              ),
              backgroundColor: isDarkTheme
                  ? darkTheme["primaryBackgroundColor"]
                  : lightTheme["primaryBackgroundColor"],
              bottom: PreferredSize(
                preferredSize: Size.fromHeight(1.0),
                child: isTopLoading ? LinearProgressIndicator() : SizedBox(),
              ),
            )
          : null,
      body: _mFuncLoading
          ? Container(
              width: getWidth(context),
              height: getHeight(context),
              color: isDarkTheme
                  ? darkTheme["primaryBackgroundColor"]
                  : lightTheme["primaryBackgroundColor"],
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Your File Have Been Posted Successfully",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              )),
            )
          : Stack(
              children: [
                Container(
                  width: _width,
                  height: _height,
                  color: isDarkTheme
                      ? darkTheme["primaryBackgroundColor"]
                      : lightTheme["primaryBackgroundColor"],
                  padding: EdgeInsets.all(10),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    //  crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      var data = await dialog(
                                          "sell",
                                          assetsQty,
                                          user,
                                          marketfile,
                                          context,
                                          _formKey, (cont, price, qty, postId) {
                                        post(cont, 'sell', price, qty, postId);
                                      }, '', marketfile.postId,
                                          numberOfBids: numberOfBids);
                                      if (data) getPageData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    child: Text(
                                      "Sell",
                                      style: TextStyle(
                                          color: darkTheme['primaryTextColor'],
                                          fontWeight: FontWeight.bold),
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      print("here" + marketfile.price);
                                      var data = await buyDialog(
                                          "buy",
                                          assetsQty,
                                          user,
                                          marketfile,
                                          context,
                                          _formKey1,
                                          (cont, price, qty, biderId) async {
                                        buy(cont, 'buy', price, qty, biderId);
                                        return true;
                                      }, '', '', numberOfBids: numberOfBids);
                                      if (data) getPageData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: Text(
                                      "Buy",
                                      style: TextStyle(
                                          color: darkTheme['primaryTextColor'],
                                          fontWeight: FontWeight.bold),
                                    ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      var data = await dialog(
                                          "sell_limit",
                                          assetsQty,
                                          user,
                                          marketfile,
                                          context,
                                          _formKey,
                                          (cont, price, qty, postId) async {
                                        var sl = await post(cont, 'sell_limit',
                                            price, qty, postId);
                                        return true;
                                      }, 'sell', marketfile.postId,
                                          numberOfBids: numberOfBids);
                                      if (data) getPageData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    child: Text(
                                      "Sell Limit",
                                      style: TextStyle(
                                          color: darkTheme['primaryTextColor'],
                                          fontWeight: FontWeight.bold),
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      var data = await buyDialog(
                                          "buy_limit",
                                          assetsQty,
                                          user,
                                          marketfile,
                                          context,
                                          _formKey1,
                                          (cont, price, qty, biderId) async {
                                        var dt = await buy(cont, 'buy_limit',
                                            price, qty, biderId);
                                        return true;
                                      }, '', '', numberOfBids: numberOfBids);
                                      if (data) getPageData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: Text(
                                      "Buy Limit",
                                      style: TextStyle(
                                          color: darkTheme['primaryTextColor'],
                                          fontWeight: FontWeight.bold),
                                    ))),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      var data = await dialog(
                                          "sell_kill",
                                          assetsQty,
                                          user,
                                          marketfile,
                                          context,
                                          _formKey,
                                          (cont, price, qty, postId) async {
                                        var sk = await post(cont, 'sell_kill',
                                            price, qty, postId);
                                        return true;
                                      }, '', marketfile.postId,
                                          numberOfBids: numberOfBids);
                                      if (data) getPageData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.green,
                                    ),
                                    child: Text(
                                      "Sell / Kill",
                                      style: TextStyle(
                                          color: darkTheme['primaryTextColor'],
                                          fontWeight: FontWeight.bold),
                                    ))),
                            SizedBox(
                              width: 10,
                            ),
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: () async {
                                      var data = await buyDialog(
                                          "buy_kill",
                                          assetsQty,
                                          user,
                                          marketfile,
                                          context,
                                          _formKey,
                                          (cont, price, qty, postId) async {
                                        var bk = await buy(cont, 'buy_kill',
                                            price, qty, postId);
                                        return true;
                                      }, 'sell', marketfile.postId,
                                          numberOfBids: numberOfBids);
                                      if (data) getPageData();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                    ),
                                    child: Text(
                                      "Buy / Kill",
                                      style: TextStyle(
                                          color: darkTheme['primaryTextColor'],
                                          fontWeight: FontWeight.bold),
                                    ))),
                          ],
                        ),
                      ),
                      Flexible(
                        child: Card(
                          color: darkTheme["cardBackground"],
                          child: ClipPath(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: darkTheme["secondaryColor"],
                                          width: 6))),
                              child: SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 12, 0, 0),
                                            child: Text('Sell',
                                                style: TextStyle(
                                                    color: darkTheme[
                                                        "secondaryColor"],
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)))
                                      ],
                                    ),
                                    Container(
                                      height: 260,
                                      child: ListView.builder(
                                        itemCount: sellOrderList.length,
                                        itemBuilder: (context, index) {
                                          return sellOrderList.length > 0
                                              ? SellItemWidget(
                                                  sell: sellOrderList[index],
                                                  marketfile: marketfile,
                                                  assetsQty: assetsQty,
                                                  user: user,
                                                  formKey: _formKey,
                                                  refreshPage: () {
                                                    getPageData();
                                                  },
                                                  numberOfBids: numberOfBids,
                                                  post: (context, price, qty,
                                                      postId) async {
                                                    var s = await post(
                                                        context,
                                                        'update',
                                                        price,
                                                        qty,
                                                        postId);
                                                    return true;
                                                  })
                                              : Container();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                      ),
                      Flexible(
                        child: Card(
                          color: darkTheme["cardBackground"],
                          child: ClipPath(
                            child: Container(
                              decoration: BoxDecoration(
                                  border: Border(
                                      top: BorderSide(
                                          color: darkTheme["secondaryColor"],
                                          width: 6))),
                              child: SingleChildScrollView(
                                physics: NeverScrollableScrollPhysics(),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                16, 12, 0, 0),
                                            child: Text('Buy',
                                                style: TextStyle(
                                                    color: darkTheme[
                                                        "secondaryColor"],
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold)))
                                      ],
                                    ),
                                    Container(
                                      height: 240,
                                      child: ListView.builder(
                                        itemCount: buyOrderList.length,
                                        itemBuilder: (context, index) {
                                          return buyOrderList.length > 0 &&
                                                  buyOrderList[index] != null
                                              ? BuyItemWidget(
                                                  buy: buyOrderList[index],
                                                  marketfile: marketfile,
                                                  assetsQty: assetsQty,
                                                  user: user,
                                                  formKey1: _formKey1,
                                                  refreshPage: () {
                                                    getPageData();
                                                  },
                                                  numberOfBids: numberOfBids,
                                                  buyfunc: (context, price, qty,
                                                      biderId) async {
                                                    var b = await buy(
                                                        context,
                                                        'update',
                                                        price,
                                                        qty,
                                                        biderId);
                                                    return true;
                                                  })
                                              : Container();
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            clipper: ShapeBorderClipper(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (firstLoading)
                  AppLoadingScreen(
                    backgroundOpactity: .6,
                  )
              ],
            ),
    );
  }

  //buydialog

  //sell dialog
  bool _mFuncLoading = false;

  Future<bool> post(cont, type, formPrice, formQty, postId) async {
    print('formQty:-' + formQty);
    if (!isNumeric(formPrice)) {
      showToast("not a valid price");
      playWarningSound();
      return false;
    }

    if (_mFuncLoading) {
      showToast(
          "you are clicking too fast please wait an request is proccessing");
      playWarningSound();
      return false;
    }
    if (!isNumeric(formQty)) {
      showToast("not a valid quanitiy");
      playWarningSound();
      return false;
    }
    /* if (int.tryParse(formQty) > int.tryParse(assetsQty)) {
      showToast("your available quantity: " + assetsQty);
      return;
    } */

    if (formPrice.length < 1) {
      showToast("price cannot be empty");
      playStopSound();
      return false;
    }
    if (formQty.length < 1) {
      playStopSound();
      showToast("quantity cannot be empty");
      return false;
    }
    var isOwner = "NO";
    if (user.id == marketfile.ownerId) {
      // playStopSound();
      isOwner = "Yes";
    }
    // if(type == "sell"){
    var request = {
      "qty": formQty,
      "price": formPrice,
      "file_action_id": marketfile.fileActionId,
      "owner_id": user.id,
      "file_id": marketfile.fileId,
      "symbol_id": marketfile.qkpFileSymbolId,
      "post_id": postId,
      "type": type
    };
    // howAlertDialog("Request Failed", "Cannot Load data", context);
    print('sell: ' + request.toString());
    // return;
    setState(() {
      _mFuncLoading = true;
    });
    var response = await postFile(request);
    setState(() {
      _mFuncLoading = false;
    });
    // print(response);
    if (response != null) {
      if (response["ResponseCode"] == 1) {
        getRequest(REFRESH_MARKET_FIREBASE_DATA);
        if (type == "sell_limit") {
          playSniperLoadSound();
          getPageData();
        } else {
          // stop_audio.mp3
          playBidSound();
        }
        navBidSuccessful(context);
        // Navigator.of(cont).pop();
      } else {
        playStopSound();
      }
    } else {
      showAlertDialog("Request Failed", "Cannot Get Response", context);
      playStopSound();
    }
    return true;
  }

  Future<bool> buy(cont, type, formPrice1, formQty1, bidId) async {
    if (!isNumeric(formPrice1)) {
      showToast("not a valid price");
      playWarningSound();
      return false;
    }
    if (!isNumeric(formQty1)) {
      showToast("not a valid quanitiy");
      playWarningSound();
      return false;
    }
    if (_mFuncLoading) {
      showToast(
          "you are clicking too fast please wait an request is proccessing");
      playWarningSound();
      return false;
    }
    if (formPrice1.length < 1) {
      showToast("price cannot be empty");
      playStopSound();
      return false;
    }
    if (formQty1.length < 1) {
      showToast("quantity cannot be empty");
      playStopSound();
      return false;
    }

    var request = {
      "owner_id": marketfile.ownerId,
      "bider_id": user.id,
      "quantity": marketfile.quantity,
      "price": marketfile.price,
      "bid_quantity": formQty1,
      "bid_price": formPrice1,
      "qkp_file_id": marketfile.fileId,
      "file_action_id": marketfile.fileActionId,
      "post_id": marketfile.mPostId,
      "symbol_id": marketfile.qkpFileSymbolId,
      "type": type,
      "bidid": bidId
    };
    print(request);
    setState(() {
      _mFuncLoading = true;
    });
    var response = await bidFiles(request);
    setState(() {
      _mFuncLoading = false;
    });
    print(response);
    if (response["ResponseCode"] == 1) {
      getRequest(REFRESH_MARKET_FIREBASE_DATA);
      // playBidSound();
      if (type == "buy_limit") {
        playSniperLoadSound();
        getPageData();
      } else {
        // stop_audio.mp3
        playBidSound();
      }
      navBidSuccessful(context);
      // Navigator.of(cont).pop();
    }
    return true;
  }
}

class BuyItemWidget extends StatefulWidget {
  MyAsset buy;
  String assetsQty;
  User user;
  GlobalKey<FormState> formKey1;
  final buyfunc;
  final marketfile;
  final refreshPage;
  int numberOfBids;

  BuyItemWidget(
      {this.buy,
      this.assetsQty,
      this.user,
      this.formKey1,
      this.buyfunc,
      this.marketfile,
      this.refreshPage,
      this.numberOfBids});

  @override
  _BuyItemWidgetState createState() => _BuyItemWidgetState();
}

class _BuyItemWidgetState extends State<BuyItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        bottom: BorderSide(
          color: darkTheme['primaryTextColor'],
          width: 1.0,
        ),
      )),
      margin: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 0),
      child: Material(
        color: darkTheme["cardBackground"],
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              // playHammerAudio();
              showActionSheet(widget.buy, widget.assetsQty, widget.user,
                  widget.formKey1, widget.buyfunc, widget.marketfile);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Buy",
                  style: TextStyle(
                      color: darkTheme['primaryTextColor'],
                      fontWeight: FontWeight.bold),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SvgPicture.asset(
                      'assets/images/file.svg',
                      width: 14,
                      height: 14,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.buy.bidQuantity,
                      style: TextStyle(
                          color: darkTheme['primaryTextColor'],
                          fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/dollar.svg',
                      width: 14,
                      height: 14,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.buy.bidPrice,
                      style: TextStyle(
                          color: darkTheme['primaryTextColor'],
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  showActionSheet(MyAsset actionMarketFile, assetsQty, user, formKey1, buyfunc,
      marketfile) {
    showAdaptiveActionSheet(
      context: context,
      title: const Text('Buy'),
      actions: <BottomSheetAction>[
        // BottomSheetAction(
        //     title: const Text(
        //       'Instant Buy',
        //     ),
        //     onPressed: () async {
        //       //  print("id " + actionMarketFile.qkpFileBidId);
        //       Navigator.of(context).pop();
        //       var data = await buyDialog(
        //           "instant_buy",
        //           assetsQty,
        //           user,
        //           marketfile,
        //           context,
        //           formKey1,
        //           buyfunc,
        //           actionMarketFile,
        //           actionMarketFile.qkpFileBidId,
        //           numberOfBids: widget.numberOfBids);
        //       // if (data == true) widget.refreshPage();
        //     }),
        BottomSheetAction(
            title: const Text(
              'Edit',
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              print("id " + actionMarketFile.qkpFileBidId);
              var data = await buyDialog(
                  "update",
                  assetsQty,
                  user,
                  marketfile,
                  context,
                  formKey1,
                  buyfunc,
                  actionMarketFile,
                  actionMarketFile.qkpFileBidId,
                  numberOfBids: widget.numberOfBids);
              // if (data == true) widget.refreshPage();
            }),
        BottomSheetAction(
            title: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await deleteBid(actionMarketFile.qkpFileBidId, user.id);
              // widget.refreshPage();
            }),
      ],
      cancelAction: CancelAction(
          title: const Text(
        'Cancel',
      )), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  bool isRequesting = false;

  deleteBid(bidId, userId) async {
    if (isRequesting) {
      showToast("please wait request is processing..");
      return;
    }
    var request = {"bid_id": bidId, "user_id": userId};
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    progressDialog.update(message: "Deleting Post..");
    progressDialog.show();
    isRequesting = true;
    var response = await deleteFileBid(request);
    isRequesting = false;
    progressDialog.hide();
    if (response["ResponseCode"] == 1) {
      getRequest(REFRESH_MARKET_FIREBASE_DATA);
      showToast("post deleted successfully!");
      widget.refreshPage();
    }
  }
}

class SellItemWidget extends StatefulWidget {
  MyAsset sell;
  String assetsQty;
  User user;
  GlobalKey<FormState> formKey;
  final post;
  final marketfile;
  final refreshPage;
  int numberOfBids;

  SellItemWidget(
      {this.sell,
      this.assetsQty,
      this.user,
      this.formKey,
      this.post,
      this.marketfile,
      this.refreshPage,
      this.numberOfBids});

  @override
  _SellItemWidgetState createState() => _SellItemWidgetState();
}

class _SellItemWidgetState extends State<SellItemWidget> {
  @override
  Widget build(BuildContext context) {
    if (widget.sell == null) {
      return SizedBox();
    } else
      return Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            color: darkTheme['primaryTextColor'],
            width: 1.0,
          ),
        )),
        margin: const EdgeInsets.fromLTRB(8.0, 2.0, 8.0, 2.0),
        child: Material(
          color: darkTheme["cardBackground"],
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TouchableOpacity(
              onTap: () {
                showActionSheet(widget.sell, widget.assetsQty, widget.user,
                    widget.formKey, widget.post, widget.marketfile);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Sell",
                    style: TextStyle(
                        fontSize: 17,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/file.svg',
                        width: 14,
                        height: 14,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.sell.bidQuantity,
                        style: TextStyle(
                            color: darkTheme['primaryTextColor'],
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/images/dollar.svg',
                        width: 14,
                        height: 14,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        widget.sell.bidPrice,
                        style: TextStyle(
                            color: darkTheme['primaryTextColor'],
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }

  showActionSheet(
      MyAsset actionMarketFile, assetsQty, user, formKey, post, marketfile) {
    showAdaptiveActionSheet(
      context: context,
      title: const Text('Sell'),
      actions: <BottomSheetAction>[
        // BottomSheetAction(
        //     title: const Text(
        //       'Instant Sell',
        //     ),
        //     onPressed: () async {
        //       Navigator.of(context).pop();
        //       var data = await dialog(
        //           "instant_sell",
        //           assetsQty,
        //           user,
        //           marketfile,
        //           context,
        //           formKey,
        //           post,
        //           actionMarketFile,
        //           actionMarketFile.postId,
        //           numberOfBids: widget.numberOfBids);
        //       // if (data) widget.refreshPage();
        //     }),
        BottomSheetAction(
            title: const Text(
              'Edit',
            ),
            onPressed: () async {
              Navigator.of(context).pop();

              var data = await dialog(
                  "update",
                  assetsQty,
                  user,
                  marketfile,
                  context,
                  formKey,
                  post,
                  actionMarketFile,
                  actionMarketFile.postId,
                  numberOfBids: widget.numberOfBids);
              // if (data) widget.refreshPage();
            }),
        BottomSheetAction(
            title: const Text(
              'Delete',
              style: TextStyle(color: Colors.red),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              await deletePost(actionMarketFile.postId, user.id);
              // widget.refreshPage();
            }),
      ],
      cancelAction: CancelAction(
          title: const Text(
        'Cancel',
      )), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  bool isRequesting = false;

  deletePost(postId, userId) async {
    if (isRequesting) {
      showToast("please wait till request completes");
      return;
    }
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    progressDialog.update(message: "Deleting Post..");
    progressDialog.show();
    isRequesting = true;
    setState(() {
      widget.sell = null;
    });
    var request = {"post_id": postId, "user_id": userId};
    var response = await deleteFilePost(request);
    isRequesting = false;
    progressDialog.hide();
    if (response == null) {
      showAlertDialog("Request Failed", "Cannot Load data", context);
      widget.refreshPage();
      return;
    }
    if (response["ResponseCode"] == 1) {
      getRequest(REFRESH_MARKET_FIREBASE_DATA);
      showToast("post deleted successfully!");
      widget.refreshPage();
    }
  }
}

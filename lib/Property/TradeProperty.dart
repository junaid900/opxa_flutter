import 'dart:async';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/Property.dart';
import 'package:qkp/Model/PropertyBids.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/URLS.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'package:qkp/Network/network.dart';
import 'package:intl/intl.dart';
import '../Constraint/globals.dart' as global;
import '../main.dart';

class TradeProperty extends StatefulWidget {
  @override
  _TradePropertyState createState() => _TradePropertyState();
}

class _TradePropertyState extends State<TradeProperty> with RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  Property propertyList;

  // FirebaseMessaging _firebaseMessaging;

  // Property propertyList;
  User user;
  List<PropertyBids> propertyBids = [];
  List<PropertyBids> maxPropertyBids = [];
  bool isTopLoading = false;
  Timer timer;
  bool firstLoading = true;

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    bidPropertyList();
    getSinglePropertyData();
  }

  bool isRequesting = false;

  getSinglePropertyData() async {
    if (isRequesting) {
      return;
    }
    if (propertyList == null) {
      return;
    }
    var request = {
      "property_id": propertyList.id,
    };
    isRequesting = true;
    var res = await getSinglePropertyService(request);
    isRequesting = false;
    if (res != null) {
      var data = res["list"]['properties'];
      // print(res);
      print(data);
      if (data != null) {
        try {
          propertyList.fromJson(data);
        } catch (e) {}
        setState(() {
          propertyList = propertyList;
        });
      }
    } else {
      // showDialog(context: context,builder: ())
      isRequesting = true;
      // var a = await propertyConformationDialog(context);
      isRequesting = false;
    }
  }

  bidPropertyList() async {
    setState(() {
      isTopLoading = true;
    });
    var request = <String, dynamic>{"property_id": propertyList.id};
    var res = await getBidPropertyList(request);
    setState(() {
      isTopLoading = false;
      firstLoading = false;
    });

    propertyBids.clear();
    maxPropertyBids.clear();
    if (res == null) {
      // showToast("no data found");
      return;
    }
    if (res["ResponseCode"] == 1) {
      var propertyrMapList = res["list"]["bids"];
      var maxMapList = res["list"]["maximum_bid"];
      for (int i = 0; i < propertyrMapList.length; i++) {
        PropertyBids propertyBid = new PropertyBids();
        propertyBid.fromJson(propertyrMapList[i]);
        propertyBids.add(propertyBid);
      }
      for (int i = 0; i < maxMapList.length; i++) {
        PropertyBids propertyBid = new PropertyBids();
        propertyBid.fromJson(maxMapList[i]);
        maxPropertyBids.add(propertyBid);
      }
      setState(() {
        propertyBids = propertyBids;
        maxPropertyBids = maxPropertyBids;
      });
    } else {
      setState(() {
        //assetsQty = '';
      });
    }
  }

  @override
  void initState() {
    getPageData();
    super.initState();
    propertyTimer();
  }

  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    fcmInit();
    final arguments = ModalRoute.of(context).settings.arguments;
    setState(() {
      propertyList = arguments;
    });
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
    getPageData();
    onNotificationReceive(context, data: {"message": message});
  }

  @override
  void dispose() {
    timer.cancel();
    // TODO: implement dispose
    super.dispose();
  }

  void propertyTimer() {
    timer = Timer.periodic(Duration(seconds: 5), (timer) {
      getPageData();
    });
  }

  bool _pinned = true;
  bool _snap = false;
  bool _floating = false;

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: <Widget>[
              SliverAppBar(
                pinned: _pinned,
                snap: _snap,
                floating: _floating,
                title: Text(propertyList.propertyName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    )),
                expandedHeight: 250.0,
                flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,
                    background: Image.network(
                      url + propertyList.images[0].image,
                      fit: BoxFit.cover,
                    )),
                bottom: PreferredSize(
                  preferredSize: Size.fromHeight(7.0),
                  child: isTopLoading ? LinearProgressIndicator() : SizedBox(),
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  return Container(
                    width: _width,
                    height: _height,
                    color: darkTheme["primaryBackgroundColor"],
                    //transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                    /* decoration: new BoxDecoration(
                          color: darkTheme["primaryBackgroundColor"],
                          borderRadius: BorderRadius.only(
                              topRight: const Radius.circular(35.0),
                              topLeft: const Radius.circular(35.0))), */
                    child: Padding(
                      padding: const EdgeInsets.all(1.0),
                      child: PropertyItem(
                          propertyList: propertyList,
                          user: user,
                          propertyBids: propertyBids,
                          bidfunc: () {
                            getPageData();
                          },
                          maxPropertyBids: maxPropertyBids,
                          bidfunction: () {
                            getPageData();
                          }),
                    ),
                  );
                }, childCount: 1
                    // childCount: 20,
                    ),
              ),
            ],
          ),
          if (firstLoading)
            AppLoadingScreen(
              backgroundOpactity: .6,
            )
        ],
      ),
    );
  }
}

class PropertyItem extends StatefulWidget {
  /*
   Container(
            width: _width,
            height: _height,
            color: isDarkTheme
                ? darkTheme["primaryBackgroundColor"]
                : lightTheme["primaryBackgroundColor"],
            child: Padding(
              padding: const EdgeInsets.all(1.0),
              child: PropertyItem(propertyList: arguments ,user:user , propertyBids: propertyBids,bidfunc:bidPropertyList ),
            ),
          ),*/
  Property propertyList;
  User user;
  List propertyBids;
  List maxPropertyBids;
  final bidfunc;
  final bidfunction;

  PropertyItem(
      {this.maxPropertyBids,
      this.propertyList,
      this.user,
      this.propertyBids,
      this.bidfunc,
      this.bidfunction});

  @override
  _PropertyItemState createState() => _PropertyItemState();
}

class _PropertyItemState extends State<PropertyItem> {
  GlobalKey<FormState> _formKey2;
  bool isRequesting = false;

  @override
  Widget build(BuildContext context) {
    //print("maximum Bid"+ widget.maxPropertyBids[0].bidPrice.toString());
    var length = widget.propertyBids != null ? widget.propertyBids.length : 0;
    var formatter = NumberFormat.compact(locale: 'eu');
    return widget.user == null
        ? SizedBox()
        : Container(
            height: MediaQuery.of(context).size.height,
            /* transform: Matrix4.translationValues(0.0, -40.0, 0.0),
          decoration: BoxDecoration(
              color: darkTheme['primaryBackgroundColor'],
              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20))
          ), */
            child: Wrap(
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Visibility(
                        visible: widget.user.id == widget.propertyList.usersId
                            ? false
                            : true,
                        child: SizedBox(
                          width: 170,
                          child: ElevatedButton(
                              onPressed: () async {
                                var data = await bidProperty(
                                    'make_offer',
                                    widget.propertyBids.length > 0
                                        ? widget.propertyBids[0].bidPrice
                                        : 0,
                                    widget.propertyList,
                                    widget.user.id,
                                    context,
                                    _formKey2,
                                    (context, propertyList, userId, bidPrice) {
                                  bidProp(
                                      context, propertyList, userId, bidPrice);
                                });
                                if (data) {
                                  widget.bidfunc();
                                }
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
                              child: Text("Make offer",
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700))),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Visibility(
                      visible: widget.user.id == widget.propertyList.usersId
                          ? false
                          : true,
                      child: SizedBox(
                        width: 170,
                        child: ElevatedButton(
                            onPressed: () async {
                              var data = await bidProperty(
                                  'buy_now',
                                  widget.propertyBids.length > 0
                                      ? widget.propertyBids[0].bidPrice
                                      : 0,
                                  widget.propertyList,
                                  widget.user.id,
                                  context,
                                  _formKey2,
                                  (context, propertyList, userId, bidPrice) {
                                bidProp(
                                    context, propertyList, userId, bidPrice);
                              });
                              if (data) {
                                await widget.bidfunc();
                                // Navigator.pushNamed(context, "portfolio",arguments: "1");
                              }
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.green),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                        BorderSide(color: darkTheme["redText"]),
                                  ),
                                  // primary: darkTheme["secondaryColor"],
                                )),
                            child: Text("Buy Now",
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700))),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Detail',
                        style: TextStyle(
                            color: darkTheme['primaryTextColor'],
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: Table(
                      defaultVerticalAlignment:
                          TableCellVerticalAlignment.middle,
                      border: TableBorder(
                          //   verticalInside: BorderSide(color: darkTheme['secondaryColor']),
                          //  horizontalInside: BorderSide(color: darkTheme['secondaryColor']),
                          ),
                      columnWidths: {
                        0: FractionColumnWidth(.4),
                        1: FractionColumnWidth(.4),
                        2: FractionColumnWidth(.2),
                      },
                      /* widget.user.id == widget.propertyList.usersId
                    ? {
                        0: FractionColumnWidth(.4),
                        1: FractionColumnWidth(.4),
                        2: FractionColumnWidth(.2),
                      }
                    : {
                        0: FractionColumnWidth(.5),
                        1: FractionColumnWidth(.5),
                      } */
                      children: [
                        TableRow(children: [
                          TableCell(
                              child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                  topLeft: const Radius.circular(10.0),
                                  bottomLeft: const Radius.circular(10.0)),
                              color: darkTheme['cardBackground'],
                            ),
                            child: Center(
                                child: Text(
                              'Name',
                              style: TextStyle(
                                  color: darkTheme['primaryTextColor']),
                            )),
                          )),
                          TableCell(
                              child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(0.0),
                                  bottomRight: const Radius.circular(0.0)),
                              /*widget.user.id == widget.propertyList.usersId
                                ? new BorderRadius.only(
                                    topRight: const Radius.circular(0.0),
                                    bottomRight: const Radius.circular(0.0))
                                : new BorderRadius.only(
                                    topRight: const Radius.circular(10.0),
                                    bottomRight: const Radius.circular(10.0)),*/
                              color: darkTheme['cardBackground'],
                            ),
                            child: Center(
                                child: Text(
                              'Price',
                              style: TextStyle(
                                  color: darkTheme['primaryTextColor']),
                            )),
                          )),
                          TableCell(
                              /*  child: Visibility(
                      visible: widget.user.id == widget.propertyList.usersId
                          ? true
                          : false, */
                              child: Container(
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: darkTheme['cardBackground'],
                              borderRadius: new BorderRadius.only(
                                  topRight: const Radius.circular(10.0),
                                  bottomRight: const Radius.circular(10.0)),
                            ),
                            child: Center(
                                child: Text(
                              'Action',
                              style: TextStyle(
                                  color: darkTheme['primaryTextColor']),
                            )),
                            // ),
                          )),
                        ]),
                        for (var i = 0; i < length; i++)
                          TableRow(children: [
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                    topLeft: const Radius.circular(10.0),
                                    bottomLeft: const Radius.circular(10.0)),
                                color: i % 2 == 0
                                    ? Colors.transparent
                                    : darkTheme['cardBackground'],
                              ),
                              child: Wrap(
                                children: [
                                  Center(
                                      child: Text(
                                    widget.propertyBids[i].userName,
                                    style: TextStyle(
                                        color: darkTheme['primaryTextColor']),
                                  )),
                                  Center(
                                      child: Text(
                                    widget.propertyBids[i].dateAdded,
                                    style: TextStyle(
                                        color: darkTheme['primaryTextColor'],
                                        fontSize: 8),
                                  )),
                                ],
                              ),
                            )),
                            TableCell(
                                child: Container(
                              padding: const EdgeInsets.all(10.0),
                              decoration: BoxDecoration(
                                borderRadius: new BorderRadius.only(
                                    topRight: const Radius.circular(0.0),
                                    bottomRight: const Radius.circular(0.0)),
                                color: i % 2 == 0
                                    ? Colors.transparent
                                    : darkTheme['cardBackground'],
                              ),
                              child: Center(
                                  child: Text(
                                widget.propertyBids[i].bidPrice + ' PKR',
                                style: widget.maxPropertyBids.length > 0
                                    ? widget.maxPropertyBids[0].id ==
                                            widget.propertyBids[i].id
                                        ? TextStyle(color: Colors.green[400])
                                        : TextStyle(color: Colors.red[400])
                                    : TextStyle(
                                        color: darkTheme['primaryTextColor']),
                              )),
                            )),
                            widget.user.id != widget.propertyList.usersId
                                ? TableCell(
                                    child: Visibility(
                                      visible: widget.propertyBids[i].usersId ==
                                              widget.user.id
                                          ? true
                                          : false,
                                      child: Container(
                                        padding: const EdgeInsets.all(12.0),
                                        decoration: BoxDecoration(
                                          borderRadius: new BorderRadius.only(
                                              topRight:
                                                  const Radius.circular(10.0),
                                              bottomRight:
                                                  const Radius.circular(10.0)),
                                          color: i % 2 == 0
                                              ? Colors.transparent
                                              : darkTheme['cardBackground'],
                                        ),
                                        child: Row(
                                          children: [
                                            InkWell(
                                                onTap: () async {
                                                  showActionSheet(
                                                      widget.propertyBids[i],
                                                      widget.user.id,
                                                      widget.bidfunction);
                                                },
                                                child: Icon(
                                                  Icons.edit,
                                                  size: 17,
                                                  color: Colors.green,
                                                )),
                                            /* InkWell(
                                      onTap: () async {

                                      },
                                      child: Icon(
                                        Icons.delete,
                                        size: 17,
                                        color: Colors.red,
                                      )),*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                : TableCell(
                                    child: Visibility(
                                    visible: widget.user.id ==
                                            widget.propertyList.usersId
                                        ? true
                                        : false,
                                    child: Container(
                                      padding: const EdgeInsets.all(12.0),
                                      decoration: BoxDecoration(
                                        borderRadius: new BorderRadius.only(
                                            topRight:
                                                const Radius.circular(10.0),
                                            bottomRight:
                                                const Radius.circular(10.0)),
                                        color: i % 2 == 0
                                            ? Colors.transparent
                                            : darkTheme['cardBackground'],
                                      ),
                                      child: Center(
                                          child: isRequesting
                                              ? CircularProgressIndicator()
                                              : InkWell(
                                                  onTap: () async {
                                                    await acceptBid(
                                                      widget.propertyBids[i]
                                                          .propertyId,
                                                      widget.user.id,
                                                      widget.propertyBids[i]
                                                          .usersId,
                                                      widget.propertyBids[i]
                                                          .price,
                                                      widget.propertyBids[i],
                                                    );
                                                  },
                                                  child: Icon(
                                                    Icons.check_circle,
                                                    size: 17,
                                                    color: Colors.green,
                                                  ))),
                                    ),
                                  )),
                          ]),
                      ]),
                ),
              ],
            ),
          );
  }

  GlobalKey<FormState> _formKey3;

  showActionSheet(PropertyBids bidData, user_id, bidfunction) {
    showAdaptiveActionSheet(
      context: context,
      title: const Text('Action'),
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: Text(
              'Edit',
              style: TextStyle(
                color: darkTheme["redText"],
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();

              var data = await editBid(
                  bidData.bidPrice,
                  bidData.id,
                  bidData.propertyId,
                  user_id,
                  context,
                  _formKey3, (context, bidPrice, id, propertyId, user_id) {
                editPropBid(context, bidPrice, id, propertyId, user_id);
              });
              if (data) {
                bidfunction();
              }
            }),
        BottomSheetAction(
            title: const Text('Delete'),
            onPressed: () {
              Navigator.of(context).pop();
              deleteBids(
                  bidData.id, bidData.propertyId, bidData.usersId, bidfunction);
            }),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }

  bool isLoading = false;

  acceptBid(
      property_id, user_id, owner_id, price, PropertyBids propertyBids) async {
    if (isRequesting) {
      showToast("Too many requests please wait");
      return;
    }
    setState(() {
      isRequesting = true;
    });
    var request = {
      'property_id': property_id,
      'seller_id': owner_id,
      'buyer_id': user_id,
      'price': price,
      'bid_id': propertyBids.id
    };
    // setState(() {
    //   isLoading = true;
    // });
    var data = await acceptPropertyBidService(request);
    setState(() {
      isRequesting = false;
    });
    if (data != null) {
      playHammerAudio();
      setState(() {
        isRequesting = true;
      });
      var xdata =
          await Navigator.pushNamed(context, 'portfolio', arguments: "1");
      setState(() {
        isRequesting = false;
      });
    } else {
      playStopSound();
    }
    widget.bidfunc();
  }

  editPropBid(context, bidPrice, id, propertyId, user_id) async {
    if (isRequesting) {
      showToast("Too many requests please wait");
      playStopSound();
      return;
    }
    var request = {
      "property_id": propertyId,
      "bid_id": id,
      "bid_price": bidPrice
    };
    setState(() {
      isRequesting = true;
    });
    var res = await editBidProperty(request);
    setState(() {
      isRequesting = false;
    });
    if (res["ResponseCode"] == 1) {
      playBidSound();
      widget.bidfunc();
      // Navigator.of(context).pop();
    }
  }

  //
  bidProp(cont, propertyList, userId, bidPrice) async {
    print('bid Price' + bidPrice);
    if (isRequesting) {
      showToast("Too many requests please wait");
      playStopSound();
      return;
    }
    if (!isNumeric(bidPrice)) {
      showToast("invalid bid price");
      playWarningSound();
      return;
    }
    if (bidPrice.length < 1) {
      showToast("price cannot be empty");
      playStopSound();
      return;
    }
    if (int.tryParse(bidPrice) < int.tryParse(propertyList.minimumOffer)) {
      playStopSound();
      showToast("You must offer at least " + propertyList.minimumOffer);
      return;
    }
    setState(() {
      isRequesting = true;
    });
    var request = {
      "property_id": propertyList.id,
      "users_id": userId,
      "biderId": propertyList.usersId,
      "maximum_price": propertyList.maximumOffer,
      "bid_price": bidPrice
    };
    ProgressDialog progress =
        showProgressDialog(ProgressDialog(context, isDismissible: false));
    // /bid_property
    var response = await postRequest(BID_PROPERTY,request);
    progress.hide();
    setState(() {
      isRequesting = false;
    });
    if (response != null) {
      if (response["ResponseCode"] == 1) {
        playBidSound();
        // Navigator.of(context).pop();

        if (int.tryParse(propertyList.maximumOffer) == int.tryParse(bidPrice)) {
          if (isRequesting) {
            // Navigator.of(context).pop();
            widget.bidfunc();
          }
          // setState(() {
          //   isRequesting = true;
          // });
          var a =
              await Navigator.pushNamed(context, 'portfolio', arguments: "1");
          // setState(() {
          //   isRequesting = false;
          // });
        }
      } else if (response["ResponseCode"] == 2) {
        showWalletActionSheet(context);
        // showToast("property doesn't exist");
      }
    } else {
      // showToast("property doesn't exist");
    }
  }

  deleteBids(String id, String propertyId, String usersId, bidfunction) async {
    if (isRequesting) {
      showToast("Too many requests please wait");
      playStopSound();
      return;
    }
    var request = {
      "property_id": propertyId,
      "bid_id": id,
      "users_id": usersId
    };
    ProgressDialog progress =
        showProgressDialog(ProgressDialog(context, isDismissible: false));
    var res = await deleteBidProperty(request);

    progress.hide();
    setState(() {
      isRequesting = false;
    });
    if (res == null) {
      bidfunction();
      return;
    }
    if (res["ResponseCode"] == 1) {
      playBidSound();
      bidfunction();
    }
  }
}

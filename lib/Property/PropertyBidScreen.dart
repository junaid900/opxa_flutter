import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/EmptyLayout.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/PropertyAsset.dart';
import 'package:qkp/Model/PropertyBids.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';
import 'package:intl/intl.dart';
import '../CustomeElivatedButton.dart';
import '../Constraint/globals.dart' as global;
import '../main.dart';

class PropertyBidWidget extends StatefulWidget {
  @override
  _PropertyBidWidgetState createState() => _PropertyBidWidgetState();
}

Future<dynamic> myBackgroundMessageHandler(Map<String, dynamic> message) async {
  var formatter = NumberFormat.compact(locale: 'eu');
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

class _PropertyBidWidgetState extends State<PropertyBidWidget> with RouteAware {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  List<PropertyBids> propertyBids = [];
  PropertyAsset propertyAsset;
  Function onPreStateChanged;
  User user;
  FirebaseMessaging _firebaseMessaging;
  bool _initialized = false;
  bool _error = false;
  bool isTopLoading = false;
  bool isIntranferRequest = false;


  setPageData(data) {
    setState(() {
      propertyAsset = data["asset"];
      onPreStateChanged = data["onChanged"];
    });
  }



  // getPageData() async {
  //   // getPageData();
  //
  // }
  getPageData() async {

    if (propertyAsset == null) {
      await Future.delayed(Duration(milliseconds: 400));
      getPageData();
      return;
    }
    setState(() {
      isTopLoading = true;
    });
    var request = {"property_id": propertyAsset.id};
    print(request);
    var data = await getBidPropertyList(request);
    if (data != null) {
      var propertyBidsMapList = data["list"]["bids"];
      propertyBids.clear();
      for (int i = 0; i < propertyBidsMapList.length; i++) {
        propertyBids.add(PropertyBids.fromJson(propertyBidsMapList[i]));
      }
      setState(() {
        propertyBids = propertyBids;

      });
      user = await getUser();
    } else {}
    setState(() {
      isTopLoading = false;
    });
  }

  @override
  void initState() {
    getPageData();
    super.initState();
  }
  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }
  @override
  void didPopNext() {
    fcmInit();
  }


  void FCMMesseging(message) {
    print("onMessage Property Market: $message");
    getPageData();
    onNotificationReceive(context,data: {"message":message});

  }
  @override
  void didChangeDependencies() {
    fcmInit();
    routeObserver.subscribe(this, ModalRoute.of(context));
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }



  @override
  Widget build(BuildContext context) {
    var data = ModalRoute.of(context).settings.arguments;
    setPageData(data);
    return Scaffold(
      appBar: AppBar(
        title: Text("Property Bids"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: isTopLoading?LinearProgressIndicator():SizedBox(),
        ),
      ),
      body: Container(
        color: darkTheme["primaryBackgroundColor"],
        width: getWidth(context),
        height: getHeight(context),
        child: propertyBids.length > 0
            ? SingleChildScrollView(
                child: Column(
                  children: List.generate(propertyBids.length, (index) {
                    return PropertyBidItemWidget(
                      asset: propertyAsset,
                      onStateChanged: onPreStateChanged,
                      propertyBid: propertyBids[index],
                      user: user,
                      refresh: () {
                        getPageData();
                      },
                    );
                  }),
                ),
              )
            : Center(
                child: EmptyLayoutWidget(
                  message: "Waiting for bids",
                ),
              ),
      ),
    );
  }
}

class PropertyBidItemWidget extends StatefulWidget {
  PropertyAsset asset;
  PropertyBids propertyBid;
  User user;
  final onStateChanged;
  final refresh;

  PropertyBidItemWidget(
      {this.asset,
      this.onStateChanged,
      this.propertyBid,
      this.user,
      this.refresh});

  @override
  _PropertyBidItemWidgetState createState() => _PropertyBidItemWidgetState();
}

class _PropertyBidItemWidgetState extends State<PropertyBidItemWidget> {
  bool isIntranferRequest = false;
  acceptBid(PropertyAsset propertyAsset, PropertyBids propertyBids) async {
    print(isIntranferRequest);
    if(isIntranferRequest){
      showToast("too many request please wait....");
      return;
    }
    isIntranferRequest = true;
    var request = {
      'property_id': propertyAsset.id,
      'seller_id': widget.user.id,
      'buyer_id': propertyBids.usersId,
      'price': propertyAsset.price,
      'bid_id': propertyBids.id,
    };
    var data = await acceptPropertyBidService(request);
    isIntranferRequest = false;
    if(data != null){
      Navigator.of(context).pop();
    }

    // widget.refresh();
    // widget.onStateChanged();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.compact(locale: 'eu');
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
                  // left: BorderSide(
                  //   color: darkTheme["secondaryColor"],
                  //   style: BorderStyle.solid,
                  //   width: 7,
                  // ),
                  ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                              child: Text(
                                //  widget.asset.price + " PKR",
                               widget.asset.price,
                                // widget.asset.price + " PKR",

                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.asset.propertyName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                // SizedBox(width: 8),
                                // Icon(
                                //   Icons.circle,
                                //   color: Colors.grey,
                                //   size: 8,
                                // )
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                // SizedBox(width: 20,),
                                Flexible(
                                  child: Text(
                                    widget.propertyBid.userName,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.green[300],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                                // SizedBox(width: 8),
                                // Icon(
                                //   Icons.circle,
                                //   color: Colors.grey,
                                //   size: 8,
                                // )
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Row(
                              children: [
                                Text(
                                  "Bid Price",
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500),
                                ),
                                SizedBox(
                                  width: 20,
                                ),
                                Flexible(
                                  child: Text(
                                   widget.propertyBid.bidPrice +
                                        " PKR",
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Colors.blue[300],
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
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
                            // Flex(
                            //   direction: Axis.horizontal,
                            //   children: [
                            //     Expanded(
                            //       flex: 1,
                            //       child: Row(
                            //         children: [
                            //           Icon(
                            //             FontAwesomeIcons.bed,
                            //             color: Colors.white,
                            //             size: 15,
                            //           ),
                            //           SizedBox(
                            //             width: 10,
                            //           ),
                            //           Text(
                            //             widget.asset.bedRooms + " Beds",
                            //             style: TextStyle(
                            //               color: Colors.white,
                            //               fontSize: 13,
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //     Expanded(
                            //       flex: 1,
                            //       child: Row(
                            //         children: [
                            //           Icon(
                            //             FontAwesomeIcons.shower,
                            //             color: Colors.white,
                            //             size: 15,
                            //           ),
                            //           SizedBox(
                            //             width: 4,
                            //           ),
                            //           Text(
                            //             widget.asset.bathRooms + " Baths",
                            //             style: TextStyle(
                            //               color: Colors.white,
                            //               fontSize: 13,
                            //             ),
                            //           )
                            //         ],
                            //       ),
                            //     ),
                            //   ],
                            // )
                          ],
                        )),
                    Expanded(
                        flex: 1,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            "https://images.pexels.com/photos/186077/pexels-photo-186077.jpeg?auto=compress&cs=tinysrgb&dpr=1&w=500",
                            width: 140,
                            height: 81,
                            fit: BoxFit.cover,
                          ),
                        ))
                  ],
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                  // width: getWidth(context)/2.5,
                  width: getWidth(context) * .44,
                  child: CustomeElivatedButtonWidget(
                    onPress: () {
                      acceptBid(widget.asset, widget.propertyBid);
                    },
                    name: "Accept",
                    color: Colors.green,
                  ),
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

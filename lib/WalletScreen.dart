import 'dart:ffi';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:countup/countup.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:qkp/CircularInputField.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/CustomeElivatedButton.dart';
import 'package:qkp/Model/Transaction.dart';

import 'BottomTabNavigation.dart';
import 'CommensModel.dart';
import 'Constraint/Dialog.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/TopupHistory.dart';
import 'Model/User.dart';
import 'Network/constant.dart';
import 'Network/network.dart';
import 'package:intl/intl.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';


class WalletWidget extends StatefulWidget {
  final openDrawer;
  final closeDrawer;

  WalletWidget({this.openDrawer, this.closeDrawer});

  @override
  _WalletWidgetState createState() => _WalletWidgetState();
}

class _WalletWidgetState extends State<WalletWidget> with RouteAware {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  User user;
  String availableAmount;
  String availableBids;
  bool isTopLoading = false;
  List<Transaction> historyList = [];
  FirebaseMessaging _firebaseMessaging;


  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    walletAmount();
  }

  walletAmount() async {
    setState(() {
      isTopLoading = true;
    });
    var res = await userWalletAmount(user.id);
    if(res == null){
      return;
    }
    print("res" + res.toString());
    if (res["ResponseCode"] == 1) {
      this.availableAmount = res["walletAmount"]["available_amount"].toString();
      this.availableBids = res["walletAmount"]["action_counter"].toString();
      // history
      var historyMapList = res["history"];
      historyList.clear();
      for (int i = 0; i < historyMapList.length; i++) {
        Transaction transaction = new Transaction();
        transaction.fromJson(historyMapList[i]);
        setState(() {
          historyList.add(transaction);
        });
      }
      setState(() {
        historyList = historyList;
      });
      setState(() {
        availableAmount = availableAmount;
        availableBids = availableBids;
      });
    } else {
      setState(() {
        // assetsQty = '';
      });
    }
    setState(() {
      isTopLoading = false;
    });
    // topuphistory();
  }

  topuphistory() async {
  // /
  }


  @override
  void initState() {
    getPageData();
    super.initState();
  }
  @override
  void didPopNext() {
    fcmInit();
    getPageData();
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
    routeObserver.subscribe(this, ModalRoute.of(context));
    fcmInit();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text("Wallet")),
        // leading: IconButton(
        //   onPressed: () {
        //     widget.openDrawer();
        //   },
        //   icon: Icon(Icons.menu),
        // ),
        actions: [
          FlatButton(onPressed: (){
            showAdaptiveActionSheet(context: context, actions: [
              BottomSheetAction(title: Text("Bank Deposit"), onPressed: () async {
                Navigator.of(context).pop();

                Navigator.pushNamed(context, "direct_deposit");
              }),
              BottomSheetAction(title: Text("Online Deposit"), onPressed: () async {
                Navigator.of(context).pop();
               showDialog(context: context,builder: (BuildContext context){
                 String amount = "0";
                 return AlertDialog(
                   backgroundColor: darkTheme['primaryBackgroundColor'],
                   content: Container(
                     height: 150,
                     color: darkTheme['primaryBackgroundColor'],
                     child: Column(
                       children: [
                        Text("Online Deposit JAZZ CASH",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold
                        ),),
                         SizedBox(height: 20,),
                         CircularInputField(
                           hintText:"Enter Amount",
                           onChanged: (val){
                             amount = val;
                           },
                         ),
                         CustomeElivatedButtonWidget(
                           name: "Done",
                           onPress: (){
                             if(convertToDouble(amount) < 1){
                               showToast("amount enter amount");
                               return;
                             }
                             Navigator.of(context).pop();
                             Navigator.pushNamed(context, "online_deposit",arguments:{"amount":amount});
                           },
                         ),
                       ],
                     ),
                   ),
                 );
               });
              })
            ]);
          }, child: Text("Deposit",
          style: TextStyle(
            color: Colors.white
          ),))
        ],
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
            child: Wrap(
              children: [
                Container(
                  width: getWidth(context),
                  margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                  // height: getHeight(context) * .23,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: AssetImage("assets/images/bgwallet.png"),
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(28, 35, 28, 0),
                    child: Wrap(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Total Wallet Balance",
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              "PKR",
                              style: TextStyle(
                                  color: Color.fromRGBO(23, 193, 40, 1.0)),
                            )
                          ],
                        ),
                        SizedBox(height: 25),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Countup(
                                  begin: 0,
                                  end: availableAmount?.length != null
                                      ? double.tryParse(availableAmount)
                                      : 0,
                                  duration: Duration(seconds: 3),
                                  separator: ',',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  " PKR",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0, 18, 0, 0),
                            child: Text(
                              "Number of Bids",
                              style: TextStyle(color: Colors.white),
                            )),
                        TouchableOpacity(
                          onTap: (){
                              Navigator.pushNamed(context, "convert_bids",arguments: {"action_counter":availableBids.toString()});
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Countup(
                                begin: 0,
                                end: availableBids?.length != null
                                    ? double.tryParse(availableBids)
                                    : 0,
                                duration: Duration(seconds: 3),
                                separator: ',',
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                flex:1,
                                child: ElevatedButton(
                                    onPressed: () async {
                                      await Navigator.pushNamed(context, 'packages');
                                      walletAmount();
                                      topuphistory();
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
                                    child:
                                    Text("Top Up", style: TextStyle(fontSize: 15))),
                              ),
                              Expanded(child: Padding(
                                padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
                                child: CustomeElivatedButtonWidget(
                                  name: "Withdraw",
                                  color:  darkTheme['secondaryColor'],
                                  onPress: (){
                                    showActionSheet();
                                    // topuphistory();
                                  },
                                ),
                              )),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                Wrap(
                  children: [
                    Container(
                      width: getWidth(context),
                      height: getHeight(context) * .58,
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      decoration: BoxDecoration(
                        color: darkTheme["walletBackground"],
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25)),
                      ),
                      child: ListView.builder(
                        itemCount: historyList.length,
                        itemBuilder: (context, index) {
                          return historyList.length > 0 &&
                                  historyList[index] != null
                              ?  WalletTransactionItem(history: historyList[index])
                              : Container();
                        },
                      ),
                    ),
                  ],
                ),


                SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
          if(isTopLoading)
          AppLoadingScreen(backgroundOpactity: .7,),

        ],
      ),
    );
  }
  showActionSheet() {
    // Navigator.of(cont).pop();
    showAdaptiveActionSheet(
      context: context,
      title: const Text(
        "Note: you can withdraw wallet amount or bids.",
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      ),
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: const Text("Amount"),
            onPressed: () async {

              Navigator.of(context).pop();
              Navigator.pushNamed(context, "withdraw",arguments: availableAmount);
              walletAmount();
              // var a = await Navigator.of(context).pushNamed('wallet');
              // if (data != null) {
              //   if (data["func"] != null) {
              //     var func = data['func'];
              //     func();
              //   }
              // }
              // Navigator.of(cont);
            }),
        BottomSheetAction(
            title: const Text("Bids"),
            onPressed: () async {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "convert_bids",arguments: {"action_counter":availableBids.toString()});
              // if (data != null) {
              //   if (data["func"] != null) {
              //     var func = data['func'];
              //     func();
              //   }
              // }
              // Navigator.of(cont);
            }),
      ],
      cancelAction: CancelAction(
        title: const Text('Cancel',),
      ),
    );
  }
}

class WalletTransactionItem extends StatefulWidget {
  Transaction history;

  WalletTransactionItem({this.history});

  @override
  _WalletTransactionItemState createState() => _WalletTransactionItemState();
}

class _WalletTransactionItemState extends State<WalletTransactionItem> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery
        .of(context)
        .size
        .width;
    var _height = MediaQuery
        .of(context)
        .size
        .height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    // color: Colors.blue,
                    margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
                    padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
                    decoration: BoxDecoration(
                      color: darkTheme["bgArrow"],
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Column(
                      children: [
                        Image.asset('assets/images/top-arrow.png'),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Your Account has been debited with the amount.",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          new DateFormat("dd MMMM yyyy")
                              .format(DateTime.parse(widget.history.dateAdded)),
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.history.price + " PKR",
                    style: TextStyle(
                        fontSize: 14,
                        color: darkTheme["secondaryColor"],
                        fontWeight: FontWeight.w700),
                  )
                ],
              ),
              SizedBox(
                height: 12,
              ),
              Divider(
                height: 5,
                thickness: 2,
                color: darkTheme["dividerColor"],
              ),
            ],
          ),
        ),
      ),
    );
  }
}


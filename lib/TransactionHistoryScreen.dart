import 'package:flutter/material.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Model/AccountStatementModel.dart';
import 'package:qkp/Model/Transaction.dart';
import 'package:qkp/Model/UserAccountStatment.dart';
import 'package:qkp/Network/URLS.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/User.dart';
import 'Network/network.dart';
import 'package:intl/intl.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';

class TransactionHistory extends StatefulWidget {
  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory> with RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  User user;
  List<UserAccountStatment> historyList = [];
  bool isLoading = false;

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    topuphistory();
  }

  topuphistory() async {
    setState(() {
      isLoading = true;
    });
    print(user.id);
    var res = await getRequest(TRANSACTION_HISTROY + "?user_id=" + user.id);
    setState(() {
      isLoading = false;
    });
    print("res" + res.toString());
    if (res == null) {
      return;
    }
    if (res["ResponseCode"] == 1) {
      var historyMapList = res["History"];
      for (int i = 0; i < historyMapList.length; i++) {
        historyList.add(UserAccountStatment.fromJson(historyMapList[i]));
      }
      setState(() {
        historyList = historyList;
      });
    } else {
      setState(() {});
    }
  }

  @override
  void initState() {
    getPageData();
    // TODO: implement initState
    super.initState();
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
    getPageData();
    onNotificationReceive(context, data: {"message": message});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Account Statement")),
        body: Container(
          color: isDarkTheme
              ? darkTheme["primaryBackgroundColor"]
              : lightTheme["primaryBackgroundColor"],
          child: Wrap(
            children: [
              Container(
                width: getWidth(context),
                height: getHeight(context),
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: BoxDecoration(
                  color: darkTheme["walletBackground"],
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        children: [
                          if (!isLoading)
                            Table(children: [
                              TableRow(
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                    color: Colors.white,
                                  )),
                                  children: [
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Date",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Description",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Debit",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Credit",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 4,
                                        ),
                                        Text(
                                          "Current",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                        SizedBox(
                                          height: 4,
                                        ),
                                      ],
                                    ),
                                  ]),
                              // TableRow(children: [
                              //   Column(
                              //     children: [
                              //       Divider(
                              //         color: Colors.white,
                              //       )
                              //     ],
                              //   )
                              // ]),
                              for (int index = 0;
                                  index < historyList.length;
                                  index++)
                                TableRow(
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom:
                                                BorderSide(color: Colors.white),
                                            left:
                                                BorderSide(color: Colors.white),
                                            right: BorderSide(
                                                color: Colors.white))),
                                    children: [
                                      // SizedBox(height: 2,),
                                      Center(
                                        child: Text(
                                          historyList[index].createdAt,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 2,),
                                      // SizedBox(height: 2,),
                                      Center(
                                        child: Text(
                                          historyList[index].description,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        ),
                                      ),
                                      // SizedBox(height: 2,),
                                      // SizedBox(height: 2,),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Center(
                                          child: Text(
                                            historyList[index].debit,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 2,),
                                      // SizedBox(height: 2,),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Center(
                                          child: Text(
                                            historyList[index].credit,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 2,),
                                      // SizedBox(height: 2,),
                                      Container(
                                        padding: EdgeInsets.all(10),
                                        child: Center(
                                          child: Text(
                                            historyList[index].current,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        ),
                                      ),
                                      // SizedBox(height: 2,),
                                    ])
                            ]),
                          SizedBox(
                            height: 200,
                          )
                        ],
                      ),
                    ),
                    // ListView.builder(
                    //   itemCount: historyList.length,
                    //   itemBuilder: (context, index) {
                    //     return historyList.length > 0 &&
                    //             historyList[index] != null
                    //         ? WalletTransactionItem(history: historyList[index])
                    //         : Container();
                    //   },
                    // ),
                    if (isLoading)
                      AppLoadingScreen(
                        backgroundOpactity: .6,
                      )
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class WalletTransactionItem extends StatefulWidget {
  UserAccountStatment history;

  WalletTransactionItem({this.history});

  @override
  _WalletTransactionItemState createState() => _WalletTransactionItemState();
}

class _WalletTransactionItemState extends State<WalletTransactionItem> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
      child: Container(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //   children: [
              //     Container(
              //       // color: Colors.blue,
              //       margin: EdgeInsets.fromLTRB(0, 0, 10, 0),
              //       padding: EdgeInsets.fromLTRB(16, 14, 16, 14),
              //       decoration: BoxDecoration(
              //         color: darkTheme["bgArrow"],
              //         borderRadius: BorderRadius.all(Radius.circular(25)),
              //       ),
              //       child: Column(
              //         children: [
              //           Image.asset('assets/images/top-arrow.png'),
              //         ],
              //       ),
              //     ),
              //     Expanded(
              //       child: Column(
              //         mainAxisAlignment: MainAxisAlignment.start,
              //         crossAxisAlignment: CrossAxisAlignment.start,
              //         children: [
              //           Text(
              //             "Your Account has been debited with the amount.",
              //             style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.w500),
              //           ),
              //           Text(
              //               widget.history.createdAt!=null?new DateFormat("dd MMMM yyyy").format(DateTime.parse(widget.history.createdAt)):"",
              //             style: TextStyle(fontSize: 10, color: Colors.white),
              //           ),
              //         ],
              //       ),
              //     ),
              //     Column(
              //       children: [
              //         Text(
              //           widget.history.debit+" PKR DB",
              //           style: TextStyle(fontSize: 14, color: darkTheme["secondaryColor"],fontWeight: FontWeight.w700),
              //         ),
              //         Text(
              //           widget.history.credit+" PKR CR",
              //           style: TextStyle(fontSize: 14, color: darkTheme["secondaryColor"],fontWeight: FontWeight.w700),
              //         ),
              //       ],
              //     )
              //   ],
              // ),
              // SizedBox(height: 12,),
              // Divider(height: 5,thickness: 2,color:darkTheme["dividerColor"],),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';
import 'package:intl/intl.dart';
import 'Constraint/globals.dart' as global;
import 'Model/AccountStatementModel.dart';
import 'main.dart';

class AccountStatement extends StatefulWidget {
  @override
  _AccountStatementState createState() => _AccountStatementState();
}

class _AccountStatementState extends State<AccountStatement> with RouteAware {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  User user;
  List<AccountStatementModel> historyList = [];

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    accounthistory();
  }

  accounthistory() async {
    var res = await accountHistory(user.id);
    print("res" + res.toString());
    if (res["ResponseCode"] == 1) {
      var historyMapList = res["AccountStatement"];
      print("res" + historyMapList.toString());
      for (int i = 0; i < historyMapList.length; i++) {
        AccountStatementModel transaction = new AccountStatementModel();
        transaction.fromJson(historyMapList[i]);
       // setState(() {
          historyList.add(transaction);
      //  });
      }
      setState(() {
        historyList = historyList;
      });
      print(historyList.length);
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
          child: Column(
            children: [
              Flexible(
                child: ListView.builder(
                  itemCount: historyList.length,
                  itemBuilder: (context, index) {
                    return historyList.length > 0 && historyList[index] != null
                        ? AccountTransactionItem(history: historyList[index])
                        : Container();
                  },
                ),
              ),
            ],
          ),
        ));
  }
}
class AccountTransactionItem extends StatefulWidget {
  AccountStatementModel history;
  AccountTransactionItem({this.history});
  @override
  _AccountTransactionItemState createState() => _AccountTransactionItemState();
}

class _AccountTransactionItemState extends State<AccountTransactionItem> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0.0, 0, 0, 0),
      child: Container(
        width: getWidth(context),
        height: getHeight(context),
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
        decoration: BoxDecoration(
          color: darkTheme["walletBackground"],
          borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children:[
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
                          style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.w500),
                        ),
                        Text(
                          new DateFormat("dd MMMM yyyy").format(DateTime.parse(widget.history.createdAt)),
                          style: TextStyle(fontSize: 10, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    widget.history.debit+" PKR",
                    style: TextStyle(fontSize: 14, color: darkTheme["secondaryColor"],fontWeight: FontWeight.w700),
                  )
                ],
              ),
              SizedBox(height: 12,),
              Divider(height: 5,thickness: 2,color:darkTheme["dividerColor"],),
            ],
          ),
        ),
      ),
    );
  }
}


import 'package:flutter/material.dart';
import 'package:qkp/Model/PackageLog.dart';
import 'package:qkp/Model/Transaction.dart';
import 'package:qkp/Network/constant.dart';

import 'Constraint/AppLoadingScreen.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/User.dart';
import 'Network/network.dart';
import 'package:intl/intl.dart';
import 'Constraint/globals.dart' as global;

import 'main.dart';
class PackageLogHistoryWidget extends StatefulWidget {
  @override
  _PackageLogHistoryWidgetState createState() => _PackageLogHistoryWidgetState();
}

class _PackageLogHistoryWidgetState extends State<PackageLogHistoryWidget> with RouteAware {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  User user;
  List<PackageLog> historyList = [];
  bool isLoading = false;
  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    topuphistory();
  }

  topuphistory() async {
    var request = {"user_id": user.id};
    print(request);
    setState(() {
      isLoading = true;
    });
    var res = await getPackageLogReportService(request);
    setState(() {
      isLoading = false;
    });
    if(res == null){
      return;
    }
    print("res" + res.toString());
    if (res["ResponseCode"] == 1) {
      var historyMapList = res["list"];
      for (int i = 0; i < historyMapList.length; i++) {
       historyList.add(PackageLog.fromJson(historyMapList[i]));
      }

        setState(() {
          historyList = historyList;
        });
      // } else {
      //   setState(() {});
      // }
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
        appBar: AppBar(title: Text("Package Log")),
        body: Container(
          color: isDarkTheme
              ? darkTheme["primaryBackgroundColor"]
              : lightTheme["primaryBackgroundColor"],
          child: Wrap(
            children: [
              Container(
                width: getWidth(context),
                height: getHeight(context)*.90,
                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                decoration: BoxDecoration(
                  color: darkTheme["walletBackground"],
                  borderRadius: BorderRadius.only(topLeft: Radius.circular(25),topRight: Radius.circular(25)),
                ),
                child: Stack(
                  children: [
                    ListView.builder(
                      itemCount: historyList.length,
                      itemBuilder: (context, index) {
                        return historyList.length > 0 && historyList[index] != null
                            ? PackageLogItem(history: historyList[index])
                            : Container();
                      },
                    ),
                    if(isLoading)
                      AppLoadingScreen(backgroundOpactity: .6,)
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}

class PackageLogItem extends StatefulWidget {
  PackageLog history;
  PackageLogItem({this.history});
  @override
  _PackageLogItemState createState() => _PackageLogItemState();
}

class _PackageLogItemState extends State<PackageLogItem> {
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
                        widget.history.type == "Added"?Icon(Icons.arrow_upward,color: Colors.white,size: 20,):Icon(Icons.arrow_downward_outlined,color: Colors.white,size: 20,),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.history.description,
                          style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.w500),
                        ),
                        Text(
                          widget.history.logDescription!=null?widget.history.logDescription:"",
                          style: TextStyle(fontSize: 12, color: Colors.white,fontWeight: FontWeight.w500),
                        ),
                        Text(
                          widget.history.logBids!=null?widget.history.logBids + " Bids "+widget.history.type:"",
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
                    widget.history.price+" PKR",
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


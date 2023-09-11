import 'package:flutter/material.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/WithdrawHistory.dart';
import 'package:qkp/Network/URLS.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'Model/User.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';

class WithdrawReportWidget extends StatefulWidget {
  @override
  _WithdrawReportWidgetState createState() => _WithdrawReportWidgetState();
}

class _WithdrawReportWidgetState extends State<WithdrawReportWidget> with RouteAware {
  User user;
  List<WithdrawHistory> dataSet = [];
  bool isLoading = true;

  getPageData() async {
    user = await getUser();
    var response = await getRequest(WITHDRAW_REPORT + "?user_id=" + user.id);
    if (response != null) {
      var listMap = response["History"];
      for (int i = 0; i < listMap.length; i++) {
        dataSet.add(WithdrawHistory.fromJson(listMap[i]));
      }
      setState(() {
        dataSet = dataSet;
      });
    }
    setState(() {
      isLoading = false;
    });
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
      backgroundColor: darkTheme["primaryBackgroundColor"],
      appBar: AppBar(
        title: Text("Withdraw Report"),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SingleChildScrollView(
              child: Container(
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'ID',
                          style:
                          TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Date',
                          style:
                          TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Bank Name',
                          style:
                          TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Account No',
                          style:
                          TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Amount',
                          style:
                          TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Detail',
                          style:
                          TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Status',
                          style:
                          TextStyle(
                              fontStyle: FontStyle.italic, color: Colors.white),
                        ),
                      ),
                    ],
                    rows: List.generate(
                        dataSet.length,
                            (index) {
                          return DataRow(cells: [
                            DataCell(Text("Ref-${dataSet[index].id}",
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text("${dataSet[index].dateAdded}",
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text("${dataSet[index].bankName}",
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text("${dataSet[index].accountNo}",
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text("${dataSet[index].amount}",
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text("${dataSet[index].detail}",
                                style: TextStyle(color: Colors.white))),
                            DataCell(Text("${dataSet[index].requestStatus}",
                                style: TextStyle(color: Colors.white))),
                          ]);
                        }),
                  )),
            ),
          ),
          if(isLoading)
            AppLoadingScreen(backgroundOpactity: .6,),
        ],
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';
import 'main.dart';
import 'Constraint/globals.dart' as global;

class AreaWiseTradeReport extends StatefulWidget {
  @override
  _AreaWiseTradeReportState createState() => _AreaWiseTradeReportState();
}

class _AreaWiseTradeReportState extends State<AreaWiseTradeReport> with RouteAware{
  Map marketWatchVar = Map();
  Map marketWatchProVar = Map();
  bool isLoading = false;
  Map fileCitiesTotal = Map();
  Map propertyCitiesTotal = Map();
  List<String> levels = ["Level 1", "Level 2"];
  String currentLevel = "Level 1";
  String startDate = "";
  String endDate = "";

  // bool isLoading = false;

  getPageData() async {
    setState(() {
      isLoading = true;
    });

    var res = await areaWiseTradeService(startDate, endDate);
    setState(() {
      isLoading = false;
    });
    print(res.toString());
    if (res != null) if (res["ResponseCode"] == 1) {
      var watchMarketMapList = res["trade"]["file"];
      var watchMarketPropertyMapList = res["trade"]["property"];
      // print(fileCitiesTotal);
      // print(propertyCitiesTotal);
      setState(() {
        marketWatchVar = watchMarketMapList;
        marketWatchProVar = watchMarketPropertyMapList;
      });
    }
  }

  @override
  void initState() {
    this.getPageData();
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
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(title: Text("Area Wise Trade Report")),
      body: Stack(
        children: [
          Container(
              decoration:
                  BoxDecoration(color: darkTheme["primaryBackgroundColor"]),
              width: _width,
              height: _height,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Phases",
                              style: TextStyle(
                                color: darkTheme["secondaryColor"],
                              )),
                          DropdownButton<String>(
                            isExpanded: true,
                            value: currentLevel,
                            icon: Icon(Icons.backpack),
                            hint: Text("Select Phase"),
                            dropdownColor: darkTheme["cardBackground"],
                            items: levels.map((String val) {
                              return new DropdownMenuItem<String>(
                                value: val,
                                child: new Text(
                                  val,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (_) {
                              print("phase => " + _);
                              setState(() {
                                currentLevel = _;
                              });
                              // filter();
                            },
                          ),
                          Flex(
                            direction: Axis.horizontal,
                            children: [
                              Expanded(
                                flex: 1,
                                child: FlatButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime:
                                              DateTime(2000, 3, 5, 0, 0, 0),
                                          maxTime: DateTime.now(),
                                          onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (date) {
                                        print('confirm $date');
                                        setState(() {
                                          startDate = date.year.toString() +
                                              "-" +
                                              date.month.toString() +
                                              "-" +
                                              date.day.toString();
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Column(
                                      children: [
                                        Text("Start Date",
                                            style: TextStyle(
                                                color: darkTheme[
                                                    "secondaryColor"])),
                                        Text(
                                          startDate,
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    )),
                              ),
                              Expanded(
                                flex: 1,
                                child: FlatButton(
                                    onPressed: () {
                                      DatePicker.showDatePicker(context,
                                          showTitleActions: true,
                                          minTime:
                                              DateTime(2000, 3, 5, 0, 0, 0),
                                          maxTime: DateTime.now(),
                                          onChanged: (date) {
                                        print('change $date');
                                      }, onConfirm: (date) {
                                        print('confirm $date');
                                        setState(() {
                                          endDate = date.year.toString() +
                                              "-" +
                                              date.month.toString() +
                                              "-" +
                                              date.day.toString();
                                        });
                                      },
                                          currentTime: DateTime.now(),
                                          locale: LocaleType.en);
                                    },
                                    child: Column(
                                      children: [
                                        Text("End Date",
                                            style: TextStyle(
                                                color: darkTheme[
                                                    "secondaryColor"])),
                                        Text(
                                          endDate,
                                          style: TextStyle(color: Colors.blue),
                                        ),
                                      ],
                                    )),
                              ),
                              Expanded(
                                child: FlatButton(
                                    onPressed: () {
                                      getPageData();
                                    },
                                    color: Colors.blue,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Apply",
                                          style:
                                              TextStyle(color: Colors.white
                                              ),
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    if (marketWatchVar["cities"] != null)
                    Wrap(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Files',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: darkTheme["secondaryColor"]),
                            )),
                        Wrap(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(20),
                              child: Column(
                                children: [
                                  for (int i = 0;
                                      i < marketWatchVar["cities"].length;
                                      i++)
                                    Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                marketWatchVar["totals"]
                                                    .keys
                                                    .elementAt(i),
                                                style: TextStyle(
                                                    color: Colors.white,fontWeight:FontWeight.bold,fontSize: 17),
                                              ),
                                              Text(
                                                  marketWatchVar["totals"][
                                                      marketWatchVar["totals"]
                                                          .keys
                                                          .elementAt(i)],
                                                  style: TextStyle(
                                                      color: Colors.white,fontWeight:FontWeight.bold,fontSize: 17))
                                            ]),
                                        if(currentLevel == "Level 2")
                                        for (int j = 0;
                                            j <
                                                marketWatchVar["cities"][
                                                        marketWatchVar["totals"]
                                                            .keys
                                                            .elementAt(i)]
                                                    .length;
                                            j++)
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                marketWatchVar["cities"][
                                                        marketWatchVar["totals"]
                                                            .keys
                                                            .elementAt(i)][j]
                                                    ["society_title"],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                  marketWatchVar["cities"][
                                                          marketWatchVar[
                                                                  "totals"]
                                                              .keys
                                                              .elementAt(i)][j]
                                                      ["society_total"],
                                                  style: TextStyle(
                                                      color: Colors.white))
                                            ],
                                          ),
                                        SizedBox(height: 6,),
                                      ],
                                    )
                                ],
                              ),
                            )
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     // Padding(
                            //     //     padding:
                            //     //         EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //     //     // child: Text(
                            //     //     //   // marketWatchVar["totals"].keys.elementAt(i),
                            //     //     //   style: TextStyle(
                            //     //     //       color:Colors.white,
                            //     //     //       fontSize: 16,
                            //     //     //       fontWeight: FontWeight.w600),
                            //     //     // )
                            //     // ),
                            //     // Padding(
                            //     //     padding:
                            //     //         EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //     //     child: Text(
                            //     //       fileCitiesTotal[marketWatchVar.keys
                            //     //                   .elementAt(i)] !=
                            //     //               null
                            //     //           ? fileCitiesTotal[marketWatchVar
                            //     //                   .keys
                            //     //                   .elementAt(i)]
                            //     //               .toString()
                            //     //           : "",
                            //     //       style: TextStyle(
                            //     //           color: Colors.white,
                            //     //           fontSize: 16,
                            //     //           fontWeight: FontWeight.w600),
                            //     //     ))
                            //   ],
                            // ),
                            // currentLevel == "Level 2"
                            //     ? SingleChildScrollView(
                            //         scrollDirection: Axis.horizontal,
                            //         child: AreaWiseDataTable(
                            //             data: marketWatchVar[marketWatchVar
                            //                 .keys
                            //                 .elementAt(i)]),
                            //       )
                            //     : SizedBox(),
                          ],
                        ),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(
                              'Properties',
                              style: TextStyle(
                                  fontSize: 18,
                                  color: darkTheme["secondaryColor"]),
                            )),
                        if(marketWatchProVar["cities"] != null)
                        Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Column(
                                children: [
                                  for (int i = 0;
                                  i < marketWatchProVar["cities"].length;
                                  i++)
                                    Column(
                                      children: [
                                        Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                marketWatchProVar["totals"]
                                                    .keys
                                                    .elementAt(i),
                                                style: TextStyle(
                                                    color: Colors.white,fontWeight:FontWeight.bold,fontSize: 17),
                                              ),
                                              Text(
                                                  marketWatchProVar["totals"][
                                                  marketWatchProVar["totals"]
                                                      .keys
                                                      .elementAt(i)].toString(),
                                                  style: TextStyle(
                                                      color: Colors.white,fontWeight:FontWeight.bold,fontSize: 17))
                                            ]),
                                        if(currentLevel == "Level 2")
                                        for (int j = 0;
                                        j <
                                            marketWatchProVar["cities"][
                                            marketWatchProVar["totals"]
                                                .keys
                                                .elementAt(i)]
                                                .length;
                                        j++)
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                marketWatchProVar["cities"][
                                                marketWatchProVar["totals"]
                                                    .keys
                                                    .elementAt(i)][j]
                                                ["society_name"],
                                                style: TextStyle(
                                                    color: Colors.white),
                                              ),
                                              Text(
                                                  marketWatchProVar["cities"][
                                                  marketWatchProVar[
                                                  "totals"]
                                                      .keys
                                                      .elementAt(i)][j]
                                                  ["society_total"].toString(),
                                                  style: TextStyle(
                                                      color: Colors.white))
                                            ],
                                          ),
                                        SizedBox(height: 6,),

                                      ],
                                    )
                                ],
                              ),
                            )
                            // Row(
                            //   mainAxisAlignment:
                            //       MainAxisAlignment.spaceBetween,
                            //   children: [
                            //     // Padding(
                            //     //     padding:
                            //     //         EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //     //     // child: Text(
                            //     //     //   // marketWatchVar["totals"].keys.elementAt(i),
                            //     //     //   style: TextStyle(
                            //     //     //       color:Colors.white,
                            //     //     //       fontSize: 16,
                            //     //     //       fontWeight: FontWeight.w600),
                            //     //     // )
                            //     // ),
                            //     // Padding(
                            //     //     padding:
                            //     //         EdgeInsets.fromLTRB(10, 10, 10, 10),
                            //     //     child: Text(
                            //     //       fileCitiesTotal[marketWatchVar.keys
                            //     //                   .elementAt(i)] !=
                            //     //               null
                            //     //           ? fileCitiesTotal[marketWatchVar
                            //     //                   .keys
                            //     //                   .elementAt(i)]
                            //     //               .toString()
                            //     //           : "",
                            //     //       style: TextStyle(
                            //     //           color: Colors.white,
                            //     //           fontSize: 16,
                            //     //           fontWeight: FontWeight.w600),
                            //     //     ))
                            //   ],
                            // ),
                            // currentLevel == "Level 2"
                            //     ? SingleChildScrollView(
                            //         scrollDirection: Axis.horizontal,
                            //         child: AreaWiseDataTable(
                            //             data: marketWatchVar[marketWatchVar
                            //                 .keys
                            //                 .elementAt(i)]),
                            //       )
                            //     : SizedBox(),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )),
          if (isLoading)
            AppLoadingScreen(
              backgroundOpactity: .6,
            ),
        ],
      ),
    );
  }
}

class AreaWiseDataTable extends StatefulWidget {
  var data = [];

  AreaWiseDataTable({this.data});

  @override
  _AreaWiseDataTableState createState() => _AreaWiseDataTableState();
}

class _AreaWiseDataTableState extends State<AreaWiseDataTable> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context),
      decoration: BoxDecoration(color: darkTheme["primaryBackgroundColor"]),
      child: DataTable(
        columns: <DataColumn>[
          DataColumn(
            label: Text(
              'Society',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: darkTheme["secondaryColor"]),
            ),
          ),
          DataColumn(
            label: Text(
              'Volume',
              style: TextStyle(
                  fontStyle: FontStyle.italic,
                  color: darkTheme["secondaryColor"]),
            ),
          ),
        ],
        rows: <DataRow>[
          for (var i = 0; i < widget.data.length; i++)
            DataRow(
              cells: <DataCell>[
                DataCell(Text(widget.data[i]["society_title"],
                    style: TextStyle(color: Colors.white))),
                DataCell(Text(widget.data[i]["qty"],
                    style: TextStyle(color: Colors.white))),
              ],
            ),
        ],
      ),
    );
  }
}

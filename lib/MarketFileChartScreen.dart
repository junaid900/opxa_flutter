import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Model/FileHistory.dart';
import 'package:qkp/Network/constant.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import 'EmptyLayout.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/MarketFiles.dart';
import 'Model/User.dart';
import 'Network/network.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';


class MarketFileChartWidget extends StatefulWidget {
  @override
  _MarketFileChartWidgetState createState() => _MarketFileChartWidgetState();
}

class _MarketFileChartWidgetState extends State<MarketFileChartWidget> with RouteAware {
  bool showAvg = true;
  MarketFiles marketFiles;
  User user;
  String selectedFilter = "1 days ago";
  bool isLoading = false;
  bool showError = false;

  //MarketFiles marketFiles;
  List<FileHistory> fileHistoryList = [];

  List<Color> gradientColors = [
    const Color(0xff23b6e6),
    const Color(0xff02d39a),
  ];

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
  }

  filterGraph(params) async {
    setState(() {
      isLoading = true;
    });
    var request = <String, dynamic>{
      "file_id": marketFiles.fileId,
      "range": params
    };

    var res = await loadFileChart(request);
    setState(() {
      isLoading = false;
    });
    print(res);
    if (res != null) {
      var fileHistoryMapList = res["Files"];
      fileHistoryList.clear();

      for (int i = 0; i < fileHistoryMapList.length; i++) {
        FileHistory fHistory = new FileHistory();
        fHistory.fromJson(fileHistoryMapList[i]);
        fileHistoryList.add(fHistory);
      }
      selectedFilter = params.toString();
      setState(() {
        fileHistoryList = fileHistoryList;
        showError = false;
      });
    } else {
      setState(() {
        showError = true;
      });
    }
  }

  loadPageData() async {
    // 1 days ago
    // 7 days ago
    // 6 months ago
    // 1 year ago
    if (marketFiles == null) {
      await Duration(milliseconds: 1000);
      loadPageData();
      return;
    }

    var request = <String, dynamic>{
      "file_id": marketFiles.fileId,
      "range": "1 days ago"
    };

    getPageData();

    //print("request--"+request.toString());
    setState(() {
      isLoading = true;
    });
    var res = await loadFileChart(request);
    setState(() {
      isLoading = false;
    });
    print(res);
    if (res != null) {
      var fileHistoryMapList = res["Files"];
      fileHistoryList.clear();
      for (int i = 0; i < fileHistoryMapList.length; i++) {
        FileHistory fHistory = new FileHistory();
        fHistory.fromJson(fileHistoryMapList[i]);
        fileHistoryList.add(fHistory);
      }
      setState(() {
        fileHistoryList = fileHistoryList;
        showError = false;
      });
    } else {
      setState(() {
        showError = true;
      });
    }
  }

  @override
  void initState() {
    loadPageData();
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
    final arguments = ModalRoute.of(context).settings.arguments;
    MarketFiles file = new MarketFiles();
    file.fromJson(arguments);

    setState(() {
      marketFiles = file;
      //    getPageData();
    });

    final List<Color> color = <Color>[];
    // color.add(Colors.blue[800]);
    color.add(Color.fromRGBO(85, 174, 238, .7));
    color.add(Color.fromRGBO(85, 174, 238, .2));
    color.add(Colors.transparent);

    final List<double> stops = <double>[];
    stops.add(0.0);
    stops.add(0.5);
    stops.add(1.0);
    final LinearGradient gradientColors = LinearGradient(
        colors: color, stops: stops, end: Alignment.bottomCenter);

    var _height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    var chartData = [];
    return Scaffold(
      appBar: AppBar(
        title: Text(file.fileName),
      ),
      body: Container(
        width: width,
        height: _height,
        color: darkTheme['primaryBackgroundColor'],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
                        child: ElevatedButton(
                          onPressed: () {
                            filterGraph("1 days ago");
                          },
                          style: ElevatedButton.styleFrom(
                            primary: darkTheme['secondaryColor'],
                          ),
                          child: Text(
                            "1 day",
                            style: TextStyle(
                                color: darkTheme['primaryTextColor'],
                                fontWeight: FontWeight.bold,fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
                        child: ElevatedButton(
                          onPressed: () => filterGraph("7 days ago"),
                          style: ElevatedButton.styleFrom(
                            primary: darkTheme['secondaryColor'],
                          ),
                          child: Text(
                            "7 days",
                            style: TextStyle(
                                color: darkTheme['primaryTextColor'],
                                fontWeight: FontWeight.bold,fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(0, 0, 3, 0),
                        child: ElevatedButton(
                          onPressed: () => filterGraph("6 months ago"),
                          style: ElevatedButton.styleFrom(
                            primary: darkTheme['secondaryColor'],
                          ),
                          child: Text(
                            "6 months",
                            style:TextStyle(
                                color: darkTheme['primaryTextColor'],
                                fontWeight: FontWeight.bold,fontSize: 13)
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: ElevatedButton(
                        onPressed: () {
                          filterGraph("1 year ago");
                        },
                        style: ElevatedButton.styleFrom(
                          primary: darkTheme['secondaryColor'],
                        ),
                        child: Text(
                          "1 Year",
                          style: TextStyle(
                              color: darkTheme['primaryTextColor'],
                              fontWeight: FontWeight.bold,fontSize: 13)
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                  height: _height / 1.3,
                  width: width,
                  child: isLoading
                      ? AppLoadingScreen(
                          backgroundOpactity: .6,
                        )
                      : showError
                          ? Center(
                              child:
                                  EmptyLayoutWidget(message: "No Data Found"),
                            )
                          : SfCartesianChart(
                              zoomPanBehavior: ZoomPanBehavior(
                                enablePinching: true,
                                // enableSelectionZooming: true,
                                enableDoubleTapZooming: true,
                                enableSelectionZooming: true,
                                selectionRectBorderWidth: 1,
                                // maximumZoomLevel: 10
                              ),
                              trackballBehavior: TrackballBehavior(
                                  enable: true,
                                  tooltipSettings: InteractiveTooltip(
                                      enable: true, color: Colors.red)),
                              tooltipBehavior: TooltipBehavior(
                                enable: true,
                              ),
                              // borderColor: Colors.red,
                              plotAreaBorderColor: Colors.transparent,
                              borderColor: Colors.transparent,
                              backgroundColor: Colors.transparent,
                              plotAreaBackgroundColor: Colors.transparent,
                              palette: [
                                Colors.red,
                                Colors.red,
                                Colors.red,
                                Colors.red,
                                Colors.red,
                              ],
                              primaryXAxis: CategoryAxis(
                                  title: AxisTitle(
                                      text: 'Time',
                                      textStyle: TextStyle(
                                          color: Colors.grey[50],
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold)),
                                  majorGridLines: MajorGridLines(
                                      width: 1,
                                      color: Colors.grey[800],
                                      dashArray: <double>[5, 5]),
                                  minorGridLines: MinorGridLines(
                                      width: 1,
                                      color: Colors.grey[800],
                                      dashArray: <double>[5, 5]),
                                  minorTicksPerInterval: 2),
                              primaryYAxis: NumericAxis(
                                  title: AxisTitle(
                                    text: "Price",
                                    textStyle: TextStyle(
                                        color: Colors.grey[50],
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12),
                                  ),
                                  majorGridLines: MajorGridLines(
                                      width: 1,
                                      color: Colors.grey[800],
                                      dashArray: <double>[5, 5])),
                              // primaryYAxis: CategoryAxis(
                              // title: AxisTitle(
                              //     text: 'Y-Axis',
                              //     textStyle: ChartTextStyle(
                              //         color: Colors.deepOrange,
                              //         fontFamily: 'Roboto',
                              //         fontSize: 16,
                              //         fontStyle: FontStyle.italic,
                              //         fontWeight: FontWeight.w300
                              //     )
                              // ),
                              // majorGridLines: MajorGridLines(
                              //     width: 1,
                              //     color: Colors.grey[800],
                              //     dashArray: <double>[5,5]
                              // ),
                              // minorGridLines: MinorGridLines(
                              //     width: 1,
                              //     color: Colors.grey[800],
                              //     dashArray: <double>[5,5]
                              // ),
                              // minorTicksPerInterval:2
                              // ),
                              series: <ChartSeries>[
                                // Renders fast line chart
                                AreaSeries<FileHistory, String>(
                                  dataSource: fileHistoryList,
                                  xValueMapper: (FileHistory file, _) {
                                    print("_" +
                                        _.toString() +
                                        file.qkpFileId +
                                        "");
                                    String xVal = "";
                                    var val = file.createdDate.split(" ");
                                    if (selectedFilter == "7 days ago") {
                                      var days = val[0].split("-");
                                      var hours = val[1].split(":");
                                      String month = months[int.parse(days[1])];

                                      var DAYS7 =
                                          days[2] + " " + capitalize(month);
                                      xVal = DAYS7;
                                    } else if (selectedFilter == "1 days ago") {
                                      var hours = val[1].split(":");
                                      var HOURS24 = hours[0] + ":" + hours[1];
                                      xVal = HOURS24;
                                    } else if (selectedFilter ==
                                        "6 months ago") {
                                      var hours = val[1].split(":");
                                      var date = val[0].split("-");
                                      String month = months[int.parse(date[1])];
                                      var MONTHS6 =
                                          date[2] + " " + capitalize(month);
                                      xVal = MONTHS6;
                                    } else if (selectedFilter == "1 year ago") {
                                      var hours = val[1].split(":");
                                      var date = val[0].split("-");
                                      String month = months[int.parse(date[1])];

                                      var MONTHS6 = date[2] +
                                          " " +
                                          capitalize(month) +
                                          " " +
                                          date[0];
                                      xVal = MONTHS6;
                                    } else {
                                      xVal = _.toString();
                                    }
                                    return xVal;
                                  },
                                  yValueMapper: (FileHistory file, _) =>
                                      double.parse(file.price),
                                  gradient: gradientColors,
                                  borderWidth: 4,
                                  borderColor: Colors.blue,
                                ),
                                // FastLineSeries<SalesData, double>(
                                //      dataSource: [
                                //        new SalesData("Key", 1,1),
                                //        new SalesData("May", 2,2),
                                //        new SalesData("May", 3,3),
                                //        new SalesData("May", 4,4),
                                //        new SalesData("May", 5,5),
                                //        new SalesData("May", 6,6),
                                //      ],
                                //     xValueMapper: (SalesData sales, _) => 2,
                                //     yValueMapper: (SalesData sales, _) => sales.sales
                                // )
                              ])),
            ],
          ),
        ),
      ),
    );
  }
}

class SalesData {
  String month;
  int data;
  double years;

  SalesData(this.month, this.data, this.years);

  get salesMonth => this.month;

  get year => this.years;

  get sales => this.data;
}

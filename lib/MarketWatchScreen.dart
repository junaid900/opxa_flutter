import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Model/MarketWatch.dart';
import 'package:qkp/Network/constant.dart';
import 'Constraint/globals.dart' as global;

import 'Network/network.dart';
import 'main.dart';

class MarketWatchScreen extends StatefulWidget {
  @override
  _MarketWatchScreenState createState() => _MarketWatchScreenState();
}

class _MarketWatchScreenState extends State<MarketWatchScreen> with RouteAware {
  List<MarketWatch> marketWatch = [];
  var marketWatchVar;
  bool firstLoading = true;

  getPageData() async {
    var res = await marketWatchService();
    marketWatch.clear();
    setState(() {
      firstLoading = false;
    });
    if(res == null){
      return;
    }
    if (res["ResponseCode"] == 1) {
      var watchMarketMapList = res["WatchMarket"];
      print(watchMarketMapList.toString());

      /* for (int i = 0; i < watchMarketMapList.length; i++) {
        MarketWatch asset = new MarketWatch();
        asset.fromJson(watchMarketMapList[i]);
        setState(() {
          marketWatch.add(asset);
        });
      } */
      setState(() {
        marketWatchVar = watchMarketMapList;
      });
      print(marketWatchVar.toString());
    }
  }

  @override
  void initState() {
    this.getPageData();
    super.initState();
    /* SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]); */
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
      appBar: AppBar(title: Text("Market Watch")),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(color: darkTheme["primaryBackgroundColor"]),
            width: _width,
            height: _height,
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    flex: 1,
                    child: Column(
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                            child: Text(
                              'SYMBOL',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                            child: Text(
                              'LDCP',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                            child: Text(
                              'OPEN',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                            child: Text(
                              'HIGH',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                            child: Text(
                              'LOW',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                            child: Text(
                              'CURRENT',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                            child: Text(
                              'CHANGE',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                            child: Text(
                              'CHANGE(%)',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500),
                            )),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                            child: Text(
                              'VOLUME',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            )),
                      ],
                    )),
                Expanded(
                  flex: 3,
                  child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: MarketDataTable(marketList: marketWatchVar)),
                )
              ],
            ),
          ),
          if(firstLoading)
            AppLoadingScreen(backgroundOpactity: .7,)
        ],
      ),
    );
  }
}

class MarketDataTable extends StatefulWidget {
  var marketList;

  MarketDataTable({this.marketList});

  @override
  _MarketDataTableState createState() => _MarketDataTableState();
}

class _MarketDataTableState extends State<MarketDataTable> {
  @override
  Widget build(BuildContext context) {
    var length = widget.marketList != null ? widget.marketList.length : 0;

    return Container(
      child: Wrap(children: [
        for (var i = 0; i < length; i++)
          Column(
            children: [
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                  child: Text(
                    widget.marketList[i]['symbol'],
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                  child: Text(
                    widget.marketList[i]['ldcp'].toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                  child: Text(
                    widget.marketList[i]['open'].toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                  child: Text(
                    widget.marketList[i]['high'].toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                  child: Text(
                    widget.marketList[i]['low'].toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                  child: Text(
                    widget.marketList[i]['current'].toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                  child: Text(
                    widget.marketList[i]['change'].toString(),
                    style: TextStyle(
                        color: checkDoubleValue(double.tryParse(widget.marketList[i]['change']
                                    .toString())) >=
                                0
                            ? Colors.green[700]
                            : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                  child: Text(
                    widget.marketList[i]['change_percentage'].toString() + " %",
                    style: TextStyle(
                        color: checkDoubleValue(double.tryParse(widget.marketList[i]
                                        ['change_percentage']
                                    .toString())) >=
                                0
                            ? Colors.green[700]
                            : Colors.red,

                        // color: Colors.black,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )),
              Padding(
                  padding: EdgeInsets.fromLTRB(10, 16, 10, 13),
                  child: Text(
                    widget.marketList[i]['total_file_volume'].toString(),
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  )),
            ],
          ),
      ]),
    );
    /*DataTable(
      columns:  <DataColumn>[
        for(var i=0;i<length;i++ )
        DataColumn(
          label: Text(
            widget.marketList[i]['symbol'],
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
      /*  DataColumn(
          label: Text(
            'LDCP',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'OPEN',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'HIGH',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'LOW',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'CURRENT',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'CHANGE',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'CHANGE (%)',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ),
        DataColumn(
          label: Text(
            'VOLUME',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
        ), */


      ],
      rows:  <DataRow>[
        for(var i=0;i<length;i++ )
        DataRow(
          cells: <DataCell>[
            DataCell(Text(widget.marketList[i]['symbol'])),
            DataCell(Text(widget.marketList[i]['ldcp'].toString())),
            DataCell(Text(widget.marketList[i]['open'].toString())),
           /* DataCell(Text(widget.marketList[i]['high'].toString())),
            DataCell(Text(widget.marketList[i]['low'].toString())),
            DataCell(Text(widget.marketList[i]['current'].toString())),
            DataCell(Text(widget.marketList[i]['change'].toString())),
            DataCell(Text(widget.marketList[i]['change_percentage'].toString())),
            DataCell(Text(widget.marketList[i]['total_file_volume'].toString())),*/
          ],
        ),



      ],
    ); */
  }
}

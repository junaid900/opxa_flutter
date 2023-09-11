import 'package:flutter/material.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/EmptyLayout.dart';
import 'package:qkp/FavouritesScreen.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';

class MarketPerformers extends StatefulWidget {
  @override
  _MarketPerformersState createState() => _MarketPerformersState();
}

class _MarketPerformersState extends State<MarketPerformers> with RouteAware {
  var marketWatchVar = [];
   bool isError = false;
   bool firstLoading = true;


  getPageData() async {

    var res = await marketPerformerService();
    setState(() {
      firstLoading = false;
    });
    if(res == null){
      isError = true;
      return;
    }
    if (res["ResponseCode"] == 1) {
      var watchMarketMapList = res["MarketPerformer"];
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
      appBar: AppBar(title: Text("Market Performers")),
      body: Container(
        width: _width,
        height: _height,
        decoration: BoxDecoration(color: darkTheme["primaryBackgroundColor"]),
        child: Stack(
          children: [
            if( marketWatchVar != null )
            !isError && marketWatchVar.length > 0
                ? SingleChildScrollView(
                  child: Wrap(
                      children: [
                        Padding( 
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              'TOP ACTIVE STOCKS',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            )),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: MarketPerformDataTable(
                                marketList: marketWatchVar[0])),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              'TOP ADVANCERS',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            )),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: MarketPerformDataTable(
                                marketList: marketWatchVar[1])),
                        Padding(
                            padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                            child: Text(
                              'TOP DECLINERS',
                              style: TextStyle(
                                  color: darkTheme["secondaryColor"],
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700),
                            )),
                        SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: MarketPerformDataTable(
                                marketList: marketWatchVar[2])),
                      ],
                    ),
                )
                : Center(
                    child: EmptyLayoutWidget(message: "No Data Found",)),
            if(firstLoading)
            AppLoadingScreen(backgroundOpactity: .6,)
          ],
        ),
      ),
    );
  }
}

class MarketPerformDataTable extends StatefulWidget {
  var marketList;

  MarketPerformDataTable({this.marketList});

  @override
  _MarketPerformDataTableState createState() => _MarketPerformDataTableState();
}

class _MarketPerformDataTableState extends State<MarketPerformDataTable> {
  @override
  Widget build(BuildContext context) {
    var length = widget.marketList != null ? widget.marketList.length : 0;
    return DataTable(
      columns: <DataColumn>[
        DataColumn(
          label: Text(
            'Symbol',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
          ),
        ),
        DataColumn(
          label: Text(
            'PRICE',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
          ),
        ),
        DataColumn(
          label: Text(
            'CHANGE',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
          ),
        ),
        DataColumn(
          label: Text(
            'VOLUME',
            style: TextStyle(fontStyle: FontStyle.italic, color: Colors.white),
          ),
        ),
      ],
      rows: <DataRow>[
        for (var i = 0; i < length; i++)
          DataRow(
            cells: <DataCell>[
              DataCell(Text(widget.marketList[i]['symbol'],
                  style: TextStyle(color: Colors.white))),
              DataCell(Text(widget.marketList[i]['current'].toString(),
                  style: TextStyle(color: Colors.white))),
              DataCell(Text(
                widget.marketList[i]['change'].toString() +
                    '(' +
                    widget.marketList[i]['change_percentage'].toString()  +
                    '%)',
                style: TextStyle(
                    color: checkDoubleValue(double.tryParse(widget.marketList[i]
                                    ['change_percentage']
                                .toString())) >=
                            0
                        ? Color.fromRGBO(76, 187, 23, 1)
                        : Colors.red,
                    fontWeight: FontWeight.w700),
              )),
              DataCell(Text(
                widget.marketList[i]['total_file_volume'].toString(),
                style: TextStyle(color: Colors.white),
              )),
            ],
          ),
      ],
    );
  }
}

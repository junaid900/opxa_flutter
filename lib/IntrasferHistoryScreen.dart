import 'package:flutter/material.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/IntranferFile.dart';
import 'package:qkp/Model/PropertyIntransfer.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/URLS.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';

class IntransferHistoryScreen extends StatefulWidget {
  @override
  _IntransferHistoryScreenState createState() =>
      _IntransferHistoryScreenState();
}

class _IntransferHistoryScreenState extends State<IntransferHistoryScreen>
    with SingleTickerProviderStateMixin,RouteAware {
  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  TabController _tabController;
  User user = null;
  List<PropertyIntransfer> propertyIntransferList = [];
  List<IntransferFile> fileIntransferList = [];
  bool isLoading = false;

  getPageData() async {
    setState(() {
      isLoading = true;
    });
    user = await getUser();
    var request = {"user_id": user.id};
    var intRequest = request;
    var intRes = await postRequest(GET_PROPERTY_INTRANSFER_HISTORY, intRequest,toast: false);
    if (intRes != null) {
      var intMapList = intRes["Files"];
      propertyIntransferList.clear();
      for (int i = 0; i < intMapList.length; i++) {
        propertyIntransferList.add(PropertyIntransfer.fromJson(intMapList[i]));
      }
    }
    // var intRequest = request;
    var fres = await postRequest(GET_FILE_INTRANSFER_HISTORY, intRequest);
    if (fres != null) {
      var fMapList = fres["Files"];
      for (int j = 0; j < fMapList.length; j++) {
        IntransferFile intransferFile = new IntransferFile();
        intransferFile.fromJson(fMapList[j]);
        fileIntransferList.add(intransferFile);
      }
    }
    setState(() {
      fileIntransferList = fileIntransferList;
      propertyIntransferList = propertyIntransferList;
      isLoading = false;
    });
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getPageData();
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
      appBar: AppBar(
        title: Text("Intransfer History"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(40),
          child: Column(
            children: [
              TabBar(
                indicatorColor: Colors.cyan,
                indicator: UnderlineTabIndicator(
                  borderSide: BorderSide(width: 4.0, color: Colors.white),
                  insets: EdgeInsets.symmetric(horizontal: 30.0),
                ),
                isScrollable: true,
                controller: _tabController,
                tabs: [
                  Tab(
                    text: "File",
                  ),
                  Tab(
                    text: "Property",
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      body: Container(
          width: getWidth(context),
          height: getHeight(context),
          child: Stack(
            children: [
              TabBarView(controller: _tabController, children: [
                FileIntransferHistory(fileList: fileIntransferList),
                PropertyIntransferHistory(propertyList: propertyIntransferList),
              ]),
              if (isLoading) AppLoadingScreen()
            ],
          )),
    );
  }
}

class PropertyIntransferHistory extends StatefulWidget {
  List<PropertyIntransfer> propertyList;

  PropertyIntransferHistory({this.propertyList});

  @override
  _PropertyIntransferHistoryState createState() =>
      _PropertyIntransferHistoryState();
}

class _PropertyIntransferHistoryState extends State<PropertyIntransferHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context),
      width: getWidth(context),
      color: darkTheme['primaryBackgroundColor'],
      child: ListView(
        children: widget.propertyList == null
            ? []
            : List.generate(
                widget.propertyList.length,
                (index) => PropertyIntransferHistoryItem(
                      property: widget.propertyList[index],
                    )),
      ),
    );
  }
}

class FileIntransferHistory extends StatefulWidget {
  List<IntransferFile> fileList;

  FileIntransferHistory({this.fileList});

  @override
  _FileIntransferHistoryState createState() => _FileIntransferHistoryState();
}

class _FileIntransferHistoryState extends State<FileIntransferHistory> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: getHeight(context),
      width: getWidth(context),
      color: darkTheme['primaryBackgroundColor'],
      child: ListView(
        children: widget.fileList == null
            ? []
            : List.generate(
                widget.fileList.length,
                (index) =>
                    FileIntransferHistoryItem(file: widget.fileList[index])),
      ),
    );
  }
}

class PropertyIntransferHistoryItem extends StatefulWidget {
  PropertyIntransfer property;

  PropertyIntransferHistoryItem({this.property});


  @override
  _PropertyIntransferHistoryItemState createState() =>
      _PropertyIntransferHistoryItemState();
}

class _PropertyIntransferHistoryItemState
    extends State<PropertyIntransferHistoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 14, 10, 0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: darkTheme["cardBackground"],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "P-" + widget.property.historyId,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.property.propertyName}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                            "${widget.property.price} PKR",
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Seller: " +
                                    widget.property.sellerName +
                                    " (" +
                                    widget.property.sellerNumber +
                                    ")",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Buyer: " +
                                    widget.property.buyerName +
                                    " (" +
                                    widget.property.buyerNumber +
                                    ")",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}

class FileIntransferHistoryItem extends StatefulWidget {
  IntransferFile file;
  FileIntransferHistoryItem({this.file});
  @override
  _FileIntransferHistoryItemState createState() =>
      _FileIntransferHistoryItemState();
}

class _FileIntransferHistoryItemState extends State<FileIntransferHistoryItem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.fromLTRB(10, 14, 10, 0),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: darkTheme["cardBackground"],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "F-" + widget.file.historyId,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              "${widget.file.fileName}",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                          child: Text(
                             "(${widget.file.quantity}) ${widget.file.price} PKR",
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Seller: " +
                                    widget.file.sellerName +
                                    " (" +
                                    widget.file.sellerNumber +
                                    ")",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                "Buyer: " +
                                    widget.file.buyerName +
                                    " (" +
                                    widget.file.buyerNumber +
                                    ")",
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                      ],
                    )),
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ));
  }
}

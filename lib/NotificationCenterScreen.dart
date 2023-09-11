import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:qkp/EmptyLayout.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/CenterNotification.dart';
import 'package:qkp/Model/SubTypeField.dart';
import 'package:qkp/Model/User.dart';
import 'BottomTabNavigation.dart';
import 'Constraint/AppLoadingScreen.dart';
import 'Constraint/Dialog.dart';
import 'Network/constant.dart';
import 'Network/network.dart';
import 'Constraint/globals.dart' as global;

class NotificationCenterWidget extends StatefulWidget {
  @override
  _NotificationCenterWidgetState createState() =>
      _NotificationCenterWidgetState();
}

class _NotificationCenterWidgetState extends State<NotificationCenterWidget> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  User user;
  List<CenterNotification> _centerNotificationList = [];
  int page = 0;
  int totalPages = 1;
  bool isTopLoading = false;
  bool firstLoading = true;

  updateNotificationStatus() async {
    user = await getUser();
    var request = {"user_id": user.id};
    await updateNotificationStatusService(request);
  }

  getPageData() async {
    getNotificationData();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    page = 0;
    getNotificationData(type: "refresh");
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  void _onLoading() async {
    if (page != totalPages) {
      getNotificationData();
    }
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.loadComplete();
  }

  getNotificationData({type = "simple"}) async {
    if (isTopLoading) {
      showToast("loading please wait .. ");
      return;
    }
    setState(() {
      isTopLoading = true;
    });
    user = await getUser();
    var request = {"user_id": user.id, "page": page + 1};
    var res = await getUserNotificationsService(request);
    setState(() {
      isTopLoading = false;
      firstLoading = false;
    });
    if (res != null) {
      var data = res["response"];
      var cPage = data["currentPage"];
      var tPages = data["totalPages"];
      var notificaionMapList = data["notifications"];
      type == "refresh" ? _centerNotificationList.clear() : "";
      for (int i = 0; i < notificaionMapList.length; i++) {
        _centerNotificationList
            .add(CenterNotification.fromJson(notificaionMapList[i]));
      }
      setState(() {
        _centerNotificationList = _centerNotificationList;
        page = cPage;
        totalPages = tPages;
      });
    }
  }

  @override
  void initState() {
    updateNotificationStatus();
    getPageData();
    super.initState();
  }

  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }

  void FCMMesseging(message) {
    print("onMessage Property Market: $message");
    onNotificationReceive(context, data: {"message": message});

  }
  @override
  void didChangeDependencies() {
    fcmInit();
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkTheme["primaryBackgroundColor"],
        appBar: AppBar(
          elevation: 0,
          backgroundColor: darkTheme["primaryBackgroundColor"],
          title: Text("Notification Center"),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.1),
            child: isTopLoading
                ? LinearProgressIndicator(
                    // backgroundColor: Colors.black,
                    // valueColor: ,
                    )
                : SizedBox(),
          ),
        ),
        body: Stack(
          children: [
            SmartRefresher(
              enablePullDown: true,
              enablePullUp: true,
              header: WaterDropMaterialHeader(),
              footer: CustomFooter(
                builder: (BuildContext context, LoadStatus mode) {
                  Widget body;
                  if (mode == LoadStatus.idle) {
                    body = Text("pull up load");
                  } else if (mode == LoadStatus.loading) {
                    body = CupertinoActivityIndicator();
                  } else if (mode == LoadStatus.failed) {
                    body = Text("Load Failed!Click retry!");
                  } else if (mode == LoadStatus.canLoading) {
                    body = Text("release to load more");
                  } else {
                    body = Text("No more Data");
                  }
                  return Container(
                    height: 55.0,
                    child: Center(child: body),
                  );
                },
              ),
              controller: _refreshController,
              onRefresh: _onRefresh,
              onLoading: _onLoading,
              child: _centerNotificationList.length > 0
                  ? ListView(
                      children: List.generate(
                          _centerNotificationList.length,
                          (index) => NotificationItemWidget(
                              centerNotification:
                                  _centerNotificationList[index])))
                  : EmptyLayoutWidget(
                      message: "No Notification",
                      color: Colors.black,
                    ),
            ),
            if (firstLoading)
              AppLoadingScreen(
                backgroundOpactity: .6,
              )
          ],
        ));
  }
}

class NotificationItemWidget extends StatefulWidget {
  CenterNotification centerNotification;

  NotificationItemWidget({this.centerNotification});

  @override
  _NotificationItemWidgetState createState() => _NotificationItemWidgetState();
}

class _NotificationItemWidgetState extends State<NotificationItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Material(
          color: darkTheme["primaryBackgroundColor"],
          child: InkWell(
            onTap: () async {
              if (widget.centerNotification.click == "Property_Intransfer") {
                var xdata = await Navigator.pushNamed(context, 'portfolio',
                    arguments: "1");
              } else if (widget.centerNotification.click == "File_Intransfer") {
                var xdata = await Navigator.pushNamed(context, 'portfolio',
                    arguments: "0");
              } else if(widget.centerNotification.click == "Property_OwnerPropertyBid"){
                var xdata = await Navigator.pushNamed(context, 'portfolio',
                    arguments: "2");
              } else if(widget.centerNotification.click == "Property_BidProperty"){
                var xdata = await Navigator.pushNamed(context, 'portfolio',
                    arguments: "3");
              }
              // OwnerPropertyBid
              // BidProperty
            },
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 14, 10, 14),
              child: Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                      flex: 1,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: FadeInImage(
                          placeholder: AssetImage(
                              widget.centerNotification.click ==
                                      "Property_Intransfer"
                                  ? "assets/images/placeholder.jpeg"
                                  : widget.centerNotification.click ==
                                          "File_Intransfer"
                                      ? "assets/images/noti_file.png"
                                      : "assets/images/placeholder.jpeg"),
                          image: NetworkImage(
                              url + widget.centerNotification.image),
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )),
                  Expanded(
                    flex: 4,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Flexible(
                                child: Text(
                                  widget.centerNotification.title,
                                  maxLines: 2,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Text(
                                widget.centerNotification.createdAt
                                    .split(" ")[0],
                                style: TextStyle(
                                  color: Colors.grey[200],
                                  fontSize: 10,
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            widget.centerNotification.description,
                            maxLines: 2,
                            style: TextStyle(
                              color: Colors.grey[200],
                              // fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Expanded(
                  //   flex: 1,
                  //   child: IconButton(
                  //     icon: Icon(Icons.settings),
                  //     onPressed: () {},
                  //   ),
                  // )
                ],
              ),
            ),
          ),
        ),
        Divider(
          height: 1,
        ),
      ],
    );
  }
}

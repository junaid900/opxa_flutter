import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Model/PropertyNews.dart';
import 'package:qkp/Network/network.dart';
import 'Constraint/globals.dart' as global;

import 'Network/constant.dart';
import 'main.dart';

class NewsFeedListWidget extends StatefulWidget {
  @override
  _NewsFeedListWidgetState createState() => _NewsFeedListWidgetState();
}

class _NewsFeedListWidgetState extends State<NewsFeedListWidget> with RouteAware {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  List<PropertyNews> newsList = [];
  int currentPage = 1;
  bool isLoading = false;
  getPageData() async {
    print("here");
    var request = {
      "page": currentPage,
    };
    setState(() {
      isLoading = true;;
    });
    var res = await getPropertyNewsSevice(request);
    setState(() {
      isLoading = false;
    });
    print("res" + res.toString());
    newsList.clear();
    if (res["ResponseCode"] == 1) {
      var propertyMapList = res["list"]["news"];
      for (int i = 0; i < propertyMapList.length; i++) {
        newsList.add(PropertyNews.fromJson(propertyMapList[i]));
      }
      setState(() {
        newsList = newsList;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // get();
    getPageData();
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
        title: Text("News Feed"),
      ),
      body: Stack(
        children: [
          Container(
            height: getHeight(context),
            decoration: BoxDecoration(
                color: darkTheme["primaryBackgroundColor"]
            ),
            child: ListView(
                children: List.generate(
                    newsList.length,
                    (index) => NewsFeedItemWidget(
                          propertyNews: newsList[index],
                        ))),
          ),
          if(isLoading)
          AppLoadingScreen(backgroundOpactity: .6,),
        ],
      ),
    );
  }
}

class NewsFeedItemWidget extends StatefulWidget {
  PropertyNews propertyNews;

  NewsFeedItemWidget({this.propertyNews});

  @override
  _NewsFeedItemWidgetState createState() => _NewsFeedItemWidgetState();
}

class _NewsFeedItemWidgetState extends State<NewsFeedItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: darkTheme["cardBackground"],
      ),
      child: Material(
        color: Colors.transparent,
        child: Padding(
          padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
          // padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamed(context, 'news_details',
                  arguments: widget.propertyNews);
            },
            child: Flex(
              direction: Axis.horizontal,
              children: [
                Expanded(
                    flex: 1,
                    child: FadeInImage(
                      placeholder: AssetImage(
                          "assets/images/house_loading_placeholder.gif"),
                      image: NetworkImage(widget.propertyNews.image),
                      fit: BoxFit.cover,
                      height: 70,
                      width: 70,
                    )),
                Expanded(
                    flex: 3,
                    child: Container(
                      margin: EdgeInsets.fromLTRB(8, 2, 2, 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.propertyNews.title,
                              maxLines: 2,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              )),

                          // Text(
                          //   widget.propertyNews.details,
                          //   maxLines: 2,
                          //   style: TextStyle(
                          //     fontSize: 15,
                          //     // fontWeight: FontWeight.bold,
                          //     color: Colors.white,
                          //   ),
                          // )
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}

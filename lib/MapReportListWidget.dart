import 'package:flutter/material.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Model/PropertyMaps.dart';
import 'package:qkp/Network/network.dart';

import 'Network/constant.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';

class MapReportListWidget extends StatefulWidget {
  @override
  _MapReportListWidgetState createState() => _MapReportListWidgetState();
}

class _MapReportListWidgetState extends State<MapReportListWidget> with RouteAware {
  List<PropertyMaps> propertyMapsList = [];
  int currentPage = 1;
  bool isLoading = false;
  getPageData() async {
    print("here");
    var request = {
      "page": currentPage,
    };
    setState(() {
      isLoading = true;
    });
    var res = await getPropertyMapsService(request);
    setState(() {
      isLoading = false;
    });
    print("res" + res.toString());
    propertyMapsList.clear();
    if (res["ResponseCode"] == 1) {
      var propertyMapList = res["list"]["property_maps"];
      for (int i = 0; i < propertyMapList.length; i++) {
        propertyMapsList.add(PropertyMaps.fromJson(propertyMapList[i]));
      }
      setState(() {
        propertyMapsList = propertyMapsList;
      });
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
      appBar: AppBar(
        title: Text('Map Report'),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              color: darkTheme["primaryBackgroundColor"],
            ),
            height: getHeight(context),
            child: ListView(
                children: List.generate(
                    propertyMapsList.length,
                        (index) => MapReportItemWidget(
                          propertyMaps: propertyMapsList[index],
                    ))),
          ),
          if(isLoading)
          AppLoadingScreen(backgroundOpactity: .6,)
        ],
      ),
    );
  }
}

class  MapReportItemWidget extends StatefulWidget {
  PropertyMaps propertyMaps;

  MapReportItemWidget({this.propertyMaps});

  @override
  _MapReportItemWidgetState createState() => _MapReportItemWidgetState();
}

class _MapReportItemWidgetState extends State<MapReportItemWidget> {
  @override
  Widget build(BuildContext context) {
    return  Column(
      children: [
        SizedBox(height: 5,),
        Container(
          height: 40,
          decoration: BoxDecoration(
            color: darkTheme["cardBackground"],
          ),
          child: Material(
            color: Colors.transparent,
            child: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
              // padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap:(){
                  Navigator.of(context).pushNamed("map_details",arguments: widget.propertyMaps);
                },
                child: Row(
                  children: [

                    SizedBox(width: 20,),
                    Icon(
                      Icons.list_alt,
                      color: Colors.white,
                    ),
                    SizedBox(width: 10,),
                    Text(widget.propertyMaps.societyName,style: TextStyle(
                        fontSize: 18,
                        color: Colors.white
                    ),),
                    SizedBox(width: 20),

                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

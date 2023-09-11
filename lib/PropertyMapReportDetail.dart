import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:qkp/Network/constant.dart';

import 'Model/PropertyMaps.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';

class PropertyMapDetailsWidget extends StatefulWidget {
  @override
  _PropertyMapDetailsWidgetState createState() =>
      _PropertyMapDetailsWidgetState();
}

class _PropertyMapDetailsWidgetState extends State<PropertyMapDetailsWidget> with RouteAware {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
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
    // getPageData();
    onNotificationReceive(context, data: {"message": message});
  }
  @override
  Widget build(BuildContext context) {
    PropertyMaps propertyMaps;
    var arguments = ModalRoute.of(context).settings.arguments;
    propertyMaps = arguments;
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        color: darkTheme["primaryBackgroundColor"],
          child: PhotoView(
              imageProvider: NetworkImage(url+propertyMaps.mapImage)
          )),
    );
  }
}

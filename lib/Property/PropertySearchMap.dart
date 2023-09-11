import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:qkp/Constraint/area_picker.dart';
import 'package:qkp/Constraint/picker_widget.dart';
import 'package:qkp/Constraint/propertytype_picker.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/Property.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';
import 'dart:math';
import '../Constraint/globals.dart' as global;
import '../main.dart';

class GoogleMapProperty extends StatefulWidget {
  @override
  _GoogleMapPropertyState createState() => _GoogleMapPropertyState();
}

class _GoogleMapPropertyState extends State<GoogleMapProperty> with RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  GlobalKey globalKey = GlobalKey();
  bool isDrawingMode = false;

  List<TouchPoints> points = List();
  double opacity = 1.0;
  StrokeCap strokeType = StrokeCap.round;
  double strokeWidth = 3.0;
  Color selectedColor = Colors.black;
  Completer<GoogleMapController> _controller = Completer();
  Position currentPosition;
  LatLng currentLatLng;
  LatLng locationData;
  Set<Marker> markerSet = {};
  Set<Polygon> polygonSet = {};
  List<LatLng> latLngList = [];
  List<Property> propertyList;
  String price = '';
  String area = '';
  String propertyType = '';
  int propertyTypeID;
  String startPrice;
  String endPrice;
  String startArea;
  String endArea;
  bool btnReset = false;
  bool isLoading = false;
  bool showError = false;
  bool _switchValue = false;
  List<Property> currentList = [];
  double zoom = 8.786;
  bool isLatLongFinding = false;
  double cameraLat = 0;
  double cameraLng = 0;
  bool isPerfectZoom = false;

  static final CameraPosition _kGooglePlex = CameraPosition(
    // target: LatLng(0, 0),
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 16.4746,
  );

  func() async {
    GoogleMapController controller = await _controller.future;
    // var data = _controller.;
    // controller.get
  }

  Future<void> goToCurrentLocation() async {
    // GoogleMapController controller = await _controller.future;
    currentPosition = await getCurrentLocation();
    await Future.delayed(Duration(milliseconds: 600));
    print(currentPosition);
    if (currentPosition == null) {
      currentPosition = Position(latitude: 30.3753, longitude: 69.3451);
    }
    setState(() {
      currentPosition = currentPosition;
    });
    goToLocation(LatLng(currentPosition.latitude, currentPosition.longitude));
  }

  goToLocation(LatLng location) async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      // currentPosition = location;
    });
    // print("here");
    setState(() {
      currentLatLng = location;
    });
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: location,
      zoom: zoom,
    )));
  }

  changeZoom(double zoom) async {
    GoogleMapController controller = await _controller.future;

    // print("here");
    setState(() {});
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: currentLatLng,
      zoom: zoom,
    )));
  }

  showPropertyDetiail(Property property) {
    showModalBottomSheet(
        context: context,
        builder: (cont) => GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, "property_detail",
                    arguments: property);
              },
              child: Container(
                height: 300,
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    FadeInImage(
                      placeholder:
                          AssetImage("assets/images/loading_circules.gif"),
                      image: NetworkImage(
                        property.images.length > 0
                            ? url + property.images[0].image
                            : "",
                      ),
                      width: getWidth(context),
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 0, 22, 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            property.price + " PKR",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                          SizedBox(
                            height: 3,
                          ),
                          Text(property.propertyName,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              )),
                          Text(property.unitName + " " + property.size,
                              style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                          Text(property.address,
                              style: TextStyle(
                                color: Colors.white,
                                // fontWeight: FontWeight.bold,
                                fontSize: 16,
                              )),
                        ],
                      ),
                    ),
                    // Align(
                    //   alignment: Alignment.topLeft,
                    //   child: Material(
                    //     color: Colors.transparent,
                    //     child: IconButton(
                    //         icon: Icon(Icons.remove_red_eye, color: Colors.white),
                    //         onPressed: () {
                    //           Navigator.pushNamed(context, "property_detail",
                    //               arguments: property);
                    //         }),
                    //   ),
                    // )
                  ],
                ),
              ),
            ));
  }

  filterMarkers() {
    currentList.clear();
    for (int i = 0; i < propertyList.length; i++) {
      if (_checkIfValidMarker(
          LatLng(double.tryParse(propertyList[i].lat),
              double.parse(propertyList[i].long)),
          latLngList))
        markerSet.add(Marker(
            markerId: MarkerId(genrateMarkerId()),
            position: LatLng(double.tryParse(propertyList[i].lat),
                double.tryParse(propertyList[i].long)),
            onTap: () {
              showPropertyDetiail(propertyList[i]);
            }));
      currentList.add(propertyList[i]);
    }
    setState(() {
      markerSet = markerSet;
    });
  }

  resetMarkers() {
    markerSet.clear();
    currentList.clear();
    print("resetMarket=>" + propertyList.length.toString());
    for (int i = 0; i < propertyList.length; i++) {
      markerSet.add(Marker(
          markerId: MarkerId(genrateMarkerId()),
          position: LatLng(double.tryParse(propertyList[i].lat),
              double.tryParse(propertyList[i].long)),
          onTap: () {
            showPropertyDetiail(propertyList[i]);
          }));
      currentList.add(propertyList[i]);
    }
    polygonSet.clear();
    latLngList.clear();

    setState(() {
      markerSet = markerSet;
      polygonSet = polygonSet;
      latLngList = latLngList;
      points.clear();
    });
  }

  reset() {}

  clear() {}

  ResetFilters() {
    price = '';
    area = '';
    propertyType = '';
    propertyTypeID = 0;
    startPrice = '';
    endPrice = '';
    startArea = '';
    endArea = '';
    btnReset = false;
    propertyDataWithLatLong(latitude: cameraLat, longitude: cameraLng);
  }

  getPropertyList(data) async {
    propertyList = data;
    if (propertyList == null) {
      await Future.delayed(Duration(milliseconds: 500));
      getPropertyList(data);
    }
    currentList.clear();
    currentList.addAll(propertyList);
    // resetMarkers();
  }

  void _showCustomPropertyTypePicker() {
    showModalBottomSheet(
        backgroundColor: darkTheme['primaryBackgroundColor'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) => PropertyTypePicker(
              onChange: (newTime) => propertyType = newTime,
            )).whenComplete(() {
      if (propertyType == 'Residential') {
        propertyTypeID = 1;
      } else if (propertyType == 'Commercial') {
        propertyTypeID = 2;
      } else if (propertyType == 'Plot') {
        propertyTypeID = 3;
      }
      setState(() {
        propertyTypeID = propertyTypeID;
      });
      if (propertyType.length > 0) {
        btnReset = true;
        propertyDataWithLatLong(latitude: cameraLat, longitude: cameraLng);
      }
    });
  }

  propertyData() async {
    setState(() {
      isLoading = true;
    });
    User user;
    user = await getUser();
    var request = {
      "user_id": user.id,
      "type_id": propertyTypeID,
      "start_price": startPrice,
      "end_price": endPrice,
      "start_area": startArea,
      "end_area	": endArea,
    };
    print(request.toString());
    var res = await getPropertyData(request);
    print("res" + res.toString());
    setState(() {
      isLoading = false;
    });
    if (res != null) {
      if (res["ResponseCode"] == 1) {
        propertyList.clear();
        currentList.clear();
        var propertyMapList = res["list"];
        for (int i = 0; i < propertyMapList.length; i++) {
          Property asset = new Property();
          await asset.fromJson(propertyMapList[i]);
          setState(() {
            propertyList.add(asset);
          });
        }
        setState(() {
          propertyList = propertyList;
          currentList.addAll(propertyList);
          showError = false;
        });
        resetMarkers();
      } else {
        setState(() {
          //assetsQty = '';
          showError = true;
        });
      }
    } else {
      setState(() {
        showError = true;
      });
    }
  }

  propertyDataWithLatLong({latitude = 0, longitude = 0}) async {
    setState(() {
      isLatLongFinding = true;
    });
    cameraLat = latitude;
    cameraLng = longitude;
    User user;
    user = await getUser();
    var request = {
      "lat": cameraLat,
      "lng": cameraLng,
      "user": user.id,
      "type_id": propertyTypeID,
      "start_price": startPrice,
      "end_price": endPrice,
      "start_area": startArea,
      "end_area	": endArea,
    };
    print(request.toString());
    var res = await getPropertyLatLongData(request);
    print("res" + res.toString());
    setState(() {
      isLatLongFinding = false;
    });
    // return;
    setState(() {
      isLoading = false;
    });
    if (res != null) {
      if (res["list"].length < 1) {
        propertyList.clear();
        currentList.clear();
        setState(() {
          propertyList = propertyList;
          currentList = currentList;
        });
        resetMarkers();
      }
      if (res["ResponseCode"] == 1) {
        propertyList.clear();
        currentList.clear();
        var propertyMapList = res["list"];
        for (int i = 0; i < propertyMapList.length; i++) {
          Property asset = new Property();
          await asset.fromJson(propertyMapList[i]);
          setState(() {
            propertyList.add(asset);
          });
        }
        setState(() {
          propertyList = propertyList;
          // currentList.addAll(propertyList);
          showError = false;
        });
        resetMarkers();
      } else {
        setState(() {
          //assetsQty = '';
          showError = true;
        });
      }
    } else {
      setState(() {
        showError = true;
      });
    }
  }

  bool _checkIfValidMarker(LatLng tap, List<LatLng> vertices) {
    int intersectCount = 0;
    for (int j = 0; j < vertices.length - 1; j++) {
      if (rayCastIntersect(tap, vertices[j], vertices[j + 1])) {
        intersectCount++;
      }
    }

    return ((intersectCount % 2) == 1); // odd = inside, even = outside;
  }

  bool rayCastIntersect(LatLng tap, LatLng vertA, LatLng vertB) {
    double aY = vertA.latitude;
    double bY = vertB.latitude;
    double aX = vertA.longitude;
    double bX = vertB.longitude;
    double pY = tap.latitude;
    double pX = tap.longitude;

    if ((aY > pY && bY > pY) || (aY < pY && bY < pY) || (aX < pX && bX < pX)) {
      // print(aY.toString()+ "ay-py" + pY.toString() + " __ " + bY.toString() +"by-py"+ pY.toString());
      return false; // a and b can't both be above or below pt.y, and a or
      // b must be east of pt.x
    }

    double m = (aY - bY) / (aX - bX); // Rise over run
    double bee = (-aX) * m + aY; // y = mx + b
    double x = (pY - bee) / m; // algebra is neat!

    return x > pX;
  }

  showBottomSheet() async {
    bool data = await showModalBottomSheet(
      context: context,
      // barrierColor: Colors.red,
      // bounc : true,
      builder: (contex) => StatefulBuilder(builder: (cont, setState) {
        return Container(
          height: getHeight(context) / 3,
          color: Colors.blueGrey[700],
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Satellite Mode",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                CupertinoSwitch(
                  value: _switchValue,
                  trackColor: Colors.red,
                  onChanged: (value) {
                    setState(() {
                      _switchValue = value;
                    });
                    Navigator.of(contex).pop(value);
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
    if (data != null)
      setState(() {
        _switchValue = data;
      });
  }

  @override
  void initState() {
    showDynamicToast(
        "try to draw a property circle with out touching end points",
        gravity: ToastGravity.TOP,
        color: Colors.black,
        textColor: Colors.white);
    goToCurrentLocation();
    // TODO: implement initState
    super.initState();
  }

  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
    fcmInit();
  }

  @override
  void didPopNext() {
    fcmInit();
  }

  void FCMMesseging(message) {
    print("onMessage Property Market: $message");
    onNotificationReceive(context, data: {"message": message});
  }

  void _showCustomTimePicker() {
    showModalBottomSheet(
        backgroundColor: darkTheme['primaryBackgroundColor'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) => TimePickerWidget(
              onChange: (newTime) => price = newTime,
            )).whenComplete(() {
      var pr = price.split(' ');
      setState(() {
        startPrice = pr[0];
        endPrice = pr[2];
      });
      if (price.length > 0) {
        btnReset = true;
        propertyDataWithLatLong(latitude: cameraLat, longitude: cameraLng);
      }
    });
  }

  void _showCustomAreaPicker() async {
    showModalBottomSheet(
        backgroundColor: darkTheme['primaryBackgroundColor'],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
        ),
        context: context,
        builder: (context) => AreaPicker(
              onChange: (areas) => area = areas,
            )).whenComplete(() {
      if (area.length > 0) {
        var ar = area.split(' ');
        startArea = getAreaList(ar[0]);
        endArea = getAreaList(ar[2]);
        setState(() {
          startArea = startArea;
          endArea = endArea;
        });
        if (area.length > 0) {
          btnReset = true;
          propertyDataWithLatLong(latitude: cameraLat, longitude: cameraLng);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (propertyList == null) {
      var args = ModalRoute.of(context).settings.arguments;
      getPropertyList(args);
    }
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        // appBar: AppBar(
        //   title:,
        // ),
        body: Stack(
          children: [
            GoogleMap(
              onTap: (LatLng latLng) {
                // currentLatLng = latLng;
                // print("lat");
                // print(latLng);

                // print("====>" +
                //     _checkIfValidMarker(latLng, latLngList).toString());
              },
              onCameraMove: (CameraPosition cameraPosition) {
                // print(cameraPosition.zoom);
                if (isLatLongFinding || btnReset) {
                  return;
                }
                if (cameraPosition.zoom < 11) {
                  // print("here");
                  setState(() {
                    isPerfectZoom = false;
                  });
                  return;
                }
                setState(() {
                  isPerfectZoom = true;
                });

                var _lat = cameraPosition.target.latitude;
                var _lng = cameraPosition.target.longitude;
                // print(
                //     "${cameraPosition.target.latitude} : ${cameraPosition.target.longitude}");
                propertyDataWithLatLong(latitude: _lat, longitude: _lng);
              },
              polygons: polygonSet,
              mapType: !_switchValue ? MapType.normal : MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markerSet,
            ),
            if (!isPerfectZoom)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedContainer(
                    // height: 50,
                    margin: EdgeInsets.fromLTRB(0, 180, 0, 0),
                    padding: EdgeInsets.fromLTRB(10, 6, 10, 6),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(.6),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    duration: Duration(milliseconds: 1000),
                    child: Text(
                      "Zoom more to see properties",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            isDrawingMode
                ? GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject();
                        print(details);

                        points.add(
                          TouchPoints(
                            points:
                                renderBox.globalToLocal(details.globalPosition),
                            paint: Paint()
                              ..strokeCap = strokeType
                              ..isAntiAlias = true
                              ..color = selectedColor.withOpacity(opacity)
                              ..strokeWidth = strokeWidth,
                            x: details.localPosition.dx,
                            y: details.localPosition.dy,
                          ),
                        );
                      });
                    },
                    onPanStart: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject();
                        points.add(TouchPoints(
                            points:
                                renderBox.globalToLocal(details.globalPosition),
                            x: details.localPosition.dx,
                            y: details.localPosition.dy,
                            paint: Paint()
                              ..strokeCap = strokeType
                              ..isAntiAlias = true
                              ..color = selectedColor.withOpacity(opacity)
                              ..strokeWidth = strokeWidth));
                      });
                    },
                    onPanEnd: (details) async {
                      setState(() {
                        points.add(null);
                      });
                      await Future.delayed(Duration(milliseconds: 500));
                      print(points.length);
                      markerSet.clear();
                      latLngList.clear();
                      polygonSet.clear();
                      showDynamicToast("searching...",
                          color: Colors.black.withOpacity(.6),
                          length: Toast.LENGTH_LONG,
                          textColor: Colors.white,
                          fontSize: 12.0,
                          gravity: ToastGravity.TOP);
                      for (int i = 0; i < points.length; i++) {
                        if (points[i] != null) {
                          GoogleMapController controller =
                              await _controller.future;
                          print("{" + points[i].points.dx.toString() + "}");
                          int offsetMultiplier =
                              Platform.isAndroid ? 3.round() : 1;
                          int dx = points[i].x.floor() * offsetMultiplier;
                          int dy = points[i].y.floor() * offsetMultiplier;
                          ScreenCoordinate screenCords =
                              ScreenCoordinate(x: dx, y: dy);
                          // print(screenCords);
                          if (screenCords.x != null && screenCords.y != null) {
                            LatLng latLong =
                                await controller.getLatLng(screenCords);
                            // print(latLong);
                            // markerSet.add(Marker(
                            //     markerId: MarkerId(genrateMarkerId()),
                            //     position: latLong));
                            latLngList.add(latLong);
                          }
                        }
                      }
                      polygonSet.add(Polygon(
                        polygonId: PolygonId(genrateMarkerId()),
                        points: List.generate(
                          latLngList.length,
                          (index) => latLngList[index],
                        ),
                        fillColor: Colors.blue.withOpacity(.3),
                        strokeWidth: 3,
                      ));

                      setState(() {
                        points.clear();
                        isDrawingMode = false;
                        markerSet = markerSet;
                        polygonSet = polygonSet;
                        // zoom = 11.7;
                        // changeZoom(zoom);
                        print("Zoommingg" + zoom.toString());
                      });
                      // return;
                      filterMarkers();
                      getZoomLevel(50);
                    },
                    child: RepaintBoundary(
                      key: globalKey,
                      child: Stack(
                        children: <Widget>[
                          Center(
                            child: Image.asset("assets/images/hut.png"),
                          ),
                          CustomPaint(
                            size: Size.infinite,
                            painter: MyPainter(
                              pointsList: points,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : SizedBox(),
            Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(
                      5, Platform.isAndroid ? 34 : 50, 5, 10),
                  width: getWidth(context),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                          child: Material(
                        color: Colors.transparent,
                        child: FlatButton(
                          onPressed: () async {
                            List<Property> filteredList = [];
                            // showDynamicToast(
                            //   "Filtering Please Wait ....",
                            //   color: Colors.red.withOpacity(.7),
                            //   textColor: Colors.white,
                            //   fontSize: 18.0,
                            //   gravity: ToastGravity.CENTER,
                            //   length: Toast.LENGTH_SHORT,
                            // );
                            // if (latLngList.length > 0 && markerSet.length > 0) {
                            //   filteredList.addAll(propertyList.where(
                            //           (element) => _checkIfValidMarker(
                            //           LatLng(double.tryParse(element.lat),
                            //               double.tryParse(element.long)),
                            //           latLngList)));
                            //   if (filteredList.length > 0)
                            Navigator.of(context).pop();
                            // } else {
                            //   filteredList.addAll(propertyList);
                            //   print(propertyList.length);
                            //   Navigator.of(context).pop();
                            // }
                          },
                          child: Icon(
                            Icons.arrow_back,
                            color: darkTheme["backgroundColor"],
                            size: 22,
                          ),
                        ),
                      )),
                      Expanded(
                        flex: 4,
                        child: Column(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: Material(
                                  color: Colors.grey.withOpacity(.8),
                                  child: InkWell(
                                    onTap: () {
                                      print("here");
                                      googleSearchDialog();
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Flexible(
                                            child: Text(
                                              "Do You Want To Search Location?",
                                            ),
                                          ),
                                          Icon(Icons.location_history),
                                        ],
                                      ),
                                    ),
                                  )),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                          flex: 2,
                          child: Material(
                            color: Colors.transparent,
                            child: FlatButton(
                              onPressed: () async {
                                List<Property> filteredList = [];
                                showDynamicToast(
                                  "Filtering Please Wait ....",
                                  color: Colors.red.withOpacity(.7),
                                  textColor: Colors.white,
                                  fontSize: 18.0,
                                  gravity: ToastGravity.CENTER,
                                  length: Toast.LENGTH_SHORT,
                                );
                                if (latLngList.length > 0 &&
                                    markerSet.length > 0) {
                                  filteredList.addAll(propertyList.where(
                                      (element) => _checkIfValidMarker(
                                          LatLng(double.tryParse(element.lat),
                                              double.tryParse(element.long)),
                                          latLngList)));
                                  if (filteredList.length > 0)
                                    Navigator.of(context).pop(filteredList);
                                } else {
                                  showToast("no property found");
                                  // filteredList.addAll(propertyList);
                                  // print(propertyList.length);
                                  // Navigator.of(context).pop();
                                }
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.list,
                                    color: darkTheme["backgroundColor"],
                                    size: 22,
                                  ),
                                  Flexible(
                                      child: Text(
                                    "List",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: darkTheme["backgroundColor"]),
                                  )),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                ),
                Container(
                  height: 40,
                  width: getWidth(context),
                  child: ListView(
                    shrinkWrap: false,
                    scrollDirection: Axis.horizontal,
                    children: [
                      Row(
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Visibility(
                            visible: btnReset,
                            child: FlatButton(
                              // padding: EdgeInsets.all(30.0),
                              color: darkTheme["cardBackground"],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(22.0),
                                  side: BorderSide(
                                      color: darkTheme["cardBackground"],
                                      width: 1)),
                              child: Icon(
                                Icons.reset_tv,
                                color: darkTheme["primaryWhite"],
                              ),

                              onPressed: () async {
                                ResetFilters();
                              },
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          //  for(var i=0;i<10;i++)
                          FlatButton(
                            // padding: EdgeInsets.all(30.0),
                            color: darkTheme["cardBackground"],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                                side: BorderSide(
                                    color: darkTheme["cardBackground"],
                                    width: 1)),
                            child: Text(
                              "Filters",
                              style:
                                  TextStyle(color: darkTheme["primaryWhite"]),
                            ),
                            onPressed: () async {
                              var arguments =
                                  await Navigator.pushNamed(context, 'filters');
                              if (arguments != null) {
                                print(arguments);
                                propertyList.clear();
                                btnReset = true;
                                setState(() {
                                  propertyList.addAll(arguments);
                                });
                              }

                              print('Button pressed');
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FlatButton(
                            // padding: EdgeInsets.all(30.0),
                            color: darkTheme["cardBackground"],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                                side: BorderSide(
                                    color: darkTheme["cardBackground"],
                                    width: 1)),
                            child: Text(
                              "Property Type",
                              style:
                                  TextStyle(color: darkTheme["primaryWhite"]),
                            ),
                            onPressed: () {
                              _showCustomPropertyTypePicker();
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FlatButton(
                            // padding: EdgeInsets.all(30.0),
                            color: darkTheme["cardBackground"],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                                side: BorderSide(
                                    color: darkTheme["cardBackground"],
                                    width: 1)),
                            child: Text(
                              "Area",
                              style:
                                  TextStyle(color: darkTheme["primaryWhite"]),
                            ),
                            onPressed: () {
                              _showCustomAreaPicker();
                              print('Button pressed');
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          FlatButton(
                            // padding: EdgeInsets.all(30.0),
                            color: darkTheme["cardBackground"],
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(22.0),
                                side: BorderSide(
                                    color: darkTheme["cardBackground"],
                                    width: 1)),
                            child: Text(
                              "Price",
                              style:
                                  TextStyle(color: darkTheme["primaryWhite"]),
                            ),
                            onPressed: () {
                              _showCustomTimePicker();
                            },
                          ),
                          SizedBox(
                            width: 5,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                isLatLongFinding
                    ? Container(
                        height: 50,
                        width: getWidth(context),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator()),
                            SizedBox(
                              width: 10,
                            ),
                            Text("Searching .. "),
                          ],
                        ),
                      )
                    : SizedBox()
              ],
            ),
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  setState(() {
                    isDrawingMode = !isDrawingMode;
                  });
                },
                child: isDrawingMode
                    ? Icon(Icons.clear)
                    : Icon(FontAwesomeIcons.penAlt),
              ),
              SizedBox(
                width: 10,
              ),
              FloatingActionButton(
                heroTag: "btn2",
                onPressed: () {
                  resetMarkers();
                },
                child: Icon(Icons.refresh),
              ),
              SizedBox(
                width: 8,
              ),
              FloatingActionButton(
                onPressed: () async {
                  showBottomSheet();
                  // List<Property> filteredList = [];
                  // showDynamicToast(
                  //   "Filtering Please Wait ....",
                  //   color: Colors.red.withOpacity(.7),
                  //   textColor: Colors.white,
                  //   fontSize: 18.0,
                  //   gravity: ToastGravity.CENTER,
                  //   length: Toast.LENGTH_SHORT,
                  // );
                  // if (latLngList.length > 0 && markerSet.length > 0) {
                  //   filteredList.addAll(propertyList.where((element) =>
                  //       _checkIfValidMarker(
                  //           LatLng(double.tryParse(element.lat),
                  //               double.tryParse(element.long)),
                  //           latLngList)));
                  //   if(filteredList.length > 0)
                  //   Navigator.of(context).pop(filteredList);
                  // } else {
                  //   latLngList.length < 0
                  //       ? showToast("please draw a pattern first")
                  //       : showToast("no property found");
                  // }

                  // for(int i = 0 ; i<propertyList.length ; i++){
                  //
                  // }
                },
                child: Icon(Icons.maps_ugc),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> googleSearchDialog() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    var p = await PlacesAutocomplete.show(
      context: context,
      apiKey: GEO_API,
      mode: Mode.overlay, // Mode.fullscreen
      language: "en",
    );
    if (p != null) {
      showToast("Please wait..");
      GoogleMapsPlaces places = GoogleMapsPlaces(
        apiKey: GEO_API,
        apiHeaders: await GoogleApiHeaders().getHeaders(),
      );
      PlacesDetailsResponse detail =
          await places.getDetailsByPlaceId(p.placeId);
      if (detail != null) {
        goToLocation(LatLng(detail.result.geometry.location.lat,
            detail.result.geometry.location.lng));
      } else {
        showToast("Cannot Pick Location Try Again");
      }
    } else {
      showToast("Cannot Pick Location Try Again");
    }

    // displayPrediction(p, homeScaffoldKey.currentState);
  }
}

class MyPainter extends CustomPainter {
  MyPainter({this.pointsList});

  //Keep track of the points tapped on the screen
  List<TouchPoints> pointsList;
  List<Offset> offsetPoints = List();

  //This is where we can draw on canvas.
  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < pointsList.length - 1; i++) {
      if (pointsList[i] != null && pointsList[i + 1] != null) {
        //Drawing line when two consecutive points are available
        canvas.drawLine(pointsList[i].points, pointsList[i + 1].points,
            pointsList[i].paint);
      } else if (pointsList[i] != null && pointsList[i + 1] == null) {
        offsetPoints.clear();
        offsetPoints.add(pointsList[i].points);
        offsetPoints.add(Offset(
            pointsList[i].points.dx + 0.1, pointsList[i].points.dy + 0.1));

        //Draw points when two points are not next to each other
        canvas.drawPoints(
            ui.PointMode.points, offsetPoints, pointsList[i].paint);
      }
    }
  }

  //Called when CustomPainter is rebuilt.
  //Returning true because we want canvas to be rebuilt to reflect new changes.
  @override
  bool shouldRepaint(MyPainter oldDelegate) => true;
}

//Class to define a point touched at canvas
class TouchPoints {
  Paint paint;
  Offset points;
  double x;
  double y;

  TouchPoints({this.points, this.paint, this.x = 0, this.y = 0});
}

double getZoomLevel(double radius) {
  double zoomLevel = 11;
  if (radius > 0) {
    double radiusElevated = radius + radius / 2;
    double scale = radiusElevated / 500;
    zoomLevel = 16 - log(scale) / log(2);
  }
  zoomLevel = num.parse(zoomLevel.toStringAsFixed(2));
  return zoomLevel;
}

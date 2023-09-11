import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_api_headers/google_api_headers.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:http/http.dart';
import 'package:qkp/CircularInputField.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Network/constant.dart';
import '../Constraint/globals.dart' as global;


class MapSample extends StatefulWidget {
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  Completer<GoogleMapController> _controller = Completer();
  Position currentPosition;
  Set<Marker> markerList = {};
  LatLng currentLatLng;
  LatLng locationData;

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(0, 0),
    // target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  // static final CameraPosition _kLake = CameraPosition(
  //     bearing: 192.8334901395799,
  //     target: LatLng(37.43296265331129, -122.08832357078792),
  //     // tilt: 59.440717697143555,
  //     zoom: 22.154);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    goToCurrentLocation();
  }


  @override
  void didChangeDependencies() {
    fcmInit();
  }

  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }
  void FCMMesseging(message) {
    onNotificationReceive(context,data: {"message":message});
  }



  Future<void> goToCurrentLocation() async {
    // GoogleMapController controller = await _controller.future;
    try {
      currentPosition = await getCurrentLocation();
      await Future.delayed(Duration(milliseconds: 600));
      print(currentPosition);
      if (currentPosition == null) {
        currentPosition = Position(latitude: 30.3753, longitude: 69.3451);
      }
      setState(() {
        currentPosition = currentPosition;
      });
    }catch(e){
      currentPosition = Position(latitude: 30.3753, longitude: 69.3451);
    }
    goToLocation(LatLng(currentPosition.latitude, currentPosition.longitude));
    // print("currentLocation" + currentPosition.toString());
    // print("currentLocation L L" +
    //     currentPosition.latitude.toString() +
    //     "Long " +
    //     currentPosition.longitude.toString());
    // controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
    //   target: LatLng(currentPosition.latitude, currentPosition.longitude),
    //   zoom: 18.4746,
    // )));
    // markerList.add(Marker(markerId: null))
    // controller.mar
    // addMarker(currentPosition);
  }

  addMarker(Position position) {
    // var markerIdVal = MyWayToGenerateId();
    final MarkerId markerId = MarkerId(genrateMarkerId());
    markerList.clear();
    markerList.add(Marker(
        markerId: markerId,
        position: LatLng(position.latitude, position.longitude)));
    setState(() {
      markerList = markerList;
      locationData = LatLng(position.latitude, position.longitude);
    });
  }

  goToLocation(LatLng location) async {
    GoogleMapController controller = await _controller.future;
    setState(() {
      currentLatLng = location;
    });
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: location,
      zoom: 18.4746,
    )));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: darkTheme["primaryBackgroundColor"],
      padding: EdgeInsets.fromLTRB(0, Platform.isAndroid ? 34 : 0, 0, 0),
      child: new Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              
              onTap: (LatLng latLng) {
                currentLatLng = latLng;
              },
              mapType: MapType.normal,
              initialCameraPosition: _kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              markers: markerList,
            ),
            currentLatLng == null
                ? AppLoadingScreen(backgroundOpactity: .6,)
                : SizedBox(),

            Padding(
              padding: EdgeInsets.fromLTRB(0, Platform.isAndroid ? 34 : 34, 0, 0),
              child: Container(
                margin: EdgeInsets.all(10),
                width: getWidth(context),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Material(
                          child: InkWell(
                        onTap: () {
                          print("here");
                          googleSearchDialog();
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Do You Want To Search Location?",
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
            ),
          ],
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.miniStartFloat,
        floatingActionButton: Row(
          children: [
            FloatingActionButton(
              heroTag: "btn1",
              onPressed: () {
                // goToCurrentLocation();
                // goToLocation(currentLatLng);
                if (currentLatLng != null) {
                  addMarker(Position(
                      latitude: currentLatLng.latitude,
                      longitude: currentLatLng.longitude));
                } else {
                  showToast("Cannot Pick Current Location");
                }
              },
              // label: Text('To the lake!'),
              child: Icon(Icons.location_on_sharp),
            ),
            SizedBox(
              width: 10,
            ),
            FloatingActionButton.extended(
              heroTag: "btn2",
              onPressed: () {
                // goToCurrentLocation();
                // goToLocation(currentLatLng);
                if (locationData != null) {
                  Navigator.pop(context, locationData

                      //     {
                      //   "lat": locationData.latitude,
                      //   "long": locationData.longitude
                      // }
                      );
                } else {
                  showToast("Mark A Location First");
                }
              },
              backgroundColor: darkTheme["primaryBackgroundColor"],

              // label: Text('To the lake!'),
              label: Text("Save"),
              icon: Icon(Icons.save),
            ),
          ],
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

  getLocations(query) async {
    String locationUrl =
        "https://www.google.com/maps/search/?api=1&query=$query&key=$GEO_API";
    print(locationUrl);
    var res = await get(locationUrl);
    print("location response");
    // var data = jsonDecode(res.body);
    print(res.body);
  }

  Future<void> _goToTheLake() async {
    // final GoogleMapController controller = await _controller.future;
    // controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
  }
}

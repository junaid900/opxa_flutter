import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:qkp/Network/constant.dart';

class PropertyDetailMapWidget extends StatefulWidget {
  @override
  _PropertyDetailMapWidgetState createState() => _PropertyDetailMapWidgetState();
}

class _PropertyDetailMapWidgetState extends State<PropertyDetailMapWidget> {
  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments;
    LatLng latLng = arguments;
    return  GoogleMap(
      onTap: (LatLng latLng) {
        // currentLatLng = latLng;
        // print("lat");
        // print(latLng);

        // print("====>" +
        //     _checkIfValidMarker(latLng, latLngList).toString());
      },
      // polygons: polygonSet,
      mapType: MapType.normal,
      initialCameraPosition: CameraPosition(target: arguments,zoom: 10),
      // onMapCreated: (GoogleMapController controller) {
      //   _controller.complete(controller);
      // },
      markers: {
        Marker(markerId: MarkerId(genrateMarkerId()),
          position: latLng,
        ),
      },
    );
  }
}

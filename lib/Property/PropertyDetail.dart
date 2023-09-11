import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:photo_view/photo_view.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/Model/Property.dart';
import 'package:qkp/Network/constant.dart';
import 'package:intl/intl.dart';
import '../Constraint/globals.dart' as global;
import '../main.dart';
class PropertyDetail extends StatefulWidget {
  @override
  _PropertyDetailState createState() => _PropertyDetailState();
}

class _PropertyDetailState extends State<PropertyDetail> with RouteAware {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  Property propertyList;
  FirebaseMessaging _firebaseMessaging;

  void FCMMesseging(message) {
    onNotificationReceive(context,data: {"message":message});
  }

  getPropertyData() {}

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  fcmInit(){
    global.onMessageReceiveFunction = (message){
      FCMMesseging(message);
    };
  }
  @override
  void didPopNext() {
    fcmInit();
  }
  @override
  void didChangeDependencies() {
    fcmInit();
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments;
    setState(() {
      propertyList = arguments;
      print(propertyList.toJson());
    });
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(propertyList.propertyName),
        actions: [
          IconButton(
              icon: Icon(Icons.image_search),
              onPressed: () {
                Navigator.of(context)
                    .pushNamed("type_images", arguments: propertyList);
              })
        ],
      ),
      body: Container(
        width: _width,
        height: _height,
        color: isDarkTheme
            ? darkTheme["primaryBackgroundColor"]
            : lightTheme["primaryBackgroundColor"],
        // padding: EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: SliderItem(propertyList: propertyList),
        ),
      ),
    );
  }
}

class SliderItem extends StatefulWidget {
  final CarouselController _controller = CarouselController();
  Property propertyList;

  SliderItem({this.propertyList});

  @override
  _SliderItemState createState() => _SliderItemState();
}

class _SliderItemState extends State<SliderItem> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  List<Widget> imageSliders = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    imageSliders = widget.propertyList.images
        .map((item) => Container(
              // margin: EdgeInsets.all(5.0),
              // width: getWidth(context),
              color: Colors.transparent,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      GestureDetector(
                        child: Container(
                            width: getWidth(context),
                            height: 200,
                            child: Image.network(
                              url + item.image,
                              width: getWidth(context),
                              height: 200,
                              fit: BoxFit.cover,
                            )),
                        //),
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) {
                            return Scaffold(
                              body: Stack(
                                children: [
                                  GestureDetector(
                                    child: Center(
                                      child: InteractiveViewer(
                                        //  panEnabled: false, // Set it to false
                                        boundaryMargin: EdgeInsets.all(100),
                                        minScale: 0.5,
                                        maxScale: 2,
                                        // tag: widget.propertyList.id,
                                        child: PhotoView(
                                          imageProvider:
                                              NetworkImage(url + item.image),
                                          // width: 200,
                                          //height: 200,
                                          // fit: BoxFit.cover
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: Colors.black38,
                                    child: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.arrow_back_outlined,
                                          color: Colors.white,
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            ;
                          }));
                        },
                      ),
                    ],
                  )),
            ))
        .toList();
    setState(() {
      imageSliders = imageSliders;
    });
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.compact(locale: 'eu');
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          CarouselSlider(
            items: imageSliders,
            options: CarouselOptions(
              height: 200.0,
              viewportFraction: 1,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              autoPlayAnimationDuration: Duration(milliseconds: 1000),
              autoPlayCurve: Curves.fastOutSlowIn,
            ),
            carouselController: _controller,
          ),
          Container(
            decoration: BoxDecoration(
                color: darkTheme['primaryBackgroundColor'],
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20))),
            padding: EdgeInsets.fromLTRB(10, 15, 10, 2),
            transform: Matrix4.translationValues(0.0, -22.0, 0.0),
            height: 100,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  widget.propertyList.images.length,
                  (index) => InkWell(
                    onTap: () => _controller.animateToPage(index),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                            url + widget.propertyList.images[index].image,
                            fit: BoxFit.cover,
                            height: 100,
                            width: 100),
                      ),
                    ),
                  ),
                )),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    widget.propertyList.propertyName + ' . ',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 18),
                  ),
                ),
                Row(
                  children: [
                    SvgPicture.asset(
                      'assets/images/dollar.svg',
                      width: 18,
                      height: 18,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      widget.propertyList.price + ' PKR',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Row(
              children: [
                Text(
                  widget.propertyList.societyName != null
                      ? widget.propertyList.societyName
                      : "",
                  style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                      fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.fromLTRB(10, 15, 10, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(2.0),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Icon(
                            Icons.arrow_upward,
                            size: 14,
                            color: darkTheme['bgCellColor'],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text(
                      'High Price: ',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    Text(
                      widget.propertyList.maxBid,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // if((widget.propertyList.bedRooms == null  || widget.propertyList.bedRooms == "null") || (widget.propertyList.bathRooms == null  || widget.propertyList.bathRooms == "null"))
          Stack(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: darkTheme['bgCellColor'],
                  ),
                  padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      if(widget.propertyList.bedRooms != null  && widget.propertyList.bedRooms != "null")

                        Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.propertyList.bedRooms,
                                      style: TextStyle(
                                        color: darkTheme['primaryTextColor'],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.bed,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ]),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Beds',
                                style: TextStyle(
                                    color: darkTheme['primaryTextColor'],
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if(widget.propertyList.bathRooms != null  && widget.propertyList.bathRooms != "null")
                      Expanded(
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.propertyList.bathRooms,
                                      style: TextStyle(
                                        color: darkTheme['primaryTextColor'],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 2,
                                    ),
                                    Icon(
                                      FontAwesomeIcons.bath,
                                      size: 14,
                                      color: Colors.white,
                                    ),
                                  ]),
                              SizedBox(
                                height: 5,
                              ),
                              Text(
                                'Baths',
                                style: TextStyle(
                                    color: darkTheme['primaryTextColor'],
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Expanded(
                      //   child: Container(
                      //     child: Column(
                      //       crossAxisAlignment: CrossAxisAlignment.center,
                      //       children: [
                      //         Row(
                      //             mainAxisAlignment: MainAxisAlignment.center,
                      //             children: [
                      //               Text(
                      //                 "3",
                      //                 style: TextStyle(
                      //                   color: darkTheme['primaryTextColor'],
                      //                 ),
                      //               ),
                      //               SizedBox(
                      //                 width: 2,
                      //               ),
                      //               Icon(
                      //                 FontAwesomeIcons.parking,
                      //                 size: 14,
                      //                 color: Colors.white,
                      //               ),
                      //             ]),
                      //         SizedBox(
                      //           height: 5,
                      //         ),
                      //         Text(
                      //           'Parkings',
                      //           style: TextStyle(
                      //               color: darkTheme['primaryTextColor'],
                      //               fontWeight: FontWeight.w500),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 25.0, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, 'property_more_feature',
                        arguments: widget.propertyList.features);
                  },
                  child: Text(
                    'More Feature',

                    style: TextStyle(color: Colors.white,
                    decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                      child: ElevatedButton(
                          onPressed: () => {
                                Navigator.pushNamed(context, 'trade_property',
                                    arguments: widget.propertyList)
                              },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  darkTheme['secondaryColor']),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: darkTheme["redText"]),
                                ),
                                // primary: darkTheme["secondaryColor"],
                              )),
                          child:
                              Text("Bid Now", style: TextStyle(fontSize: 15))),
                    ),
                  )
                ],
              )),
          Container(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (widget.propertyList.sectorName != null)
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Sector",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.propertyList.sectorName,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                if (widget.propertyList.typeName != null)
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Type",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.propertyList.typeName,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                if (widget.propertyList.typeName != null)
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Sub Type",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.propertyList.subtypeName,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                if (widget.propertyList.minimumOffer != null)
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Starting Bid Price",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.propertyList.minimumOffer,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                if (widget.propertyList.address != null)
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Address",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          widget.propertyList.address,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                if (widget.propertyList.unitName != null)
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_drop_down_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            SizedBox(width: 6),
                            Text(
                              "Unit (Size)",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "(${widget.propertyList.size}) ${widget.propertyList.unitName} ",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (widget.propertyList.contactNumber != null)
          Container(
            width: getWidth(context),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                  child: Text(
                    "Description",
                    style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
                ),
                Text(
                  widget.propertyList.contactNumber,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                )
                // Text(widget.propertyList.contactNumber)
              ]),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: EdgeInsets.fromLTRB(10, 12, 10, 0),
              width: getWidth(context),
              height: getHeight(context) * .30,
              decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                  ),
              child: GoogleMap(
                onTap: (latLng) {
                  Navigator.of(context)
                      .pushNamed("property_map_detail", arguments: latLng);
                },
                initialCameraPosition: CameraPosition(
                  target: LatLng(double.parse(widget.propertyList.lat),
                      double.parse(widget.propertyList.long)),
                  zoom: 17,
                ),
                mapType: MapType.hybrid,
                markers: {
                  Marker(
                    markerId: MarkerId(genrateMarkerId()),
                    position: LatLng(double.parse(widget.propertyList.lat),
                        double.parse(widget.propertyList.long)),
                  )
                },
              ),
            ),
          )
        ],
      ),
    ));
  }
}

class DetailScreen extends StatelessWidget {
  String imageLink;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        child: Center(
          child: Hero(
            tag: 'imageHero',
            child: Image.network(imageLink),
          ),
        ),
        onTap: () {
          Navigator.pop(context);
        },
      ),
    );
  }
}

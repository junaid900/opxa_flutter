import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/MaterialButton.dart';
import 'package:qkp/MaterialInputField.dart';
import 'package:qkp/Model/IntranferFile.dart';
import 'package:qkp/Model/MyAsset.dart';
import 'package:qkp/Model/PropertyAsset.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';

import 'CircularInputField.dart';
import 'Constraint/Dialog.dart';
import 'CustomeElivatedButton.dart';
import 'EmptyLayout.dart';
import 'Model/Property.dart';
import 'Model/User.dart';
import 'Network/URLS.dart';
import 'Network/http_requests.dart';

class SellOrderTabWidget extends StatefulWidget {

  List<MyAsset> sells;
  Function stateChanged;
  List<bool> isSelected;
  List<PropertyAsset> propertySell;

  SellOrderTabWidget(
      {this.sells, this.stateChanged, this.propertySell, this.isSelected});

  @override
  _SellOrderTabWidgetState createState() => _SellOrderTabWidgetState();
}

class _SellOrderTabWidgetState extends State<SellOrderTabWidget> {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  List<MyAsset> data = [];
  User user;
  bool isEmpty = false;
  int numberOfBids = -1;

  getPageData() async {
    user = await getUser();
    setState(() {
      numberOfBids = -1;
    });
    // data.clear();
    var owner_id = await user.id;
    var request = {"owner_id": owner_id};
    // setState(() {
    //   data = widget.assets;
    // });
    var res2 = await getUserBidsService({"user_id": user.id});
    if (res2 != null) {
      numberOfBids = int.tryParse(res2["list"]["bids"].toString());
    } else {
      numberOfBids = 0;
    }
    // print("===============++>"+convertToNumber(res2["list"]["bids"].toString()).toString());
    setState(() {
      numberOfBids = numberOfBids;
    });
    // getPageData();
  }

  getAssets() async {
    print("when here");
    user = await getUser();
    data.clear();

    var owner_id = await user.id;
    var request = {"owner_id": owner_id};
    setState(() {
      data = widget.sells;
    });
    print(data.length);
    if (data.length < 1) {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        isEmpty = false;
      });
    }
    getPageData();
  }

  @override
  void initState() {
    getAssets();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    // print(data.length);
    return SingleChildScrollView(
      child: Container(
          margin: EdgeInsets.fromLTRB(0, 0, 0, 90),
          child: Column(
              children: widget.isSelected[0]
                  ? data.length > 0
                      ? List.generate(data.length, (index) {
                          // print(new MyAsset().toJson().toString());
                          return SellOrderTabItemFile(
                              asset: data[index],
                              sellStateChanged: () {
                                widget.stateChanged();
                                getPageData();
                              },
                              bids: numberOfBids);
                        })
                      : [
                          Center(
                            child: EmptyLayoutWidget(
                              message: "No data found in sell orders",
                            ),
                          ),
                        ]
                  // : <Widget>[PropertySellItemWidget()]

                  : widget.propertySell.length > 0
                      ? List.generate(widget.propertySell.length, (index) {
                          print(new MyAsset().toJson().toString());
                          return PropertySellItemWidget(
                              asset: widget.propertySell[index],
                              sellStateChanged: () {
                                getPageData();
                                widget.stateChanged();
                              },
                              bids: numberOfBids);
                        })
                      : [
                          Center(
                            child: EmptyLayoutWidget(
                              message: "No data found in sell orders",
                            ),
                          )
                        ]
              //
              )),
    );
  }
}

class PropertySellItemWidget extends StatefulWidget {
  PropertyAsset asset;
  final sellStateChanged;
  int bids;

  PropertySellItemWidget({this.asset, this.sellStateChanged, this.bids});

  @override
  _PropertySellItemWidgetState createState() => _PropertySellItemWidgetState();
}

class _PropertySellItemWidgetState extends State<PropertySellItemWidget> {
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
        children: [
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                        child: Text(
                          widget.asset.maximumOffer + " PKR",
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
                        children: [
                          Flexible(
                            child: Text(
                              widget.asset.propertyName,
                              style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500),
                            ),
                          ),
                          // SizedBox(width: 8),
                          // Icon(
                          //   Icons.circle,
                          //   color: Colors.grey,
                          //   size: 8,
                          // )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.bed,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  widget.asset.bedRooms + " Beds",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Icon(
                                  FontAwesomeIcons.shower,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  widget.asset.bathRooms + " Baths",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                          ),
                          // Expanded(
                          //   flex: 1,
                          //   child: Row(
                          //     children: [
                          //       Icon(
                          //         FontAwesomeIcons.car,
                          //         color: Colors.white,
                          //         size: 13,
                          //       ),
                          //       SizedBox(
                          //         width: 3,
                          //       ),
                          //       Flexible(
                          //         child: Text(
                          //           // widget.asset.par,
                          //           "2 Parking",
                          //           style: TextStyle(
                          //             color: Colors.white,
                          //             fontSize: 13,
                          //           ),
                          //         ),
                          //       )
                          //     ],
                          //   ),
                          // )
                        ],
                      )
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.network(
                      url + widget.asset.image,
                      width: 140,
                      height: 81,
                      fit: BoxFit.cover,
                    ),
                  ))
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
                  // width: getWidth(context)/2.5,
                  // width: getWidth(context) * .50,
                  child: CustomeElivatedButtonWidget(
                    onPress: () {
                      propertyEditDialog(widget.asset.id, "Edit", widget.asset,
                          widget.sellStateChanged);
                    },
                    name: "Edit Post",
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                  // width: getWidth(context)/2.5,
                  // width: getWidth(context) * .50,
                  child: CustomeElivatedButtonWidget(
                    onPress: () {
                      dialogDeleteProperty(widget.asset.id);
                    },
                    name: "Delete",
                    color: Colors.red,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(6, 0, 0, 0),
                  // width: getWidth(context)/2.5,
                  // width: getWidth(context) * .50,
                  child: CustomeElivatedButtonWidget(
                    onPress: () {
                      Property property = new Property(
                        id: widget.asset.id,
                        propertyName: widget.asset.propertyName,
                        typeId: widget.asset.typeId,
                        subTypeId: widget.asset.subTypeId,
                        cityId: widget.asset.cityId,
                        townId: widget.asset.townId,
                        societyId: widget.asset.societyId,
                        lat: widget.asset.lat,
                        long: widget.asset.long,
                        address: widget.asset.address,
                      );
                      Navigator.pushNamed(context, 'trade_property', arguments: property);
                      // Navigator.of(context).pushNamed("view_property_bids",
                      //     arguments: {
                      //       "asset": widget.asset,
                      //       "onChanged": widget.sellStateChanged
                      //     });
                    },
                    name: "Bids",
                    color: Colors.green,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  var formPrice = "", formQty = "", minBidPrice = "", maxBidPrice = "";
  bool isLoading = false;
  bool isDisabled = false;

  propertyEditDialog(
      var id, var type, PropertyAsset asset, final postStateChanged) {
    minBidPrice = asset.minimumOffer;
    maxBidPrice = asset.maximumOffer;

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext stcontext,
                void Function(void Function()) setState) {
              return AlertDialog(
                insetPadding: EdgeInsets.all(10),
                backgroundColor: Colors.transparent,
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: darkTheme["popupBackground"],
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Form(
                    // key: _formKey1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Material(
                                color: Colors.transparent,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset(
                              "assets/images/bid.png",
                              width: 100,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text(
                              'Starting Bid Price',
                              style: TextStyle(
                                color: darkTheme['primaryTextColor'],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 3),
                            child: CircularInputField(
                              value: asset.minimumOffer,
                              hintText: "Selling Price",
                              onChanged: (val) {
                                minBidPrice = val;
                              },
                              type: TextInputType.numberWithOptions(
                                  decimal: true, signed: false),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text(
                              'Enter Maximum Price',
                              style: TextStyle(
                                color: darkTheme['primaryTextColor'],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 3),
                            child: CircularInputField(
                              value: asset.maximumOffer,
                              hintText: "Maximum Bid Price",
                              onChanged: (val) {
                                maxBidPrice = val;
                              },
                              type: TextInputType.numberWithOptions(
                                  decimal: true, signed: false),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: CustomeElivatedButtonWidget(
                                        onPress: () async {
                                          if (int.tryParse(minBidPrice) >=
                                              int.tryParse(maxBidPrice)) {
                                            showToast(
                                                "minimum price cannot be greater or equal to maximum price");
                                            return;
                                          }
                                          // setState(() {
                                          //   isLoading = true;
                                          //   isDisabled = true;
                                          // });
                                          Navigator.pop(context);
                                          await propertyUpdate(id, context,
                                              asset, postStateChanged);
                                          // setState(() {
                                          //   isLoading = false;
                                          //   isDisabled = false;
                                          // });
                                          // widget.sellStateChanged();
                                        },
                                        name: "Post",
                                        isDisable: isDisabled,
                                        isLoading: isLoading,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            // child: ,
          );
          //   StatefulBuilder(builder: (context, setState) {
          //   return AlertDialog(
          //     content: Stack(
          //       overflow: Overflow.visible,
          //       children: <Widget>[
          //         Positioned(
          //           right: -40.0,
          //           top: -40.0,
          //           child: InkResponse(
          //             onTap: () {
          //               Navigator.of(context).pop();
          //             },
          //             child: CircleAvatar(
          //               child: Icon(Icons.close),
          //               backgroundColor: Colors.red,
          //             ),
          //           ),
          //         ),
          //         Form(
          //           key: _formKey,
          //           child: Column(
          //             mainAxisSize: MainAxisSize.min,
          //             children: <Widget>[
          //               Padding(
          //                 padding: EdgeInsets.all(8.0),
          //                 child: MaterialInputField(
          //                   label: "Minimum Offer",
          //                   value: type == "Add" ? "" : asset.price,
          //                   onChanged: (val) {
          //                     setState(() {
          //                       formPrice = val;
          //                     });
          //                   },
          //                   textInputType: TextInputType.numberWithOptions(),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: EdgeInsets.all(8.0),
          //                 child: MaterialInputField(
          //                   label: "Maximum Offer",
          //                   value: type == "Add" ? "" : 0,
          //                   onChanged: (val) {
          //                     setState(() {
          //                       formQty = val;
          //                     });
          //                   },
          //                   textInputType: TextInputType.numberWithOptions(),
          //                 ),
          //               ),
          //               Padding(
          //                 padding: const EdgeInsets.all(8.0),
          //                 child: MaterialButtonWidget(
          //                   name: "Post",
          //                   onPressed: () async {
          //                     setState(() {
          //                       isLoading = true;
          //                       isDisabled = true;
          //                     });
          //                     await post(id, context, asset, postStateChanged);
          //                     setState(() {
          //                       isLoading = false;
          //                       isDisabled = false;
          //                     });
          //                   },
          //                   isDisable: isDisabled,
          //                   isLoading: isLoading,
          //                 ),
          //                 // child: RaisedButton(
          //                 //   child: Text("Submit"),
          //                 //   onPressed: () {
          //                 //     // if (_formKey.currentState.validate()) {
          //                 //     //   _formKey.currentState.save();
          //                 //     // }
          //                 //   },
          //                 // ),
          //               )
          //             ],
          //           ),
          //         ),
          //       ],
          //     ),
          //   );
          // });
        });
  }

  propertyUpdate(id, cont, PropertyAsset asset, final stateChanged) async {
    // print(formPrice);
    // print(formQty);
    if (minBidPrice.length < 1) {
      showToast("minimum offer cannot be empty");
      return;
    }
    if (maxBidPrice.length < 1) {
      showToast("maximum offer cannot be empty");
      return;
    }
    if(!isNumeric(minBidPrice)){
      showToast("minimum offer is not valid");
      return;
    }
    if(!isNumeric(maxBidPrice)){
      showToast("maximum offer is not valid");
      return;
    }
    if(checkDoubleValue(double.tryParse(minBidPrice))>checkDoubleValue(double.tryParse(maxBidPrice))){
      showToast("maximum offer cannot be less then minimum offer");
      return;
    }
    // if(widget.bids < 1){
    //   showToast("don't have enough bids");
    //   return;
    // }

    var request = {
      "users_id": asset.usersId,
      "minimum_offer": minBidPrice,
      "maximum_offer": maxBidPrice,
      "property_id": asset.id,
    };
    var p = showShortDialog(context,message1: "Updating post");
    var response = await propertyUpdatePostService(request);
    p.hide();
    if (response == null) {
      return;
    }
    if (response["ResponseCode"] == 1) {
      // Navigator.of(cont).pop();
      // widget.sellStateChanged();
      stateChanged();
      // stateChanged();
    } else {
      showToast("your available quantity: ");
    }
  }

  bool isDeleteLoading = false;
  bool isDeleteDisabled = false;

  dialogDeleteProperty(var postId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext stcontext,
                void Function(void Function()) setState) {
              bool isLoading = false, isDisabled = false;

              return StatefulBuilder(
                builder: (BuildContext stcontext,
                    void Function(void Function()) setState) {
                  return AlertDialog(
                    insetPadding: EdgeInsets.all(10),
                    backgroundColor: Colors.transparent,
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: darkTheme["popupBackground"],
                      ),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Form(
                        // key: _formKey1,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkResponse(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset(
                                  "assets/images/bid.png",
                                  width: 100,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: Text(
                                "Are you sure want to delete this post?",
                                style: TextStyle(color: Colors.white),
                              )),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          // padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                          child: CustomeElivatedButtonWidget(
                                            onPress: () async {
                                              // setState(() {
                                              //   isDeleteDisabled = true;
                                              //   isDeleteLoading = true;
                                              // });
                                              Navigator.of(context).pop();
                                              await deletePropertyPost(
                                                  postId,
                                                  context,
                                                  widget.sellStateChanged);
                                              // setState(() {
                                              //   isDeleteDisabled = false;
                                              //   isDeleteLoading = false;
                                              // });
                                              // widget.sellStateChanged();
                                            },
                                            name: "Delete",
                                            isDisable: isDeleteLoading,
                                            isLoading: isDeleteLoading,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: CustomeElivatedButtonWidget(
                                            onPress: () async {
                                              Navigator.pop(context);
                                            },
                                            name: "Cancel",
                                            // color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                // child: ,
              );
              //   AlertDialog(
              //   content: Stack(
              //     overflow: Overflow.visible,
              //     children: <Widget>[
              //       Positioned(
              //         right: -40.0,
              //         top: -40.0,
              //         child: InkResponse(
              //           onTap: () {
              //             Navigator.of(context).pop();
              //           },
              //           child: CircleAvatar(
              //             child: Icon(Icons.close),
              //             backgroundColor: Colors.red,
              //           ),
              //         ),
              //       ),
              //       Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: <Widget>[
              //           Text("Are you sure want to delete this post"),
              //           Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Flex(
              //               direction: Axis.horizontal,
              //               children: [
              //                 Expanded(
              //                   flex: 1,
              //                   child: MaterialButtonWidget(
              //                     name: "Yes",
              //                     onPressed: () {
              //                       deletePost(postId, context);
              //                     },
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Expanded(
              //                   flex: 1,
              //                   child: MaterialButtonWidget(
              //                     name: "No",
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     },
              //                   ),
              //                 ),
              //               ],
              //             ),
              //
              //             // child: RaisedButton(
              //             //   child: Text("Submit"),
              //             //   onPressed: () {
              //             //     // if (_formKey.currentState.validate()) {
              //             //     //   _formKey.currentState.save();
              //             //     // }
              //             //   },
              //             // ),
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              // );
            },
            // child:,
          );
        });
  }

  deletePropertyPost(postId, cont, fun) async {
    var request = {
      "property_id": postId,
    };
    var p = showShortDialog(context,message1: "Deleting post");
    var response = await propertyDeletePostService(request);
    p.hide();
    if (response["ResponseCode"] == 1) {
      showToast("post deleted successfully!");
      fun();
      // Navigator.of(cont).pop();
    }
  }
}

class SellOrderTabItemFile extends StatefulWidget {
  MyAsset asset;
  final sellStateChanged;
  int bids;

  SellOrderTabItemFile({this.asset, this.sellStateChanged, this.bids});

  @override
  _SellOrderTabItemFileState createState() => _SellOrderTabItemFileState();
}

class _SellOrderTabItemFileState extends State<SellOrderTabItemFile> {
  GlobalKey<FormState> _formKey;
  bool isLoading = false, isDisabled = false;

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
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.asset.symbol + " " + widget.asset.fileType,
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Colors.white),
                ),
              ),
              Text(
                widget.asset.bidQuantity + " Files",
                style: TextStyle(
                  fontSize: 14,
                  color: darkTheme["secondaryColor"],
                ),
              ),
            ],
          ),
          SizedBox(
            height: 8,
          ),
          Text(
            widget.asset.cityName + " " + widget.asset.town,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 8,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: Text(
                "PKR " + widget.asset.bidPrice + " /file",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: darkTheme["secondaryColor"]),
              ),
            ),
            Row(children: [
              SizedBox(
                width: 10,
              ),
              CustomeElivatedButtonWidget(
                onPress: () {
                  dialog(widget.asset.actionId, "Update", widget.asset);
                },
                name: "Update",
              ),
              // ElevatedButton(
              //   onPressed: () {
              //   },
              //   // color: Colors.green,
              //   style: ElevatedButton.styleFrom(
              //       primary: Colors.red,
              //       // primary: Colors.teal,
              //       onPrimary: Colors.white,
              //       onSurface: Colors.grey,
              //       textStyle: TextStyle(
              //         fontSize: 10,
              //       )),
              //
              //   child: Text(
              //     'Update',
              //     style: TextStyle(color: Colors.white),
              //   ),
              // ),
              SizedBox(
                width: 10,
              ),
              CustomeElivatedButtonWidget(
                color: Colors.red,
                name: "Delete",
                onPress: () {
                  dialogDelete(widget.asset.postId);
                },
              ),
              SizedBox(
                width: 10,
              ),
            ]),
          ]),
        ],
      ),
    );
  }

  dialogDelete(var postId) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext stcontext,
                void Function(void Function()) setState) {
              bool isLoading = false, isDisabled = false;

              return StatefulBuilder(
                builder: (BuildContext stcontext,
                    void Function(void Function()) setState) {
                  return AlertDialog(
                    insetPadding: EdgeInsets.all(10),
                    backgroundColor: Colors.transparent,
                    content: Container(
                      width: MediaQuery.of(context).size.width,
                      // height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: darkTheme["popupBackground"],
                      ),
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                      child: Form(
                        // key: _formKey1,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Align(
                                alignment: Alignment.topRight,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkResponse(
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: CircleAvatar(
                                        child: Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        backgroundColor: Colors.transparent,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: Image.asset(
                                  "assets/images/bid.png",
                                  width: 100,
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Center(
                                  child: Text(
                                "Are you sure want to delete this post?",
                                style: TextStyle(color: Colors.white),
                              )),
                              Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Container(
                                          // padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                          child: CustomeElivatedButtonWidget(
                                            onPress: () async {
                                              // setState(() {
                                              //   isLoading = true;
                                              //   isDisabled = true;
                                              // });
                                              Navigator.of(context).pop();
                                              await deletePost(postId, context,
                                                  widget.sellStateChanged);
                                              // setState(() {
                                              //   isLoading = false;
                                              //   isDisabled = false;
                                              // });
                                              // widget.sellStateChanged();
                                            },
                                            name: "Delete",
                                            isDisable: isDisabled,
                                            isLoading: isLoading,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 0, 0, 0),
                                          child: CustomeElivatedButtonWidget(
                                            onPress: () async {
                                              Navigator.pop(context);
                                            },
                                            name: "Cancel",
                                            // color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
                // child: ,
              );
              //   AlertDialog(
              //   content: Stack(
              //     overflow: Overflow.visible,
              //     children: <Widget>[
              //       Positioned(
              //         right: -40.0,
              //         top: -40.0,
              //         child: InkResponse(
              //           onTap: () {
              //             Navigator.of(context).pop();
              //           },
              //           child: CircleAvatar(
              //             child: Icon(Icons.close),
              //             backgroundColor: Colors.red,
              //           ),
              //         ),
              //       ),
              //       Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: <Widget>[
              //           Text("Are you sure want to delete this post"),
              //           Padding(
              //             padding: const EdgeInsets.all(8.0),
              //             child: Flex(
              //               direction: Axis.horizontal,
              //               children: [
              //                 Expanded(
              //                   flex: 1,
              //                   child: MaterialButtonWidget(
              //                     name: "Yes",
              //                     onPressed: () {
              //                       deletePost(postId, context);
              //                     },
              //                   ),
              //                 ),
              //                 SizedBox(
              //                   width: 10,
              //                 ),
              //                 Expanded(
              //                   flex: 1,
              //                   child: MaterialButtonWidget(
              //                     name: "No",
              //                     onPressed: () {
              //                       Navigator.of(context).pop();
              //                     },
              //                   ),
              //                 ),
              //               ],
              //             ),
              //
              //             // child: RaisedButton(
              //             //   child: Text("Submit"),
              //             //   onPressed: () {
              //             //     // if (_formKey.currentState.validate()) {
              //             //     //   _formKey.currentState.save();
              //             //     // }
              //             //   },
              //             // ),
              //           )
              //         ],
              //       ),
              //     ],
              //   ),
              // );
            },
            // child:,
          );
        });
  }

  deletePost(postId, cont, func) async {
    User user = await getUser();
    var request = {
      "post_id": postId,
      "user_id": user.id,
    };
    ProgressDialog progressDialog =
        new ProgressDialog(context, isDismissible: false);
    progressDialog.update(message: "Deleting Post");
    progressDialog.show();
    var response = await deleteFilePost(request);
    progressDialog.hide();
    if (response == null) {
      func();
      return;
    }
    if (response["ResponseCode"] == 1) {
      getRequest(REFRESH_MARKET_FIREBASE_DATA);
      showToast("post deleted successfully!");
      func();
      // Navigator.of(cont).pop();
    }
  }

  var formPrice = "", formQty = "";

  dialog(var id, var type, MyAsset asset) {
    if (widget.bids < 0) {
      showToast("waiting for bids");
      return;
    }
    if (type == "Update") {
      formPrice = asset.bidPrice;
      formQty = asset.bidQuantity;
    }
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
            builder: (BuildContext stcontext,
                void Function(void Function()) setState) {
              return AlertDialog(
                insetPadding: EdgeInsets.all(10),
                backgroundColor: Colors.transparent,
                content: Container(
                  width: MediaQuery.of(context).size.width,
                  // height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: darkTheme["popupBackground"],
                  ),
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                  child: Form(
                    // key: _formKey1,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Align(
                            alignment: Alignment.topRight,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Material(
                                color: Colors.transparent,
                                child: InkResponse(
                                  onTap: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: CircleAvatar(
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                    ),
                                    backgroundColor: Colors.transparent,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Align(
                            alignment: Alignment.bottomCenter,
                            child: Image.asset(
                              "assets/images/bid.png",
                              width: 100,
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                            child: Text(
                              'Enter the price',
                              style: TextStyle(
                                color: darkTheme['primaryTextColor'],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 3),
                            child: CircularInputField(
                              hintText: "Bid Price Per File",
                              value: type == "Update" ? formPrice : "",
                              onChanged: (val) {
                                formPrice = val;
                              },
                              type: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
                            child: Text(
                              'Number of Files',
                              style: TextStyle(
                                color: darkTheme['primaryTextColor'],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 3),
                            child: CircularInputField(
                              hintText: "Number of Files",
                              value: type == "Update" ? formQty : "",
                              onChanged: (val) {
                                formQty = val;
                              },
                              type: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Center(
                              child: Text(
                                (convertToNumber(widget.bids) + convertToNumber(asset.bidQuantity)).toString() + " available bids",
                                style: TextStyle(
                                  color: Colors.greenAccent
                                ),
                              ),
                            ),

                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: CustomeElivatedButtonWidget(
                                        onPress: () async {
                                          // setState(() {
                                          //   isLoading = true;
                                          //   isDisabled = true;
                                          // });
                                          Navigator.pop(context);
                                          await post(id, context, asset,
                                              widget.sellStateChanged);
                                          // setState(() {
                                          //   isLoading = false;
                                          //   isDisabled = false;
                                          // });
                                        },
                                        name: "Update",
                                        isDisable: isDisabled,
                                        isLoading: isLoading,
                                      ),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            // child: ,
          );
        });
  }

  post(id, cont, MyAsset asset, func) async {
    if (!isNumeric(formPrice)) {
      showToast("invalid price");
      return;
    }
    if (!isNumeric(formQty)) {
      showToast("invalid qty");
      return;
    }
    if (formPrice.length < 1) {
      showToast("price cannot be empty");
      return;
    }
    if (formQty.length < 1) {
      showToast("quantity cannot be empty");
      return;
    }

    print(widget.asset.bidQuantity);
    print(widget.bids);
    if (widget.bids + int.tryParse(widget.asset.bidQuantity) <
        int.tryParse(formQty)) {
      showToast("don't have enough bids");
      showWalletActionSheet(context,data: {"func": widget.sellStateChanged});
      return;
    }
    // var request = {
    //   "qty": formQty,
    //   "price": formPrice,
    //   "file_action_id": marketfile.fileActionId,
    //   "owner_id": user.id,
    //   "file_id": marketfile.fileId,
    //   "symbol_id": marketfile.qkpFileSymbolId,
    //   "post_id": postId,
    //   "type": type
    // };
    ProgressDialog progressDialog =
        new ProgressDialog(context, isDismissible: false);
    progressDialog.update(message: "Updating Post");

    progressDialog.show();
    var request = {
      "qty": formQty,
      "price": formPrice,
      "file_action_id": id,
      "owner_id": asset.ownerId,
      "file_id": asset.qkpFileId,
      "symbol_id": asset.qkpFileSymbolId,
      "post_id": asset.postId,
      "type": "update"
    };
    var response = await updatePostFile(request);
    progressDialog.hide();

    if (response == null) {
      func();
      return;
    }
    if (response["ResponseCode"] == 1) {
      getRequest(REFRESH_MARKET_FIREBASE_DATA);
      showToast("updated successfully");
      func();
    } else {
      showToast("your available quantity: ");
    }
  }
}

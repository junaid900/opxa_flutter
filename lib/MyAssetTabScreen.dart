import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/CustomeElivatedButton.dart';
import 'package:qkp/EmptyLayout.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/MaterialButton.dart';
import 'package:qkp/MaterialInputField.dart';
import 'package:qkp/Model/IntranferFile.dart';
import 'package:qkp/Model/MyAsset.dart';
import 'package:qkp/Model/PropertyAsset.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';

import 'CircularInputField.dart';
import 'Model/User.dart';
import 'Network/URLS.dart';
import 'Network/http_requests.dart';

class MyAssetTabWidget extends StatefulWidget {
  List<MyAsset> assets;
  final stateChanged;
  List<bool> isSelected;
  List<PropertyAsset> propertyAssetList;
  int numberOfbids = 0;

  MyAssetTabWidget(
      {this.assets,
      this.stateChanged,
      this.isSelected,
      this.propertyAssetList});

  @override
  _MyAssetTabWidgetState createState() => _MyAssetTabWidgetState();
}

class _MyAssetTabWidgetState extends State<MyAssetTabWidget> {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  List<MyAsset> data = [];
  User user;
  bool isEmpty = false;
  int numberOfBids = -1;

  getPageData() async {
    // data.addAll(widget.assets);
    // setState(() {
    //   data = data;
    // });
    // if (data.length < 1) {
    //   setState(() {
    //     isEmpty = true;
    //   });
    // } else {
    //   print("===========++>here");
    //   setState(() {
    //     isEmpty = false;
    //   });
    // }
  }

  getAssets() async {
    user = await getUser();
    // data.clear();
    setState(() {
      numberOfBids = -1;
    });
    var owner_id = await user.id;
    var request = {"owner_id": owner_id};

    var res2 = await getUserBidsService({"user_id": user.id});
    if (res2 != null) {
      setState(() {
        numberOfBids = int.tryParse(res2["list"]["bids"].toString());
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
    var _width = MediaQuery.of(context).size.width;

    return widget.isSelected[0]
        ? widget.assets.length < 1
            ? Center(
                child: EmptyLayoutWidget(
                  message: "Looking for assets",
                ),
              )
            : ListView(
                children: List.generate(widget.assets.length, (index) {
                // print(new MyAsset().toJson().toString());
                return MyAssetTabItemFile(
                    asset: widget.assets[index],
                    numOfBids: numberOfBids,
                    postStateChanged: () {
                      widget.stateChanged();
                      getAssets();
                    });
              }))
        : widget.propertyAssetList.length < 1
            ? EmptyLayoutWidget(
                message: "Looking for your property assets",
              )
            : Column(
                children:
                    List.generate(widget.propertyAssetList.length, (index) {
                return PropertyAssetTabItemFile(
                    asset: widget.propertyAssetList[index],
                    numOfBids: numberOfBids,
                    postStateChanged: () {
                      widget.stateChanged();
                      getAssets();
                    });
              }));
  }
}

class MyAssetTabItemFile extends StatefulWidget {
  MyAsset asset;
  final postStateChanged;
  int numOfBids;

  MyAssetTabItemFile({this.asset, this.numOfBids, this.postStateChanged});

  @override
  _MyAssetTabItemFileState createState() => _MyAssetTabItemFileState();
}

class _MyAssetTabItemFileState extends State<MyAssetTabItemFile> {
  GlobalKey<FormState> _formKey;
  bool isLoading = false;
  bool isDisabled = false;

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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  widget.asset.symbol + " " + widget.asset.fileType,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 6,
          ),
          Text(
            (int.tryParse(widget.asset.availableQuantity) -
                        int.tryParse(widget.asset.postedQty)) <
                    1
                ? "0 Files"
                : (int.tryParse(widget.asset.availableQuantity) -
                            int.tryParse(widget.asset.postedQty))
                        .toString() +
                    " Files ",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
          Text(
            widget.asset.cityName,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            SizedBox(
              width: 10,
            ),
            Container(
              width: getWidth(context) / 2,
              child: CustomeElivatedButtonWidget(
                onPress: () {
                  if (widget.numOfBids == null) {
                    showToast(
                        "don't have enough bids please purchase to post file");
                    showWalletActionSheet(context);
                    return;
                  }
                  // Navigator.pop(context);
                  dialog(widget.asset.actionId, "Add", widget.asset,
                      widget.postStateChanged);
                },
                name: "Post",
              ),
            )
          ]),
        ],
      ),
    );
  }

  var formPrice = "", formQty = "";

  dialog(var id, var type, MyAsset asset, final postStateChanged) {
    var con = context;
    if (type == "Update") {
      // formPrice = asset.bidPrice;
      // formQty = asset.bidQuantity;
    }
    if (widget.numOfBids == -1) {
      showToast("waiting for bids");
      return;
    }
    int avg = 0;
    if (asset.avgPrice != null && asset.avgPrice != "0") {
      avg = double.tryParse(asset.avgPrice).floor();
    }
    showDialog(
        context: context,
        builder: (BuildContext mcontext) {
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
                              onChanged: (val) {
                                formQty = val;
                              },
                              type: TextInputType.number,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 15, 20, 10),
                            child: Text(
                              "you have " +
                                  widget.numOfBids.toString() +
                                  " bids",
                              style: TextStyle(
                                color: Colors.green,
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
                                          // if(checkD)
                                          if (!isNumeric(formQty)) {
                                            showToast("invalid qty");
                                            return;
                                          }
                                          if (!isNumeric(formPrice)) {
                                            showToast("invalid price");
                                            return;
                                          }
                                          if (formQty.length < 0) {
                                            showToast(
                                                "quantity cannot be empty");
                                            return;
                                          }

                                          if (widget.numOfBids <
                                              int.tryParse(formQty)) {
                                            showToast("don't have enough bids");
                                            Navigator.pop(mcontext);
                                            showWalletActionSheet(context,
                                                data: {
                                                  "func": () {
                                                    widget.postStateChanged();
                                                  }
                                                });
                                            playStopSound();
                                            return;
                                          }

                                          if ((avg - (avg / 2)) >
                                              int.tryParse(formPrice)) {
                                            playWarningSound();
                                            // showToast();
                                            await showDialog(
                                                context: context,
                                                builder: (mContext) =>
                                                    AlertDialog(
                                                      insetPadding:
                                                          EdgeInsets.all(10),
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      content: Container(
                                                        color: Colors.red,
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                                20, 10, 10, 20),
                                                        child: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Text(
                                                              "your price is too low then avg price current file average price = " +
                                                                  avg.toString(),
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            CustomeElivatedButtonWidget(
                                                                onPress:
                                                                    () async {
                                                                  // setState(() {
                                                                  //   isLoading =
                                                                  //       true;
                                                                  //   isDisabled =
                                                                  //       true;
                                                                  // });
                                                                  print(
                                                                      "========+> in posting");
                                                                  Navigator.pop(
                                                                      context);
                                                                  Navigator.pop(
                                                                      context);
                                                                  post(
                                                                      id,
                                                                      context,
                                                                      asset,
                                                                      postStateChanged);
                                                                  // Navigator.pop(context);
                                                                  // Navigator.pop(context);
                                                                  // widget.postStateChanged();
                                                                  // setState(() {
                                                                  //   isLoading =
                                                                  //       false;
                                                                  //   isDisabled =
                                                                  //       false;
                                                                  // });
                                                                },
                                                                name:
                                                                    "Continue"),
                                                            CustomeElivatedButtonWidget(
                                                                onPress: () {
                                                                  Navigator.of(
                                                                          mContext)
                                                                      .pop();
                                                                },
                                                                color: Colors
                                                                    .red[800],
                                                                name: "Cancel")
                                                          ],
                                                        ),
                                                      ),
                                                    ));
                                            return;
                                          }
                                          // setState(() {
                                          //   isLoading = true;
                                          //   isDisabled = true;
                                          // });
                                          Navigator.pop(context);
                                          post(id, context, asset,
                                              postStateChanged);
                                          // setState(() {
                                          //   isLoading = false;
                                          //   isDisabled = false;
                                          // });
                                          // widget.postStateChanged();
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
        });
  }

  post(id, cont, MyAsset asset, final stateChanged) async {
    // print(formPrice);
    // print(formQty);
    if (formPrice.length < 1) {
      showToast("price cannot be empty");
      return;
    }
    if (formQty.length < 1) {
      showToast("quantity cannot be empty");
      return;
    }
    if (!isNumeric(formPrice)) {
      showToast("invalid price");
      return;
    }
    if (!isNumeric(formQty)) {
      showToast("invalid price");
      return;
    }
    // print(isDisabled);
    // print("here2=>" + isDisabled.toString());
    // disable();
    // print("afterDisable" + isDisabled.toString());
    var request = {
      "qty": formQty,
      "price": formPrice,
      "file_action_id": id,
      "owner_id": asset.ownerId,
      "file_id": asset.qkpFileId,
      "symbol_id": asset.qkpFileSymbolId,
      "post_type": "portfolio",
      "type": 'post'
    };
    ProgressDialog progressDialog = new ProgressDialog(context);
    progressDialog.update(message: "Posting file");
    progressDialog.show();
    var response = await postFile(request);
    progressDialog.hide();
    // print("here=>" + isDisabled.toString());
    if (response["ResponseCode"] == 1) {
      // stateChanged();
      getRequest(REFRESH_MARKET_FIREBASE_DATA);
      widget.postStateChanged();
    } else {
      showToast("your available quantity: ");
    }
  }
}

class PropertyAssetTabItemFile extends StatefulWidget {
  PropertyAsset asset;
  final postStateChanged;
  int numOfBids;

  PropertyAssetTabItemFile({this.asset, this.numOfBids, this.postStateChanged});

  @override
  _PropertyAssetTabItemFileState createState() =>
      _PropertyAssetTabItemFileState();
}

class _PropertyAssetTabItemFileState extends State<PropertyAssetTabItemFile> {
  GlobalKey<FormState> _formKey;
  bool isLoading = false;
  bool isDisabled = false;

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
                          widget.asset.price + " PKR",
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
                        ],
                      )
                    ],
                  )),
              Expanded(
                  flex: 1,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: FadeInImage(
                      placeholder: AssetImage(
                          "assets/images/house_loading_placeholder.gif"),
                      image: NetworkImage(
                        url + widget.asset.image,
                      ),
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
          Container(
            width: getWidth(context) / 2,
            margin: EdgeInsets.fromLTRB(3, 0, 0, 0),
            // width: getWidth(context)/2.5,
            // width: getWidth(context) * .50,
            child: CustomeElivatedButtonWidget(
              onPress: () {
                propertyPostDialog(widget.asset.id, context, widget.asset,
                    widget.postStateChanged);
              },
              name: "Post",
            ),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  var formPrice = "", formQty = "", minBidPrice = "", maxBidPrice = "";

  propertyPostDialog(
      var id, var type, PropertyAsset asset, final postStateChanged) {
    if (type == "Update") {
      // formPrice = asset.bidPrice;
      // formQty = asset.bidQuantity;
    }

    showDialog(
        context: context,
        builder: (BuildContext context) {
          // var isLoading = false;
          // var isDisable = false;
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
                              'Enter Minimum Price',
                              style: TextStyle(
                                color: darkTheme['primaryTextColor'],
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 3),
                            child: CircularInputField(
                              hintText: "Minimum Bid Price",
                              onChanged: (val) {
                                minBidPrice = val;
                              },
                              type: TextInputType.number,
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
                              hintText: "Maximum Bid Price",
                              onChanged: (val) {
                                maxBidPrice = val;
                              },
                              type: TextInputType.number,
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
                                          setState(() {
                                            isLoading = true;
                                            isDisabled = true;
                                          });
                                          Navigator.pop(context);
                                          await propertyPost(id, context, asset,
                                              postStateChanged);
                                          setState(() {
                                            isLoading = false;
                                            isDisabled = false;
                                          });
                                          // widget.postStateChanged();
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
        });
  }

  propertyPost(id, cont, PropertyAsset asset, final stateChanged) async {
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
    if (convertToNumber(minBidPrice) >= convertToNumber(maxBidPrice)) {
      showToast("Starting bid price cannot be greater then max price");
      return;
    }
    var request = {
      "user": asset.usersId,
      "minimum_offer": minBidPrice,
      "maximum_offer": maxBidPrice,
      "property_id": asset.id,
      "type": "Asset_Post"
    };
    ProgressDialog progressDialog = new ProgressDialog(context);
    progressDialog.update(message: "Posting file");
    progressDialog.show();
    var response = await addPropertyService(request);
    progressDialog.hide();
    if (response == null) {
      stateChanged();
      return;
    }
    if (response["ResponseCode"] == 1) {
      stateChanged();
    } else {
      stateChanged();
    }
  }
}

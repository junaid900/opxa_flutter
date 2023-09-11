import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/EmptyLayout.dart';
import 'package:qkp/Model/Property.dart';
import 'package:qkp/Model/PropertyBuyOrder.dart';

import 'CustomeElivatedButton.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/MyAsset.dart';
import 'Model/User.dart';
import 'Network/constant.dart';
import 'Network/network.dart';

class BuyOrderTabWidget extends StatefulWidget {
  List<MyAsset> buyOrder;
  List<PropertyBuyOrder> propertyBuyOrderList;
  List<bool> isSelected;

  final stateChanged;

  BuyOrderTabWidget(
      {this.buyOrder,
      this.propertyBuyOrderList,
      this.isSelected,
      this.stateChanged});

  @override
  _BuyOrderTabWidgetState createState() => _BuyOrderTabWidgetState();
}

class _BuyOrderTabWidgetState extends State<BuyOrderTabWidget> {
  List<MyAsset> data = [];
  User user;
  bool isEmpty = false;
  int numberOfBids = -1;

  getUserBids() async {
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
    // getPageData();
  }

  getPageData() async {
    user = await getUser();
    data.clear();
    // var owner_id = await user.id;
    // var request = {"owner_id": owner_id};
    setState(() {
      data = widget.buyOrder;
    });
    if (data.length < 1) {
      setState(() {
        isEmpty = true;
      });
    } else {
      setState(() {
        isEmpty = false;
      });
    }

    // var res = await getMyAssetsService(request);
    // print("my res=>" + res.toString());
    // if (res["ResponseCode"] == 1) {
    //   var assetsMapList = res["Assets"];
    //   for (int i = 0; i < assetsMapList.length; i++) {
    //     MyAsset asset = new MyAsset();
    //     asset.fromJson(assetsMapList[i]);
    //     setState(() {
    //       data.add(asset);
    //     });
    //   }
    getUserBids();
  }

  @override
  void initState() {
    getPageData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      scrollDirection: Axis.vertical,
      children: widget.isSelected[0]
          ? data.length > 0
              ? List.generate(
                  data.length,
                  (index) => BuyOrderTabItemWidget(
                      buyOrder: data[index],
                      user: user,
                      numberOfBids: numberOfBids,
                      stateChanged: () {
                        getUserBids();
                        widget.stateChanged();
                      }))
              : [
                  Center(
                    child: EmptyLayoutWidget(
                      message: "No data found in buy orders",
                    ),
                  )
                ]
          : widget.propertyBuyOrderList.length > 0
              ? List.generate(
                  widget.propertyBuyOrderList.length,
                  (index) => PropertyBuyOrderWidget(
                        propertyBuyOrder: widget.propertyBuyOrderList[index],
                        user: user,
                      ))
              : [
                  Center(
                    child: EmptyLayoutWidget(
                      message: "No data found in buy orders",
                    ),
                  )
                ],
    );
  }
}

class PropertyBuyOrderWidget extends StatelessWidget {
  PropertyBuyOrder propertyBuyOrder;
  User user;

  PropertyBuyOrderWidget({this.propertyBuyOrder, this.user});
  goToPropertyDetail(context){
    Property property = new Property(
      id: propertyBuyOrder.id,
      propertyName: propertyBuyOrder.propertyName,
      typeId: propertyBuyOrder.typeId,
      subTypeId: propertyBuyOrder.subTypeId,
      cityId: propertyBuyOrder.cityId,
      townId: propertyBuyOrder.townId,
      societyId: propertyBuyOrder.societyId,
      lat: propertyBuyOrder.lat,
      long: propertyBuyOrder.long,
      address: propertyBuyOrder.address,
    );
    Navigator.pushNamed(context, 'trade_property', arguments: property);
  }
  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onTap: () {
        goToPropertyDetail(context);
      },
      child: Container(
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
                            propertyBuyOrder.price + " PKR",
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
                                propertyBuyOrder.propertyName,
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
                                    propertyBuyOrder.bedRooms + " Beds",
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
                                    propertyBuyOrder.bathRooms + " Baths",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 13,
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20,),
                        Center(
                          child: SizedBox(
                            width: getWidth(context) *.6,
                            child: CustomeElivatedButtonWidget(
                              onPress: (){
                                goToPropertyDetail(context);
                              },
                              name: "View",
                            ),
                          ),
                        )
                      ],
                    )),
                // Expanded(
                //     flex: 1,
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(10),
                //       child:
              ],
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}

class BuyOrderTabItemWidget extends StatefulWidget {
  MyAsset buyOrder;
  User user;
  int numberOfBids;
  Function stateChanged;

  BuyOrderTabItemWidget(
      {this.buyOrder, this.user, this.numberOfBids, this.stateChanged});

  @override
  _BuyOrderTabItemWidgetState createState() => _BuyOrderTabItemWidgetState();
}

class _BuyOrderTabItemWidgetState extends State<BuyOrderTabItemWidget> {
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
                  widget.buyOrder.symbol + " " + widget.buyOrder.fileType,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
              Text(
                widget.buyOrder.bidQuantity + " Files",
                style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            widget.buyOrder.cityName + " " + widget.buyOrder.town,
            style: TextStyle(
              fontSize: 13,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Flexible(
              child: Text(
                "PKR " + widget.buyOrder.bidPrice + " /file",
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.blue),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                CustomeElivatedButtonWidget(
                  name: "Update",
                  onPress: () async {
                    var data = await buyDialog(
                        "update",
                        0,
                        widget.user,
                        widget.buyOrder,
                        context,
                        null, (context, price, qty, biderId) async {
                      var b = await buy(context, 'update', price, qty, biderId);
                      return true;
                    }, widget.buyOrder, widget.buyOrder.qkpFileBidId,
                        numberOfBids: widget.numberOfBids,
                        request_type: "Buy_Order");
                    // if (data == true) widget.refreshPage();
                  },
                ),
                SizedBox(
                  width: 2,
                ),
                CustomeElivatedButtonWidget(
                  name: "Delete",
                  color: Colors.red,
                  onPress: () async {
                    await deleteBid(
                        widget.buyOrder.qkpFileBidId, widget.user.id);
                    // if (data == true) widget.refreshPage();
                  },
                ),
              ],
            ),
          ]),
        ],
      ),
    );
  }

  deleteBid(bidId, userId) async {
    var request = {"bid_id": bidId, "user_id": userId};
    ProgressDialog progressDialog =
        new ProgressDialog(context, isDismissible: false);
    progressDialog.update(message: "Deleting Bid");
    progressDialog.show();
    var response = await deleteFileBid(request);
    progressDialog.hide();
    if (response["ResponseCode"] == 1) {
      showToast("post deleted successfully!");
      widget.stateChanged();
    }
  }

  Future<bool> buy(cont, type, formPrice1, formQty1, bidId) async {
    if (!isNumeric(formPrice1)) {
      showToast("not a valid price");
      playWarningSound();
      return false;
    }
    if (!isNumeric(formQty1)) {
      showToast("not a valid quanitiy");
      playWarningSound();
      return false;
    }
    // if (_mFuncLoading) {
    //   showToast(
    //       "you are clicking too fast please wait an request is proccessing");
    //   playWarningSound();
    //   return false;
    // }
    if (formPrice1.length < 1) {
      showToast("price cannot be empty");
      playStopSound();
      return false;
    }
    if (formQty1.length < 1) {
      showToast("quantity cannot be empty");
      playStopSound();
      return false;
    }

    var request = {
      "owner_id": widget.buyOrder.ownerId,
      "bider_id": widget.user.id,
      "quantity": widget.buyOrder.quantity,
      "price": widget.buyOrder.price,
      "bid_quantity": formQty1,
      "bid_price": formPrice1,
      "qkp_file_id": widget.buyOrder.qkpFileId,
      "file_action_id": "",
      "post_id": "",
      "symbol_id": widget.buyOrder.qkpFileSymbolId,
      "type": type,
      "bidid": bidId
    };
    ProgressDialog progressDialog =
        new ProgressDialog(context, isDismissible: false);
    progressDialog.update(message: "Updating Bid");
    progressDialog.show();
    var response = await bidFiles(request);
    progressDialog.hide();
    if (response == null) {
      playStopSound();
      widget.stateChanged();
      return false;
    }
    if (response["ResponseCode"] == 1) {
      playBidSound();
      widget.stateChanged();
      // navBidSuccessful(context);
      // Navigator.of(cont).pop();
    } else {
      playStopSound();
      widget.stateChanged();
    }
    return true;
  }
}

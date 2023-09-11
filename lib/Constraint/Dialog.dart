import 'dart:io';
import 'dart:ui';
import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/CustomeElivatedButton.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/IntranferFile.dart';
import 'package:qkp/Model/Package.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:intl/intl.dart';
import 'package:qkp/Network/network.dart';
import '../CircularInputField.dart';

bool isLoading;

Future<bool> buyDialog(var type, assetsQty, user, marketfile, context,
    _formKey1, buyfunc, buy, biderId,
    {numberOfBids = 0, request_type = "MarketFile"}) async {
  _formKey1 = GlobalKey();
  var formPrice1 = "", formQty1 = "";
  formPrice1 = "";
  formQty1 = "";
  var mcontext = context;
  // print(marketfile.fileId) ;
  if (numberOfBids < 0) {
    showToast("please wait checking your bids");
    return false;
  }
  if (numberOfBids < 1 && type != "update") {
    showToast("please purchase bids you have 0 bids in wallet");
    // showWalletActionSheet(mcontext);
    showWalletActionSheet(mcontext);
    return false;
  }

  if (user.id == marketfile.ownerId) {
    print(user.id + '---' + marketfile.ownerId);
    print(type);
    if (type != "buy_limit" && type != "buy_kill" && type != "update") {
      print("user_id" + type);
      showToast("There is no file in the market to Buy");
      playStopSound();
      return false;
    }
  }
  if (type == 'buy' && int.tryParse(marketfile.price) <= 0) {
    print("==========++>" + marketfile.price);
    playStopSound();
    showToast("There is no file in the market to Buy");
    return false;
  }
  if (type == 'buy') {
    formPrice1 = marketfile.price;
  }
  if (type == "update") {
    formQty1 = buy.bidQuantity;
    formPrice1 = buy.bidPrice;
  }
  print('market price: ' + marketfile.quantity);
  if (type == "buy_kill" && int.tryParse(marketfile.price) <= 0) {
    playStopSound();
    return false;
  }
  if (type == "instant_buy") {
    formQty1 = marketfile.quantity;
    formPrice1 = marketfile.price;
  }

  isLoading = false;
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.all(10),
              backgroundColor: Colors.transparent,
              content: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    // height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkTheme["popupBackground"],
                    ),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
                    child: Form(
                      key: _formKey1,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: TouchableOpacity(
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
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                "assets/images/bid.png",
                                width: 100,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  if (marketfile.price != null)
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: darkTheme['bgCellColor'],
                                        ),
                                        margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 8),
                                              child: Text(
                                                'Rs',
                                                style: TextStyle(
                                                  color: darkTheme[
                                                      'primaryTextColor'],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              child: Text(
                                                marketfile.price,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: darkTheme[
                                                        'primaryTextColor'],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 0),
                                              child: Text(
                                                'Offer Price',
                                                style: TextStyle(
                                                    color: darkTheme[
                                                        'secondaryColor'],
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (request_type != "Buy_Order")
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: darkTheme['bgCellColor'],
                                        ),
                                        margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 8),
                                              child: Text(
                                                'Rs',
                                                style: TextStyle(
                                                  color: darkTheme[
                                                      'primaryTextColor'],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              child: Text(
                                                marketfile.highestPrice,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: darkTheme[
                                                        'primaryTextColor'],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 0),
                                              child: Text(
                                                'Highest Bid',
                                                style: TextStyle(
                                                    color: darkTheme[
                                                        'secondaryColor'],
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  if (marketfile.quantity != null)
                                    Expanded(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                          color: darkTheme['bgCellColor'],
                                        ),
                                        margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                        padding: EdgeInsets.all(10),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 8),
                                              child: Text(
                                                'No',
                                                style: TextStyle(
                                                  color: darkTheme[
                                                      'primaryTextColor'],
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 0, 0, 0),
                                              child: Text(
                                                marketfile.quantity,
                                                style: TextStyle(
                                                    fontSize: 12,
                                                    color: darkTheme[
                                                        'primaryTextColor'],
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.fromLTRB(
                                                      0, 8, 0, 0),
                                              child: Text(
                                                'Total File',
                                                style: TextStyle(
                                                    color: darkTheme[
                                                        'secondaryColor'],
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                ],
                              ),
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
                                readOnly: type == "buy" ? true : false,
                                value: type == "buy"
                                    ? marketfile.price
                                    : type == "update"
                                        ? buy.bidPrice
                                        : type == "instant_buy"
                                            ? marketfile.price
                                            : "",
                                type: TextInputType.number,
                                onChanged: (val) {
                                  formPrice1 = val;
                                },
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
                                value: type == "update"
                                    ? buy.bidQuantity
                                    : type == "instant_buy"
                                        ? marketfile.quantity
                                        : "",
                                type: TextInputType.number,
                                TextColor: formQty1.length > 0 && type == "buy"
                                    ? int.tryParse(formQty1) != null
                                        ? int.tryParse(formQty1) >
                                                int.tryParse(
                                                    marketfile.quantity)
                                            ? Colors.red
                                            : darkTheme[
                                                'primaryBackgroundColor']
                                        : Colors.red
                                    : darkTheme['primaryBackgroundColor'],
                                onChanged: (val) {
                                  formQty1 = val;
                                  setState(() {
                                    formQty1 = val;
                                  });
                                },
                              ),
                            ),
                            if (type == "update")
                              int.tryParse(formQty1) != null &&
                                      int.tryParse(formQty1) >
                                          numberOfBids +
                                              int.tryParse(buy.bidQuantity)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 0),
                                      child: Text(
                                        "Not have enough bids you current bids are " +
                                            (convertToNumber(buy.bidQuantity) +
                                                    convertToNumber(
                                                        numberOfBids))
                                                .toString(),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : SizedBox(),
                            if (type == "instant_buy")
                              int.tryParse(formQty1) != null &&
                                      int.tryParse(formQty1) >
                                          numberOfBids +
                                              int.tryParse(buy.bidQuantity)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 0),
                                      child: Text(
                                        "Not have enough bids for instant sell you current bids are " +
                                            numberOfBids.toString(),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : SizedBox(),
                            if (type != "update" && type != "instant_buy")
                              int.tryParse(formQty1) != null &&
                                      int.tryParse(formQty1) > numberOfBids
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 0),
                                      child: Text(
                                        "Not have enough bids you current bids are " +
                                            numberOfBids.toString(),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : SizedBox(),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              // print(numberOfBids);
                                              // print(buy.bidQuantity);
                                              // print(marketfile.quantity);
                                              // return;

                                              // return;
                                              //

                                              if (formQty1.length > 0 &&
                                                  type == "buy") {
                                                if (int.tryParse(formQty1) >
                                                    int.tryParse(
                                                        marketfile.quantity)) {
                                                  playWarningSound();
                                                  showToast(
                                                      "cannot trade quantity more then :" +
                                                          marketfile.quantity);
                                                  return;
                                                }
                                              }
                                              // var qty = 0;
                                              // if (type == "instant_sell") {
                                              //   qty = marketfile.quantity;
                                              // } else {
                                              //
                                              // }
                                              var check = false;
                                              if (type == "update") {
                                                if (int.tryParse(formQty1) !=
                                                        null &&
                                                    int.tryParse(formQty1) >
                                                        (numberOfBids +
                                                            int.tryParse(buy
                                                                .bidQuantity))) {
                                                  Navigator.pop(context);
                                                  showWalletActionSheet(
                                                      mcontext);
                                                  return;
                                                }
                                              } else if (type ==
                                                  "instant_buy") {
                                                if (int.tryParse(formQty1) !=
                                                        null &&
                                                    (int.tryParse(formQty1) >
                                                        numberOfBids +
                                                            int.tryParse(buy
                                                                .bidQuantity))) {
                                                  Navigator.pop(context);
                                                  showWalletActionSheet(
                                                      mcontext);

                                                  return;
                                                }
                                              } else {
                                                if (int.tryParse(formQty1) !=
                                                        null &&
                                                    int.tryParse(formQty1) >
                                                        numberOfBids) {
                                                  Navigator.pop(context);
                                                  showWalletActionSheet(
                                                      mcontext);
                                                  return;
                                                }
                                              }
                                              // CHECK ?????????????????
                                              if (marketfile
                                                      .latestClosingPrice !=
                                                  null) {
                                                var val = (double.tryParse(
                                                            marketfile
                                                                .latestClosingPrice) /
                                                        100) *
                                                    50;
                                                bool a = double.tryParse(
                                                        formPrice1) <
                                                    val;
                                                bool b = double.tryParse(
                                                        formPrice1) >
                                                    double.tryParse(marketfile
                                                            .latestClosingPrice) +
                                                        val;

                                                if (double.tryParse(marketfile
                                                        .latestClosingPrice) >
                                                    0) if (a || b) {
                                                  playWarningSound();
                                                  var x = await showDialog(
                                                      context: context,
                                                      builder: (BuildContext
                                                          context) {
                                                        return AlertDialog(
                                                          backgroundColor:
                                                              darkTheme[
                                                                  "primaryColor"],
                                                          content: Container(
                                                            height: 200,
                                                            child: Column(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Text(
                                                                  "The price you had entered has a huge difference to market please check out your bid price",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                Flex(
                                                                  direction: Axis
                                                                      .horizontal,
                                                                  children: [
                                                                    Expanded(
                                                                      child:
                                                                          CustomeElivatedButtonWidget(
                                                                        onPress:
                                                                            () async {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                          var dyt = await buyfunc(
                                                                              context,
                                                                              formPrice1,
                                                                              formQty1,
                                                                              biderId);
                                                                        },
                                                                        name:
                                                                            "Place",
                                                                      ),
                                                                    ),
                                                                    Expanded(
                                                                      child:
                                                                          CustomeElivatedButtonWidget(
                                                                        onPress:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop();
                                                                        },
                                                                        name:
                                                                            "Cancel",
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                  return;
                                                }
                                              }
                                              //CHECK END ????????????/
                                              setState(() {
                                                isLoading = true;
                                              });

                                              Navigator.of(context).pop();
                                              var dyt = await buyfunc(
                                                  context,
                                                  formPrice1,
                                                  formQty1,
                                                  biderId);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(darkTheme[
                                                            'secondaryColor']),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors.red),
                                                  ),
                                                  // primary: darkTheme["secondaryColor"],
                                                )),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    type == 'update'
                                                        ? 'Update'
                                                        : "Place",
                                                    //  "Trade Now",
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                                SizedBox(
                                                  width: 1.3,
                                                ),
                                                isLoading
                                                    ? SizedBox(
                                                        height: 10.0,
                                                        width: 10,
                                                        child: CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    Colors
                                                                        .white),
                                                            strokeWidth: 2.0))
                                                    : SizedBox()
                                              ],
                                            )),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      });
  return true;
}

Future<bool> dialog(var type, assetsQty, user, marketfile, context, _formKey,
    post, sell, postId,
    {numberOfBids = 0}) async {
  var mcontext = context;
  var formPrice = "", formQty = "";
  formPrice = "";
  formQty = "";
  print("here5");
  if (numberOfBids < 0) {
    showToast("please wait checking your bids");
    return false;
  }
  if (numberOfBids < 1 && type != "update") {
    showToast("please purchase bids you have 0 bids in wallet");
    showWalletActionSheet(mcontext);
    return false;
  }
  if (type == "sell_kill" && int.tryParse(marketfile.highestPrice) <= 0) {
    playStopSound();
    return false;
  }
  print("here6");
  // if (int.tryParse(assetsQty) == null) {
  //   playStopSound();
  //   showToast("you don't have enough quantity in assets");
  //   return false;
  // }
  // if (int.tryParse(assetsQty) != null) {
  //   if (int.tryParse(assetsQty) <= 0) {
  //     playStopSound();
  //     showToast("you don't have enough quantity in assets");
  //     return false;
  //   }
  // }
  //print(user.id+'--'+marketfile.ownerId);
  // if (type == 'sell' && user.id == marketfile.ownerId) {
  //   playStopSound();
  //   return false;
  // }
  if (type == 'sell') {
    formPrice = marketfile.highestPrice;
  }
  print("here");
  if (type == 'sell' && int.tryParse(formPrice) == 0) {
    playStopSound();
    return false;
  }
  print("here2");
  if (marketfile.bidderId == user.id && type == 'sell') {
    playStopSound();
    showToast("There is no file in the market to Sell");
    return false;
  }
  print("her3");
  if (type == "update") {
    formQty = sell.bidQuantity;
    formPrice = sell.bidPrice;
  }
  if (type == "instant_sell") {
    formQty = marketfile.highestQuantity;
    formPrice = marketfile.highestPrice;
  }
  //print(marketfile.highestQuantity);
  isLoading = false;
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            insetPadding: EdgeInsets.all(10),
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(builder: (context, setState) {
              return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //  height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkTheme["popupBackground"],
                    ),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Form(
                      key: _formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: TouchableOpacity(
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
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                "assets/images/bid.png",
                                width: 100,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                              child: Flex(
                                direction: Axis.horizontal,
                                children: [
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: darkTheme['bgCellColor'],
                                      ),
                                      margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 8),
                                            child: Text(
                                              'Rs',
                                              style: TextStyle(
                                                color: darkTheme[
                                                    'primaryTextColor'],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Text(
                                              marketfile.price,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: darkTheme[
                                                      'primaryTextColor'],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 0),
                                            child: Text(
                                              'Lowest Offer',
                                              style: TextStyle(
                                                  color: darkTheme[
                                                      'secondaryColor'],
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: darkTheme['bgCellColor'],
                                      ),
                                      margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 8),
                                            child: Text(
                                              'Rs',
                                              style: TextStyle(
                                                color: darkTheme[
                                                    'primaryTextColor'],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Text(
                                              marketfile.highestPrice,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: darkTheme[
                                                      'primaryTextColor'],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 0),
                                            child: Text(
                                              'Highest Bid',
                                              style: TextStyle(
                                                  color: darkTheme[
                                                      'secondaryColor'],
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                        color: darkTheme['bgCellColor'],
                                      ),
                                      margin: EdgeInsets.fromLTRB(0, 0, 6, 0),
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 8),
                                            child: Text(
                                              'No',
                                              style: TextStyle(
                                                color: darkTheme[
                                                    'primaryTextColor'],
                                                fontSize: 12,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 0, 0, 0),
                                            child: Text(
                                              type == 'sell'
                                                  ? marketfile.highestQuantity
                                                  : marketfile.quantity,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  color: darkTheme[
                                                      'primaryTextColor'],
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(
                                                0, 8, 0, 0),
                                            child: Text(
                                              'Total File',
                                              style: TextStyle(
                                                  color: darkTheme[
                                                      'secondaryColor'],
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.w700),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                              child: IgnorePointer(
                                ignoring: type == "instant_sell",
                                child: CircularInputField(
                                  hintText: "Bid Price Per File",
                                  readOnly: type == "sell" ? true : false,
                                  value: type == "sell"
                                      ? marketfile.highestPrice
                                      : type == "update"
                                          ? sell.bidPrice
                                          : type == "instant_sell"
                                              ? marketfile.highestPrice
                                              : "",
                                  type: TextInputType.numberWithOptions(),
                                  onChanged: (val) {
                                    // setState(() {
                                    // return;
                                    if (type == "instant_sell") {
                                      return;
                                    }
                                    formPrice = val;
                                    // });
                                  },
                                ),
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
                              child: IgnorePointer(
                                ignoring: type == "instant_sell",
                                child: CircularInputField(
                                  hintText: "Number of Files",
                                  value: type == "update"
                                      ? sell.bidQuantity
                                      : type == "instant_sell"
                                          ? marketfile.highestQuantity
                                          : "",
                                  type: TextInputType.number,
                                  TextColor:
                                      formQty.length > 0 && type == "sell"
                                          ? int.tryParse(formQty) != null
                                              ? int.tryParse(formQty) >
                                                      int.tryParse(marketfile
                                                          .highestQuantity)
                                                  ? Colors.red
                                                  : darkTheme[
                                                      'primaryBackgroundColor']
                                              : Colors.red
                                          : darkTheme['primaryBackgroundColor'],
                                  //value: type == "Add"?"":asset.bidQuantity,

                                  onChanged: (val) {
                                    // if (type == "instant_sell") {
                                    //   return;
                                    // }
                                    // return;
                                    // if(!isNumeric(val)){
                                    //   playStopSound();
                                    //   showToast("cannot enter this val");
                                    //   return;
                                    // }
                                    formQty = val;
                                    setState(() {
                                      formQty = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            if (type == "instant_sell")
                              int.tryParse(formQty) != null &&
                                      int.tryParse(formQty) >
                                          numberOfBids +
                                              int.tryParse(sell.bidQuantity)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 0),
                                      child: Text(
                                        "Not have enough bids for instent sell you current bids are " +
                                            numberOfBids.toString(),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : SizedBox(),
                            if (type == "update")
                              int.tryParse(formQty) != null &&
                                      int.tryParse(formQty) >
                                          numberOfBids +
                                              int.tryParse(sell.bidQuantity)
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 0),
                                      child: Text(
                                        "Not have enough bids you current bids are " +
                                            (convertToNumber(sell.bidQuantity) +
                                                    convertToNumber(
                                                        numberOfBids))
                                                .toString(),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : SizedBox(),
                            if (type != "update" && type != "instant_sell")
                              int.tryParse(formQty) != null &&
                                      int.tryParse(formQty) > numberOfBids
                                  ? Padding(
                                      padding: const EdgeInsets.fromLTRB(
                                          20, 10, 20, 0),
                                      child: Text(
                                        "Not have enough bids you current bids are " +
                                            numberOfBids.toString(),
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    )
                                  : SizedBox(),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        child: ElevatedButton(
                                            onPressed: () async {
                                              if (type == "sell") {
                                                if (int.tryParse(formQty) >
                                                    int.tryParse(marketfile
                                                        .highestQuantity)) {
                                                  showToast("message");
                                                  playStopSound();
                                                  return;
                                                }
                                              }
                                              print("here");
                                              if (!isNumeric(formPrice)) {
                                                playStopSound();
                                                return;
                                              }
                                              if (!isNumeric(formQty)) {
                                                playStopSound();
                                                return;
                                              }
                                              if (formQty.length > 0 &&
                                                  type == "sell") {}
                                              if (type == "update") {
                                                if (int.tryParse(formQty) ==
                                                        null ||
                                                    int.tryParse(formQty) >
                                                        (numberOfBids +
                                                            int.tryParse(sell
                                                                .bidQuantity))) {
                                                  Navigator.of(context).pop();
                                                  showWalletActionSheet(
                                                      mcontext);
                                                  showToast(
                                                      "dont have enough bids");
                                                  return;
                                                }
                                              } else if (type ==
                                                  "instant_sell") {
                                                if (int.tryParse(formQty) ==
                                                        null ||
                                                    int.tryParse(formQty) >
                                                        numberOfBids +
                                                            int.tryParse(sell
                                                                .bidQuantity)) {
                                                  Navigator.of(context).pop();
                                                  showWalletActionSheet(
                                                      mcontext);
                                                  showToast(
                                                      "dont have enough bids");
                                                  return;
                                                }
                                              } else {
                                                // print(int.tryParse(formQty).toString()+"HERR");
                                                if (int.tryParse(formQty) ==
                                                        null ||
                                                    int.tryParse(formQty) >
                                                        numberOfBids) {
                                                  Navigator.of(context).pop();
                                                  showWalletActionSheet(
                                                      mcontext);
                                                  showToast(
                                                      "dont have enough bids");
                                                  return;
                                                }
                                              }
                                              var val = (double.tryParse(marketfile
                                                          .latestClosingPrice) /
                                                      100) *
                                                  50;
                                              print(val.toString());
                                              bool a =
                                                  double.tryParse(formPrice) <
                                                      val;
                                              bool b = double.tryParse(
                                                      formPrice) >
                                                  double.tryParse(marketfile
                                                          .latestClosingPrice) +
                                                      val;
                                              if (double.tryParse(marketfile
                                                      .latestClosingPrice) >
                                                  0) if (a || b) {
                                                playWarningSound();
                                                var x = await showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor:
                                                            darkTheme[
                                                                "primaryColor"],
                                                        content: Container(
                                                          height: 200,
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Text(
                                                                "The price you had entered has a huge difference to market please check out your bid price",
                                                                style:
                                                                    TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                ),
                                                              ),
                                                              Flex(
                                                                direction: Axis
                                                                    .horizontal,
                                                                children: [
                                                                  Expanded(
                                                                    child:
                                                                        CustomeElivatedButtonWidget(
                                                                      onPress:
                                                                          () async {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                        var pt = await post(
                                                                            context,
                                                                            formPrice,
                                                                            formQty,
                                                                            postId);
                                                                      },
                                                                      name:
                                                                          "Place",
                                                                    ),
                                                                  ),
                                                                  Expanded(
                                                                    child:
                                                                        CustomeElivatedButtonWidget(
                                                                      onPress:
                                                                          () {
                                                                        Navigator.of(context)
                                                                            .pop();
                                                                      },
                                                                      name:
                                                                          "Cancel",
                                                                    ),
                                                                  )
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                                return;
                                              }
                                              // if(double.tryParse(formPrice) > double.tryParse(marketfile.latestClosingPrice) + val)){
                                              //
                                              // }
                                              setState(() {
                                                isLoading = true;
                                              });
                                              Navigator.of(context).pop();
                                              var pt = await post(context,
                                                  formPrice, formQty, postId);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(darkTheme[
                                                            'secondaryColor']),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors.red),
                                                  ),
                                                  // primary: darkTheme["secondaryColor"],
                                                )),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                    type == 'update'
                                                        ? 'Update'
                                                        : "Place"
                                                            "",
                                                    //  "Trade Now",
                                                    style: TextStyle(
                                                        fontSize: 15)),
                                                SizedBox(
                                                  width: 1.3,
                                                ),
                                                isLoading
                                                    ? SizedBox(
                                                        height: 10.0,
                                                        width: 10,
                                                        child: CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    Colors
                                                                        .white),
                                                            strokeWidth: 2.0))
                                                    : SizedBox()
                                              ],
                                            )),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
      });
  return true;
}

var propertyPrice = "";

Future<bool> bidProperty(
    type, maxBidPrice, propertyList, user_id, context, _formKey2, bidProp,
    {numberOfBids = 0}) async {
  if (propertyList.usersId == user_id) {
    playStopSound();
    return false;
  }
  if (type == 'buy_now') {
    propertyPrice = propertyList.maximumOffer;
  }
  bool inputTextColor = false;
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            insetPadding: EdgeInsets.all(10),
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(builder: (context, setState) {
              var formatter = NumberFormat.compact(locale: 'eu');
              return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //  height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkTheme["popupBackground"],
                    ),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Form(
                      key: _formKey2,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
                              child: TouchableOpacity(
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
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                "assets/images/bid.png",
                                width: 100,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 30, 20, 30),
                              child: type != 'buy_now'
                                  ? Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        Expanded(
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5.0),
                                              color: darkTheme['bgCellColor'],
                                            ),
                                            margin:
                                                EdgeInsets.fromLTRB(0, 0, 6, 0),
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.fromLTRB(
                                                          0, 10, 0, 8),
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                        'Maximum Offer',
                                                        style: TextStyle(
                                                          color: darkTheme[
                                                              'primaryTextColor'],
                                                          fontSize: 12,
                                                        ),
                                                      ),
                                                      Text(
                                                        formatter.format(int
                                                            .tryParse(maxBidPrice
                                                                .toString())),
                                                        style: TextStyle(
                                                            fontSize: 12,
                                                            color: darkTheme[
                                                                'primaryTextColor'],
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                            ),
                            Visibility(
                              visible: type == 'buy_now' ? true : false,
                              child: Center(
                                  child: Text(
                                'Do you want to buy? ' +
                                    formatter.format(int.tryParse(
                                        propertyList.maximumOffer)),
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                            ),
                            Visibility(
                              visible: type == 'buy_now' ? false : true,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: Text(
                                  'Your offer',
                                  style: TextStyle(
                                    color: darkTheme['primaryTextColor'],
                                  ),
                                ),
                              ),
                            ),
                            Visibility(
                              visible: type == 'buy_now' ? false : true,
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 3),
                                child: CircularInputField(
                                  hintText: propertyList.minimumOffer,
                                  value: type == 'buy_now'
                                      ? propertyList.maximumOffer
                                      : '',
                                  readOnly: type == 'buy_now' ? true : false,
                                  TextColor: (int.tryParse(propertyPrice) ==
                                                  null
                                              ? 0
                                              : int.tryParse(propertyPrice)) >
                                          (int.tryParse(propertyList
                                                      .minimumOffer) ==
                                                  null
                                              ? 0
                                              : int.tryParse(
                                                  propertyList.minimumOffer))
                                      ? Colors.green
                                      : Colors.red,
                                  type: TextInputType.number,
                                  onChanged: (val) {
                                    setState(() {
                                      propertyPrice = val;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              bidProp(context, propertyList,
                                                  user_id, propertyPrice);
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(darkTheme[
                                                            'secondaryColor']),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors.red),
                                                  ),
                                                  // primary: darkTheme["secondaryColor"],
                                                )),
                                            child: Text(
                                                type == 'make_offer'
                                                    ? 'Make Offer'
                                                    : 'Confirm',
                                                style:
                                                    TextStyle(fontSize: 15))),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
      });
  return true;
}

hammerDialog(context) async {
  bool isReq = false;
  dismissDialog(context, miliseconds, setState) async {
    await Future.delayed(Duration(milliseconds: miliseconds));
    setState(() {
      isReq = true;
    });
    Navigator.pop(context);
  }

  var cont;
  var _width = MediaQuery.of(context).size.width;
  var _height = MediaQuery.of(context).size.height;
  showDialog(
      context: context,
      builder: (BuildContext context) {
        cont = context;
        return AlertDialog(
          insetPadding: EdgeInsets.all(0.0),
          contentPadding: EdgeInsets.all(0.0),
          backgroundColor: Colors.transparent,
          //  backgroundColor: Colors.white,
          //insetPadding: EdgeInsets.all(10.0),
          content: StatefulBuilder(builder: (context, setState) {
            dismissDialog(context, Platform.isAndroid ? 2300 : 2300, setState);
            return Container(
              width: MediaQuery.of(context).size.width * 2,
              child: Stack(
                overflow: Overflow.visible,
                alignment: Alignment.topLeft,
                children: <Widget>[
                  Image.asset(
                    "assets/images/hemmar6.gif",
                    width: getWidth(context),
                    height: getHeight(context),
                    fit: BoxFit.cover,
                  ),
                  isReq
                      ? Padding(
                          padding: const EdgeInsets.fromLTRB(20, 40, 0, 0),
                          child: TouchableOpacity(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 40,
                              )),
                        )
                      : SizedBox(),
                ],
              ),
            );
          }),
        );
      });
  playHammerAudio();
}

packageConfirmation(context, list, buyPackage) async {
  var _width = MediaQuery.of(context).size.width;
  var _height = MediaQuery.of(context).size.height;

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(builder: (context, setState) {
            return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkTheme["popupBackground"],
                    ),
                    //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: TouchableOpacity(
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
                        Text('Confirmation',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 12,
                        ),
                        Text('Total Price for subscribing to',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        Text('selected package is',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'PKR ' +
                              (checkDoubleValue(double.tryParse(list.price)) *
                                      checkDoubleValue(double.tryParse(
                                          list.quantity.toString())))
                                  .toString() +
                              '',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Are you sure you want to continue?',
                          style: TextStyle(
                              color: Color.fromRGBO(76, 187, 23, 1),
                              fontSize: 12),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();

                                          buyPackage(
                                              list.id, list.price, list.bids);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(darkTheme[
                                                        'secondaryColor']),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              // primary: darkTheme["secondaryColor"],
                                            )),
                                        child: Text('Subscribe',
                                            style: TextStyle(fontSize: 15))),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ]);
          }),
        );
      });
}

rechargeDialog(context, id, package) async {
  var _width = MediaQuery.of(context).size.width;
  var _height = MediaQuery.of(context).size.height;

  showDialog(
      context: context,
      builder: (BuildContext buildContext) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(builder: (buildContext, setState) {
            return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 280,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkTheme["popupBackground"],
                    ),
                    //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: TouchableOpacity(
                            onTap: () {
                              Navigator.of(buildContext).pop();
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
                        Text('Not Enough Money In Wallet',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 12,
                        ),
                        Text('You dont have sufficient balance to',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        Text('subscribe for selected package',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        SizedBox(
                          height: 15,
                        ),
                        Text(
                          'Please recharge your balance',
                          style: TextStyle(
                              color: darkTheme['greenText'], fontSize: 12),
                        ),
                        Text(
                          'try again.',
                          style: TextStyle(
                              color: darkTheme['greenText'], fontSize: 12),
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.of(buildContext).pop();
                                          // Navigator.of(context).pushNamed(
                                          //     'payment_screen',
                                          //     arguments: {
                                          //       "id": id,
                                          //       "qty": package.quantity
                                          //     });
                                          showActionSheet(id, context, package);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(darkTheme[
                                                        'secondaryColor']),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              // primary: darkTheme["secondaryColor"],
                                            )),
                                        child: Text('Recharge',
                                            style: TextStyle(fontSize: 15))),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ]);
          }),
        );
      });
}

changeMarlaKanal(context) async {
  var _width = MediaQuery.of(context).size.width;
  var _height = MediaQuery.of(context).size.height;

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(builder: (context, setState) {
            return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 200,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkTheme["popupBackground"],
                    ),
                    //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: TouchableOpacity(
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
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding: EdgeInsets.fromLTRB(40, 2, 40, 2),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).pushNamed(
                                              'filters',
                                              arguments: 'Marla');
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(darkTheme[
                                                        'secondaryColor']),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              // primary: darkTheme["secondaryColor"],
                                            )),
                                        child: Text('Marla',
                                            style: TextStyle(fontSize: 15))),
                                  ),
                                )
                              ],
                            )),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.of(context).pushNamed(
                                              'filters',
                                              arguments: 'Kanal');
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(darkTheme[
                                                        'secondaryColor']),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              // primary: darkTheme["secondaryColor"],
                                            )),
                                        child: Text('Kanal',
                                            style: TextStyle(fontSize: 15))),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ]);
          }),
        );
      });
}

Future comissionConformPopup(context, intransfer, amount, user_id, buyPackage,
    {type = "file_intransfer"}) async {
  var _width = MediaQuery.of(context).size.width;
  var _height = MediaQuery.of(context).size.height;
  var _t = 'file';
  if (type != "file_intransfer") {
    _t = 'property';
  }

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(builder: (context, setState) {
            return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 330,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkTheme["popupBackground"],
                    ),
                    //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: TouchableOpacity(
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
                          Text('Confirmation',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 12,
                          ),
                          // Text('We will try to get that property to you.',
                          //     style:
                          //         TextStyle(color: Colors.white, fontSize: 14)),
                          // Text('We will try to get that ${_t} to you. '+
                          //     'in off changes if we cannot make deal then OPXA with will return your money',
                          //     textAlign: TextAlign.center,
                          //     style:
                          //         TextStyle(color: Colors.white, fontSize: 14)),
                          Text(
                              'When you purchase the service dedicated broker will start doing his best for you. but if he fails your money will be returned.',
                              textAlign: TextAlign.center,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'PKR ' + amount,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Are you sure you want to continue?',
                            style: TextStyle(
                                color: Color.fromRGBO(76, 187, 23, 1),
                                fontSize: 12),
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            buyPackage(intransfer.id, amount,
                                                user_id, intransfer);
                                            // Navigator.pop(context);
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(darkTheme[
                                                          'secondaryColor']),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color: Colors.red),
                                                ),
                                                // primary: darkTheme["secondaryColor"],
                                              )),
                                          child: Text('Subscribe',
                                              style: TextStyle(fontSize: 15))),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ]);
          }),
        );
      });
}

Future<bool> rechargeCommissionDialog(context, id,
    {user_id = null,
    remainingAmount = "0",
    total = "0",
    available = "0",
    type = "file_intransfer"}) async {
  var _width = MediaQuery.of(context).size.width;
  var _height = MediaQuery.of(context).size.height;

  var a = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(builder: (context, setState) {
            return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: 300,
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkTheme["popupBackground"],
                    ),
                    //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: TouchableOpacity(
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
                          Text('Failure',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 12,
                          ),
                          Text('You dont have sufficient balance to',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          Text('subscribe for selected package',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 14)),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Please recharge your balance',
                            style: TextStyle(
                                color: darkTheme['greenText'], fontSize: 12),
                          ),
                          Text(
                            'try again.',
                            style: TextStyle(
                                color: darkTheme['greenText'], fontSize: 12),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Total',
                                style: TextStyle(
                                    color: darkTheme['greenText'],
                                    fontSize: 12),
                              ),
                              Text(
                                total,
                                style: TextStyle(
                                    color: darkTheme['greenText'],
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'available',
                                style: TextStyle(
                                    color: darkTheme['greenText'],
                                    fontSize: 12),
                              ),
                              Text(
                                available,
                                style: TextStyle(
                                    color: darkTheme['greenText'],
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Needed',
                                style: TextStyle(
                                    color: darkTheme['greenText'],
                                    fontSize: 12),
                              ),
                              Text(
                                remainingAmount,
                                style: TextStyle(
                                    color: darkTheme['greenText'],
                                    fontSize: 12),
                              ),
                            ],
                          ),
                          Padding(
                              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Container(
                                      padding:
                                          EdgeInsets.fromLTRB(40, 10, 40, 10),
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            if (remainingAmount == "0") {
                                              return;
                                            }
                                            var a = await Navigator.of(context)
                                                .pushNamed('commission_payment',
                                                    arguments: {
                                                  "id": id,
                                                  "available": available,
                                                  "total": total,
                                                  "amount": remainingAmount,
                                                  "user_id": user_id,
                                                  "type": type
                                                });
                                            Navigator.of(context).pop();
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(darkTheme[
                                                          'secondaryColor']),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color: Colors.red),
                                                ),
                                                // primary: darkTheme["secondaryColor"],
                                              )),
                                          child: Text('Recharge',
                                              style: TextStyle(fontSize: 15))),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ),
                ]);
          }),
        );
      });
  return a;
}

ratingPopUp(context) async {
  var colorofemoji = Colors.grey;
  var _width = MediaQuery.of(context).size.width;
  var _height = MediaQuery.of(context).size.height;
  Color colorgrey = Colors.grey;
  Color coloryellow = Colors.yellow;
  String value = '';
  String message = '';

  showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) => AlertDialog(
            insetPadding: EdgeInsets.all(10),
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(builder: (context, setState) {
              return Stack(
                  overflow: Overflow.visible,
                  alignment: Alignment.center,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 400,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: darkTheme["popupBackground"],
                      ),
                      //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                margin: EdgeInsets.only(left: 10),
                                child: Text(
                                  "Share Your FeedBack",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30),
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
                            ],
                          ),
                          Container(
                              width: MediaQuery.of(context).size.width,
                              margin: const EdgeInsets.fromLTRB(6, 4, 6, 4),
                              child: Flex(
                                direction: Axis.horizontal,
                                //crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              value = 'sad';
                                            });
                                          },
                                          child: Image(
                                              height: 40,
                                              width: 40,
                                              // color: colorofemoji,
                                              color: value == 'sad'
                                                  ? coloryellow
                                                  : colorgrey,
                                              image: AssetImage(
                                                  'assets/images/emojis/angry.png')),
                                        ),
                                        Text(
                                          "Sad",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              value = 'average';
                                            });
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            height: 40,
                                            width: 40,
                                            child: Image(
                                                height: 40,
                                                width: 40,
                                                color: value == 'average'
                                                    ? coloryellow
                                                    : colorgrey,
                                                image: AssetImage(
                                                    'assets/images/emojis/crying.png')),
                                          ),
                                        ),
                                        Text(
                                          "Average",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              value = 'good';
                                            });
                                          },
                                          child: Image(
                                              height: 40,
                                              width: 40,
                                              // color: colorofemoji,
                                              color: value == 'good'
                                                  ? coloryellow
                                                  : colorgrey,
                                              image: AssetImage(
                                                  'assets/images/emojis/Happy.png')),
                                        ),
                                        Text(
                                          "Good",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              value = 'happy';
                                            });
                                          },
                                          child: Image(
                                              height: 40,
                                              width: 40,
                                              // color: colorofemoji,
                                              color: value == 'happy'
                                                  ? coloryellow
                                                  : colorgrey,
                                              image: AssetImage(
                                                  'assets/images/emojis/smile.png')),
                                        ),
                                        Text(
                                          "Happy",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              value = 'great';
                                            });
                                          },
                                          child: Image(
                                              height: 40,
                                              width: 40,
                                              //color: colorofemoji,
                                              color: value == 'great'
                                                  ? coloryellow
                                                  : colorgrey,
                                              image: AssetImage(
                                                  'assets/images/emojis/cool.png')),
                                        ),
                                        Text(
                                          "Great",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              )),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:
                                  darkTheme["secondaryColor"].withOpacity(.5),
                            ),
                            margin: EdgeInsets.only(left: 10, right: 10),
                            padding: EdgeInsets.all(10.0),
                            height: 200,
                            child: new ConstrainedBox(
                              constraints: BoxConstraints(
                                maxHeight: 200.0,
                              ),
                              child: new Scrollbar(
                                child: new SingleChildScrollView(
                                  scrollDirection: Axis.vertical,
                                  reverse: true,
                                  child: SizedBox(
                                    height: 190.0,
                                    child: new TextField(
                                      onChanged: (val) {
                                        message = val;
                                      },
                                      maxLines: 100,
                                      decoration: new InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'What do you like the most?',
                                        hintStyle:
                                            TextStyle(color: Colors.white),
                                      ),
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
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
                                      child: ElevatedButton(
                                          onPressed: () async {
                                            // Navigator.pop(context);
                                            /* Navigator.of(context).pushNamed(
                                                'filters',
                                                arguments: 'Kanal');*/
                                            if (value.length < 1) {
                                              showToast(
                                                  "please select what you experienced");
                                            }
                                            User user = await getUser();
                                            if (user != null) {
                                              var request = {
                                                "user_id": user.id,
                                                "message": message,
                                                "feed_back": value,
                                              };
                                              // var progressDialog = await new ProgressDialog(context);
                                              // progressDialog.update(message: "Please wait");
                                              // progressDialog.show();
                                              showToast("posting..");
                                              var res =
                                                  await postFeedBackService(
                                                      request);
                                              if (res != null) {
                                                // progressDialog.hide();
                                                Navigator.of(context).pop();
                                              }
                                            }
                                          },
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty
                                                      .all<Color>(darkTheme[
                                                          'secondaryColor']),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          18.0),
                                                  side: BorderSide(
                                                      color: Colors.red),
                                                ),
                                                // primary: darkTheme["secondaryColor"],
                                              )),
                                          child: Text('Send',
                                              style: TextStyle(fontSize: 15))),
                                    ),
                                  )
                                ],
                              )),
                        ],
                      ),
                    ),
                  ]);
            }),
          ),
        );
      });
}

var bidPrice = "";

Future<bool> editBid(
    Price, id, propertyId, user_id, context, _formKey3, bidfunc) async {
  bool inputTextColor = false;
  await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            insetPadding: EdgeInsets.all(10),
            backgroundColor: Colors.transparent,
            content: StatefulBuilder(builder: (context, setState) {
              var formatter = NumberFormat.compact(locale: 'eu');
              return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    //  height: 400,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkTheme["popupBackground"],
                    ),
                    padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                    child: Form(
                      key: _formKey3,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Align(
                              alignment: Alignment.topRight,
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
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Image.asset(
                                "assets/images/bid.png",
                                width: 100,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                              child: Text(
                                'Your offer',
                                style: TextStyle(
                                  color: darkTheme['primaryTextColor'],
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 3),
                              child: CircularInputField(
                                hintText: '',
                                value: Price,
                                readOnly: false,
                                type: TextInputType.number,
                                onChanged: (val) {
                                  setState(() {
                                    bidPrice = val;
                                  });
                                },
                              ),
                            ),
                            Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 10, 20, 0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding:
                                            EdgeInsets.fromLTRB(40, 10, 40, 10),
                                        child: ElevatedButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                              bidfunc(context, bidPrice, id,
                                                  propertyId, user_id);
                                            },
                                            style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty
                                                        .all<Color>(darkTheme[
                                                            'secondaryColor']),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            18.0),
                                                    side: BorderSide(
                                                        color: Colors.red),
                                                  ),
                                                  // primary: darkTheme["secondaryColor"],
                                                )),
                                            child: Text('Post',
                                                style:
                                                    TextStyle(fontSize: 15))),
                                      ),
                                    )
                                  ],
                                )),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }));
      });
  return true;
}

showAlertDialog(title, message, context, {button1 = null, button2: null}) {
  CupertinoAlertDialog(
    title: title,
    content: message,
    actions: [
      CupertinoDialogAction(
        onPressed: () {},
        child: Text("Ok"),
      )
    ],
  );
}

Future<bool> propertyConformationDialog(context) async {
  var _width = MediaQuery.of(context).size.width;
  var _height = MediaQuery.of(context).size.height;

  var a = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          insetPadding: EdgeInsets.all(10),
          backgroundColor: Colors.transparent,
          content: StatefulBuilder(builder: (context, setState) {
            return Stack(
                overflow: Overflow.visible,
                alignment: Alignment.center,
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: darkTheme["popupBackground"],
                    ),
                    //padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                    child: Column(
                      children: [
                        // Align(
                        //   alignment: Alignment.topRight,
                        //   child: TouchableOpacity(
                        //     onTap: () {
                        //       Navigator.of(context).pop();
                        //     },
                        //     child: CircleAvatar(
                        //       child: Icon(
                        //         Icons.close,
                        //         color: Colors.white,
                        //       ),
                        //       backgroundColor: Colors.transparent,
                        //     ),
                        //   ),
                        // ),
                        Text('Confirmation',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 12,
                        ),
                        Text('Property has sold cannot perform any action',
                            style:
                                TextStyle(color: Colors.white, fontSize: 14)),
                        // Text('selected package is',
                        //     style:
                        //     TextStyle(color: Colors.white, fontSize: 14)),
                        SizedBox(
                          height: 15,
                        ),
                        // Text(
                        //   'PKR ' + amount,
                        //   style: TextStyle(
                        //       color: Colors.white, fontWeight: FontWeight.bold),
                        // ),
                        // SizedBox(
                        //   height: 15,
                        // ),
                        // Text(
                        //   'Are you sure you want to continue?',
                        //   style: TextStyle(color: Colors.red, fontSize: 12),
                        // ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    padding:
                                        EdgeInsets.fromLTRB(40, 10, 40, 10),
                                    child: ElevatedButton(
                                        onPressed: () async {
                                          // buyPackage(intransfer.id, amount,
                                          //     user_id, intransfer);
                                          Navigator.pop(context);
                                          Navigator.of(context).pop();
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStateProperty
                                                    .all<Color>(darkTheme[
                                                        'secondaryColor']),
                                            shape: MaterialStateProperty.all<
                                                RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(18.0),
                                                side: BorderSide(
                                                    color: Colors.red),
                                              ),
                                              // primary: darkTheme["secondaryColor"],
                                            )),
                                        child: Text('Go Back',
                                            style: TextStyle(fontSize: 15))),
                                  ),
                                )
                              ],
                            )),
                      ],
                    ),
                  ),
                ]);
          }),
        );
      });
  return false;
}

showActionSheet(id, context, package) {
  showAdaptiveActionSheet(
    context: context,
    title: const Text('Note: We will respond in 24 hours in direct deposit'),
    actions: <BottomSheetAction>[
      BottomSheetAction(
          title: Text(
            'Bank Deposit',
            style: TextStyle(
              // color: Colors.blue,
            ),
          ),
          onPressed: () async {
            Navigator.pop(context);
            Navigator.pushNamed(context, "direct_deposit", arguments: package);
          }),
      BottomSheetAction(
          title: const Text('Online Deposit'),
          onPressed: () {
            // /
            Navigator.of(context).pop();
            Navigator.of(context).pushNamed('payment_screen',
                arguments: {"id": id, "qty": package.quantity});

            // var contex = context;
            // packageConfirmation(context, widget.package,
            //         (package_id, price, bids) {
            //       buyPackage(widget.package.id, widget.package.price,
            //           widget.package.bids);
            //     });

            // deleteBids(bidData.id,bidData.propertyId,bidData.usersId,bidfunction);
          }),
    ],
    cancelAction: CancelAction(
      title: const Text('Cancel'),
    ), // onPressed parameter is optional by default will dismiss the ActionSheet
  );
}

showWalletActionSheet(cont, {data = null}) {
  // Navigator.of(cont).pop();
  showAdaptiveActionSheet(
    context: cont,
    title: const Text(
      "Note: don't have enough bids",
      style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
    ),
    actions: <BottomSheetAction>[
      BottomSheetAction(
          title: const Text('Go To Wallet'),
          onPressed: () async {
            Navigator.of(cont).pop();
            var a = await Navigator.of(cont).pushNamed('wallet');
            if (data != null) {
              if (data["func"] != null) {
                var func = data['func'];
                func();
              }
            }
            Navigator.of(cont);
          }),
    ],
    cancelAction: CancelAction(
      title: const Text('Cancel'),
    ),
  );
}

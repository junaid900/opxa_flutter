import 'dart:async';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/CustomeElivatedButton.dart';
import 'package:qkp/Network/URLS.dart';
import 'package:qkp/Network/http_requests.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/Package.dart';
import 'Model/User.dart';
import 'Network/constant.dart';
import 'Network/network.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';

class Packages extends StatefulWidget {
  @override
  _PackagesState createState() => _PackagesState();
}

class _PackagesState extends State<Packages> with RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  User user;
  List<Package> packageList = [];
  bool isLoading = false;

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
    });
    packages();
  }

  packages() async {
    setState(() {
      isLoading = true;
    });
    var res = await getpackages();
    setState(() {
      isLoading = false;
    });
    // print("res"+res.toString());
    if (res["ResponseCode"] == 1) {
      var packagesMapList = res["Packages"];
      for (int i = 0; i < packagesMapList.length; i++) {
        Package packages = new Package();
        packages.fromJson(packagesMapList[i]);
        setState(() {
          packageList.add(packages);
        });
      }
      setState(() {
        print(packageList.toString());
        packageList = packageList;
      });
      // showToast("Bid sent Successfully");
      //clearForm();
    } else {
      setState(() {
        // assetsQty = '';
      });
    }
  }
  // inAppPurchaseFun() async {
  //   final bool available = await InAppPurchaseConnection.instance.isAvailable();
  //   if (!available) {
  //     // The store cannot be reached or accessed. Update the UI accordingly.
  //     // Set literals require Dart 2.2. Alternatively, use `Set<String> _kIds = <String>['product1', 'product2'].toSet()`.
  //     const Set<String> _kIds = {'product1', 'product2'};
  //     final ProductDetailsResponse response = await InAppPurchaseConnection.instance.
  //     queryProductDetails(_kIds);
  //     if (response.notFoundIDs.isNotEmpty) {
  //       // Handle the error.
  //     }
  //
  //     List<ProductDetails> products = response.productDetails;
  //     final QueryPurchaseDetailsResponse response2 = await InAppPurchaseConnection.instance.queryPastPurchases();
  //     if (response.error != null) {
  //       // Handle the error.
  //     }
  //     for (PurchaseDetails purchase in response2.pastPurchases) {
  //       _verifyPurchase(purchase);  // Verify the purchase following the best practices for each storefront.
  //       _deliverPurchase(purchase); // Deliver the purchase to the user in your app.
  //       if (Platform.isIOS) {
  //         // Mark that you've delivered the purchase. Only the App Store requires
  //         // this final confirmation.
  //         InAppPurchaseConnection.instance.completePurchase(purchase);
  //       }
  //     }
  //   }
  // }
  // Stream purchaseUpdated =
  //     InAppPurchaseConnection.instance.purchaseUpdatedStream;
  // _subscription = purchaseUpdated.listen((purchaseDetailsList) {
  // _listenToPurchaseUpdated(purchaseDetailsList);
  // }, onDone: () {
  // _subscription.cancel();
  // }, onError: (error) {
  // // handle error here.
  // });
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageData();

  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    return Scaffold(
        appBar: AppBar(title: Text("Packages")),
        body: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
                width: _width,
                height: _height,
                color: isDarkTheme
                    ? darkTheme["primaryBackgroundColor"]
                    : lightTheme["primaryBackgroundColor"],
                padding: EdgeInsets.all(10),
                child: Stack(
                  children: [
                    SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Text(
                          //   "Note:\t\t  Bid Strandard Policy\n\t\t\t\t\t\t\t\t\t\t\t\t\t10,000 bid price\n\t\t\t\t\t\t\t\t\t\t\t\t\t8000 \t return amount on successful trade\n\t\t\t\t\t\t\t\t\t\t\t\t\t2000 \t bid cost",
                          //   textAlign: TextAlign.start,
                          //   style: TextStyle(
                          //       color: Colors.white,
                          //       fontWeight: FontWeight.bold),
                          // ),
                          Container(
                            child: Column(
                              children:
                                  List.generate(packageList.length, (index) {
                                //print(marketFilesList[index]);
                                return packageList.length > 0 &&
                                        packageList[index] != null
                                    ? PackageItem(
                                        package: packageList[index],
                                        userId: user.id)
                                    : Container();
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (isLoading)
                      AppLoadingScreen(
                        backgroundOpactity: .6,
                      ),
                  ],
                )),
          ],
        ));
  }
}

class PackageItem extends StatefulWidget {
  Package package;
  String userId;

  PackageItem({this.package, this.userId});

  @override
  _PackageItemState createState() => _PackageItemState();
}

class _PackageItemState extends State<PackageItem> {
  bool isRequesting = false;

  buyPackage(String id, String price, String bids) async {
    if (isRequesting) {
      showToast("so many requests please wait");
      return;
    }
    isRequesting = true;
    var request = <String, dynamic>{
      "users_id": widget.userId,
      "packages_id": id,
      "price": price,
      "action_counter": bids,
      "qty": widget.package.quantity,
    };
    ProgressDialog progressDialog =
        ProgressDialog(context, isDismissible: false);
    progressDialog.update(message: "Checking Your Wallet");
    progressDialog.show();
    var res = await postRequest(BUY_PACKAGES, request);
    progressDialog.hide();
    isRequesting = false;
    // Navigator.of(context).pop();
    if (res == null) {
      print('failure');
      rechargeDialog(context, id, widget.package);
    } else {
      if (res["ResponseCode"] == 1) {
        showToast("Package purchased successfully!");
      } else {
        print('failure');
      }
    }
  }

  updateQuantity(type) {
    switch (type) {
      case "increament":
        widget.package.quantity += 1;
        break;
      case "decrement":
        if (widget.package.quantity > 1) {
          widget.package.quantity -= 1;
        }
        break;
      default:
        showToast('invalid method');
        break;
    }
    setState(() {
      widget.package = widget.package;
    });
  }

  bool isQtyOpen = false;
  bool showQtyLayout = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border: Border(
        top: BorderSide(
          color: darkTheme['secondaryColor'],
          width: 3.0,
        ),
      )),
      margin: const EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 2.0),
      child: Material(
        color: darkTheme["cardBackground"],
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        widget.package.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'PKR ${convertToNumber(widget.package.price) * convertToNumber(widget.package.quantity)}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You will Get ',
                        style: TextStyle(
                            color: darkTheme['secondaryColor'],
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${widget.package.quantity}',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w700),
                      ),
                      Text(
                        ' bids',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w700),
                      )
                    ],
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              width: getWidth(context),
              color: darkTheme["cardBackground"],
              padding: EdgeInsets.fromLTRB(0, 5, 0, 2),
              margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
              child: Column(
                // direction: Axis.horizontal,
                children: [
                  // ElevatedButton(
                  //
                  //     style: ButtonStyle(
                  //       elevation: MaterialStateProperty.all(0),
                  //       backgroundColor: MaterialStateProperty.all<Color>(
                  //           Colors.transparent),
                  //     ),
                  //     child: Text("Subscribe",
                  //         style: TextStyle(
                  //             fontSize: 14,
                  //             color: darkTheme["secondaryColor"],
                  //             decoration: TextDecoration.underline,
                  //             decorationThickness: 2))),
                  Container(
                    width: getWidth(context)*.40,
                    // padding:EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: darkTheme["primaryBackgroundColor"],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    height: 40,
                    margin: EdgeInsets.fromLTRB(0, 2, 10, 2),
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            child: Icon(
                              Icons.remove,
                              size: 20,
                            ),
                            onPressed: () {
                              updateQuantity("decrement");
                            },
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        bottomLeft: Radius.circular(8)),
                                    // side: BorderSide.lerp(BorderSide(),),
                                  ),
                                )),
                          ),
                        ),
                        Expanded(
                            child: Container(
                                padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                height: 30,
                                decoration: BoxDecoration(
                                    color: darkTheme["cardBackground"],
                                    borderRadius: BorderRadius.circular(5)),
                                child: Center(
                                    child: Text(
                                      widget.package.quantity.toString(),
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600),
                                    )))),
                        Expanded(
                          child: ElevatedButton(
                            child: Icon(
                              Icons.add,
                              size: 24,
                            ),
                            onPressed: () {
                              updateQuantity("increament");
                            },
                            style: ButtonStyle(
                                elevation: MaterialStateProperty.all(0),
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent)),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 10,),
                  CustomeElivatedButtonWidget(
                    name: "Subscribe",
                    onPress: () async {
                      packageConfirmation(context, widget.package,
                              (package_id, price, bids) {
                            buyPackage(widget.package.id, widget.package.price,
                                widget.package.bids);
                          });
                      // showActionSheet(widget.package);
                    },
                  ),

                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
  // showPayWithActionSheet() {
  //   return showAdaptiveActionSheet(
  //     context: context,
  //     title: const Text('Note: We will respond in 24 hours in direct deposit'),
  //     actions: <BottomSheetAction>[
  //       BottomSheetAction(
  //           title: Text(
  //             'Via In-App-Purchase',
  //             style: TextStyle(
  //               color: darkTheme["redText"],
  //             ),
  //           ),
  //           onPressed: () async {
  //             Navigator.of(context).pop();
  //             // Navigator.pushNamed(context, "direct_deposit",
  //             //     arguments: widget.package);
  //
  //           }),
  //       BottomSheetAction(
  //           title: const Text('Via JazzCash'),
  //           onPressed: () {
  //             // var contex = context;
  //             Navigator.of(context).pop();
  //             packageConfirmation(context, widget.package,
  //                     (package_id, price, bids) {
  //                   buyPackage(widget.package.id, widget.package.price,
  //                       widget.package.bids);
  //                 });
  //             // packageConfirmation(context, widget.package,
  //             //         (package_id, price, bids) {
  //             //       buyPackage(widget.package.id, widget.package.price,
  //             //           widget.package.bids);
  //             //     });
  //
  //             // deleteBids(bidData.id,bidData.propertyId,bidData.usersId,bidfunction);
  //           }),
  //     ],
  //     cancelAction: CancelAction(
  //       title: const Text('Cancel'),
  //     ), // onPressed parameter is optional by default will dismiss the ActionSheet
  //   );
  // }

  showActionSheet(Package package) {
    return showAdaptiveActionSheet(
      context: context,
      title: const Text('Note: We will respond in 24 hours in direct deposit'),
      actions: <BottomSheetAction>[
        // BottomSheetAction(
        //     title: Text(
        //       'In-App-Purchase',
        //       style: TextStyle(
        //         color: darkTheme["redText"],
        //       ),
        //     ),
        //     onPressed: () async {
        //       Navigator.of(context).pop();
        //       Navigator.pushNamed(context, "direct_deposit",
        //           arguments: widget.package);
        //     }),
        BottomSheetAction(
            title: const Text('Online Deposit'),
            onPressed: () {
              // var contex = context;
              Navigator.of(context).pop();
              packageConfirmation(context, widget.package,
                      (package_id, price, bids) {
                    buyPackage(widget.package.id, widget.package.price,
                        widget.package.bids);
                  });

              // deleteBids(bidData.id,bidData.propertyId,bidData.usersId,bidfunction);
            }),
        BottomSheetAction(
            title: Text(
              'Direct Detail',
              style: TextStyle(
                // color: Colo,
              ),
            ),
            onPressed: () async {
              Navigator.of(context).pop();
              Navigator.pushNamed(context, "direct_deposit",
                  arguments: widget.package);
            }),

      ],
      cancelAction: CancelAction(
        title: const Text('Cancel'),
      ), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
  }
}

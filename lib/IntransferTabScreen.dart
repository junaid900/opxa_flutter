import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/CustomeElivatedButton.dart';
import 'package:qkp/FavouritesScreen.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/MaterialButton.dart';
import 'package:qkp/Model/ChatUser.dart';
import 'package:qkp/Model/CommissionRequest.dart';
import 'package:qkp/Model/FileCommissionSociety.dart';
import 'package:qkp/Model/IntranferFile.dart';
import 'package:qkp/Model/IntransferTimer.dart';
import 'package:qkp/Model/PropertyCommissionSociety.dart';
import 'package:qkp/Model/PropertyIntransfer.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';
import 'package:qkp/forgotpassword.dart';
import 'package:url_launcher/url_launcher.dart';

import 'EmptyLayout.dart';

class IntransferTabWidget extends StatefulWidget {
  List<IntransferFile> intransferList;
  final stateChanged;
  List<PropertyIntransfer> propertyIntransferList;
  List<bool> isSelected;

  IntransferTabWidget(
      {this.intransferList,
      this.stateChanged,
      this.isSelected,
      this.propertyIntransferList});

  @override
  _IntransferTabWidgetState createState() => _IntransferTabWidgetState();
}

class _IntransferTabWidgetState extends State<IntransferTabWidget> {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  User user;
  bool isEmpty = false;
  List<IntransferFile> transferList = [];
  Timer timer;
  List<PropertyIntransfer> propertyIntransferList = [];
  List<FileCommissionSociety> fileCommissionsSocieties = [];
  List<PropertyCommissionSociety> propertyCommissionsSocieties = [];

  getDataWithTimer() async {
    var request = {"owner_id": user.id};
    var res = await getTimerinTransferService(request);
    var intransferMapList = res["Files"];
    transferList.clear();
    //print(intransferMapList);
    //print(intransferMapList[0]["hours"]);
    for (int i = 0; i < intransferMapList.length; i++) {
      IntransferFile intransferFile = new IntransferFile();
      intransferFile.fromJson(intransferMapList[i]);
      transferList.add(intransferFile);
    }
    setState(() {
      transferList = transferList;
    });
  }

  getCommissionSocities() async {
    var request = {"owner_id": user.id};
    var res = await commissionFileSocietiesService(request);
    var fileCommissionMap = res["socities"];
    fileCommissionsSocieties.clear();
    for (int i = 0; i < fileCommissionMap.length; i++) {
      fileCommissionsSocieties
          .add(FileCommissionSociety.fromJson(fileCommissionMap[i]));
    }
    setState(() {
      fileCommissionsSocieties = fileCommissionsSocieties;
    });
    var res2 = await commissionPropertySocietiesService(request);
    var propertyCommissionMap = res2["socities"];
    for (int i = 0; i < propertyCommissionMap.length; i++) {
      propertyCommissionsSocieties
          .add(PropertyCommissionSociety.fromJson(propertyCommissionMap[i]));
    }
    setState(() {
      propertyCommissionsSocieties = propertyCommissionsSocieties;
    });
  }

  pageData() async {
    setState(() {
      transferList = widget.intransferList;
      propertyIntransferList = widget.propertyIntransferList;
    });
    getCommissionSocities();
    getPropertyTimer();

    var u = await getUser();
    // print("user->" + u.toJson().toString());
    setState(() {
      user = u;
    });
    if (widget.intransferList.length > 0) {
      setState(() {
        isEmpty = false;
      });
    } else {
      setState(() {
        isEmpty = true;
      });
    }
  }

  getPropertyTimer() async {
    var intRequest = {"owner_id": user.id};
    var intRes = await getPropertyIntransferService(intRequest);

    // var intData = intRes["Files"];
    var intMapList = intRes["Files"];
    propertyIntransferList.clear();
    for (int i = 0; i < intMapList.length; i++) {
      propertyIntransferList.add(PropertyIntransfer.fromJson(intMapList[i]));
    }
    setState(() {
      propertyIntransferList = propertyIntransferList;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer.cancel();
    super.dispose();
  }

  @override
  void initState() {
    user = new User(id: "");
    // TODO: implement initState
    pageData();
    super.initState();
    timer = new Timer.periodic(new Duration(milliseconds: 10000), (timer) {
      // print(left);
      getDataWithTimer();
      getPropertyTimer();
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        scrollDirection: Axis.vertical,
        children: widget.isSelected[0]
            ? transferList.length > 0
                ? List.generate(
                    transferList.length,
                    (index) => IntransferFileItemWidget(
                          intransferFile: transferList[index],
                          user: user,
                          refreshList: () {
                            getDataWithTimer();
                          },
                          commissionSocieties: fileCommissionsSocieties,
                        ))
                : [
                    Center(
                      child: Column(
                        children: [
                          EmptyLayoutWidget(
                            message: "Nothing in Intransfer",
                          ),
                          // SizedBox(
                          //   height: 30,
                          //   widt∂h: 30,
                          //   child: CircularProgressIndicator(),
                          // ),
                        ],
                      ),
                    )
                  ]
            : propertyIntransferList.length > 0
                ? List.generate(
                    propertyIntransferList.length,
                    (index) => PropertyIntransferItemWidget(
                          intransferFile: propertyIntransferList[index],
                          user: user,
                          refreshList: () {
                            getPropertyTimer();
                          },
                          commissionSocieties: propertyCommissionsSocieties,
                        ))
                : [
                    Center(
                      child: Column(
                        children: [
                          EmptyLayoutWidget(
                            message: "Nothing in Intransfer",
                          ),
                          // SizedBox(
                          //   height: 30,
                          //   width: 30,
                          //   child: CircularProgressIndicator(),
                          // ),
                        ],
                      ),
                    )
                  ]);
  }
}

class PropertyIntransferItemWidget extends StatefulWidget {
  User user;
  PropertyIntransfer intransferFile;
  Function refreshList;
  List<PropertyCommissionSociety> commissionSocieties;

  PropertyIntransferItemWidget(
      {this.user,
      this.intransferFile,
      this.refreshList,
      this.commissionSocieties});

  @override
  _PropertyIntransferItemWidgetState createState() =>
      _PropertyIntransferItemWidgetState();
}

class _PropertyIntransferItemWidgetState
    extends State<PropertyIntransferItemWidget> {
  PropertyCommissionSociety commissionSociety;
  bool isCommissionExist = false;
  bool isUserCommission = false;
  bool isCommissionLoading = false;
  CommissionRequest commissionRequest;

  clearDealData() async {
    var dialog = showDialog(
        context: context,
        builder: (BuildContext cont) {
          return AlertDialog(
            title: Text("Warning!"),
            content: Text(
                "Ensure everything. After clearing the deal OPXA cannot follow up your case"),
            actions: [
              FlatButton(
                  onPressed: () async {
                    Navigator.pop(cont);
                    var request = {
                      "history_id": widget.intransferFile.historyId
                    };
                    ProgressDialog progressDialog = showProgressDialog(
                        ProgressDialog(context, isDismissible: false));
                    var data = await propertyIntransferActionService(request);
                    progressDialog.hide();
                    widget.refreshList();
                  },
                  child: Text("OK")),
              FlatButton(onPressed: () async {
                Navigator.pop(cont);
              }, child: Text("CANCEL")),
            ],
          );
        });
  }

  startChat(userId, otherUserId) async {
    var request = {
      "requestType": "chatRequest",
      "userId": userId,
      "otherUserId": otherUserId,
      "history_id": widget.intransferFile.historyId,
      "type": "Property",
      // "user_type": otherUserId
    };

    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.show();
    var res = await getConversationList(request);
    pr.hide();
    if (res != null) {
      // print(res);
      Chat chat = Chat.fromJson(res["response"]["chat"]);
      Navigator.of(context).pushNamed("chat_detail", arguments: chat);
    } else {
      showToast("Cannot Create Chat Room");
    }
  }

  checkCommissionTicketId(userId, userType) async {
    // var request = {
    //   "user_id": userId,
    //   "user_type": userType,
    //   "type" : "Property",
    //   "history_id": widget.intransferFile.historyId,
    // };
    // setState(() {
    //   isCommissionLoading = true;
    // });
    // // var res = await getCommissionTicketData(request);
    // setState(() {
    //   isCommissionLoading = false;
    // });
    // if(res != null){
    // }else{
    //   // showToast(message)
    // }
  }

  getItemData() {
    if (widget.intransferFile.sellerId == widget.user.id) {
      if (widget.intransferFile.sellerAction == "Commission") {
        setState(() {
          isUserCommission = true;
        });
        checkCommissionTicketId(widget.user.id, "Seller");
      }
    } else {
      if (widget.intransferFile.buyerAction == "Commission") {
        setState(() {
          isUserCommission = true;
        });
        checkCommissionTicketId(widget.user.id, "Buyer");
      }
      List<PropertyCommissionSociety> tempCommission = [];
      tempCommission.addAll(widget.commissionSocieties.where((element) {
        return element.societyId == widget.intransferFile.societyId;
      }));

      if (tempCommission.length > 0) {
        setState(() {
          isCommissionExist = true;
          commissionSociety = tempCommission.first;
        });
      }
    }
  }

  // getItemData() {
  //   List<PropertyCommissionSociety> tempCommission = [];
  //   tempCommission.addAll(widget.commissionSocieties.where((element) {
  //     return element.societyId == widget.intransferFile.societyId;
  //   }));
  //
  //   if (tempCommission.length > 0) {
  //     setState(() {
  //       isCommissionExist = true;
  //       commissionSociety = tempCommission.first;
  //     });
  //   }
  // }
  bool isRequesting = false;

  commessionProperty(userId, amount, PropertyIntransfer intransferFile) async {
    if (isRequesting) {
      showToast("too many requests please wait");
      return;
    }
    showToast("please wait");
    var request = {
      "intransfer_id": intransferFile.historyId,
      "user_id": widget.user.id,
      "amount": amount,
      "tp": "property_intransfer"
      // "user_type": otherUserId
    };
    showToast("please wait");
    // print(request);
    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.show();
    setState(() {
      isRequesting = true;
    });
    var res = await commissionRequestService(request);
    setState(() {
      isRequesting = false;
    });
    pr.hide();
    if (res == null) {
      showToast("unfortunate error");
    }
    if (res["ResponseCode"] == 0) {
      showToast(res["ResponseMessage"]);
      var data = jsonDecode(res["data"]);
      var a = await rechargeCommissionDialog(context, intransferFile.historyId,
          total: data["amount"].toString(),
          remainingAmount: data["remaining_amount"].toString(),
          available: data["wallet_amount"].toString(),
          user_id: userId,
          type: "property_intransfer");
      widget.refreshList();
    }
    if (res["ResponseCode"] == 1) {
      showToast("successfully received payment. refeshing.....");
      widget.refreshList();
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    getItemData();
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: darkTheme["cardBackground"],
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: (widget.intransferFile.propertyName.length + 3) * 12.1 <
                        getWidth(context)
                    ? (widget.intransferFile.propertyName.length + 3) * 14.1
                    : getWidth(context),
                child: Column(
                  children: [
                    Divider(
                      color: Colors.white,
                      thickness: .6,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.home,
                          color: Colors.white,
                          size: 22,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            widget.intransferFile.propertyName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: .6,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          "P-" + widget.intransferFile.historyId,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20),
                        ),
                      )),
                  if (widget.intransferFile.ticketId != null &&
                      widget.intransferFile.ticketId != "null")
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Text(
                            "TKT-" + widget.intransferFile.ticketId,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16),
                          ),
                        )),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/timer.svg",
                            width: 170,
                            color: userItemStatus(
                                        widget.intransferFile.sellerId,
                                        widget.intransferFile.sellerAction,
                                        widget.intransferFile.buyerAction,
                                        widget.user.id) ==
                                    "Completed"
                                ? Colors.green
                                : checkHours(
                                        widget.intransferFile.hours.toString())
                                    ? Colors.blue
                                    : Colors.red,
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              userItemStatus(
                                          widget.intransferFile.sellerId,
                                          widget.intransferFile.sellerAction,
                                          widget.intransferFile.buyerAction,
                                          widget.user.id) ==
                                      'Commission'
                                  ? "Support"
                                  : userItemStatus(
                                              widget.intransferFile.sellerId,
                                              widget
                                                  .intransferFile.sellerAction,
                                              widget.intransferFile.buyerAction,
                                              widget.user.id) ==
                                          'Completed'
                                      ? widget.intransferFile.sellerAction ==
                                                  "Completed" &&
                                              widget.intransferFile
                                                      .buyerAction ==
                                                  "Completed"
                                          ? "Deal Done"
                                          : checkHours(widget
                                                  .intransferFile.hours
                                                  .toString())
                                              ? "Pending"
                                              : "Timeout"
                                      : checkHours(widget.intransferFile.hours
                                              .toString())
                                          ? widget.intransferFile.hours
                                                  .toString() +
                                              " : " +
                                              widget.intransferFile.mints
                                                  .toString()
                                          : "Time Stopped",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.intransferFile.sellerId == widget.user.id
                    ? "Seller " + "Information"
                    : "Buyer " + "Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              if (!isUserCommission &&
                  checkHours(widget.intransferFile.hours.toString()))
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.person,
                              color: Colors.white,
                              size: 20,
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Flexible(
                              child: Text(
                                widget.intransferFile.sellerId == widget.user.id
                                    ? widget.intransferFile.buyerName
                                    : widget.intransferFile.sellerName,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            InkWell(
                              onTap: () async {
                                await launch("tel:+" +
                                    widget.intransferFile.buyerNumber);
                              },
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                                child: Text(
                                  widget.intransferFile.sellerId ==
                                          widget.user.id
                                      ? widget.intransferFile.buyerNumber
                                      : widget.intransferFile.sellerNumber,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              if (isUserCommission)
                Text(
                  "Connect to support to process with TKT number",
                  style: TextStyle(
                      color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                child: Flex(
                  direction: Axis.horizontal,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.monetization_on_sharp,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                            child: Text(
                              "PKR " + widget.intransferFile.price + "",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              widget.intransferFile.cityName,
                              // widget.intransferFile.symbol,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              if (isCommissionExist &&
                  !isUserCommission &&
                  checkHours(widget.intransferFile.hours.toString()))
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: FlatButton(
                          onPressed: () async {
                            var user = widget.user.id;
                            var otherUser;
                            if (widget.intransferFile.sellerId ==
                                widget.user.id) {
                              otherUser = widget.intransferFile.buyerId;
                              if (widget.intransferFile.sellerAction ==
                                  "Commission") {
                                showToast(
                                    "You request is in process wait for support response");
                                return;
                              }
                            } else {
                              otherUser = widget.intransferFile.sellerId;
                              if (widget.intransferFile.buyerAction ==
                                  "Commission") {
                                showToast(
                                    "You request is in process wait for support response");
                                return;
                              }
                            }
                            double amount = (double.tryParse(
                                        commissionSociety.percentage) /
                                    100) *
                                double.tryParse(widget.intransferFile.price);

                            await comissionConformPopup(
                                context,
                                widget.intransferFile,
                                amount.toString(),
                                user, (id, price, user_id, intransferFile) {
                              //
                              commessionProperty(
                                  user_id, amount, intransferFile);
                            }, type: "property_intransfer");
                          },
                          // color: Colors.blueGrey,
                          child: Row(
                            children: [
                              Icon(
                                Icons.support_agent,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  "On " +
                                      commissionSociety.percentage +
                                      "% commission for Support help",
                                  style: TextStyle(
                                      color: darkTheme["secondaryColor"]),
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              if (!isUserCommission &&
                  checkHours(widget.intransferFile.hours.toString()))
                Padding(
                  padding: const EdgeInsets.fromLTRB(26, 0, 20, 0),
                  child: Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        child: FlatButton(
                            onPressed: () {
                              var user = widget.user.id;
                              var otherUser;
                              if (widget.intransferFile.sellerId ==
                                  widget.user.id) {
                                otherUser = widget.intransferFile.buyerId;
                              } else {
                                otherUser = widget.intransferFile.sellerId;
                              }
                              // print(user + otherUser);
                              startChat(user, otherUser);
                            },
                            // color: Colors.blueGrey,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: darkTheme["secondaryColor"],
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Start Chat",
                                  style: TextStyle(color: Colors.white),
                                )
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: getWidth(context) / 1.6,
                child: CustomeElivatedButtonWidget(
                  onPress: () {
                    if (userItemStatus(
                            widget.intransferFile.sellerId,
                            widget.intransferFile.sellerAction,
                            widget.intransferFile.buyerAction,
                            widget.user.id) ==
                        'Completed') {
                      // print("Completed");
                      return;
                    } else if (userItemStatus(
                            widget.intransferFile.sellerId,
                            widget.intransferFile.sellerAction,
                            widget.intransferFile.buyerAction,
                            widget.user.id) ==
                        'Commission') {
                      return;
                    } else {
                      print(checkHours(widget.intransferFile.hours.toString()));
                      if (checkHours(widget.intransferFile.hours.toString())) {
                        // hammerDialog(context);
                        clearDealData();
                      } else {
                        return;
                      }
                    }
                  },
                  color: userItemStatus(
                              widget.intransferFile.sellerId,
                              widget.intransferFile.sellerAction,
                              widget.intransferFile.buyerAction,
                              widget.user.id) ==
                          "Completed"
                      ? Colors.green
                      : checkHours(widget.intransferFile.hours.toString())
                          ? Colors.blue
                          : Colors.red,
                  name: userItemStatus(
                              widget.intransferFile.sellerId,
                              widget.intransferFile.sellerAction,
                              widget.intransferFile.buyerAction,
                              widget.user.id) ==
                          "Completed"
                      ? widget.intransferFile.sellerAction == "Completed" &&
                              widget.intransferFile.buyerAction == "Completed"
                          ? "Completed"
                          : "Pending"
                      : userItemStatus(
                                  widget.intransferFile.sellerId,
                                  widget.intransferFile.sellerAction,
                                  widget.intransferFile.buyerAction,
                                  widget.user.id) ==
                              "Commission"
                          ? "Commission"
                          : checkHours(widget.intransferFile.hours.toString())
                              ? "Clear"
                              : "Expired",
                ),
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
    );
    ;
  }
}

class IntransferFileItemWidget extends StatefulWidget {
  IntransferFile intransferFile;
  User user;
  final refreshList;
  List<FileCommissionSociety> commissionSocieties;

  IntransferFileItemWidget(
      {this.intransferFile,
      this.user,
      this.refreshList,
      this.commissionSocieties});

  @override
  _IntransferFileItemWidgetState createState() =>
      _IntransferFileItemWidgetState();
}

class _IntransferFileItemWidgetState extends State<IntransferFileItemWidget> {
  FileCommissionSociety commissionSociety;
  bool isCommissionExist = false;
  bool isUserCommission = false;
  bool isCommissionTicketLoading = false;
  bool _mClearRequesting = false;
  bool isRequesting = false;

  clearFromHistory() async {
    if (_mClearRequesting) {
      showToast("your request is processing");
      playStopSound();
      return;
    }
    // var dialog = await
    showDialog(
        context: context,
        builder: (BuildContext cont) {
          return AlertDialog(
              title: Text("Warning!"),
              content: Text(
                  "Ensure everything. After clearing the deal OPXA cannot follow up your case"),
              actions: [
                FlatButton(
                  onPressed: () async {
                    Navigator.pop(cont);
                    var userType = '';
                    widget.intransferFile.sellerId == widget.user.id
                        ? userType = "Seller"
                        : userType = "Buyer";
                    var request = {
                      "id": widget.intransferFile.historyId,
                      "user_id": widget.user.id,
                      "user_type": userType
                    };
                    setState(() {
                      _mClearRequesting = true;
                    });
                    ProgressDialog progressDialog = showProgressDialog(
                        ProgressDialog(context, isDismissible: false));
                    var res = await clearIntransferService(request);
                    hideProgressDialog(progressDialog);
                    setState(() {
                      _mClearRequesting = false;
                    });
                    widget.refreshList();
                  },
                  child: Text("Ok"),
                ),
                FlatButton(
                    onPressed: () {
                      Navigator.pop(cont);
                    },
                    child: Text("CANCEL"))
              ]);
        });
  }

  startChat(userId, otherUserId) async {
    var request = {
      "requestType": "chatRequest",
      "userId": userId,
      "otherUserId": otherUserId,
      "history_id": widget.intransferFile.historyId,
      "type": "File",

      // "user_type": otherUserId
    };
    // print(request);
    ProgressDialog pr = ProgressDialog(context,
        type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.show();
    var res = await getConversationList(request);
    pr.hide();
    if (res != null) {
      Chat chat = Chat.fromJson(res["response"]["chat"]);
      Navigator.of(context).pushNamed("chat_detail", arguments: chat);
    } else {
      showToast("Cannot Create Chat Room");
    }
  }

  commessionFile(userId, amount, IntransferFile intransferFile) async {
    // if(isRequesting){
    //   showToast("too many requests please wait");
    //   return;
    // }
    var request = {
      "intransfer_id": intransferFile.historyId,
      "user_id": widget.user.id,
      "amount": amount,
      "tp": "file_intransfer"
      // "user_type": otherUserId
    };
    // print(request);
    // ProgressDialog pr = ProgressDialog(context,
    //     type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    // pr.show();
    if (isRequesting) {
      showToast("your request is in process please wait");
      return;
    }
    setState(() {
      isRequesting = true;
    });
    ProgressDialog progressDialog =
        showProgressDialog(ProgressDialog(context, isDismissible: false));
    var res = await commissionRequestService(request);
    hideProgressDialog(progressDialog);
    setState(() {
      isRequesting = false;
    });
    // pr.hide();
    if (res == null) {
      showToast("unfortunate error");
    }
    if (res["ResponseCode"] == 0) {
      showToast(res["ResponseMessage"]);
      Navigator.of(context).pop();
      var data = jsonDecode(res["data"]);
      // ProgressDialog progressDialog =
      // showProgressDialog(ProgressDialog(context, isDismissible: false));
      var a = await rechargeCommissionDialog(context, intransferFile.historyId,
          total: data["amount"].toString(),
          remainingAmount: data["remaining_amount"].toString(),
          available: data["wallet_amount"].toString(),
          user_id: userId,
          type: "file_intransfer");
      showToast("proceeding request... ");
      // Navigator.of(context).pop();
      widget.refreshList();
    }
    if (res["ResponseCode"] == 1) {
      showToast("successfully recharged");
      widget.refreshList();
      Navigator.of(context).pop();
      return;
    }
  }

  checkCommissionTicketId(userId, seller) async {}

  getItemData() {
    if (widget.intransferFile.sellerId == widget.user.id) {
      if (widget.intransferFile.sellerAction == "Commission") {
        setState(() {
          isUserCommission = true;
        });
        checkCommissionTicketId(widget.user.id, "Seller");
      }
    } else {
      if (widget.intransferFile.buyerAction == "Commission") {
        setState(() {
          isUserCommission = true;
        });
        checkCommissionTicketId(widget.user.id, "Buyer");
      }
    }
    List<FileCommissionSociety> tempCommission = [];
    tempCommission.addAll(widget.commissionSocieties.where((element) {
      // print(element.societyId + " | intr"+widget.intransferFile.socialId.toString() );
      return element.societyId == widget.intransferFile.socialId;
    }));

    if (tempCommission.length > 0) {
      setState(() {
        isCommissionExist = true;
        commissionSociety = tempCommission.first;
      });
    }
  }

  @override
  void initState() {
    // getItemData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print("heq1212");
    getItemData();
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 14, 10, 0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Material(
          color: darkTheme["cardBackground"],
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Container(
                width: widget.intransferFile.fileName.length * 12.1 <
                        getWidth(context)
                    ? widget.intransferFile.fileName.length * 12.1
                    : getWidth(context),
                child: Column(
                  children: [
                    Divider(
                      color: Colors.white,
                      thickness: .6,
                    ),
                    SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          FontAwesomeIcons.solidFile,
                          color: Colors.white,
                          size: 20,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Flexible(
                          child: Text(
                            widget.intransferFile.fileName,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.white,
                      thickness: .6,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Stack(
                children: [
                  Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                        child: Text(
                          "F-" + widget.intransferFile.historyId,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 20),
                        ),
                      )),
                  if (widget.intransferFile.ticketId != null &&
                      widget.intransferFile.ticketId != "null")
                    Align(
                        alignment: Alignment.topRight,
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 20, 0),
                          child: Text(
                            "TKT-" + widget.intransferFile.ticketId,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16),
                          ),
                        )),
                  Align(
                    alignment: Alignment.center,
                    child: Container(
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/images/timer.svg",
                            width: 170,
                            color: userItemStatus(
                                        widget.intransferFile.sellerId,
                                        widget.intransferFile.sellerAction,
                                        widget.intransferFile.buyerAction,
                                        widget.user.id) ==
                                    "Completed"
                                ? Colors.green
                                : checkHours(widget.intransferFile.hours)
                                    ? Colors.blue
                                    : Colors.red,
                          ),
                          SizedBox(
                            width: 100,
                            child: Text(
                              isUserCommission
                                  ? "Support"
                                  : userItemStatus(
                                              widget.intransferFile.sellerId,
                                              widget
                                                  .intransferFile.sellerAction,
                                              widget.intransferFile.buyerAction,
                                              widget.user.id) ==
                                          'Completed'
                                      ? widget.intransferFile.sellerAction ==
                                                  "Completed" &&
                                              widget.intransferFile
                                                      .buyerAction ==
                                                  "Completed"
                                          ? "Deal Done"
                                          : checkHours(
                                                  widget.intransferFile.hours)
                                              ? "Pending"
                                              : "Timeout"
                                      : checkHours(widget.intransferFile.hours)
                                          ? widget.intransferFile.hours +
                                              " : " +
                                              widget.intransferFile.minuts
                                          : "Time Stopped",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 22,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                widget.intransferFile.sellerId == widget.user.id
                    ? "Buyer " + "Information"
                    : "Seller " + "Information",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                child: Flex(
                  direction: Axis.horizontal,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 20,
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Flexible(
                            child: Text(
                              widget.intransferFile.sellerId == widget.user.id
                                  ? widget.intransferFile.buyerName
                                  : widget.intransferFile.sellerName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () async {
                          await launch(
                              "tel:+" + widget.intransferFile.buyerNumber);
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              FontAwesomeIcons.phone,
                              color: Colors.white,
                              size: 14,
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                              child: Text(
                                widget.intransferFile.sellerId == widget.user.id
                                    ? widget.intransferFile.buyerNumber
                                    : widget.intransferFile.sellerNumber,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 0, 26, 0),
                child: Flex(
                  direction: Axis.horizontal,
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Wrap(
                        direction: Axis.horizontal,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        children: [
                          Icon(
                            Icons.monetization_on_sharp,
                            color: Colors.white,
                            size: 16,
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                            child: Text(
                              "PKR " + widget.intransferFile.price + " / file",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            FontAwesomeIcons.solidFileAlt,
                            color: Colors.white,
                            size: 14,
                          ),
                          SizedBox(
                            width: 9,
                          ),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(0, 4, 0, 0),
                            child: Text(
                              widget.intransferFile.quantity + " Files",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(26, 0, 20, 0),
                child: Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_pin,
                            color: Colors.white,
                            size: 18,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Flexible(
                            child: Text(
                              widget.intransferFile.cityName +
                                  " " +
                                  widget.intransferFile.symbol,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isUserCommission &&
                        checkHours(widget.intransferFile.hours))
                      Expanded(
                        child: FlatButton(
                            onPressed: () {
                              var user = widget.user.id;
                              var otherUser;
                              if (widget.intransferFile.sellerId ==
                                  widget.user.id) {
                                otherUser = widget.intransferFile.buyerId;
                              } else {
                                otherUser = widget.intransferFile.sellerId;
                              }
                              startChat(user, otherUser);
                            },
                            // color: Colors.blueGrey,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.chat,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Flexible(
                                  child: Text(
                                    "Start Chat",
                                    style: TextStyle(
                                        color: darkTheme["secondaryColor"]),
                                  ),
                                )
                              ],
                            )),
                      )
                  ],
                ),
              ),
              if (isCommissionExist &&
                  !isUserCommission &&
                  userItemStatus(
                          widget.intransferFile.sellerId,
                          widget.intransferFile.sellerAction,
                          widget.intransferFile.buyerAction,
                          widget.user.id) ==
                      "Clear" &&
                  checkHours(widget.intransferFile.hours))
                Flex(
                  direction: Axis.horizontal,
                  children: [
                    Expanded(
                      child: FlatButton(
                          onPressed: () async {
                            var user = widget.user.id;
                            var otherUser;
                            if (widget.intransferFile.sellerId ==
                                widget.user.id) {
                              otherUser = widget.intransferFile.buyerId;
                              if (widget.intransferFile.sellerAction ==
                                  "Commission") {
                                showToast(
                                    "You request is in process wait for support response");
                                return;
                              }
                            } else {
                              otherUser = widget.intransferFile.sellerId;
                              if (widget.intransferFile.buyerAction ==
                                  "Commission") {
                                showToast(
                                    "You request is in process wait for support response");
                                return;
                              }
                            }

                            double amount =
                                ((int.tryParse(commissionSociety.percentage) /
                                            100) *
                                        double.tryParse(
                                            widget.intransferFile.price)) *
                                    checkDouble(double.tryParse(
                                        widget.intransferFile.quantity));

                            await comissionConformPopup(
                                context,
                                widget.intransferFile,
                                amount.toString(),
                                user, (id, price, user_id,
                                    IntransferFile intransferFile) {
                              //
                              commessionFile(user_id, amount, intransferFile);
                            });
                          },
                          // color: Colors.blueGrey,
                          child: Row(
                            children: [
                              Icon(
                                Icons.support_agent,
                                color: Colors.white,
                                size: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Flexible(
                                child: Text(
                                  "On " +
                                      commissionSociety.percentage +
                                      "% commission for Support help",
                                  style: TextStyle(
                                      color: darkTheme["secondaryColor"]),
                                ),
                              )
                            ],
                          )),
                    )
                  ],
                ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: getWidth(context) / 1.6,
                child: CustomeElivatedButtonWidget(
                  onPress: () {
                    if (userItemStatus(
                            widget.intransferFile.sellerId,
                            widget.intransferFile.sellerAction,
                            widget.intransferFile.buyerAction,
                            widget.user.id) ==
                        'Completed') {
                      // print("Completed");
                      return;
                    } else if (userItemStatus(
                            widget.intransferFile.sellerId,
                            widget.intransferFile.sellerAction,
                            widget.intransferFile.buyerAction,
                            widget.user.id) ==
                        'Commission') {
                      // print("Completed");
                      return;
                    } else {
                      // print(checkHours(widget.intransferFile.hours));
                      if (checkHours(widget.intransferFile.hours)) {
                        // hammerDialog(context);
                        clearFromHistory();
                      } else {
                        return;
                      }
                    }
                  },
                  color: userItemStatus(
                              widget.intransferFile.sellerId,
                              widget.intransferFile.sellerAction,
                              widget.intransferFile.buyerAction,
                              widget.user.id) ==
                          "Completed"
                      ? Colors.green
                      : checkHours(widget.intransferFile.hours)
                          ? Colors.blue
                          : Colors.red,
                  name: userItemStatus(
                              widget.intransferFile.sellerId,
                              widget.intransferFile.sellerAction,
                              widget.intransferFile.buyerAction,
                              widget.user.id) ==
                          "Completed"
                      ? widget.intransferFile.sellerAction == "Completed" &&
                              widget.intransferFile.buyerAction == "Completed"
                          ? "Completed"
                          : "Pending"
                      : userItemStatus(
                                  widget.intransferFile.sellerId,
                                  widget.intransferFile.sellerAction,
                                  widget.intransferFile.buyerAction,
                                  widget.user.id) ==
                              "Commission"
                          ? "Commission"
                          : checkHours(widget.intransferFile.hours)
                              ? "Clear"
                              : "Expired",
                ),
              ),
              SizedBox(
                height: 16,
              )
            ],
          ),
        ),
      ),
    );
  }
}

userItemStatus(sellerId, sellerAction, buyerAction, userId) {
  // print("===============");
  // print(sellerId);
  // print(userId);
  if (sellerId == userId) {
    if (sellerAction == 'Completed') {
      return 'Completed';
    } else {
      if (sellerAction == "Commission") {
        return 'Commission';
      } else {
        return 'Clear';
      }
    }
  } else {
    if (buyerAction == 'Completed') {
      return 'Completed';
    } else {
      if (buyerAction == "Commission") {
        return 'Commission';
      } else {
        return 'Clear';
      }
    }
  }
}

bool checkHours(String hours) {
  try {
    if (int.parse(hours) > 0) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    print(e);
    return false;
  }
}

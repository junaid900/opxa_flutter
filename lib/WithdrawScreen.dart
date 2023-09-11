import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/CircularInputField.dart';
import 'package:qkp/CustomeElivatedButton.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'package:qkp/Network/network.dart';
import 'Constraint/globals.dart' as global;
import 'Model/User.dart';
import 'Network/URLS.dart';
import 'main.dart';

class WithdrawWidgetScreen extends StatefulWidget {
  @override
  _WithdrawWidgetScreenState createState() => _WithdrawWidgetScreenState();
}

class _WithdrawWidgetScreenState extends State<WithdrawWidgetScreen> with RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  bool isTopLoading = false;
  User user;
  String bankName = "", accountNo = "", details = "", walletAmount = "";
  String selectType = null;

  getPageData() async {
    user = await getUser();
  }

  submit() async {
    if (isTopLoading) {
      showToast(
          "you are clicking too fast please wait your request is in process");
      playStopSound();
      return;
    }
    if (accountNo.length < 5) {
      showToast("invalid account no must be more then 5 characters");
      playStopSound();
      return;
    }
    if (bankName.length < 2) {
      showToast("invalid bank name");
      playStopSound();
      return;
    }
    if (details.length < 10) {
      showToast("invalid details must be greater then 10 characters");
      playStopSound();
      return;
    }
    if (!isNumeric(walletAmount)) {
      showToast("not a valid amount");
      playStopSound();
      return;
    }
    // if(selectType == null){
    //   showToast("please select a type");
    //   playStopSound();
    //   return;
    // }
    var request = {
      "user_id": user.id,
      "bank_name": bankName,
      "account_no": accountNo,
      "detail": details,
      "amount": walletAmount,
      // "type": selectType
    };
    setState(() {
      isTopLoading = true;
    });
    ProgressDialog p = showShortDialog(context);
    var data = await postRequest(WITHDRAW_REQUEST, request);
    await p.hide();
    // hideProgressDialog(p);
    if (data != null) {
      print("here");
      // await Future.delayed(Duration(milliseconds: 1000));
      print(p.isShowing());
      setState(() {
        isTopLoading = false;
        // if(p.isShowing()) {
        Navigator.of(context).pop();
        // Navigator.of(context).pop();
        // }
      });
    }
  }

  @override
  void initState() {
    getPageData();
    super.initState();
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
    var args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: darkTheme["primaryBackgroundColor"],
      appBar: AppBar(
        title: Text("Withdraw Information"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(7.0),
          child: isTopLoading ? LinearProgressIndicator() : SizedBox(),
        ),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(
                    child: Text(
                      "Currect Amount",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Center(
                    child: Text(
                      args.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "What is your deposit bank details?",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Visibility(
                        visible: false,
                        child: Container(
                          height: 70,
                          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white,
                          ),
                          // color: Colors.white,
                          child: DropdownSearch<String>(
                            mode: Mode.DIALOG,
                            items: ["Money", "Bids"],
                            label: "Select Subtype",
                            selectedItem: selectType,
                            onChanged: (_) {
                              selectType = _;
                            },
                            dropdownSearchDecoration: InputDecoration(
                                fillColor: Colors.white,
                                border: InputBorder.none
                                // UnderlineInputBorder(
                                //   borderSide: BorderSide(color: Color(0xFF01689)),
                                // ),
                                ),
                            // selectedItem: selectedCity,
                            showSearchBox: false,
                            searchBoxDecoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                              labelText: "Search a Sub Type",
                            ),
                            popupTitle: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                color: darkTheme["primaryBackgroundColor"],
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Sub Type',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                            popupShape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(24),
                                topRight: Radius.circular(24),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // SizedBox(
                      //   height: 10,
                      // ),
                      CircularInputField(
                        hintText: "Amount",
                        onChanged: (val) {
                          walletAmount = val;
                        },
                        type: TextInputType.number,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularInputField(
                        hintText: "Account No",
                        onChanged: (val) {
                          accountNo = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularInputField(
                        hintText: "Bank Name",
                        onChanged: (val) {
                          bankName = val;
                        },
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularInputField(
                        hintText: "More Account details & contact information",
                        onChanged: (val) {
                          details = val;
                        },
                        minLines: 3,
                        maxLines: 3,
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: getWidth(context) * .70,
                        child: CustomeElivatedButtonWidget(
                          onPress: () {
                            submit();
                          },
                          name: "Submit",
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

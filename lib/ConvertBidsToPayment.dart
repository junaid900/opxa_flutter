import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'package:qkp/Network/network.dart';
import 'package:qkp/main.dart';

import 'CircularInputField.dart';
import 'CustomeElivatedButton.dart';
import 'Network/URLS.dart';
import 'Constraint/globals.dart' as global;


class ConvertBidsToPaymentWidget extends StatefulWidget {
  @override
  _ConvertBidsToPaymentWidgetState createState() => _ConvertBidsToPaymentWidgetState();
}

class _ConvertBidsToPaymentWidgetState extends State<ConvertBidsToPaymentWidget> with RouteAware {
  @override
  void setState(fn){
    if(mounted)
      super.setState(fn);
  }

  String actionCounter;
  Map wallet = {};
  User user;
  String bids;
  getPageData() async {
    user = await getUser();
  }
  submit() async {
    if(isNumber(bids) && isNumber((actionCounter))){
      if(int.tryParse(bids) > int.tryParse(actionCounter)){
        showToast("bids cannot be greater then number of bids");
        return;
      }
    }else{
      showToast("Invalid bids");
      return;
    }
    var request = {
      "user_id": user.id,
      "bids" : bids
    };
    ProgressDialog progressDialog = showProgressDialog(ProgressDialog(context),);
    var response = await postRequest(WITHDRAW_BIDS, request);
    progressDialog.hide();
    if(response["ResponseCode"] == 1) {
      setState(() {
        // isTopLoading = false;
        Navigator.of(context).pop();
      });
    }

  }


  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    wallet = ModalRoute.of(context).settings.arguments;
    actionCounter = wallet["action_counter"];
    routeObserver.subscribe(this, ModalRoute.of(context));
    fcmInit();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageData();
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
    return  Scaffold(
      backgroundColor: darkTheme["primaryBackgroundColor"],
      appBar: AppBar(
        title: Text("Sell Bids"),
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
                      actionCounter.toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10,),
              Text(
                "Want To Convert Bids To Money?",
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
                      CircularInputField(
                        hintText: "Bids",
                        onChanged: (val) {
                          bids = val;
                        },
                        type: TextInputType.number,
                      ),
                      SizedBox(
                        height: 10,
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

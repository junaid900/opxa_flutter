import 'package:flutter/material.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/Complain.dart';
import 'package:qkp/Network/URLS.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';

import 'CircularInputField.dart';
import 'CustomeElivatedButton.dart';
import 'Model/User.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';

class ComplainCenterWidget extends StatefulWidget {
  @override
  _ComplainCenterWidgetState createState() => _ComplainCenterWidgetState();
}

class _ComplainCenterWidgetState extends State<ComplainCenterWidget> with RouteAware {
  String title = "";
  String desc = "";
  bool isTopLoading = false;
  User user = null;
  List<Complain> complains = [];
  List<Widget> col1Items = [];

  getPageData() async {
    user = await getUser();
    var request = {"user_id": user.id};
    var data = await postRequest(GET_COMPLAINS, request);
    var res = data["response"];
    complains.clear();
    for (int i = 0; i < res.length; i++) {
      complains.add(Complain.fromJson(res[i]));
    }
    setState(() {
      complains = complains;
    });
  }

  // setCol1(){
  //   // col1Items.addAll([
  //   //
  //   // ]);
  //   setState(() {
  //     col1Items = col1Items;
  //   });
  // }

  @override
  void initState() {
    // TODO: implement initState
    getPageData();
    fcmInit();
    super.initState();
    // setCol1();
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
    return Scaffold(
      backgroundColor: appbg,
      appBar: AppBar(
        title: Text("Contact Center"),
      ),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter your query details here with your personal details",
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
                      // SizedBox(
                      //   height: 10,
                      // ),
                      CircularInputField(
                        hintText: "Title",
                        onChanged: (val) {
                          title = val;
                        },
                        type: TextInputType.text,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      CircularInputField(
                        hintText: "Detail",
                        onChanged: (val) {
                          desc = val;
                        },
                        maxLines: 4,
                        minLines: 4,
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
              ),
              for (int i = 0; i < complains.length; i++)
                ComplainItemWidget(
                    complain: complains[i],
                    refresh: () {
                      getPageData();
                    })
            ],
          ),
        ),
      ),
    );
  }

  submit() async {
    if (isTopLoading) {
      showToast(
          "you are clicking too fast please wait your request is in process");
      playStopSound();
      return;
    }
    if (title.length < 5) {
      showToast("invalid account no must be more then 5 characters");
      playStopSound();
      return;
    }
    if (desc.length < 20) {
      showToast("atleast 20 charecters for description");
      playStopSound();
      return;
    }

    var request = {
      "user_id": user.id,
      "title": title,
      "desc": desc,
    };
    setState(() {
      isTopLoading = true;
    });
    ProgressDialog progressDialog =
        showProgressDialog(ProgressDialog(context, isDismissible: false));
    var data = await postRequest(ADD_COMPLAIN, request);
    progressDialog.hide();
    setState(() {
      isTopLoading = false;
    });
    if (data != null) {
      reset();
      getPageData();
      // Navigator.of(context).pop();
    }
    // setState(() {
    //   isTopLoading = false;
    // });
  }

  reset() {
    title = "";
    desc = "";
  }
}

class ComplainItemWidget extends StatefulWidget {
  Complain complain;
  Function refresh;

  ComplainItemWidget({this.refresh, this.complain});

  @override
  _ComplainItemWidgetState createState() => _ComplainItemWidgetState();
}

class _ComplainItemWidgetState extends State<ComplainItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: getWidth(context),
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
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8.0, 18.0, 8.0, 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flex(
                direction: Axis.horizontal,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      "Query no :- ${widget.complain.id}",
                      style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.w900,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10, 3, 10, 3),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(3),
                          color: widget.complain.status == "Inactive"
                              ? Colors.green
                              : Colors.blueAccent,
                        ),
                        child: Center(
                          child: Text(
                            "${widget.complain.status}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ))
                ],
              ),
              Text(
                "${widget.complain.title}",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              ),
              Text(
                "${widget.complain.description}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
              Text(
                "${widget.complain.adminDetails}",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    ;
  }
}

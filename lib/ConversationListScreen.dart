import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/ChatUser.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';
import 'Constraint/Dialog.dart';
import 'Model/User.dart';
import 'main.dart';
import 'Constraint/globals.dart' as global;

class ConversationListWidget extends StatefulWidget {
  @override
  _ConversationListWidgetState createState() => _ConversationListWidgetState();
}

class _ConversationListWidgetState extends State<ConversationListWidget>
    with RouteAware {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  List<Chat> chats = [];
  User user;
  bool isLoading = true;

  getPageData() async {
    user = await getUser();
    setState(() {
      user = user;
      // isLoading = true;
    });
    var request = {
      "requestType": "getChatList",
      "userId": user.id,
    };
    var data = await getConversationList(request);

    setState(() {
      isLoading = false;
    });
    if (data != null) {
      var res = data["response"]["chats"];
      chats.clear();
      for (int i = 0; i < res.length; i++) {
        chats.add(Chat.fromJson(res[i]));
      }
      setState(() {
        chats = chats;
      });
    }
  }

  getTime() {
    DateFormat df = new DateFormat();
  }

  @override
  void initState() {
    getPageData();
    // TODO: implement initState
    super.initState();
  }

  @override
  void didPopNext() {
    fcmInit();
  }

  void FCMMesseging(message) {
    print("onMessage Files Market: $message");
    if (message["data"]["type"] == "Intransfer") {
      hammerDialog(context);
    }
    getPageData();
  }

  fcmInit() {
    global.onInnerMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }

  Timer timer;

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    fcmInit();
    timer = new Timer(Duration(seconds: 15), () {
      getPageData();
    });
    routeObserver.subscribe(this, ModalRoute.of(context));
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: darkTheme["primaryBackgroundColor"],
        appBar: AppBar(
          title: Text("Conversation"),
        ),
        body: Stack(
          children: [
            ListView.builder(
              itemCount: chats.length,
              shrinkWrap: true,
              // padding: EdgeInsets.only(top: 16),
              // physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return ConversationItemWidget(
                    chatUser: chats[index],
                    func: () {
                      getPageData();
                    });
              },
            ),
            if (isLoading)
              AppLoadingScreen(
                backgroundOpactity: .6,
              )
          ],
        ));
  }
}

class ConversationItemWidget extends StatefulWidget {
  Chat chatUser;
  bool isMessageRead = false;
  Function func;

  ConversationItemWidget({this.chatUser, this.func});

  @override
  _ConversationItemWidgetState createState() => _ConversationItemWidgetState();
}

class _ConversationItemWidgetState extends State<ConversationItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () async {
          var data = await Navigator.of(context)
              .pushNamed("chat_detail", arguments: widget.chatUser);
          widget.func();
        },
        child: Container(
          // color: Colors.red,
          // height: 160,
          padding: EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          decoration: BoxDecoration(
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.white))),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                        // color: Colors.black,
                        //height: 100,
                        child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: FadeInImage(
                        placeholder: AssetImage("assets/images/profile.png"),
                        image: NetworkImage(url + widget.chatUser.profileImage),
                        fit: BoxFit.cover,
                        width: 60,
                        height: 60,
                      ),
                    )),
                    SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width / 2.5,
                                  decoration: BoxDecoration(),
                                  child: widget.chatUser.type == "File"
                                      ? Text(
                                          widget.chatUser.history != null
                                              ? "F-${widget.chatUser.historyId} ( ${widget.chatUser.history.name} ) "
                                              : "Not Name Found",
                                          /*+ " "+ widget.chatUser.type,*/
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        )
                                      : Text(
                                          widget.chatUser.history != null
                                              ? "P-${widget.chatUser.historyId} ( ${widget.chatUser.history
                                              .propertyName } ) "
                                              : "Not Name Found",
                                          /*+ " "+ widget.chatUser.type,*/
                                          maxLines: 3,
                                          style: TextStyle(
                                              fontSize: 14,
                                              color: Colors.white),
                                        ),
                                ),
                                Text(
                                  DateFormat.jm()
                                      .format(DateFormat("hh:mm:ss").parse(
                                        widget.chatUser.updatedAt.split(" ")[1],
                                      ))
                                      .toString(),

                                  //DateTime.now().toString(),
                                  //  widget.chatUser.updatedAt.split(" ")[1],
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: widget.isMessageRead
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      color: Colors.white),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.chatUser.message,
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey[400],
                                  fontWeight: widget.isMessageRead
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                            /* Text(
                              widget.chatUser.updatedAt.split(" ")[1],
                              style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: widget.isMessageRead
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),*/
                            // Divider(),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              widget.chatUser.count > 0
                  ? Container(
                      width: getWidth(context) * .05,
                      height: getWidth(context) * .05,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Center(
                        child: Text(
                          widget.chatUser.count.toString(),
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

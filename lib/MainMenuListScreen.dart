import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qkp/FoldableDrawer.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/MateiralInputField.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';

class MainMenuListWidget extends StatefulWidget {
  @override
  _MainMenuListWidgetState createState() => _MainMenuListWidgetState();
}

class _MainMenuListWidgetState extends State<MainMenuListWidget> {
  List menuItemsList = [];
  bool reportOpen = false;
  FSBStatus drawerStatus = FSBStatus.FSB_CLOSE;
  String firstNameValue;
  String LastNameValue;
  User user;
  @override
  getUserData() async {
    user = await getUser();
    setState(() {
      user = user;
      firstNameValue = user.firstName;
      LastNameValue = user.lastName;

    });

  }


  updateProfileData() async {

  //  print(firstNameCtrl.text + " " + LastNameCtrl.text);
    String firstName = firstNameValue;
    String lastName = LastNameValue;

    var request = <String, String>{"first_name": firstName, "last_name": lastName,"current_user":user.id};
    print(request.toString());
    //    var request = new Map();
    var data = await updateProfile(request);
    if (data != null) {
      User currentUser = new User();
      currentUser.fromJson(data["User"]);
      await setUser(currentUser);
      // Navigator.pushReplacementNamed(_keyLoader.currentContext, "/");
      // Navigator.pushReplacementNamed(context, "/");
    }
  }
  void initState() {
    getUserData();

    menuItemsList = [
      {
        "title": "Profile",
        "onClick": (context) {
          Navigator.pushNamed(context, 'portfolio');
        },
        "icon": FontAwesomeIcons.personBooth,
        "visible": true,
      },
      {
        "title": "Reports",
        "onClick": (context) {
          // Navigator.pushNamed(context, 'market_watch');

          List indexList = [2,3,4,5,6,7];
          setState(() {
            reportOpen = !reportOpen;
            if(reportOpen)
            menuItemsList[1]["icon"] = FontAwesomeIcons.arrowDown;
            else
            menuItemsList[1]["icon"] = FontAwesomeIcons.arrowRight;
          });
          if(reportOpen) {
            for (int i = 0; i < indexList.length; i++) {
              menuItemsList[indexList[i]]["visible"] = true;
            }
          } else {
            for (int i = 0; i < indexList.length; i++) {
              menuItemsList[indexList[i]]["visible"] = false;
            }
          }
          setState(() {
            menuItemsList = menuItemsList;
          });

        },
        "icon": FontAwesomeIcons.arrowRight,
        "visible": true,
      },
      {
        "title": "Market Watch",
        "onClick": (context) {
          Navigator.pushNamed(context, 'market_watch');
        },
        "icon": Icons.list_alt,
        "visible": false,
      },
      {
        "title": "Market Performers",
        "onClick": (context) {
          Navigator.pushNamed(context, 'market_performers');
        },
        "icon": Icons.list_alt,
        "visible": false,
      },
      {
        "title": "Area Wise Trade Report",
        "onClick": (context) {
          Navigator.pushNamed(context, 'area_wise_trade_report');
        },
        "icon": Icons.list_alt,
        "visible": false,
      },
      {
        "title": "New Feeds",
        "onClick": (context) {
          Navigator.pushNamed(context, 'news_feed');
        },
        "icon": Icons.list_alt,
        "visible": false,
      },
      {
        "title": "Map Report",
        "onClick": (context) {
          Navigator.pushNamed(context, 'map_report');
        },
        "icon": Icons.list_alt,
        "visible": false,
      },
      {
        "title": "Transaction History",
        "onClick": (context) {
          Navigator.pushNamed(context, 'transaction_history');
        },
        "icon": Icons.list_alt,
        "visible": false,
      },
      {
        "title": "Chat",
        "onClick": (context) {
          // logout();
          Navigator.pushNamed(context, "conversation");
          return;
        },
        "icon": Icons.chat_bubble,
        "visible": true,
      },
      {
        "title": "How It Works?",
        "onClick": (context) {
          // logout();
          Navigator.pushNamed(context, "intro");
          return;
        },
        "icon": Icons.chat_bubble,
        "visible": true,
      },
      {
        "title": "Logout",
        "onClick": (context) {
          logout();
          Navigator.pushReplacementNamed(context, "login");
          return;
        },
        "icon": Icons.exit_to_app,
        "visible": true,
      },
    ];
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return FoldableDrawerWidget(
      drawerStatus: drawerStatus,
      widget: Scaffold(
        appBar: AppBar(
            title: Text('Profile'),
            actions: [
              IconButton(
                onPressed: (){
                  Navigator.pushNamed(context, "conversation");
                },
                icon:Icon(
                  Icons.message_rounded,
                ),
              ),
            ],
            leading: IconButton(
              onPressed: (){
                print(drawerStatus);
                setState(() {
                  drawerStatus = drawerStatus == FSBStatus.FSB_OPEN ? FSBStatus.FSB_CLOSE : FSBStatus.FSB_OPEN;
                });
              },
              icon:Icon(
                Icons.more_horiz,
              ),
            ),
        ),
        body: user != null ? Container(
          color: Colors.white,
          child: Container(
            padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
            // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Wrap(
              children: [
                Container(
                  child: Center(
                    child: ClipOval(
                      child: FadeInImage(
                        placeholder: AssetImage(
                            "assets/images/image_placeholder.gif"),
                        image: AssetImage(
                          "assets/images/profile.png",
                        ),
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.fromLTRB(0, 10, 0, 12),
                  child: MaterialInputFieldCustom(
                    value: user.firstName,
                    OnChange: (val){
                      setState(() {
                        firstNameValue = val;
                      });
                    },label:'First Name',icon:Image.asset(
                    "assets/images/user.png",
                    height: 13,
                  ),Obscure:false,),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                  child: MaterialInputFieldCustom(
                    value: user.lastName,
                    OnChange: (val){
                      setState(() {
                        LastNameValue = val;
                      });
                    },label:'Last Name',icon:Image.asset(
                    "assets/images/user.png",
                    height: 13,
                  ),Obscure:false,),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                  child: MaterialInputFieldCustom(
                    value: user.phone,
                    OnChange: (val){},label:'Phone Number',icon:Image.asset(
                    "assets/images/phone.png",
                    height: 13,
                  ),Obscure:false,),
                ),
                Center(
                  child: SizedBox(
                    width: 250,
                    height: 45,
                    child: ElevatedButton(
                        onPressed: () async {
                              updateProfileData();
                        },
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all<Color>(
                                darkTheme['primaryBackgroundColor']),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(25.0),
                                side: BorderSide(
                                    color: darkTheme["redText"]),
                              ),
                              // primary: darkTheme["secondaryColor"],
                            )),
                        child: Text("Update",
                            style: TextStyle(fontSize: 15))),
                  ),
                ),//
              ],
            ),
          ),
        ):Container(),
      ),
    );
  }
}

class MenuItemWidget extends StatefulWidget {
  String title;
  Function onClick;
  IconData icon;
  Map item = {};

  MenuItemWidget({this.title, this.onClick, this.icon,this.item});

  @override
  _MenuItemWidgetState createState() => _MenuItemWidgetState();
}

class _MenuItemWidgetState extends State<MenuItemWidget> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 1000),
      child: Visibility(
        visible: widget.item["visible"],
        child: Column(
          children: [
            SizedBox(
              height: 5,
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 1000),
              height: 40,
              decoration: BoxDecoration(
                color: darkTheme["cardBackground"],
              ),
              child: Material(
                color: Colors.transparent,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                  // padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: widget.onClick,
                    //
                    //     (){
                    //   Navigator.pushNamed(context, 'market_watch');
                    // },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 20,
                        ),
                        Icon(
                          widget.icon,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          widget.title,
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

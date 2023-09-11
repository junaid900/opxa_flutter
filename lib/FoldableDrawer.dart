import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foldable_sidebar/foldable_sidebar.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'dart:async';

class FoldableDrawerWidget extends StatefulWidget {
  Widget widget;
  FSBStatus drawerStatus;
  FoldableDrawerWidget({this.widget, this.drawerStatus =FSBStatus.FSB_CLOSE });

  @override
  _FoldableDrawerWidgetState createState() => _FoldableDrawerWidgetState();
}

class _FoldableDrawerWidgetState extends State<FoldableDrawerWidget> {

  //FSBStatus drawerStatus;
  User user;
  bool DrawerVisible =false;
  @override
  void initState() {
    getUserData();
    Timer(Duration(milliseconds: 100), () => DrawerVisible =true);

    // TODO: implement initState
    super.initState();
  }
  getUserData() async {
    user = await getUser();
    setState(() {
      user = user;
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: user!=null?FoldableSidebarBuilder(
        drawerBackgroundColor: darkTheme["primaryBackgroundColor"],
        drawer: CustomDrawer(closeDrawer: (){
          setState(() {
            widget.drawerStatus = FSBStatus.FSB_CLOSE;
          });
        },
          user:user,
          drawerVisible:DrawerVisible,
        ),
        screenContents: widget.widget,
        status: widget.drawerStatus,

      ):Container(),
     /* floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepOrange,
          child: Icon(Icons.menu,color: Colors.white,),
          onPressed: () {
            setState(() {
              drawerStatus = drawerStatus == FSBStatus.FSB_OPEN ? FSBStatus.FSB_CLOSE : FSBStatus.FSB_OPEN;
            });
          }),*/
    );
  }
}



class CustomDrawer extends StatelessWidget {

  final Function closeDrawer;
  final user;
  final drawerVisible;
  CustomDrawer({Key key, this.closeDrawer,this.user,this.drawerVisible}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    return Visibility(
      visible: drawerVisible,
      child: Container(
        color: darkTheme["primaryBackgroundColor"],
        width: mediaQuery.size.width * 0.60,
        height: mediaQuery.size.height,
        child: SingleChildScrollView(

          child: Column(
            children: <Widget>[
              Container(
                  width: double.infinity,
                  height: 200,
                  color:darkTheme["primaryBackgroundColor"],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.asset(
                        "assets/images/profile.png",
                        width: 100,
                        height: 100,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(user.userName, style:TextStyle(color:Colors.white)),
                    ],
                  )),
              ListTile(
                dense: true,
                onTap: (){
                  Navigator.pushNamed(context, 'portfolio');
                },
                title: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/Reports.svg'),
                    SizedBox(
                      width: 14, // here put the desired space between the icon and the text
                    ),
                    Text("My Portfolio",style:TextStyle(color:Colors.white,fontSize: 14)) // here we could use a column widget if we want to add a subtitle
                  ],
                ),
              ),
              ListTile(
                dense: true,
                onTap: (){
                  Navigator.pushNamed(context, 'market_watch');
                },
                title: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/MarketWatch.svg'),
                    SizedBox(
                      width: 14, // here put the desired space between the icon and the text
                    ),
                    Text("Market Watch",style:TextStyle(color:Colors.white,fontSize: 14)) // here we could use a column widget if we want to add a subtitle
                  ],
                ),
              ),
              ListTile(
                dense: true,
                onTap: (){
                  Navigator.pushNamed(context, 'market_performers');
                },
                title: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/MarketPerformance.svg'),
                    SizedBox(
                      width: 14, // here put the desired space between the icon and the text
                    ),
                    Text("Market Performers",style:TextStyle(color:Colors.white,fontSize: 14)) // here we could use a column widget if we want to add a subtitle
                  ],
                ),
              ),
              ListTile(
                dense: true,
                onTap: (){
                  Navigator.pushNamed(context, 'area_wise_trade_report');
                },
                title: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/AWTReport.svg'),
                    SizedBox(
                      width: 14, // here put the desired space between the icon and the text
                    ),
                    Flexible(child: Text("Area Wise Trade Report",style:TextStyle(color:Colors.white,fontSize: 14))) // here we could use a column widget if we want to add a subtitle
                  ],
                ),
              ),
              ListTile(
                dense: true,
                onTap: (){
                  Navigator.pushNamed(context, 'news_feed');
                },
                title: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/Newsfeed.svg'),
                    SizedBox(
                      width: 14, // here put the desired space between the icon and the text
                    ),
                    Text("News Feed",style:TextStyle(color:Colors.white,fontSize: 14)) // here we could use a column widget if we want to add a subtitle
                  ],
                ),
              ),
              ListTile(
                dense: true,
                onTap: (){
                  Navigator.pushNamed(context, 'map_report');
                },
                title: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/MapReport.svg'),
                    SizedBox(
                      width: 14, // here put the desired space between the icon and the text
                    ),
                    Text("Map Report",style:TextStyle(color:Colors.white,fontSize: 14)) // here we could use a column widget if we want to add a subtitle
                  ],
                ),
              ),
              ListTile(
                dense: true,
                onTap: (){
                  Navigator.pushNamed(context, 'account_statement');
                },
                title: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/TransactionHistory.svg'),
                    SizedBox(
                      width: 14, // here put the desired space between the icon and the text
                    ),
                    Text("Account Statement",style:TextStyle(color:Colors.white,fontSize: 14)) // here we could use a column widget if we want to add a subtitle
                  ],
                ),
              ),
              /*ListTile(
                dense: true,
                onTap: (){
                  Navigator.pushNamed(context, "conversation");
                },
                title: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/TransactionHistory.svg'),
                    SizedBox(
                      width: 14, // here put the desired space between the icon and the text
                    ),
                    Text("Chat",style:TextStyle(color:Colors.white,fontSize: 14)) // here we could use a column widget if we want to add a subtitle
                  ],
                ),
              ), */
              ListTile(
                dense: true,
                onTap: () {
                  logout();
                  Navigator.pushReplacementNamed(context, "login");
                },
                title: Row(
                  children: <Widget>[
                    SvgPicture.asset('assets/images/logout.svg'),
                    SizedBox(
                      width: 14, // here put the desired space between the icon and the text
                    ),
                    Text("Logout",style:TextStyle(color:Colors.white,fontSize: 14)) // here we could use a column widget if we want to add a subtitle
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

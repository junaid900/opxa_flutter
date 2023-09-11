import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:qkp/FavouritesScreen.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/HomeScreen.dart';
import 'package:qkp/MarketScreen.dart';
import 'package:qkp/MenuItemModel.dart';
import 'package:qkp/MyPortfolioScreen.dart';
import 'package:qkp/WalletScreen.dart';

class CustomeDrawer extends StatefulWidget {
  Function closeDrawer;
  Function openDrawer;

  @override
  _CustomeDrawerState createState() => _CustomeDrawerState();
}

class _CustomeDrawerState extends State<CustomeDrawer> {
  double xOffset = 0;
  double yOffset = 0;
  double scaleFector = 1;
  bool isDrawerOpen = false;
  int _currentTab = 0;
  String _currentTitle;

  checkSession() async {
    if (!await isLogin()) {
      Navigator.pushReplacementNamed(context, "login");
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkSession();
    widget.closeDrawer = () {
      closeDrawer();
    };
    widget.openDrawer = () {
      openDrawer();
    };
    setState(() {
      Tabs = [
        new MenuItem(
            container: HomeWidget(openDrawer: () {
              openDrawer();
              print("here");
            }, closeDrawer: () {
              closeDrawer();
            }),
            name: "Home",
            index: 0,
            isActive: false),
        new MenuItem(
            container: MarketWidget(openDrawer: () {
              openDrawer();
              print("here");
            }, closeDrawer: () {
              closeDrawer();
            }),
            name: "Market",
            index: 1,
            isActive: false),
        new MenuItem(
            container: FavouritesWidget(openDrawer: () {
              openDrawer();
              print("here");
            }, closeDrawer: () {
              closeDrawer();
            }),
            name: "Favourites",
            index: 2,
            isActive: false),
        new MenuItem(
            container: MyPortfolioWidget(openDrawer: () {
              openDrawer();
              print("here");
            }, closeDrawer: () {
              closeDrawer();
            }),
            name: "My Portfolio",
            index: 3,
            isActive: false),
        new MenuItem(
          container: WalletWidget(),
          name: "My Wallet",
          index: 4,
        ),
        new MenuItem(
          container: Container(),
          name: "Logout",
          index: 5,
        )
      ];
    });
  }

  // Widget logout(){

  // return Container();
  // }
  List Tabs;

  void openDrawer() {
    setState(() {
      xOffset = 220;
      yOffset = 140;
      scaleFector = 1;
      isDrawerOpen = true;
    });
    active();
  }

  active() {
    for (int i = 0; i < Tabs.length; i++) {
      if (Tabs[i].index == _currentTab) {
        setState(() {
          Tabs[i].isActive = true;
        });
      } else {
        setState(() {
          Tabs[i].isActive = false;
        });
      }
    }
  }

  void closeDrawer() {
    setState(() {
      xOffset = 0;
      yOffset = 0;
      scaleFector = 1;
      isDrawerOpen = false;
    });
    active();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Stack(
      children: [
        Container(
          padding: defaultTargetPlatform == TargetPlatform.iOS
              ? EdgeInsets.fromLTRB(0, 20, 0, 0)
              : EdgeInsets.all(0),
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [Colors.blueGrey[500], Colors.grey[900]]),
          ),
          width: _width,
          height: _height,
          child: Material(
            color: Colors.transparent,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      padding: EdgeInsets.fromLTRB(10, 20, 0, 0),
                      child: Image.asset(
                        'assets/images/logo_menu_h.png',
                        height: 60,
                      )),
                  SizedBox(
                    height: 50,
                  ),
                  Column(
                      children: List.generate(Tabs.length, (index) {
                    return DrawerMenuItems(
                        closeDrawer: () {
                          closeDrawer();
                          setState(() {
                            _currentTab = Tabs[index].index;
                          });
                        },
                        currentTab: Tabs[index].index,
                        title: Tabs[index].name,
                        isActive: Tabs[index].isActive == null
                            ? false
                            : Tabs[index].isActive);
                  })),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
          onHorizontalDragEnd: (dragEndDetails) {
            if (dragEndDetails.primaryVelocity < 0) {
              // Page forwards
              print('Move page forwards');
              closeDrawer();
            } else if (dragEndDetails.primaryVelocity > 0) {
              // Page backwards
              openDrawer();
              print('Move page backwards');
              // _goBack();
            }
          },
          child: AnimatedContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            transform: Matrix4.translationValues(xOffset, yOffset, 0)
              ..scale(scaleFector),
            duration: Duration(milliseconds: 500),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Container(
                height: _height,
                child: Tabs[_currentTab].container,
              ),
            ),
          ),
        ),
      ],
    );
  }

  void goToAddFiles() {
    Navigator.pushNamed(context, "add_file");
    closeDrawer();
  }
}

class ToolBarHome extends StatefulWidget {
  bool isDrawerOpen;
  String title;
  final openDrawer;
  final closeDrawer;

  ToolBarHome(
      {this.title, this.isDrawerOpen, this.openDrawer, this.closeDrawer});

  @override
  _ToolBarHomeState createState() => _ToolBarHomeState();
}

class _ToolBarHomeState extends State<ToolBarHome> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        !widget.isDrawerOpen
            ? IconButton(
                icon: Icon(
                  Icons.menu,
                  color: Colors.white,
                ),
                onPressed: () => {widget.openDrawer()})
            : IconButton(
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                ),
                onPressed: () => {widget.closeDrawer()}),
        Text(
          widget.title,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
        ),
        IconButton(
          icon: Icon(
            Icons.info_rounded,
            color: Colors.white,
          ),
          onPressed: null,
          color: Colors.white,
        )
      ],
    );
  }
}

class DrawerMenuItems extends StatefulWidget {
  final closeDrawer;
  int currentTab;
  String title;
  bool isActive = false;

  DrawerMenuItems(
      {this.closeDrawer, this.currentTab, this.title, this.isActive});

  @override
  _DrawerMenuItemsState createState() => _DrawerMenuItemsState();
}

class _DrawerMenuItemsState extends State<DrawerMenuItems> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    return ClipRRect(
      child: InkWell(
        onTap: () {
          if (widget.currentTab == 5) {
            logout();
            Navigator.pushReplacementNamed(context, "login");
            return;
          }
          widget.closeDrawer();
        },
        // focusColor: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            children: [
              Container(
                width: _width / 1.8,
                color:
                    widget.isActive ? Colors.blueGrey[800] : Colors.transparent,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.title,
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 20,
                    )
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

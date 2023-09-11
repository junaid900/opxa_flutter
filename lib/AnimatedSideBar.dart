import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Property/AddPropertyScreen.dart';
import 'package:qkp/Property/MarketPropertyScreen.dart';
import 'package:qkp/SearchDropdownField.dart';

import 'FavouritesScreen.dart';
import 'Helpers/SessionHelper.dart';
import 'HomeScreen.dart';
import 'MarketScreen.dart';
import 'MenuItemModel.dart';
import 'MyPortfolioScreen.dart';
import 'Packages.dart';
import 'WalletScreen.dart';

class AnimatedSideBar extends StatefulWidget {
  @override
  _AnimatedSideBarState createState() => _AnimatedSideBarState();
}

class _AnimatedSideBarState extends State<AnimatedSideBar> {
  Offset _offset = Offset(0, 0);
  GlobalKey globalKey = GlobalKey();
  List<double> limits = [];
  bool isMenuOpen = false;
  List Tabs = [];
  int _currentIndex = 0;

  checkSession() async {
    if (!await isLogin()) {
      Navigator.pushReplacementNamed(context, "login");
    }
  }

  initTabs() {
    setState(() {
      Tabs = [
        new MenuItem(
            container: MarketWidget(
                openDrawer: () {
                  setState(() {
                    isMenuOpen = true;
                  });
                },
                closeDrawer: () {}),
            name: "Market",
            index: 0,
            isActive: false,
            icon: Icons.home_repair_service_rounded),
        // new MenuItem(
        //     container: AddPropertyScreen(),
        //     name: "Home",
        //     index: 2,
        //     isActive: false,
        //     icon: Icons.home_filled),
        new MenuItem(
            container: MarketPropertyScreen(
              openDrawer: (){
                setState(() {
                  isMenuOpen = true;
                });
              },
              closeDrawer: null,
            ),
            name: "Property",
            index: 3,
            isActive: false,
            icon: Icons.build_outlined),

        new MenuItem(
            container: FavouritesWidget(
                openDrawer: () {
                  setState(() {
                    isMenuOpen = true;
                  });
                },
                closeDrawer: () {}),
            name: "Favourites",
            index: 4,
            isActive: false,
            icon: Icons.favorite),
        new MenuItem(
            container: MyPortfolioWidget(
                openDrawer: () {
                  setState(() {
                    isMenuOpen = true;
                  });
                },
                closeDrawer: () {}),
            name: "My Portfolio",
            index: 5,
            isActive: false,
            icon: Icons.line_weight),
        new MenuItem(
            container: WalletWidget(
                openDrawer: () {
                  setState(() {
                    isMenuOpen = true;
                  });
                },
                closeDrawer: () {}
            ),
            name: "My Wallet",
            index: 6,
            icon: Icons.account_balance_wallet),
        new MenuItem(
            container: Container(),
            name: "Logout",
            index: 7,
            icon: Icons.exit_to_app),
      ];
    });
  }

  @override
  void initState() {
    checkSession();
    //limits = [10, 10, 10, 10, 10, 10, 10, 10];
    initTabs();
    WidgetsBinding.instance.addPostFrameCallback(getPosition);
    super.initState();
  }

  getPosition(duration) {
    RenderBox renderBox = globalKey.currentContext.findRenderObject();
    final position = renderBox.localToGlobal(Offset.zero);
    double start = position.dy - 20;
    double containerLimit = position.dy + renderBox.size.height - 20;
    double step = (containerLimit - start) / 5;
    for (double x = start; x <= containerLimit; x = x + step) {
      limits.add(x);
    }
    setState(() {
      limits = limits;
    });
  }

  getSize(int index) {
    // if(limits.length - 1 > index) {
    //   double size = (_offset.dy > limits[index] &&
    //       _offset.dy < limits[index + 1]
    //       ? 25
    //       : 16);
    //   return size;
    // }else{
    return 16.0;
    // }
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;
    var sideBarSize = _width * 0.75;
    double menuContainerHeight = _height * .50;
    return Container(
      width: _width,
      height: _height,
      decoration: BoxDecoration(
          // gradient: LinearGradient(colors: [
          //   Color.fromRGBO(125, 65, 108, 1.0),
          //   Color.fromRGBO(125, 75, 73, 1.0),
          // ]),
          color: isDarkTheme
              ? darkTheme["primaryBackgroundColor"]
              : lightTheme["primaryBackgroundColor"]),
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              setState(() {
                isMenuOpen = false;
              });
            },
            child: Container(
              padding: EdgeInsets.fromLTRB(16, 0, 0, 0),
              child:
                  Tabs.length > 0 ? Tabs[_currentIndex].container : Container(),
            ),
          ),
          AnimatedPositioned(
            duration: Duration(milliseconds: 500),
            left: isMenuOpen ? 0 : -sideBarSize + 16,
            top: 0,
            curve: Curves.easeOutSine,
            child: SizedBox(
              width: sideBarSize,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (details.localPosition.dx <= sideBarSize) {
                    setState(() {
                      _offset = details.localPosition;
                    });
                  }
                  if (details.localPosition.dx > sideBarSize - 16 &&
                      details.delta.distanceSquared > 2) {
                    setState(() {
                      isMenuOpen = true;
                    });
                  } else {}
                },
                // onHorizontalDragEnd: (details){
                //   // if (details.primaryVelocity < 0)
                //   // setState(() {
                //   //   isMenuOpen = false;
                //   // });
                // },
                onPanEnd: (details) {
                  setState(() {
                    _offset = Offset(0, 0);
                  });
                },
                child: Container(
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      // offset: isMenuOpen?Offset(0, 0):Offset(0.0,0.0), //(x,y)
                      blurRadius: 4.0,
                    )
                  ]),
                  child: Stack(
                    alignment: Alignment.topRight,
                    children: [
                      CustomPaint(
                        size: Size(sideBarSize, _height),
                        painter: DrawerPainter(offset: _offset),
                      ),
                      Container(
                        height: _height,
                        width: sideBarSize,
                        child: SafeArea(
                          child: SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 50, 20, 0),
                                  width: double.infinity,
                                  child: Center(
                                    child: FadeInImage(
                                      width: 120,
                                      height: 120,
                                      placeholder: AssetImage(
                                          "assets/images/profile.png"),
                                      image: NetworkImage(
                                        "https://google.com",
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.fromLTRB(0, 50, 20, 0),
                                  width: double.infinity,
                                  // height: menuContainerHeight,
                                  child: Column(
                                    children: List.generate(
                                        Tabs.length,
                                        (index) => MySideBarButtons(
                                            text: Tabs[index].name,
                                            iconData: Tabs[index].icon,
                                            textSize: getSize(index),
                                            height: (menuContainerHeight) / 6,
                                            onPressed: () {
                                              if (index == Tabs.length - 1) {
                                                logout();
                                                Navigator.pushReplacementNamed(
                                                    context, "login");
                                                return;
                                              }
                                              setState(() {
                                                _currentIndex = index;
                                                isMenuOpen = false;
                                              });
                                            })),
                                  ),
                                ),
                                Divider(
                                  thickness: 1,
                                ),
                                Container(
                                  key: globalKey,
                                  height: _height * 0.20,
                                  padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                                  child: Center(
                                    child: Image.asset(
                                      "assets/images/logo_menu_h.png",
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      AnimatedPositioned(
                        child: Padding(
                          padding: const EdgeInsets.fromLTRB(0, 40, 20, 0),
                          child: Material(
                            color: Colors.transparent,
                            child: IconButton(
                              onPressed: () {
                                setState(() {
                                  isMenuOpen = false;
                                });
                              },
                              iconSize: 30,
                              enableFeedback: true,
                              icon: Icon(
                                Icons.arrow_back_outlined,
                                color: isDarkTheme
                                    ? darkTheme["primaryTextColor"]
                                    : lightTheme["primaryTextColor"],
                              ),
                            ),
                          ),
                        ),
                        duration: Duration(milliseconds: 400),
                        // right: (isMenuOpen)?10:sideBarSize,
                        // bottom: 30,
                      )
                    ],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DrawerPainter extends CustomPainter {
  final Offset offset;

  DrawerPainter({this.offset});

  double getControllPointX(double width) {
    if (offset.dx == 0) {
      return width;
    } else {
      return offset.dx > width ? offset.dx : width + 75;
    }
  }

  @override
  void paint(Canvas canvas, Size size) {
    // var gradient = RadialGradient(
    //   center: const Alignment(0.7, -0.6), // near the top right
    //   radius: 0.2,
    //   colors: [
    //     const Color(0xFFFFFF00), // yellow sun
    //     const Color(0xFF009923), // blue sky
    //   ],
    //   stops: [0.4, 1.0],
    // );

    // Rect myRect = const Offset(1.0, 2.0) & const Size(3.0, 4.0);
    Paint paint = Paint()
      // ..shader = gradient.createShader(myRect)
      ..color = isDarkTheme
          ? darkTheme["primaryBackgroundColor"]
          : lightTheme["primaryBackgroundColor"]
      ..style = PaintingStyle.fill;
    Path path = new Path();
    path.moveTo(-size.width, 0);
    path.lineTo(size.width, 0);
    path.quadraticBezierTo(
        getControllPointX(size.width), offset.dy, size.width, size.height);
    path.lineTo(-size.width, size.height);
    path.close();

    canvas.drawPath(path, paint);

    // TODO: implement paint
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    // TODO: implement shouldRepaint
    // throw UnimplementedError();
    return true;
  }
}

class SideBarMenuItems extends StatefulWidget {
  //final closeDrawer;
  // int currentTab;
  // String title;
  // bool isActive = false;

  //DrawerMenuItems(
  // {this.closeDrawer, this.currentTab, this.title, this.isActive});

  @override
  _SideBarMenuItemsState createState() => _SideBarMenuItemsState();
}

class _SideBarMenuItemsState extends State<SideBarMenuItems> {
  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    return ClipRRect(
      child: InkWell(
        onTap: () {
          // if (widget.currentTab == 5) {
          //  // logout();
          //   Navigator.pushReplacementNamed(context, "login");
          //   return;
          // }
          // widget.closeDrawer();
        },
        // focusColor: Colors.grey[900],
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            children: [
              Container(
                width: _width / 1.8,
                color: isDarkTheme
                    ? darkTheme["primaryColor"]
                    : lightTheme["primaryColor"],
                //  widget.isActive ? Colors.blueGrey[800] : Colors.transparent,
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      //widget.title,
                      "Title",
                      style: TextStyle(fontSize: 17, color: Colors.white),
                    ),
                    SizedBox(
                      width: 40,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: isDarkTheme
                          ? darkTheme["primaryTextColor"]
                          : lightTheme["primaryTextColor"],
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

class MySideBarButtons extends StatelessWidget {
  String text;
  double textSize;
  double height;
  IconData iconData;
  final onPressed;

  MySideBarButtons(
      {this.text, this.textSize, this.height, this.iconData, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed,
      height: height,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: [
          Icon(
            iconData,
            color: isDarkTheme
                ? darkTheme["primaryTextColor"]
                : lightTheme["primaryTextColor"],
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: TextStyle(
                color: isDarkTheme
                    ? darkTheme["primaryTextColor"]
                    : lightTheme["primaryTextColor"],
                fontSize: textSize),
          ),
        ],
      ),
    );
  }
}

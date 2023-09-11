import 'package:flutter/material.dart';

import 'AnimatedSideBar.dart';
import 'FavouritesScreen.dart';
import 'Helpers/SessionHelper.dart';
import 'HomeScreen.dart';
import 'MarketScreen.dart';
import 'MenuItemModel.dart';
import 'MyPortfolioScreen.dart';
import 'WalletScreen.dart';

class FlutterDrawerWidget extends StatefulWidget {
  @override
  _FlutterDrawerWidgetState createState() => _FlutterDrawerWidgetState();
}

class _FlutterDrawerWidgetState extends State<FlutterDrawerWidget> {

  List Tabs = [];
  bool isMenuOpen = false;
  initTabs() {
    setState(() {
      Tabs = [
        new MenuItem(
            container: HomeWidget(openDrawer: () {
              setState(() {
                isMenuOpen = true;
              });
            }, closeDrawer: () {}),
            name: "Home",
            index: 0,
            isActive: false,
            icon: Icons.home_filled),
        new MenuItem(
            container: MarketWidget(openDrawer: () {
              setState(() {
                isMenuOpen = true;
              });
            }, closeDrawer: () {}),
            name: "Market",
            index: 1,
            isActive: false,
            icon: Icons.home_repair_service_rounded),
        new MenuItem(
            container: FavouritesWidget(openDrawer: () {
              setState(() {
                isMenuOpen = true;
              });
            }, closeDrawer: () {}),
            name: "Favourites",
            index: 2,
            isActive: false,
            icon: Icons.favorite),
        new MenuItem(
            container: MyPortfolioWidget(openDrawer: () {
              setState(() {
                isMenuOpen = true;
              });
            }, closeDrawer: () {}),
            name: "My Portfolio",
            index: 3,
            isActive: false,
            icon: Icons.line_weight),
        new MenuItem(
            container: WalletWidget(

            ),
            name: "My Wallet",
            index: 4,
            icon: Icons.account_balance_wallet),
        new MenuItem(
            container: Container(),
            name: "Logout",
            index: 5,
            icon: Icons.exit_to_app)
      ];
    });
  }

  @override
  void initState() {
    initTabs();
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.black87,
          child: ListView(
            children: List.generate(
                Tabs.length,
                    (index) => MySideBarButtons(
                    text: Tabs[index].name,
                    iconData: Tabs[index].icon,
                    textSize: 16,
                    height: 40,
                    onPressed: () {
                      if(index == 5){
                         logout();
                        Navigator.pushReplacementNamed(context, "login");
                        return;
                      }
                      setState(() {
                        // _currentIndex = index;
                        isMenuOpen = false;

                      });
                    })),
          ),
        ),
      ),
    );
  }
}

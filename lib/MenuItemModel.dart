import 'package:flutter/cupertino.dart';

class MenuItem {
  int index;
  String name;
  Widget container;
  bool isActive;
  IconData icon;
  MenuItem({this.index, this.name, this.container,this.isActive,this.icon});

}

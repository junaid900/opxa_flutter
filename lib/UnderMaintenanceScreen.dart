import 'package:flutter/material.dart';
import 'package:qkp/Network/constant.dart';

class UnderMaintenanceWidget extends StatefulWidget {
  @override
  _UnderMaintenanceWidgetState createState() => _UnderMaintenanceWidgetState();
}

class _UnderMaintenanceWidgetState extends State<UnderMaintenanceWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: darkTheme["primaryBackgroundColor"],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/settings.png",
              width: getWidth(context) * .60,
            ),
            SizedBox(
              height: 10,
            ),
            Text(
              "Site is under maintenance please comeback after sometime",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            )
          ],
        ),
      ),
    );
  }
}

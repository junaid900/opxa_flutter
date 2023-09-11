import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qkp/Model/Property.dart';
import 'package:qkp/Network/constant.dart';

class PropertyMoreFeatures extends StatefulWidget {
  @override
  _PropertyMoreFeaturesState createState() => _PropertyMoreFeaturesState();
}

class _PropertyMoreFeaturesState extends State<PropertyMoreFeatures> {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  List propertyList;

  @override
  Widget build(BuildContext context) {
    FocusNode focusNode = FocusNode();
    bool isFocused = false;
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;
    Map arguments = ModalRoute.of(context).settings.arguments;
    print(arguments);
    var length = arguments != null ? arguments.values.length : 0;
    print('length: ' + length.toString());

    return Scaffold(
      appBar: AppBar(
        title: Text("More Features"),
      ),
      body: Container(
        width: _width,
        height: _height,
        color: isDarkTheme
            ? darkTheme["primaryBackgroundColor"]
            : lightTheme["primaryBackgroundColor"],
        padding: EdgeInsets.all(10),
        child: Column(
          children:
              List.generate(arguments != null ? arguments.length : 0, (i) {
            var subList = arguments[arguments.keys.elementAt(i)];
            return Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0)),
              color: Colors.transparent,
              child: Wrap(
                children: [
                  Container(
                    padding: EdgeInsets.fromLTRB(20, 15, 15, 15),
                    decoration: new BoxDecoration(
                        color: darkTheme['secondaryColor'],
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(10.0),
                            topRight: const Radius.circular(10.0))),
                    child: Row(children: [
                      Text(
                        arguments.keys.elementAt(i),
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w700),
                      ),
                    ]),
                  ),
                  Container(
                      padding: EdgeInsets.fromLTRB(20, 5, 15, 15),
                      decoration: new BoxDecoration(
                          color: darkTheme['cardBackground'],
                          borderRadius: new BorderRadius.only(
                              bottomLeft: const Radius.circular(10.0),
                              bottomRight: const Radius.circular(10.0))),
                      child: Column(
                        children: List.generate(
                          subList != null ? subList.length : 0,
                          (index) => Container(
                            padding: EdgeInsets.fromLTRB(0, 14, 0, 14),
                            decoration: new BoxDecoration(
                              border: Border(
                              bottom: BorderSide( //                   <--- left side
                                color: Color.fromRGBO(83, 97, 129, 1.0),
                                width: 2.0,
                              ),
                            ), ),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    subList[subList.keys.elementAt(index)]
                                            ['name'] +
                                        ' :',
                                    style: TextStyle(
                                        color: darkTheme['primaryTextColor']),
                                  ),
                                  Text(
                                    subList[subList.keys.elementAt(index)]
                                        ['value'],
                                    style: TextStyle(
                                        color: darkTheme['primaryTextColor'],
                                        fontWeight: FontWeight.bold),
                                  ),

                                ]),
                          ),
                        ),
                      )
                      ),
                ],
              ),
            );

            /* Stack(
              children: [
                Container(
                  margin: const EdgeInsets.fromLTRB(0, 8.0, 0, 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    // color: Colors.green,
                    border: Border.all(
                      width: 1.0,
                      color: darkTheme['secondaryColor'],
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: List.generate(
                        subList!= null?subList.length:0,
                        (index) => Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                subList[subList.keys.elementAt(index)]['name'] +
                                    ' :',
                                style: TextStyle(
                                    color: darkTheme['primaryTextColor']),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                subList[subList.keys.elementAt(index)]['value'],
                                style: TextStyle(
                                    color: darkTheme['primaryTextColor'],
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                    color: darkTheme['secondaryColor'],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        arguments.keys.elementAt(i),
                        style: TextStyle(color: darkTheme['primaryColor']),
                      ),
                    ),
                  ),
                ),
              ],
            ); */
          }),
        ),
      ),
    );
  }
}

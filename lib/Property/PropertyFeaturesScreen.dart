import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qkp/MaterialInputField.dart';
import 'package:qkp/Model/PropertyFeature.dart';
import 'package:qkp/Network/constant.dart';

class PropertyFeatureWidget extends StatefulWidget {
  @override
  _PropertyFeatureWidgetState createState() => _PropertyFeatureWidgetState();
}

class _PropertyFeatureWidgetState extends State<PropertyFeatureWidget> {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  List<PropertyFeatures> featuresList = [];
  var cont;
  Map featuresData = new Map();


  //bool isOpen = true;

  getPageData() async {
    if (cont == null) {
      await Future.delayed(Duration(milliseconds: 700));
      getPageData();
    }
    var arguments = ModalRoute.of(cont).settings.arguments;
    featuresList.clear();
    setState(() {
      featuresList.addAll(arguments);
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getPageData();
  }

  void addFeatures(data,PropertyFeatures propertyFeatures) {
    // if(featuresData[propertyFeatures.featureName] == null) {
    //   featuresData[propertyFeatures.featureName][0] = "" ;
    // }
    if (featuresData[propertyFeatures.featureName] == null) {
      featuresData[propertyFeatures.featureName] = {data["key"]: data};
      // featuresData[propertyFeatures.featureName][data["key"]] = data;
    } else
      if(featuresData[propertyFeatures.featureName][data["key"]] == null){
        featuresData[propertyFeatures.featureName][data["key"]] =  data;
      }else
      featuresData[propertyFeatures.featureName].update(data["key"], (value) => data);

    print(featuresData);
  }

  @override
  Widget build(BuildContext context) {
    cont = context;
    return Scaffold(
        appBar: AppBar(
          title: Text("Add Features"),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop(featuresData);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                          child: Text(
                        "Save",
                        style: TextStyle(fontSize: 17, color: Colors.white),
                      )),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: featuresList.length>0?ExpansionPanelList(
            expansionCallback: (index, isExpanded) {
              setState(() {
                featuresList[index].isOpen = !featuresList[index].isOpen;
              });
            },
            animationDuration: Duration(milliseconds: 1000),
            children: List.generate(featuresList.length, (index) {
              return ExpansionPanel(
                headerBuilder: (BuildContext context, bool isOpen) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(
                          featuresList[index].featureName,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  );
                },
                body: PropertyFeatureItemWidget(
                  propertyFeatures: featuresList[index],
                  addFeatures: (data,PropertyFeatures propertyFeatures) => addFeatures(data,propertyFeatures),
                ),
                isExpanded: featuresList[index].isOpen,
              );
            }),
          ):SizedBox(),
        ));
  }
}

class PropertyFeatureItemWidget extends StatefulWidget {
  PropertyFeatures propertyFeatures;
  Function addFeatures;

  PropertyFeatureItemWidget({this.propertyFeatures, this.addFeatures});

  @override
  _PropertyFeatureItemWidgetState createState() =>
      _PropertyFeatureItemWidgetState();
}

class _PropertyFeatureItemWidgetState extends State<PropertyFeatureItemWidget> {
  Map dropdown = Map();
  Map<dynamic, bool> checkBox = Map();

  Widget getInput(Features features, i, PropertyFeatures propertyFeatures) {
    if (features.type == "Input") {
      return Container(
        width: 150,
        height: 40,
        margin: EdgeInsets.fromLTRB(0, 3, 6, 0),
        child: TextField(
          onChanged: (val) {
            widget.addFeatures({
              "key": features.itemId,
              "value": val,
              "name": features.name,
              "feature_id": features.id,
            },propertyFeatures);
          },
          decoration: InputDecoration(
            // border: OutlineInputBorder(),
            hintText: "Enter " + features.name,
          ),
          style: TextStyle(
            fontSize: 14,
          ),
        ),
      );
    } else if (features.type == "Check") {
      if (checkBox[i] == null) checkBox[i] = false;

      return Container(
        // color: Colors.black,
        width: 150,
        height: 40,
        margin: EdgeInsets.fromLTRB(0, 3, 6, 0),
        child: Theme(
          data: ThemeData(unselectedWidgetColor: Colors.grey),
          child: Checkbox(
            onChanged: (bool value) {
              if (value) {
                // print("true");
              }
              setState(() {
                checkBox[i] = value;
              });
              widget.addFeatures({
                "key": features.itemId,
                "value": value ? "Yes" : "No",
                "name": features.name,
                "feature_id": features.id,
              },propertyFeatures);
            },
            value: checkBox[i],

          ),
        ),
      );
    } else if (features.type == "Dropdown") {
      setState(() {});
      // print("drop == >"+dropdown[i]);
      return Container(
        width: 150,
        height: 40,
        margin: EdgeInsets.fromLTRB(0, 3, 6, 0),
        child: DropdownButton<String>(
          isExpanded: true,
          icon: Icon(
            Icons.arrow_drop_down,
            size: 24,
          ),
          hint: Text("Select Option"),
          value: dropdown[i],
          items: features.dropDownData.map((DropDownData val) {
            return new DropdownMenuItem<String>(
              value: val.name,
              child: new Text(val.name),
            );
          }).toList(),
          onChanged: (_) {
            setState(() {
              dropdown[i] = _;
            });

            widget.addFeatures({
              "key": features.itemId,
              "value": _,
              "name": features.name,
              "feature_id": features.id,
            },propertyFeatures);
            // filter();
          },
        ),
      );
    } else {
      return SizedBox();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(3, 10, 3, 10),
      child: Column(
        children:
            List.generate(widget.propertyFeatures.features.length, (index) {
          // print(widget.propertyFeatures.features[index].type);
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                  child: Text(widget.propertyFeatures.features[index].name)),
              getInput(widget.propertyFeatures.features[index], index,
                  widget.propertyFeatures),
            ],
          );
        }),
      ),
    );
  }
}

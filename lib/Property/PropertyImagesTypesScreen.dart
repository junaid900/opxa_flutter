import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Model/Property.dart';
import 'package:qkp/Model/TypeImages.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';

class PropertyImagesTypeWidget extends StatefulWidget {
  @override
  _PropertyImagesTypeWidgetState createState() =>
      _PropertyImagesTypeWidgetState();
}

class _PropertyImagesTypeWidgetState extends State<PropertyImagesTypeWidget>
    with TickerProviderStateMixin {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  TabController controller;
  Property property;
  List<TypeImages> typeImagesList = [];
  bool isLoading = false;

  getPageData() async {

    var request = {
      "property_id": property.id,
    };
    setState(() {
      isLoading = true;
    });
    var res = await getTypeImagesService(request);
    setState(() {
      isLoading = false;
    });
    // print("res" + res.toString());
    var typeImagesListMap = res["list"];
    for (int i = 0; i < typeImagesListMap.length; i++) {
      typeImagesList.add(TypeImages.fromJson(typeImagesListMap[i]));
    }
    setState(() {
      typeImagesList = typeImagesList;
    });
    setState(() {
      controller = TabController(length: typeImagesList.length, vsync: this);
    });
  }

  @override
  void initState() {
    // getPageData();
    controller = TabController(length: 0, vsync: this);
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if(property == null){
      var args = ModalRoute.of(context).settings.arguments;
      setState(() {
        property = args;
      });
      getPageData();
    }
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: controller,
          tabs: List.generate(
              typeImagesList.length,
              (index) => Tab(
                    text: typeImagesList[index].imageType,
                  )),
        ),
      ),
      body: Stack(
        children: [
          TabBarView(
            controller: controller,
            children: List.generate(
                typeImagesList.length,
                (index) => Container(
                      width: getWidth(context),
                      height: getHeight(context),
                      child: ListView(
                        children: List.generate(
                            typeImagesList[index].images.length,
                            (imageIndex) => FadeInImage(
                              placeholder: AssetImage(
                                "assets/images/house_loading_placeholder.gif"
                              ),
                              image: NetworkImage(
                                  url+ typeImagesList[index].images[imageIndex].image),
                            )),
                      ),
                    )),
          ),
          if(isLoading)
            AppLoadingScreen(backgroundOpactity: .8,)
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:qkp/Model/PropertyNews.dart';
import 'package:qkp/Network/constant.dart';

class PropertyNewsFeedDetails extends StatefulWidget {
  @override
  _PropertyNewsFeedDetailsState createState() =>
      _PropertyNewsFeedDetailsState();
}

class _PropertyNewsFeedDetailsState extends State<PropertyNewsFeedDetails> {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    var arguments = ModalRoute.of(context).settings.arguments;
    PropertyNews propertyNews = arguments;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            FadeInImage(
              placeholder:
                  AssetImage("assets/images/house_loading_placeholder.gif"),
              image: NetworkImage(propertyNews.image),
              fit: BoxFit.cover,
              height: getHeight(context)*.24,
              width: getWidth(context),
            ),
            Text(
              propertyNews.title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Html(data: propertyNews.details),
          ],
        ),
      ),
    );
  }
}

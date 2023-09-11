import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:qkp/Network/constant.dart';

class WizardIntroScreenWidget extends StatefulWidget {
  @override
  _WizardIntroScreenWidgetState createState() =>
      _WizardIntroScreenWidgetState();
}

class _WizardIntroScreenWidgetState extends State<WizardIntroScreenWidget> {
  PageController _pageController = PageController();
  double currentPage = 0;
  int selectedindex = 0;

  Widget _indicator(bool isActive) {
    return Container(
      height: 10,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 150),
        margin: EdgeInsets.symmetric(horizontal: 4.0),
        height: isActive ? 10 : 8.0,
        width: isActive ? 12 : 8.0,
        decoration: BoxDecoration(
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Color(0XFF2FB7B2).withOpacity(0.72),
                    blurRadius: 4.0,
                    spreadRadius: 1.0,
                    offset: Offset(
                      0.0,
                      0.0,
                    ),
                  )
                : BoxShadow(
                    color: Colors.transparent,
                  )
          ],
          shape: BoxShape.circle,
          color: isActive ? Color(0XFF6BC4C9) : Color(0XFFEAEAEA),
        ),
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < 9; i++) {
      list.add(i == selectedindex ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  @override
  void initState() {
    _pageController.addListener(() {
      setState(() {
        currentPage = _pageController.page;
      });
      print(currentPage);
    });
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(),
      body: Stack(
        children: [
          PageView(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  selectedindex = index;
                });
              },
              children: [
                for (int i = 0; i < 9; i++)
                  Container(
                    width: getWidth(context),
                    child: InteractiveViewer(
                      minScale: .3,
                      //  panEnabled: false, // Set it to false
                      // boundaryMargin: EdgeInsets.all(100),
                      // minScale: 10.5,
                      // maxScale: 2,
                      // tag: widget.xwpropertyList.id,
                      child: PhotoView(
                        imageProvider: AssetImage(
                          'assets/images/intro/opxa${i}.png',
                        ),

                        // width: 200,
                        //height: 200,
                        // fit: BoxFit.cover
                      ),
                    ),
                  ),
              ]),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 0, 70),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Row(
                children: _buildPageIndicator(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
            child: FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Container(
                  child: Text(
                    "Skip",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                )),
          ),
          if (selectedindex == 8)
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 0, 0, 30),
                child: FlatButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    color: Colors.blue.withOpacity(.4),
                    child: Container(
                      child: Text(
                        "Finish",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
            )
        ],
      ),
    );
  }
}

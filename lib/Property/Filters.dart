import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/CircularInputField.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/Constraint/picker_widget.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/MaterialInputField.dart';
import 'package:qkp/Model/Property.dart';
import 'package:qkp/Model/PropertyCity.dart';
import 'package:qkp/Model/PropertySector.dart';
import 'package:qkp/Model/PropertyType.dart';
import 'package:qkp/Model/PropertyUnit.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'package:qkp/Network/network.dart';
import 'package:intl/intl.dart';
import '../Constraint/globals.dart' as global;
import '../main.dart';

class Filters extends StatefulWidget {
  @override
  _FiltersState createState() => _FiltersState();
}

class _FiltersState extends State<Filters> with RouteAware{
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  String propertyName;
  List<PropertyType> propertyTypeList = [];
  List<Subtypes> selectedSubTypeList = [];
  List<PropertySociety> propertySocietyList = [];
  List<Towns> selectedTownsList = [];
  PropertySociety selectedPropertySociety;
  List<PropertyCity> propertyCityList = [];
  List<Sectors> selectedSectorsList = [];
  PropertyCity selectedCity;
  Sectors selectedSectors;
  Towns selectedTown;
  int selectedSubType = 0;
  String propertySubTypeId;

  String propertySubType;
  bool bedrooms = false;
  bool bathroom = false;
  bool number = false;
  int selected_bathroom = 0;
  int selected_bedrooms = 0;
  String numberField = '';
  double startPrice;
  double endPrice;
  double startpropertyNumber;
  double endpropertyNumber;
  double startpropertyRange;
  double endpropertyRange;
  String fixStartPrice;
  String fixEndPrice;
  String fixStartRange;
  String fixEndRange;
  String fixStartPropertyNumber;
  String fixEndPropertyNumber;
  String startArea;
  String endArea;
  String selectedCityId;
  String selectedTownId;
  String selectedSocietyId;
  String selectedSectorId;
  var clickme;
  String selectedUnit;
  String selectedUnitName;
  List<PropertyUnit> unitsList = [];

  User user;
  List<Property> propertyList = [];
  getSocietyByCity() async {
    var request = {"city": selectedCity.id};
    ProgressDialog progressDialog =
    showProgressDialog(ProgressDialog(context, isDismissible: false));
    var res = await postRequest("/get_society_by_city", request);
    progressDialog.hide();
    if (res != null) {
      var data = res["list"];
      var mapSocietyList = data["society"];
      propertySocietyList.clear();
      for (int i = 0; i < mapSocietyList.length; i++) {
        propertySocietyList.add(PropertySociety.fromJson(mapSocietyList[i]));
      }
      setState(() {
        propertySocietyList = propertySocietyList;
      });
    }
  }
  getPageData() async {
    var res = await getPropertyAddPageData();
    var data = res["list"];
    var typeMapList = data["types"];
    var mapSocietyList = data["society"];
    var citiesMapList = data["cities"];
    var propertyUnitMap = data["units"];

    for (int i = 0; i < citiesMapList.length; i++) {
      propertyCityList.add(PropertyCity.fromJson(citiesMapList[i]));
    }
    for (int i = 0; i < propertyUnitMap.length; i++) {
      unitsList.add(PropertyUnit.fromJson(propertyUnitMap[i]));
    }

    for (int i = 0; i < typeMapList.length; i++) {
      propertyTypeList.add(PropertyType.fromJson(typeMapList[i]));
    }

    for (int i = 0; i < mapSocietyList.length; i++) {
      propertySocietyList.add(PropertySociety.fromJson(mapSocietyList[i]));
    }

    user = await getUser();

    setState(() {
      user = user;
      propertyCityList = propertyCityList;
      propertyTypeList = propertyTypeList;
      propertySocietyList = propertySocietyList;
    });
    // subTypeFilter(propertyTypeList[0].id);
  }

  filterTowns(PropertyCity _propertyCity) {
    selectedCityId = _propertyCity.id;

    int filteredItems = 0;
    selectedTownsList.clear();
    for (int i = 0; i < propertyCityList.length; i++) {
      if (propertyCityList[i].id == _propertyCity.id) {
        if (propertyCityList[i].towns.length > 0) {
          filteredItems++;
        }
        selectedTownsList.addAll(propertyCityList[i].towns);
      }
    }
    if (filteredItems > 0) {
      setState(() {
        selectedTownsList = selectedTownsList;
      });
    } else {
      setState(() {
        selectedTownsList.clear();
      });
    }
  }

  void filterPropertySectors(PropertySociety propertySociety) {
    int filteredItems = 0;
    selectedSectorsList.clear();
    for (int i = 0; i < propertySocietyList.length; i++) {
      if (propertySocietyList[i].id == propertySociety.id) {
        if (propertySocietyList[i].sectors.length > 0) {
          filteredItems++;
        }
        selectedSectorsList.addAll(propertySocietyList[i].sectors);
      }
    }
    if (filteredItems > 0) {
      setState(() {
        selectedSectorsList = selectedSectorsList;
      });
    } else {
      setState(() {
        selectedSectorsList.clear();
      });
    }
  }

  subTypeFilter(type) {
    setState(() {
      selectedSubType = int.tryParse(type);
      print('selectedSubType:');
      print(selectedSubType);

    });

    int filteredItems = 0;
    selectedSubTypeList.clear();
    for (int i = 0; i < propertyTypeList.length; i++) {
      if (propertyTypeList[i].id == type) {
        if (propertyTypeList[i].subtypes.length > 0) {
          filteredItems++;
        }
        print(propertyTypeList[i].toJson());
        selectedSubTypeList.addAll(propertyTypeList[i].subtypes);
      }
    }
    if (filteredItems > 0) {
      setState(() {
        selectedSubTypeList = selectedSubTypeList;
      });
    } else {
      setState(() {
        selectedSubTypeList.clear();
      });
    }
  }

  search() async {

    if(fixStartPrice != null && fixStartPrice != ''){
      startPrice = double.tryParse(fixStartPrice);
    }else{
      startPrice = _currentPriceRangeValues.start;
    }
    if(fixEndPrice != null && fixEndPrice != ''){
      endPrice = double.tryParse(fixEndPrice);
    }else{
      endPrice = _currentPriceRangeValues.end;
    }

    if(fixStartPropertyNumber != null && fixStartPropertyNumber != ''){
      startpropertyNumber = double.tryParse(fixStartPropertyNumber);
    }else{
      startpropertyNumber = _currentPropertyNumber.start;
    }
    if(fixEndPropertyNumber != null && fixEndPropertyNumber != ''){
      endpropertyNumber = double.tryParse(fixEndPropertyNumber);
    }else{
      endpropertyNumber = _currentPropertyNumber.end;
    }

    if(fixStartRange != null && fixStartRange != ''){
      startpropertyRange = double.tryParse(fixStartRange);
    }else{
      startpropertyRange = _currentAreaRangeValues.start;
    }
    if(fixEndRange != null && fixEndRange != ''){
      endpropertyRange = double.tryParse(fixEndRange);
    }else{
      endpropertyRange = _currentAreaRangeValues.end;
    }




    var request = {
      "user_id": user.id,
      "city_id": selectedCityId,
      "town_id": selectedTownId,
      "society_id": selectedSocietyId,
      "sector_id": selectedSectorId,
      "type_id": selectedSubType,
      "sub_type_id": propertySubTypeId,
      "number_field": numberField,
      "bed_rooms": selected_bedrooms,
      "bath_rooms": selected_bathroom,
      "start_price": startPrice,
      "end_price": endPrice,
      "start_rang": startpropertyRange,
      "end_rang": endpropertyRange,
      // "page": 1,
      "start_area": startpropertyNumber,
      "end_area": endpropertyNumber,
      'unit': selectedUnit,
      'property_name': propertyName,
    };
    print(request.toString());
    ProgressDialog progressDialog = new ProgressDialog(context);
    progressDialog.update(message: "Filtering Properties");
    progressDialog.show();
    var res = await propertyFilter(request);
    progressDialog.hide();
    propertyList.clear();
    if (res == null) {
      showToast("no property found");
      return;
    }
    if (res["ResponseCode"] == 1) {
      var propertyMapList = res["list"];
      for (int i = 0; i < propertyMapList.length; i++) {
        Property asset = new Property();
        await asset.fromJson(propertyMapList[i]);
        setState(() {
          propertyList.add(asset);
        });
      }
      //setState(() {
      propertyList = propertyList;
      print(propertyList.length);
      Navigator.pop(context, propertyList);
      // });
    } else {
      showToast("no property found");
    }
  }

  resetAll() {
    setState(() {
      numberField = '';
      startPrice = null;
      endPrice = null;
      startArea = null;
      endArea = null;
      selectedCityId = null;
      selectedTownId = null;
      selectedSocietyId = null;
      selectedSectorId = null;
      selectedUnit = null;
      selectedUnitName = '';
      startpropertyNumber = null;
      endpropertyNumber = null;
      startpropertyRange = null;
      endpropertyRange =  null;
      fixStartPrice = null;
      fixEndPrice = null;
      fixStartPropertyNumber = null;
      endpropertyNumber = null;
      startpropertyRange = null;
      endpropertyRange  =null;

    });
  }

  @override
  void initState() {
    this.getPageData();

    // TODO: implement initState
    super.initState();
  }
  void FCMMesseging(message) {
    onNotificationReceive(context,data: {"message":message});
  }
  @override
  void didChangeDependencies() {
    routeObserver.subscribe(this, ModalRoute.of(context));
    fcmInit();
    super.didChangeDependencies();
  }
  @override
  void didPopNext() {
    fcmInit();
  }

  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }


  RangeValues _currentPriceRangeValues = const RangeValues(40, 6000000000);
  RangeValues _currentPropertyNumber = const RangeValues(1, 1000);
  RangeValues _currentAreaRangeValues = const RangeValues(0, 5000);

  @override
  Widget build(BuildContext context) {
    var formatter = NumberFormat.compact(locale: 'eu');
    return Scaffold(
      appBar: AppBar(
        title: Text('Filters'),
      ),
      body: Container(
        height: getHeight(context),
        width: getWidth(context),
        color: isDarkTheme
            ? darkTheme["primaryBackgroundColor"]
            : lightTheme["primaryBackgroundColor"],
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Property Name',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 6,),
                    CircularInputField(
                      onChanged: (val){
                        propertyName = val;
                      },
                      label: "Property Name",
                    ),
                    SizedBox(height: 10,),
                    Text(
                      'Select City',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      height: 50,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.white,
                      ),
                      child: DropdownSearch<PropertyCity>(
                        mode: Mode.DIALOG,
                        items: propertyCityList,
                        hint: "Select City",
                        onChanged: (_) {
                          setState(() {
                            selectedCity = _;
                          });
                          filterTowns(_);
                          getSocietyByCity();
                        },
                        dropdownSearchDecoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 8, 10),
                            fillColor: Colors.red),
                        showSearchBox: true,
                        popupTitle: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: darkTheme["primaryBackgroundColor"],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'City',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Select Town',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      height: 50,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.white,
                      ),
                      child: DropdownSearch<Towns>(
                        mode: Mode.DIALOG,
                        items: selectedTownsList,
                        // popupBackgroundColor: Colors.grey,
                        hint: "Select town",
                        onChanged: (_) {
                          // print("=>"+_.id);
                          setState(() {
                            selectedTownId = _.id;
                            selectedTown = _;
                          });
                        },
                        // selectedItem: selectedCity,
                        showSearchBox: true,
                        dropdownSearchDecoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.fromLTRB(15, 10, 8, 10),
                            fillColor: Colors.red),
                        popupTitle: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color: darkTheme["primaryBackgroundColor"],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'Town',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        popupShape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(24),
                            topRight: Radius.circular(24),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Select Society',
                      style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      height: 50,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: DropdownSearch<PropertySociety>(
                          mode: Mode.DIALOG,
                          items: propertySocietyList,

                          // popupBackgroundColor: Colors.grey,
                          hint: "Select Society",
                          onChanged: (_) {
                            // print("=>"+_.id);
                            setState(() {
                              selectedSocietyId = _.id;
                              selectedPropertySociety = _;
                            });
                            filterPropertySectors(_);
                          },

                          // selectedItem: selectedCity,
                          showSearchBox: true,
                          searchBoxDecoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                            fillColor: Colors.red,
                            hoverColor: Colors.red,
                            focusColor: Colors.red,
                            labelText: "Search a society",
                          ),
                          popupTitle: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: darkTheme["primaryBackgroundColor"],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Society',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Select Sector',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                      height: 50,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(60.0),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: DropdownSearch<Sectors>(
                          mode: Mode.DIALOG,
                          items: selectedSectorsList,

                          // popupBackgroundColor: Colors.grey,
                          hint: "Select Sector",
                          onChanged: (_) {
                            // print("=>"+_.id);
                            setState(() {
                              selectedSectorId = _.id;
                              selectedSectors = _;
                            });
                            // filterPropertySectors(_);
                          },

                          // selectedItem: selectedCity,
                          showSearchBox: true,
                          searchBoxDecoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                            fillColor: Colors.red,
                            hoverColor: Colors.red,
                            focusColor: Colors.red,
                            labelText: "Search a sectors",
                          ),
                          popupTitle: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              color: darkTheme["primaryBackgroundColor"],
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                topRight: Radius.circular(10),
                              ),
                            ),
                            child: Center(
                              child: Text(
                                'Sector',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          popupShape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(24),
                              topRight: Radius.circular(24),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        height: 50,
                        width: getWidth(context),
                        child: ListView(
                            shrinkWrap: false,
                            scrollDirection: Axis.horizontal,
                            children:
                            List.generate(propertyTypeList.length, (index) {
                              print(index);
                              return Row(
                                children: [
                                  FlatButton(
                                    // padding: EdgeInsets.all(30.0),
                                    color: int.tryParse(
                                        propertyTypeList[index].id) ==
                                        selectedSubType
                                        ? darkTheme['secondaryColor']
                                        : Colors.transparent,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                          color: int.tryParse(
                                              propertyTypeList[index]
                                                  .id) ==
                                              selectedSubType
                                              ? Colors.transparent
                                              : Colors.white,
                                          width: 1,
                                          style: BorderStyle.solid),
                                      borderRadius: BorderRadius.circular(22.0),
                                    ),

                                    child: Text(
                                      propertyTypeList[index].typeName,
                                      style: TextStyle(
                                          color: int.tryParse(
                                              propertyTypeList[index]
                                                  .id) ==
                                              selectedSubType
                                              ? darkTheme["primaryWhite"]
                                              : darkTheme["primaryWhite"]),
                                    ),
                                    onPressed: () {
                                      subTypeFilter(propertyTypeList[index].id);
                                      setState(() {
                                        bedrooms = false;
                                        bathroom = false;
                                      });
                                      print('Button pressed');
                                    },
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                ],
                              );
                            }))),
                    Container(
                        margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                        height: 100,
                        width: getWidth(context),
                        child: ListView(
                            shrinkWrap: false,
                            scrollDirection: Axis.horizontal,
                            children:
                            List.generate(selectedSubTypeList.length, (index) {
                              return selectedSubTypeList.length > 0
                                  ? Container(
                                decoration: new BoxDecoration(
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                    color: selectedSubTypeList[index]
                                        .subTypeName ==
                                        propertySubType
                                        ? darkTheme['secondaryColor']
                                        : darkTheme["cardBackground"]
                                  //  darkTheme["cardBackground"],
                                ),
                                width: getWidth(context) / 3,
                                height: 100,
                                margin: EdgeInsets.fromLTRB(5, 0, 5, 0),
                                // padding: EdgeInsets.fromLTRB(8, 10, 15, 10),
                                child: InkWell(
                                  onTap: () {
                                    setState(() {
                                      bedrooms = false;
                                      bathroom = false;
                                      number = true;
                                      propertySubTypeId =
                                          selectedSubTypeList[index].id;
                                      propertySubType =
                                          selectedSubTypeList[index]
                                              .subTypeName;
                                    });
                                    if (propertySubType == 'house' ||
                                        propertySubType == 'appartment' ||
                                        propertySubType == 'Flat') {
                                      bedrooms = true;
                                      bathroom = true;
                                    }
                                  },
                                  child: Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        selectedSubTypeList[index]
                                            .subTypeName ==
                                            propertySubType
                                            ? 'assets/images/home_white.png'
                                            : 'assets/images/home.png',
                                      ),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                        selectedSubTypeList[index]
                                            .subTypeName,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 12),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                                  : Container();
                            }))),
                    Visibility(
                      visible: bedrooms,
                      child: Row(
                        children: [
                          Text(
                            'Bedrooms',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: bedrooms,
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          height: 50,
                          width: getWidth(context),
                          child: ListView(
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              children: List.generate(10, (index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      elevation: 0,
                                      primary: index == selected_bedrooms
                                          ? darkTheme['secondaryColor']
                                          : darkTheme['cardBackground'],
                                    ),
                                    child: Container(
                                      // width: 15,
                                      // height: 20,
                                      alignment: Alignment.center,
                                      decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                      child: Text(
                                        index.toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: index == selected_bedrooms
                                              ? darkTheme["primaryWhite"]
                                              : darkTheme[
                                          "primaryAccientColor"],
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selected_bedrooms = index;
                                      });
                                    },
                                  ),
                                );
                              }))),
                    ),
                    Visibility(
                      visible: bathroom,
                      child: Row(
                        children: [
                          Text(
                            'Bathrooms',
                            style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: bathroom,
                      child: Container(
                          margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          height: 50,
                          width: getWidth(context),
                          child: ListView(
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              children: List.generate(10, (index) {
                                return Padding(
                                  padding: EdgeInsets.fromLTRB(0, 2, 0, 2),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      shape: CircleBorder(),
                                      primary: index == selected_bathroom
                                          ? darkTheme['secondaryColor']
                                          : darkTheme['cardBackground'],
                                      elevation: 0,
                                    ),
                                    child: Container(
                                      // width: 15,
                                      // height: 20,
                                      alignment: Alignment.center,
                                      decoration:
                                      BoxDecoration(shape: BoxShape.circle),
                                      child: Text(
                                        index.toString(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: index == selected_bathroom
                                              ? darkTheme["primaryWhite"]
                                              : darkTheme[
                                          "primaryAccientColor"],
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        selected_bathroom = index;
                                      });
                                    },
                                  ),
                                );
                              }))),
                    ),
                    Visibility(
                      visible: number,
                      child: MaterialInputField(
                        onChanged: (val) {
                          numberField = val;
                        },
                        textColor: Colors.white,
                        labelColor: Colors.white,
                        label: propertySubType != null
                            ? propertySubType + " number"
                            : "number",
                        textInputType: TextInputType.text,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Price Range(PKR)',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          height: 30,
                          width: getWidth(context)/3,
                          child:CircularInputField(
                            hintText: 'Start Price',
                            // value: Price,
                            readOnly: false,
                            type: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                fixStartPrice = val;
                                print(fixStartPrice);
                              });
                            },
                          ),
                        ),
                        Text(
                          'TO',
                          style: TextStyle(color:Colors.white),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          height: 30,
                          width: getWidth(context)/3,
                          child:CircularInputField(
                            hintText: 'End Price',
                            // value: Price,
                            readOnly: false,
                            type: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                fixEndPrice = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: getWidth(context),
                      child: RangeSlider(
                        inactiveColor: Colors.white,
                        activeColor: darkTheme['secondaryColor'],
                        values: _currentPriceRangeValues,
                        min: 0
                        ,
                        max: 6000000000,
                        divisions: 50,
                        labels: RangeLabels(
                          formatter
                              .format(_currentPriceRangeValues.start.round()),
                          formatter
                              .format(_currentPriceRangeValues.end.round()),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentPriceRangeValues = values;
                          });
                        },
                      ),
                    ),
                    Text(
                      'Property Number Range',
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          height: 30,
                          width: getWidth(context)/3,
                          child:CircularInputField(
                            hintText: 'Start Range',
                            // value: Price,
                            readOnly: false,
                            type: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                fixStartPropertyNumber = val;
                              });
                            },
                          ),
                        ),
                        Text(
                          'TO',
                          style: TextStyle(color:Colors.white),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          height: 30,
                          width: getWidth(context)/3,
                          child:CircularInputField(
                            hintText: 'End Range',
                            // value: Price,
                            readOnly: false,
                            type: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                fixEndPropertyNumber = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: getWidth(context),
                      child: RangeSlider(
                        inactiveColor: Colors.white,
                        activeColor: darkTheme['secondaryColor'],
                        values: _currentPropertyNumber,
                        min: 0,
                        max: 2000,
                        divisions: 50,
                        labels: RangeLabels(
                          formatter.format(_currentPropertyNumber.start),
                          formatter.format(_currentPropertyNumber.end),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentPropertyNumber = values;
                          });
                        },
                      ),
                    ),
                    /*    Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                        DropdownButton<String>(
                              value: startPrice,
                              icon: const Icon(FontAwesomeIcons.chevronDown),
                              iconSize: 16,
                              elevation: 16,
                              style: const TextStyle(color: Colors.black),
                              underline: Container(
                                height: 1,
                                color: Colors.black,
                              ),
                              onChanged: (val) {
                                setState(() {
                                  startPrice = val;
                                });
                              },
                              items: <String>['0', '500000', '1000000', '1500000', '2000000', '2500000', '3000000', '3500000', '4000000', '4500000', '5000000', '6000000']
                                  .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          Text('To', style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: endPrice,
                            icon: const Icon(FontAwesomeIcons.chevronDown),
                            iconSize: 16,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            onChanged: (val) {
                              setState(() {
                                endPrice = val;
                              });
                            },
                            items: <String>['0', '500000', '1000000', '1500000', '2000000', '2500000', '3000000', '3500000', '4000000', '4500000', '5000000', '6000000']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ), */
                    Row(
                      // direction: Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Flexible(
                          child: Row(
                            children: [
                              Text(
                                'Area Range ',
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),

                              Flexible(
                                child: Text(
                                  '($selectedUnitName)',
                                  style: TextStyle(
                                      fontSize: 11,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Container(
                          width: getWidth(context) / 2,
                          child: Theme(
                            data: ThemeData(primaryColor: Colors.white),
                            child: DropdownButton<String>(
                              isExpanded: true,
                              value: selectedUnit,
                              underline: SizedBox(),
                              hint: Text(
                                "Select Unit",
                                style: TextStyle(color: Colors.white),
                              ),
                              onChanged: (_) async {
                                print(_);
                                setState(() {
                                  selectedUnit = _;
                                  var data = unitsList
                                      .where((element) =>
                                  element.id == selectedUnit)
                                      .first;
                                  selectedUnitName = data.unitName;
                                });
                                // ProgressDialog  pr = ProgressDialog(context);
                                // pr.show();
                                // var pgData =  await getPageData();
                                // clearForm();
                                // pr.hide();
                                //
                                // print(_);
                                // setState(() {
                                //   society = _;
                                // });
                                // var filt = await filter();
                                // // filterFromDropDowns(_, "society");
                                // filterSector();
                              },
                              style: TextStyle(color: Colors.white),
                              items: unitsList.map((PropertyUnit val) {
                                return new DropdownMenuItem<String>(
                                  value: val.id,
                                  child: new Text(
                                    val.unitName != null ? val.unitName : "",
                                    style: TextStyle(color: Colors.blueGrey),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),

                        // InkWell(
                        //   onTap: () {
                        //     changeMarlaKanal(context);
                        //   },
                        //   child: Text(
                        //     'Change Area Unit',
                        //     style:
                        //         TextStyle(color: darkTheme['secondaryColor']),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          height: 30,
                          width: getWidth(context)/3,
                          child:CircularInputField(
                            hintText: 'Start Range',
                            // value: Price,
                            readOnly: false,
                            type: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                fixStartRange = val;
                              });
                            },
                          ),
                        ),
                        Text(
                          'TO',
                          style: TextStyle(color:Colors.white),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                          ),
                          height: 30,
                          width: getWidth(context)/3,
                          child:CircularInputField(
                            hintText: 'End Range',
                            // value: Price,
                            readOnly: false,
                            type: TextInputType.number,
                            onChanged: (val) {
                              setState(() {
                                fixEndRange = val;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: getWidth(context),
                      child: RangeSlider(
                        inactiveColor: Colors.white,
                        activeColor: darkTheme['secondaryColor'],
                        values: _currentAreaRangeValues,
                        min: 0,
                        max: 5000,
                        divisions: 50,
                        labels: RangeLabels(
                          _currentAreaRangeValues.start.round().toString(),
                          _currentAreaRangeValues.end.round().toString(),
                        ),
                        onChanged: (RangeValues values) {
                          setState(() {
                            _currentAreaRangeValues = values;
                          });
                        },
                      ),
                    ),
                    Center(
                      child: SizedBox(
                        width: 140,
                        child: ElevatedButton(
                            onPressed: () => {search()},
                            style: ButtonStyle(
                                backgroundColor:
                                MaterialStateProperty.all<Color>(
                                    darkTheme['secondaryColor']),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                    side:
                                    BorderSide(color: darkTheme["redText"]),
                                  ),
                                  // primary: darkTheme["secondaryColor"],
                                )),
                            child: Text("Search",
                                style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700))),
                      ),
                    ),
                    Center(
                      child: TouchableOpacity(
                          onTap: () {
                            resetAll();
                          },
                          child: Text('Clear all',
                              style: TextStyle(
                                  color: Colors.white, fontSize: 16))),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    /* Container(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          DropdownButton<String>(
                            value: startArea,
                            icon: const Icon(FontAwesomeIcons.chevronDown),
                            iconSize: 16,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            onChanged: (val) {
                              setState(() {
                                startArea = val;
                              });
                            },
                            items: <String>['0', '500000', '1000000', '1500000', '2000000', '2500000', '3000000', '3500000', '4000000', '4500000', '5000000', '6000000']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          Text('To', style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value:  endArea,
                            icon: const Icon(FontAwesomeIcons.chevronDown),
                            iconSize: 16,
                            elevation: 16,
                            style: const TextStyle(color: Colors.black),
                            underline: Container(
                              height: 1,
                              color: Colors.black,
                            ),
                            onChanged: (val) {
                              setState(() {
                                endArea = val;
                              });
                            },
                            items: <String>['0', '500000', '1000000', '1500000', '2000000', '2500000', '3000000', '3500000', '4000000', '4500000', '5000000', '6000000']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          //PricePicker(),
                        ],
                      ),
                    ), */
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

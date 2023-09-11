import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:camera/camera.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:marquee_widget/marquee_widget.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/CircularInputField.dart';
import 'package:qkp/Constraint/AppLoadingScreen.dart';
import 'package:qkp/Constraint/AutoScroller.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/Constraint/mMarqeeWidget.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/MaterialButton.dart';
import 'package:qkp/MaterialInputField.dart';
import 'package:qkp/Model/ImageType.dart';
import 'package:qkp/Model/Property.dart';
import 'package:qkp/Model/PropertyCity.dart';
import 'package:qkp/Model/PropertyFeature.dart';
import 'package:qkp/Model/PropertySector.dart';
import 'package:qkp/Model/PropertyType.dart';
import 'package:qkp/Model/PropertyUnit.dart';
import 'package:qkp/Model/SubTypeField.dart';
import 'package:qkp/Model/Town.dart';
import 'package:qkp/Model/Unit.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';
import 'package:qkp/Network/network.dart';

import '../CustomeElivatedButton.dart';
import '../Constraint/globals.dart' as global;
import '../main.dart';

class AddPropertyScreen extends StatefulWidget {
  CameraDescription camera;

  AddPropertyScreen({this.camera});

  @override
  _AddPropertyScreenState createState() => _AddPropertyScreenState();
}

class _AddPropertyScreenState extends State<AddPropertyScreen> with RouteAware {
  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  String type;
  CameraController _controller;

  Future<void> _initializeControllerFuture;
  List<PickedFile> imageList = [];
  bool isLoading = false;
  String base64 = "";
  List<Map<String, dynamic>> images = [];
  Map<String, dynamic> citiesMapList = {};
  LatLng currentLocation;

  //List<Units> unitArrayList = [];
  String unitId;
  String propertySubType;
  List<PropertyType> propertyTypeList = [];
  List<Subtypes> selectedSubTypeList = [];
  List<PropertyCity> propertyCityList = [];
  List<Towns> selectedTownsList = [];
  List<ImageType> imageTypeList = [];
  ImageType currentType;
  Subtypes selectedSubType;
  Towns selectedTown;
  PropertyCity selectedCity;
  List<PropertyUnit> propertyUnitList = [];
  List<PropertyFeatures> propertyFeaturesList = [];
  Map featuresMap;
  String selectedImage = "1";
  List<SubTypeFields> subTypeFiedsList = [];
  List<SubTypeFields> currentSubTypeFieldList = [];
  Map<String, dynamic> fieldsData = Map();

  List<PropertySociety> propertySocietyList = [];
  PropertySociety selectedPropertySociety;
  List<Sectors> selectedSectorsList = [];
  Sectors selectedSectors;
  Completer<GoogleMapController> _mapController = Completer();
  bool isTopLoading = false;

  String rooms = "",
      bathRooms = "",
      area = "",
      address = "",
      phone = "",
      price = "0",
      contact = "",
      title = "",
      minPrice = "",
      maxPrice = "";
  User user;
  bool saveLoading = false, isDisabledSave = false;

  var propertyNumber;

  getFeatures() async {
    var res = await getFeatureData();
    var data = res["list"];
    for (int i = 0; i < data.length; i++) {
      propertyFeaturesList.add(PropertyFeatures.fromJson(data[i]));
    }
  }

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
    user = await getUser();
    setState(() {
      isTopLoading = true;
    });
    var res = await getPropertyAddPageData();
    setState(() {
      isTopLoading = false;
    });
    if (res == null) {
      return;
    }
    var data = res["list"];
    var typeMapList = data["types"];
    var citiesMapList = data["cities"];
    var mapUnitList = data["property_unit"];
    var mapImagesTypeList = data["images_type"];
    var mapSubTypeFields = data["fields"];
    var mapSocietyList = data["society"];
    propertyTypeList.clear();
    propertyCityList.clear();
    propertySocietyList.clear();
    propertyUnitList.clear();
    imageTypeList.clear();
    subTypeFiedsList.clear();
    for (int i = 0; i < typeMapList.length; i++) {
      propertyTypeList.add(PropertyType.fromJson(typeMapList[i]));
    }

    for (int i = 0; i < citiesMapList.length; i++) {
      propertyCityList.add(PropertyCity.fromJson(citiesMapList[i]));
    }

    for (int i = 0; i < mapUnitList.length; i++) {
      propertyUnitList.add(PropertyUnit.fromJson(mapUnitList[i]));
    }
    for (int i = 0; i < mapImagesTypeList.length; i++) {
      imageTypeList.add(ImageType.fromJson(mapImagesTypeList[i]));
    }
    for (int i = 0; i < mapSubTypeFields.length; i++) {
      subTypeFiedsList.add(SubTypeFields.fromJson(mapSubTypeFields[i]));
    }

    for (int i = 0; i < mapSocietyList.length; i++) {
      propertySocietyList.add(PropertySociety.fromJson(mapSocietyList[i]));
    }

    currentType =
        imageTypeList.where((element) => element.id == "1").toList()[0];
    setState(() {
      propertyTypeList = propertyTypeList;
      propertyCityList = propertyCityList;
      propertyUnitList = propertyUnitList;
      imageTypeList = imageTypeList;
      subTypeFiedsList = subTypeFiedsList;
      propertySocietyList = propertySocietyList;
    });
  }

  subTypeFilter(type) {
    int filteredItems = 0;
    selectedSubTypeList.clear();
    for (int i = 0; i < propertyTypeList.length; i++) {
      if (propertyTypeList[i].id == type) {
        if (propertyTypeList[i].subtypes.length > 0) {
          filteredItems++;
        }
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

  subTypeFieldsFilter(Subtypes _fSubType) {
    print(_fSubType.toJson());
    List<SubTypeFields> tempSubTypeList = subTypeFiedsList
        .where((element) => element.subTypeId == _fSubType.id)
        .toList();

    currentSubTypeFieldList.clear();
    currentSubTypeFieldList.addAll(tempSubTypeList);
    fieldsData.clear();
    setState(() {
      currentSubTypeFieldList = currentSubTypeFieldList;
    });
  }

  filterTowns(PropertyCity _propertyCity) {
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

  setFieldsInformation(SubTypeFields subTypeField, val) {
    if (fieldsData[subTypeField.fieldId] == null) {
      fieldsData[subTypeField.id] = {
        "id": subTypeField.id,
        "field_id": subTypeField.fieldId,
        "name": subTypeField.name,
        "value": val
      };
    } else {
      fieldsData[subTypeField.id].update(
          fieldsData[subTypeField.fieldId],
          (value) => {
                "id": subTypeField.id,
                "field_id": subTypeField.fieldId,
                "name": subTypeField.name,
                "value": val
              });
    }
    print(fieldsData);
  }

  //

  openCamera() async {
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.camera, imageQuality: 20);

    if (image != null) {
      File _file = await cropImage(image);
      if (_file != null) {
        final bytes = _file.readAsBytesSync();
        print(bytes.toString());

        String base = base64Encode(bytes);
        String name = image.path.split("/").last;

        var request = {"image": base, "name": name};
        setState(() {
          isLoading = true;
        });
        var response = await uploadImage(request);
        setState(() {
          isLoading = false;
        });
        if (response != null) {
          Map<String, dynamic> data = {
            "image": response["Image"]["image"].toString(),
            "selectedType": currentType.toJson()
          };
          var img = data;

          images.add(img);
        }
        // print("Base 64 Gallary => " + base64);
        // images.add();
        setState(() {
          imageList.add(image);
        });
      } else {
        showToast("No image selected");
      }
    } else {
      showToast("No image selected");
    }
  }

  openGallery() async {
    PickedFile image = await ImagePicker.platform
        .pickImage(source: ImageSource.gallery, imageQuality: 20);
    if (image != null) {
      File _file = await cropImage(image);
      if (_file != null) {
        final bytes = _file.readAsBytesSync();
        print(bytes.toString());
        String base = base64Encode(bytes);
        String name = image.path.split("/").last;
        var request = {"image": base, "name": name};
        setState(() {
          isLoading = true;
        });
        var response = await uploadImage(request);
        setState(() {
          isLoading = false;
        });
        if (response != null) {
          Map<String, dynamic> data = {
            "image": response["Image"]["image"],
            "selectedType": currentType.toJson()
          };
          // var img = data;
          images.add(data);
        }
        // print("Base 64 Gallary => " + base64);
        // images.add();
        setState(() {
          imageList.add(image);
        });
      } else {
        showToast("No image selected");
      }
    } else {
      showToast("No image selected");
    }
  }

  Future<File> cropImage(imageFile) async {
    File croppedFile = await ImageCropper.cropImage(
      sourcePath: imageFile.path,
      maxWidth: 1080,
      maxHeight: 500,
      aspectRatio: CropAspectRatio(ratioX: 2.0, ratioY: 1.5),
      // aspectRatioPresets: [
      //   CropAspectRatioPreset.square,
      //   CropAspectRatioPreset.ratio3x2,
      //   CropAspectRatioPreset.original,
      //   CropAspectRatioPreset.ratio4x3,
      //   CropAspectRatioPreset.ratio16x9
      // ],
      // androidUiSettings: AndroidUiSettings(
      //     toolbarTitle: 'Cropper',
      //     toolbarColor: Colors.deepOrange,
      //     toolbarWidgetColor: Colors.white,
      //     initAspectRatio: CropAspectRatioPreset.original,
      //     lockAspectRatio: false
      // ),
      // iosUiSettings: IOSUiSettings(
      //   minimumAspectRatio: 1.0,
      // )
    );
    return croppedFile;
  }

  bool isRequesting = false;

  //
  addProperty() async {
    // print(selectedCity.toJson())

    if (isRequesting && isLoading) {
      showToast("please wait...");
      return;
    }
    if (selectedTown == null) {
      selectedTown = Towns();
      selectedTown.id = "";

      // showToast("Please Select Town");
      // return;
    }
    if(selectedPropertySociety == null){
      selectedPropertySociety = PropertySociety();
      selectedPropertySociety.id = '';
    }

    if (selectedCity == null) {
      showToast("Please Select City");
      return;
    }
    if (selectedSubType == null) {
      showToast("Please Select SubType");
      return;
    }
    if (title.length < 2) {
      showToast("title cannot be empty");
      return;
    }
    if (unitId.length < 1) {
      showToast("Please Select Unit");
      return;
    }
    if (minPrice.length < 1) {
      showToast("minimum price cannot be empty");
      return;
    }
    if (maxPrice.length < 1) {
      showToast("maximum price cannot be empty");
      return;
    }
    if (currentLocation == null) {
      currentLocation = LatLng(0, 0);
    }
    if (propertyNumber == null) {
      showToast("property number cannot be null");
      return;
    }
    if (int.tryParse(minPrice) >= int.tryParse(maxPrice)) {
      showToast("minimum price cannot be greater then or equal to max price");
      return;
    }
    Map<String, dynamic> image = Map();
    if (images.length < 1) {
      var Types = imageTypeList.where((element) => element.id == "5");
      if (Types.length > 0) currentType = Types.first;
      print(type);
      if (type == "1") {
        image = {
          "image": propertyDefaultUrl + "Residentail.jpeg",
          "selectedType": currentType.toJson()
        };
      } else if (type == "2") {
        image = {
          "image": propertyDefaultUrl + "Commercial.jpeg",
          "selectedType": currentType.toJson()
        };
      } else if (type == "3") {
        image = {
          "image": propertyDefaultUrl + "Plots.jpeg",
          "selectedType": currentType.toJson()
        };
      } else {
        image = {
          "image": propertyDefaultUrl + "Plots.jpeg",
          "selectedType": currentType.toJson()
        };
      }
      images.add(image);
      setState(() {
        images = images;
      });
    }
    if(images.length < 1){
      showToast("images cannot be empty");
      return;
    }

    // for (int i = 0; i < images.length; i++) {}
    var sectorId = selectedSectors != null ? selectedSectors.id : "0";
    var request = {
      "city": selectedCity.id,
      "town": selectedTown.id,
      "subType": selectedSubType.id,
      "type": type,
      "unit": unitId,
      "rooms": rooms,
      "bathrooms": bathRooms,
      "features": jsonEncode(featuresMap),
      "images": jsonEncode(images),
      "fields_data": jsonEncode(fieldsData),
      "address": address,
      "phone": phone,
      "lat": currentLocation.latitude,
      "long": currentLocation.longitude,
      "contact": contact,
      "price": price,
      "user": user.id,
      "title": title,
      "society": selectedPropertySociety.id,
      "sector": sectorId,
      "min_price": minPrice,
      "max_price": maxPrice,
      "area": area,
      "property_number": propertyNumber
    };

    print(request);

    // return ;
    loading();

    isRequesting = true;

    ProgressDialog progressDialog = showShortDialog(context);
    var resp = await addPropertyService(request);

    progressDialog.hide();

    isRequesting = false;

    stopLoading();

    if (resp["ResponseCode"] == 1) {
      Navigator.of(context).pop();
    }
  }

  loading() {
    setState(() {
      isDisabledSave = true;
      saveLoading = true;
    });
  }

  stopLoading() {
    setState(() {
      isDisabledSave = false;
      saveLoading = false;
    });
  }

  goToLocation(LatLng location) async {
    GoogleMapController controller = await _mapController.future;
    print("here");
    controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: location,
      zoom: 18.4746,
    )));
  }

  Future<bool> showActionSheet() async {
    await showAdaptiveActionSheet(
      context: context,
      title: const Text('Trade Now'),
      actions: <BottomSheetAction>[
        BottomSheetAction(
            title: Text(
              'Camera',
              style: TextStyle(
                color: darkTheme["redText"],
              ),
            ),
            onPressed: () async {
              await openCamera();
              try {
                await _initializeControllerFuture;
                print("Done image");
              } catch (e) {
                print("error =>" + e.toString());
              }
            }),
        BottomSheetAction(
            title: Text(
              'Gallery',
              style: TextStyle(
                color: darkTheme["redText"],
              ),
            ),
            onPressed: () {
              openGallery();
              // Navigator.pushNamed(context, "bid_file",
              //     arguments: widget.file.toJson());
              //CancelAction();
            }),
      ],
      cancelAction: CancelAction(
          title: const Text(
              'Cancel')), // onPressed parameter is optional by default will dismiss the ActionSheet
    );
    return true;
  }

  Future<bool> showImageTypeBottomSheet(cont) async {
    await showModalBottomSheet(
      context: cont,
      // barrierColor: Colors.red,
      // bounc : true,
      builder: (context) => StatefulBuilder(builder: (context, setState) {
        return Container(
          padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
          color: darkTheme['primaryBackgroundColor'],
          height: getHeight(cont),
          width: getWidth(cont),
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 5),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(),
                    SizedBox(),
                    SizedBox(),
                    SizedBox(
                      height: 60,
                      width: 150,
                      child: Divider(
                        color: Colors.grey,
                        height: 20,
                        thickness: 5,
                      ),
                    ),
                    SizedBox(),
                    Material(
                      color: Colors.transparent,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(Icons.close),
                          color: Colors.white),
                    )
                  ],
                ),
                Text(
                  "Image Type",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "File",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                DropdownButton<String>(
                  isExpanded: true,
                  value: selectedImage,
                  hint: Text(
                    "Select Image Type",
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                  icon: Icon(Icons.location_city),
                  dropdownColor: darkTheme["cardBackground"],
                  items: imageTypeList.map((ImageType val) {
                    return new DropdownMenuItem<String>(
                      value: val.id,
                      child: new Text(
                        val.imageType,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (_) {
                    print(_);
                    setState(() {
                      selectedImage = _;
                      currentType = imageTypeList
                          .where((element) => element.id == _)
                          .toList()[0];
                    });

                    print("file" + selectedImage.toString());
                    // filter();
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                SizedBox(
                  height: 40,
                ),
                CustomeElivatedButtonWidget(
                    onPress: () async {
                      // print(" fileId" + fId);
                      // await getFilesData();
                      Navigator.of(context).pop();
                    },
                    name: "Apply Now")
              ],
            ),
          ),
        );
      }),
    ).then((value) => print(value.toString()));
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    getPageData();
    getFeatures();
    super.initState();
  }

  fcmInit() {
    global.onMessageReceiveFunction = (message) {
      FCMMesseging(message);
    };
  }

  void FCMMesseging(message) {
    onNotificationReceive(context, data: {"message": message});
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Property"),
        elevation: 0,
        actions: [
          IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                getPageData();
              })
        ],
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: isTopLoading ? LinearProgressIndicator() : SizedBox(),
        ),
      ),
      body: Stack(
        children: [
          Container(
            color: isDarkTheme
                ? darkTheme["primaryBackgroundColor"]
                : lightTheme["primaryBackgroundColor"],
            padding: EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [

                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Text(
                          "Property Information",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: darkTheme["secondaryColor"],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () async {
                              var res =
                                  await Navigator.pushNamed(context, "map");
                              print(res);
                              if (res != null) {
                                setState(() {
                                  currentLocation = res;
                                });
                                goToLocation(currentLocation);
                              }
                            },
                            child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(20, 10, 20, 10),
                              child: Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      "Location",
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
                                        color: darkTheme["primaryWhite"],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 4,
                                  ),
                                  Icon(
                                    Icons.location_pin,
                                    size: 14,
                                    color: darkTheme["redText"],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  CircularInputField(
                    onChanged: (val) {
                      title = val;
                    },
                    hintText: "Property Title*",
                    // textInputType: TextInputType.text,
                  ),
                  Container(
                    height: 50,
                    width: getWidth(context),
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: Center(
                      child: ListView(
                        shrinkWrap: false,
                        scrollDirection: Axis.horizontal,
                        children:
                            List.generate(propertyTypeList.length, (index) {
                          return Row(
                            children: [
                              Text(
                                propertyTypeList[index].typeName,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: darkTheme["primaryWhite"],
                                ),
                              ),
                              Radio<String>(
                                activeColor: Colors.white,
                                focusColor: Colors.white,
                                value: propertyTypeList[index].id,
                                groupValue: type,
                                onChanged: (String value) {
                                  setState(() {
                                    type = value;
                                  });
                                  subTypeFilter(type);
                                  print(value);
                                },
                              ),
                              SizedBox(
                                width: 10,
                              )
                            ],
                          );
                        }),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    height: 50,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.white,
                    ),
                    child: IgnorePointer(
                      ignoring: false,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(60.0),
                        child: DropdownSearch<Subtypes>(
                          mode: Mode.DIALOG,
                          items: selectedSubTypeList,
                          // popupBackgroundColor: Colors.grey,
                          label: "Select Subtype*",
                          onChanged: (_) {
                            // print("=>"+_.id);
                            setState(() {
                              selectedSubType = _;
                            });
                            subTypeFieldsFilter(_);
                          },
                          // selectedItem: selectedCity,
                          showSearchBox: true,
                          searchBoxDecoration: InputDecoration(
                            border: OutlineInputBorder(),
                            contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                            fillColor: Colors.red,
                            hoverColor: Colors.red,
                            focusColor: Colors.red,
                            labelText: "Search a Sub Type",
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
                                'Sub Type*',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Wrap(
                    direction: Axis.vertical,
                    children: List.generate(
                      currentSubTypeFieldList.length,
                      (index) => Container(
                        width: getWidth(context) * .94,
                        child: MaterialInputField(
                          onChanged: (val) {
                            setFieldsInformation(
                                currentSubTypeFieldList[index], val);
                          },
                          labelColor: Colors.grey,
                          label: currentSubTypeFieldList[index].name,
                          textInputType: TextInputType.text,
                          rightIcon: Icon(Icons.notes),
                          textColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Your Property Located At?",
                      style: TextStyle(
                        color: darkTheme["secondaryColor"],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  Text("Note: Please select nearest society town if you cannot find your related and use map for exact location.",
                      style: TextStyle(
                        color: darkTheme["secondaryColor"],
                        fontSize: 12,
                        // fontWeight: FontWeight.bold,
                      )),
                  SizedBox(
                    height: 10,
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
                      child: DropdownSearch<PropertyCity>(
                        mode: Mode.DIALOG,
                        items: propertyCityList,

                        // popupBackgroundColor: Colors.grey,
                        label: "Select city*",
                        onChanged: (_) {
                          // print("=>"+_.id);
                          setState(() {
                            selectedCity = _;
                          });
                          filterTowns(_);
                          getSocietyByCity();
                        },

                        // selectedItem: selectedCity,
                        showSearchBox: true,
                        searchBoxDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                          fillColor: Colors.red,
                          hoverColor: Colors.red,
                          focusColor: Colors.red,
                          labelText: "Search a city",
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
                              'City',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
                  SizedBox(height: 10),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 0, 0),
                    height: 50,
                    decoration: new BoxDecoration(
                      borderRadius: BorderRadius.circular(60.0),
                      color: Colors.white,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60.0),
                      child: DropdownSearch<Towns>(
                        mode: Mode.DIALOG,
                        items: selectedTownsList,
                        // popupBackgroundColor: Colors.grey,
                        label: "Select town",
                        onChanged: (_) {
                          // print("=>"+_.id);
                          setState(() {
                            selectedTown = _;
                          });
                        },
                        // selectedItem: selectedCity,
                        showSearchBox: true,
                        searchBoxDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding: EdgeInsets.fromLTRB(12, 12, 8, 0),
                          fillColor: Colors.red,
                          hoverColor: Colors.red,
                          focusColor: Colors.red,
                          labelText: "Search a Town",
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
                              'Town',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
                        label: "Select Society",
                        onChanged: (_) {
                          // print("=>"+_.id);
                          setState(() {
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
                        label: "Select Sector",
                        onChanged: (_) {
                          // print("=>"+_.id);
                          setState(() {
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
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
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
                    height: 17,
                  ),
                  if (selectedSubType != null)
                    CircularInputField(
                      onChanged: (val) {
                        propertyNumber = val;
                      },
                      hintText: selectedSubType != null
                          ? selectedSubType.subTypeName + " Number*"
                          : "Number",
                      type: TextInputType.text,
                    ),
                  SizedBox(
                    height: 10,
                  ),
                  Flex(
                    direction: Axis.horizontal,
                    children: [
                      Expanded(
                          flex: 1,
                          child: Column(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Container(
                                alignment: Alignment.center,
                                decoration: new BoxDecoration(
                                  borderRadius: BorderRadius.circular(60.0),
                                  color: Colors.white,
                                ),
                                padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                child: DropdownButton<String>(
                                  underline: SizedBox(),
                                  isExpanded: true,
                                  value: unitId,
                                  hint: Text("Select Unit*"),
                                  items:
                                      propertyUnitList.map((PropertyUnit val) {
                                    // var i = p.indexOf(val);
                                    // print(i.toString());
                                    return new DropdownMenuItem<String>(
                                      value: val.id,
                                      child: new Text(val.unitName),
                                    );
                                  }).toList(),
                                  onChanged: (_) {
                                    print(_);
                                    setState(() {
                                      unitId = _;
                                    });
                                  },
                                ),
                              ),
                            ],
                          )),
                      SizedBox(width: 10),
                      Expanded(
                        flex: 1,
                        child: CircularInputField(
                          onChanged: (val) {
                            if (unitId == null) {
                              showToast("select some unit");
                              return;
                            }
                            area = val;
                          },
                          hintText: "Area",
                          value: area,
                          type: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 14),
                  Visibility(
                    visible: true,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CircularInputField(
                            onChanged: (val) {
                              minPrice = val;
                            },
                            hintText: "Bid Starting Price*",
                            type: TextInputType.number,
                          ),
                        ),
                        SizedBox(width: 6),
                        Expanded(
                          flex: 1,
                          child: Container(
                            margin: EdgeInsets.fromLTRB(4, 0, 0, 0),
                            child: CircularInputField(
                              onChanged: (val) {
                                maxPrice = val;
                              },
                              hintText: "Selling Price*",
                              type: TextInputType.number,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 14,
                  ),
                  // Flex(
                  //   direction: Axis.vertical,
                  //   children: [
                  //     Expanded(
                  //       flex: 1,
                  //       child: MaterialInputField(
                  //         onChanged: (val) {
                  //
                  //         },
                  //         labelColor: Colors.grey,
                  //         label: "Area",
                  //         textInputType: TextInputType.text,
                  //       ),
                  //     ),
                  //     Expanded(
                  //       flex: 1,
                  //       child: MaterialInputField(
                  //         onChanged: (val) {
                  //
                  //         },
                  //         labelColor: Colors.grey,
                  //         label: "Area",
                  //         textInputType: TextInputType.text,
                  //       ),
                  //     ),
                  //   ],
                  // ),

                  CircularInputField(
                    onChanged: (val) {
                      address = val;
                    },
                    hintText: "Full Address",
                    type: TextInputType.text,
                  ),

                  SizedBox(
                    height: 14,
                  ),
                  CircularInputField(
                    onChanged: (val) {
                      phone = val;
                    },
                    hintText: "Additional Number",
                    type: TextInputType.number,
                  ),
                  SizedBox(
                    height: 0,
                  ),
                  Visibility(
                    visible: false,
                    child: MaterialInputField(
                      onChanged: (val) {
                        price = val;
                      },
                      labelColor: Colors.grey,
                      label: "Expecting (Price)",
                      textInputType: TextInputType.text,
                      rightIcon: Icon(FontAwesomeIcons.moneyBillWave),
                    ),
                  ),

                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 80,
                    width: getWidth(context),
                    child: images.length > 0
                        ? ListView(
                            scrollDirection: Axis.horizontal,
                            children: List.generate(images.length, (index) {
                              return Stack(
                                children: [
                                  Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          images[index]["selectedType"] =
                                              currentType.toJson();
                                        });
                                      },
                                      onLongPress: () async {
                                        var ddata =
                                            await showImageTypeBottomSheet(
                                                context);
                                        if (ddata) {
                                          setState(() {
                                            images[index]["selectedType"] =
                                                currentType.toJson();
                                          });
                                          print("here");
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Stack(
                                            alignment: Alignment.bottomCenter,
                                            children: [
                                              FadeInImage(
                                                placeholder: AssetImage(
                                                    "assets/images/house_loading_placeholder.gif"),
                                                image: NetworkImage(
                                                  BaseUrl +
                                                      images[index]["image"],
                                                ),
                                                fit: BoxFit.cover,
                                                width: 100,
                                                height: 80,
                                              ),
                                              Container(
                                                padding: EdgeInsets.fromLTRB(
                                                    10, 2, 10, 2),
                                                margin: EdgeInsets.fromLTRB(
                                                    0, 0, 0, 5),
                                                decoration: BoxDecoration(
                                                  color: Colors.lightBlueAccent,
                                                  borderRadius:
                                                      BorderRadius.circular(3),
                                                ),
                                                child: Text(
                                                  images[index]["selectedType"]
                                                      ["image_type"],
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                        child: Icon(
                                          Icons.delete,
                                          size: 22,
                                          color: Colors.white,
                                        ),
                                        onTap: () {
                                          setState(() {
                                            images.removeAt(index);
                                          });
                                        }),
                                  ),
                                ],
                              );
                            }),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("No Image Found",
                                  style: TextStyle(color: Colors.white)),
                              Icon(Icons.image_search,
                                  size: 24, color: Colors.white)
                            ],
                          ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  isLoading
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 50,
                              width: 50,
                              child: CircularProgressIndicator(
                                  valueColor:
                                      AlwaysStoppedAnimation(Colors.white),
                                  strokeWidth: 3.0),
                            ),
                          ],
                        )
                      : SizedBox(),
                  propertyFeaturesList.length > 0
                      ? Container(
                          padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "More Information",
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: darkTheme["primaryWhite"]),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () async {
                                      var data = await Navigator.pushNamed(
                                          context, "features",
                                          arguments: propertyFeaturesList);
                                      if (data != null) {
                                        print(data);
                                        setState(() {
                                          featuresMap = data;
                                        });
                                      }
                                    },
                                    child: Container(
                                      width: getWidth(context),
                                      padding:
                                          EdgeInsets.fromLTRB(6, 10, 0, 10),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: darkTheme["primaryWhite"]),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.transparent),
                                      child: Text(
                                        "Select Features",
                                        style: TextStyle(
                                          color: darkTheme["primaryWhite"],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                margin: EdgeInsets.fromLTRB(2, 0, 0, 0),
                                child: Column(
                                  children: List.generate(
                                    featuresMap != null
                                        ? featuresMap.length
                                        : 0,
                                    (index) => Wrap(
                                      children: List.generate(
                                          featuresMap[featuresMap.keys
                                                      .elementAt(index)] !=
                                                  null
                                              ? featuresMap[featuresMap.keys
                                                      .elementAt(index)]
                                                  .length
                                              : 0, (ind) {
                                        var subFeature = featuresMap[
                                            featuresMap.keys.elementAt(index)];
                                        return Container(
                                          padding:
                                              EdgeInsets.fromLTRB(10, 6, 10, 6),
                                          margin:
                                              EdgeInsets.fromLTRB(7, 6, 0, 0),
                                          decoration: BoxDecoration(
                                            color: Colors.grey[300],
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                subFeature.keys.elementAt(ind) +
                                                    " : " +
                                                    subFeature.values.elementAt(
                                                        ind)["value"],
                                                style: TextStyle(
                                                    // color:Colors.white,
                                                    ),
                                              ),
                                              InkWell(
                                                onTap: () {
                                                  var sub = featuresMap[
                                                      featuresMap.keys
                                                          .elementAt(index)];
                                                  featuresMap[featuresMap.keys
                                                          .elementAt(index)]
                                                      .remove(sub.keys
                                                          .elementAt(ind));
                                                  setState(() {
                                                    featuresMap = featuresMap;
                                                  });
                                                },
                                                child: Icon(
                                                  Icons.clear,
                                                  size: 16,
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ),
                              ),
                              currentLocation != null
                                  ? Container(
                                      width: getWidth(context),
                                      height: getHeight(context) * .30,
                                      child: GoogleMap(
                                        mapType: MapType.terrain,
                                        // zoomControlsEnabled: false,
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          _mapController.complete(controller);
                                        },
                                        initialCameraPosition: CameraPosition(
                                            target: currentLocation, zoom: 20),
                                        markers: {
                                          Marker(
                                              markerId:
                                                  MarkerId(genrateMarkerId()),
                                              position: currentLocation)
                                        },
                                      ),
                                    )
                                  : Center(
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10,
                                          ),
                                          Text("Cannot Locate Your Property",
                                              style: TextStyle(
                                                  color: darkTheme[
                                                      "primaryWhite"])),
                                          Icon(Icons.location_disabled,
                                              color: darkTheme["primaryWhite"]),
                                        ],
                                      ),
                                    )
                            ],
                          ),
                        )
                      : SizedBox(),
                  CircularInputField(
                    onChanged: (val) {
                      contact = val;
                    },
                    maxLines: 3,
                    minLines: 3,
                    hintText: "Extra Information (Optional)",
                    type: TextInputType.text,
                  ),
                  SizedBox(
                    height: 10,
                  ),

                  Center(
                    child: SizedBox(
                      width: 140,
                      child: ElevatedButton(
                          //isLoading: saveLoading,
                          //isDisable: isDisabledSave,
                          onPressed: () async {
                            addProperty();
                          },
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  darkTheme['secondaryColor']),
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: darkTheme["redText"]),
                                ),
                                // primary: darkTheme["secondaryColor"],
                              )),
                          child: Text("Post",
                              style: TextStyle(
                                  fontSize: 12, fontWeight: FontWeight.w700))),
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isTopLoading)
            AppLoadingScreen(
              backgroundOpactity: .6,
            ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: darkTheme['secondaryColor'],
        onPressed: () {
          showActionSheet();
        },
        child: Icon(
          Icons.image,
        ),
      ),
    );
  }
}

import 'dart:convert';
import 'dart:io';

import 'package:adaptive_action_sheet/adaptive_action_sheet.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/http_requests.dart';

import 'Helpers/SessionHelper.dart';
import 'Model/PropertyCity.dart';
import 'Model/User.dart';
import 'Network/MateiralInputField.dart';
import 'Network/network.dart';
import 'Constraint/globals.dart' as global;
import 'main.dart';


class UserProfileWidget extends StatefulWidget {
  @override
  _UserProfileWidgetState createState() => _UserProfileWidgetState();
}

class _UserProfileWidgetState extends State<UserProfileWidget> with RouteAware {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  User user;
  String firstNameValue;
  String LastNameValue;
  List<PropertyCity> propertyCityList = [];
  PropertyCity selectedCity;
  bool isTopLoading = false;

  getUserData() async {
    user = await getUser();
    setState(() {
      user = user;
      firstNameValue = user.firstName;
      LastNameValue = user.lastName;
    });
    getPageData();
  }

  void getPageData() async {
    setState(() {
      isTopLoading = true;
    });
    var res = await getUserCities({});
    setState(() {
      isTopLoading = false;
    });
    if (res != null) {
      var citiesMapList = res["list"]["cities"];
      for (int i = 0; i < citiesMapList.length; i++) {
        propertyCityList.add(PropertyCity.fromJson(citiesMapList[i]));
      }
      setState(() {
        propertyCityList = propertyCityList;
      });
      print("here");
      print(propertyCityList.length.toString());
      var cityData = propertyCityList.where((element) {
        return element.id == user.city;
      });
     print(cityData.length.toString() + " a[a");
      if(cityData.length > 0 ){
        var index = propertyCityList.indexOf(cityData.first);
        setState(() {
          selectedCity = propertyCityList[index];
        });
        print(index);

      }
    }
  }

  updateProfileData() async {
    //  print(firstNameCtrl.text + " " + LastNameCtrl.text);
    String firstName = firstNameValue;
    String lastName = LastNameValue;

    ProgressDialog progressDialog = ProgressDialog(context);
    progressDialog.update(message: "loading");
    progressDialog.show();
    var request = <String, String>{
      "first_name": firstName,
      "last_name": lastName,
      "current_user": user.id,
      "city":selectedCity.id
    };
    print(request.toString());
    //    var request = new Map();
    var data = await updateProfile(request);
    progressDialog.hide();
    if (data != null) {
      User currentUser = new User();

      currentUser.fromJson(data["User"]);
      await setUser(currentUser);
      showToast("profile updated");
      // Navigator.pushReplacementNamed(_keyLoader.currentContext, "/");
      // Navigator.pushReplacementNamed(context, "/");
    }
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
                // await _initializeControllerFuture;
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

  Future<Map<String, dynamic>> uploadImage(req) async {
    try {
      var request = req;
      // var data;
      var data = await simplePostRequest("/upload_user_image",request);
      if (data["status"] == 0) {
        //showToast(data["ResponseHeader"]["ResponseMessage"]);
        return null;
      }
      if (data["status"] == 1) {
        updateUserImage(data["res"]);
        user.profilePicture = data["res"];
        setState(() {
          user = user;
        });
      }
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
    } catch (exp) {
      print(exp.toString());
      showToast("Unfortunate Error");
      return null;
    }
  }

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

        var request = {"image": base, "user_id": user.id};
        var response = await uploadImage(request);
        if (response != null) {}
        // print("Base 64 Gallary => " + base64);
        // images.add();

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
        var request = {"image": base, "user_id": user.id};
        var response = await uploadImage(request);

        if (response != null) {}
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
      maxHeight: 1080,
      aspectRatio: CropAspectRatio(ratioX: 2.0, ratioY: 1.5),

    );
    return croppedFile;
  }

  @override
  void initState() {
    getUserData();
    // TODO: implement initState
    super.initState();
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
  void FCMMesseging(message) {
    getPageData();
    onNotificationReceive(context, data: {"message": message});
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Profile"),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(7.0),
          child: isTopLoading?LinearProgressIndicator():SizedBox(),
        ),
      ),
      body: user != null
          ? Container(
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.fromLTRB(10, 20, 10, 20),
                // margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
                child: Wrap(
                  children: [
                    Container(
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            showActionSheet();
                          },
                          child: ClipOval(
                            child: FadeInImage(
                              placeholder:
                                  AssetImage("assets/images/profile.png"),
                              image: NetworkImage(
                                user != null ? url + user.profilePicture : "",
                              ),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),

                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 12),
                      child: MaterialInputFieldCustom(
                        value: user.firstName,
                        OnChange: (val) {
                          setState(() {
                            firstNameValue = val;
                          });
                        },
                        label: 'First Name',
                        icon: Image.asset(
                          "assets/images/user.png",
                          height: 13,
                        ),
                        Obscure: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      child: MaterialInputFieldCustom(
                        value: user.lastName,
                        OnChange: (val) {
                          setState(() {
                            LastNameValue = val;
                          });
                        },
                        label: 'Last Name',
                        icon: Image.asset(
                          "assets/images/user.png",
                          height: 13,
                        ),
                        Obscure: false,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(0, 0, 0, 25),
                      child: MaterialInputFieldCustom(
                        value: user.phone,
                        OnChange: (val) {},
                        label: 'Phone Number',
                        icon: Image.asset(
                          "assets/images/phone.png",
                          height: 13,
                        ),
                        Obscure: false,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 0, 10),
                      height: 60,
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        // color: Colors.white,
                      ),
                      // color: Colors.white,

                      child: DropdownSearch<PropertyCity>(
                        mode: Mode.DIALOG,
                        items: propertyCityList,
                        selectedItem: selectedCity,
                        hint: "Select City",
                        onChanged: (_) {
                          // print("=>"+_.id);
                          setState(() {
                            selectedCity = _;
                          });
                        },
                        dropdownSearchDecoration: InputDecoration(
                            border: OutlineInputBorder(
                                borderSide:BorderSide.lerp(BorderSide(color: Colors.black), BorderSide(color: Colors.black), 1),
                                borderRadius: BorderRadius.circular(16),
                                gapPadding: 0
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderSide:BorderSide.lerp(BorderSide(color: Colors.black), BorderSide(color: Colors.black), 3),
                                borderRadius: BorderRadius.circular(16),
                                gapPadding: 0

                            ),

                            helperStyle:
                            TextStyle(color: Colors.white),
                            hintStyle: TextStyle(
                              color: Colors.black,
                            )),
                        searchBoxDecoration: InputDecoration(
                          border: OutlineInputBorder(),
                          contentPadding:
                          EdgeInsets.fromLTRB(12, 12, 8, 0),
                          fillColor: Colors.red,
                          hoverColor: Colors.red,
                          focusColor: Colors.red,
                          // labelStyle: TextStyle(
                          //   color: Colors.w
                          // ),
                          labelText: "Search a city",
                        ),
                        showSearchBox: true,
                        popupTitle: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            color:
                            darkTheme["primaryBackgroundColor"],
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10),
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'City',
                              style: TextStyle(
                                fontSize: 16,
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
                    Center(
                      child: SizedBox(
                        width: 250,
                        height: 45,
                        child: ElevatedButton(
                            onPressed: () async {
                              updateProfileData();
                            },
                            style: ButtonStyle(
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        darkTheme['primaryBackgroundColor']),
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25.0),
                                    side:
                                        BorderSide(color: darkTheme["redText"]),
                                  ),
                                  // primary: darkTheme["secondaryColor"],
                                )),
                            child:
                                Text("Update", style: TextStyle(fontSize: 15))),
                      ),
                    ), //
                  ],
                ),
              ),
            )
          : Container(),
    );
  }
}

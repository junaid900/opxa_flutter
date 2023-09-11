import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/CustomeElivatedButton.dart';
import 'package:qkp/Model/City.dart';
import 'package:url_launcher/url_launcher.dart';

import 'CommensModel.dart';
import 'Constraint/colors.dart';
import 'Helpers/SessionHelper.dart';
import 'MaterialButton.dart';
import 'MaterialInputField.dart';
import 'Model/Country.dart';
import 'Model/PropertyCity.dart';
import 'Model/User.dart';
import 'Network/constant.dart';
import 'Network/network.dart';
import 'TopLayout.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  void setState(fn) {
    // TODO: implement setState
    if (mounted) {
      super.setState(fn);
    }
  }

  bool termsAgree = false;

  final _formKey = GlobalKey<FormState>();
  final _formKey2 = GlobalKey<FormState>();
  bool _error = true;
  var firstNameCtrl = TextEditingController();
  var lastNameCtrl = TextEditingController();
  var phoneNumberCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();

  var reenterPasswordCtrl = TextEditingController();
  var countryCodeController = TextEditingController();
  var cityCtrl = TextEditingController();
  var emailCtrl = TextEditingController();
  String userId;
  String verficationCode;
  List<PropertyCity> propertyCityList = [];
  List<Country> countryList = [];
  PropertyCity selectedCity;
  Country selectedCountry;
  bool showPassword = false;
  bool showPassword1 = false;

  bool isTopLoading = false;
  User user;

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
      var countriesMapList = res["list"]["country"];
      for (int i = 0; i < citiesMapList.length; i++) {
        propertyCityList.add(PropertyCity.fromJson(citiesMapList[i]));
      }
      for (int i = 0; i < countriesMapList.length; i++) {
        countryList.add(Country.fromJson(countriesMapList[i]));
      }
      setState(() {
        propertyCityList = propertyCityList;
        countryList = countryList;
      });
    }
  }

  void resendPassword(userId, context) async {
    setState(() {
      isTopLoading = true;
    });
    if (userId == null) {
      showToast("cannot resend password");
    }
    ProgressDialog progressDialog =
        showProgressDialog(ProgressDialog(context, isDismissible: false));
    var data = await resendCode({"current_user": userId});
    hideProgressDialog(progressDialog);
    if (data["ResponseCode"] == 1) {
      userId = data['User']['id'].toString();
      if (data['User']['activation_code'] != null) {
        verficationCode = data['User']['activation_code'].toString();
      }
    }
    setState(() {
      isTopLoading = false;
    });
  }

  void signup() async {
    //print(firstNameCtrl.text + " " + lastNameCtrl.text);
    String firstName = firstNameCtrl.text;
    String lastName = lastNameCtrl.text;
    String phoneNumber = phoneNumberCtrl.text;
    String password = passwordCtrl.text;
    String reenterPassword = reenterPasswordCtrl.text;
    if (selectedCountry == null) {
      showToast("please select country");
      return;
    }
    if (selectedCountry.sortname != "PK") {
      selectedCity = PropertyCity(
          id: "0", name: cityCtrl.text, createdAt: "", updatedAt: "");
    }
    // if(selectedCountry.sortname == "PK")
    if (selectedCity == null) {
      showToast("please select city");
      return;
    }
    if (password.length < 8) {
      showToast("password must be 8 charecter long");
      return;
    }
    if (reenterPassword != password) {
      showToast("password did not match");
      return;
    }

    if (phoneNumber.length < 10 || phoneNumber.length > 12) {
      showToast("invalid phone number");
      return;
    }
    if (phoneNumber[0] == "0") {
      phoneNumber = phoneNumber.substring(1, phoneNumber.length);
    }
    if (!checkEmail(emailCtrl.text)) {
      showToast("invalid email address");
      return;
    }
    phoneNumber = selectedCountry.countryCode + phoneNumber;

    if (selectedCountry.sortname == "PK" && phoneNumber.length != 12) {
      showToast("invalid phone number");
      return;
    }
    print("phone" + phoneNumber);

    // return;

    var request = {
      "first_name": firstName,
      "last_name": lastName,
      "phone": phoneNumber,
      "password": password,
      "city": selectedCity.id,
      "city_name": selectedCity.name,
      "email": emailCtrl.text,
      "country": selectedCountry.id
    };
    //print(request.toString());
    //    var request = new Map();
    ProgressDialog progressDialog =
        showProgressDialog(ProgressDialog(context, isDismissible: false));
    var data = await signUpService(request);
    hideProgressDialog(progressDialog);
    // print(data.toString());
    if (data["ResponseCode"] == 2) {
      print(data['User']);
      // var da =  data['User']['id'];
      // print(da);
      userId = data['User']['id'].toString();
      if (data['User']['activation_code'] != null) {
        // user = new User().fromJson(data['User']);
        showToast("please check your email");
        // if(selectedCountry.sortname != "PK") {
        verficationCode = data['User']['activation_code'].toString();
        dialog(userId);
        // }
      }
    }
  }

  @override
  void initState() {
    getPageData();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Sign up"),
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      body: Stack(
        children: [
          // TopLayout(),

          Wrap(
            children: [
              Container(
                transform: Matrix4.translationValues(0, -59, -13),
                child: Image.asset(
                  "assets/images/login_bg.gif",
                  width: getWidth(context),
                  height: getHeight(context) + 100,
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          // TopLayout(),
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 10, 0),
              child: isTopLoading
                  ? SizedBox(
                      height: 30,
                      width: 30,
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.white,
                      ),
                    )
                  : SizedBox(),
            ),
          ),
          Container(
            color: Colors.black.withOpacity(.72),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 60, 10, 0),
              child: Column(
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  //   child: Image.asset(
                  //     "assets/images/logo.png",
                  //     width: getWidth(context) / 2,
                  //   ),
                  // ),
                  // Text(
                  //   "Proceed With Your Information",
                  //   style: TextStyle(
                  //     fontSize: 30,
                  //     color: Colors.white,
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: new CommensModel(context).WIDTH / 9,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: firstNameCtrl,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                fillColor: whitecolor.withOpacity(0.6),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: whitecolor, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),

                                // filled: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: whitecolor,
                                ),
                                hintText: "FullName",
                                hintStyle: TextStyle(color: whitecolor),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Name';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                // email = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 0, left: 10, right: 10),
                            child: TextFormField(
                              controller: lastNameCtrl,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                fillColor: whitecolor.withOpacity(0.6),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: whitecolor, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),

                                // filled: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: whitecolor,
                                ),
                                hintText: "Last Name",
                                hintStyle: TextStyle(color: whitecolor),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Name';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                // email = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              margin: EdgeInsets.fromLTRB(0, 3, 0, 0),
                              height: 60,
                              decoration: new BoxDecoration(
                                borderRadius: BorderRadius.circular(16.0),
                                // color: Colors.white,
                              ),
                              // color: Colors.white,

                              child: Theme(
                                data: ThemeData(
                                  textTheme: TextTheme(
                                      subtitle1:
                                          TextStyle(color: Colors.green)),
                                ),
                                child: DropdownSearch<Country>(
                                  mode: Mode.DIALOG,
                                  items: countryList,
                                  hint: "Select Country",
                                  onChanged: (_) {
                                    // print("=>"+_.id);
                                    countryCodeController.text =
                                        "+" + _.countryCode.toString();

                                    setState(() {
                                      selectedCountry = _;
                                    });
                                  },
                                  dropdownSearchDecoration: InputDecoration(
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.lerp(
                                              BorderSide(color: Colors.white),
                                              BorderSide(color: Colors.white),
                                              1),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          gapPadding: 0),
                                      enabledBorder: OutlineInputBorder(
                                          borderSide: BorderSide.lerp(
                                              BorderSide(color: Colors.white),
                                              BorderSide(color: Colors.white),
                                              3),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                          gapPadding: 0),
                                      helperStyle:
                                          TextStyle(color: Colors.white),
                                      hintStyle: TextStyle(
                                        color: Colors.white,
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
                                    labelText: "Search a country",
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
                                        'Country',
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
                            ),
                          ),
                          if (selectedCountry != null)
                            if (selectedCountry.sortname == "PK")
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  margin: EdgeInsets.fromLTRB(0, 0, 0, 3),
                                  height: 60,
                                  decoration: new BoxDecoration(
                                    borderRadius: BorderRadius.circular(16.0),
                                    // color: Colors.white,
                                  ),
                                  // color: Colors.white,

                                  child: Theme(
                                    data: ThemeData(
                                      textTheme: TextTheme(
                                          subtitle1:
                                              TextStyle(color: Colors.green)),
                                    ),
                                    child: DropdownSearch<PropertyCity>(
                                      mode: Mode.DIALOG,
                                      items: propertyCityList,
                                      hint: "Select City",
                                      onChanged: (_) {
                                        // print("=>"+_.id);
                                        setState(() {
                                          selectedCity = _;
                                        });
                                      },
                                      dropdownSearchDecoration: InputDecoration(
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.lerp(
                                                  BorderSide(
                                                      color: Colors.white),
                                                  BorderSide(
                                                      color: Colors.white),
                                                  1),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              gapPadding: 0),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: BorderSide.lerp(
                                                  BorderSide(
                                                      color: Colors.white),
                                                  BorderSide(
                                                      color: Colors.white),
                                                  3),
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                              gapPadding: 0),
                                          helperStyle:
                                              TextStyle(color: Colors.white),
                                          hintStyle: TextStyle(
                                            color: Colors.white,
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
                                          color: darkTheme[
                                              "primaryBackgroundColor"],
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
                                ),
                              ),
                          if (selectedCountry != null)
                            if (selectedCountry.sortname != "PK")
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 10, left: 10, right: 10),
                                child: TextFormField(
                                  controller: cityCtrl,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                    fillColor: whitecolor.withOpacity(0.6),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: whitecolor, width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2)),

                                    // filled: true,
                                    prefixIcon: Icon(
                                      Icons.person,
                                      color: whitecolor,
                                    ),
                                    hintText: "Enter City",
                                    hintStyle: TextStyle(color: whitecolor),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  validator: (String value) {
                                    // if (value.isEmpty) {
                                    //   return 'Please Enter City';
                                    // }
                                    // return null;
                                  },
                                  onSaved: (String value) {
                                    // email = value;
                                  },
                                ),
                              ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 10, left: 10, right: 10),
                            child: TextFormField(
                              controller: emailCtrl,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                fillColor: whitecolor.withOpacity(0.6),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: whitecolor, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),

                                // filled: true,
                                prefixIcon: Icon(
                                  Icons.person,
                                  color: whitecolor,
                                ),
                                hintText: "Enter Email",
                                hintStyle: TextStyle(color: whitecolor),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Email';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                // email = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: Flex(
                              direction: Axis.horizontal,
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: IgnorePointer(
                                      ignoring: true,
                                      child: TextFormField(
                                        controller: countryCodeController,
                                        style: TextStyle(color: Colors.white),
                                        keyboardType: TextInputType.phone,
                                        decoration: InputDecoration(
                                          fillColor:
                                              whitecolor.withOpacity(0.6),
                                          enabledBorder: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20)),
                                              borderSide: BorderSide(
                                                  color: whitecolor, width: 2)),
                                          focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: BorderSide(
                                                  color: Colors.white,
                                                  width: 2)),
                                          hintStyle:
                                              TextStyle(color: whitecolor),
                                          border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                        ),
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'Please Enter Number';
                                          }
                                          return null;
                                        },
                                        onSaved: (String value) {
                                          // email = value;
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  flex: 4,
                                  child: TextFormField(
                                    controller: phoneNumberCtrl,
                                    style: TextStyle(color: Colors.white),
                                    keyboardType: TextInputType.phone,
                                    decoration: InputDecoration(
                                      fillColor: whitecolor.withOpacity(0.6),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          borderSide: BorderSide(
                                              color: whitecolor, width: 2)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 2)),

                                      // filled: true,
                                      prefixIcon: Icon(
                                        Icons.phone_rounded,
                                        color: whitecolor,
                                      ),
                                      hintText: "3123456789",
                                      hintStyle: TextStyle(color: whitecolor.withOpacity(.5)),
                                      border: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                    ),
                                    validator: (String value) {
                                      if (value.isEmpty) {
                                        return 'Please Enter Number';
                                      }
                                      return null;
                                    },
                                    onSaved: (String value) {
                                      // email = value;
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: passwordCtrl,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              obscureText: !showPassword,
                              decoration: InputDecoration(
                                suffixIcon: TouchableOpacity(
                                    onTap: () {
                                      setState(() {
                                        showPassword = !showPassword;
                                      });
                                    },
                                    child: Icon(
                                        showPassword
                                            ? Icons.remove_red_eye_outlined
                                            : Icons.remove_red_eye,
                                        color: Colors.grey)),
                                fillColor: whitecolor.withOpacity(0.6),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: whitecolor, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),

                                // filled: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: whitecolor,
                                ),
                                hintText: "Password",
                                hintStyle: TextStyle(color: whitecolor),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Password';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                // email = value;
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                bottom: 15, left: 10, right: 10),
                            child: TextFormField(
                              controller: reenterPasswordCtrl,
                              style: TextStyle(color: Colors.white),
                              keyboardType: TextInputType.text,
                              obscureText: !showPassword1,
                              decoration: InputDecoration(
                                suffixIcon: TouchableOpacity(
                                    onTap: () {
                                      setState(() {
                                        showPassword1 = !showPassword1;
                                      });
                                    },
                                    child: Icon(
                                        showPassword1
                                            ? Icons.remove_red_eye_outlined
                                            : Icons.remove_red_eye,
                                        color: Colors.grey)),
                                fillColor: whitecolor.withOpacity(0.6),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(20)),
                                    borderSide: BorderSide(
                                        color: whitecolor, width: 2)),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20),
                                    borderSide: BorderSide(
                                        color: Colors.white, width: 2)),

                                // filled: true,
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: whitecolor,
                                ),
                                hintText: "Confirm Password",
                                hintStyle: TextStyle(color: whitecolor),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(20)),
                              ),
                              validator: (String value) {
                                if (value.isEmpty) {
                                  return 'Please Enter Password';
                                }
                                return null;
                              },
                              onSaved: (String value) {
                                // email = value;
                              },
                            ),
                          ),
                          Padding(
                              padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
                              child: Container(
                                child: Row(
                                  children: [
                                    Checkbox(
                                      checkColor: Colors.white,
                                      // fillColor: MaterialStateProperty.resolveWith(getColor),
                                      value: termsAgree,
                                      onChanged: (bool value) {
                                        setState(() {
                                          termsAgree = value;
                                        });
                                      },
                                    ),
                                    TouchableOpacity(
                                      onTap: () async {
                                        print(PRIVACY_POLICY_URL);
                                        if (await canLaunch(
                                            PRIVACY_POLICY_URL)) {
                                          await launch(PRIVACY_POLICY_URL);
                                        } else {
                                          throw 'Could not launch $PRIVACY_POLICY_URL';
                                        }
                                      },
                                      child: Text(
                                        " Terms And Conditions",
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18),
                                      ),
                                    )
                                  ],
                                ),
                              )),
                          SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width / 1.1,
                            height: 50,
                            child: RaisedButton(
                              color: Color.fromRGBO(36, 154, 255, 1.0),
                              onPressed: () {
                                if (!termsAgree) {
                                  showToast(
                                      "please agree terms and condition to continue.");
                                  return;
                                }
                                if (_formKey.currentState.validate()) {
                                  print("successful");
                                  signup();
                                  return;
                                } else {
                                  print("UnSuccessfull");
                                }
                              },
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(50.0),
                                  side: BorderSide(
                                      color: Color.fromRGBO(36, 154, 255, 1.0),
                                      width: 2)),
                              textColor: Colors.white,
                              child: Text(
                                "Signup",
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Already have an account? ",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      TouchableOpacity(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, "login");
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  var userVerficationCode = '';

  dialog(var id) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: darkTheme["primaryBackgroundColor"],
            content: Container(
              height: 300,
              child: Stack(
                overflow: Overflow.visible,
                children: <Widget>[
                  Form(
                    key: _formKey2,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            "A Code Has Been Sent \n To Your Email / Phone Number",
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: MaterialInputField(
                            label: "verification code",
                            labelColor: Colors.white,
                            textColor: Colors.white,
                            onChanged: (val) {
                              setState(() {
                                userVerficationCode = val;
                              });
                            },
                          ),
                        ),
                        Flex(
                          direction: Axis.horizontal,
                          children: [

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomeElivatedButtonWidget(
                                  name: "Resend",
                                  onPress: () {
                                    resendPassword(userId, context);
                                  },
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: CustomeElivatedButtonWidget(
                                  name: "Submit",
                                  onPress: () {
                                    verficationCodes(userId, context);
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: TouchableOpacity(
                      onTap: () {
                        Navigator.of(context).pop();
                      },
                      child: CircleAvatar(
                        child: Icon(Icons.close),
                        // backgroundColor: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  verficationCodes(id, cont) async {
    print(userVerficationCode + '---' + verficationCode);
    if (userVerficationCode != verficationCode) {
      showToast("invalid verfication code");
      return;
    }
    if (userVerficationCode.length < 1) {
      showToast("code cannot be empty");
      return;
    }

    var request = {"code": userVerficationCode, "current_user": id};
    print('chk request: ' + request.toString());
    ProgressDialog progressDialog =
        showProgressDialog(ProgressDialog(context, isDismissible: false));
    var response = await activateService(request);
    hideProgressDialog(progressDialog);
    print('response: ' + response.toString());
    if (response["ResponseCode"] == 1) {
      User currentUser = new User();
      currentUser.fromJson(response["User"]);
      await setUser(currentUser);
      // Navigator.pushReplacementNamed(_keyLoader.currentContext, "/");
      Navigator.pushReplacementNamed(context, "/");
      // Navigator.of(cont).pop();
    }
  }
}

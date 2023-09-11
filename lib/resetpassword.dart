import 'package:flutter/material.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';

import 'Constraint/colors.dart';
import 'CustomeElivatedButton.dart';
import 'Helpers/SessionHelper.dart';
import 'MaterialInputField.dart';
import 'Model/User.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  @override
  void setState(fn){
    if(mounted){
      super.setState(fn);
    }
  }
  var passwordCtrl = TextEditingController();
  String verficationCode;
  String userId;
  String phone;
  bool showPassword = false;

  resetPassword() async {
    if(userId == null){
      showToast("something went wrong try again later");
      Navigator.pushReplacementNamed(context, "login");
    }
    var request = {"phone":phone,"password":passwordCtrl.text,"user_id":userId};
    showToast("processing your request please wait .. ");
    var res = await resetPasswordService(request);
    if(res != null){
      showToast("successfully changed password");
      Navigator.pushReplacementNamed(context, "login");
    }
  }
  @override
  void didChangeDependencies() {
    Map data = ModalRoute.of(context).settings.arguments;
    userId  = data["user_id"];
    phone = data["phone"];
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }
  final _formKey2= GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        /*Image.asset(
              "assets/images/login_bg.jpeg",
              width: getWidth(context),
              height: getHeight(context),
              fit: BoxFit.cover,
            ),
            // TopLayout(),
            Container(
              color: Colors.black.withOpacity(.6),
            ),*/

        children: [
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/images/login_bg.jpeg',
              fit: BoxFit.fill,
            ),
          ),
          Container(
            color: Colors.black.withOpacity(.6),
          ),
          Container(
            padding: EdgeInsets.only(top: 100),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 50,
                    ),
                    Text(
                      "Reset Password?",
                      style: TextStyle(
                          color: whitecolor,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "We just need you to enter new password must be 8 character long",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    SizedBox(
                      height: 50,
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
                          fillColor: whitecolor.withOpacity(0.6),
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
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  BorderSide(color: whitecolor, width: 2)),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                              borderSide:
                                  BorderSide(color: Colors.white, width: 2)),
                          prefixIcon: Icon(
                            Icons.lock,
                            color: whitecolor,
                          ),
                          hintText: "New Password",
                          hintStyle: TextStyle(color: whitecolor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
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
                    SizedBox(
                      height: 50,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.1,
                      height: 50,
                      child: RaisedButton(
                        color: Color.fromRGBO(36, 154, 255, 1.0),
                        onPressed: () {
                          if (_formKey2.currentState.validate()) {
                            print("successful");
                            resetPassword();
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
                          "Reset Password",
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "Do you want to login? ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        InkWell(
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
            ),
          ),
        ],
      ),
    );
  }
}


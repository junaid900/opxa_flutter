import 'package:flutter/material.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/Network/network.dart';

import 'Constraint/colors.dart';
import 'CustomeElivatedButton.dart';
import 'Helpers/SessionHelper.dart';
import 'MaterialInputField.dart';
import 'Model/User.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  var passwordCtrl = TextEditingController();
  String verficationCode;
  String userId;
  getOTP() async {
    var request = {"phone":passwordCtrl.text};
    showToast("sending a code to your number/email");
    var res = await getOtpService(request);
    if(res != null){
      userId = res['response']['id'].toString();
      if (res['response']['activation_code'] != null) {
        verficationCode = res['response']['activation_code'].toString();
        dialog(userId);
      }
      print(res);

    }
  }
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(

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
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.lock,
                      color: Colors.white,
                      size: 50,
                    ),
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                          color: whitecolor,
                          fontSize: 30,
                          fontWeight: FontWeight.w700),
                    ),
                    Text(
                      "We just need your phone number \n to send you password reset",
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
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          fillColor: whitecolor.withOpacity(0.6),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              borderSide:
                                  BorderSide(color: whitecolor, width: 2)),
                          // focusedBorder: OutlineInputBorder(
                          //     borderRadius: BorderRadius.circular(20),
                          //     borderSide:
                          //         BorderSide(color: Colors.white, width: 2)),
                          prefixIcon: Icon(
                            Icons.phone_rounded,
                            color: whitecolor,
                          ),
                          // suffixIcon: Icon(
                          //   Icons.remove_red_eye_outlined,
                          //   color: whitecolor,
                          // ),
                          hintText: "Phone: 923XXXXXXXXX",
                          hintStyle: TextStyle(color: whitecolor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
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
                          if (_formKey.currentState.validate()) {
                            print("successful");
                            getOTP();
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
                          "Don't have an Account? ",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pushReplacementNamed(context, "signup");
                          },
                          child: Text(
                            "Register",
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
  var userVerficationCode = '';
  final _formKey2 = GlobalKey<FormState>();
  dialog(var id) {

    // var _formKey2;
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: darkTheme["primaryBackgroundColor"],
            content: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                Positioned(
                  right: -40.0,
                  top: -40.0,
                  child: InkResponse(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: CircleAvatar(
                      child: Icon(Icons.close),
                      backgroundColor: Colors.red,
                    ),
                  ),
                ),
                Form(
                  key: _formKey2,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CustomeElivatedButtonWidget(
                          name: "Submit",
                          onPress: () {
                            verficationCodes(userId, context);
                          },
                        ),
                        // child: RaisedButton(
                        //   child: Text("Submit"),
                        //   onPressed: () {
                        //     // if (_formKey.currentState.validate()) {
                        //     //   _formKey.currentState.save();
                        //     // }
                        //   },
                        // ),
                      )
                    ],
                  ),
                ),
              ],
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
    if(userId != null){
      Navigator.pushReplacementNamed(context, "reset_password",arguments: {"user_id":userId,"phone":passwordCtrl.text});
    }


    // var request = {"code": userVerficationCode, "current_user": id};
    // print('chk request: ' + request.toString());
    // var response = await activateService(request);
    // print('response: ' + response.toString());
    // if (response["ResponseCode"] == 1) {
    //   User currentUser = new User();
    //   currentUser.fromJson(response["User"]);
    //   await setUser(currentUser);
    //   // Navigator.pushReplacementNamed(_keyLoader.currentContext, "/");
    //   // Navigator.of(cont).pop();
    // }
  }
}


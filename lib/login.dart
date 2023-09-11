import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:qkp/CommensModel.dart';
import 'package:qkp/Constraint/TouchableOpacity.dart';
import 'package:qkp/Network/network.dart';
import 'package:qkp/signup.dart';

import 'Constraint/colors.dart';
import 'Helpers/SessionHelper.dart';
import 'Model/User.dart';
import 'Network/constant.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var emailCtrl = TextEditingController();
  var passwordCtrl = TextEditingController();
  bool isLoading = false;
  bool isDisabled = false;
  final LocalAuthentication auth = LocalAuthentication();
  bool termsAgree = false;
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String _authorized = 'Not Authorized';
  bool _isAuthenticating = false;
  bool showPassword = false;

  // var context;
  final GlobalKey<State> _keyLoader = new GlobalKey<State>();

  // bool _error = true;
  //
  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometrics;
    });
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;
    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometrics;
    });
  }

  Future<void> _authenticate() async {
    bool authenticated = false;
    try {
      setState(() {
        _isAuthenticating = true;
        _authorized = 'Authenticating';
      });
      authenticated = await auth.authenticateWithBiometrics(
          localizedReason: 'Scan your fingerprint to authenticate',
          useErrorDialogs: true,
          stickyAuth: true);
      setState(() {
        _isAuthenticating = false;
        _authorized = 'Authenticating';
      });
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    final String message = authenticated ? 'Authorized' : 'Not Authorized';
    setState(() {
      _authorized = message;
    });
  }

  void _cancelAuthentication() {
    auth.stopAuthentication();
    setState(() {
      _isAuthenticating = false;
    });
  }

  void login() async {
    print(emailCtrl.text + " " + passwordCtrl.text);
    String email = emailCtrl.text;
    String password = passwordCtrl.text;
    if (email[0] == "+") {
      email = email.substring(1, email.length);
      // return;
    }
    print(email);
    var request = <String, String>{"phone": email, "password": password};
    print(request.toString());

    //    var request = new Map();
    var data = await loginService(request);
    if (data != null) {
      User currentUser = new User();
      currentUser.fromJson(data["User"]);
      await setUser(currentUser);
      // Navigator.pushReplacementNamed(_keyLoader.currentContext, "/");
      Navigator.pushReplacementNamed(context, "/");
    }
  }

  manageLoading() {
    setState(() {
      isLoading = !isLoading;
      isDisabled = !isDisabled;
    });
  }

  getPageData() async {
    // print("0000" + await getString(FIRST_TIME));
    // var data = await getString(FIRST_TIME);
    // if (data == null || data == '' || data.length < 1) {
    //   setString(FIRST_TIME, "OK");
    //   Get.to(WizardIntroScreenWidget());
    // }
  }

  @override
  void initState() {
    getPageData();
    _getAvailableBiometrics();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var _width = MediaQuery.of(context).size.width;
    var _height = MediaQuery.of(context).size.height;

    setState(() {
      // this.context = context;
    });
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Login"),
      //   elevation: 0,
      //   centerTitle: true,
      // ),
      backgroundColor: darkTheme["primaryBackgroundColor"],
      body: Container(
        child: Stack(
          children: [
            Wrap(
              children: [
                Container(
                  transform: Matrix4.translationValues(0, -59, -13),
                  decoration: BoxDecoration(),
                  child: Image.asset(
                    "assets/images/login_bg.gif",
                    width: getWidth(context),
                    height: getHeight(context) + 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 600,
            ),
            // Image.asset(
            //   "assets/images/login_bg.jpeg",
            //   width: getWidth(context),
            //   height: getHeight(context),
            //   fit: BoxFit.cover,
            // ),
            // TopLayout(),
            Container(
              color: Colors.black.withOpacity(.7),
            ),
            Padding(
              // padding: const EdgeInsets.all(8.0),
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Text("Powered By",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600
                                  ),),
                                Image.asset('assets/images/mjcoders2.png',width: getWidth(context)*.30),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 180,
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                      //   child: Row(
                      //     mainAxisAlignment: MainAxisAlignment.center,
                      //     children: [
                      //       Text(
                      //         "OPXA",
                      //         style: TextStyle(
                      //             color: Colors.blue,
                      //             fontSize: 30,
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //       Text(
                      //         ".com",
                      //         style: TextStyle(
                      //             color: Colors.white,
                      //             fontSize: 30,
                      //             fontWeight: FontWeight.bold
                      //         // fontWeight: FontWeight.bold
                      //         ),
                      //       ),
                      //     ],
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
                                height: 24,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    bottom: 15, left: 10, right: 10),
                                child: TextFormField(
                                  controller: emailCtrl,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    // fillColor: whitecolor.withOpacity(0.6),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                        borderSide: BorderSide(
                                            color: whitecolor, width: 2)),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(20),
                                        borderSide: BorderSide(
                                            color: Colors.white, width: 2)),

                                    prefixIcon: Icon(
                                      Icons.phone,
                                      color: whitecolor,
                                    ),
                                    hintText: "Phone: 923XXXXXXXXX",
                                    hintStyle: TextStyle(color: whitecolor),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  validator: (String value) {
                                    if (value.length < 3) {
                                      return 'Please Enter Phone number';
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
                                  controller: passwordCtrl,
                                  style: TextStyle(color: Colors.white),
                                  keyboardType: TextInputType.text,
                                  obscureText: !showPassword,
                                  decoration: InputDecoration(
                                    fillColor: whitecolor,
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
                                      Icons.lock,
                                      color: whitecolor,
                                    ),

                                    hintText: "Password",
                                    hintStyle: TextStyle(color: whitecolor),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(20)),
                                  ),
                                  validator: (String value) {
                                    if (value.length < 4) {
                                      return 'Password cannot be less than 8';
                                    }
                                    return null;
                                  },
                                  onSaved: (String value) {
                                    // email = value;
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Builder(
                                  builder: (context) => Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                          onPressed: !isDisabled
                                              ? () async {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    // CommensModel.showSnakeBar("Proceeding information", context);
                                                    FocusScope.of(context)
                                                        .unfocus();
                                                    // Navigator.pushReplacementNamed(context, "/");
                                                    manageLoading();
                                                    await login();
                                                    manageLoading();
                                                  }
                                                }
                                              : null,
                                          style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateColor
                                                      .resolveWith((states) =>
                                                          Colors.transparent),
                                              padding:
                                                  MaterialStateProperty.all(
                                                      EdgeInsets.fromLTRB(
                                                          0, 0, 0, 0))),
                                          child: Container(
                                            height: 50,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Color.fromRGBO(
                                                  36, 154, 255, 1.0),
                                              // .withOpacity(.5),
                                            ),
                                            alignment: Alignment.center,
                                            padding: EdgeInsets.all(8),
                                            width:
                                                new CommensModel(context).WIDTH,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Login",
                                                  style: TextStyle(
                                                      color: Colors.white),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                isLoading
                                                    ? SizedBox(
                                                        height: 20.0,
                                                        width: 20,
                                                        child: CircularProgressIndicator(
                                                            valueColor:
                                                                AlwaysStoppedAnimation(
                                                                    Colors
                                                                        .white),
                                                            strokeWidth: 2.0))
                                                    : SizedBox(),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TouchableOpacity(
                                onTap: () {
                                  Navigator.pushNamed(
                                      context, 'forget_password');
                                },
                                child: Text(
                                  "Forgot Password",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              TouchableOpacity(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => SignUp()));
                                },
                                child: Text(
                                  "Signup",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   crossAxisAlignment: CrossAxisAlignment.center,
                      //   children: [
                      //     Text(
                      //       "Did'nt have any account? ",
                      //       style: TextStyle(color: Colors.black, fontSize: 16),
                      //     ),
                      //     InkWell(
                      //       onTap: () {
                      //         Navigator.pushReplacementNamed(context, 'signup');
                      //       },
                      //       child: Text(
                      //         "Signup",
                      //         style: TextStyle(
                      //             fontSize: 18,
                      //             color: darkTheme["primaryBackgroundColor"],
                      //             fontWeight: FontWeight.bold),
                      //       ),
                      //     )
                      //   ],
                      // )
                      SizedBox(
                        height: 20,
                      ),

                      // GestureDetector(
                      //   onTap:() async {
                      //     final LocalAuthentication localAuthentication = LocalAuthentication();
                      //     // bool isBiometricSupported = await localAuthentication.();
                      //     print(_isAuthenticating);
                      //     bool isAuthenticated = await localAuthentication.authenticate(
                      //       localizedReason: 'Please complete the biometrics to proceed.',
                      //       biometricOnly: true,
                      //     );
                      //     _isAuthenticating
                      //         ? _cancelAuthentication()
                      //         : _authenticate();
                      //
                      //   },
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       border: Border.all(color: Colors.white),
                      //       borderRadius: BorderRadius.circular(7),
                      //     ),
                      //     child: Image.network(
                      //       "https://pngimg.com/uploads/fingerprint/fingerprint_PNG56.png",
                      //       width: 100,
                      //       height: 100,
                      //       color: Colors.white,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

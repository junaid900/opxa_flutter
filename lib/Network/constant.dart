import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:qkp/BottomTabNavigation.dart';
import 'package:qkp/Constraint/Dialog.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/MarketScreen.dart';
import 'package:qkp/Network/network.dart';
import 'package:encrypt/encrypt.dart' as encrypt;


const APP_VERSION = "1.3";
// const BaseUrl = 'https://zameenexchange.com/';
// const url = 'https://zameenexchange.com/';
// const BaseUrl = 'http://127.0.0.1:8000/';
// const url = 'http://127.0.0.1:8000/';
const url = 'https://opxa.junaidaliansari.com/';
const BaseUrl = 'https://opxa.junaidaliansari.com/';
const propertyDefaultUrl = 'uploads/extra/';
const AUDIO_DIRECTORY = "audio";
const MAIN_APP_DIRECTAORY = "QKP";

const ConsumerKey = 'ck_498bf48f2a3b541898dc3e88f80d7b704347d79d';
const ConsumerSecret = 'cs_dee74759c9824663824f5111a44d9eb9db06d57b';
const dateFormat = 'yMMMd';
const preGEO_API = "AIzaSyD2jmquvyaoT3aPF8E88tNxfaymi7SoHkI";
const GEO_API = "AIzaSyC4HqZf-zANxtQqW0riYOrRKdrXvzMqCqM";
const NOTIFICATION_URL = "https://fcm.googleapis.com/fcm/send";
const FCM_SERVER_KEY =
    "AAAAJZ8EI1M:APA91bFK-oRk0mkc9HyYR4g1LYTmHsiIowI_-O-zH7TM7de6QnOidd-Jya5Wwg6n0dPf8MH_AKqKmL1Nm5w4vhEv9wR-sM0-KX1qVRRaojGaNFG8cbuEP7-tM2UFaisXkyYUgkb8eFp1";
/* EndPoint */
const categories = 'categories';

const accessAllowed = true;
//Theme COlors
const isDarkTheme = true;

const darkTheme = <String, Color>{
  "primaryColor": Color.fromRGBO(40, 55, 71, 1.0),
  "primaryLightColor": Color.fromRGBO(52, 73, 94, 1.0),
  "primaryTextColor": Colors.white,
  "primaryDarkColor": Colors.black87,
  "primaryAccientColor": Colors.grey,
  "primaryBlack": Colors.black,
  "primaryWhite": Colors.white,
  "primaryBackgroundColor": Color.fromRGBO(32, 42, 73, 1.0),
  "cardBackground": Color.fromRGBO(49, 65, 102, 1.0),
  "walletBackground": Color.fromRGBO(46, 57, 85, 1.0),
  "primaryBackgroundLight": Color.fromRGBO(49, 65, 102, .8),
  "secondaryColor": Color.fromRGBO(36, 154, 255, 1.0),
  "bgCellColor": Color.fromRGBO(19, 25, 46, 1.0),
  "popupBackground": Color.fromRGBO(48, 63, 103, 1),
  "greenText": Color.fromRGBO(0, 255, 170, 1),
  "redText": Color.fromRGBO(255, 43, 43, 1),
  "greyFil": Color.fromRGBO(194, 194, 194, 0.4),
  "bgArrow": Color.fromRGBO(26, 34, 60, 1),
  "dividerColor": Color.fromRGBO(67, 77, 102, 1),
  "tabsColor": Color.fromRGBO(26, 34, 60, 1),
};
Color appbg = darkTheme['primaryBackgroundColor'];
Color primaryColor = darkTheme['primaryBackgroundColor'];
const lightTheme = <String, Color>{
  "primaryColor": Color.fromRGBO(242, 242, 242, 1.0),
  "primaryLightColor": Colors.white,
  "primaryTextColor": Colors.black87,
  "primaryDarkColor": Colors.black12,
  "primaryAccientColor": Colors.blue,
  "primaryBackgroundColor": Colors.white,
};

const List months = [
  'jan',
  'feb',
  'mar',
  'apr',
  'may',
  'jun',
  'jul',
  'aug',
  'sep',
  'oct',
  'nov',
  'dec'
];

String capitalize(String data) {
  return "${data[0].toUpperCase()}${data.substring(1)}";
}

var darkTextColor = darkTheme["primaryTextColor"];

/* Share Preferences Key */

const IS_LOGGED_IN = 'IS_LOGGED_IN';
const TOKEN = 'TOKEN';
const USER_ID = 'USER_ID';
const USERNAME = 'USERNAME';
const FIRST_NAME = 'FIRST_NAME';
const LAST_NAME = 'LAST_NAME';
const USER_DISPLAY_NAME = 'USER_DISPLAY_NAME';
const USER_EMAIL = 'USER_EMAIL';
const USER_ROLE = 'USER_ROLE';
const AVATAR = 'AVATAR';
const PASSWORD = 'PASSWORD';
const PROFILE_IMAGE = 'PROFILE_IMAGE';
const USER = "user4";
const FIRST_TIME = "first_time_loading1";
const PRIVACY_POLICY_URL = "https://opxa.com/privacy.html";
/* font sizes*/
const textSizeSmall = 12;
const textSizeSMedium = 14;
const textSizeMedium = 16;
const textSizeLargeMedium = 18;
const textSizeNormal = 20;
const textSizeLarge = 24;
const textSizeXLarge = 28;
const textSizeXXLarge = 30;
const textSizeBig = 50;

void showToast(String message) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.black87,
      textColor: Colors.white,
      fontSize: 16.0);
}

void showDynamicToast(
  String message, {
  Color color = Colors.black,
  Color textColor = Colors.white,
  length = Toast.LENGTH_SHORT,
  gravity = ToastGravity.BOTTOM,
  fontSize = 16.0,
}) {
  Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: textColor,
      fontSize: fontSize);
}

double getHeight(final context) {
  return MediaQuery.of(context).size.height;
}

double getWidth(final context) {
  return MediaQuery.of(context).size.width;
}

/// Determine the current position of the device.
///
/// When the location services are not enabled or permissions
/// are denied the `Future` will return an error.
Future<Position> getCurrentLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition();
}

String genrateMarkerId() {
  String dateTime = new DateTime.now().toString();
  int random = Random().nextInt(9999999);
  int random2 = Random().nextInt(9999999);
  int random3 = Random().nextInt(9999999);

  return dateTime + random3.toString() + random.toString() + random2.toString();
}

String getAreaList(index) {
  int newIndex = int.tryParse(index);
  newIndex = newIndex;
  final liststring = [
    '1',
    '3',
    '5',
    '7',
    '9',
    '11',
    '13',
    '15',
    '17',
    '19',
    '21',
    '23',
    '25',
    '27',
    '29',
    '31',
    '33',
    '35',
    '37',
    '39',
    '41',
    '43',
    '45',
    '47',
    '49',
    '51',
    '53',
    '55',
    '57',
    '59',
    '61',
    '63',
    '65',
    '67',
    '69',
    '71',
    '73',
    '75',
    '77',
    '79',
    '81',
    '83',
    '85',
    '87',
    '89',
    '91',
    '93',
    '95',
    '97',
    '99',
    '101',
    '103',
    '105',
    '107',
    '109',
    '111',
    '113',
    '115',
    '117',
    '119',
    '121',
    '123',
    '125',
    '127',
    '129',
    '131',
    '133',
    '135',
    '137',
    '139',
    '141',
    '143',
    '145',
    '147',
    '149',
    '151',
    '153',
    '155',
    '157',
    '159',
    '161',
    '163',
    '165',
    '167',
    '169',
    '171',
    '173',
    '175',
    '177',
    '179',
    '181',
    '183',
    '185',
    '187',
    '189',
    '191',
    '193',
    '195',
    '197',
    '199',
    '201',
    '203',
    '205',
    '207',
    '209',
    '211',
    '213',
    '215',
    '217',
    '219',
    '221',
    '223',
    '225',
    '227',
    '229',
    '231',
    '233',
    '235',
    '237',
    '239',
    '241',
    '243',
    '245',
    '247',
    '249',
    '251',
    '253',
    '255',
    '257',
    '259',
    '261',
    '263',
    '265',
    '267',
    '269',
    '271',
    '273',
    '275',
    '277',
    '279',
    '281',
    '283',
    '285',
    '287',
    '289',
    '291',
    '293',
    '295',
    '297',
    '299',
    '301',
    '303',
    '305',
    '307',
    '309',
    '311',
    '313',
    '315',
    '317',
    '319',
    '321',
    '323',
    '325',
    '327',
    '329',
    '331',
    '333',
    '335',
    '337',
    '339',
    '341',
    '343',
    '345',
    '347',
    '349',
    '351',
    '351',
    '353',
    '355',
    '357',
    '359',
    '361',
    '363',
    '365',
    '367',
    '369',
    '371',
    '373',
    '375',
    '377',
    '379',
    '381',
    '383',
    '385',
    '387',
    '389',
    '391',
    '393',
    '395',
    '397',
    '399',
    '401',
    '403',
    '405',
    '407',
    '409',
    '411',
    '413',
    '415',
    '417',
    '419',
    '421',
    '423',
    '425',
    '427',
    '429',
    '431',
    '433',
    '435',
    '437',
    '439',
    '441',
    '443',
    '445',
    '447',
    '449',
    '451',
    '453',
    '455',
    '457',
    '459',
    '461',
    '463',
    '465',
    '467',
    '469',
    '471',
    '473',
    '475',
    '477',
    '479',
    '481',
    '483',
    '485',
    '487',
    '489',
    '491',
    '493',
    '495',
    '497',
    '499',
    '501',
    '503',
    '505',
    '507',
    '509',
    '511',
    '513',
    '515',
    '517',
    '519',
    '521',
    '523',
    '525',
    '527',
    '529',
    '531',
    '533',
    '535',
    '537',
    '539',
    '541',
    '543',
    '545',
    '547',
    '549',
    '551',
    '553',
    '555',
    '557',
    '559',
    '561',
    '563',
    '565',
    '567',
    '569',
    '571',
    '573',
    '575',
    '577',
    '579',
    '581',
    '583',
    '585',
    '587',
    '589',
    '591',
    '593',
    '595',
    '597',
    '599',
    '601',
    '603',
    '605',
    '607',
    '609',
    '611',
    '613',
    '615',
    '617',
    '619',
    '621',
    '623',
    '625',
    '627',
    '629',
    '631',
    '633',
    '635',
    '637',
    '639',
    '641',
    '643',
    '645',
    '647',
    '649',
    '651',
    '653',
    '655',
    '657',
    '659',
    '661',
    '663',
    '665',
    '667',
    '669',
    '671',
    '673',
    '675',
    '677',
    '679',
    '681',
    '683',
    '683',
    '685',
    '687',
    '689',
    '691',
    '693',
    '695',
    '697',
    '699',
    '701',
    '703',
    '705',
    '707',
    '709',
    '711',
    '713',
    '715',
    '717',
    '719',
    '721',
    '723',
    '725',
    '727',
    '729',
    '731',
    '733',
    '735',
    '737',
    '739',
    '741',
    '743',
    '745',
    '747',
    '749',
    '751',
    '753',
    '755',
    '757',
    '759',
    '761',
    '763',
    '765',
    '767',
    '769',
    '771',
    '773',
    '775',
    '777',
    '779',
    '781',
    '783',
    '785',
    '787',
    '789',
    '791',
    '793',
    '795',
    '797',
    '799',
    '801',
    '803',
    '805',
    '807',
    '809',
    '811',
    '813',
    '815',
    '817',
    '819',
    '821',
    '823',
    '825',
    '827',
    '829',
    '831',
    '833',
    '835',
    '837',
    '839',
    '841',
    '843',
    '845',
    '847',
    '849',
    '851',
    '853',
    '855',
    '857',
    '859',
    '861',
    '863',
    '865',
    '867',
    '869',
    '871',
    '873',
    '875',
    '877',
    '879',
    '881',
    '883',
    '885',
    '887',
    '889',
    '891',
    '893',
    '895',
    '897',
    '899',
    '901',
    '903',
    '905',
    '907',
    '909',
    '911',
    '913',
    '915',
    '917',
    '919',
    '921',
    '923',
    '925',
    '927',
    '929',
    '931',
    '933',
    '935',
    '937',
    '939',
    '941',
    '943',
    '945',
    '947',
    '949',
    '951',
    '953',
    '955',
    '957',
    '959',
    '961',
    '963',
    '965',
    '967',
    '969',
    '971',
    '973',
    '975',
    '977',
    '979',
    '981',
    '983',
    '985',
    '987',
    '989',
    '991',
    '993',
    '995',
    '997',
    '999'
  ];
  final listMap = liststring.asMap();
  return listMap[newIndex];
}

Future<String> _localDocPath() async {
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<bool> checkFilePath(path) async {
  var syncPath = await path;
  File(syncPath).exists();
  return File(syncPath).exists();
}

Future<bool> checkDirectoryPath(path) async {
  var syncPath = await path;
  return Directory(syncPath).exists();
  ;
}

Future<String> getAudioDirectory() async {
  var path = await getApplicationDocumentsDirectory();
  var dPath = path.path + "/" + MAIN_APP_DIRECTAORY + "/" + AUDIO_DIRECTORY;
  return dPath;
}

Future<String> createDirectory(String cow) async {
  final folderName = cow;
  var status = await Permission.storage.status;
  if (!status.isGranted) {
    await Permission.storage.request();
  }
  final directory = await getApplicationDocumentsDirectory();
  final path = Directory(directory.path + "/" + "$folderName");
  if ((await path.exists())) {
    return path.path;
  } else {
    path.create();
    return path.path;
  }
}

playHammerAudio() async {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  await assetsAudioPlayer.open(
    Audio("assets/audios/hammer_audio.mp3"),
    autoStart: true,
    showNotification: false,
  );
  assetsAudioPlayer.play();
}

playStopSound() async {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  await assetsAudioPlayer.open(
    Audio("assets/audios/stop_audio.mp3"),
    autoStart: true,
    showNotification: false,
  );
  assetsAudioPlayer.play();
}
// bool isPlaying = false;
playBidSound() async {

  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  await assetsAudioPlayer.open(
    Audio("assets/audios/coin_audio.mp3"),
    autoStart: true,
    showNotification: false,
  );
  // if(!isPlaying)
  assetsAudioPlayer.play();
  // isPlaying = true;

}

playSniperLoadSound() async {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  await assetsAudioPlayer.open(
    Audio("assets/audios/sniper_sound.mp3"),
    autoStart: true,
    showNotification: false,
  );
  assetsAudioPlayer.play();
}

playMachineGunSound() async {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  await assetsAudioPlayer.open(
    Audio("assets/audios/machine_gun_sound.mp3"),
    autoStart: true,
    showNotification: false,
  );
  assetsAudioPlayer.play();
}

playWarningSound() async {
  AssetsAudioPlayer assetsAudioPlayer = AssetsAudioPlayer();

  await assetsAudioPlayer.open(
    Audio("assets/audios/warning_sound.mp3"),
    autoStart: true,
    showNotification: false,
  );
  assetsAudioPlayer.play();
}

navBidSuccessful(context) {
  Navigator.popUntil(context, ModalRoute.withName("/"));
}
popAllPreviousAndStart(context,Widget widget){
  Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              widget),
          (Route<dynamic> route) => false);
}
ProgressDialog showProgressDialog(ProgressDialog p, {message = "Please Wait"}) {
  p.update(message: message);
  p.show();
  return p;
}

hideProgressDialog(ProgressDialog p) {
  p.hide();
}

ProgressDialog showShortDialog(context, {message1: "please wait..."}) {

  ProgressDialog progressDialog = ProgressDialog(context, isDismissible: false);
  progressDialog.update(message: message1);
  progressDialog.show();
  return progressDialog;
}

checkEmail(val) {
  bool emailValid = RegExp(
          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
      .hasMatch(val);
  return emailValid;
}

checkDoubleValue(parse) {
  //print('check --- '+parse.toString());
  if (parse == null) {
    return 0.0;
  }
  try {
    return parse;
  } catch (e) {
    showToast("Error Occured" + e.toString());
    return 0.0;
  }
}

onNotificationReceive(context, {data = null}) {
  if (data["message"]["data"]["type"] == "Intransfer") {
    hammerDialog(context);
  }
}

Future<String> getApiToken() async {
  try {
    String token = (await getUser()).authToken;
    String apiToken = APIKEY + "_tkn_" + token;
    Codec<String, String> stringToBase64 = utf8.fuse(base64);
    String encodedKey = stringToBase64.encode(apiToken);
    // print("KEY:=>" + encodedKey);
    return encodedKey;
  } catch (e) {
    return null;
  }
}

bool isNumber(String s) {
  if (s == null) {
    return false;
  }
  if (s.length > 15) {
    return false;
  }
  return double.tryParse(s) != null &&
      s.contains(".") == false &&
      double.tryParse(s) > 0;
}

const encryptKey = "MJCODERS@@TAYYABIRFANCOMPANY{@2}";
const ivTxt = "TAYYAB<><>()&*^%";

Future<String> encryptString(str) async {
  final plainText = str;
  var key = encrypt.Key.fromUtf8(encryptKey);
  final iv = encrypt.IV.fromUtf8(ivTxt);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final encrypted = await encrypter.encrypt(plainText, iv: iv);
  return encrypted.base64;
}

Future<String> decryptString(enData) async {
  var key = encrypt.Key.fromUtf8(encryptKey);
  final encrypter =
      encrypt.Encrypter(encrypt.AES(key, mode: encrypt.AESMode.cbc));
  final iv = encrypt.IV.fromUtf8(ivTxt);
  String data = await encrypter.decrypt64(enData, iv: iv).toString();
  return data;
}

int convertToNumber(num) {
  try {
    int number = int.tryParse(num.toString());
    if (number == null) {
      return 0;
    }
    if (number > 0) {
      return number;
    } else {
      return 0;
    }
  } catch (e) {
    return 0;
  }
}

double convertToDouble(num) {
  try {
    double number = double.tryParse(num);
    return checkDoubleValue(number);
  } catch (e) {
    return 0;
  }
}
void showDynamicSnakBar(title, message, {duration = 4000,snackPosition = SnackPosition.TOP}) async {
  try {
    // final func = (){};
    var a = await Future.delayed(const Duration(milliseconds: 500), () {
      Get.snackbar(
          title, message,
          snackPosition: snackPosition,
          duration: Duration(milliseconds: duration),
          backgroundColor: Colors.white.withOpacity(.6),
          onTap: (a){
            print("here");
          }
      );
    });
    playBidSound();
  } catch (e) {
    print(e);
  }
}
void showSnakBar(title, message, {duration = 4000}) async {
  try {
    // final func = (){};
    var a = await Future.delayed(const Duration(milliseconds: 500), () {
      Get.snackbar(
        title, message,
        snackPosition: SnackPosition.TOP,
        duration: Duration(milliseconds: duration),
        backgroundColor: Colors.white.withOpacity(.6),
        onTap: (a){
            print("here");
        }
      );
    });
    playBidSound();
  } catch (e) {
    print(e);
  }
}
Iterable<int> get positiveIntegers sync* {
  int i = 0;
  while (true) yield i++;
}


import 'dart:convert';

// import 'dio';
import 'dart:io';
import 'package:get/get.dart' as op_get;
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Network/constant.dart';
import 'package:qkp/login.dart';

// String baseUrl = "https://zameenexchange.com/api";
String baseUrl = "https://opxa.junaidaliansari.com/api";
// String baseUrl = "http://127.0.0.1:8000/api";
String APIKEY = "TA_MJCODERS_QKPAPPKEY";

Future<Map<String, String>> header() async {
  var hdrs = {
    HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
    HttpHeaders.cacheControlHeader: 'no-cache',
    HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
    "ApiKey": await getApiToken(),
  };
  return hdrs;
}
Future<bool> hasNetwork() async {
  try {
    final result = await InternetAddress.lookup("google.com");
    print(result);
    return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
  } on SocketException catch (_) {
    print(_);
    return false;
  }
}

Future<Map<String, dynamic>> loginService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/signin",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> signUpService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/signup",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    showToast(data["ResponseHeader"]["ResponseMessage"]);

    if (data["ResponseHeader"]["ResponseCode"] != 1) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      // return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> myAssetsService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/myassets",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> buyPackages(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/buypackages",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getpackages() async {
  try {
    // var request = data;
    var response = await get(
      baseUrl + "/getpackages",
      headers: await header(),
    );
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //  showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> fileDropDownService() async {
  try {
    // var request = data;
    var response = await get(
      baseUrl + "/dropdownData",
      headers: await header(),
    );
    // body: jsonEncode(request));
    // print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> sellFilesService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/sellfiles",
        headers: await header(), body: jsonEncode(request));
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //  showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> sellLimitFilesService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/selllimit",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> addFileService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/savefilesdata",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> bidFiles(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/bidfiles",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getMyAssetsService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/fileassets",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getOwnerAction(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/owner_action_assets",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> postFile(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/postfile",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> deleteFilePost(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/delete_file_post",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> activateService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/activate",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> ownerFilesService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/getownerfiles",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    // showToast(data["ResponseHeader"]["ResponseMessage"]);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> updatePostFile(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/update_post_files",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    // showToast(data["ResponseHeader"]["ResponseMessage"]);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> loadFileChart(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/file_graph",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getTimerinTransferService(data) async {
  try {
    var request = data;
    var response = await get(
      baseUrl + "/intransfer_time?owner_id=" + data["owner_id"],
      headers: await header(),
      // body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> clearIntransferService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/inactivehistory",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getFileDetailsService(file_id) async {
  print(baseUrl + "/5?file_id=" + file_id);
  try {
    //var request = data;
    var data;
    var response = await get(
      baseUrl + "/get_file_details?file_id=" + file_id,
      headers: await header(),
      // body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> userWalletAmount(user_id) async {
  try {
    // var request = data;
    var response = await get(
      baseUrl + "/user_wallet_amount?user_id=" + user_id,
      headers: await header(),
    );
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> transactionHistory(user_id) async {
  try {
// var request = data;
    var response = await get(
      baseUrl + "/transaction_history?user_id=" + user_id,
      headers: await header(),
    );
    if (response.body == null) {
      // showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast("failed to load data");
      return null;
    }
// showToast(data["ResponseHeader"]["ResponseMessage"]);
// showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> accountHistory(user_id) async {
  try {
// var request = data;
    var response = await get(
      baseUrl + "/account_statement?users_id=" + user_id,
      headers: await header(),
    );
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
// showToast(data["ResponseHeader"]["ResponseMessage"]);
// showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> topUpHistory(user_id) async {
  try {
// var request = data;
    var response = await get(
      baseUrl + "/topuphistory?user_id=" + user_id,
      headers: await header(),
    );
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast("failed to load data");
      return null;
    }
// showToast(data["ResponseHeader"]["ResponseMessage"]);
// showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> deleteFileBid(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/delete_file_bid",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getPropertyWatchList(user_id) async {
  try {
    //var request = data;
    var data;
    var response = await get(
      baseUrl + "/get_property_watch_list?users_id=" + user_id,
      headers: await header(),
      // body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    //showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getWatchList(user_id) async {
  try {
    //var request = data;
    var data;
    var response = await get(
      baseUrl + "/watch_list?user_id=" + user_id,
      headers: await header(),
      // body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    //  showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> uploadImage(data) async {
  try {
    var request = data;
    print(request);
    // var data;
    var response = await post(baseUrl + "/upload_image",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

//
// Future<Map<String,dynamic>> getPropertyData(userId) async {
//   try {
//     // var request = data;
//     Response response = await post(
//       baseUrl+"/property_list?user_id="+userId,
//       headers: await header(),);
//     if (response.body == null) {
//       showToast("Cannot get response");
//       return null;
//     }
//     var data = jsonDecode(response.body);
//
//     var responseCode = data["ResponseHeader"]["ResponseCode"];
//     if(responseCode == 400 || responseCode == 500){
//       logout();
//       op_get.Get.offAll(Login());
//     }if (data["ResponseHeader"]["ResponseCode"] == 0) {}

//       showToast("failed to load data");
//       return null;
//     }
//     // showToast(data["ResponseHeader"]["ResponseMessage"]);
//     // showToast()
//     return data["ResponseHeader"];
//   }catch(exp){
//     print(exp.toString());
//     showToast("Unfortunate Error");
//     return null;
//   }
// }

Future<Map<String, dynamic>> getPropertyAddPageData() async {
  try {
    // var request = data;
    Response response = await get(
      baseUrl + "/get_property_page_data",
      headers: await header(),
    );
    print(response.body);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getFeatureData() async {
  try {
    // var request = data;
    Response response = await get(
      baseUrl + "/get_features_data",
      headers: await header(),
    );
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getBidPropertyList(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/bid_property_list",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //  showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> PostBidProperty(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/bid_property",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 2) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return data["ResponseHeader"];
    }
    if (data["ResponseHeader"]["ResponseCode"] != 1) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> addPropertyService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/add_property_data",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getPropertyPorfolioService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/property_portfolio",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> addFileWatchList(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/add_file_watchlist",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> addPropertyWatchList(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/add_property_watchlist",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> acceptPropertyBidService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/property_owner_accept_offer",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getPropertyIntransferService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/property_intransfer_time",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> propertyIntransferActionService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/buyer_property_intransfer_action",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //  showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> propertyOwnerBidService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/property_owner_bids",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> propertyPostService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/property_post",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> propertyUpdatePostService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/property_post_update",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> propertyDeletePostService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/property_post_delete",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getPropertyData(data) async {
  try {
    var request = data;
    print(request);
    // var data;
    var response = await post(baseUrl + "/property_list",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getSinglePropertyService(data) async {
  try {
    var request = data;
    print(request);
    // var data;
    var response = await post(baseUrl + "/single_property",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getPropertyLatLongData(data) async {
  try {
    var request = data;
    print(request);
    // var data;
    var response = await post(baseUrl + "/property_latlong_filter",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return data["ResponseHeader"];
    }
    //showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getCurrentPagePropertyData(data) async {
  try {
    var request = data;
    print(request);
    // var data;
    var response = await post(baseUrl + "/current_property_list",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> propertyFilter(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/property_filter",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> marketWatchService() async {
  try {
    // var request = data;
    var response = await get(
      baseUrl + "/watch_market",
      headers: await header(),
    );
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> marketPerformerService() async {
  try {
    // var request = data;
    var response = await get(
      baseUrl + "/market_performer",
      headers: await header(),
    );
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getPropertyNewsSevice(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/get_property_news",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getPropertyMapsService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/get_property_maps",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> areaWiseTradeService(s, e) async {
  try {
    // var request = data;
    print(await getApiToken());
    print(baseUrl + "/trade_report?s_date=" + s + "&e_date=" + e);
    var response = await get(
      baseUrl + "/trade_report?s_date=" + s + "&e_date=" + e,
      headers: await header(),
    );
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);
    print(data);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getTypeImagesService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/get_type_images",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> updateProfile(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/profile",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> updateUserFCMToken(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/update_user_fcm_token",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> invloveSupportChatRequest(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/chat_involve_support",
        headers: await header(), body: jsonEncode(request));
    print("response--->");
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return data["ResponseHeader"];
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getConversationList(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/chat_data",
        headers: await header(), body: jsonEncode(request));
    print("response--->");
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return data["ResponseHeader"];
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getConversationList2(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/update_chat",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<String> uploadAudioFile(data) async {
  try {
    Uri uri = Uri.parse(baseUrl + "/chat_data");
    var request = MultipartRequest("POST", uri);
    request.files.add(await MultipartFile.fromPath("audio", data["path"],
        contentType: MediaType("audio", "mp3")));
    request.headers.addAll(await header());
    request.fields.addAll(data);
    var response = await request.send();
    print(response.stream);
    var res = await http.Response.fromStream(response);
    print(res.body);
    return res.body;
    // print(respons);
  } catch (exp) {
    print("MJ Error :" + exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<String> uploadConversationImages(data) async {
  try {
    Uri uri = Uri.parse(baseUrl + "/chat_data");
    var request = MultipartRequest("POST", uri);
    request.headers.addAll(await header());
    request.files.add(await MultipartFile.fromPath(
        "audio", data["path"].path.replaceAll('file://', ''),
        contentType: MediaType("audio", "mp3")));

    request.fields.addAll(data);

    var response = await request.send();
    print(response.stream);
    var res = await http.Response.fromStream(response);
    print(res.body);
    return res.body;
    // print(respons);
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> commissionFileSocietiesService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/get_file_commission_society",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> commissionPropertySocietiesService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/get_property_commission_society",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> commissionRequestService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/make_commission",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return data["ResponseHeader"];
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getUserCities(data) async {
  try {
    var request = data;
    // print(headers);
    var response = await post(baseUrl + "/get_user_cities",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return data["ResponseHeader"];
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getUserNotificationsService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/get_notifcations",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return data["ResponseHeader"];
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getCommissionTicketData(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/commission_ticket",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return data["ResponseHeader"];
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> postFeedBackService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/feed_back",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());

    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getOtpService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/send_otp",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());

    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> resetPasswordService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/reset_password",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());

    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> appSettingsService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/app_settings",
        headers: await header(), body: jsonEncode(request));
    // print(response.body.toString());
    print("appSetting");

    if (response.body == null) {
      // showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    return data["ResponseHeader"];
  } catch (exp) {
    print("AppSettingError");
    print(exp.toString());
    // showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> updateNotificationStatusService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/update_notification_status",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());

    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getUserBidsService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/get_user_wallet_bids",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());

    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> resendCode(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/resend",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());

    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getPropertyBuyIntransfer(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/get_intransfer_property_buy",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());

    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> editBidProperty(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/edit_property_bid",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> deleteBidProperty(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/delete_property_bid",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> submitWithdrawRequestService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/withdrawl_request",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> submitDirectDepositRequestService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/direct_deposit",
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String, dynamic>> getPackageLogReportService(data) async {
  try {
    var request = data;
    var response = await post(baseUrl + "/bid_report",
        headers: await header(), body: jsonEncode(request)).timeout(Duration(seconds: 100));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if (responseCode == 400 || responseCode == 500) {
      logout();
      op_get.Get.offAll(Login());
    }
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

bool isNumeric(String s) {
  if (s == null) {
    return false;
  }
  if(s.length > 15){
    return false;
  }
  return double.tryParse(s) != null &&
      s.contains(".") == false &&
      double.tryParse(s) > 0;
}

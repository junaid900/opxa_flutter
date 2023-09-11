import 'dart:convert';
import 'package:http/http.dart';
import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Network/network.dart';
import 'package:qkp/login.dart';
import 'constant.dart';
import 'package:get/get.dart' as op_get;


Future<Map<String, dynamic>> postRequest(url,data,{toast=true}) async {
  try {
    var request = data;
    print(baseUrl + url);
    var response = await post(baseUrl + url,
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      if(toast)
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if(responseCode == 400 || responseCode == 500){
      logout();
      op_get.Get.offAll(Login());
    }if (data["ResponseHeader"]["ResponseCode"] == 0) {
      if(toast)
        showToast(data["ResponseHeader"]["ResponseMessage"]);
        return null;
    }
    if(toast)
      showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String, dynamic>> getRequest(url) async {
  try {
    // print(baseUrl+url);
    // var request = data;
    var response = await get(baseUrl + url,
        headers: await header());
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);
    var responseCode = data["ResponseHeader"]["ResponseCode"];
    if(responseCode == 400 || responseCode == 500){
      logout();
      op_get.Get.offAll(Login());
    }if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  } catch (exp) {
    print(url+exp.toString());
    if(url != '/market_fire_store')
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String, dynamic>> simplePostRequest(url,request) async {
  try {
    // var request = data;
    var response = await post(baseUrl + url,
        headers: await header(), body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);
    return data;
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String, dynamic>> simpleGetRequest(url) async {
  try {
    // var request = data;
    var response = await get(baseUrl + url,
        headers: await header());
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);
   return data;
  } catch (exp) {
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
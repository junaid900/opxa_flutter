import 'dart:convert';
// import 'dio';
import 'dart:io';
import 'package:http/http.dart';
import 'package:qkp/Network/constant.dart';

String baseUrl = "https://zameenexchange.com/api";
var headers = {
  HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
  HttpHeaders.cacheControlHeader: 'no-cache',
  HttpHeaders.acceptHeader: 'application/json; charset=utf-8',
  "ApiKey":"XXXXXX-XXXXXX-JUnsa1988938922039:012900929",
};
Future<Map<String,dynamic>> loginService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/signin",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    //showToast(data["ResponseHeader"]["ResponseMessage"]);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> signUpService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/signup",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
   // showToast(data["ResponseHeader"]["ResponseMessage"]);

    if (data["ResponseHeader"]["ResponseCode"] == 0 || data["ResponseHeader"]["ResponseCode"] == 2) {
      showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}




Future<Map<String,dynamic>> myAssetsService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/myassets",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
   // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> buyPackages(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/buypackages",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
   // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}





Future<Map<String,dynamic>> getpackages() async {
  try {
    // var request = data;
    var response = await get(
      baseUrl+"/getpackages",
      headers: headers,);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
    //  showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> fileDropDownService() async {
  try {
    // var request = data;
    var response = await get(
        baseUrl+"/dropdownData",
        headers: headers,);
        // body: jsonEncode(request));
    // print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> sellFilesService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/sellfiles",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> sellLimitFilesService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/selllimit",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> addFileService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/savefilesdata",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}




Future<Map<String,dynamic>> bidFiles(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/bidfiles",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
   // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> getMyAssetsService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/fileassets",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> getOwnerAction(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/owner_action_assets",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> postFile(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/postfile",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
   // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> deleteFilePost(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/delete_file_post",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
   // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> activateService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/activate",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
  //  showToast(data["ResponseHeader"]["ResponseMessage"]);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> ownerFilesService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/getownerfiles",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
   // showToast(data["ResponseHeader"]["ResponseMessage"]);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> updatePostFile(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/update_post_files",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
   // showToast(data["ResponseHeader"]["ResponseMessage"]);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> loadFileChart(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/file_graph",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
   // showToast(data["ResponseHeader"]["ResponseMessage"]);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}




Future<Map<String,dynamic>> getTimerinTransferService(data) async {
  try {
    var request = data;
    var response = await get(
        baseUrl+"/intransfer_time?owner_id="+data["owner_id"],
        headers: headers,
         // body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> clearIntransferService(data) async {
  try {
    var request = data;
    var response = await post(
      baseUrl+"/inactivehistory",
      headers: headers,
      body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> getFileDetailsService(file_id) async {
  print(baseUrl+"/get_file_details?file_id="+file_id);
  try {
    //var request = data;
    var data;
    var response = await get(
      baseUrl+"/get_file_details?file_id="+file_id,
      headers: headers,
      // body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> userWalletAmount(user_id) async {
  try {
    // var request = data;
    var response = await get(
      baseUrl+"/user_wallet_amount?user_id="+user_id,
      headers: headers,);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> transactionHistory(user_id) async {
  try {
// var request = data;
    var response = await get(
      baseUrl+"/transaction_history?user_id="+user_id,
      headers: headers,);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
// showToast(data["ResponseHeader"]["ResponseMessage"]);
// showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> accountHistory(user_id) async {
  try {
// var request = data;
    var response = await get(
      baseUrl+"/account_statement?users_id="+user_id,
      headers: headers,);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
// showToast(data["ResponseHeader"]["ResponseMessage"]);
// showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> topUpHistory(user_id) async {
  try {
// var request = data;
    var response = await get(
      baseUrl+"/topuphistory?user_id="+user_id,
      headers: headers,);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast("failed to load data");
      return null;
    }
// showToast(data["ResponseHeader"]["ResponseMessage"]);
// showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> deleteFileBid(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/delete_file_bid",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> getPropertyWatchList(user_id) async {
  try {
    //var request = data;
    var data;
    var response = await get(
      baseUrl+"/get_property_watch_list?users_id="+user_id,
      headers: headers,
      // body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    //showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> getWatchList(user_id) async {
  try {
    //var request = data;
    var data;
    var response = await get(
      baseUrl+"/watch_list?user_id="+user_id,
      headers: headers,
      // body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
  //  showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> uploadImage(data) async {
  try {
    var request = data;
    print(request);
    // var data;
    var response = await post(
      baseUrl+"/upload_image",
      headers: headers,
      body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
   // showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  }catch(exp){
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
//       headers: headers,);
//     if (response.body == null) {
//       showToast("Cannot get response");
//       return null;
//     }
//     var data = jsonDecode(response.body);
//
//     if (data["ResponseHeader"]["ResponseCode"] == 0) {
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

Future<Map<String,dynamic>> getPropertyAddPageData() async {
  try {
    // var request = data;
    Response response = await get(
      baseUrl+"/get_property_page_data",
      headers: headers,);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> getFeatureData() async {
  try {
    // var request = data;
    Response response = await get(
      baseUrl+"/get_features_data",
      headers: headers,);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> getBidPropertyList(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/bid_property_list",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> PostBidProperty(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/bid_property",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> addPropertyService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/add_property_data",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> getPropertyPorfolioService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/property_portfolio",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> addFileWatchList(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/add_file_watchlist",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> addPropertyWatchList(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/add_property_watchlist",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> acceptPropertyBidService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/property_owner_accept_offer",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> getPropertyIntransferService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/property_intransfer_time",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> propertyIntransferActionService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/buyer_property_intransfer_action",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> propertyOwnerBidService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/property_owner_bids",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> propertyPostService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/property_post",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> propertyUpdatePostService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/property_post_update",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> propertyDeletePostService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/property_post_delete",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> getPropertyData(data) async {
  try {
    var request = data;
    print(request);
    // var data;
    var response = await post(
        baseUrl+"/property_list",
        headers: headers,
        body: jsonEncode(request)
    );
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);
    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //showToast(data["ResponseHeader"]["ResponseMessage"]);
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> propertyFilter(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/property_filter",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      //showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
   // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> marketWatchService() async {
  try {
    // var request = data;
    var response = await get(
      baseUrl+"/watch_market",
      headers: headers,);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> marketPerformerService() async {
  try {
    // var request = data;
    var response = await get(
      baseUrl+"/market_performer",
      headers: headers,);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> getPropertyNewsSevice(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/get_property_news",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
   // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}


Future<Map<String,dynamic>> getPropertyMapsService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/get_property_maps",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
   // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> areaWiseTradeService(s,e) async {
  try {
    // var request = data;
    var response = await get(
      baseUrl+"/area_wise_trade_report?s_date="+s+"&e_date="+e,
      headers: headers,);
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    var data = jsonDecode(response.body);
    print(data);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      showToast("failed to load data");
      return null;
    }
    // showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> getTypeImagesService(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/get_type_images",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
  //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> updateProfile(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/profile",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}



Future<Map<String,dynamic>> updateUserFCMToken(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/update_user_fcm_token",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
     // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
  //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
Future<Map<String,dynamic>> getConversationList2(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/update_chat",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}

Future<Map<String,dynamic>> getConversationList(data) async {
  try {
    var request = data;
    var response = await post(
        baseUrl+"/chat_data",
        headers: headers,
        body: jsonEncode(request));
    print(response.body.toString());
    if (response.body == null) {
      showToast("Cannot get response");
      return null;
    }
    data = jsonDecode(response.body);

    if (data["ResponseHeader"]["ResponseCode"] == 0) {
      // showToast(data["ResponseHeader"]["ResponseMessage"]);
      return null;
    }
    //  showToast(data["ResponseHeader"]["ResponseMessage"]);
    // showToast()
    return data["ResponseHeader"];
  }catch(exp){
    print(exp.toString());
    showToast("Unfortunate Error");
    return null;
  }
}
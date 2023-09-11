import 'dart:convert';

import 'package:nb_utils/nb_utils.dart';

const APP_SETTING = "app_setting";

setValue(key, value) async {
  var data = await setString(key, value);
  return data;
}

getValue(key) async {
  try {
    var data = await getString(key);
    var d = jsonDecode(data);
    return d;
  } catch (e) {
    return null;
  }
}

removeValue(key) async {
  try {
    return await setString(key, null);
  } catch (e) {
    return null;
  }
}
getAppSetting() async {
  var prefData = await getString(APP_SETTING);
  return await getAppSettingFromMap(jsonDecode(prefData));
}
getAppSettingFromMap(List<dynamic> map) {
  Map resMap = Map();
  for (int i = 0; i < map.length; i++) {
    resMap[map[i]["name"]] = map[i];
  }
  return resMap;
}

import 'dart:convert';
import 'package:nb_utils/nb_utils.dart';
import 'package:qkp/Model/User.dart';
import 'package:qkp/Network/constant.dart';

setUser(User currentUser) async {
  print("user"+currentUser.firstName);
  await setString(USER, jsonEncode(currentUser.toJson()));
}
//
// setFirstTime() async {
//   print("user"+currentUser.firstName);
//   await setString(USER, jsonEncode(currentUser.toJson()));
// }

updateUserImage(image)async{
  User user = await getUser();
  if(user != null){
    user.profilePicture = image;
    setUser(user);
  }
}

Future<User> getUser() async {
  try {
    User user = new User();
    var data = jsonDecode(await getString(USER));
    user.fromJson(data);
    return user;
  }catch(e){
    return null;
  }
}


Future<bool> isLogin() async {
  try {
    if (await getString(USER) == ''|| await getString(USER) == null) {
      return false;
    } else {
      return true;
    }
  } catch (e) {
    return false;
  }
}

logout() async {
  await setString(USER, null);
}

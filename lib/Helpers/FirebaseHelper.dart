import 'package:firebase_database/firebase_database.dart';
import 'package:qkp/Model/MarketFiles.dart';
import 'package:qkp/Network/constant.dart';

class FirebaseDatabaseHelper {
  static String marketFire = 'Market';
  static FirebaseDatabase database = FirebaseDatabase.instance;

  static getMarketDataFromFirebase({onSuccess, onError}) {
    print("firebase");
    var ref = database.reference().child('Market').orderByKey().onValue.listen((Event event) {
      print("firebase1");
      onSuccess(event);
    }, onError: (o) {
      print("firebase2");
      print(o);
      print("==============+> firebase Error");
      onError(o);
    },onDone: (){
      print("firebase done");
    });
    return ref;
  }
  static int mySortComparison(DataSnapshot a, DataSnapshot b) {
    // print(a.value);
    final propertyA = a.value["total_file_volume"];
    final propertyB = b.value["total_file_volume"];
    if (convertToDouble(propertyA) < convertToDouble(propertyB)) {
      return 1;
    } else if (convertToDouble(propertyA) > convertToDouble(propertyB)) {
      return -1;
    } else {
      return 0;
    }
  }
}

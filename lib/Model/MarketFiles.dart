import 'package:qkp/Helpers/SessionHelper.dart';
import 'package:qkp/Model/User.dart';

class MarketFiles {
  String fileId;
  String cityName;
  String fileName;
  String quantity;
  String price;
  String qkpFileSymbolId;
  String symbol;
  String town;
  String ownerId;
  String status;
  String createdAt;
  String updatedAt;
  String fileActionId;
  String postId;
  String transactionPoints;
  String transactionPercentage;
  String lastClosingPrice;
  String latestClosingPrice;
  String highestPrice;
  String highestQuantity;
  String avgPrice;
  String totalFileVolume;
  String lastFileVolume;
  String bidderId;
  String cityId;
  String mPostId;
  bool isLiked = false;
  String ltcp;
  String societyPercentage;
  dynamic fileWatchList;

  MarketFiles(
      {this.fileId,
      this.cityName,
      this.fileName,
      this.quantity,
      this.price,
      this.qkpFileSymbolId,
      this.symbol,
      this.town,
      this.ownerId,
      this.status,
      this.createdAt,
      this.updatedAt,
      this.fileActionId,
      this.postId,
      this.transactionPoints,
      this.transactionPercentage,
      this.lastClosingPrice,
      this.latestClosingPrice,
      this.highestPrice,
      this.highestQuantity,
      this.avgPrice,
      this.totalFileVolume,
      this.lastFileVolume,
      this.bidderId,
      this.mPostId,
      this.cityId,
      this.isLiked,
      this.ltcp,
      this.fileWatchList});

  MarketFiles.fromJson(Map<dynamic, dynamic> json) {
    fileId = json['file_id'].toString();
    cityName = json['city_name'].toString();
    fileName = json['file_name'].toString();
    quantity =
        json['ask_quantity'] == null ? "0" : json['ask_quantity'].toString();
    price = json['ask_price'] == null ? "0" : json['ask_price'].toString();
    qkpFileSymbolId = json['qkp_file_symbol_id'] == null
        ? "0"
        : json['qkp_file_symbol_id'].toString();
    symbol = json['symbol'] == null ? "" : json['symbol'].toString();
    town = json['town'] == null ? "0" : json['town'].toString();
    transactionPoints = json['transaction_points'] == null
        ? "0"
        : json['transaction_points'].toString();
    transactionPercentage = json['transaction_percentage'] == null
        ? "0"
        : json['transaction_percentage'].toString();
    lastClosingPrice = json['ldcp'] == null ? "0" : json['ldcp'].toString();
    latestClosingPrice =
        json['current'] == null ? "0" : json['current'].toString();
    highestPrice =
        json['highest_price'] == null ? "0" : json['highest_price'].toString();
    highestQuantity = json['highest_quantity'] == null
        ? "0"
        : json['highest_quantity'].toString();
    totalFileVolume = json['total_file_volume'] == null
        ? "0"
        : json['total_file_volume'].toString();
    cityId = json['city_id'].toString();
    lastFileVolume = json['last_file_volume'] == null
        ? "0"
        : json['last_file_volume'].toString();
    ltcp = json['ldcp'].toString();
    isLiked = json['is_like'] == null ? false : json['is_like'];
    avgPrice = json['avg_price'] == null ? "0" : json['avg_price'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();

    ownerId = json['owner_id'].toString();
    status = json['status'].toString();
    fileActionId = json['file_action_id'].toString();
    postId = json['post_id'].toString();
    bidderId = json['bider_id'].toString();
    mPostId = json['m_post_id'].toString();
    societyPercentage = json['society_percentage'].toString();
    if (json['file_watch_list'] != null) {
      fun() async {
        User user = User();
        user = await getUser();
        if (user != null) {
          fileWatchList = json['file_watch_list'];
          for (int i = 0; i < fileWatchList.length; i++) {
            if (user.id == fileWatchList[i]["user_id"].toString()) {
              isLiked = true;
              break;
            }
          }
        }else{isLiked = false;}
      }
      fun();
    } else {
      isLiked = false;
    }
  }

  fromJson(Map<String, dynamic> json) {
    fileId = json['file_id'].toString();
    cityName = json['city_name'].toString();
    fileName = json['file_name'].toString();
    quantity =
        json['ask_quantity'] == null ? "0" : json['ask_quantity'].toString();
    price = json['ask_price'] == null ? "0" : json['ask_price'].toString();
    qkpFileSymbolId = json['qkp_file_symbol_id'] == null
        ? "0"
        : json['qkp_file_symbol_id'].toString();
    symbol = json['symbol'] == null ? "" : json['symbol'].toString();
    town = json['town'] == null ? "0" : json['town'].toString();
    transactionPoints = json['transaction_points'] == null
        ? "0"
        : json['transaction_points'].toString();
    transactionPercentage = json['transaction_percentage'] == null
        ? "0"
        : json['transaction_percentage'].toString();
    lastClosingPrice = json['ldcp'] == null ? "0" : json['ldcp'].toString();
    latestClosingPrice =
        json['current'] == null ? "0" : json['current'].toString();
    highestPrice =
        json['highest_price'] == null ? "0" : json['highest_price'].toString();
    highestQuantity = json['highest_quantity'] == null
        ? "0"
        : json['highest_quantity'].toString();
    totalFileVolume = json['total_file_volume'] == null
        ? "0"
        : json['total_file_volume'].toString();
    cityId = json['city_id'].toString();
    lastFileVolume = json['last_file_volume'] == null
        ? "0"
        : json['last_file_volume'].toString();
    ltcp = json['ldcp'].toString();
    isLiked = json['is_like'];
    avgPrice = json['avg_price'] == null ? "0" : json['avg_price'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();

    ownerId = json['owner_id'].toString();
    status = json['status'].toString();
    fileActionId = json['file_action_id'].toString();
    postId = json['post_id'].toString();
    bidderId = json['bider_id'].toString();
    mPostId = json['m_post_id'].toString();
    societyPercentage = json['society_percentage'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_id'] = this.fileId;
    data['city_name'] = this.cityName;
    data['file_name'] = this.fileName;
    data['ask_quantity'] = this.quantity;
    data['ask_price'] = this.price;
    data['qkp_file_symbol_id'] = this.qkpFileSymbolId;
    data['symbol'] = this.symbol;
    data['town'] = this.town;
    data['owner_id'] = this.ownerId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['file_action_id'] = this.fileActionId;
    data['post_id'] = this.postId;
    data['transaction_points'] = this.transactionPoints;
    data['transaction_percentage'] = this.transactionPercentage;
    data['ldcp'] = this.lastClosingPrice;
    data['current'] = this.latestClosingPrice;
    data['highest_price'] = this.highestPrice;
    data['highest_quantity'] = this.highestQuantity;
    data['avg_price'] = this.avgPrice;
    data['total_file_volume'] = this.totalFileVolume;
    data['last_file_volume'] = this.lastFileVolume;
    data['bider_id'] = this.bidderId;
    data['m_post_id'] = this.mPostId;
    data['city_id'] = this.cityId;
    data['is_like'] = this.isLiked;
    data['ltcp'] = this.ltcp;

    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return symbol;
  }
}

class MyAsset {
  String id;
  String qkpFileId;
  //for buyer section
  String qkpFileBidId;
  //
  String ownerId;
  String qkpFileSymbolId;
  String quantity;
  String availableQuantity;
  String price;
  String bidQuantity;
  String bidPrice;
  String status;
  String name;
  String detail;
  String fileType;
  String fileSubType;
  String town;
  String city;
  String unitType;
  String unit;
  String createdAt;
  String updatedAt;
  String symbol;
  String actionId;
  String fileName;
  String cityName;
  String postId;
  String biderId;
  String avgPrice;
  String postedQty;
  String latestClosingPrice = null;
  MyAsset(
      {this.id,
        this.qkpFileId,
        this.ownerId,
        this.qkpFileSymbolId,
        this.qkpFileBidId,
        this.quantity,
        this.availableQuantity,
        this.price,
        this.bidQuantity,
        this.bidPrice,
        this.status,
        this.name,
        this.detail,
        this.fileType,
        this.fileSubType,
        this.town,
        this.city,
        this.unitType,
        this.unit,
        this.createdAt,
        this.updatedAt,
        this.symbol,
        this.actionId,
        this.fileName,
        this.cityName,
        this.postId,
        this.biderId,
        this.postedQty
      });

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    qkpFileId = json['qkp_file_id'].toString();
    ownerId = json['owner_id'].toString();
    qkpFileSymbolId = json['qkp_file_symbol_id'].toString();
    qkpFileBidId = json['file_bid_id'].toString();
    quantity = json['quantity'].toString();
    availableQuantity = json['available_quantity'].toString();
    price = json['price'].toString();
    bidQuantity = json['bid_quantity'].toString();
    bidPrice = json['bid_price'].toString();
    status = json['status'];
    name = json['name'];
    detail = json['detail'];
    fileType = json['file_type'];
    fileSubType = json['file_sub_type'];
    town = json['town'] != null ? json['town'].toString():"";

    city = json['city'].toString();
    unitType = json['unit_type'];
    unit = json['unit'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'];
    symbol = json['symbol'].toString();
    actionId = json['action_id'].toString();
    fileName = json['file_name'];
    cityName = json['city_name'];
    postId  = json['post_id'].toString();
    biderId  = json['bider_id'].toString();
    avgPrice  = json['avg_price'].toString();
    postedQty  = json['posted_qty'].toString();
    latestClosingPrice  = json['latest_closing_price'] != null?json['latest_closing_price']:null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qkp_file_id'] = this.qkpFileId;
    data['owner_id'] = this.ownerId;
    data['qkp_file_symbol_id'] = this.qkpFileSymbolId;
    data['file_bid_id'] = this.qkpFileBidId;
    data['quantity'] = this.quantity;
    data['available_quantity'] = this.availableQuantity;
    data['price'] = this.price;
    data['bid_quantity'] = this.bidQuantity;
    data['bid_price'] = this.bidPrice;
    data['status'] = this.status;
    data['name'] = this.name;
    data['detail'] = this.detail;
    data['file_type'] = this.fileType;
    data['file_sub_type'] = this.fileSubType;
    data['town'] = this.town;
    data['city'] = this.city;
    data['unit_type'] = this.unitType;
    data['unit'] = this.unit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['symbol'] = this.symbol;
    data['action_id'] = this.actionId;
    data['file_name'] = this.fileName;
    data['city_name'] = this.cityName;
    data['post_id'] = this.postId;
    data['bider_id'] = this.biderId;
    data['posted_qty'] = this.postedQty;
    return data;
  }
}
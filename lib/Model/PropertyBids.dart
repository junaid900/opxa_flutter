class PropertyBids {
  String id;
  String propertyId;
  String usersId;
  String price;
  String bidPrice;
  String dateAdded;
  String status;
  String userName;
  String propertyName;

  PropertyBids(
      {this.id,
        this.propertyId,
        this.usersId,
        this.price,
        this.bidPrice,
        this.dateAdded,
        this.status,
        this.userName,
        this.propertyName});

  PropertyBids.fromJson(Map<String, dynamic> json) {
    id = json['id'] != null ? json['id'].toString():"";
    propertyId = json['property_id'].toString();
    usersId = json['users_id'].toString();
    price = json['price'].toString();
    bidPrice = json['bid_price'].toString();
    dateAdded = json['date_added'].toString();
    status = json['status'].toString();
    userName = json['user_name'].toString();
    propertyName = json['property_name'].toString();
  }
  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    propertyId = json['property_id'].toString();
    usersId = json['users_id'].toString();
    price = json['price'].toString();
    bidPrice = json['bid_price'].toString();
    dateAdded = json['date_added'].toString();
    status = json['status'].toString();
    userName = json['user_name'].toString();
    propertyName = json['property_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['users_id'] = this.usersId;
    data['price'] = this.price;
    data['bid_price'] = this.bidPrice;
    data['date_added'] = this.dateAdded;
    data['status'] = this.status;
    data['user_name'] = this.userName;
    data['property_name'] = this.propertyName;
    return data;
  }
}
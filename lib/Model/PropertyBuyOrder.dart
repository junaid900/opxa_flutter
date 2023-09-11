class PropertyBuyOrder {
  String userName;
  String area;
  String unitName;
  String cityName;
  String propertyName;
  String usersId;
  String id;
  String typeId;
  String subTypeId;
  String cityId;
  String townId;
  String societyId;
  String price;
  String minimumOffer;
  String maximumOffer;
  String long;
  String lat;
  String address;
  String propertyUnitId;
  String size;
  String contactNumber;
  String bedRooms;
  String bathRooms;
  String phoneNumber;
  String features;
  String status;
  String bidPrice;
  String dateAdded;

  PropertyBuyOrder(
      {this.userName,
        this.area,
        this.unitName,
        this.cityName,
        this.propertyName,
        this.usersId,
        this.id,
        this.typeId,
        this.subTypeId,
        this.cityId,
        this.townId,
        this.societyId,
        this.price,
        this.minimumOffer,
        this.maximumOffer,
        this.long,
        this.lat,
        this.address,
        this.propertyUnitId,
        this.size,
        this.contactNumber,
        this.bedRooms,
        this.bathRooms,
        this.phoneNumber,
        this.features,
        this.status,
        this.bidPrice,
        this.dateAdded});
  PropertyBuyOrder.fromJson(Map<String, dynamic> json) {
    userName = json['user_name'].toString();
    area = json['area'].toString();
    unitName = json['unit_name'].toString();
    cityName = json['city_name'].toString();
    propertyName = json['property_name'].toString();
    usersId = json['users_id'].toString();
    id = json['id'].toString();
    typeId = json['type_id'].toString();
    subTypeId = json['sub_type_id'].toString();
    cityId = json['city_id'].toString();
    townId = json['town_id'].toString();
    societyId = json['society_id'].toString();
    price = json['price'].toString();
    minimumOffer = json['minimum_offer'].toString();
    maximumOffer = json['maximum_offer'].toString();
    long = json['long'].toString();
    lat = json['lat'].toString();
    address = json['address'].toString();
    propertyUnitId = json['property_unit_id'].toString();
    size = json['size'].toString();
    contactNumber = json['contact_number'].toString();
    bedRooms = "";
    bathRooms = "";
    phoneNumber = json['phone_number'].toString();
    features = json['features'].toString();
    status = json['status'].toString();
    bidPrice = json['bid_price'].toString();
    dateAdded = json['date_added'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_name'] = this.userName;
    data['area'] = this.area;
    data['unit_name'] = this.unitName;
    data['city_name'] = this.cityName;
    data['property_name'] = this.propertyName;
    data['users_id'] = this.usersId;
    data['id'] = this.id;
    data['type_id'] = this.typeId;
    data['sub_type_id'] = this.subTypeId;
    data['city_id'] = this.cityId;
    data['town_id'] = this.townId;
    data['society_id'] = this.societyId;
    data['price'] = this.price;
    data['minimum_offer'] = this.minimumOffer;
    data['maximum_offer'] = this.maximumOffer;
    data['long'] = this.long;
    data['lat'] = this.lat;
    data['address'] = this.address;
    data['property_unit_id'] = this.propertyUnitId;
    data['size'] = this.size;
    data['contact_number'] = this.contactNumber;
    data['bed_rooms'] = this.bedRooms;
    data['bath_rooms'] = this.bathRooms;
    data['phone_number'] = this.phoneNumber;
    data['features'] = this.features;
    data['status'] = this.status;
    data['bid_price'] = this.bidPrice;
    data['date_added'] = this.dateAdded;
    return data;
  }
}
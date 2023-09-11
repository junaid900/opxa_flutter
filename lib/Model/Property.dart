import 'dart:convert';

import 'PropertyImages.dart';

class Property {
  String id;
  String propertyName;
  String typeId;
  String subTypeId;
  String cityId;
  String townId;
  String societyId;
  String price;
  String long;
  String lat;
  String address;
  String usersId;
  String propertyUnitId;
  String size;
  String contactNumber;
  String bedRooms;
  String bathRooms;
  String phoneNumber;
  String status;
  String societyTitle;
  String societyName;
  String societyStatus;
  String unitName;
  Map     features;
  List<PropertyImages> images = [];
  String minimumOffer;
  String maximumOffer;
  String maxBid;
  bool isLike;
  String ltcp;
  String propertyId;
  String sectorName;
  String subtypeName;
  String typeName;
  Property(
      {this.id,
        this.propertyName,
        this.typeId,
        this.subTypeId,
        this.cityId,
        this.townId,
        this.societyId,
        this.price,
        this.long,
        this.lat,
        this.address,
        this.usersId,
        this.propertyUnitId,
        this.size,
        this.contactNumber,
        this.bedRooms,
        this.bathRooms,
        this.phoneNumber,
        this.status,
        this.societyTitle,
        this.societyName,
        this.societyStatus,
        this.images,
        this.features,
        this.minimumOffer,
        this.maximumOffer,
        this.isLike,
        this.maxBid,
        this.unitName,
        this.ltcp,
        this.propertyId,
      }){
    if(this.images == null){
      this.images = [];
      this.images.add(PropertyImages(id:'',propertyId: propertyId,image: ''));
    }
  }

  Future<bool> fromJson(Map<String, dynamic> json) async {
    id = json['id'].toString();
    propertyName = json['property_name'];
    typeId = json['type_id'].toString();
    subTypeId = json['sub_type_id'].toString();
    cityId = json['city_id'].toString();
    townId = json['town_id'].toString();
    societyId = json['society_id'].toString();
    price = json['price'].toString();
    long = json['long'].toString();
    lat = json['lat'].toString();
    address = json['address'].toString();
    usersId = json['users_id'].toString();
    propertyUnitId = json['property_unit_id'].toString();
    size = json['size'].toString();
    contactNumber = json['contact_number'];
    bedRooms = json['bed_rooms'].toString();
    bathRooms = json['bath_rooms'].toString();
    phoneNumber = json['phone_number'].toString();
    status = json['status'].toString();
    societyTitle = json['society_title'].toString();
    societyName = json['society_name'].toString();
    societyStatus = json['society_status'].toString();
    minimumOffer = json['minimum_offer'].toString();
    maximumOffer = json['maximum_offer'].toString();
    isLike =  json['is_like'];
    unitName =  json['unit_name'].toString();
    ltcp =  json['ltcp'].toString();
    propertyId =  json['property_id'].toString();
    sectorName =  json['sector_name'].toString();
    subtypeName =  json['sub_type_name'].toString();
    typeName =  json['type_name'].toString();
    // propertyId =  json['property_id'];
    maxBid =  json['max_bid'] == null?"0":json['max_bid'].toString();
    //images = json['images'].cast<String>();
    this.images = [];
    if(json["images"] != null) {
       for (int i = 0; i < json["images"].length; i++) {
        PropertyImages propertyImages = new PropertyImages();
        await propertyImages.fromJson(json["images"][i]);
        this.images.add(propertyImages);
      }
    }
    if(images.length < 1){
      images.add(PropertyImages(id:'',propertyId: propertyId,image: ''));
    }
    if(json["features"] != null){
      features = Map();
      try {
        features = json["features"];
      }catch(e){
        features = jsonDecode(json["features"]);
      }
    }

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_name'] = this.propertyName;
    data['type_id'] = this.typeId;
    data['sub_type_id'] = this.subTypeId;
    data['city_id'] = this.cityId;
    data['town_id'] = this.townId;
    data['society_id'] = this.societyId;
    data['price'] = this.price;
    data['long'] = this.long;
    data['lat'] = this.lat;
    data['address'] = this.address;
    data['users_id'] = this.usersId;
    data['property_unit_id'] = this.propertyUnitId;
    data['size'] = this.size;
    data['contact_number'] = this.contactNumber;
    data['bed_rooms'] = this.bedRooms;
    data['bath_rooms'] = this.bathRooms;
    data['phone_number'] = this.phoneNumber;
    data['status'] = this.status;
    data['society_title'] = this.societyTitle;
    data['society_name'] = this.societyName;
    data['society_status'] = this.societyStatus;
    data['images'] = this.images;
    data['minimum_offer'] = this.minimumOffer;
    data['maximum_offer'] = this.maximumOffer;
    data['is_like'] = this.isLike;
    data['unit_name'] = this.unitName;
    return data;
  }
}
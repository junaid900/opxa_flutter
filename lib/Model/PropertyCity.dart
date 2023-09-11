class PropertyCity {
  String id;
  String name;
  String countryId;
  String createdAt;
  String updatedAt;
  List<Towns> towns;

  PropertyCity(
      {this.id, this.name, this.createdAt, this.updatedAt, this.towns});

  PropertyCity.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    countryId = json['country_id'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    if (json['towns'] != null) {
      towns = new List<Towns>();
      json['towns'].forEach((v) {
        towns.add(new Towns.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    if (this.towns != null) {
      data['towns'] = this.towns.map((v) => v.toJson()).toList();
    }
    return data;
  }

  @override
  String toString() {
    // TODO: implement toString
    return this.name;
  }
}

class Towns {
  String id;
  String city;
  String town;
  String createdAt;
  String updatedAt;

  Towns({this.id, this.city, this.town, this.createdAt, this.updatedAt});

  Towns.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    city = json['city'].toString();
    town = json['town'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['city'] = this.city;
    data['town'] = this.town;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return this.town;
  }
}
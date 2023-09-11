class Town {
  String id;
  String city;
  String town;
  String createdAt;
  String updatedAt;

  Town({this.id, this.city, this.town, this.createdAt, this.updatedAt});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    city = json['city'].toString();
    town = json['town'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
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
}
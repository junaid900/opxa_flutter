class Country {
  String id;
  String countryName;
  String countryCode;
  String sortname;
  String image;

  Country({this.id, this.countryName, this.countryCode, this.image});

  Country.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    countryName = json['country_name'];
    countryCode = json['country_code'].toString();
    sortname = json['sortname'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['country_name'] = this.countryName;
    data['country_code'] = this.countryCode;
    data['image'] = this.image;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return countryName;
  }
}
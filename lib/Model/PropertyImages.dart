class PropertyImages {
  String id;
  String propertyId;
  String image;

  PropertyImages({this.id, this.propertyId, this.image});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    propertyId = json['property_id'].toString();
    image = json['image'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['image'] = this.image;
    return data;
  }
}
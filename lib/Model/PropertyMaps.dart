class PropertyMaps {
  String id;
  String societyId;
  String mapImage;
  String status;
  String societyName;

  PropertyMaps(
      {this.id, this.societyId, this.mapImage, this.status, this.societyName});

  PropertyMaps.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    societyId = json['society_id'].toString();
    mapImage = json['map_image'].toString();
    status = json['status'].toString();
    societyName = json['society_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['society_id'] = this.societyId;
    data['map_image'] = this.mapImage;
    data['status'] = this.status;
    data['society_name'] = this.societyName;
    return data;
  }
}
class PropertyUnit {
  String id;
  String unitName;
  String status;

  PropertyUnit({this.id, this.unitName, this.status});

  PropertyUnit.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    unitName = json['unit_name'];
    status = json['status'];
  }


  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['unit_name'] = this.unitName;
    data['status'] = this.status;
    return data;
  }
}
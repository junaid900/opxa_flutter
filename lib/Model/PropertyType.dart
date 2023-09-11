class PropertyType {
  String id;
  String typeName;
  String status;
  List<Subtypes> subtypes;

  PropertyType({this.id, this.typeName, this.status, this.subtypes});

  PropertyType.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    typeName = json['type_name'];
    status = json['status'];
    if (json['subtypes'] != null) {
      subtypes = new List<Subtypes>();
      json['subtypes'].forEach((v) {
        subtypes.add(new Subtypes.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_name'] = this.typeName;
    data['status'] = this.status;
    if (this.subtypes != null) {
      data['subtypes'] = this.subtypes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Subtypes {
  String id;
  String subTypeName;
  String typeId;
  String status;

  Subtypes({this.id, this.subTypeName, this.typeId, this.status});

  Subtypes.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    subTypeName = json['sub_type_name'];
    typeId = json['type_id'].toString();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_type_name'] = this.subTypeName;
    data['type_id'] = this.typeId;
    data['status'] = this.status;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return this.subTypeName;
  }
}
class SubTypeFields {
  String id;
  String subTypeId;
  String name;
  String fieldId;

  SubTypeFields({this.id, this.subTypeId, this.name, this.fieldId});

  SubTypeFields.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    subTypeId = json['sub_type_id'].toString();
    name = json['name'];
    fieldId = json['field_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sub_type_id'] = this.subTypeId;
    data['name'] = this.name;
    data['field_id'] = this.fieldId;
    return data;
  }
}
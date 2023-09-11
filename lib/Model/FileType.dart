class FileType {
  String id;
  String typeName;
  String status;

  FileType({this.id, this.typeName, this.status});

  FileType.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    typeName = json['type_name'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['type_name'] = this.typeName;
    data['status'] = this.status;
    return data;
  }
}
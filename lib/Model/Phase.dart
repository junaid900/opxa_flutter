class Phase {
  String id;
  String phase;
  String qkpFileId;

  Phase({this.id, this.phase, this.qkpFileId});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    phase = json['phase'].toString();
    qkpFileId = json['qkp_file_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['phase'] = this.phase;
    data['qkp_file_id'] = this.qkpFileId;
    return data;
  }
}
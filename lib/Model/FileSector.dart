class FileSector {
  String id;
  String sectorName;
  String societyId;
  String status;

  FileSector({this.id, this.sectorName, this.societyId, this.status});

  FileSector.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    sectorName = json['sector_name'].toString();
    societyId = json['society_id'].toString();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sector_name'] = this.sectorName;
    data['society_id'] = this.societyId;
    data['status'] = this.status;
    return data;
  }
}
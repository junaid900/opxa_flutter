class FileCommissionSociety {
  String id;
  String societyId;
  String percentage;
  String status;

  FileCommissionSociety(
      {this.id, this.societyId, this.percentage, this.status});

  FileCommissionSociety.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    societyId = json['society_id'].toString();
    percentage = json['percentage'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['society_id'] = this.societyId;
    data['percentage'] = this.percentage;
    data['status'] = this.status;
    return data;
  }
}
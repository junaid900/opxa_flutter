class Society {
  String id;
  String societyTitle;
  String societyName;
  String societyStatus;

  Society({this.id, this.societyTitle, this.societyName, this.societyStatus});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    societyTitle = json['society_title'].toString();
    societyName = json['society_name'].toString();
    societyStatus = json['society_status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['society_title'] = this.societyTitle;
    data['society_name'] = this.societyName;
    data['society_status'] = this.societyStatus;
    return data;
  }
}
class Complain {
  String id;
  String userId;
  String title;
  String description;
  String status;
  String adminDetails;

  Complain(
      {this.id,
        this.userId,
        this.title,
        this.description,
        this.status,
        this.adminDetails});

  Complain.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    title = json['title'];
    description = json['description'];
    status = json['status'];
    adminDetails = json['admin_details'] != null ? json['admin_details']:"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['status'] = this.status;
    data['admin_details'] = this.adminDetails;
    return data;
  }
}
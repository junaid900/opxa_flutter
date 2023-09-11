class PropertyNews {
  String id;
  String usersId;
  String title;
  String details;
  String image;
  String status;

  PropertyNews(
      {this.id,
        this.usersId,
        this.title,
        this.details,
        this.image,
        this.status});

  PropertyNews.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    usersId = json['users_id'].toString();
    title = json['title'].toString();
    details = json['details'].toString();
    image = json['image'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['users_id'] = this.usersId;
    data['title'] = this.title;
    data['details'] = this.details;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}
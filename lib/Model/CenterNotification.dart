class CenterNotification {
  String id;
  String receiverId;
  String title;
  String description;
  String image;
  String click;
  String readStatus;
  String data;
  String type;
  String createdAt;
  String updatedAt;

  CenterNotification(
      {this.id,
        this.receiverId,
        this.title,
        this.description,
        this.image,
        this.click,
        this.readStatus,
        this.data,
        this.type,
        this.createdAt,
        this.updatedAt});

  CenterNotification.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    receiverId = json['receiver_id'].toString();
    title = json['title'].toString();
    description = json['description'].toString();
    image = json['image'].toString();
    click = json['click'].toString();
    readStatus = json['read_status'].toString();
    data = json['data'].toString();
    type = json['type'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['receiver_id'] = this.receiverId;
    data['title'] = this.title;
    data['description'] = this.description;
    data['image'] = this.image;
    data['click'] = this.click;
    data['read_status'] = this.readStatus;
    data['data'] = this.data;
    data['type'] = this.type;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
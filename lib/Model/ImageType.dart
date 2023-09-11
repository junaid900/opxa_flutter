class ImageType {
  String id;
  String imageType;
  String status;

  ImageType({this.id, this.imageType, this.status});

  ImageType.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    imageType = json['image_type'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_type'] = this.imageType;
    data['status'] = this.status;
    return data;
  }
}
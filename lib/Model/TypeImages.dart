class TypeImages {
  String id;
  String imageType;
  String status;
  List<Images> images;

  TypeImages({this.id, this.imageType, this.status, this.images});

  TypeImages.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    imageType = json['image_type'].toString();
    status = json['status'].toString();
    if (json['images'] != null) {
      images = new List<Images>();
      json['images'].forEach((v) {
        images.add(new Images.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['image_type'] = this.imageType;
    data['status'] = this.status;
    if (this.images != null) {
      data['images'] = this.images.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Images {
  String id;
  String propertyId;
  String image;
  String imageTypeId;

  Images({this.id, this.propertyId, this.image, this.imageTypeId});

  Images.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    propertyId = json['property_id'].toString();
    image = json['image'].toString();
    imageTypeId = json['image_type_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['property_id'] = this.propertyId;
    data['image'] = this.image;
    data['image_type_id'] = this.imageTypeId;
    return data;
  }
}
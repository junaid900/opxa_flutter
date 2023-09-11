class PropertyFeatures {
  String id;
  String featureName;
  String status;
  List<Features> features;
  bool isOpen = false;

  PropertyFeatures({this.id, this.featureName, this.status, this.features});

  PropertyFeatures.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    featureName = json['feature_name'];
    status = json['status'];
    this.isOpen = false;
    if (json['features'] != null) {
      features = new List<Features>();
      json['features'].forEach((v) {
        features.add(new Features.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['feature_name'] = this.featureName;
    data['status'] = this.status;
    if (this.features != null) {
      data['features'] = this.features.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Features {
  String id;
  String itemId;
  String name;
  String type;
  String addFeatureId;
  String status;
  bool isDropdown;
  List<DropDownData> dropDownData;

  Features(
      {this.id,
        this.itemId,
        this.name,
        this.type,
        this.addFeatureId,
        this.status,
        this.isDropdown,
        this.dropDownData});

  Features.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    itemId = json['item_id'].toString();
    name = json['name'];
    type = json['type'];
    addFeatureId = json['add_feature_id'].toString();
    status = json['status'];
    isDropdown = json['isDropdown'];
    if (json['drop_down_data'] != null) {
      dropDownData = new List<DropDownData>();
      json['drop_down_data'].forEach((v) {
        dropDownData.add(new DropDownData.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['item_id'] = this.itemId;
    data['name'] = this.name;
    data['type'] = this.type;
    data['add_feature_id'] = this.addFeatureId;
    data['status'] = this.status;
    data['isDropdown'] = this.isDropdown;
    if (this.dropDownData != null) {
      data['drop_down_data'] =
          this.dropDownData.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class DropDownData {
  String id;
  String name;
  String featureId;
  String status;

  DropDownData({this.id, this.name, this.featureId, this.status});

  DropDownData.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    featureId = json['feature_id'].toString();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['feature_id'] = this.featureId;
    data['status'] = this.status;
    return data;
  }
}

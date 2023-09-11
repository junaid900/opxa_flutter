class Chat {
  String id;
  String userId;
  String otherUserId;
  String senderId;
  String receiverId;
  String supportId;
  String historyId;
  String type;
  String dateRequest;
  String status;
  String supportStatus;
  String createdAt;
  String updatedAt;
  String name;
  String otherFcm;
  int count;
  String message;
  History history;
  String profileImage;
  String otherName;
  String supportName;

  Chat(
      {this.id,
        this.userId,
        this.otherUserId,
        this.senderId,
        this.receiverId,
        this.supportId,
        this.historyId,
        this.type,
        this.dateRequest,
        this.status,
        this.supportStatus,
        this.createdAt,
        this.updatedAt,
        this.name,
        this.otherFcm,
        this.count,
        this.message,
        this.profileImage,
        this.history});

  Chat.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    userId = json['user_id'].toString();
    otherUserId = json['other_user_id'].toString();
    senderId = json['sender_id'].toString();
    receiverId = json['receiver_id'].toString();
    supportId = json['support_id'].toString();
    historyId = json['history_id'].toString();
    type = json['type'];
    dateRequest = json['date_request'];
    status = json['status'];
    supportStatus = json['support_status'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    name = json['name'];
    otherFcm = json['other_fcm'];
    count = json['count'];
    message = json['message'];
    otherName = json['other_name'];
    supportName = json['support_name'];
    profileImage = json['profile_image'] != null? json['profile_image']:"" ;
    history =
    json['history'] != null ? new History.fromJson(json['history']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['user_id'] = this.userId;
    data['other_user_id'] = this.otherUserId;
    data['sender_id'] = this.senderId;
    data['receiver_id'] = this.receiverId;
    data['support_id'] = this.supportId;
    data['history_id'] = this.historyId;
    data['type'] = this.type;
    data['date_request'] = this.dateRequest;
    data['status'] = this.status;
    data['support_status'] = this.supportStatus;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['name'] = this.name;
    data['other_fcm'] = this.otherFcm;
    data['count'] = this.count;
    data['message'] = this.message;
    if (this.history != null) {
      data['history'] = this.history.toJson();
    }
    return data;
  }
}

class History {
  String id;
  String name;
  String propertyName;
  String detail;
  String qkpFileSymbolId;
  String qkpUnitId;
  String fileType;
  String fileSubType;
  String town;
  String city;
  String unitType;
  String societyId;
  String unit;
  String phaseId;
  String createdAt;
  String updatedAt;

  History(
      {this.id,
        this.name,
        this.detail,
        this.qkpFileSymbolId,
        this.qkpUnitId,
        this.fileType,
        this.fileSubType,
        this.town,
        this.city,
        this.unitType,
        this.societyId,
        this.unit,
        this.phaseId,
        this.createdAt,
        this.updatedAt});

  History.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    propertyName = json['property_name'];
    detail = json['detail'];
    qkpFileSymbolId = json['qkp_file_symbol_id'].toString();
    qkpUnitId = json['qkp_unit_id'].toString();
    fileType = json['file_type'].toString();
    fileSubType = json['file_sub_type'].toString();
    town = json['town'].toString();
    city = json['city'].toString();
    unitType = json['unit_type'];
    societyId = json['society_id'].toString();
    unit = json['unit'].toString();
    phaseId = json['phase_id'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['property_name'] = this.propertyName;
    data['detail'] = this.detail;
    data['qkp_file_symbol_id'] = this.qkpFileSymbolId;
    data['qkp_unit_id'] = this.qkpUnitId;
    data['file_type'] = this.fileType;
    data['file_sub_type'] = this.fileSubType;
    data['town'] = this.town;
    data['city'] = this.city;
    data['unit_type'] = this.unitType;
    data['society_id'] = this.societyId;
    data['unit'] = this.unit;
    data['phase_id'] = this.phaseId;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    return data;
  }
}
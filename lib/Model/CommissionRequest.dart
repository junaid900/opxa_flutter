class CommissionRequest {
  String id;
  String historyId;
  String userId;
  String userType;
  String commissionAmount;
  String type;
  String status;
  String updatedAt;
  String createdAt;

  CommissionRequest(
      {this.id,
        this.historyId,
        this.userId,
        this.userType,
        this.commissionAmount,
        this.type,
        this.status,
        this.updatedAt,
        this.createdAt});

  CommissionRequest.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    historyId = json['history_id'].toString();
    userId = json['user_id'].toString();
    userType = json['user_type'].toString();
    commissionAmount = json['commission_amount'].toString();
    type = json['type'].toString();
    status = json['status'].toString();
    updatedAt = json['updated_at'].toString();
    createdAt = json['created_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['history_id'] = this.historyId;
    data['user_id'] = this.userId;
    data['user_type'] = this.userType;
    data['commission_amount'] = this.commissionAmount;
    data['type'] = this.type;
    data['status'] = this.status;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    return data;
  }
}
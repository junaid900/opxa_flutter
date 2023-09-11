class DirectDepositHistory {
  String id;
  String detail;
  String image;
  String slipNo;
  String amount;
  String userId;
  String packageId;
  String status;
  String adminStatus;
  String createdAt;
  String packageName;

  DirectDepositHistory(
      {this.id,
        this.detail,
        this.image,
        this.slipNo,
        this.amount,
        this.userId,
        this.packageId,
        this.status,
        this.adminStatus,
        this.createdAt,
        this.packageName});

  DirectDepositHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    detail = json['detail'].toString();
    image = json['image'].toString();
    slipNo = json['slipNo'].toString();
    amount = json['amount'].toString();
    userId = json['user_id'].toString();
    packageId = json['package_id'].toString();
    status = json['status'].toString();
    adminStatus = json['admin_status'].toString();
    createdAt = json['created_at'].toString();
    packageName = json['package_name'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['detail'] = this.detail;
    data['image'] = this.image;
    data['slipNo'] = this.slipNo;
    data['amount'] = this.amount;
    data['user_id'] = this.userId;
    data['package_id'] = this.packageId;
    data['status'] = this.status;
    data['admin_status'] = this.adminStatus;
    data['created_at'] = this.createdAt;
    data['package_name'] = this.packageName;
    return data;
  }
}
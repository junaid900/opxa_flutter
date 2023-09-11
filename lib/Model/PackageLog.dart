class PackageLog {
  String id;
  String packageId;
  String userId;
  String type;
  String bids;
  String createdAt;
  String description;
  String name;
  String price;
  String commissionAmount;
  String returnAmount;
  String status;
  String logDescription;
  String logBids;

  PackageLog(
      {this.id,
        this.packageId,
        this.userId,
        this.type,
        this.bids,
        this.createdAt,
        this.description,
        this.name,
        this.price,
        this.commissionAmount,
        this.returnAmount,
        this.logDescription,
        this.logBids,
        this.status});

  PackageLog.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    packageId = json['package_id'].toString();
    userId = json['user_id'].toString();
    type = json['type'].toString();
    bids = json['bids'].toString();
    createdAt = json['created_at'];
    description = json['description'];
    name = json['name'];
    price = json['price'].toString();
    commissionAmount = json['commission_amount'].toString();
    returnAmount = json['return_amount'].toString();
    status = json['status'].toString();
    logDescription = json['log_description'];
    logBids = json['log_bids'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['package_id'] = this.packageId;
    data['user_id'] = this.userId;
    data['type'] = this.type;
    data['bids'] = this.bids;
    data['created_at'] = this.createdAt;
    data['description'] = this.description;
    data['name'] = this.name;
    data['price'] = this.price;
    data['commission_amount'] = this.commissionAmount;
    data['return_amount'] = this.returnAmount;
    data['status'] = this.status;
    return data;
  }
}
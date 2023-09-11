class OwnerAccounts {
  int id;
  String accountName;
  String accountNo;
  String image;
  String status;
  String description;

  OwnerAccounts(
      {this.id, this.accountName, this.accountNo, this.image, this.status,this.description});

  OwnerAccounts.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    accountName = json['account_name'].toString();
    accountNo = json['account_no'].toString();
    image = json['image'].toString();
    status = json['status'].toString();
    description = json['description'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['account_name'] = this.accountName;
    data['account_no'] = this.accountNo;
    data['image'] = this.image;
    data['status'] = this.status;
    return data;
  }
}
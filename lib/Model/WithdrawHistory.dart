class WithdrawHistory {
  String id;
  String usersId;
  String bankName;
  String accountNo;
  String detail;
  String amount;
  String type;
  String status;
  String dateAdded;
  String requestStatus;

  WithdrawHistory(
      {this.id,
        this.usersId,
        this.bankName,
        this.accountNo,
        this.detail,
        this.amount,
        this.type,
        this.status,
        this.dateAdded,
        this.requestStatus});

  WithdrawHistory.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    usersId = json['users_id'].toString();
    bankName = json['bank_name'].toString();
    accountNo = json['account_no'].toString();
    detail = json['detail'].toString();
    amount = json['amount'].toString();
    type = json['type'].toString();
    status = json['status'].toString();
    dateAdded = json['date_added'].toString();
    requestStatus = json['request_status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['users_id'] = this.usersId;
    data['bank_name'] = this.bankName;
    data['account_no'] = this.accountNo;
    data['detail'] = this.detail;
    data['amount'] = this.amount;
    data['type'] = this.type;
    data['status'] = this.status;
    data['date_added'] = this.dateAdded;
    data['request_status'] = this.requestStatus;
    return data;
  }
}
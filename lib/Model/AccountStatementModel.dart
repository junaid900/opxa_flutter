class AccountStatementModel {
  String id;
  String usersId;
  String debit;
  String credit;
  String currentBalance;
  String message;
  String createdAt;

  AccountStatementModel(
      {this.id,
        this.usersId,
        this.debit,
        this.credit,
        this.currentBalance,
        this.message,
        this.createdAt});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    usersId = json['users_id'].toString();
    debit = json['debit'].toString();
    credit = json['credit'].toString();
    currentBalance = json['current_balance'].toString();
    message = json['message'].toString();
    createdAt = json['created_at'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['users_id'] = this.usersId;
    data['debit'] = this.debit;
    data['credit'] = this.credit;
    data['current_balance'] = this.currentBalance;
    data['message'] = this.message;
    data['created_at'] = this.createdAt;
    return data;
  }
}
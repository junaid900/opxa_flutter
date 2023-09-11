class UserAccountStatment {
  String id;
  String transactionsId;
  String usersId;
  String source;
  String type;
  String debit;
  String credit;
  String current;
  String createdAt;
  String updatedAt;
  String description;

  UserAccountStatment(
      {this.id,
        this.transactionsId,
        this.usersId,
        this.source,
        this.type,
        this.debit,
        this.credit,
        this.current,
        this.createdAt,
        this.updatedAt,
        this.description});

  UserAccountStatment.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    transactionsId = json['transactions_id'].toString();
    usersId = json['users_id'].toString();
    source = json['source'].toString();
    type = json['type'].toString();
    debit = json['debit'].toString();
    credit = json['credit'].toString();
    current = json['current'].toString();
    createdAt = json['created_at'].toString();
    updatedAt = json['updated_at'].toString();
    description = json['description'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['transactions_id'] = this.transactionsId;
    data['users_id'] = this.usersId;
    data['source'] = this.source;
    data['type'] = this.type;
    data['debit'] = this.debit;
    data['credit'] = this.credit;
    data['current'] = this.current;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['description'] = this.description;
    return data;
  }
}
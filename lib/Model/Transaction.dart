class Transaction {
  String id;
  String qkpFileHistoryId;
  String price;
  String action;
  String usersId;
  String dateAdded;

  Transaction(
      {this.id,
        this.qkpFileHistoryId,
        this.price,
        this.action,
        this.usersId,
        this.dateAdded});
  // {id: 16, transactions_id: 7, users_id: 25, source: jazzcash, type: Topup, debit: 20, credit: 0, current: 0, created_at: 2021-10-06 09:15:42, updated_at: 2021-10-06 09:15:42, description: Package Purchased}
  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    qkpFileHistoryId = json['qkp_file_history_id'].toString();
    price = json['price'].toString();
    action = json['action'];
    usersId = json['users_id'].toString();
    dateAdded = json['date_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qkp_file_history_id'] = this.qkpFileHistoryId;
    data['price'] = this.price;
    data['action'] = this.action;
    data['users_id'] = this.usersId;
    data['date_added'] = this.dateAdded;
    return data;
  }
}
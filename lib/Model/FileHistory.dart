class FileHistory {
  String id;
  String qkpFileSymbolId;
  String qkpFileActionId;
  String qkpFileId;
  String sellerId;
  String buyerId;
  String quantity;
  String price;
  String status;
  String createdDate;
  String updatedDate;

  FileHistory(
      {this.id,
        this.qkpFileSymbolId,
        this.qkpFileActionId,
        this.qkpFileId,
        this.sellerId,
        this.buyerId,
        this.quantity,
        this.price,
        this.status,
        this.createdDate,
        this.updatedDate});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    qkpFileSymbolId = json['qkp_file_symbol_id'].toString();
    qkpFileActionId = json['qkp_file_action_id'].toString();
    qkpFileId = json['qkp_file_id'].toString();
    sellerId = json['seller_id'].toString();
    buyerId = json['buyer_id'].toString();
    quantity = json['quantity'].toString();
    price = json['price'].toString();
    status = json['status'].toString();
    createdDate = json['created_date'].toString();
    updatedDate = json['updated_date'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['qkp_file_symbol_id'] = this.qkpFileSymbolId;
    data['qkp_file_action_id'] = this.qkpFileActionId;
    data['qkp_file_id'] = this.qkpFileId;
    data['seller_id'] = this.sellerId;
    data['buyer_id'] = this.buyerId;
    data['quantity'] = this.quantity;
    data['price'] = this.price;
    data['status'] = this.status;
    data['created_date'] = this.createdDate;
    data['updated_date'] = this.updatedDate;
    return data;
  }
}

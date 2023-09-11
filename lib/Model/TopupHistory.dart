class TopupHistory {
  String id;
  String usersId;
  String packagesId;
  String price;
  String dateAdded;

  TopupHistory(
      {this.id, this.usersId, this.packagesId, this.price, this.dateAdded});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    usersId = json['users_id'].toString();
    packagesId = json['packages_id'].toString();
    price = json['price'].toString();
    dateAdded = json['date_added'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['users_id'] = this.usersId;
    data['packages_id'] = this.packagesId;
    data['price'] = this.price;
    data['date_added'] = this.dateAdded;
    return data;
  }
}
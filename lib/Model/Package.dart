class Package {
  String id;
  String name;
  String description;
  String price;
  // String returnPrice;
  // String commissionPrice;
  String bids;
  String status;
  int quantity;

  Package(
      {this.id,
        this.name,
        this.description,
        this.price,
        this.bids,
        this.status});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'];
    description = json['description'];
    price = json['price'].toString();
    bids = json['bids'].toString();
    status = json['status'];
    quantity = 1;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['price'] = this.price;
    data['bids'] = this.bids;
    data['status'] = this.status;
    return data;
  }
}
class Symbol {
  String id;
  String symbol;
  String status;

  Symbol({this.id, this.symbol, this.status});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    symbol = json['symbol'].toString();
    status = json['status'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['symbol'] = this.symbol;
    data['status'] = this.status;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return symbol;
  }
}
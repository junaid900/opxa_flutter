class FileSymbol {
  String id;
  String symbol;
  String status;
  String fileId;

  FileSymbol({this.id, this.symbol, this.status});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    symbol = json['symbol'].toString();
    status = json['status'].toString();
    fileId = json['file_id'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['symbol'] = this.symbol;
    data['status'] = this.status;
    data['file_id'] = this.fileId;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return symbol;
  }
}
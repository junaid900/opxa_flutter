class MarketWatch {
  String fileId;
  String fileName;
  String qkpFileSymbolId;
  String symbol;
  String change;
  String changePercentage;
  String ldcp;
  String current;
  String open;
  String high;
  String low;
  String lastFileVolume;
  String totalFileVolume;

  MarketWatch(
      {this.fileId,
        this.fileName,
        this.qkpFileSymbolId,
        this.symbol,
        this.change,
        this.changePercentage,
        this.ldcp,
        this.current,
        this.open,
        this.high,
        this.low,
        this.lastFileVolume,
        this.totalFileVolume});

fromJson(Map<String, dynamic> json) {
    fileId = json['file_id'].toString();
    fileName = json['file_name'].toString();
    qkpFileSymbolId = json['qkp_file_symbol_id'].toString();
    symbol = json['symbol'].toString();
    change = json['change'].toString();
    changePercentage = json['change_percentage'].toString();
    ldcp = json['ldcp'].toString();
    current = json['current'].toString();
    open = json['open'].toString();
    high = json['high'].toString();
    low = json['low'].toString();
    lastFileVolume = json['last_file_volume'].toString();
    totalFileVolume = json['total_file_volume'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['file_id'] = this.fileId;
    data['file_name'] = this.fileName;
    data['qkp_file_symbol_id'] = this.qkpFileSymbolId;
    data['symbol'] = this.symbol;
    data['change'] = this.change;
    data['change_percentage'] = this.changePercentage;
    data['ldcp'] = this.ldcp;
    data['current'] = this.current;
    data['open'] = this.open;
    data['high'] = this.high;
    data['low'] = this.low;
    data['last_file_volume'] = this.lastFileVolume;
    data['total_file_volume'] = this.totalFileVolume;
    return data;
  }
}
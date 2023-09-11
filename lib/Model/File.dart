import 'Phase.dart';

class File {
  String id;
  String name;
  String detail;
  String qkpFileSymbolId;
  String qkpUnitId;
  String fileType;
  String fileSubType;
  String town;
  String city;
  String unitType;
  String unit;
  String createdAt;
  String updatedAt;
  String area;
  String symbol;
  String status;
  String fileName;
  String unitName;
  String townName;
  String societyId;
  String phaseId;
  String cityName;
  String societyTitle;
  String societyName;
  String phase;
  String ltcp;
  String type_id;
  String sector_id;
  String societyPercentage;
  String typeName;
  String sectorName;
  String phaseName;
  List<Phase> phases = [];

  File(
      {this.id,
        this.name,
        this.detail,
        this.qkpFileSymbolId,
        this.qkpUnitId,
        this.fileType,
        this.fileSubType,
        this.town,
        this.city,
        this.unitType,
        this.unit,
        this.createdAt,
        this.updatedAt,
        this.area,
        this.symbol,
        this.status,
        this.fileName,
        this.unitName,
        this.townName,
      this.societyId,
      this.phases,
      this.phase,
      this.societyTitle,
      this.societyName,
      this.cityName,
        this.phaseId,
        this.phaseName,
        this.ltcp
      });

  Future<bool> fromJson(Map<String, dynamic> json) {
    phases = [];
    id = json['id'].toString();
    name = json['name'];
    detail = json['detail'];
    qkpFileSymbolId = json['qkp_file_symbol_id'].toString();
    qkpUnitId = json['qkp_unit_id'].toString();
    fileType = json['file_type'].toString();
    fileSubType = json['file_sub_type'].toString();
    town = json['town'].toString();
    city = json['city'].toString();
    unitType = json['unit_type'].toString();
    unit = json['unit'].toString();
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    area = json['area'].toString();
    symbol = json['symbol'].toString();
    status = json['status'].toString();
    fileName = json['file_name'];
    unitName = json['unit_name'];
    townName = json['town_name'];

    societyId = json['society_id'].toString();
    societyName = json['society_name'];
    societyTitle = json['society_title'];
    phase = json['phase'].toString();
    cityName = json['city_name'];
    type_id = json['type_id'].toString();
    sector_id = json['sector_id'].toString();
    ltcp = json['ltcp'].toString();
    typeName = json['type_name'].toString();
    societyPercentage = json['society_percentage'].toString();
    sectorName = json['sector_name'].toString();

    phaseId = json['phase_id'].toString();
    phaseName = json['phase_name'].toString();
    if(json["phases"] != null) {
      for (int i = 0; i < json["phases"].length; i++) {
        Phase phase = new Phase();
        phase.fromJson(json["phases"][i]);
        this.phases.add(phase);
      }
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['detail'] = this.detail;
    data['qkp_file_symbol_id'] = this.qkpFileSymbolId;
    data['qkp_unit_id'] = this.qkpUnitId;
    data['file_type'] = this.fileType;
    data['file_sub_type'] = this.fileSubType;
    data['town'] = this.town;
    data['city'] = this.city;
    data['unit_type'] = this.unitType;
    data['unit'] = this.unit;
    data['created_at'] = this.createdAt;
    data['updated_at'] = this.updatedAt;
    data['area'] = this.area;
    data['symbol'] = this.symbol;
    data['status'] = this.status;
    data['file_name'] = this.fileName;
    data['unit_name'] = this.unitName;
    data['town_name'] = this.townName;
    data['society_id'] = this.societyId;
    data['phase_id'] = this.phaseId;
    data['ltcp'] = this.ltcp;
    data['phase_name'] = this.phaseName;
    return data;
  }
}
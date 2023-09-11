class PropertySociety {
  String id;
  String societyName;
  String status;
  List<Sectors> sectors;

  PropertySociety({this.id, this.societyName, this.status, this.sectors});

  PropertySociety.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    societyName = json['society_name'];
    status = json['status'];
    if (json['sectors'] != null) {
      sectors = new List<Sectors>();
      json['sectors'].forEach((v) {
        sectors.add(new Sectors.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['society_name'] = this.societyName;
    data['status'] = this.status;
    if (this.sectors != null) {
      data['sectors'] = this.sectors.map((v) => v.toJson()).toList();
    }
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return this.societyName;
  }
}

class Sectors {
  String id;
  String sectorName;
  String sectorSocietyId;
  String status;

  Sectors({this.id, this.sectorName, this.sectorSocietyId, this.status});

  Sectors.fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    sectorName = json['sector_name'];
    sectorSocietyId = json['sector_society_id'].toString();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['sector_name'] = this.sectorName;
    data['sector_society_id'] = this.sectorSocietyId;
    data['status'] = this.status;
    return data;
  }
  @override
  String toString() {
    // TODO: implement toString
    return this.sectorName;
  }
}
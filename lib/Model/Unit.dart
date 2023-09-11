class Units {
  String id;
  String name;
  String area;

  Units({this.id, this.name, this.area});

  fromJson(Map<String, dynamic> json) {
    id = json['id'].toString();
    name = json['name'].toString();
    area = json['area'].toString();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['area'] = this.area;
    return data;
  }
}
class ZoneModel {
  String? id;
  String? zoneName;
  String? zoneId;
  String? leaderName;
  num? timestamp;
  List<String>? areas;

  ZoneModel({this.zoneName, this.zoneId, this.leaderName, this.areas, this.id, this.timestamp});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zoneName = json['zoneName'];
    zoneId = json['zoneId'];
    leaderName = json['leaderName'];
    timestamp = json['timestamp'];
    areas = json['areas'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['zoneName'] = this.zoneName;
    data['zoneId'] = this.zoneId;
    data['leaderName'] = this.leaderName;
    data['timestamp'] = this.timestamp;
    data['areas'] = this.areas;
    return data;
  }
}

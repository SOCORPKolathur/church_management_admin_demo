import 'members_model.dart';

class ZoneModel {
  String? id;
  String? zoneName;
  String? zoneId;
  String? leaderName;
  String? leaderPhone;
  num? timestamp;
  List<String>? areas;
  List<MembersModel>? supporters;

  ZoneModel({this.zoneName, this.zoneId, this.leaderName, this.leaderPhone, this.areas, this.id,this.supporters, this.timestamp});

  ZoneModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zoneName = json['zoneName'];
    zoneId = json['zoneId'];
    leaderName = json['leaderName'];
    leaderPhone = json['leaderPhone'];
    timestamp = json['timestamp'];
    areas = json['areas'].cast<String>();
    if (json['supporters'] != null) {
      supporters = <MembersModel>[];
      json['supporters'].forEach((v) {
        supporters!.add(new MembersModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['zoneName'] = this.zoneName;
    data['zoneId'] = this.zoneId;
    data['leaderName'] = this.leaderName;
    data['leaderPhone'] = this.leaderPhone;
    data['timestamp'] = this.timestamp;
    data['areas'] = this.areas;
    if (this.supporters != null) {
      data['supporters'] = this.supporters!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

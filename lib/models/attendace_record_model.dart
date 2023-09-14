class AttendanceRecordModel {
  String? id;
  int? timestamp;
  String? name;

  AttendanceRecordModel({this.id, this.timestamp, this.name});

  AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['name'] = this.name;
    return data;
  }
}

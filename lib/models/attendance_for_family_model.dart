
class AttendanceFamilyRecordModel {
  String? date;
  List<AttendanceFamily>? attendance;

  AttendanceFamilyRecordModel({this.date, this.attendance});

  AttendanceFamilyRecordModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    if (json['attendance'] != null) {
      attendance = <AttendanceFamily>[];
      json['attendance'].forEach((v) {
        attendance!.add(new AttendanceFamily.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class AttendanceFamily {
  String? member;
  bool? present;
  String? memberId;

  AttendanceFamily({this.member, this.present, this.memberId});

  AttendanceFamily.fromJson(Map<String, dynamic> json) {
    member = json['member'];
    present = json['present'];
    memberId = json['memberId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['member'] = this.member;
    data['present'] = this.present;
    data['memberId'] = this.memberId;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return memberId!;
      case 2:
        return member!;
      case 3:
        return present! ? "Present" : "Absent";
    }
    return '';
  }


}
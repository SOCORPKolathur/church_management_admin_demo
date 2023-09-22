// class AttendanceRecordModel {
//   String? id;
//   int? timestamp;
//   String? name;
//
//   AttendanceRecordModel({this.id, this.timestamp, this.name});
//
//   AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
//     id = json['id'];
//     timestamp = json['timestamp'];
//     name = json['name'];
//   }
//
//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id'] = this.id;
//     data['timestamp'] = this.timestamp;
//     data['name'] = this.name;
//     return data;
//   }
// }

class AttendanceRecordModel {
  num? timestamp;
  String? date;
  List<Attendance>? attendance;

  AttendanceRecordModel({this.date, this.attendance, this.timestamp});

  AttendanceRecordModel.fromJson(Map<String, dynamic> json) {
    timestamp = json['timestamp'];
    date = json['date'];
    if (json['attendance'] != null) {
      attendance = <Attendance>[];
      json['attendance'].forEach((v) {
        attendance!.add(new Attendance.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['timestamp'] = this.timestamp;
    if (this.attendance != null) {
      data['attendance'] = this.attendance!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Attendance {
  String? student;
  bool? present;
  String? studentId;

  Attendance({this.student, this.present, this.studentId});

  Attendance.fromJson(Map<String, dynamic> json) {
    student = json['student'];
    present = json['present'];
    studentId = json['studentId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['student'] = this.student;
    data['present'] = this.present;
    data['studentId'] = this.studentId;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return studentId!;
      case 2:
        return student!;
      case 3:
        return present! ? "Present" : "Absent";
    }
    return '';
  }

}

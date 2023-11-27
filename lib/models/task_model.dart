class TaskModel {
  String? id;
  String? zoneName;
  String? zoneId;
  String? leaderName;
  String? taskName;
  String? taskDescription;
  String? taskDueDate;
  String? date;
  String? time;
  String? submittedTime;
  String? submittedDate;
  int? timestamp;
  String? status;
  String? feedback;

  TaskModel(
      {this.zoneName,
        this.zoneId,
        this.leaderName,
        this.taskName,
        this.taskDescription,
        this.taskDueDate,
        this.date,
        this.time,
        this.submittedTime,
        this.submittedDate,
        this.timestamp,
        this.status,
        this.id,
        this.feedback});

  TaskModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    zoneName = json['zoneName'];
    zoneId = json['zoneId'];
    leaderName = json['leaderName'];
    submittedTime = json['submittedTime'];
    submittedDate = json['submittedDate'];
    taskName = json['taskName'];
    taskDescription = json['taskDescription'];
    taskDueDate = json['taskDueDate'];
    date = json['date'];
    time = json['time'];
    timestamp = json['timestamp'];
    status = json['status'];
    feedback = json['feedback'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['zoneName'] = this.zoneName;
    data['leaderName'] = this.leaderName;
    data['submittedTime'] = this.submittedTime;
    data['submittedDate'] = this.submittedDate;
    data['zoneId'] = this.zoneId;
    data['taskName'] = this.taskName;
    data['taskDescription'] = this.taskDescription;
    data['taskDueDate'] = this.taskDueDate;
    data['date'] = this.date;
    data['time'] = this.time;
    data['timestamp'] = this.timestamp;
    data['status'] = this.status;
    data['feedback'] = this.feedback;
    return data;
  }
}

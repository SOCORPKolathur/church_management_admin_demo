class NotificationModel {
  String? date;
  String? time;
  String? to;
  String? subject;
  String? content;

  NotificationModel(
      {this.date, this.time, this.to, this.subject, this.content});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    to = json['to'];
    subject = json['subject'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['to'] = this.to;
    data['subject'] = this.subject;
    data['content'] = this.content;
    return data;
  }
}

class NotificationModel {
  String? date;
  String? time;
  num? timestamp;
  String? to;
  String? subject;
  String? content;
  bool? isViewed;
  List<String>? viewsCount;

  NotificationModel({this.date, this.time, this.to, this.subject, this.content,this.isViewed,this.viewsCount, required this.timestamp});

  NotificationModel.fromJson(Map<String, dynamic> json) {
    date = json['date'];
    time = json['time'];
    timestamp = json['timestamp'];
    to = json['to'];
    subject = json['subject'];
    content = json['content'];
    isViewed = json['isViewed'];
    if (json['viewsCount'] != null) {
      viewsCount = <String>[];
      json['viewsCount'].forEach((v) {
        viewsCount!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['date'] = this.date;
    data['time'] = this.time;
    data['timestamp'] = this.timestamp;
    data['to'] = this.to;
    data['subject'] = this.subject;
    data['content'] = this.content;
    data['isViewed'] = this.isViewed;
    if (this.viewsCount != null) {
      data['viewsCount'] = this.viewsCount;
    }
    return data;
  }
}

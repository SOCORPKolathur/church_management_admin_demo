class MessageModel {
  String? id;
  String? title;
  String? content;
  String? date;
  String? time;
  bool? isViewed;
  num? timestamp;

  MessageModel({this.id, this.title, this.content, this.date, this.time, this.isViewed, this.timestamp});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    date = json['date'];
    time = json['time'];
    isViewed = json['isViewed'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date'] = this.date;
    data['time'] = this.time;
    data['isViewed'] = this.isViewed;
    data['timestamp'] = this.timestamp;
    return data;
  }
}

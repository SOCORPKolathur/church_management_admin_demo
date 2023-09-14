class MessageModel {
  String? id;
  String? title;
  String? content;
  String? date;
  String? time;

  MessageModel({this.id, this.title, this.content, this.date, this.time});

  MessageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    date = json['date'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['title'] = this.title;
    data['content'] = this.content;
    data['date'] = this.date;
    data['time'] = this.time;
    return data;
  }
}

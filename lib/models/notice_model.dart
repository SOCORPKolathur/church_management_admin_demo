class NoticeModel {
  String? id;
  String? title;
  String? description;
  String? date;
  String? time;
  num? timestamp;
  List<String>? views;

  NoticeModel({this.title, this.description, this.id,this.timestamp,this.date,this.time,this.views});

  NoticeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    title = json['title'];
    description = json['description'];
    timestamp = json['timestamp'];
    if (json['views'] != null) {
      views = <String>[];
      json['views'].forEach((v) {
        views!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['title'] = this.title;
    data['description'] = this.description;
    data['timestamp'] = this.timestamp;
    if (this.views != null) {
      data['views'] = this.views!.map((v) => v).toList();
    }
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return title!;
      case 2:
        return description!;
    }
    return '';
  }

}

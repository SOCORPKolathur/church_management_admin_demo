class PrayersModel {
  String? id;
  String? title;
  String? date;
  String? time;
  String? description;
  num? timestamp;

  PrayersModel({this.title, this.description, this.id,this.timestamp,this.date,this.time});

  PrayersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    title = json['title'];
    description = json['description'];
    timestamp = json['timestamp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['title'] = this.title;
    data['description'] = this.description;
    data['timestamp'] = this.timestamp;
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

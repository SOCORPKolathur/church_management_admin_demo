class EventsModel {
  String? id;
  String? date;
  num? views;
  num? timestamp;
  String? description;
  String? imgUrl;
  String? location;
  String? time;

  EventsModel(
      {this.id, this.date, this.views, this.description, this.imgUrl, this.timestamp, this.location, this.time});

  EventsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    views = json['views'];
    timestamp = json['timestamp'];
    description = json['description'];
    imgUrl = json['imgUrl'];
    location = json['location'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['date'] = this.date;
    data['views'] = this.views;
    data['timestamp'] = this.timestamp;
    data['description'] = this.description;
    data['imgUrl'] = this.imgUrl;
    data['location'] = this.location;
    data['time'] = this.time;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return date!;
      case 2:
        return time!;
      case 3:
        return location!.toString();
      case 4:
        return description!;
    }
    return '';
  }
}

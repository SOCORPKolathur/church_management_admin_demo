class TestimonialsModel {
  String? id;
  String? title;
  String? date;
  String? time;
  String? description;
  num? timestamp;
  String? phone;
  String? status;
  String? requestedBy;

  TestimonialsModel({this.title,this.phone,this.status,this.requestedBy, this.description, this.id,this.timestamp,this.date,this.time});

  TestimonialsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    date = json['date'];
    time = json['time'];
    title = json['title'];
    description = json['description'];
    timestamp = json['timestamp'];
    phone = json['phone'];
    status = json['status'];
    requestedBy = json['requestedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = this.id;
    data['date'] = this.date;
    data['time'] = this.time;
    data['title'] = this.title;
    data['description'] = this.description;
    data['timestamp'] = this.timestamp;
    data['phone'] = this.phone;
    data['status'] = this.status;
    data['requestedBy'] = this.requestedBy;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return title!;
      case 2:
        return date!;
      case 3:
        return time!;
      case 4:
        return description!;
    }
    return '';
  }

}

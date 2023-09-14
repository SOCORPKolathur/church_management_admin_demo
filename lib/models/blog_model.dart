class BlogModel {
  String? id;
  int? timestamp;
  String? title;
  String? description;
  String? time;
  String? author;
  String? imgUrl;

  BlogModel(
      {this.id,
        this.timestamp,
        this.title,
        this.description,
        this.time,
        this.author,
        this.imgUrl});

  BlogModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    title = json['title'];
    description = json['description'];
    time = json['time'];
    author = json['author'];
    imgUrl = json['imgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['title'] = this.title;
    data['description'] = this.description;
    data['time'] = this.time;
    data['author'] = this.author;
    data['imgUrl'] = this.imgUrl;
    return data;
  }
}

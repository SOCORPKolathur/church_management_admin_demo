class BlogModel {
  String? id;
  int? timestamp;
  String? title;
  String? description;
  String? time;
  String? author;
  String? imgUrl;
  List<String>? views;
  List<String>? likes;

  BlogModel(
      {this.id,
        this.timestamp,
        this.title,
        this.description,
        this.time,
        this.views,
        this.likes,
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
    if (json['views'] != null) {
      views = <String>[];
      json['views'].forEach((v) {
        views!.add(v);
      });
    }
    if (json['likes'] != null) {
      likes = <String>[];
      json['likes'].forEach((v) {
        likes!.add(v);
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['title'] = this.title;
    data['description'] = this.description;
    data['time'] = this.time;
    if (this.views != null) {
      data['views'] = this.views!.map((v) => v).toList();
    }
    if (this.likes != null) {
      data['likes'] = this.likes!.map((v) => v).toList();
    }
    data['author'] = this.author;
    data['imgUrl'] = this.imgUrl;
    return data;
  }
}

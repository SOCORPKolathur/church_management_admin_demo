class GalleryImageModel {
  String? id;
  String? imgUrl;

  GalleryImageModel({this.id, this.imgUrl});

  GalleryImageModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgUrl = json['imgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['imgUrl'] = imgUrl;
    return data;
  }
}

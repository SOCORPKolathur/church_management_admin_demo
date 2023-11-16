class WishesTemplate {
  String? title;
  String? id;
  String? content;
  bool? selected;
  bool? withName;

  WishesTemplate({required this.title, required this.content,required  this.selected,required  this.id,required this.withName});

  WishesTemplate.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    content = json['content'];
    selected = json['selected'];
    withName = json['withName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['content'] = this.content;
    data['selected'] = this.selected;
    data['withName'] = this.withName;
    return data;
  }
}

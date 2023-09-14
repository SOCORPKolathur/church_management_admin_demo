class WishesTemplate {
  String? title;
  String? id;
  String? content;
  bool? selected;

  WishesTemplate({required this.title, required this.content,required  this.selected,required  this.id});

  WishesTemplate.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    content = json['content'];
    selected = json['selected'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['id'] = this.id;
    data['content'] = this.content;
    data['selected'] = this.selected;
    return data;
  }
}

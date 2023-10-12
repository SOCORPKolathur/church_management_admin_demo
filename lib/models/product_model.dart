class ProductModel {
  String? id;
  String? productId;
  int? timestamp;
  String? title;
  String? imgUrl;
  String? description;
  String? categories;
  String? tags;
  String? sale;
  double? price;

  ProductModel(
      {this.id,
        this.productId,
        this.timestamp,
        this.title,
        this.imgUrl,
        this.description,
        this.categories,
        this.tags,
        this.sale,
        this.price});

  ProductModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    productId = json['productId'];
    timestamp = json['timestamp'];
    title = json['title'];
    imgUrl = json['imgUrl'];
    description = json['description'];
    categories = json['categories'];
    tags = json['tags'];
    sale = json['sale'];
    price = json['price'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['productId'] = this.productId;
    data['timestamp'] = this.timestamp;
    data['title'] = this.title;
    data['imgUrl'] = this.imgUrl;
    data['description'] = this.description;
    data['categories'] = this.categories;
    data['tags'] = this.tags;
    data['sale'] = this.sale;
    data['price'] = this.price;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return title!;
      case 2:
        return _formatCurrency(price!);
      case 3:
        return categories!.toString();
      case 4:
        return tags!;
    }
    return '';
  }

  String _formatCurrency(double amount) {
    return 'Rs ${amount.toStringAsFixed(2)}';
  }
}

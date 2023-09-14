class OrdersModel {
  String? id;
  num? timestamp;
  String? userName;
  String? orderId;
  double? amount;
  String? method;
  String? date;
  String? phone;
  String? address;
  String? status;
  List<Products>? products;

  OrdersModel(
      {this.id,
        this.timestamp,
        this.userName,
        this.orderId,
        this.amount,
        this.method,
        this.date,
        this.phone,
        this.address,
        this.status,
        this.products});

  OrdersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    userName = json['userName'];
    orderId = json['orderId'];
    amount = json['amount'];
    method = json['method'];
    date = json['date'];
    phone = json['phone'];
    address = json['address'];
    status = json['status'];
    if (json['products'] != null) {
      products = <Products>[];
      json['products'].forEach((v) {
        products!.add(new Products.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['userName'] = this.userName;
    data['orderId'] = this.orderId;
    data['amount'] = this.amount;
    data['method'] = this.method;
    data['date'] = this.date;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['status'] = this.status;
    if (this.products != null) {
      data['products'] = this.products!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return userName!;
      case 2:
        return products!.first.name!;
      case 2:
        return amount!.toString();
      case 2:
        return method!;
      case 2:
        return status!;
      case 2:
        return address!;
    }
    return '';
  }
}

class Products {
  String? id;
  String? name;
  double? price;
  int? quantity;

  Products({this.id, this.name, this.price, this.quantity});

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['price'] = this.price;
    data['quantity'] = this.quantity;
    return data;
  }



}

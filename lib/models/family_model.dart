class FamilyModel {
  String? id;
  num? timestamp;
  String? name;
  String? leaderName;
  int? quantity;
  String? contactNumber;
  String? address;
  String? city;
  String? country;
  String? zone;

  FamilyModel(
      {this.name,
        this.leaderName,
        this.id,
        this.timestamp,
        this.quantity,
        this.contactNumber,
        this.address,
        this.city,
        this.country,
        this.zone});

  FamilyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    timestamp = json['timestamp'];
    leaderName = json['leaderName'];
    quantity = json['quantity'];
    contactNumber = json['contactNumber'];
    address = json['address'];
    city = json['city'];
    country = json['country'];
    zone = json['zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['name'] = this.name;
    data['leaderName'] = this.leaderName;
    data['quantity'] = this.quantity;
    data['contactNumber'] = this.contactNumber;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['zone'] = this.zone;
    return data;
  }
}

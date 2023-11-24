class FamilyModel {
  String? id;
  String? familyId;
  num? timestamp;
  String? leaderImgUrl;
  String? name;
  String? email;
  String? leaderName;
  int? quantity;
  String? contactNumber;
  String? address;
  //String? permanentAddress;
  String? city;
  String? country;
  String? zone;

  FamilyModel(
      {this.name,
        this.leaderName,
        this.leaderImgUrl,
        this.email,
        this.familyId,
        this.id,
        this.timestamp,
        this.quantity,
        this.contactNumber,
        this.address,
       // this.permanentAddress,
        this.city,
        this.country,
        this.zone});

  FamilyModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    leaderImgUrl = json['leaderImgUrl'];
    familyId = json['familyId'];
    timestamp = json['timestamp'];
    leaderName = json['leaderName'];
    quantity = json['quantity'];
    contactNumber = json['contactNumber'];
    address = json['address'];
   // permanentAddress = json['permanentAddress'];
    city = json['city'];
    country = json['country'];
    zone = json['zone'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['familyId'] = this.familyId;
    data['email'] = this.email;
    data['leaderImgUrl'] = this.leaderImgUrl;
    data['timestamp'] = this.timestamp;
    data['name'] = this.name;
    data['leaderName'] = this.leaderName;
    data['quantity'] = this.quantity;
    data['contactNumber'] = this.contactNumber;
    data['address'] = this.address;
    //data['permanentAddress'] = this.permanentAddress;
    data['city'] = this.city;
    data['country'] = this.country;
    data['zone'] = this.zone;
    return data;
  }
}

class ChurchDetailsModel {
  String? id;
  String? name;
  String? phone;
  String? buildingNo;
  String? streetName;
  String? area;
  String? city;
  String? state;
  String? pincode;
  String? website;
  String? adminEmail;
  String? adminPassword;
  String? managerEmail;
  String? managerPassword;

  ChurchDetailsModel(
      {this.id,
        this.name,
        this.phone,
        this.buildingNo,
        this.streetName,
        this.area,
        this.city,
        this.state,
        this.pincode,
        this.website,
        this.adminEmail,
        this.adminPassword,
        this.managerEmail,
        this.managerPassword});

  ChurchDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    buildingNo = json['buildingNo'];
    streetName = json['streetName'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    website = json['website'];
    adminEmail = json['adminEmail'];
    adminPassword = json['adminPassword'];
    managerEmail = json['managerEmail'];
    managerPassword = json['managerPassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['buildingNo'] = this.buildingNo;
    data['streetName'] = this.streetName;
    data['area'] = this.area;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['website'] = this.website;
    data['adminEmail'] = this.adminEmail;
    data['adminPassword'] = this.adminPassword;
    data['managerEmail'] = this.managerEmail;
    data['managerPassword'] = this.managerPassword;
    return data;
  }
}

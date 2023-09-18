class DepartmentModel {
  String? id;
  num? timestamp;
  String? name;
  String? leaderName;
  String? contactNumber;
  String? location;
  String? description;
  String? address;
  String? city;
  String? country;
  String? zone;

  DepartmentModel(
      {this.id,
        this.name,
        this.timestamp,
        this.leaderName,
        this.contactNumber,
        this.location,
        this.description,
        this.address,
        this.city,
        this.country,
        this.zone});

  DepartmentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    name = json['name'];
    leaderName = json['leaderName'];
    contactNumber = json['contactNumber'];
    location = json['location'];
    description = json['description'];
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
    data['contactNumber'] = this.contactNumber;
    data['location'] = this.location;
    data['description'] = this.description;
    data['address'] = this.address;
    data['city'] = this.city;
    data['country'] = this.country;
    data['zone'] = this.zone;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return name!;
      case 2:
        return leaderName!;
      case 3:
        return contactNumber!.toString();
      case 4:
        return zone!;
    }
    return '';
  }

}

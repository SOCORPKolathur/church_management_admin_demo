class CommitteeModel {
  String? id;
  num? timestamp;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? gender;
  String? address;
  String? position;
  String? baptizeDate;
  String? marriageDate;
  String? socialStatus;
  String? job;
  String? country;
  String? family;
  String? department;
  String? bloodGroup;
  String? dob;
  String? nationality;
  String? imgUrl;

  CommitteeModel(
      {this.id,
        this.firstName,
        this.lastName,
        this.address,
        this.timestamp,
        this.gender,
        this.phone,
        this.email,
        this.country,
        this.position,
        this.baptizeDate,
        this.marriageDate,
        this.socialStatus,
        this.job,
        this.family,
        this.department,
        this.bloodGroup,
        this.dob,
        this.nationality,
        this.imgUrl});

  CommitteeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    address = json['address'];
    firstName = json['firstName'];
    gender = json['gender'];
    lastName = json['lastName'];
    country = json['country'];
    phone = json['phone'];
    email = json['email'];
    position = json['position'];
    baptizeDate = json['baptizeDate'];
    marriageDate = json['marriageDate'];
    socialStatus = json['socialStatus'];
    job = json['job'];
    family = json['family'];
    department = json['department'];
    bloodGroup = json['bloodGroup'];
    dob = json['dob'];
    nationality = json['nationality'];
    imgUrl = json['imgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['address'] = this.address;
    data['firstName'] = this.firstName;
    data['gender'] = this.gender;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['position'] = this.position;
    data['country'] = this.country;
    data['baptizeDate'] = this.baptizeDate;
    data['marriageDate'] = this.marriageDate;
    data['socialStatus'] = this.socialStatus;
    data['job'] = this.job;
    data['family'] = this.family;
    data['department'] = this.department;
    data['bloodGroup'] = this.bloodGroup;
    data['dob'] = this.dob;
    data['nationality'] = this.nationality;
    data['imgUrl'] = this.imgUrl;
    return data;
  }
}

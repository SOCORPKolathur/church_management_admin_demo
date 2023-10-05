class PastorsModel {
  String? id;
  num? timestamp;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? address;
  String? gender;
  String? aadharNo;
  String? position;
  String? baptizeDate;
  String? marriageDate;
  String? socialStatus;
  String? job;
  String? country;
  String? family;
  String? familyId;
  String? maritalStatus;
  String? department;
  String? bloodGroup;
  String? dob;
  String? nationality;
  String? pincode;
  String? imgUrl;

  PastorsModel(
      {this.id,
        this.firstName,
        this.lastName,
        this.timestamp,
        this.address,
        this.gender,
        this.aadharNo,
        this.phone,
        this.email,
        this.country,
        this.position,
        this.pincode,
        this.baptizeDate,
        this.marriageDate,
        this.socialStatus,
        this.job,
        this.family,
        this.familyId,
        this.maritalStatus,
        this.department,
        this.bloodGroup,
        this.dob,
        this.nationality,
        this.imgUrl});

  PastorsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    country = json['country'];
    aadharNo = json['aadharNo'];
    phone = json['phone'];
    pincode = json['pincode'];
    address = json['address'];
    gender = json['gender'];
    email = json['email'];
    position = json['position'];
    baptizeDate = json['baptizeDate'];
    marriageDate = json['marriageDate'];
    socialStatus = json['socialStatus'];
    job = json['job'];
    family = json['family'];
    familyId = json['familyId'];
    maritalStatus = json['maritalStatus'];
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
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['address'] = this.address;
    data['aadharNo'] = this.aadharNo;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['position'] = this.position;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['baptizeDate'] = this.baptizeDate;
    data['marriageDate'] = this.marriageDate;
    data['socialStatus'] = this.socialStatus;
    data['job'] = this.job;
    data['family'] = this.family;
    data['familyId'] = this.familyId;
    data['maritalStatus'] = this.maritalStatus;
    data['department'] = this.department;
    data['bloodGroup'] = this.bloodGroup;
    data['dob'] = this.dob;
    data['nationality'] = this.nationality;
    data['imgUrl'] = this.imgUrl;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return "${firstName!} ${lastName!}";
      case 2:
        return position!;
      case 3:
        return phone!.toString();
      case 4:
        return nationality!;
    }
    return '';
  }

}

class ChurchStaffModel {
  String? id;
  num? timestamp;
  String? firstName;
  String? lastName;
  String? phone;
  String? gender;
  String? email;
  String? address;
  String? permanentAddress;
  String? aadharNo;
  String? document;
  String? dateOfJoining;
  String? position;
  String? baptizeDate;
  String? marriageDate;
  String? maritalStatus;
  String? socialStatus;
  String? job;
  String? country;
  String? family;
  String? familyId;
  String? department;
  String? bloodGroup;
  String? dob;
  String? pincode;
  String? nationality;
  String? landMark;
  String? imgUrl;

  ChurchStaffModel(
      {this.id,
        this.firstName,
        this.address,
        this.permanentAddress,
        this.dateOfJoining,
        this.document,
        this.aadharNo,
        this.lastName,
        this.timestamp,
        this.phone,
        this.pincode,
        this.email,
        this.country,
        this.gender,
        this.position,
        this.landMark,
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

  ChurchStaffModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    address = json['address'];
    permanentAddress = json['permanentAddress'];
    landMark = json['landMark'];
    aadharNo = json['aadharNo'];
    dateOfJoining = json['dateOfJoining'];
    document = json['document'];
    firstName = json['firstName'];
    gender = json['gender'];
    pincode = json['pincode'];
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
    data['address'] = this.address;
    data['permanentAddress'] = this.permanentAddress;
    data['aadharNo'] = this.aadharNo;
    data['landMark'] = this.landMark;
    data['dateOfJoining'] = this.dateOfJoining;
    data['document'] = this.document;
    data['firstName'] = this.firstName;
    data['gender'] = this.gender;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['pincode'] = this.pincode;
    data['email'] = this.email;
    data['position'] = this.position;
    data['country'] = this.country;
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
        return gender!;
    }
    return '';
  }

}

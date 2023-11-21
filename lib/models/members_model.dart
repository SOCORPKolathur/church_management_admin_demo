class MembersModel {
  String? id;
  String? memberId;
  num? timestamp;
  String? firstName;
  String? lastName;
  String? aadharNo;
  String? phone;
  String? email;
  String? position;
  String? baptizeDate;
  String? marriageDate;
  String? gender;
  String? permanentAddress;
  String? resistentialAddress;
  String? houseType;
  String? baptizemCertificate;
  String? socialStatus;
  String? serviceLanguage;
  String? job;
  String? country;
  String? family;
  String? familyid;
  String? department;
  String? bloodGroup;
  String? dob;
  String? nationality;
  String? imgUrl;
  String? pincode;
  String? landMark;
  String? previousChurch;
  String? qualification;
  String? maritalStatus;
  String? relationToFamily;
  String? attendingTime;



  MembersModel(
      {this.id,
        this.firstName,
        this.landMark,
        this.previousChurch,
        this.maritalStatus,
        this.relationToFamily,
        this.attendingTime,
        this.lastName,
        this.aadharNo,
        this.memberId,
        this.timestamp,
        this.phone,
        this.gender,
        this.baptizemCertificate,
        this.permanentAddress,
        this.resistentialAddress,
        this.houseType,
        this.email,
        this.qualification,
        this.country,
        this.position,
        this.baptizeDate,
        this.marriageDate,
        this.socialStatus,
        this.serviceLanguage,
        this.job,
        this.family,
        this.familyid,
        this.department,
        this.bloodGroup,
        this.dob,
        this.nationality,
        this.pincode,
        this.imgUrl});

  MembersModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    memberId = json['memberId'];
    timestamp = json['timestamp'];
    gender = json['gender'];
    aadharNo = json['aadharNo'];
    permanentAddress = json['permanentAddress'];
    resistentialAddress = json['resistentialAddress'];
    houseType = json['houseType'];
    baptizemCertificate = json['baptizemCertificate'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    country = json['country'];
    pincode = json['pincode'];
    phone = json['phone'];
    email = json['email'];
    position = json['position'];
    baptizeDate = json['baptizeDate'];
    marriageDate = json['marriageDate'];
    socialStatus = json['socialStatus'];
    serviceLanguage = json['serviceLanguage'];
    job = json['job'];
    family = json['family'];
    familyid = json['familyid'];
    department = json['department'];
    bloodGroup = json['bloodGroup'];
    dob = json['dob'];
    nationality = json['nationality'];
    imgUrl = json['imgUrl'];
    qualification = json['qualification'];
    maritalStatus = json['maritalStatus'];
    relationToFamily = json['relationToFamily'];
    attendingTime = json['attendingTime'];
    previousChurch = json['previousChurch'];
    landMark = json['landMark'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    
    data['qualification'] = this.qualification;
    data['relationToFamily'] = this.relationToFamily;
    data['maritalStatus'] = this.maritalStatus;
    data['attendingTime'] = this.attendingTime;
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['timestamp'] = this.timestamp;
    data['aadharNo'] = this.aadharNo;
    data['baptizemCertificate'] = this.baptizemCertificate;
    data['gender'] = this.gender;
    data['houseType'] = this.houseType;
    data['permanentAddress'] = this.permanentAddress;
    data['resistentialAddress'] = this.resistentialAddress;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['position'] = this.position;
    data['country'] = this.country;
    data['pincode'] = this.pincode;
    data['baptizeDate'] = this.baptizeDate;
    data['marriageDate'] = this.marriageDate;
    data['socialStatus'] = this.socialStatus;
    data['serviceLanguage'] = this.serviceLanguage;
    data['job'] = this.job;
    data['family'] = this.family;
    data['familyid'] = this.familyid;
    data['department'] = this.department;
    data['bloodGroup'] = this.bloodGroup;
    data['dob'] = this.dob;
    data['nationality'] = this.nationality;
    data['imgUrl'] = this.imgUrl;
    data['landMark'] = this.landMark;
    data['previousChurch'] = this.previousChurch;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return memberId!;
      case 2:
        return "${firstName!} ${lastName!}";
      case 3:
        return position!;
      case 4:
        return phone!.toString();
      case 5:
        return pincode!;
    }
    return '';
  }

}

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
  String? address;
  String? baptizemCertificate;
  String? socialStatus;
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


  String? qualification;
  String? maritalStatus;
  String? relationToFamily;
  String? attendingTime;



  MembersModel(
      {this.id,
        this.firstName,
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
        this.address,
        this.email,
        this.qualification,
        this.country,
        this.position,
        this.baptizeDate,
        this.marriageDate,
        this.socialStatus,
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
    address = json['address'];
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
    relationToFamily = json['maritalStatus'];
    attendingTime = json['attendingTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    
    data['qualification'] = this.qualification;
    data['maritalStatus'] = this.maritalStatus;
    data['maritalStatus'] = this.maritalStatus;
    data['attendingTime'] = this.attendingTime;
    data['id'] = this.id;
    data['memberId'] = this.memberId;
    data['timestamp'] = this.timestamp;
    data['aadharNo'] = this.aadharNo;
    data['baptizemCertificate'] = this.baptizemCertificate;
    data['gender'] = this.gender;
    data['address'] = this.address;
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
    data['job'] = this.job;
    data['family'] = this.family;
    data['familyid'] = this.familyid;
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

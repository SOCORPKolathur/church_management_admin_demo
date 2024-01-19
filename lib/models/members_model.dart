class MembersModel {
  String? id;
  String? memberId;
  num? timestamp;
  String? prefix;
  String? firstName;
  String? middleName;
  String? lastName;
  String? gender;
  String? bloodGroup;
  String? dob;
  String? baptizeDate;
  String? conDate;
  String? aadharNo;
  String? maritalStatus;
  String? marriageDate;
  String? family;
  String? familyid;
  String? relationToFamily;
  String? previousChurch;
  String? serviceLanguage;
  String? attendingTime;
  String? position;
  String? qualification;
  String? companyname;
  String? phone;
  String? alphone;
  String? email;
  String? alterNativeemail;
  String? state;
  String? city;
  String? country;
  String? pincode;
  String? houseType;
  String? resistentialAddress;
  String? permanentAddress;


  String? baptizemCertificate;
  bool? status;
  String? imgUrl;

  MembersModel(
      {this.id,
        this.prefix,
        this.firstName,
        this.middleName,
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
        this.status,
        this.baptizeDate,
        this.marriageDate,

        this.serviceLanguage,

        this.family,
        this.familyid,

        this.bloodGroup,
        this.dob,

        this.pincode,
        this.alterNativeemail,

        this.state,
        this.imgUrl,

        this.alphone,
        this.city,
        this.companyname,
        this.conDate,



      });

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
    prefix = json['prefix'];
    firstName = json['firstName'];
    middleName = json['middleName'];
    lastName = json['lastName'];
    status = json['status'];
    country = json['country'];
    pincode = json['pincode'];
    phone = json['phone'];
    email = json['email'];
    alterNativeemail = json['alterNativeemail'];

    state = json['state'];
    position = json['position'];
    baptizeDate = json['baptizeDate'];
    marriageDate = json['marriageDate'];

    serviceLanguage = json['serviceLanguage'];

    family = json['family'];
    familyid = json['familyid'];

    bloodGroup = json['bloodGroup'];
    dob = json['dob'];

    imgUrl = json['imgUrl'];
    qualification = json['qualification'];
    maritalStatus = json['maritalStatus'];
    relationToFamily = json['relationToFamily'];
    attendingTime = json['attendingTime'];
    previousChurch = json['previousChurch'];

    conDate = json['conDate'];
    companyname = json['companyname'];
    city = json['city'];
    alphone = json['alphone'];

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
    data['status'] = this.status;
    data['baptizemCertificate'] = this.baptizemCertificate;
    data['gender'] = this.gender;
    data['houseType'] = this.houseType;
    data['permanentAddress'] = this.permanentAddress;
    data['resistentialAddress'] = this.resistentialAddress;
    data['prefix'] = this.prefix;
    data['middleName'] = this.middleName;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['alterNativeemail'] = this.alterNativeemail;
    data['country'] = this.country;
    data['state'] = this.state;
    data['position'] = this.position;
    data['pincode'] = this.pincode;
    data['baptizeDate'] = this.baptizeDate;
    data['marriageDate'] = this.marriageDate;
    data['serviceLanguage'] = this.serviceLanguage;
    data['family'] = this.family;
    data['familyid'] = this.familyid;
    data['bloodGroup'] = this.bloodGroup;
    data['dob'] = this.dob;
    data['imgUrl'] = this.imgUrl;
    data['previousChurch'] = this.previousChurch;

    data['alphone'] = this.alphone;
    data['city'] = this.city;
    data['companyname'] = this.companyname;
    data['conDate'] = this.conDate;

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

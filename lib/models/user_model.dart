class UserModel {
  late String id;
  late int timestamp;
  late String prefix;
  late String firstName;
  late String middleName;
  late String lastName;
  late String phone;
  late String email;
  late String alterNativeemail;
  late String fcmToken;
  late String profession;
  late String aadharNo;
  late String baptizeDate;
  late String anniversaryDate;
  late String maritialStatus;
  late String gender;
  late String bloodGroup;
  late String dob;
  late String locality;/// City
  late String state;
  late String contry;
  late String qualification;
  late String about;
  late String resaddress;
  late String preaddress;
  late String imgUrl;
  late String nationality;
  late String houseType;
  late String pincode;
  late String companyname;
  late String condate;
  late String alphone;
  late bool status;
  late bool isPrivacyEnabled;

  UserModel(
      {required this.id,
        required this.timestamp,
        required this.houseType,
        required this.nationality,
        required this.firstName,
        required this.prefix,
        required this.middleName,
        required this.lastName,
        required this.aadharNo,
        required this.phone,
        required this.email,
        required this.alterNativeemail,
        required this.fcmToken,
        //this.password,
        required this.profession,
        required this.baptizeDate,
        required this.qualification,
        required this.anniversaryDate,
        required this.maritialStatus,
        required this.gender,
        required this.status,
        required this.bloodGroup,
        required this.isPrivacyEnabled,
        required this.dob,
        required this.locality,
        required this.contry,
        required this.state,
        required this.about,
        required this.resaddress,
        required this.preaddress,
        required this.pincode,
        required this.imgUrl,
        required this.condate,
        required this.companyname,
        required this.alphone,


      });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    pincode = json['pincode'];
    houseType = json['houseType'];
    nationality = json['nationality'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    middleName = json['middleName'];
    prefix = json['prefix'];
    fcmToken = json['fcmToken'];
    status = json['status'];
    phone = json['phone'];
    aadharNo = json['aadharNo'];
    email = json['email'];
    alterNativeemail = json['alterNativeemail'];
    qualification = json['qualification'];
    maritialStatus = json['maritialStatus'];
    profession = json['profession'];
    baptizeDate = json['baptizeDate'];
    anniversaryDate = json['anniversaryDate'];
    bloodGroup = json['bloodGroup'];
    gender = json['gender'];
    dob = json['dob'];
    locality = json['locality'];
    state = json['state'];
    contry = json['contry'];
    about = json['about'];
    resaddress = json['resaddress'];
    preaddress = json['preaddress'];
    imgUrl = json['imgUrl'];
    isPrivacyEnabled = json['isPrivacyEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['firstName'] = this.firstName;
    data['nationality'] = this.nationality;
    data['houseType'] = this.houseType;
    data['fcmToken'] = this.fcmToken;
    data['lastName'] = this.lastName;
    data['middleName'] = this.middleName;
    data['prefix'] = this.prefix;
    data['aadharNo'] = this.aadharNo;
    data['status'] = this.status;
    data['maritialStatus'] = this.maritialStatus;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['email'] = this.email;
    data['alterNativeemail'] = this.alterNativeemail;
    //data['password'] = this.password;
    data['profession'] = this.profession;
    data['baptizeDate'] = this.baptizeDate;
    data['anniversaryDate'] = this.anniversaryDate;
    data['bloodGroup'] = this.bloodGroup;
    data['dob'] = this.dob;
    data['locality'] = this.locality;
    data['contry'] = this.contry;
    data['state'] = this.state;
    data['qualification'] = this.qualification;
    data['pincode'] = this.pincode;
    data['about'] = this.about;
    data['resaddress'] = this.resaddress;
    data['preaddress'] = this.preaddress;
    data['imgUrl'] = this.imgUrl;
    data['isPrivacyEnabled'] = this.isPrivacyEnabled;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return "${firstName!} ${lastName!}";
      case 2:
        return dob!;
      case 3:
        return profession!;
      case 4:
        return phone!.toString();
      case 5:
        return pincode!;
    }
    return '';
  }

  String getIndex1(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return "${firstName!} ${lastName!}";
      case 2:
        return phone!;
      case 3:
        return bloodGroup!.toString();
      case 4:
        return resaddress!;
    }
    return '';
  }

}

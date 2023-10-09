class UserModel {
  late String id;
  late int timestamp;
  late String firstName;
  late String lastName;
  late String phone;
  late String email;
  late String fcmToken;
  late String profession;
  late String aadharNo;
  late String baptizeDate;
  late String anniversaryDate;
  late String maritialStatus;
  late String gender;
  late String bloodGroup;
  late String dob;
  late String locality;
  late String about;
  late String address;
  late String imgUrl;
  late String pincode;
  late bool isPrivacyEnabled;

  UserModel(
      {required this.id,
        required this.timestamp,
        required this.firstName,
        required this.lastName,
        required this.aadharNo,
        required this.phone,
        required this.email,
        required this.fcmToken,
        //this.password,
        required this.profession,
        required this.baptizeDate,
        required this.anniversaryDate,
        required this.maritialStatus,
        required this.gender,
        required this.bloodGroup,
        required this.isPrivacyEnabled,
        required this.dob,
        required this.locality,
        required this.about,
        required this.address,
        required this.pincode,
        required this.imgUrl});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    pincode = json['pincode'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fcmToken = json['fcmToken'];
    phone = json['phone'];
    aadharNo = json['aadharNo'];
    email = json['email'];
    maritialStatus = json['maritialStatus'];
    profession = json['profession'];
    baptizeDate = json['baptizeDate'];
    anniversaryDate = json['anniversaryDate'];
    bloodGroup = json['bloodGroup'];
    gender = json['gender'];
    dob = json['dob'];
    locality = json['locality'];
    about = json['about'];
    address = json['address'];
    imgUrl = json['imgUrl'];
    isPrivacyEnabled = json['isPrivacyEnabled'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['firstName'] = this.firstName;
    data['fcmToken'] = this.fcmToken;
    data['lastName'] = this.lastName;
    data['aadharNo'] = this.aadharNo;
    data['maritialStatus'] = this.maritialStatus;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['email'] = this.email;
    //data['password'] = this.password;
    data['profession'] = this.profession;
    data['baptizeDate'] = this.baptizeDate;
    data['anniversaryDate'] = this.anniversaryDate;
    data['bloodGroup'] = this.bloodGroup;
    data['dob'] = this.dob;
    data['locality'] = this.locality;
    data['pincode'] = this.pincode;
    data['about'] = this.about;
    data['address'] = this.address;
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
        return address!;
    }
    return '';
  }

}

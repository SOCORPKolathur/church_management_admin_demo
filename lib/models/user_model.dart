class UserModel {
  String? id;
  int? timestamp;
  String? firstName;
  String? lastName;
  String? phone;
  String? email;
  String? fcmToken;
  //String? password;
  String? profession;
  String? baptizeDate;
  String? anniversaryDate;
  String? maritialStatus;
  String? bloodGroup;
  String? dob;
  String? locality;
  String? about;
  String? address;
  String? imgUrl;

  UserModel(
      {this.id,
        this.timestamp,
        this.firstName,
        this.lastName,
        this.phone,
        this.email,
        this.fcmToken,
        //this.password,
        this.profession,
        this.baptizeDate,
        this.anniversaryDate,
        this.maritialStatus,
        this.bloodGroup,
        this.dob,
        this.locality,
        this.about,
        this.address,
        this.imgUrl});

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    fcmToken = json['fcmToken'];
    phone = json['phone'];
    email = json['email'];
    maritialStatus = json['maritialStatus'];
    //password = json['password'];
    profession = json['profession'];
    baptizeDate = json['baptizeDate'];
    anniversaryDate = json['anniversaryDate'];
    bloodGroup = json['bloodGroup'];
    dob = json['dob'];
    locality = json['locality'];
    about = json['about'];
    address = json['address'];
    imgUrl = json['imgUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['firstName'] = this.firstName;
    data['fcmToken'] = this.fcmToken;
    data['lastName'] = this.lastName;
    data['maritialStatus'] = this.maritialStatus;
    data['phone'] = this.phone;
    data['email'] = this.email;
    //data['password'] = this.password;
    data['profession'] = this.profession;
    data['baptizeDate'] = this.baptizeDate;
    data['anniversaryDate'] = this.anniversaryDate;
    data['bloodGroup'] = this.bloodGroup;
    data['dob'] = this.dob;
    data['locality'] = this.locality;
    data['about'] = this.about;
    data['address'] = this.address;
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
        return profession!;
      case 3:
        return phone!.toString();
      case 4:
        return locality!;
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

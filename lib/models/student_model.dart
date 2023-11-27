class StudentModel {
  String? id;
  String? studentId;
  num? timestamp;
  String? firstName;
  String? lastName;
  String? phone;
  String? gender;
  String? aadharNo;
  String? clasS;
  String? degree;
  String? instituteName;
  String? age;
  String? guardian;
  String? guardianPhone;
  String? email;
  String? position;
  String? baptizeDate;
  //String? marriageDate;
  //String? socialStatus;
  //String? job;
  String? country;
  String? family;
  String? familyid;
  //String? department;
  String? bloodGroup;
  String? dob;
  String? nationality;
  String? imgUrl;
  String? permanentAddress;
  String? resistentialAddress;

  StudentModel(
      {this.id,
        this.firstName,
        this.lastName,
        this.studentId,
        this.timestamp,
        this.phone,
        this.email,
        this.aadharNo,
        this.country,
        this.clasS,
        this.degree,
        this.instituteName,
        this.age,
        this.guardian,
        this.guardianPhone,
        this.gender,
        this.position,
        this.baptizeDate,
        //this.marriageDate,
        //this.socialStatus,
        //this.job,
        this.family,
        this.familyid,
        //this.department,
        this.bloodGroup,
        this.dob,
        this.nationality,
        this.imgUrl,
        this.resistentialAddress,
        this.permanentAddress
      });

  StudentModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    clasS = json['clasS'];
    degree = json['degree'];
    instituteName = json['instituteName'];
    studentId = json['studentId'];
    age = json['age'];
    aadharNo = json['aadharNo'];
    guardian = json['guardian'];
    guardianPhone = json['guardianPhone'];
    firstName = json['firstName'];
    gender = json['gender'];
    lastName = json['lastName'];
    country = json['country'];
    phone = json['phone'];
    email = json['email'];
    position = json['position'];
    baptizeDate = json['baptizeDate'];
    //marriageDate = json['marriageDate'];
    //socialStatus = json['socialStatus'];
    //job = json['job'];
    family = json['family'];
    familyid = json['familyid'];
    //department = json['department'];
    bloodGroup = json['bloodGroup'];
    dob = json['dob'];
    nationality = json['nationality'];
    imgUrl = json['imgUrl'];
    resistentialAddress  = json['resistentialAddress'];
    permanentAddress  = json['permanentAddress'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['clasS'] = this.clasS;
    data['degree'] = this.degree;
    data['instituteName'] = this.instituteName;
    data['studentId'] = this.studentId;
    data['age'] = this.age;
    data['guardian'] = this.guardian;
    data['aadharNo'] = this.aadharNo;
    data['guardianPhone'] = this.guardianPhone;
    data['firstName'] = this.firstName;
    data['gender'] = this.gender;
    data['lastName'] = this.lastName;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['position'] = this.position;
    data['country'] = this.country;
    data['baptizeDate'] = this.baptizeDate;
    //data['marriageDate'] = this.marriageDate;
    //data['socialStatus'] = this.socialStatus;
    //data['job'] = this.job;
    data['family'] = this.family;
    data['familyid'] = this.familyid;
    //data['department'] = this.department;
    data['bloodGroup'] = this.bloodGroup;
    data['dob'] = this.dob;
    data['nationality'] = this.nationality;
    data['imgUrl'] = this.imgUrl;
    data['resistentialAddress'] = this.resistentialAddress;
    data['permanentAddress'] = this.permanentAddress;
    return data;
  }

  String getIndex(int index,int row) {
    switch (index) {
      case 0:
        return (row + 1).toString();
      case 1:
        return studentId!;
      case 2:
        return "${firstName!} ${lastName!}";
      case 3:
        return guardian!.toString();
      case 4:
        return guardianPhone!;
      case 5:
        return age!;
      case 6:
        return clasS!;
      case 7:
        return bloodGroup!;
      case 8:
        return dob!;
    }
    return '';
  }

}

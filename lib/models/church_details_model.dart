class ChurchDetailsModel {
  String? id;
  String? name;
  String? phone;
  String? buildingNo;
  String? streetName;
  String? area;
  String? city;
  String? state;
  String? pincode;
  String? website;
  String? memberIdPrefix;
  String? familyIdPrefix;
  List<RoleUserModel>? roles;
  List<AboutChurchModel>? aboutChurch;

  ChurchDetailsModel(
      {this.id,
        this.name,
        this.phone,
        this.buildingNo,
        this.streetName,
        this.area,
        this.city,
        this.state,
        this.pincode,
        this.website,
        this.roles,
        this.aboutChurch,
        this.memberIdPrefix,
        this.familyIdPrefix,
      });

  ChurchDetailsModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    buildingNo = json['buildingNo'];
    streetName = json['streetName'];
    memberIdPrefix = json['memberIdPrefix'];
    familyIdPrefix = json['familyIdPrefix'];
    area = json['area'];
    city = json['city'];
    state = json['state'];
    pincode = json['pincode'];
    website = json['website'];
    if (json['roles'] != null) {
      roles = <RoleUserModel>[];
      json['roles'].forEach((v) {
        roles!.add(RoleUserModel.fromJson(v));
      });
    }
    if (json['aboutChurch'] != null) {
      aboutChurch = <AboutChurchModel>[];
      json['aboutChurch'].forEach((v) {
        aboutChurch!.add(AboutChurchModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['buildingNo'] = this.buildingNo;
    data['streetName'] = this.streetName;
    data['familyIdPrefix'] = this.familyIdPrefix;
    data['memberIdPrefix'] = this.memberIdPrefix;
    data['area'] = this.area;
    data['city'] = this.city;
    data['state'] = this.state;
    data['pincode'] = this.pincode;
    data['website'] = this.website;
    if (this.roles != null) {
      data['roles'] = this.roles!.map((v) => v.toJson()).toList();
    }
    if (this.aboutChurch != null) {
      data['aboutChurch'] = this.aboutChurch!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RoleUserModel {
  String? roleName;
  String? rolePassword;

  RoleUserModel({this.roleName, this.rolePassword});

  RoleUserModel.fromJson(Map<String, dynamic> json) {
    roleName = json['roleName'];
    rolePassword = json['rolePassword'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['roleName'] = this.roleName;
    data['rolePassword'] = this.rolePassword;
    return data;
  }
}

class AboutChurchModel {
  String? about;
  String? img;

  AboutChurchModel({this.about, this.img});

  AboutChurchModel.fromJson(Map<String, dynamic> json) {
    about = json['about'];
    img = json['img'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['about'] = this.about;
    data['img'] = this.img;
    return data;
  }
}


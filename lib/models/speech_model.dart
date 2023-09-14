class SpeechModel {
  String? id;
  int? timestamp;
  String? imgUrl;
  String? firstName;
  String? lastName;
  String? position;
  String? speech;
  String? facebook;
  String? youtube;
  String? twitter;
  String? google;
  String? linkedin;
  String? pinterest;
  String? instagram;
  String? whatsapp;

  SpeechModel(
      {this.id,
        this.timestamp,
        this.imgUrl,
        this.firstName,
        this.lastName,
        this.position,
        this.speech,
        this.facebook,
        this.youtube,
        this.twitter,
        this.google,
        this.linkedin,
        this.pinterest,
        this.instagram,
        this.whatsapp});

  SpeechModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    imgUrl = json['imgUrl'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    position = json['position'];
    speech = json['speech'];
    facebook = json['facebook'];
    youtube = json['youtube'];
    twitter = json['twitter'];
    google = json['google'];
    linkedin = json['linkedin'];
    pinterest = json['pinterest'];
    instagram = json['instagram'];
    whatsapp = json['whatsapp'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['imgUrl'] = this.imgUrl;
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['position'] = this.position;
    data['speech'] = this.speech;
    data['facebook'] = this.facebook;
    data['youtube'] = this.youtube;
    data['twitter'] = this.twitter;
    data['google'] = this.google;
    data['linkedin'] = this.linkedin;
    data['pinterest'] = this.pinterest;
    data['instagram'] = this.instagram;
    data['whatsapp'] = this.whatsapp;
    return data;
  }
}

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
  String? Date;
  String? Time;

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
        this.Date,
        this.Time,
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
    Date = json['"Date'];
    Time = json['Time'];
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
    data['Date'] = this.Date;
    data['Time'] = this.Time;
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
        return speech!;
    }
    return '';
  }

}

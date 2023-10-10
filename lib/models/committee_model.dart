

class CommitteeModel {
  String? id;
  String? committeeName;

  CommitteeModel({this.id, this.committeeName});

  CommitteeModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    committeeName = json['committeeName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['committeeName'] = this.committeeName;
    return data;
  }
}

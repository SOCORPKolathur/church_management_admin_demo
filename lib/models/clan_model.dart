class ClansModel {
  String? id;
  String? clanName;

  ClansModel({this.id, this.clanName});

  ClansModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    clanName = json['clanName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['clanName'] = this.clanName;
    return data;
  }
}

class AssetManagementModel {
  String? id;
  int? timestamp;
  String? date;
  String? amcDate;
  String? insuranceDate;
  String? assets;
  String? verifier;
  String? approxValue;
  String? description;
  String? imgUrl;
  String? document;

  AssetManagementModel(
      {this.id,
        this.timestamp,
        this.amcDate,
        this.insuranceDate,
        this.date,
        this.imgUrl,
        this.document,
        this.assets,
        this.verifier,
        this.approxValue,
        this.description});

  AssetManagementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    date = json['date'];
    amcDate = json['amcDate'];
    insuranceDate = json['insuranceDate'];
    imgUrl = json['imgUrl'];
    document = json['document'];
    assets = json['assets'];
    verifier = json['verifier'];
    approxValue = json['approxValue'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['imgUrl'] = this.imgUrl;
    data['document'] = this.document;
    data['date'] = this.date;
    data['amcDate'] = this.amcDate;
    data['insuranceDate'] = this.insuranceDate;
    data['assets'] = this.assets;
    data['verifier'] = this.verifier;
    data['approxValue'] = this.approxValue;
    data['description'] = this.description;
    return data;
  }
}

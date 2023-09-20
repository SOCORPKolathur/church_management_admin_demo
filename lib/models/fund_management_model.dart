class FundManagementModel {
  String? id;
  num? timestamp;
  String? date;
  double? amount;
  String? recordType;
  String? source;
  String? verifier;
  String? imgUrl;
  String? document;

  FundManagementModel(
      {this.id,
        this.timestamp,
        this.date,
        this.amount,
        this.recordType,
        this.imgUrl,
        this.document,
        this.source,
        this.verifier});

  FundManagementModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    imgUrl = json['imgUrl'];
    document = json['document'];
    timestamp = json['timestamp'];
    date = json['date'];
    amount = json['amount'];
    recordType = json['recordType'];
    source = json['source'];
    verifier = json['verifier'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['imgUrl'] = this.imgUrl;
    data['document'] = this.document;
    data['timestamp'] = this.timestamp;
    data['date'] = this.date;
    data['amount'] = this.amount;
    data['recordType'] = this.recordType;
    data['source'] = this.source;
    data['verifier'] = this.verifier;
    return data;
  }
}

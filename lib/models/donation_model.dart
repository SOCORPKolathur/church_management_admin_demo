class DonationModel {
  String? id;
  num? timestamp;
  String? date;
  String? amount;
  String? source;
  String? via;
  String? description;
  String? verifier;
  String? bank;

  DonationModel(
      {this.id,
        this.timestamp,
        this.date,
        this.amount,
        this.source,
        this.via,
        this.description,
        this.verifier,
        this.bank});

  DonationModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    timestamp = json['timestamp'];
    date = json['date'];
    amount = json['amount'];
    source = json['source'];
    via = json['via'];
    description = json['description'];
    verifier = json['verifier'];
    bank = json['bank'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['timestamp'] = this.timestamp;
    data['date'] = this.date;
    data['amount'] = this.amount;
    data['source'] = this.source;
    data['via'] = this.via;
    data['description'] = this.description;
    data['verifier'] = this.verifier;
    data['bank'] = this.bank;
    return data;
  }
}

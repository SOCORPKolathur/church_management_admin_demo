class FundModel {
  double? totalCollect;
  double? totalSpend;
  double? currentBalance;

  FundModel({this.totalCollect, this.totalSpend, this.currentBalance});

  FundModel.fromJson(Map<String, dynamic> json) {
    totalCollect = json['totalCollect'];
    totalSpend = json['totalSpend'];
    currentBalance = json['currentBalance'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCollect'] = this.totalCollect;
    data['totalSpend'] = this.totalSpend;
    data['currentBalance'] = this.currentBalance;
    return data;
  }
}

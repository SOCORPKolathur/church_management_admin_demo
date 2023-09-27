class DashboardModel {
  String? totalCollect;
  String? totalSpend;
  String? currentBalance;
  String? totalUsers;
  String? totalCommite;
  String? totalPastors;
  String? totalClans;
  String? totalStaffs;
  String? totalStudents;
  String? totalMembers;
  String? totalFamilies;
  String? totalChorus;
  String? birthdayCount;
  String? annivarsaryCount;

  DashboardModel(
      {this.totalCollect,
        this.totalSpend,
        this.currentBalance,
        this.totalUsers,
        this.totalCommite,
        this.totalFamilies,
        this.totalPastors,
        this.totalClans,
        this.totalStaffs,
        this.birthdayCount,
        this.annivarsaryCount,
        this.totalStudents,
        this.totalMembers,
        this.totalChorus});

  DashboardModel.fromJson(Map<String, dynamic> json) {
    totalCollect = json['totalCollect'];
    totalSpend = json['totalSpend'];
    birthdayCount = json['birthdayCount'];
    annivarsaryCount = json['annivarsaryCount'];
    currentBalance = json['currentBalance'];
    totalUsers = json['totalUsers'];
    totalCommite = json['totalCommite'];
    totalFamilies = json['totalFamilies'];
    totalPastors = json['totalPastors'];
    totalClans = json['totalClans'];
    totalStaffs = json['totalStaffs'];
    totalStudents = json['totalStudents'];
    totalMembers = json['totalMembers'];
    totalChorus = json['totalChorus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['totalCollect'] = this.totalCollect;
    data['birthdayCount'] = this.birthdayCount;
    data['annivarsaryCount'] = this.annivarsaryCount;
    data['totalSpend'] = this.totalSpend;
    data['currentBalance'] = this.currentBalance;
    data['totalUsers'] = this.totalUsers;
    data['totalCommite'] = this.totalCommite;
    data['totalPastors'] = this.totalPastors;
    data['totalClans'] = this.totalClans;
    data['totalStaffs'] = this.totalStaffs;
    data['totalStudents'] = this.totalStudents;
    data['totalMembers'] = this.totalMembers;
    data['totalChorus'] = this.totalChorus;
    return data;
  }
}

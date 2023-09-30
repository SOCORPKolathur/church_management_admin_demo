class ManageRoleModel {
  String? role;
  String? id;
  List<dynamic>? permissions;
  List<dynamic>? dashboardItems;

  ManageRoleModel({this.role,this.id, this.permissions, this.dashboardItems});

  ManageRoleModel.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    id = json['id'];
    permissions = json['permissions'];
    dashboardItems = json['dashboardItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['id'] = this.id;
    data['permissions'] = this.permissions;
    data['dashboardItems'] = this.dashboardItems;
    return data;
  }
}

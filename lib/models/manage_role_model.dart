class ManageRoleModel {
  String? role;
  String? id;
  List<dynamic>? permissions;

  ManageRoleModel({this.role,this.id, this.permissions});

  ManageRoleModel.fromJson(Map<String, dynamic> json) {
    role = json['role'];
    id = json['id'];
    permissions = json['permissions'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['role'] = this.role;
    data['id'] = this.id;
    data['permissions'] = this.permissions;
    return data;
  }
}

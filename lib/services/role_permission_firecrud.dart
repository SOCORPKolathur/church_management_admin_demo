import 'package:church_management_admin/models/manage_role_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference RoleCollection = firestore.collection('RolePermissions');

class RolePermissionFireCrud {

  static Stream<List<ManageRoleModel>> fetchPermissions() =>
      RoleCollection
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => ManageRoleModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> updatedRole(ManageRoleModel role) async {
    Response response = Response();
    DocumentReference documentReferencer = RoleCollection.doc(role.id);
    var json = role.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }



}

import 'package:church_management_admin/models/department_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/family_model.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference DepartmentCollection = firestore.collection('Departments');

class DepartmentFireCrud {
  static Stream<List<DepartmentModel>> fetchDepartments() =>
      DepartmentCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => DepartmentModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<DepartmentModel>> fetchDepartmentswithSerach(text) =>
      DepartmentCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element['name'].toString().toLowerCase().startsWith(text) || element['leaderName'].toString().toLowerCase().startsWith(text) || element['location'].toString().toLowerCase().startsWith(text))
          .map((doc) => DepartmentModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addDepartment({
    required String name,
    required String leaderName,
    required String address,
    required String city,
    required String contactNumber,
    required String country,
    required String location,
    required String zone,
    required String description,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = DepartmentCollection.doc();
    DepartmentModel department = DepartmentModel(
      id: "",
      timestamp: DateTime.now().millisecondsSinceEpoch,
      country: country,
      contactNumber: contactNumber,
      location: location,
      description: description,
      city: city,
      address: address,
      leaderName: leaderName,
      name: name,
      zone: zone,
    );
    department.id = documentReferencer.id;
    var json = department.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> updateRecord(DepartmentModel department) async {
    Response res = Response();
    DocumentReference documentReferencer = DepartmentCollection.doc(department.id);
    var result = await documentReferencer.update(department.toJson()).whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Updated from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }

  static Future<Response> deleteRecord({required String id}) async {
    Response res = Response();
    DocumentReference documentReferencer = DepartmentCollection.doc(id);
    var result = await documentReferencer.delete().whenComplete((){
      res.code = 200;
      res.message = "Sucessfully Deleted from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }

}

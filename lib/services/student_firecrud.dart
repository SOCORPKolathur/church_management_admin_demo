import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';
import '../models/student_model.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference StudentCollection = firestore.collection('Students');
final FirebaseStorage fs = FirebaseStorage.instance;

class StudentFireCrud {
  static Stream<List<StudentModel>> fetchStudents() =>
      StudentCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => StudentModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Stream<List<StudentModel>> fetchStudentswithFilter(String clasS) =>
      StudentCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element.get('clasS') == clasS)
          .map((doc) => StudentModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addStudent(
      {required File image,
      required String baptizeDate,
      required String bloodGroup,
      //required String department,
      required String dob,
      required String studentId,
      required String age,
      required String clasS,
      required String guardian,
      required String guardianPhone,
      required String country,
      required String gender,
      required String email,
      required String family,
      required String firstName,
      //required String job,
      required String lastName,
      //required String marriageDate,
      required String nationality,
      required String phone,
      required String position,
      //required String socialStatus
      }) async {
    String downloadUrl = await uploadImageToStorage(image);
    Response response = Response();
    DocumentReference documentReferencer = StudentCollection.doc();
    StudentModel student = StudentModel(
        id: "",
        studentId: studentId,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        //socialStatus: socialStatus,
        guardianPhone: guardianPhone,
        guardian: guardian,
        age: age,
        clasS: clasS,
        position: position,
        phone: phone,
        nationality: nationality,
        //marriageDate: marriageDate,
        lastName: lastName,
        country: country,
        gender: gender,
        //job: job,
        firstName: firstName,
        family: family,
        email: email,
        dob: dob,
        //department: department,
        bloodGroup: bloodGroup,
        baptizeDate: baptizeDate,
        imgUrl: downloadUrl);
    student.id = documentReferencer.id;
    var json = student.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<String> uploadImageToStorage(file) async {
    var snapshot = await fs
        .ref()
        .child('dailyupdates')
        .child("${file.name}")
        .putBlob(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<Response> updateRecord(StudentModel student,File? image,String imgUrl) async {
    Response res = Response();
    if(image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      student.imgUrl = downloadUrl;
    }else{
      student.imgUrl = imgUrl;
    }
    DocumentReference documentReferencer = StudentCollection.doc(student.id);
    var result = await documentReferencer.update(student.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = StudentCollection.doc(id);
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

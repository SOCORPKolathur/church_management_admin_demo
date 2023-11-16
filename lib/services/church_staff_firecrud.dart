import 'dart:html';
import 'package:church_management_admin/models/church_staff_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference ChurchStaffCollection = firestore.collection('ChurchStaff');
final FirebaseStorage fs = FirebaseStorage.instance;

class ChurchStaffFireCrud {
  static Stream<List<ChurchStaffModel>> fetchChurchStaffs() => ChurchStaffCollection
      .orderBy("timestamp", descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => ChurchStaffModel.fromJson(doc.data() as Map<String,dynamic>))
      .toList());

  static Stream<List<ChurchStaffModel>> fetchChurchStaffsWithSearch(String text) => ChurchStaffCollection
      .orderBy("timestamp", descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .where((element) => (element['position'].toString().toLowerCase().startsWith(text)||
      element['firstName'].toString().toLowerCase().startsWith(text)||
      element['phone'].toString().toLowerCase().startsWith(text)
  ))
      .map((doc) => ChurchStaffModel.fromJson(doc.data() as Map<String,dynamic>))
      .toList());

  static Future<Response> addChurchStaff(
      { required File? image,
        required File? document,
        required String address,
        required String dateOfJoining,
        required String baptizeDate,
        required String bloodGroup,
        required String aadharNo,
        required String department,
        required String dob,
        required String country,
        required String gender,
        required String email,
        required String family,
        required String familyId,
        required String maritalStatus,
        required String firstName,
        required String job,
        required String pincode,
        required String lastName,
        required String marriageDate,
        required String nationality,
        required String phone,
        required String position,
        required String landMark,
        required String socialStatus})
  async {
    String downloadUrl = '';
    String downloadUrl1 = '';
    if(image != null){
      downloadUrl = await uploadImageToStorage(image);
    }
    if(document != null){
      downloadUrl1 = await uploadImageToStorage(document);
    }
    Response response = Response();
    DocumentReference documentReferencer = ChurchStaffCollection.doc();
    ChurchStaffModel church_staff = ChurchStaffModel(
        id: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
        socialStatus: socialStatus,
        address: address,
        dateOfJoining: dateOfJoining,
        landMark:landMark,
        document: downloadUrl1,
        position: position,
        phone: phone,
        aadharNo: aadharNo,
        nationality: nationality,
        marriageDate: marriageDate,
        lastName: lastName,
        country: country,
        gender: gender,
        pincode: pincode,
        familyId: familyId,
        maritalStatus: maritalStatus,
        job: job,
        firstName: firstName,
        family: family,
        email: email,
        dob: dob,
        department: department,
        bloodGroup: bloodGroup,
        baptizeDate: baptizeDate,
        imgUrl: downloadUrl);
    church_staff.id = documentReferencer.id;
    var json = church_staff.toJson();
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

  static Future<Response> updateRecord(ChurchStaffModel churchStaff,File? image,String imgUrl) async {
    Response res = Response();
    if(image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      churchStaff.imgUrl = downloadUrl;
    }else{
      churchStaff.imgUrl = imgUrl;
    }
    DocumentReference documentReferencer = ChurchStaffCollection.doc(churchStaff.id);
    var result = await documentReferencer.update(churchStaff.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = ChurchStaffCollection.doc(id);
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

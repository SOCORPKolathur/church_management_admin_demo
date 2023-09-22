import 'dart:html';
import 'dart:math';
import 'package:church_management_admin/models/members_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference MemberCollection = firestore.collection('Members');
final FirebaseStorage fs = FirebaseStorage.instance;

class MembersFireCrud {

  static String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  static Stream<List<MembersModel>> fetchMembers() => MemberCollection
          .orderBy("timestamp", descending: false)
          .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => MembersModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addMember(
      {required File image,
        required File? document,
      required String address,
      required String gender,
      required String membersId,
      required String baptizeDate,
      required String bloodGroup,
      required String department,
      required String dob,
      required String country,
      required String email,
      required String family,
      required String firstName,
      required String job,
      required String lastName,
      required String marriageDate,
      required String nationality,
      required String phone,
      required String position,
      required String socialStatus}) async {
    String downloadUrl = await uploadImageToStorage(image);
    String downloadUrl1 = await uploadImageToStorage(document);
    Response response = Response();
    DocumentReference documentReferencer = MemberCollection.doc();
    MembersModel member = MembersModel(
        id: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
        socialStatus: socialStatus,
        position: position,
        memberId: membersId,
        phone: phone,
        gender: gender,
        address: address,
        baptizemCertificate: downloadUrl1,
        nationality: nationality,
        marriageDate: marriageDate,
        lastName: lastName,
        country: country,
        job: job,
        firstName: firstName,
        family: family,
        email: email,
        dob: dob,
        department: department,
        bloodGroup: bloodGroup,
        baptizeDate: baptizeDate,
        imgUrl: downloadUrl);
    member.id = documentReferencer.id;
    var json = member.toJson();
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

  static Future<String> uploadDocumentToStorage(file) async {
    var snapshot = await fs
        .ref()
        .child('dailyupdates')
        .child("${file.name}")
        .putBlob(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<Response> updateRecord(MembersModel member,File? image,String imgUrl) async {
    Response res = Response();
    if(image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      member.imgUrl = downloadUrl;
    }else{
      member.imgUrl = imgUrl;
    }
    DocumentReference documentReferencer = MemberCollection.doc(member.id);
    var result = await documentReferencer.update(member.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = MemberCollection.doc(id);
    var result = await documentReferencer.delete().whenComplete((){
      res.code = 200;
      res.message = "Sucessfully Deleted from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }

  static Future<Response> bulkUploadMember(Excel excel) async {
    Response res = Response();
    final row = excel.tables[excel.tables.keys.first]!.rows
        .map((e) => e.map((e) => e!.value).toList()).toList();
    for (int i = 1; i < row.length; i++) {
      String documentID = generateRandomString(20);
      MembersModel member = MembersModel(
        id: documentID,
        firstName: row[i][2].toString(),
        lastName: row[i][3].toString(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        address: row[i][17].toString(),
        imgUrl: "",
        phone: row[i][4].toString(),
        email: row[i][5].toString(),
        dob: row[i][15].toString(),
        bloodGroup: row[i][14].toString(),
        baptizeDate: row[i][8].toString(),
        country: "",
        position: row[i][7].toString(),
        socialStatus: row[i][10].toString(),
        nationality: row[i][16].toString(),
        marriageDate: row[i][9].toString(),
        job: row[i][11].toString(),
        family: row[i][12].toString(),
        department: row[i][13].toString(),
        baptizemCertificate: "",
        gender: row[i][6].toString(),
        memberId: row[i][1].toString(),
      );
      var json = member.toJson();
      await MemberCollection.doc(documentID).set(
          json).whenComplete(() {
        res.code = 200;
        res.message = "Sucessfully Updated from database";
      }).catchError((e) {
        res.code = 500;
        res.message = e;
      });
    }
    return res;
  }


}

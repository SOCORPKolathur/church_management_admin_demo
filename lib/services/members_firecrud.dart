import 'dart:html';
import 'dart:math';
import 'package:church_management_admin/models/members_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';
import 'package:intl/intl.dart';

import '../models/user_model.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference MemberCollection = firestore.collection('Members');
final CollectionReference UsersCollection = firestore.collection('Users');
final FirebaseStorage fs = FirebaseStorage.instance;

class MembersFireCrud {

  static String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  static Stream<List<MembersModel>> fetchMembers() => MemberCollection.orderBy("timestamp", descending: true)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => MembersModel.fromJson(doc.data() as Map<String,dynamic>))
      .toList());

  static Stream<List<MembersModel>> fetchMemberss(searchString) => MemberCollection.where("firstName", isEqualTo: searchString).limit(10)
          .snapshots()
      .map((snapshot) => snapshot.docs
          .map((doc) => MembersModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<MembersModel>> fetchMembers1(documentList) => MemberCollection
      .orderBy("timestamp", descending: true).startAfterDocument(documentList[documentList.length - 1]).limit(10)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => MembersModel.fromJson(doc.data() as Map<String,dynamic>))
      .toList());

  static Stream<List<MembersModel>> fetchMembers2() => MemberCollection
      .orderBy("timestamp", descending: true).limit(10)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => MembersModel.fromJson(doc.data() as Map<String,dynamic>))
      .toList());

  static Stream<List<MembersModel>> fetchMembersWithSearch(String text) => MemberCollection
      .orderBy("timestamp", descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .where((element) => (element['firstName'].toString().toLowerCase().startsWith(text)||
                  element['phone'].toString().toLowerCase().startsWith(text)
                ||element['position'].toString().toLowerCase().startsWith(text)))
      .map((doc) => MembersModel.fromJson(doc.data() as Map<String,dynamic>))
      .toList());

  static Future<Response> addMember(
      {required File? image,
        required File? document,
      required String residentialAddress,
      required String permanentAddress,
      required String houseType,
      required String gender,
      required String membersId,
      required String baptizeDate,
      required String bloodGroup,
      required String department,
      required String dob,
      required String country,
      required String aadharNo,
      required String email,
      required String family,
      required String familyid,
      required String firstName,
      required String pincode,
      required String job,
      required String lastName,
      required String marriageDate,
      required String nationality,
      required String phone,
      required String qualification,
      required String relationToFamily,
      required String attendingTime,
      required String maritalStatus,
      required String position,
      required String landMark,
      required String previousChurch,
      required String serviceLanguage,
      required String socialStatus}) async {
    String downloadUrl = '';
    if(image != null){
      downloadUrl = await uploadImageToStorage(image);
    }
    String downloadUrl1 = "";
    if(document != null) {
      downloadUrl1 = await uploadImageToStorage(document);
    }
    Response response = Response();
    Response response1 = Response();
    DocumentReference documentReferencer = MemberCollection.doc();
    DocumentReference documentReferencer1 = UsersCollection.doc();

    MembersModel member = MembersModel(
        id: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
        socialStatus: socialStatus,
        position: position,
        memberId: membersId,
        phone: phone,
        gender: gender,
        permanentAddress: permanentAddress,
        resistentialAddress: residentialAddress,
        houseType: houseType,
        baptizemCertificate: document != null ? downloadUrl1 : "",
        nationality: nationality,
        serviceLanguage:serviceLanguage,
        marriageDate: marriageDate,
        aadharNo: aadharNo,
        lastName: lastName,
        pincode: pincode,
        status: true,
        country: country,
        job: job,
        firstName: firstName,
        family: family,
        familyid: familyid,
        email: email,
        landMark: landMark,
        previousChurch: previousChurch,
        dob: dob,
        department: department,
        bloodGroup: bloodGroup,
        baptizeDate: baptizeDate,
        imgUrl: downloadUrl,
        attendingTime: attendingTime,
        maritalStatus: maritalStatus,
        qualification: qualification,
        relationToFamily: relationToFamily,
    );
    member.id = documentReferencer.id;
    var memberJson = member.toJson();

    UserModel user = UserModel(
        id: documentReferencer1.id,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        profession: position.toUpperCase(),
        phone: phone,
        locality: country,
        lastName: lastName,
        fcmToken: "",
        qualification: qualification,
        firstName: firstName,
        status: true,
        maritialStatus: maritalStatus,
        gender: gender,
        email: email,
        aadharNo: aadharNo,
        isPrivacyEnabled: false,
        dob: dob,
        nationality: nationality,
        houseType: houseType,
        about: permanentAddress,
        address: residentialAddress,
        bloodGroup: bloodGroup,
        baptizeDate: baptizeDate,
        pincode: pincode,
        anniversaryDate: marriageDate,
        imgUrl: downloadUrl);
    var userJson = user.toJson();
    var result = await documentReferencer.set(memberJson).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
      FirebaseFirestore.instance.collection('Members').doc(documentReferencer.id).collection('Membership').doc(DateFormat('MMM yyyy').format(DateTime.now()).toString()).set({
        "payment" : false,
        "timestamp" : DateTime.now().millisecondsSinceEpoch,
        "mode" : "",
        "payOn" : "",
        "date" : "",
      });
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    var result1 = await documentReferencer1.set(userJson).whenComplete(() {
      response1.code = 200;
      response1.message = "Sucessfully added to the database";
    }).catchError((e) {
      response1.code = 500;
      response1.message = e;
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
        memberId: row[i][1].toString(),
        firstName: row[i][2].toString(),
        lastName: row[i][3].toString(),
        phone: row[i][4].toString(),
        email: row[i][5].toString(),
        gender: row[i][6].toString(),
        position: row[i][7].toString(),
        baptizeDate: row[i][8].toString(),
        marriageDate: row[i][9].toString(),
        socialStatus: row[i][10].toString(),
        job: row[i][11].toString(),
        familyid: row[i][12].toString(),
        family: row[i][13].toString(),
        department: row[i][14].toString(),
        bloodGroup: row[i][15].toString(),
        dob: row[i][16].toString(),
        nationality: row[i][17].toString(),
        resistentialAddress: row[i][18].toString(),
        pincode: row[i][19].toString(),
        aadharNo: row[i][20].toString(),
        maritalStatus: row[i][21].toString(),
        attendingTime: row[i][22].toString(),
        qualification: row[i][23].toString(),
        relationToFamily: row[i][24].toString(),
        previousChurch: row[i][25].toString(),
        landMark: row[i][26].toString(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        imgUrl: "",
        country: "",
        baptizemCertificate: "",
        permanentAddress: "",
        houseType: "",
        status: true,
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



  static Future<Response> bulkUploadMemberss(Excel excel) async {
    var members = await FirebaseFirestore.instance.collection("Members").get();
    var churchDetails = await FirebaseFirestore.instance.collection('ChurchDetails').get();
    Response res = Response();
    final row = excel.tables[excel.tables.keys.first]!.rows.map((e) => e.map((e) => e!.value).toList()).toList();
    for (int i = 1; i < row.length; i++) {
      String memberIdPrefix = churchDetails.docs.first.get("memberIdPrefix");
      int lastId = members.docs.length + i;
      String memberId = lastId.toString().padLeft(6,'0');
      String documentID = generateRandomString(20);
      String documentID1 = generateRandomString(20);

      MembersModel member = MembersModel(
        id: documentID,
        memberId: memberIdPrefix+memberId,
        firstName: row[i][19].toString().toLowerCase() != 'null' ? row[i][19].toString() : "",
        lastName: row[i][21].toString().toLowerCase() != 'null' ? row[i][21].toString() : "",
        phone: row[i][13].toString(),
        email: row[i][32].toString(),
        gender: row[i][22].toString().toString().toLowerCase() == 'm' ? 'Male' : 'Female',
        position: row[i][29].toString(),
        baptizeDate: "Null",
        marriageDate: row[i][25].toString(),
        socialStatus: "Null",
        job: row[i][29].toString(),
        familyid: "Null",
        family: "Null",
        department: "Null",
        bloodGroup: "Null",
        dob: row[i][23].toString(),
        nationality: row[i][11].toString(),
        resistentialAddress: "${row[i][4]},${row[i][5]},${row[i][6]},${row[i][7]},${row[i][8]},${row[i][9]},${row[i][10]},${row[i][11]}",
        permanentAddress: "${row[i][4]},${row[i][5]},${row[i][6]},${row[i][7]},${row[i][8]},${row[i][9]},${row[i][10]},${row[i][11]}",
        pincode: row[i][9].toString(),
        aadharNo: row[i][34].toString(),
        maritalStatus: row[i][24].toString().toLowerCase() == "yes" ? 'Married' : 'Single',
        attendingTime: row[i][2].toString(),
        qualification: row[i][3].toString(),
        relationToFamily: row[i][26].toString(),
        previousChurch: row[i][35].toString(),
        landMark: row[i][12].toString(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        imgUrl: "",
        country: "Null",
        baptizemCertificate: "Null",
        houseType: "Null",
        status: true,
      );

      UserModel user = UserModel(
        id: documentID1,
        about: "${row[i][4]},${row[i][5]},${row[i][6]},${row[i][7]},${row[i][8]},${row[i][9]},${row[i][10]},${row[i][11]}",
        address: "${row[i][4]},${row[i][5]},${row[i][6]},${row[i][7]},${row[i][8]},${row[i][9]},${row[i][10]},${row[i][11]}",
        anniversaryDate: row[i][25].toString(),
        fcmToken: "",
        isPrivacyEnabled: false,
        locality: row[i][11].toString(),
        maritialStatus: row[i][24].toString().toLowerCase() == "yes" ? 'Married' : 'Single',
        profession: row[i][29].toString(),
        status: true,
        firstName: row[i][19].toString(),
        lastName: row[i][21].toString(),
        phone: row[i][13].toString(),
        email: row[i][32].toString(),
        gender: row[i][22].toString().toString().toLowerCase() == 'm' ? 'Male' : 'Female',
        baptizeDate: "Null",
        bloodGroup: "Null",
        dob: row[i][23].toString(),
        nationality: row[i][11].toString(),
        pincode: row[i][9].toString(),
        aadharNo: row[i][34].toString(),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        imgUrl: "",
        qualification: "",
        houseType: "Null",
      );

      var json = member.toJson();
      var userJson = user.toJson();
      await MemberCollection.doc(documentID).set(json).whenComplete(() {
        res.code = 200;
        res.message = "Sucessfully Updated from database";
        FirebaseFirestore.instance.collection("Users").doc(documentID1).set(userJson);
      }).catchError((e) {
        res.code = 500;
        res.message = e;
      });
    }
    return res;
  }


}

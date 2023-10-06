import 'dart:html';
import 'package:church_management_admin/models/clan_member_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/clan_model.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference ClansCollection = firestore.collection('Clans');
final CollectionReference ClansChatCollection = firestore.collection('ClansChat');
final CollectionReference ClanMemberCollection = firestore.collection('ClansMembers');
final FirebaseStorage fs = FirebaseStorage.instance;

class ClansFireCrud {
  static Stream<List<ClansModel>> fetchClans() => firestore.collection('Clans')
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => ClansModel.fromJson(doc.data()))
      .toList());

  static Stream<List<ClanMemberModel>> fetchClanMembers(String id) =>
      firestore.collection('Clans').doc(id).collection('ClansMembers').snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => ClanMemberModel.fromJson(doc.data()))
      .toList());

  static Future<Response> addClan({required String name}) async {
    Response response = Response();
      DocumentReference documentReferencer = ClansCollection.doc();
      ClansModel clan = ClansModel(
          id: "",
          clanName: name,
      );
      clan.id = documentReferencer.id;
      var json = clan.toJson();
      var result = await documentReferencer.set(json).whenComplete(() {
        response.code = 200;
        response.message = "Sucessfully added to the database";
        ClansChatCollection.doc(clan.id).set({
          "id" : clan.id,
          "name": clan.clanName
        });
      }).catchError((e) {
        response.code = 500;
        response.message = e;
      });
      return response;
  }


  static Future<Response> deleteRecord({required String docId}) async {
    Response res = Response();
    DocumentReference documentReferencer = ClansCollection.doc(docId);
    var result = await documentReferencer.delete().whenComplete((){
      res.code = 200;
      res.message = "Sucessfully Deleted from database";
      ClansChatCollection.doc(docId).delete();
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }

  // static Stream<List<ClansModel>> fetchClansWithSearch(String text) => ClansCollection
  //     .orderBy("timestamp", descending: false)
  //     .snapshots()
  //     .map((snapshot) => snapshot.docs
  //     .where((element) => (element['firstName'].toString().toLowerCase().startsWith(text)||
  //     element['phone'].toString().toLowerCase().startsWith(text)||
  //     element['position'].toString().toLowerCase().startsWith(text)))
  //     .map((doc) => ClansModel.fromJson(doc.data() as Map<String,dynamic>))
  //     .toList());
  //
  static Future<Response> addClanMember(
      {required String docId,
        required File image,
        required String baptizeDate,
        required String bloodGroup,
        required String department,
        required String dob,
        required String country,
        required String gender,
        required String email,
        required String family,
        required String firstName,
        required String job,
        required String lastName,
        required String marriageDate,
        required String nationality,
        required String phone,
        required String pincode,
        required String position,
        required String socialStatus}) async {
    String downloadUrl = await uploadImageToStorage(image);
    Response response = Response();
    DocumentReference documentReferencer = ClansCollection.doc(docId).collection('ClansMembers').doc();
    ClanMemberModel clan = ClanMemberModel(
        id: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
        socialStatus: socialStatus,
        position: position,
        phone: phone,
        gender: gender,
        nationality: nationality,
        marriageDate: marriageDate,
        lastName: lastName,
        country: country,
        job: job,
        pincode: pincode,
        firstName: firstName,
        family: family,
        email: email,
        dob: dob,
        department: department,
        bloodGroup: bloodGroup,
        baptizeDate: baptizeDate,
        imgUrl: downloadUrl);
    clan.id = documentReferencer.id;
    var json = clan.toJson();
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
  //
  static Future<Response> updateRecord(ClanMemberModel clan,String imgUrl, docId) async {
    Response res = Response();
    DocumentReference documentReferencer = ClansCollection.doc(docId).collection('ClansMembers').doc(clan.id);
    var result = await documentReferencer.update(clan.toJson()).whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Updated from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }
  //
  static Future<Response> deleteMemberRecord({required String docId, required String id}) async {
    Response res = Response();
    DocumentReference documentReferencer = ClansCollection.doc(docId).collection('ClansMembers').doc(id);
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

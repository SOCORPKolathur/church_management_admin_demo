import 'dart:html';
import 'package:church_management_admin/models/church_details_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference ChurchDetailsCollection = firestore.collection('ChurchDetails');

class ChurchDetailsFireCrud {
  static Stream<List<ChurchDetailsModel>> fetchChurchDetails() =>
      ChurchDetailsCollection
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => ChurchDetailsModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<ChurchDetailsModel>> fetchChurchDetails1() =>
      firestore.collection('ChurchDetails')
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => ChurchDetailsModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<ChurchDetailsModel>> fetchChurchDetails2() =>
      firestore.collection('ChurchDetails')
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => ChurchDetailsModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> updateRecord(ChurchDetailsModel church) async {
    Response res = Response();
    DocumentReference documentReferencer =
    ChurchDetailsCollection.doc(church.id);
    var result =
    await documentReferencer.update(church.toJson()).whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Updated from database";
    }).catchError((e) {
      res.code = 500;
      res.message = e;
    });
    return res;
  }

}

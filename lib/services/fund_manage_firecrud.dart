import 'dart:html';
import 'package:church_management_admin/models/fund_management_model.dart';
import 'package:church_management_admin/models/fund_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference FundManageCollection =
    firestore.collection('FundManagement');
final CollectionReference FundCollection = firestore.collection('Funds');
final FirebaseStorage fs = FirebaseStorage.instance;

class FundManageFireCrud {
  static Stream<List<FundManagementModel>> fetchFunds() =>
      FundManageCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FundManagementModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Stream<List<FundManagementModel>> fetchFundsWithFilter(
          DateTime start, DateTime end) =>
      FundManageCollection.where("timestamp",
              isLessThanOrEqualTo: end.millisecondsSinceEpoch)
          .where("timestamp",
              isGreaterThanOrEqualTo: start.millisecondsSinceEpoch)
          .orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FundManagementModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Stream<List<FundManagementModel>> fetchFundsWithFilter1(
          DateTime start, DateTime end, String recordType) =>
      FundManageCollection.where("timestamp",
              isLessThanOrEqualTo: end.millisecondsSinceEpoch)
          .where("timestamp",
              isGreaterThanOrEqualTo: start.millisecondsSinceEpoch)
          .orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .where((element) => element['recordType'] == recordType)
              .map((doc) => FundManagementModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Stream<List<FundModel>> fetchTotalFunds() =>
      FundCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => FundModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addFund(
      {required double amount,
      required double currentBalance,
      required double totalCollect,
      required double totalSpend,
      required String verifier,
      required String source,
      required String remarks,
        required File? image,
        required File? document,
      required String date,
      required String recordType}) async {
    Response response = Response();
    String imgUrl = await uploadImageToStorage(image);
    String docUrl = await uploadDocumentToStorage(document);
    DocumentReference documentReferencer = FundManageCollection.doc();
    FundManagementModel fund = FundManagementModel(
      id: "",
      timestamp: DateTime.now().millisecondsSinceEpoch,
      recordType: recordType,
      date: date,
      remarks: remarks,
      source: source,
      verifier: verifier,
      amount: amount,
      imgUrl: imgUrl,
      document: docUrl,
    );
    fund.id = documentReferencer.id;
    var json = fund.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    if (response.code == 200) {
      if (recordType == "Receivable") {
        var fund = FundCollection.doc("x18zE9lNxDto7AXHlXDA").update({
          "currentBalance": currentBalance + amount,
          "totalCollect": totalCollect + amount,
        });
      } else {
        var fund = FundCollection.doc("x18zE9lNxDto7AXHlXDA").update({
          "currentBalance": currentBalance - amount,
          "totalSpend": totalSpend + amount,
        });
      }
    }
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

}

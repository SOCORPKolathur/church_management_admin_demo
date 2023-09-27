import 'dart:html';
import 'package:church_management_admin/models/asset_management_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference AssetManagementCollection =
    firestore.collection('AssetManagement');
final FirebaseStorage fs = FirebaseStorage.instance;

class AssetManagementFireCrud {
  static Stream<List<AssetManagementModel>> fetchAssetManagements() =>
      AssetManagementCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => AssetManagementModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Stream<List<AssetManagementModel>> fetchAssetManagementsWithAmcDate(String date) =>
      AssetManagementCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element['amcDate'] == date)
          .map((doc) => AssetManagementModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<AssetManagementModel>> fetchAssetManagementsWithFilter(
          DateTime start, DateTime end) =>
      AssetManagementCollection
          .orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element['timestamp'] < end.add(const Duration(days: 1)).millisecondsSinceEpoch && element['timestamp'] >= start.millisecondsSinceEpoch)
              .map((doc) => AssetManagementModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Future<Response> addAssetManagement({
    required String description,
    required String date,
    required String amcDate,
    required String assets,
    required String verifier,
    required String approxValue,
    required File? image,
    required File? document,
  }) async {
    Response response = Response();
    String imgUrl = await uploadImageToStorage(image);
    String docUrl = await uploadDocumentToStorage(document);
    DocumentReference documentReferencer = AssetManagementCollection.doc();
    DateTime tempDate = DateFormat("dd-MM-yyyy").parse(date);
    AssetManagementModel asset = AssetManagementModel(
      id: "",
      timestamp: tempDate.millisecondsSinceEpoch,
      approxValue: approxValue,
      verifier: verifier,
      imgUrl: imgUrl,
      amcDate: amcDate,
      document: docUrl,
      assets: assets,
      date: date,
      description: description,
    );
    asset.id = documentReferencer.id;
    var json = asset.toJson();
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


  static Future<Response> updateRecord(AssetManagementModel asset) async {
    Response res = Response();
    DocumentReference documentReferencer =
        AssetManagementCollection.doc(asset.id);
    var result =
        await documentReferencer.update(asset.toJson()).whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Updated from database";
    }).catchError((e) {
      res.code = 500;
      res.message = e;
    });
    return res;
  }

  static Future<Response> deleteRecord({required String id}) async {
    Response res = Response();
    DocumentReference documentReferencer = AssetManagementCollection.doc(id);
    var result = await documentReferencer.delete().whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Deleted from database";
    }).catchError((e) {
      res.code = 500;
      res.message = e;
    });
    return res;
  }
}

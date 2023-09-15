import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/family_model.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference FamilyCollection = firestore.collection('Families');
final FirebaseStorage fs = FirebaseStorage.instance;

class FamilyFireCrud {

  static Stream<List<FamilyModel>> fetchFamilies() =>
      FamilyCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => FamilyModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Stream<List<FamilyModel>> fetchFamiliesWithFilter(String postCode) =>
      FamilyCollection
          .where("zone", isEqualTo: postCode)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => FamilyModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addFamily({
    required File image,
    required String name,
    required String email,
    required String familyId,
    required String leaderName,
    required String address,
    required String city,
    required String contactNumber,
    required String country,
    required int quantity,
    required String zone,
  }) async {
    Response response = Response();
    String downloadUrl = await uploadImageToStorage(image);
    DocumentReference documentReferencer = FamilyCollection.doc();
    FamilyModel family = FamilyModel(
      id: "",
      familyId: familyId,
      email: email,
      leaderImgUrl: downloadUrl,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      quantity: quantity,
      country: country,
      contactNumber: contactNumber,
      city: city,
      address: address,
      leaderName: leaderName,
      name: name,
      zone: zone,
    );
    family.id = documentReferencer.id;
    var json = family.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> updateRecord(FamilyModel family,File? image,String imgUrl) async {
    Response res = Response();
    if(image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      family.leaderImgUrl = downloadUrl;
    }else{
      family.leaderImgUrl = imgUrl;
    }
    DocumentReference documentReferencer = FamilyCollection.doc(family.id);
    var result = await documentReferencer.update(family.toJson()).whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Updated from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
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

  static Future<Response> deleteRecord({required String id}) async {
    Response res = Response();
    DocumentReference documentReferencer = FamilyCollection.doc(id);
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

import 'dart:html';
import 'package:church_management_admin/models/speech_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference SpeechCollection = firestore.collection('Speeches');
final FirebaseStorage fs = FirebaseStorage.instance;

class SpeechFireCrud {
  static Stream<List<SpeechModel>> fetchSpeechList() =>
      SpeechCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => SpeechModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Future<Response> addSpeech(
      {
        //required File image,
      required String firstName,
      required String lastName,
      required String position,
      required String facebook,
      required String google,
      required String instagram,
      required String linkedin,
      required String pinterest,
      required String speech,
      required String twitter,
      required String whatsapp,
      required String Date,
      required String Time,
      required String youtube}) async {
    //String downloadUrl = await uploadImageToStorage(image);
    Response response = Response();
    DocumentReference documentReferencer = SpeechCollection.doc();
    SpeechModel speechModel = SpeechModel(
        id: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
        position: position,
        lastName: lastName,
        firstName: firstName,
        facebook: facebook,
        youtube: youtube,
        whatsapp: whatsapp,
        twitter: twitter,
        google: google,
        speech: speech,
        Date: Date,
        Time: Time,
        pinterest: pinterest,
        linkedin: linkedin,
        instagram: instagram,
        imgUrl: "",//downloadUrl
    );
    speechModel.id = documentReferencer.id;
    var json = speechModel.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }


  static Future<Response> updateRecord(SpeechModel speech) async {//File? image,String imgUrl
    Response res = Response();
    // if(image != null) {
    //   String downloadUrl = await uploadImageToStorage(image);
    //   speech.imgUrl = downloadUrl;
    // }else{
    //   speech.imgUrl = imgUrl;
    // }
    DocumentReference documentReferencer = SpeechCollection.doc(speech.id);
    var result = await documentReferencer.update(speech.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = SpeechCollection.doc(id);
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

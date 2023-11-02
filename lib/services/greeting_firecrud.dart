import 'dart:html';
import 'package:church_management_admin/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';
import '../models/wish_template_model.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference UserCollection = firestore.collection('Users');
final CollectionReference BirthdayWishTemplateCollection =
    firestore.collection('BirthdayWishTemplates');
final CollectionReference AnniversaryWishTemplateCollection =
    firestore.collection('AnniversaryWishTemplates');

class GreetingFireCrud {
  static Stream<List<UserModel>> fetchBirthydays(String date) =>
      UserCollection.snapshots().map((snapshot) =>
          snapshot.docs.where((element) => element.get("dob").toString().contains(DateFormat('dd-MM-yyyy').format(DateTime.now())))
              .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Stream<List<UserModel>> fetchAnniversaries(String date) =>
      UserCollection.snapshots().map(
          (snapshot) => snapshot.docs
              .where((element) => element.get("anniversaryDate").toString().contains(DateFormat('dd-MM-yyyy').format(DateTime.now())))
              .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Stream<List<WishesTemplate>> fetchBirthdayWishesTemplates() =>
      BirthdayWishTemplateCollection.snapshots().map((snapshot) => snapshot.docs
          .map((doc) => WishesTemplate(
                title: doc.get("title"),
                content: doc.get("content"),
                selected: doc.get("selected"),
                id: doc.get("id"),
              ))
          .toList());

  static Stream<List<WishesTemplate>> fetchAnniversaryWishesTemplates() =>
      AnniversaryWishTemplateCollection.snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => WishesTemplate(
                    title: doc.get("title"),
                    content: doc.get("content"),
                    selected: doc.get("selected"),
                    id: doc.get("id"),
                  ))
              .toList());

  static Future<Response> addWishTemplate(
      {required WishesTemplate template, required bool isBirthday}) async {
    Response response = Response();
    DocumentReference documentReferencer;
    if (isBirthday) {
      documentReferencer = BirthdayWishTemplateCollection.doc();
    } else {
      documentReferencer = AnniversaryWishTemplateCollection.doc();
    }
    template.id = documentReferencer.id;
    var json = template.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }
}

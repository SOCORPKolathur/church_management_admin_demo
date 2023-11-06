import 'dart:html';
import 'package:intl/intl.dart';
import 'package:church_management_admin/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference EventCollection = firestore.collection('Events');
final FirebaseStorage fs = FirebaseStorage.instance;

class EventsFireCrud {
  static Stream<List<EventsModel>> fetchEvents() =>
      EventCollection
          .orderBy("timestamp", descending: false)
          .snapshots().map((snapshot) => snapshot.docs
          .map((doc) => EventsModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<EventsModel>> fetchEventsWithFilter(DateTime start, DateTime end) =>
      EventCollection
          .orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element['timestamp'] < end.add(const Duration(days: 1)).millisecondsSinceEpoch && element['timestamp'] >= start.millisecondsSinceEpoch)
              .map((doc) => EventsModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Future<Response> addEvent({
    required String time,
    required String title,
    required String location,
    required File? image,
    required String description,
    required String date,
  }) async {
    String downloadUrl = '';
    if(image != null){
      downloadUrl = await uploadImageToStorage(image);
    }
    Response response = Response();
    DocumentReference documentReferencer = EventCollection.doc();
    DateTime tempDate = DateFormat("dd-MM-yyyy").parse(date);
    EventsModel event = EventsModel(
      time: time,
      title: title,
      timestamp: tempDate.millisecondsSinceEpoch,
      location: location,
      imgUrl: image != null ? downloadUrl : '',
      id: "",
      description: description,
      date: date,
      views: [],
      registeredUsers: [],
    );
    event.id = documentReferencer.id;
    var json = event.toJson();
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

  static Future<Response> updateRecord(
      EventsModel event, File? image, String imgUrl) async {
    Response res = Response();
    if (image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      event.imgUrl = downloadUrl;
    } else {
      event.imgUrl = imgUrl;
    }
    DocumentReference documentReferencer = EventCollection.doc(event.id);
    var result =
        await documentReferencer.update(event.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = EventCollection.doc(id);
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

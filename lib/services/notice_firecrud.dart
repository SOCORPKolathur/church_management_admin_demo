import 'package:church_management_admin/models/prayers_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/notice_model.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference NoticeCollection = firestore.collection('Notices');

class NoticeFireCrud {
  static Stream<List<NoticeModel>> fetchNotice() => NoticeCollection.orderBy("timestamp",descending: false)
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) =>
          NoticeModel.fromJson(doc.data() as Map<String,dynamic>)).toList()
  );

  static Future<Response> addNotice({
    required String title,
    required String date,
    required String time,
    required String description,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = NoticeCollection.doc();
    NoticeModel notice = NoticeModel(
        title : title,
        id: "",
        views: [],
        date: date,
        time: time,
        description: description,
        timestamp : DateTime.now().millisecondsSinceEpoch
    );
    notice.id = documentReferencer.id;
    var json = notice.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> updateRecord(NoticeModel notice) async {
    Response res = Response();
    DocumentReference documentReferencer = NoticeCollection.doc(notice.id);
    var result = await documentReferencer.update(notice.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = NoticeCollection.doc(id);
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
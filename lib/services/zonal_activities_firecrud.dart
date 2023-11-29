import 'dart:html';
import 'dart:math';
import 'package:church_management_admin/models/user_model.dart';
import 'package:church_management_admin/models/zone_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/members_model.dart';
import '../models/response.dart';
import '../models/task_model.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference AreaCollection = firestore.collection('AreaMaster');
final CollectionReference ZoneCollection = firestore.collection('Zones');
final CollectionReference TaskCollection = firestore.collection('Tasks');
final FirebaseStorage fs = FirebaseStorage.instance;

class ZonalActivitiesFireCrud {

  static String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  /// ----------------------- Area ------------------------------

  static Future<Response> addArea({required String areaName}) async {
    Response response = Response();
    DocumentReference documentReferencer = AreaCollection.doc();
    var result = await documentReferencer.set({
      "areaName" : areaName,
    }).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> updateArea({required String id,required String areaName}) async {
    Response response = Response();
    DocumentReference documentReferencer = AreaCollection.doc(id);
    var result = await documentReferencer.update({
      "areaName" : areaName,
    }).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }


  /// --------------------------- Zone -----------------------------------


  static Stream<List<ZoneModel>> fetchZones() =>
      ZoneCollection.orderBy("timestamp", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => ZoneModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addZone(
      {
        required String zoneName,
        required String zoneId,
        required String leaderName,
        required String leaderPhone,
        required List<String> areas,
        required List<MembersModel> supportersList,
      }) async {
    Response response = Response();
    DocumentReference documentReferencer = ZoneCollection.doc();

    ZoneModel zone = ZoneModel(
      id: documentReferencer.id,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      areas: areas,
      supporters: supportersList,
      leaderName: leaderName,
      leaderPhone: leaderPhone,
      zoneId: zoneId,
      zoneName: zoneName,
    );
    zone.id = documentReferencer.id;
    var json = zone.toJson();
    print(json);
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> updateZone(ZoneModel zone,) async {
    Response res = Response();
    DocumentReference documentReferencer = ZoneCollection.doc(zone.id);
    var result = await documentReferencer.update(zone.toJson()).whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Updated from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }


/// --------------------------- Task -----------------------------------


  static Stream<List<TaskModel>> fetchOverAllTasks() =>
      TaskCollection.orderBy("timestamp", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<TaskModel>> fetchZoneWiseTask(String zoneId) =>
      TaskCollection
          .orderBy("timestamp", descending: true)
          .where("zoneId", isEqualTo: zoneId)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => TaskModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());


  static Future<Response> addTask({required TaskModel task}) async {
    Response response = Response();
    DocumentReference documentReferencer = TaskCollection.doc();
    TaskModel task1 = TaskModel(
      time: task.time,
      taskName: task.taskName,
      taskDueDate: task.taskDueDate,
      taskDescription: task.taskDescription,
      status: task.status,
      feedback: task.feedback,
      date: task.date,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      id: task.id,
      zoneName: task.zoneName,
      zoneId: task.zoneId,
      leaderName: task.leaderName,
      leaderPhone: task.leaderPhone,
      submittedDate: task.submittedDate,
      submittedTime: task.submittedTime,
    );
    task1.id = documentReferencer.id;
    var json = task1.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> editTask({required TaskModel task}) async {
    Response response = Response();
    DocumentReference documentReferencer = TaskCollection.doc(task.id);
    var json = task.toJson();
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

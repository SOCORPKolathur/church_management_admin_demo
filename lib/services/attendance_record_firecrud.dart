
import 'package:church_management_admin/models/attendace_record_model.dart';
import 'package:church_management_admin/models/attendance_for_family_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference AttendanceCollection = firestore.collection('AttendanceRecords');
final CollectionReference AttendanceFamilyCollection = firestore.collection('MemberAttendanceRecords');

final DateFormat formatter = DateFormat('yyyy-MM-dd');
DateTime selectedDate = DateTime.now();

class AttendanceRecordFireCrud {

  static Stream<List<AttendanceRecordModel>> fetchAttendances() =>
      AttendanceCollection
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => AttendanceRecordModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<AttendanceRecordModel>> fetchAttendancesWithFilter(String date) =>
      AttendanceCollection
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => AttendanceRecordModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<AttendanceFamilyRecordModel>> fetchFamilyAttendancesWithFilter(String date) =>
      AttendanceFamilyCollection
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => AttendanceFamilyRecordModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addAttendance({
    required List<Attendance> attendanceList,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = AttendanceCollection.doc();
    AttendanceRecordModel attendance = AttendanceRecordModel(
      date: formatter.format(selectedDate),
      attendance: attendanceList
    );
    var json = attendance.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> addFamilyAttendance({
    required List<AttendanceFamily> attendanceList,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = AttendanceFamilyCollection.doc();
    AttendanceFamilyRecordModel attendance = AttendanceFamilyRecordModel(
        date: formatter.format(selectedDate),
        attendance: attendanceList
    );
    var json = attendance.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  // static Future<Response> updateRecord(AttendanceRecordModel attendance) async {
  //   Response res = Response();
  //   DocumentReference documentReferencer = AttendanceCollection.doc(attendance.id);
  //   var result = await documentReferencer.update(attendance.toJson()).whenComplete(() {
  //     res.code = 200;
  //     res.message = "Sucessfully Updated from database";
  //   }).catchError((e){
  //     res.code = 500;
  //     res.message = e;
  //   });
  //   return res;
  // }

  static Future<Response> deleteRecord({required String id}) async {
    Response res = Response();
    DocumentReference documentReferencer = AttendanceCollection.doc(id);
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

import 'package:church_management_admin/models/dashboard_model.dart';
import 'package:church_management_admin/services/greeting_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;


final CollectionReference fundCollection = firestore.collection('Funds');
final CollectionReference AttendanceFamilyCollection = firestore.collection('MemberAttendanceRecords');


class DashboardFireCrud {

  static Future<DashboardModel> fetchDashBoard() async {
    DashboardModel dashboard = DashboardModel();
    var document = await UserCollection.get();
    var attendanceDocument = await AttendanceFamilyCollection.get();
    var eventsDocument = await firestore.collection('Events').get();
    int todayPresentMembers = 0;
    int todayEventsCount = 0;
    attendanceDocument.docs.forEach((element) {
      if(element.get('date') == DateFormat('dd-MM-yyyy').format(DateTime.now())){
        element.get('attendance').forEach((e){
          if(e['present'] == true){
            todayPresentMembers++;
          }
        });
      }
    });
    eventsDocument.docs.forEach((element) {
      if(element.get('date') == DateFormat('dd-MM-yyyy').format(DateTime.now())){
            todayEventsCount++;
      }
    });
    int birthdayCount = document.docs.where((element) => element.get('dob').toString().startsWith("${DateTime.now().day}-${DateTime.now().month}")).length;
    int annivasaryCount = document.docs.where((element) => element.get('anniversaryDate').toString().startsWith("${DateTime.now().day}-${DateTime.now().month}")).length;

    var totalUsers = await firestore.collection('Users').get();
    var totalCommittee = await firestore.collection('Committee').get();
    var totalPastors =  await firestore.collection('Pastors').get();
    var totalClans = await firestore.collection('Clans').get();
    var totalChorus = await firestore.collection('Chorus').get();
    var familyCount = await firestore.collection('Families').get();
    var totalStaffs = await firestore.collection('ChurchStaff').get();
    var totalStudents = await firestore.collection('Students').get();
    var totalMembers = await firestore.collection('Members').get();
    double currentBalance = await fundCollection.doc("x18zE9lNxDto7AXHlXDA").get().then((value) => value.get("currentBalance"));
    double totalCollect = await fundCollection.doc("x18zE9lNxDto7AXHlXDA").get().then((value) => value.get("totalCollect"));
    double totalSpend = await fundCollection.doc("x18zE9lNxDto7AXHlXDA").get().then((value) => value.get("totalSpend"));
    dashboard = DashboardModel(
        todayPresentMembers : todayPresentMembers.toString(),
      totalUsers: totalUsers.docs.length.toString(),
      currentBalance: currentBalance.toString(),
      totalChorus: totalChorus.docs.length.toString(),
      totalClans: totalClans.docs.length.toString(),
      annivarsaryCount: annivasaryCount.toString(),
      birthdayCount: birthdayCount.toString(),
      totalCollect: totalCollect.toString(),
      totalCommite: totalCommittee.docs.length.toString(),
      totalMembers: totalMembers.docs.length.toString(),
      totalFamilies: familyCount.docs.length.toString(),
      totalPastors: totalPastors.docs.length.toString(),
      totalSpend: totalSpend.toString(),
      totalStaffs: totalStaffs.docs.length.toString(),
      totalStudents: totalStudents.docs.length.toString(),
      todayEventsCount: todayEventsCount.toString(),
    );
    return dashboard;
  }
}

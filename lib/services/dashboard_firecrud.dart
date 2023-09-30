import 'package:church_management_admin/models/dashboard_model.dart';
import 'package:church_management_admin/services/greeting_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference userCollection = firestore.collection('Users');
final CollectionReference committeeCollection =
    firestore.collection('Committee');
final CollectionReference pastorsCollection = firestore.collection('Pastors');
final CollectionReference clansCollection = firestore.collection('Clans');
final CollectionReference chorusCollection = firestore.collection('Chorus');
final CollectionReference churchStaffCollection =
    firestore.collection('ChurchStaff');
final CollectionReference studentCollection = firestore.collection('Students');
final CollectionReference memberCollection = firestore.collection('Members');
final CollectionReference familyCollection = firestore.collection('Families');
final CollectionReference fundCollection = firestore.collection('Funds');
final CollectionReference AttendanceFamilyCollection = firestore.collection('MemberAttendanceRecords');
final CollectionReference EventCollection = firestore.collection('Events');

class DashboardFireCrud {

  static Future<DashboardModel> fetchDashBoard() async {
    DashboardModel dashboard = DashboardModel();
    var document = await UserCollection.get();
    var attendanceDocument = await AttendanceFamilyCollection.get();
    var eventsDocument = await EventCollection.get();
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
    int totalUsers = await userCollection.get().then((value) => value.size);
    int totalCommittee =
        await committeeCollection.get().then((value) => value.size);
    int totalPastors =
        await pastorsCollection.get().then((value) => value.size);
    int totalClans = await clansCollection.get().then((value) => value.size);
    int totalChorus = await chorusCollection.get().then((value) => value.size);
    int familyCount = await familyCollection.get().then((value) => value.size);
    int totalStaffs =
        await churchStaffCollection.get().then((value) => value.size);
    int totalStudents =
        await studentCollection.get().then((value) => value.size);
    int totalMembers = await memberCollection.get().then((value) => value.size);
    double currentBalance = await fundCollection.doc("x18zE9lNxDto7AXHlXDA").get().then((value) => value.get("currentBalance"));
    double totalCollect = await fundCollection.doc("x18zE9lNxDto7AXHlXDA").get().then((value) => value.get("totalCollect"));
    double totalSpend = await fundCollection.doc("x18zE9lNxDto7AXHlXDA").get().then((value) => value.get("totalSpend"));
    dashboard = DashboardModel(
        todayPresentMembers : todayPresentMembers.toString(),
      totalUsers: totalUsers.toString(),
      currentBalance: currentBalance.toString(),
      totalChorus: totalChorus.toString(),
      totalClans: totalClans.toString(),
      annivarsaryCount: annivasaryCount.toString(),
      birthdayCount: birthdayCount.toString(),
      totalCollect: totalCollect.toString(),
      totalCommite: totalCommittee.toString(),
      totalMembers: totalMembers.toString(),
      totalFamilies: familyCount.toString(),
      totalPastors: totalPastors.toString(),
      totalSpend: totalSpend.toString(),
      totalStaffs: totalStaffs.toString(),
      totalStudents: totalStudents.toString(),
      todayEventsCount: todayEventsCount.toString(),
    );
    return dashboard;
  }
}

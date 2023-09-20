import 'package:church_management_admin/models/attendance_for_family_model.dart';
import 'package:church_management_admin/models/members_model.dart';
import 'package:church_management_admin/services/members_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../services/attendance_record_firecrud.dart';
import '../../widgets/kText.dart';
import '../../widgets/switch_button.dart';

class AttendanceFamilyTab extends StatefulWidget {
  const AttendanceFamilyTab({super.key});

  @override
  State<AttendanceFamilyTab> createState() => _AttendanceFamilyTabState();
}

class _AttendanceFamilyTabState extends State<AttendanceFamilyTab> {

  TextEditingController nameController = TextEditingController();
  List<AttendanceFamily> attendanceList = [];
  bool markAttendance = false;
  TextEditingController searchDateController = TextEditingController();
  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime selectedDate = DateTime.now();

  setDateTime() async {
    setState(() {
      searchDateController.text = formatter.format(selectedDate);
    });
  }

  @override
  void initState() {
    setDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: KText(
                text: "ATTENDANCE RECORD FOR MEMBER",
                style: GoogleFonts.openSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                onTap: () {
                  setState(() {
                    markAttendance = true;
                  });
                },
                child: Container(
                  height: 35,
                  width: 200,
                  decoration: BoxDecoration(
                    color: Constants().primaryAppColor,
                    borderRadius:
                    BorderRadius.circular(10),
                  ),
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        "Mark Today's Attendance",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            markAttendance
                ? StreamBuilder(
              stream: MembersFireCrud.fetchMembers(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<MembersModel> members = snapshot.data!;
                  attendanceList.clear();
                  members.forEach((element) {
                    attendanceList.add(AttendanceFamily(
                      present: false,
                      member:
                      "${element.firstName!} ${element.lastName!}",
                      memberId: element.memberId,
                    ));
                  });
                  return Container(
                    width: 1100,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "Mark Today's Attendance",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      markAttendance = false;
                                    });
                                  },
                                  child: Container(
                                    height: 35,
                                    width: 80,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 10),
                                        child: Text(
                                          "Cancel",
                                          style: TextStyle(
                                            color: Constants().primaryAppColor,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.7 >
                              70 + attendanceList.length * 60
                              ? 115 + attendanceList.length * 60
                              : size.height * 0.7,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 480,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: attendanceList.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          top: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width: 0.5,
                                          ),
                                          bottom: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 480,
                                            child: KText(
                                              text: attendanceList[i]
                                                  .member!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            child: SmartSwitch(
                                              size: SwitchSize.medium,
                                              disabled: false,
                                              activeColor: Constants()
                                                  .primaryAppColor,
                                              inActiveColor: Colors.grey,
                                              defaultActive:
                                              attendanceList[i]
                                                  .present!,
                                              onChanged: (value) {
                                                attendanceList[i]
                                                    .present = value;
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              const SizedBox(height: 10),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Response response =
                                          await AttendanceRecordFireCrud
                                              .addFamilyAttendance( attendanceList: attendanceList);
                                          if (response.code == 200) {
                                            setState(() {
                                              markAttendance = false;
                                            });
                                            CoolAlert.show(
                                                context: context,
                                                type:
                                                CoolAlertType.success,
                                                text:
                                                "Attendance Record created successfully!",
                                                width: size.width * 0.4,
                                                backgroundColor:
                                                Constants()
                                                    .primaryAppColor
                                                    .withOpacity(
                                                    0.8));
                                          } else {
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text:
                                                "Failed to create attendance record!",
                                                width: size.width * 0.4,
                                                backgroundColor:
                                                Constants()
                                                    .primaryAppColor
                                                    .withOpacity(
                                                    0.8));
                                          }
                                        },
                                        child: Container(
                                          height: 35,
                                          width: 80,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            color: Constants()
                                                .primaryAppColor,
                                          ),
                                          child: Center(
                                            child: KText(
                                              text: "Submit",
                                              style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            )
                : StreamBuilder(
              stream: AttendanceRecordFireCrud.fetchFamilyAttendancesWithFilter(searchDateController.text),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<AttendanceFamilyRecordModel> attendances1 = snapshot.data!;
                  List<AttendanceFamily> attendances = [];
                  attendances1.forEach((element) {
                    if(element.date == searchDateController.text){
                      attendances = element.attendance!;
                    }
                  });
                  return Container(
                    width: 1100,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "Member Attendance Records",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Material(
                                  elevation: 2,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      height: 35,
                                      width: 200,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        onTap: () async {
                                          DateTime? pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(3000));
                                          if (pickedDate != null) {
                                            setState(() {
                                              searchDateController.text = formatter.format(pickedDate);
                                            });
                                          }
                                        },
                                        decoration: InputDecoration(
                                            border: InputBorder.none,
                                            hintText: searchDateController.text,
                                            contentPadding: const EdgeInsets.only(top: 3,bottom: 10,left: 10)
                                        ),
                                      )
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        attendances.isEmpty ? Container(
                          height: 130,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Center(
                            child: Text(
                              "No records found in this date!!",
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ) : Container(
                          height: size.height * 0.7 >
                              70 + attendances.length * 60
                              ? 70 + attendances.length * 60
                              : size.height * 0.7,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 100,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 480,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: KText(
                                          text: "Attendance",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: attendances.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          top: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width: 0.5,
                                          ),
                                          bottom: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: 100,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 480,
                                            child: KText(
                                              text: attendances[i]
                                                  .member!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              attendances[i].present!
                                                  ? "Present"
                                                  : "Absent",
                                              style: TextStyle(
                                                color: attendances[i].present!
                                                    ? Colors.green
                                                    : Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            )
          ],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Constants().primaryAppColor),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Please fill required fields !!',
                  style: TextStyle(color: Colors.black)),
            ),
            const Spacer(),
            TextButton(
                onPressed: () => debugPrint("Undid"), child: const Text("Undo"))
          ],
        )),
  );

}

import 'dart:html';
import 'dart:typed_data';
import 'package:church_management_admin/models/attendance_for_family_model.dart';
import 'package:church_management_admin/models/members_model.dart';
import 'package:church_management_admin/services/members_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../services/attendance_record_firecrud.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';
import '../../widgets/switch_button.dart';
import '../prints/attendance_family_print.dart';

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
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  DateTime selectedDate = DateTime.now();

  setDateTime() async {
    setState(() {
      searchDateController.text = formatter.format(selectedDate);
    });
  }

  DateTime? dateRangeStart;
  DateTime? dateRangeEnd;
  bool isFiltered= false;
  bool attendanceMarked = false;
  bool editAttendance = false;

  @override
  void initState() {
    setDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
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
                    fontSize: width/52.53846153846154,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      if(!attendanceMarked){
                        setState(() {
                          markAttendance = true;
                        });
                      }else{
                        setState(() {

                        });
                      }
                    },
                    child: Container(
                      height: height/18.6,
                      width: width/6.83,
                      decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            attendanceMarked ? "Attendance Marked already" : "Mark Today's Attendance",
                            style:  TextStyle(
                              color: Constants().btnTextColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Visibility(
                    visible: attendanceMarked,
                    child: InkWell(
                      onTap: () {
                        setState(() {
                          markAttendance = true;
                          editAttendance = true;
                        });
                      },
                      child: Container(
                        height: height/18.6,
                        width: width/6.83,
                        decoration: BoxDecoration(
                          color: Constants().primaryAppColor,
                          borderRadius:
                          BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Text(
                               "Edit Today's Attendance",
                              style: TextStyle(
                                color: Constants().btnTextColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
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
                    width: width/1.241818181818182,
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
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      markAttendance = false;
                                      editAttendance = false;
                                    });
                                  },
                                  child: Container(
                                    height: height/18.6,
                                    width: width/17.075,
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
                          height: size.height * 0.73,
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
                                        width: width/13.66,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/2.845833333333333,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/9.106666666666667,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: height/65.1),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: attendanceList.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: height/10.85,
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
                                            width: width/13.66,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/2.845833333333333,
                                            child: KText(
                                              text: attendanceList[i]
                                                  .member!,
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
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
                              SizedBox(height: height/65.1),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          Response response;
                                          if(editAttendance){
                                            response = await AttendanceRecordFireCrud.editFamilyAttendance( attendanceList: attendanceList);
                                          }else{
                                            response = await AttendanceRecordFireCrud.addFamilyAttendance( attendanceList: attendanceList);
                                          }
                                          if (response.code == 200) {
                                            setState(() {
                                              markAttendance = false;
                                              attendanceMarked = false;
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
                                          height: height/18.6,
                                          width: width/17.075,
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
                                                color: Constants().btnTextColor,
                                                fontSize: width/105.0769230769231,
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
              stream: isFiltered ? AttendanceRecordFireCrud.fetchFamilyAttendancesWithFilterRange(dateRangeStart,dateRangeEnd) : AttendanceRecordFireCrud.fetchFamilyAttendancesWithFilter(searchDateController.text),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<AttendanceFamilyRecordModel> attendances1 = snapshot.data!;
                  List<AttendanceFamily> attendances = [];
                  attendances1.forEach((element) {
                    if(element.date == searchDateController.text){
                      attendances = element.attendance!;
                      attendanceMarked = true;
                    }
                  });
                  return Container(
                    width: width/1.241818181818182,
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
                              children: [
                                KText(
                                  text: "Member Attendance Records",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Expanded(child: Container()),
                                Material(
                                  elevation: 2,
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  child: Container(
                                      height: height/18.6,
                                      width: width/6.83,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        readOnly: true,
                                        onTap: () async {
                                          DateTime? pickedDate =
                                          await Constants().datePicker(context);
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
                                ),
                                SizedBox(width: width/136.6),
                                isFiltered ? InkWell(
                                  onTap: () {
                                    setState(() {
                                      isFiltered = false;
                                      dateRangeEnd = null;
                                      dateRangeStart = null;
                                    });
                                  },
                                  child: Container(
                                    height: height/16.275,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                      child: Center(
                                        child: KText(
                                          text: "Clear Filter",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/97.57142857142857,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ) : InkWell(
                                  onTap: () async {
                                    var result = await filterPopUp();
                                    if(result){
                                      setState(() {
                                        isFiltered = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: height/16.275,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding:
                                      const EdgeInsets.symmetric(horizontal: 6),
                                      child: Center(
                                        child: KText(
                                          text: "Filter by Range",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/97.57142857142857,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: width/136.6),
                              ],
                            ),
                          ),
                        ),
                        attendances.isEmpty ? Container(
                          height: size.height * 0.73,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        generateAttendanceforFamilyPdf(PdfPageFormat.letter, attendances1,false);
                                      },
                                      child: Container(
                                        height: height/18.6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xfffe5722),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.print,
                                                    color: Colors.white),
                                                KText(
                                                  text: "PRINT",
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize: width/105.0769230769231,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width/136.6),
                                    InkWell(
                                      onTap: () {
                                        copyToClipBoard(attendances);
                                      },
                                      child: Container(
                                        height: height/18.6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xffff9700),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.copy,
                                                    color: Colors.white),
                                                KText(
                                                  text: "COPY",
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize: width/105.0769230769231,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width/136.6),
                                    InkWell(
                                      onTap: () async {
                                        var data = await generateAttendanceforFamilyPdf(PdfPageFormat.letter, attendances1, true);
                                        savePdfToFile(data);
                                      },
                                      child: Container(
                                        height: height/18.6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xff9b28b0),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(Icons.picture_as_pdf,
                                                    color: Colors.white),
                                                KText(
                                                  text: "PDF",
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize: width/105.0769230769231,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width/136.6),
                                    InkWell(
                                      onTap: () {
                                        convertToCsv(attendances);
                                      },
                                      child: Container(
                                        height: height/18.6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xff019688),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 6),
                                          child: Center(
                                            child: Row(
                                              children: [
                                                const Icon(
                                                    Icons.file_copy_rounded,
                                                    color: Colors.white),
                                                KText(
                                                  text: "CSV",
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.white,
                                                    fontSize: width/105.0769230769231,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(child: Container()),
                                    isFiltered
                                        ? Text(
                                           "Reports from ${formatter.format(dateRangeStart!)} - ${formatter.format(dateRangeEnd!)}",
                                           style: const TextStyle(
                                             fontWeight: FontWeight.bold,

                                           ),
                                          )
                                        : Text("Reports from " +searchDateController.text,style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),)
                                  ],
                                ),
                              ),
                              Center(
                                child: Text(
                                  "No records found in this date!!",
                                  style: GoogleFonts.openSans(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ) : Container(
                          height: size.height * 0.73,
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
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      generateAttendanceforFamilyPdf(PdfPageFormat.letter, attendances1,false);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xfffe5722),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.print,
                                                  color: Colors.white),
                                              KText(
                                                text: "PRINT",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () {
                                      copyToClipBoard(attendances);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xffff9700),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.copy,
                                                  color: Colors.white),
                                              KText(
                                                text: "COPY",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () async {
                                      var data = await generateAttendanceforFamilyPdf(PdfPageFormat.letter, attendances1, true);
                                      savePdfToFile(data);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff9b28b0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.picture_as_pdf,
                                                  color: Colors.white),
                                              KText(
                                                text: "PDF",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () {
                                      convertToCsv(attendances);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration: const BoxDecoration(
                                        color: Color(0xff019688),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  Icons.file_copy_rounded,
                                                  color: Colors.white),
                                              KText(
                                                text: "CSV",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Expanded(child: Container()),
                                  isFiltered
                                      ? Text(
                                    "Reports from ${formatter.format(dateRangeStart!)} - ${formatter.format(dateRangeEnd!)}",
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,

                                    ),
                                  )
                                      : Text("Reports from ${searchDateController.text}",style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),)
                                ],
                              ),
                              SizedBox(height: height/21.7),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width/13.66,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/2.845833333333333,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/9.106666666666667,
                                        child: KText(
                                          text: "Attendance",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height: height/65.1),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: attendances1.length,
                                  itemBuilder: (ctx, i) {
                                    return Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Constants().primaryAppColor,
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 10),
                                            child: Center(
                                              child: Text(
                                                "Date : ${attendances1[i].date!}",
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.0769230769231,
                                                  color: Colors.white,
                                                  fontWeight:
                                                  FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        for(int j = 0; j < attendances1[i].attendance!.length; j ++)
                                          Container(
                                            height: height/10.85,
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
                                                  width: width/13.66,
                                                  child: KText(
                                                    text: (j + 1).toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/2.845833333333333,
                                                  child: KText(
                                                    text: attendances1[i].attendance![j]
                                                        .member!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: Text(
                                                    attendances1[i].attendance![j].present!
                                                        ? "Present"
                                                        : "Absent",
                                                    style: TextStyle(
                                                      color: attendances1[i].attendance![j].present!
                                                          ? Colors.green
                                                          : Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                      ],
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
            ),
            SizedBox(height: size.height * 0.04),
            const DeveloperCardWidget(),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }

  convertToCsv(List<AttendanceFamily> attendance) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Member ID");
    row.add("Member Name");
    row.add("Attendance");
    rows.add(row);
    for (int i = 0; i < attendance.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(attendance[i].memberId!);
      row.add(attendance[i].member!);
      row.add(attendance[i].present! ? "Present" : "Absent");
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);
    saveCsvToFile(csv);
  }

  void saveCsvToFile(csvString) async {
    final blob = Blob([Uint8List.fromList(csvString.codeUnits)]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "AttendanceForMembers.csv")
      ..click();
    Url.revokeObjectUrl(url);
  }

  void savePdfToFile(data) async {
    final blob = Blob([data],'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "AttendanceForMembers.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<AttendanceFamily> attendance) async  {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Member ID");
    row.add("    ");
    row.add("Member Name");
    row.add("    ");
    row.add("Attendance");
    rows.add(row);
    for (int i = 0; i < attendance.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add(attendance[i].memberId);
      row.add("       ");
      row.add(attendance[i].member);
      row.add("       ");
      row.add(attendance[i].present);
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows,fieldDelimiter: null,eol: null,textEndDelimiter: null,delimitAllFields: false,textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",","")));
  }

  filterPopUp() {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
            builder: (context,setState) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                content: Container(
                  height: size.height * 0.4,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Constants().primaryAppColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: KText(
                                text: "Filter",
                                style: GoogleFonts.openSans(
                                  fontSize: width/85.375,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: width/15.17777777777778,
                                    child: KText(
                                      text: "Start Date",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.57142857142857,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/85.375),
                                  Container(
                                    height: height/16.275,
                                    width: width/15.17777777777778,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                          offset: Offset(2, 3),
                                        )
                                      ],
                                    ),
                                    child: TextField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(color: Color(0xff00A99D)),
                                        hintText: dateRangeStart != null ? "${dateRangeStart!.day}/${dateRangeStart!.month}/${dateRangeStart!.year}" : "",
                                        border: InputBorder.none,
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                        await Constants().datePicker(context);
                                        if (pickedDate != null) {
                                          setState(() {
                                            dateRangeStart = pickedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width/15.17777777777778,
                                    child: KText(
                                      text: "End Date",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.57142857142857,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/85.375),
                                  Container(
                                    height: height/16.275,
                                    width: width/15.17777777777778,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                          offset: Offset(2, 3),
                                        )
                                      ],
                                    ),
                                    child: TextField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(color: Color(0xff00A99D)),
                                        hintText: dateRangeEnd != null ? "${dateRangeEnd!.day}/${dateRangeEnd!.month}/${dateRangeEnd!.year}" : "",
                                        border: InputBorder.none,
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                        await Constants().datePicker(context);
                                        if (pickedDate != null) {
                                          setState(() {
                                            dateRangeEnd = pickedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context,false);
                                    },
                                    child: Container(
                                      height: height/16.275,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 6),
                                        child: Center(
                                          child: KText(
                                            text: "Cancel",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/85.375,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/273.2),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context,true);
                                    },
                                    child: Container(
                                      height: height/16.275,
                                      decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:
                                        const EdgeInsets.symmetric(horizontal: 6),
                                        child: Center(
                                          child: KText(
                                            text: "Apply",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/85.375,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }
        );
      },
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

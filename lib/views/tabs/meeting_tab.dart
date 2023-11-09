import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:church_management_admin/models/response.dart';
import 'package:church_management_admin/services/greeting_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import '../../models/wish_template_model.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';

class MeetingsTab extends StatefulWidget {
  const MeetingsTab({super.key});

  @override
  State<MeetingsTab> createState() => _MeetingsTabState();
}

class _MeetingsTabState extends State<MeetingsTab> {

  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController organizedByController = TextEditingController();

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  String currentTab = 'View';

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
        timeController.text = picked.toString();
      });
    _formatTime(picked!);
  }


  String _formatTime(TimeOfDay time) {
    int hour = time.hourOfPeriod;
    int minute = time.minute;
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    setState(() {
      timeController.text ='${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    });

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  clearTextControllers(){
      setState(() {
        dateController.clear();
        timeController.clear();
        descriptionController.clear();
        titleController.clear();
        locationController.clear();
        organizedByController.clear();
        currentTab = 'View';
      });
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
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "Meetings",
                    style: GoogleFonts.openSans(
                        fontSize: width/52.53846153846154,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                  InkWell(
                      onTap:(){
                        if(currentTab.toUpperCase() == "VIEW") {
                          setState(() {
                            currentTab = "Add";
                          });
                        }else{
                          setState(() {
                            currentTab = 'View';
                          });
                          clearTextControllers();
                        }
                      },
                      child: Container(
                        height:height/18.6,
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
                          EdgeInsets.symmetric(horizontal:width/227.66),
                          child: Center(
                            child: KText(
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Meeting" : "View Meetings",
                              style: GoogleFonts.openSans(
                                fontSize:width/105.07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
            currentTab.toUpperCase() == "ADD"
                ? Container(
              width:width/1.2418,
              margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
              decoration: BoxDecoration(
                color: Constants().primaryAppColor,
                boxShadow: [
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
                      padding:
                      EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: "ADD NEW MEETING",
                            style: GoogleFonts.openSans(
                              fontSize: width/68.3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (dateController.text != "" &&
                                  timeController.text != "" &&
                                  locationController.text != "") {
                                FirebaseFirestore.instance.collection('Meetings').doc().set({
                                  "date" : dateController.text,
                                  "time" : timeController.text,
                                  "title" : titleController.text,
                                  "description" : descriptionController.text,
                                  "location" : locationController.text,
                                  "organizedBy" : organizedByController.text,
                                  "meetingDateTimestamp" : DateFormat('dd-MM-yyyy').parse(dateController.text).millisecondsSinceEpoch,
                                  "timestamp" : DateTime.now().millisecondsSinceEpoch,
                                });
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.success,
                                    text: "Event created successfully!",
                                    width: size.width * 0.4,
                                    backgroundColor: Constants()
                                        .primaryAppColor
                                        .withOpacity(0.8));
                                clearTextControllers();
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                            child: Container(
                              height: height/16.275,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 2),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding:
                                EdgeInsets.symmetric(horizontal:width/227.66),
                                child: Center(
                                  child: KText(
                                    text: "ADD NOW",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/85.375,
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
                    height: size.height * 0.75,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xffF7FAFC),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Date *",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: height/13.02,
                                        width: width/9.106,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                          child: TextFormField(
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none
                                            ),
                                            controller: dateController,
                                            onTap: () async {
                                              DateTime? pickedDate =
                                              await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime(1900),
                                                  lastDate: DateTime(3000));
                                              if (pickedDate != null) {
                                                setState(() {
                                                  dateController.text = formatter.format(pickedDate);
                                                });
                                              }
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(width: width/68.3),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Time *",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: height/13.02,
                                        width: width/9.106,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                          child: TextFormField(
                                            readOnly: true,
                                            onTap: (){
                                              _selectTime(context);
                                            },
                                            controller: timeController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: GoogleFonts.openSans(
                                                fontSize: width/97.571,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(width: width/68.3),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Location *",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: height/13.02,
                                        width: width/6.830,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                          child: TextFormField(
                                            controller: locationController,
                                            decoration: InputDecoration(
                                              contentPadding: EdgeInsets.symmetric(vertical: 5),
                                              border: InputBorder.none,
                                              hintStyle: GoogleFonts.openSans(
                                                fontSize: width/97.571,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height/65.1),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Organized By(Head) *",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: height/10.850,
                                        width: size.width * 0.36,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                          child: TextFormField(
                                            keyboardType: TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: null,
                                            controller: organizedByController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: GoogleFonts.openSans(
                                                fontSize: width/97.571,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height/65.1),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Title *",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: height/10.850,
                                        width: size.width * 0.56,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                          child: TextFormField(
                                            keyboardType: TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: null,
                                            controller: titleController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: GoogleFonts.openSans(
                                                fontSize: width/97.571,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height/65.1),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Description",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: height/6.510,
                                        width: size.width * 0.56,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                          child: TextFormField(
                                            keyboardType: TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: 5,
                                            controller: descriptionController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintStyle: GoogleFonts.openSans(
                                                fontSize: width/97.571,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),

                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                : Container(
              height: size.height * 0.85,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Meetings').orderBy("timestamp", descending: true).snapshots(),
                builder: (ctx, snap){
                  if(snap.hasData){
                    List<DocumentSnapshot> meetings = [];
                    snap.data!.docs.forEach((element) {
                      if(element.get("date") == DateFormat('dd-MM-yyyy').format(DateTime.now())){
                        meetings.add(element);
                      }
                    });
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          children: [
                            Container(
                              height: height/13.02,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Constants().primaryAppColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Meetings for Today",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: width/80.35294117647059,
                                        color: Colors.black,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        List<DocumentSnapshot> snaps = [];
                                        snap.data!.docs.forEach((element) {
                                          if(element.get("meetingDateTimestamp") > DateTime.now().millisecondsSinceEpoch){
                                            snaps.add(element);
                                          }
                                        });
                                        viewUpcomingMeetings(snaps);
                                      },
                                      child: Material(
                                        borderRadius:
                                        BorderRadius.circular(5),
                                        color: Colors.white,
                                        elevation: 10,
                                        child: SizedBox(
                                          height: height / 18.6,
                                          width: width / 6.106,
                                          child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: height / 81.375, horizontal: width / 180.75),
                                              child: Center(
                                                child: Text(
                                                  "View Upcoming meetings",
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: ListView.builder(
                                  itemCount: meetings.length,
                                  itemBuilder: (ctx , i){
                                    var data = meetings[i];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: Container(
                                        height: 100,
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Title : "+ meetings[i].get("title"),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                     meetings[i].get("description"),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              ),
                                              Expanded(child: Container()),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                   "Date : "+ meetings[i].get("date"),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Time : "+ meetings[i].get("time"),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  )
                                                ],
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }return Container();
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  viewUpcomingMeetings(List<DocumentSnapshot> meetings){
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: size.width * 0.5,
            margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  offset: Offset(1, 2),
                  blurRadius: 3,
                ),
              ],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Container(
              height: height*0.6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Container(
                    height: height*0.08,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
                      ),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Upcoming Meetings",
                          style: GoogleFonts.openSans(
                              fontSize: width/56.538,
                              fontWeight: FontWeight.w700,
                              color: Colors.black),
                        ),
                        IconButton(
                          onPressed: (){
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomRight: Radius.circular(10),
                          bottomLeft: Radius.circular(10),
                        ),
                      ),
                      child: ListView.builder(
                        itemCount: meetings.length,
                        itemBuilder: (ctx, i){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          "Title : "+ meetings[i].get("title"),
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                           meetings[i].get("description"),
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    ),
                                    Expanded(child: Container()),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Date : "+ meetings[i].get("date"),
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        Text(
                                          "Time : "+ meetings[i].get("time"),
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow: [
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
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Please fill required fields !!',
                  style: TextStyle(color: Colors.black)),
            ),
            Spacer(),
            TextButton(
                onPressed: () => debugPrint("Undid"), child: Text("Undo"))
          ],
        )),
  );


}

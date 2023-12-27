import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:intl/intl.dart';

import '../../constants.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/event_calender.dart';
import '../../widgets/kText.dart';

class FunctionHallTab extends StatefulWidget {
  const FunctionHallTab({super.key});

  @override
  State<FunctionHallTab> createState() => _FunctionHallTabState();
}

class _FunctionHallTabState extends State<FunctionHallTab> {


  TextEditingController dateController = TextEditingController();
  TextEditingController date2Controller = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController timeController2 = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController reasonController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  DateTime? fromTime;
  DateTime? toTime;

  TextfieldTagsController controller = TextfieldTagsController();
  static List<String> _pickLanguage = <String>[];

  final DateFormat formatter = DateFormat('yyyy-MM-dd');

  String currentTab = 'View';

  TimeOfDay _selectedTime = TimeOfDay.now();
  TimeOfDay _selectedTime1 = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null){
      DateTime now = DateTime.parse(dateController.text);
      setState(() {
        _selectedTime = picked;
        fromTime = DateTime(now.year,now.month,now.day,picked.hour,picked.minute);
        timeController.text = picked.toString();
        _keyTime.currentState!.validate();
      });
      _formatTime(picked!);
    }
  }

  Future<void> _selectTime2(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime1,
    );
    if (picked != null){
      DateTime now = DateTime.parse(dateController.text);
      setState(() {
        _selectedTime1 = picked;
        toTime = DateTime(now.year,now.month,now.day,picked.hour,picked.minute);
        timeController2.text = picked.toString();
        _keyTime2.currentState!.validate();
      });
      _formatTime2(picked!);
    }
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

  String _formatTime2(TimeOfDay time) {
    int hour = time.hourOfPeriod;
    int minute = time.minute;
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    setState(() {
      timeController2.text ='${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    });

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  clearTextControllers(){
    setState(() {
      dateController.clear();
      date2Controller.clear();
      timeController.clear();
      timeController2.clear();
      descriptionController.clear();
      titleController.clear();
      locationController.clear();
      reasonController.clear();
      phoneController.clear();
      addressController.clear();
      currentTab = 'View';
    });
  }

  final _keyPhone = GlobalKey<FormFieldState>();
  final _keyDate = GlobalKey<FormFieldState>();
  final _keyDate2 = GlobalKey<FormFieldState>();
  final _keyTime = GlobalKey<FormFieldState>();
  final _keyTime2 = GlobalKey<FormFieldState>();
  final _keyDescription = GlobalKey<FormFieldState>();
  final _keyTitle = GlobalKey<FormFieldState>();
  final _keyReason = GlobalKey<FormFieldState>();
  final _keyAddress = GlobalKey<FormFieldState>();
  final _keyLocation = GlobalKey<FormFieldState>();


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
                    text: "Function Hall",
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
                              text: currentTab.toUpperCase() == "VIEW" ? "Book" : "View Bookings",
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
                            text: "Book for Function",
                            style: GoogleFonts.openSans(
                              fontSize: width/68.3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (
                              _keyDate.currentState!.validate() &&
                                  _keyDate2.currentState!.validate() &&
                                  _keyPhone.currentState!.validate() &&
                                  _keyTime.currentState!.validate() &&
                                  _keyTime2.currentState!.validate() &&
                                  _keyReason.currentState!.validate() &&
                                  _keyTitle.currentState!.validate() &&
                                  _keyLocation.currentState!.validate() &&
                                  _keyAddress.currentState!.validate()) {
                                FirebaseFirestore.instance.collection('FunctionHall').doc().set({
                                  "date" : dateController.text,
                                  "toDate" : date2Controller.text,
                                  "fromTime" : fromTime!.millisecondsSinceEpoch,
                                  "toTime" : toTime!.millisecondsSinceEpoch,
                                  "fromTimeStr" : timeController.text,
                                  "toTimeStr" : timeController2.text,
                                  "title" : titleController.text,
                                  "phone" : phoneController.text,
                                  "address" : addressController.text,
                                  "location" : locationController.text,
                                  "reason" : reasonController.text,
                                  "meetingDateTimestamp" : DateFormat('dd-MM-yyyy').parse(dateController.text).millisecondsSinceEpoch,
                                  "timestamp" : DateTime.now().millisecondsSinceEpoch,
                                });
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.success,
                                    text: "Booked successfully!",
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
                    height: size.height * 0.8,
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
                                      text: "From Date *",
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
                                            key: _keyDate,
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Field is required';
                                              }else{
                                                return null;
                                              }
                                            },
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none
                                            ),
                                            controller: dateController,
                                            onTap: () async {
                                              DateTime? pickedDate =
                                              await Constants().futureDatePicker(context);
                                              if (pickedDate != null) {
                                                setState(() {
                                                  dateController.text = formatter.format(pickedDate);
                                                  _keyDate.currentState!.validate();
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
                                      text: "To Date *",
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
                                            key: _keyDate2,
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Field is required';
                                              }else{
                                                return null;
                                              }
                                            },
                                            readOnly: true,
                                            decoration: InputDecoration(
                                                border: InputBorder.none
                                            ),
                                            controller: date2Controller,
                                            onTap: () async {
                                              DateTime? pickedDate =
                                              await Constants().futureDatePicker(context);
                                              if (pickedDate != null) {
                                                setState(() {
                                                  date2Controller.text = formatter.format(pickedDate);
                                                  _keyDate2.currentState!.validate();
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
                                      text: "From Time *",
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
                                            key: _keyTime,
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Field is required';
                                              }else{
                                                return null;
                                              }
                                            },
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
                                      text: "To Time *",
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
                                            key: _keyTime2,
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Field is required';
                                              }else{
                                                return null;
                                              }
                                            },
                                            readOnly: true,
                                            onTap: (){
                                              _selectTime2(context);
                                            },
                                            controller: timeController2,
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
                                            key: _keyLocation,
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Field is required';
                                              }else{
                                                return null;
                                              }
                                            },
                                            onChanged: (val){
                                              _keyLocation.currentState!.validate();
                                            },
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
                                      text: "Booking For *",
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
                                            key: _keyReason,
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Field is required';
                                              }else{
                                                return null;
                                              }
                                            },
                                            onChanged: (val){
                                              _keyReason.currentState!.validate();
                                            },
                                            keyboardType: TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: null,
                                            controller: reasonController,
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
                                      text: "Function Name *",
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
                                            key: _keyTitle,
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Field is required';
                                              }else{
                                                return null;
                                              }
                                            },
                                            onChanged: (val){
                                              _keyTitle.currentState!.validate();
                                            },
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Phone *",
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
                                            key: _keyPhone,
                                            validator: (val){
                                              if(val!.isEmpty) {
                                                return 'Field is required';
                                              } else if(val.length != 10){
                                                return 'number must be 10 digits';
                                              }else{
                                                return null;
                                              }
                                            },
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            onEditingComplete: (){
                                              _keyPhone.currentState!.validate();
                                            },
                                            onFieldSubmitted: (val){
                                              _keyPhone.currentState!.validate();
                                            },
                                            maxLength: 10,
                                            controller: phoneController,
                                            decoration: InputDecoration(
                                              counterText: "",
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
                                      text: "Adddress *",
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
                                            key: _keyAddress,
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Field is required';
                                              }else{
                                                return null;
                                              }
                                            },
                                            onChanged: (val){
                                              _keyAddress.currentState!.validate();
                                            },
                                            keyboardType: TextInputType.multiline,
                                            minLines: 1,
                                            maxLines: null,
                                            controller: addressController,
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
                : SizedBox(
              height: size.height * 0.85,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('FunctionHall').orderBy("timestamp", descending: true).snapshots(),
                builder: (ctx, snap){
                  if(snap.hasData){
                    List<DocumentSnapshot> bookings = [];
                    bookings.addAll(snap.data!.docs);
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
                                      "Bookings",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: width/80.35294117647059,
                                        color: Colors.black,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        showCalenderPopup(snap.data!.docs);
                                        // List<DocumentSnapshot> snaps = [];
                                        // snap.data!.docs.forEach((element) {
                                        //   if(element.get("meetingDateTimestamp") > DateTime.now().millisecondsSinceEpoch){
                                        //     snaps.add(element);
                                        //   }
                                        // });
                                        // viewUpcomingMeetings(snaps);
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
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      "Calender View",
                                                      style: GoogleFonts.poppins(
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          ),
                                        ),
                                      ),
                                    ),
                                    // InkWell(
                                    //   onTap: (){
                                    //     List<DocumentSnapshot> snaps = [];
                                    //     snap.data!.docs.forEach((element) {
                                    //       if(element.get("meetingDateTimestamp") > DateTime.now().millisecondsSinceEpoch){
                                    //         snaps.add(element);
                                    //       }
                                    //     });
                                    //     viewUpcomingMeetings(snaps);
                                    //   },
                                    //   child: Material(
                                    //     borderRadius:
                                    //     BorderRadius.circular(5),
                                    //     color: Colors.white,
                                    //     elevation: 10,
                                    //     child: SizedBox(
                                    //       height: height / 18.6,
                                    //       width: width / 6.106,
                                    //       child: Padding(
                                    //           padding: EdgeInsets.symmetric(vertical: height / 81.375, horizontal: width / 180.75),
                                    //           child: Center(
                                    //             child: Text(
                                    //               "View Upcoming meetings",
                                    //               style: GoogleFonts.poppins(
                                    //                 fontWeight: FontWeight.w600,
                                    //               ),
                                    //             ),
                                    //           )
                                    //       ),
                                    //     ),
                                    //   ),
                                    // ),
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
                                  itemCount: bookings.length,
                                  itemBuilder: (ctx , i){
                                    var data = bookings[i];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:10, vertical: 20),
                                          child: Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Title : "+ data.get("title"),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    "Date : "+ data.get("date"),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Text(
                                                        "From : "+ data.get("fromTimeStr"),
                                                        style: GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                      SizedBox(width: 10),
                                                      Text(
                                                        "${"Till : "+ data.get("toDate")} " + data.get("toTimeStr"),
                                                        style: GoogleFonts.poppins(
                                                          color: Colors.black,
                                                          fontWeight: FontWeight.w400,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                              Expanded(child: Container()),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      viewPopup(data);
                                                    },
                                                    child: Container(
                                                      height: height /26.04,
                                                      width: width/19.51428571428571,
                                                      decoration:const BoxDecoration(
                                                        color: Color(0xff2baae4),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26,
                                                            offset:
                                                            Offset(1,2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets .symmetric(horizontal:width / 227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.remove_red_eye,
                                                                color: Colors.white,
                                                                size: width / 91.066,
                                                              ),
                                                              KText(
                                                                text: "View",
                                                                style: GoogleFonts.openSans(
                                                                  color: Colors.white,
                                                                  fontSize: width / 136.6,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        dateController.text = data.get("date");
                                                        date2Controller.text = data.get("toDate");
                                                        timeController.text = data.get("fromTimeStr");
                                                        timeController2.text = data.get("toTimeStr");
                                                        titleController.text = data.get("title");
                                                        locationController.text = data.get("location");
                                                        reasonController.text = data.get("reason");
                                                        phoneController.text = data.get("phone");
                                                        addressController.text = data.get("address");
                                                        fromTime = Timestamp.fromMillisecondsSinceEpoch(data.get("fromTime")).toDate();
                                                        toTime = Timestamp.fromMillisecondsSinceEpoch(data.get("toTime")).toDate();
                                                        currentTab = 'View';
                                                      });
                                                      editBooking(data);
                                                    },
                                                    child: Container(
                                                      height: height /26.04,
                                                      width: width/19.51428571428571,
                                                      decoration:const BoxDecoration(
                                                        color: Colors.orange,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26,
                                                            offset:
                                                            Offset(1,2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets .symmetric(horizontal:width / 227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.edit,
                                                                color: Colors.white,
                                                                size: width / 91.066,
                                                              ),
                                                              KText(
                                                                text: "Edit",
                                                                style: GoogleFonts.openSans(
                                                                  color: Colors.white,
                                                                  fontSize: width / 136.6,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context:
                                                          context,
                                                          type:
                                                          CoolAlertType
                                                              .info,
                                                          text:
                                                          "${data.get("title")} will be deleted",
                                                          title:
                                                          "Delete this Record?",
                                                          width: size.width * 0.4,
                                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          showCancelBtn:true,
                                                          cancelBtnText:'Cancel',
                                                          cancelBtnTextStyle:
                                                          TextStyle( color: Colors.black),
                                                          onConfirmBtnTap: (){
                                                            FirebaseFirestore.instance.collection("FunctionHall").doc(data.id).delete();
                                                          });
                                                    },
                                                    child: Container(
                                                      height: height /26.04,
                                                      width: width/19.51428571428571,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.red,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26,
                                                            offset:
                                                            Offset(1,2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets .symmetric(horizontal:width / 227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.cancel,
                                                                color: Colors.white,
                                                                size: width / 91.066,
                                                              ),
                                                              KText(
                                                                text: "Delete",
                                                                style: GoogleFonts.openSans(
                                                                  color: Colors.white,
                                                                  fontSize: width / 136.6,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
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
            ),
            SizedBox(height: size.height * 0.04),
            const DeveloperCardWidget(),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }

  editBooking(DocumentSnapshot booking){
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
            builder: (context,setStat) {
              return AlertDialog(
                  backgroundColor: Colors.transparent,
                  content: Container(
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
                                  text: "Edit Booking",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (_keyDate.currentState!.validate() &&
                                        _keyDate2.currentState!.validate() &&
                                        _keyPhone.currentState!.validate() &&
                                        _keyTime.currentState!.validate() &&
                                        _keyTime2.currentState!.validate() &&
                                        _keyReason.currentState!.validate() &&
                                        _keyTitle.currentState!.validate() &&
                                        _keyLocation.currentState!.validate() &&
                                        _keyAddress.currentState!.validate()) {
                                      FirebaseFirestore.instance.collection('FunctionHall').doc(booking.id).update({
                                        "date" : dateController.text,
                                        "toDate" : date2Controller.text,
                                        "fromTime" : fromTime!.millisecondsSinceEpoch,
                                        "toTime" : toTime!.millisecondsSinceEpoch,
                                        "fromTimeStr" : timeController.text,
                                        "toTimeStr" : timeController2.text,
                                        "title" : titleController.text,
                                        "phone" : phoneController.text,
                                        "address" : addressController.text,
                                        "location" : locationController.text,
                                        "reason" : reasonController.text,
                                        "meetingDateTimestamp" : DateFormat('dd-MM-yyyy').parse(dateController.text).millisecondsSinceEpoch,
                                        "timestamp" : DateTime.now().millisecondsSinceEpoch,
                                      });
                                      await CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Booking updated successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      clearTextControllers();
                                      Navigator.pop(context);
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
                                          text: "Update Now",
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
                          height: size.height * 0.7,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xffF7FAFC),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          //padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "From Date *",
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
                                                  key: _keyDate,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none
                                                  ),
                                                  controller: dateController,
                                                  onTap: () async {
                                                    DateTime? pickedDate =
                                                    await Constants().futureDatePicker(context);
                                                    if (pickedDate != null) {
                                                      setStat(() {
                                                        dateController.text = formatter.format(pickedDate);
                                                        _keyDate.currentState!.validate();
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
                                            text: "To Date *",
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
                                                  key: _keyDate2,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  readOnly: true,
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none
                                                  ),
                                                  controller: date2Controller,
                                                  onTap: () async {
                                                    DateTime? pickedDate =
                                                    await Constants().futureDatePicker(context);
                                                    if (pickedDate != null) {
                                                      setStat(() {
                                                        date2Controller.text = formatter.format(pickedDate);
                                                        _keyDate2.currentState!.validate();
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
                                            text: "From Time *",
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
                                                  key: _keyTime,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  readOnly: true,
                                                  onTap: () async {
                                                    TimeOfDay? picked = await showTimePicker(
                                                      context: context,
                                                      initialTime: _selectedTime,
                                                    );
                                                    if (picked != null){
                                                      DateTime now = DateTime.parse(dateController.text);
                                                      setStat(() {
                                                        _selectedTime = picked;
                                                        fromTime = DateTime(now.year,now.month,now.day,picked.hour,picked.minute);
                                                        timeController.text = picked.toString();
                                                        _keyTime.currentState!.validate();
                                                      });
                                                      _formatTime(picked!);
                                                    }
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
                                            text: "To Time *",
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
                                                  key: _keyTime2,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  readOnly: true,
                                                  onTap: () async {
                                                    TimeOfDay? picked = await showTimePicker(
                                                      context: context,
                                                      initialTime: _selectedTime,
                                                    );
                                                    if (picked != null){
                                                      DateTime now = DateTime.parse(dateController.text);
                                                      setStat(() {
                                                        _selectedTime = picked;
                                                        toTime = DateTime(now.year,now.month,now.day,picked.hour,picked.minute);
                                                        timeController2.text = picked.toString();
                                                        _keyTime2.currentState!.validate();
                                                      });
                                                      _formatTime2(picked!);
                                                    }
                                                  },
                                                  controller: timeController2,
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
                                                  key: _keyLocation,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  onChanged: (val){
                                                    _keyLocation.currentState!.validate();
                                                  },
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
                                            text: "Booking For *",
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
                                                  key: _keyReason,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  onChanged: (val){
                                                    _keyReason.currentState!.validate();
                                                  },
                                                  keyboardType: TextInputType.multiline,
                                                  minLines: 1,
                                                  maxLines: null,
                                                  controller: reasonController,
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
                                            text: "Function Name *",
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
                                                  key: _keyTitle,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  onChanged: (val){
                                                    _keyTitle.currentState!.validate();
                                                  },
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
                                            text: "Phone *",
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
                                                  key: _keyPhone,
                                                  validator: (val){
                                                    if(val!.isEmpty) {
                                                      return 'Field is required';
                                                    } else if(val.length != 10){
                                                      return 'number must be 10 digits';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  onEditingComplete: (){
                                                    _keyPhone.currentState!.validate();
                                                  },
                                                  onFieldSubmitted: (val){
                                                    _keyPhone.currentState!.validate();
                                                  },
                                                  inputFormatters: [
                                                    FilteringTextInputFormatter.allow(
                                                        RegExp(r'[0-9]')),
                                                  ],
                                                  maxLength: 10,
                                                  controller: phoneController,
                                                  decoration: InputDecoration(
                                                    counterText: "",
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
                                            text: "Adddress *",
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
                                                  key: _keyAddress,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  onChanged: (val){
                                                    _keyAddress.currentState!.validate();
                                                  },
                                                  keyboardType: TextInputType.multiline,
                                                  minLines: 1,
                                                  maxLines: null,
                                                  controller: addressController,
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
                                  SizedBox(height: 20),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
              );
            }
        );
      },
    );
  }

  showCalenderPopup(List<DocumentSnapshot> bookinsList){
    List<Meeting> bookings = [];
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    bookinsList.forEach((element) {
      bookings.add(
        Meeting(
          element.get("title"),
          Timestamp.fromMillisecondsSinceEpoch(element.get("fromTime")).toDate(),
          Timestamp.fromMillisecondsSinceEpoch(element.get("toTime")).toDate(),
          Colors.grey,
          false,
        )
      );
    });
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
            builder: (context, setStat) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                content: Material(
                  elevation: 7,
                  borderRadius: BorderRadius.circular(12),
                  shadowColor:  Constants().primaryAppColor.withOpacity(0.20),
                  child: Container(
                      width: 515,
                      height: 420,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:Border.all(color: Constants().primaryAppColor.withOpacity(0.20))
                      ),
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top:20.0,left: 15),
                            child: Text("Events Calendar",style: GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: 18),),
                          ),
                          Container(
                            width: 500,
                            height: 370,
                            child: SfCalendar(
                              onTap: (val){
                                // setState(() {
                                //   selectedDateController.text = DateFormat('dd-MM-yyyy').format(val.date!);
                                // });
                              },
                              onLongPress: (val){
                                // setState(() {
                                //   selectedDateController.text = DateFormat('dd-MM-yyyy').format(val.date!);
                                // });
                                // showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return BouncingDraggableDialog(
                                //         width: 600,
                                //         height: 350,
                                //         content: eventspop(val.date),
                                //       );
                                //     });
                              },
                              view: CalendarView.month,
                              allowDragAndDrop: true,
                              dataSource: MeetingDataSource(bookings),
                              monthViewSettings: MonthViewSettings(showAgenda: true),
                              appointmentTextStyle: TextStyle(color: Constants().secondaryAppColor),
                              blackoutDatesTextStyle: TextStyle(color: Constants().secondaryAppColor),
                              todayTextStyle: TextStyle(color: Constants().secondaryAppColor),
                              todayHighlightColor: Constants().primaryAppColor,
                              // appointmentBuilder: (ctx, details){
                              //   return ListView.builder(
                              //     itemCount: bookings.length,
                              //     itemBuilder: (context,i) {
                              //       var data = bookings[i];
                              //       return ListTile(
                              //         title: Text(
                              //           data.eventName,
                              //           style: TextStyle(
                              //
                              //           ),
                              //         ),
                              //         subtitle: Text(
                              //           DateFormat('dd-MM-yyyy').format(data.from),
                              //           style: TextStyle(
                              //
                              //           ),
                              //         ),
                              //       );
                              //     }
                              //   );
                              // },
                            ),
                          )

                        ],
                      )
                  ),
                ),
              );
            }
        );
      },
    );
  }

  viewPopup(DocumentSnapshot snap) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: size.width * 0.5,
            margin: EdgeInsets.symmetric(
                horizontal: width/68.3,
                vertical: height/32.55
            ),
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
              children: [
                SizedBox(
                  height: size.height * 0.1,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          snap.get("title"),
                          style: GoogleFonts.openSans(
                            fontSize: width / 68.3,
                            fontWeight: FontWeight.bold,
                            color: Constants().subHeadingColor,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 227.66),
                              child: Center(
                                child: KText(
                                  text: "CLOSE",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/85.375,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width/136.6, vertical: height/43.4),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: snap.get("reason") + " Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text:
                                        snap.get("title"),
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      Row(
                                        children: [
                                          KText(
                                            text: snap.get("date")+" ",
                                            style: TextStyle(fontSize: width/97.571),
                                          ),
                                          Visibility(
                                            visible: snap.get("date") != "",
                                            child: KText(
                                              text: "/ "+snap.get("toDate"),
                                              style: TextStyle(fontSize: width/97.571),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Time",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      Row(
                                        children: [
                                          KText(
                                            text: snap.get("fromTimeStr")+" ",
                                            style: TextStyle(fontSize: width/97.571),
                                          ),
                                          Visibility(
                                            visible: snap.get("toTimeStr") != "",
                                            child: KText(
                                              text: "- "+snap.get("toTimeStr"),
                                              style: TextStyle(fontSize: width/97.571),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Location",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: snap.get("location"),
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Phone",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: snap.get("phone"),
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      SizedBox(
                                        width: size.width*0.3,
                                        child: Text(
                                          snap.get("address"),
                                          style: TextStyle(fontSize: width/97.571),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
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

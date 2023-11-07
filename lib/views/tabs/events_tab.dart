import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:church_management_admin/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../services/events_firecrud.dart';
import 'package:intl/intl.dart';
import '../../widgets/kText.dart';
import '../prints/event_print.dart';

class EventsTab extends StatefulWidget {
  EventsTab({super.key});

  @override
  State<EventsTab> createState() => _EventsTabState();
}

class _EventsTabState extends State<EventsTab>
    with SingleTickerProviderStateMixin {
  late AnimationController lottieController;
  TextEditingController dateController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DateTime? dateRangeStart;
  DateTime? dateRangeEnd;
  bool isFiltered= false;

  File? profileImage;
  var uploadedImage;
  String? selectedImg;

  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  String currentTab = 'View';

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1900, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      setState(() {
        dateController.text = formatter.format(picked);
        selectedDate = picked;
      });
    }
  }

  selectImage() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      FileReader reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          profileImage = file;
        });
        setState(() {
          uploadedImage = reader.result;
          selectedImg = null;
        });
      });
      setState(() {});
    });
  }

  setDateTime() async {
    setState(() {
      dateController.text = formatter.format(selectedDate);
      timeController.text = DateFormat('hh:mm a').format(DateTime.now());
    });
  }

  @override
  void initState() {
    setDateTime();
    lottieController = AnimationController(vsync: this);
    lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        lottieController.reset();
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                KText(
                  text: "EVENTS",
                  style: GoogleFonts.openSans(
                      fontSize: width/52.538,
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
                        //clearTextControllers();
                      }
                    },
                    child: Container(
                      height:height/18.6,
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
                            text: currentTab.toUpperCase() == "VIEW" ? "Add Event" : "View Events",
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
                          text: "ADD NEW EVENT",
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
                              Response response = await EventsFireCrud.addEvent(
                                title: titleController.text,
                                time: timeController.text,
                                location: locationController.text,
                                image: profileImage,
                                description: descriptionController.text,
                                date: dateController.text,
                              );
                              if (response.code == 200) {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.success,
                                    text: "Event created successfully!",
                                    width: size.width * 0.4,
                                    backgroundColor: Constants()
                                        .primaryAppColor
                                        .withOpacity(0.8));
                                setState(() {
                                  locationController.text = "";
                                  descriptionController.text = "";
                                  uploadedImage = null;
                                  profileImage = null;
                                  currentTab = 'View';
                                });
                              } else {
                                CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.error,
                                    text: "Failed to Create Event!",
                                    width: size.width * 0.4,
                                    backgroundColor: Constants()
                                        .primaryAppColor
                                        .withOpacity(0.8));
                              }
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
                        )
                      ],
                    ),
                  ),
                ),
                Container(
                  height: size.height * 0.55,
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Color(0xffF7FAFC),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      )),
                  padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                      width: size.width * 0.36,
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
                                      width: size.width * 0.36,
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
                      InkWell(
                        onTap: selectImage,
                        child: Container(
                          height: size.height * 0.2,
                          width: size.width * 0.10,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: uploadedImage != null
                                  ? DecorationImage(
                                      fit: BoxFit.fill,
                                      image: MemoryImage(
                                        Uint8List.fromList(
                                          base64Decode(
                                              uploadedImage!.split(',').last),
                                        ),
                                      ),
                                    )
                                  : null),
                          child: uploadedImage != null
                              ? null
                              : Icon(
                                  Icons.add_photo_alternate,
                                  size: size.height * 0.2,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
              : currentTab.toUpperCase() == "VIEW" ?
          dateRangeStart != null ?
          StreamBuilder(
            stream: EventsFireCrud.fetchEventsWithFilter(dateRangeStart!,dateRangeEnd!),
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return Container();
              } else if (snapshot.hasData) {
                List<EventsModel> events = snapshot.data!;
                return Container(
                  width:width/1.2418,
                  margin: EdgeInsets.symmetric(horizontal: width/68.3,
                      vertical: height/32.55),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: width/68.3, vertical: height/81.375),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: "Event Records (${events.length})",
                                style: GoogleFonts.openSans(
                                  fontSize: width/68.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    isFiltered = false;
                                    dateRangeStart = null;
                                    dateRangeEnd = null;
                                  });
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
                                        text: "Clear Filter",
                                        style: GoogleFonts.openSans(
                                         fontSize: width/97.571,
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
                      Container(
                        height: size.height * 0.7,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                   var data = await generateEventPdf(PdfPageFormat.letter, events,false);
                                   print(data);
                                  },
                                  child: Container(
                                    height:height/18.6,
                                    decoration: BoxDecoration(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal:width/227.66),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.print,
                                                color: Colors.white),
                                            KText(
                                              text: "PRINT",
                                              style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize:width/105.07,
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
                                    copyToClipBoard(events);
                                  },
                                  child: Container(
                                    height:height/18.6,
                                    decoration: BoxDecoration(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal:width/227.66),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.copy,
                                                color: Colors.white),
                                            KText(
                                              text: "COPY",
                                              style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize:width/105.07,
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
                                   var data = await generateEventPdf(PdfPageFormat.a4, events,true);
                                   savePdfToFile(data);
                                  },
                                  child: Container(
                                    height:height/18.6,
                                    decoration: BoxDecoration(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal:width/227.66),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.picture_as_pdf,
                                                color: Colors.white),
                                            KText(
                                              text: "PDF",
                                              style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize:width/105.07,
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
                                    convertToCsv(events);
                                  },
                                  child: Container(
                                    height:height/18.6,
                                    decoration: BoxDecoration(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal:width/227.66),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.file_copy_rounded,
                                                color: Colors.white),
                                            KText(
                                              text: "CSV",
                                              style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize:width/105.07,
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
                            ),
                            SizedBox(height: height/21.7),
                            SizedBox(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width/455.33,vertical: height/217),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width:width/18.075,
                                      child: Center(
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/13.66,
                                      child: Center(
                                        child: KText(
                                          text: "Event",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/13.66,
                                      child: Center(
                                        child: KText(
                                          text: "Date",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/27.32,
                                      child: Center(
                                        child: KText(
                                          text: "Views",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/9.106,
                                      child: Center(
                                        child: KText(
                                          text: "Registered Users",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/10.507,
                                      child: Center(
                                        child: KText(
                                          text: "Location",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/7.189,
                                      child: Center(
                                        child: KText(
                                          text: "Description",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/7.588,
                                      child: Center(
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: events.length,
                                itemBuilder: (ctx, i) {
                                  return Container(
                                    height: height/10.850,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
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
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: height/130.2, horizontal: 0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width:width/18.075,
                                            child: Center(
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/13.66,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(events[i].imgUrl!),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/13.66,
                                            child: Center(
                                              child: KText(
                                                text: events[i].date!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/27.32,
                                            child: Center(
                                              child: KText(
                                                text: events[i].views!.length.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: width/9.106,
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  KText(
                                                    text: events[i].registeredUsers!.length.toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(width: 10),
                                                  InkWell(
                                                    onTap: (){
                                                      viewRegisteredUsers(events[i].registeredUsers!);
                                                    },
                                                    child: Icon(
                                                      Icons.remove_red_eye,
                                                    ),
                                                  ),
                                                ],
                                              )
                                          ),
                                          SizedBox(
                                            width:width/10.507,
                                            child: Center(
                                              child: KText(
                                                text: events[i].location!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/7.189,
                                            child: Center(
                                              child: KText(
                                                text: events[i].description!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:width/7.588,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      viewPopup(events[i]);
                                                    },
                                                    child: Container(
                                                      height:height/26.04,
                                                      decoration:
                                                      BoxDecoration(
                                                        color:
                                                        Color(0xff2baae4),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Colors.black26,
                                                            offset:
                                                            Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets
                                                            .symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                color: Colors
                                                                    .white,
                                                                size:width/91.06,
                                                              ),
                                                              KText(
                                                                text: "View",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:width/136.6,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width:width/273.2),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        dateController.text =
                                                        events[i].date!;
                                                        titleController.text =
                                                        events[i].title!;
                                                        timeController.text =
                                                        events[i].time!;
                                                        locationController
                                                            .text =
                                                        events[i].location!;
                                                        descriptionController
                                                            .text =
                                                        events[i]
                                                            .description!;
                                                        selectedImg =
                                                            events[i].imgUrl;
                                                      });
                                                      editPopUp(events[i], size);
                                                    },
                                                    child: Container(
                                                      height:height/26.04,
                                                      decoration:
                                                      BoxDecoration(
                                                        color:
                                                        Color(0xffff9700),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Colors.black26,
                                                            offset:
                                                            Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets
                                                            .symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                                size:width/91.06,
                                                              ),
                                                              KText(
                                                                text: "Edit",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:width/136.6,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width:width/273.2),
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType
                                                              .info,
                                                          text:
                                                          "${events[i].description} will be deleted",
                                                          title:
                                                          "Delete this Record?",
                                                          width: size.width *
                                                              0.4,
                                                          backgroundColor:
                                                          Constants()
                                                              .primaryAppColor
                                                              .withOpacity(
                                                              0.8),
                                                          showCancelBtn: true,
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                          onConfirmBtnTap:
                                                              () async {
                                                            Response res =
                                                            await EventsFireCrud
                                                                .deleteRecord(
                                                                id: events[i]
                                                                    .id!);
                                                          });
                                                    },
                                                    child: Container(
                                                      height:height/26.04,
                                                      decoration:
                                                      BoxDecoration(
                                                        color:
                                                        Color(0xfff44236),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Colors.black26,
                                                            offset:
                                                            Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets
                                                            .symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size:width/91.06,
                                                              ),
                                                              KText(
                                                                text: "Delete",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:width/136.6,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
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
          ) :
          StreamBuilder(
            stream: EventsFireCrud.fetchEvents(),
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return Container();
              } else if (snapshot.hasData) {
                List<EventsModel> events = snapshot.data!;
                return Container(
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
                          padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: "Event Records (${events.length})",
                                style: GoogleFonts.openSans(
                                  fontSize: width/68.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
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
                                        text: " Filter by Date ",
                                        style: GoogleFonts.openSans(
                                         fontSize: width/97.571,
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
                      Container(
                        height: size.height * 0.7,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    var data = await generateEventPdf(PdfPageFormat.letter, events,false);
                                  },
                                  child: Container(
                                    height:height/18.6,
                                    decoration: BoxDecoration(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal:width/227.66),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.print,
                                                color: Colors.white),
                                            KText(
                                              text: "PRINT",
                                              style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize:width/105.07,
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
                                    copyToClipBoard(events);
                                  },
                                  child: Container(
                                    height:height/18.6,
                                    decoration: BoxDecoration(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal:width/227.66),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.copy,
                                                color: Colors.white),
                                            KText(
                                              text: "COPY",
                                              style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize:width/105.07,
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
                                    //convertToPdf(events);
                                   var data = await generateEventPdf(PdfPageFormat.a4, events,true);
                                   savePdfToFile(data);
                                  },
                                  child: Container(
                                    height:height/18.6,
                                    decoration: BoxDecoration(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal:width/227.66),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.picture_as_pdf,
                                                color: Colors.white),
                                            KText(
                                              text: "PDF",
                                              style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize:width/105.07,
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
                                    convertToCsv(events);
                                  },
                                  child: Container(
                                    height:height/18.6,
                                    decoration: BoxDecoration(
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal:width/227.66),
                                      child: Center(
                                        child: Row(
                                          children: [
                                            Icon(Icons.file_copy_rounded,
                                                color: Colors.white),
                                            KText(
                                              text: "CSV",
                                              style: GoogleFonts.openSans(
                                                color: Colors.white,
                                                fontSize:width/105.07,
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
                            ),
                            SizedBox(height: height/21.7),
                            SizedBox(
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width/455.33,vertical: height/217),
                                child: Row(
                                  children: [
                                    SizedBox(
                                     width:width/18.075,
                                      child: Center(
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/13.66,
                                      child: Center(
                                        child: KText(
                                          text: "Event",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/13.66,
                                      child: Center(
                                        child: KText(
                                          text: "Date",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/27.32,
                                      child: Center(
                                        child: KText(
                                          text: "Views",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/9.106,
                                      child: Center(
                                        child: KText(
                                          text: "Registered Users",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/10.507,
                                      child: Center(
                                        child: KText(
                                          text: "Location",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/7.189,
                                      child: Center(
                                        child: KText(
                                          text: "Description",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/7.588,
                                      child: Center(
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                itemCount: events.length,
                                itemBuilder: (ctx, i) {
                                  return Container(
                                    height: height/10.850,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
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
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: height/130.2, horizontal: 0),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                           width:width/18.075,
                                            child: Center(
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/13.66,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                CircleAvatar(
                                                  backgroundImage: NetworkImage(events[i].imgUrl!),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/13.66,
                                            child: Center(
                                              child: KText(
                                                text: events[i].date!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/27.32,
                                            child: Center(
                                              child: KText(
                                                text: events[i].views!.length.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/9.106,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                KText(
                                                  text: events[i].registeredUsers!.length.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontSize:width/105.07,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                SizedBox(width: 10),
                                                InkWell(
                                                  onTap: (){
                                                    viewRegisteredUsers(events[i].registeredUsers!);
                                                  },
                                                  child: Icon(
                                                    Icons.remove_red_eye,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ),
                                          SizedBox(
                                            width:width/10.507,
                                            child: Center(
                                              child: KText(
                                                text: events[i].location!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/7.189,
                                            child: Center(
                                              child: KText(
                                                text: events[i].description!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:width/7.588,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      viewPopup(events[i]);
                                                    },
                                                    child: Container(
                                                      height:height/26.04,
                                                      decoration:
                                                      BoxDecoration(
                                                        color:
                                                        Color(0xff2baae4),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Colors.black26,
                                                            offset:
                                                            Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets
                                                            .symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                color: Colors
                                                                    .white,
                                                                size:width/91.06,
                                                              ),
                                                              KText(
                                                                text: "View",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:width/136.6,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width:width/273.2),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        dateController.text =
                                                        events[i].date!;
                                                        titleController.text =
                                                        events[i].title!;
                                                        timeController.text =
                                                        events[i].time!;
                                                        locationController
                                                            .text =
                                                        events[i].location!;
                                                        descriptionController
                                                            .text =
                                                        events[i]
                                                            .description!;
                                                        selectedImg =
                                                            events[i].imgUrl;
                                                      });
                                                      editPopUp(events[i], size);
                                                    },
                                                    child: Container(
                                                      height:height/26.04,
                                                      decoration:
                                                      BoxDecoration(
                                                        color:
                                                        Color(0xffff9700),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Colors.black26,
                                                            offset:
                                                            Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets
                                                            .symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                                size:width/91.06,
                                                              ),
                                                              KText(
                                                                text: "Edit",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:width/136.6,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(width:width/273.2),
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType
                                                              .info,
                                                          text:
                                                          "${events[i].description} will be deleted",
                                                          title:
                                                          "Delete this Record?",
                                                          width: size.width *
                                                              0.4,
                                                          backgroundColor:
                                                          Constants()
                                                              .primaryAppColor
                                                              .withOpacity(
                                                              0.8),
                                                          showCancelBtn: true,
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                          onConfirmBtnTap:
                                                              () async {
                                                            Response res =
                                                            await EventsFireCrud
                                                                .deleteRecord(
                                                                id: events[i]
                                                                    .id!);
                                                          });
                                                    },
                                                    child: Container(
                                                      height:height/26.04,
                                                      decoration:
                                                      BoxDecoration(
                                                        color:
                                                        Color(0xfff44236),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Colors.black26,
                                                            offset:
                                                            Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        EdgeInsets
                                                            .symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size:width/91.06,
                                                              ),
                                                              KText(
                                                                text: "Delete",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:width/136.6,
                                                                  fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              )),
                                        ],
                                      ),
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
          ) : Container()
        ],
      )),
    );
  }

  viewPopup(EventsModel event) {
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
            child: Column(
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
                        Text(
                          event.location!,
                          style: GoogleFonts.openSans(
                            fontSize: width/68.3,
                            fontWeight: FontWeight.bold,
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
                              padding:
                                  EdgeInsets.symmetric(horizontal:width/227.66),
                              child: Center(
                                child: KText(
                                  text: "CLOSE",
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
                          Container(
                            width: size.width * 0.5,
                            height: size.height * 0.5,
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                filterQuality: FilterQuality.high,
                                fit: BoxFit.fill,
                                image: NetworkImage(event.imgUrl!),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width/136.6, vertical: height/65.1),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Date",
                                          style: TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      Text(
                                        event.date!,
                                        style: TextStyle(
                                         fontSize: width/97.571
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Time",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      Text(
                                        event.time!,
                                        style: TextStyle(
                                           fontSize: width/97.571
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Location",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      KText(
                                        text: event.location!,
                                        style: TextStyle(
                                           fontSize: width/97.571
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Description",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      KText(
                                        text: event.description!,
                                        style: TextStyle(
                                           fontSize: width/97.571
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
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

  viewRegisteredUsers(List<String> regUsers) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    List<cf.DocumentSnapshot> users = [];
    var usersDoc = await cf.FirebaseFirestore.instance.collection('Users').get();
    for(int i = 0; i < regUsers.length; i++){
      for(int j = 0; j < usersDoc.docs.length; j++){
        if(regUsers[i] == usersDoc.docs[j].id){
          users.add(usersDoc.docs[j]);
        }
      }
    }
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
                          text: "Registered Users",
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
                        itemCount: users.length,
                        itemBuilder: (ctx, i){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: height/13.02,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Container(
                                    width: 80,
                                    child: Center(
                                      child: CircleAvatar(
                                        backgroundImage:
                                        NetworkImage(users[i].get("imgUrl")),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    width: 200,
                                    child: Text(
                                      users[i].get("firstName") + " " + users[i].get("lastName")
                                    ),
                                  ),
                                  Container(
                                    width: 250,
                                    child: Text(
                                        users[i].get("phone")
                                    ),
                                  )
                                ],
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

  editPopUp(EventsModel event, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
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
                              text: "EDIT EVENT",
                              style: GoogleFonts.openSans(
                                fontSize: width/68.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (
                                       titleController.text != "" &&
                                        dateController.text != "" &&
                                        timeController.text != "" &&
                                        locationController.text != "") {
                                      Response response = await EventsFireCrud.updateRecord(
                                              EventsModel(
                                                id: event.id,
                                                title: titleController.text,
                                                imgUrl: event.imgUrl,
                                                timestamp: event.timestamp,
                                                views: event.views,
                                                time: timeController.text,
                                                location: locationController.text,
                                                description: descriptionController.text,
                                                date: dateController.text,
                                                registeredUsers: event.registeredUsers,
                                              ),
                                              profileImage,
                                              event.imgUrl ?? "");
                                      if (response.code == 200) {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: "Event updated successfully!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                        setState(() {
                                          locationController.text = "";
                                          descriptionController.text = "";
                                          titleController.text = "";
                                          uploadedImage = null;
                                          profileImage = null;
                                        });
                                        Navigator.pop(context);
                                        Navigator.pop(context);
                                      } else {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: "Failed to update Event!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                        Navigator.pop(context);
                                      }
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.warning,
                                          text: "Please fill the required fields",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
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
                                          text: "UPDATE",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/85.375,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: width/136.6),
                                InkWell(
                                  onTap: () async {
                                    setState(() {
                                      locationController.text = "";
                                      descriptionController.text = "";
                                      titleController.text = "";
                                      uploadedImage = null;
                                      profileImage = null;
                                    });
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
                                      padding:
                                          EdgeInsets.symmetric(horizontal:width/227.66),
                                      child: Center(
                                        child: KText(
                                          text: "CANCEL",
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
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xffF7FAFC),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                            height: height/16.275,
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
                                            height: height/16.275,
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
                                            height: height/16.275,
                                            width: width/6.830,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                              child: TextFormField(
                                                controller: locationController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Select Type",
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
                                            width: size.width * 0.36,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                              child: TextFormField(
                                                keyboardType:
                                                TextInputType.multiline,
                                                minLines: 1,
                                                maxLines: 5,
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
                                            width: size.width * 0.36,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                              child: TextFormField(
                                                keyboardType:
                                                    TextInputType.multiline,
                                                minLines: 1,
                                                maxLines: 5,
                                                controller: descriptionController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: "Lucky",
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
                            InkWell(
                              onTap: selectImage,
                              child: Container(
                                height: size.height * 0.2,
                                width: size.width * 0.10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: selectedImg != null
                                        ? DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(selectedImg!))
                                        : uploadedImage != null
                                            ? DecorationImage(
                                                fit: BoxFit.fill,
                                                image: MemoryImage(
                                                  Uint8List.fromList(
                                                    base64Decode(uploadedImage!
                                                        .split(',')
                                                        .last),
                                                  ),
                                                ),
                                              )
                                            : null),
                                child: (selectedImg != null || selectedImg != '')
                                    ? null
                                    : Icon(
                                        Icons.add_photo_alternate,
                                        size: size.height * 0.2,
                                      ),
                              ),
                            ),
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

  convertToCsv(List<EventsModel> events) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Date");
    row.add("Time");
    row.add("Location");
    row.add("Description");
    rows.add(row);
    for (int i = 0; i < events.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(events[i].date!);
      row.add(events[i].time!);
      row.add(events[i].location!);
      row.add(events[i].description!);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows);
    saveCsvToFile(csv);
  }

  convertToPdf(List<EventsModel> events) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Date");
    row.add("Time");
    row.add("Location");
    row.add("Description");
    rows.add(row);
    for (int i = 0; i < events.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(events[i].date!);
      row.add(events[i].time!);
      row.add(events[i].location!);
      row.add(events[i].description!);
      rows.add(row);
    }
    String pdf = ListToCsvConverter().convert(rows);
    savePdfToFile(pdf);
  }

  void saveCsvToFile(csvString) async {
    final blob = Blob([Uint8List.fromList(csvString.codeUnits)]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "data.csv")
      ..click();
    Url.revokeObjectUrl(url);
  }

  void savePdfToFile(data) async {
    final blob = Blob([data],'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "events.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<EventsModel> events) async  {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Date");
    row.add("    ");
    row.add("Time");
    row.add("    ");
    row.add("Location");
    row.add("    ");
    row.add("Description");
    rows.add(row);
    for (int i = 0; i < events.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add(events[i].date);
      row.add("       ");
      row.add(events[i].time);
      row.add("       ");
      row.add(events[i].location);
      row.add("       ");
      row.add(events[i].description);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows,fieldDelimiter: null,eol: null,textEndDelimiter: null,delimitAllFields: false,textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",","")));
  }

  filterPopUp() {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                              padding: EdgeInsets.symmetric(horizontal: width/68.3),
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
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width:width/15.177,
                                    child: KText(
                                      text: "Start Date",
                                      style: GoogleFonts.openSans(
                                       fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:width/85.375),
                                  Container(
                                    height: height/16.275,
                                    width:width/15.177,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
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
                                        hintStyle: TextStyle(color: Color(0xff00A99D)),
                                        hintText: dateRangeStart != null ? "${dateRangeStart!.day}/${dateRangeStart!.month}/${dateRangeStart!.year}" : "",
                                        border: InputBorder.none,
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000));
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
                                    width:width/15.177,
                                    child: KText(
                                      text: "End Date",
                                      style: GoogleFonts.openSans(
                                       fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:width/85.375),
                                  Container(
                                    height: height/16.275,
                                    width:width/15.177,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
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
                                        hintStyle: TextStyle(color: Color(0xff00A99D)),
                                        hintText: dateRangeEnd != null ? "${dateRangeEnd!.day}/${dateRangeEnd!.month}/${dateRangeEnd!.year}" : "",
                                        border: InputBorder.none,
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000));
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
                                  SizedBox(width:width/273.2),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context,true);
                                    },
                                    child: Container(
                                      height: height/16.275,
                                      decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
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
}

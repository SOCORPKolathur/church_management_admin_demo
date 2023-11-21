import 'dart:html';
import 'dart:typed_data';
import 'package:church_management_admin/services/testimonial_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../models/testimonial_model.dart';
import '../../widgets/kText.dart';
import '../prints/testimonial_print.dart';

class TestimonialsTab extends StatefulWidget {
  const TestimonialsTab({super.key});

  @override
  State<TestimonialsTab> createState() => _TestimonialsTabState();
}

class _TestimonialsTabState extends State<TestimonialsTab> with SingleTickerProviderStateMixin {

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  DateTime? dateRangeStart;
  DateTime? dateRangeEnd;
  bool isFiltered= false;

  String currentTab = 'View';

  TabController? _tabController;
  int currentTabIndex = 0;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      final DateFormat formatter = DateFormat('dd-MM-yyyy');
      setState(() {
        dateController.text = formatter.format(picked);
        selectedDate = picked;
      });
    }
  }

  setDateTime() async {
    setState(() {
      dateController.text = formatter.format(selectedDate);
      timeController.text = DateFormat('hh:mm a').format(DateTime.now());
    });
  }

  final titleFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    setDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.all(width/170.75),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(width/170.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "TESTIMONIALS",
                    style: GoogleFonts.openSans(
                      fontSize: size.width/52.53846153846154,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
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
                        }
                      },
                      child: Container(
                        height: height/18.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(width/170.75),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width/227.6666666666667),
                          child: Center(
                            child: KText(
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Testimonial" : "View Testimonial",
                              style: GoogleFonts.openSans(
                                fontSize: width/105.0769230769231,
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
              width: width/1.241818181818182,
              margin: EdgeInsets.all(width/68.3),
              decoration: BoxDecoration(
                color: Constants().primaryAppColor,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(1, 2),
                    blurRadius: 3,
                  ),
                ],
                borderRadius: BorderRadius.circular(width/136.6),
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
                            text: "ADD REQUEST",
                            style: GoogleFonts.openSans(
                              fontSize: width/68.3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              if (timeController.text != "" && dateController.text != "" && titleController.text != "") {
                                Response response =
                                await TestimonialFireCrud.addTestimonial(
                                  date: dateController.text,
                                  time: timeController.text,
                                  title: titleController.text,
                                  description: descriptionController.text,
                                );
                                if (response.code == 200) {
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.success,
                                      text: "Testimonial created successfully!",
                                      width: size.width * 0.4,
                                      backgroundColor: Constants()
                                          .primaryAppColor
                                          .withOpacity(0.8));
                                  setState(() {
                                    currentTab = 'View';
                                    titleController.text = "";
                                    descriptionController.text = "";
                                  });
                                } else {
                                  CoolAlert.show(
                                      context: context,
                                      type: CoolAlertType.error,
                                      text: "Failed to Create Testimonial!",
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
                                borderRadius: BorderRadius.circular(width/170.75),
                                boxShadow: const [
                                  BoxShadow(
                                    color: Colors.black26,
                                    offset: Offset(1, 2),
                                    blurRadius: 3,
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: width/227.6666666666667),
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
                        color: const Color(0xffF7FAFC),
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(width/136.6),
                          bottomRight: Radius.circular(width/136.6),
                        )),
                    padding: EdgeInsets.all(width/68.3),
                    child: Column(
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
                                    fontSize: width/97.57142857142857,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: height/108.5),
                                Material(
                                  borderRadius: BorderRadius.circular(width/273.2),
                                  color: Colors.white,
                                  elevation: 10,
                                  child: SizedBox(
                                    height: height/16.275,
                                    width: width/9.106666666666667,
                                    child: Padding(
                                      padding: EdgeInsets.all(width/170.75),
                                      child: TextFormField(
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
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
                                    fontSize: width/97.57142857142857,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: height/108.5),
                                Material(
                                  borderRadius: BorderRadius.circular(width/273.2),
                                  color: Colors.white,
                                  elevation: 10,
                                  child: SizedBox(
                                    height: height/16.275,
                                    width: width/9.106666666666667,
                                    child: Padding(
                                      padding: EdgeInsets.all(width/170.75),
                                      child: TextFormField(
                                        onTap: (){
                                          _selectTime(context);
                                        },
                                        controller: timeController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: GoogleFonts.openSans(
                                            fontSize: width/97.57142857142857,
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
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text: "Title *",
                              style: GoogleFonts.openSans(
                                fontSize: width/97.5714285714285,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: height/108.5),
                            Material(
                              borderRadius: BorderRadius.circular(width/273.2),
                              color: Colors.white,
                              elevation: 10,
                              child: SizedBox(
                                height: height/13.02,
                                width: width/5.464,
                                child: Padding(
                                  padding: EdgeInsets.all(width/170.75),
                                  child: TextFormField(
                                    focusNode: titleFocusNode,
                                    autofocus: true,
                                    onEditingComplete: (){
                                      FocusScope.of(context).requestFocus(descriptionFocusNode);
                                    },
                                    onFieldSubmitted: (val){
                                      FocusScope.of(context).requestFocus(descriptionFocusNode);
                                    },
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: height/130.2),
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.openSans(
                                        fontSize: width/97.57142857142857,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
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
                                    fontSize: width/97.57142857142857,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: height/108.5),
                                Material(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.white,
                                  elevation: 10,
                                  child: SizedBox(
                                    height: height/6.51,
                                    width: size.width * 0.36,
                                    child: Padding(
                                      padding: EdgeInsets.all(width/170.75),
                                      child: TextFormField(
                                        focusNode: descriptionFocusNode,
                                        autofocus: true,
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 5,
                                        controller: descriptionController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: GoogleFonts.openSans(
                                            fontSize: width/97.57142857142857,
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
                  ),
                ],
              ),
            )
                : currentTab.toUpperCase() == "VIEW" ? dateRangeStart != null ? StreamBuilder(
              stream: TestimonialFireCrud.fetchTestimonialsWithFilter(dateRangeStart!,dateRangeEnd!),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<TestimonialsModel> pendingTestimonials = [];
                  List<TestimonialsModel> verifiedTestimonials = [];
                  List<TestimonialsModel> unverifiedTestimonials = [];
                  snapshot.data!.forEach((element) {
                    if(element.status!.toLowerCase() == 'verified'){
                      verifiedTestimonials.add(element);
                    }else if(element.status!.toLowerCase() == 'unverified'){
                      unverifiedTestimonials.add(element);
                    }else{
                      pendingTestimonials.add(element);
                    }
                  });
                  return Container(
                    width: width/1.241818181818182,
                    margin: EdgeInsets.all(width/68.3),
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          offset: Offset(1, 2),
                          blurRadius: 3,
                        ),
                      ],
                      borderRadius: BorderRadius.circular(width/136.6),
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
                                  text: "All Testimonials (${verifiedTestimonials.length+pendingTestimonials.length+unverifiedTestimonials.length})",
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
                                      borderRadius: BorderRadius.circular(width/170.75),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: width/227.6666666666667),
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
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.7,
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
                                      generateTestimonialPdf(PdfPageFormat.letter, currentTabIndex == 0 ? pendingTestimonials : currentTabIndex == 1 ? verifiedTestimonials : unverifiedTestimonials,false);
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
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
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
                                      copyToClipBoard(currentTabIndex == 0 ? pendingTestimonials : currentTabIndex == 1 ? verifiedTestimonials : unverifiedTestimonials);
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
                                    onTap: ()  async {
                                      var data = await generateTestimonialPdf(PdfPageFormat.letter, currentTabIndex == 0 ? pendingTestimonials : currentTabIndex == 1 ? verifiedTestimonials : unverifiedTestimonials,true);
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
                                      convertToCsv(currentTabIndex == 0 ? pendingTestimonials : currentTabIndex == 1 ? verifiedTestimonials : unverifiedTestimonials);
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
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
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
                                ],
                              ),
                              SizedBox(height: height/21.7),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                height: height/10.85,
                                width: double.infinity,
                                child: TabBar(
                                  onTap: (int index) {
                                    setState(() {
                                      currentTabIndex = index;
                                    });
                                  },
                                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                  splashBorderRadius: BorderRadius.circular(8),
                                  automaticIndicatorColorAdjustment: true,
                                  dividerColor: Colors.transparent,
                                  controller: _tabController,
                                  indicator: BoxDecoration(
                                    color: Constants().primaryAppColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelColor: Colors.black,
                                  tabs: [
                                    Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "Pending Testimonials",
                                          style: GoogleFonts.openSans(
                                            color: currentTabIndex == 0
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: width/97.57142857142857,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "Verified Testimonials",
                                          style: GoogleFonts.openSans(
                                            color: currentTabIndex == 1
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: width/97.57142857142857,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "Denied Testimonials",
                                          style: GoogleFonts.openSans(
                                            color: currentTabIndex == 2
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: width/97.57142857142857,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height/21.7),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        width: width/6.83,
                                        child: KText(
                                          text: "Title",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/6.83,
                                        child: KText(
                                          text: "Date",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/5.464,
                                        child: KText(
                                          text: "Description",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/5.464,
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
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: pendingTestimonials.length,
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
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
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
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/6.83,
                                                    child: KText(
                                                      text: pendingTestimonials[i].title!,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/6.83,
                                                    child: KText(
                                                      text: pendingTestimonials[i].date!,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/5.464,
                                                    child: KText(
                                                      text: pendingTestimonials[i].description!,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: width/5.464,
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              cf.FirebaseFirestore.instance.collection('Testimonials').doc(pendingTestimonials[i].id).update({
                                                                "status" : "verified"
                                                              });
                                                              CoolAlert.show(
                                                                context: context,
                                                                type: CoolAlertType.success,
                                                                title: "Testimonial verified Successfully",
                                                                width: size.width * 0.4,
                                                                backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                              );
                                                              // setState(() {
                                                              //   titleController.text = pendingPrayers[i].title!;
                                                              //   descriptionController.text = pendingPrayers[i].description!;
                                                              // });
                                                              // editPopUp(pendingPrayers[i],size);
                                                            },
                                                            child: Container(
                                                              height: height/26.04,
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
                                                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Icon(
                                                                        Icons.done,
                                                                        color: Colors.white,
                                                                        size: width/91.06666666666667,
                                                                      ),
                                                                      KText(
                                                                        text: "Verify",
                                                                        style: GoogleFonts.openSans(
                                                                          color: Colors.white,
                                                                          fontSize: width/136.6,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: width/273.2),
                                                          InkWell(
                                                            onTap: () {
                                                              cf.FirebaseFirestore.instance.collection('Testimonials').doc(pendingTestimonials[i].id).update({
                                                                "status" : "unverified"
                                                              });
                                                              CoolAlert.show(
                                                                context: context,
                                                                type: CoolAlertType.success,
                                                                title: "Testimonials Unverified Successfully",
                                                                width: size.width * 0.4,
                                                                backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                              );
                                                              // CoolAlert.show(
                                                              //     context: context,
                                                              //     type: CoolAlertType.info,
                                                              //     text: "${pendingPrayers[i].title} will be deleted",
                                                              //     title: "Delete this Record?",
                                                              //     width: size.width * 0.4,
                                                              //     backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                              //     showCancelBtn: true,
                                                              //     cancelBtnText: 'Cancel',
                                                              //     cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                              //     onConfirmBtnTap: () async {
                                                              //       Response res = await PrayersFireCrud.deleteRecord(id: pendingPrayers[i].id!);
                                                              //     }
                                                              // );
                                                            },
                                                            child: Container(
                                                              height: height/26.04,
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xfff44236),
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
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Icon(
                                                                        Icons.cancel_outlined,
                                                                        color: Colors.white,
                                                                        size: width/91.06666666666667,
                                                                      ),
                                                                      KText(
                                                                        text: "Unverifiy",
                                                                        style: GoogleFonts.openSans(
                                                                          color: Colors.white,
                                                                          fontSize: width/136.6,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: verifiedTestimonials.length,
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
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
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
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/6.83,
                                                    child: KText(
                                                      text: verifiedTestimonials[i].title!,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/6.83,
                                                    child: KText(
                                                      text: verifiedTestimonials[i].date!,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/5.464,
                                                    child: KText(
                                                      text: verifiedTestimonials[i].description!,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: width/5.464,
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                titleController.text = verifiedTestimonials[i].title!;
                                                                descriptionController.text = verifiedTestimonials[i].description!;
                                                              });
                                                              editPopUp(verifiedTestimonials[i],size);
                                                            },
                                                            child: Container(
                                                              height: height/26.04,
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
                                                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Icon(
                                                                        Icons.add,
                                                                        color: Colors.white,
                                                                        size: width/91.06666666666667,
                                                                      ),
                                                                      KText(
                                                                        text: "Edit",
                                                                        style: GoogleFonts.openSans(
                                                                          color: Colors.white,
                                                                          fontSize: width/136.6,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: width/273.2),
                                                          InkWell(
                                                            onTap: () {
                                                              CoolAlert.show(
                                                                  context: context,
                                                                  type: CoolAlertType.info,
                                                                  text: "${verifiedTestimonials[i].title} will be deleted",
                                                                  title: "Delete this Record?",
                                                                  width: size.width * 0.4,
                                                                  backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                                  showCancelBtn: true,
                                                                  cancelBtnText: 'Cancel',
                                                                  cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                                  onConfirmBtnTap: () async {
                                                                    Response res = await TestimonialFireCrud.deleteRecord(id: verifiedTestimonials[i].id!);
                                                                  }
                                                              );
                                                            },
                                                            child: Container(
                                                              height: height/26.04,
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xfff44236),
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
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Icon(
                                                                        Icons.cancel_outlined,
                                                                        color: Colors.white,
                                                                        size: width/91.06666666666667,
                                                                      ),
                                                                      KText(
                                                                        text: "Delete",
                                                                        style: GoogleFonts.openSans(
                                                                          color: Colors.white,
                                                                          fontSize: width/136.6,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                    Expanded(
                                      child: ListView.builder(
                                        itemCount: unverifiedTestimonials.length,
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
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
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
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/6.83,
                                                    child: KText(
                                                      text: unverifiedTestimonials[i].title!,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/6.83,
                                                    child: KText(
                                                      text: unverifiedTestimonials[i].date!,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/5.464,
                                                    child: KText(
                                                      text: unverifiedTestimonials[i].description!,
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: width/5.464,
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                titleController.text = unverifiedTestimonials[i].title!;
                                                                descriptionController.text = unverifiedTestimonials[i].description!;
                                                              });
                                                              editPopUp(unverifiedTestimonials[i],size);
                                                            },
                                                            child: Container(
                                                              height: height/26.04,
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
                                                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Icon(
                                                                        Icons.add,
                                                                        color: Colors.white,
                                                                        size: width/91.06666666666667,
                                                                      ),
                                                                      KText(
                                                                        text: "Edit",
                                                                        style: GoogleFonts.openSans(
                                                                          color: Colors.white,
                                                                          fontSize: width/136.6,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(width: width/273.2),
                                                          InkWell(
                                                            onTap: () {
                                                              CoolAlert.show(
                                                                  context: context,
                                                                  type: CoolAlertType.info,
                                                                  text: "${unverifiedTestimonials[i].title} will be deleted",
                                                                  title: "Delete this Record?",
                                                                  width: size.width * 0.4,
                                                                  backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                                  showCancelBtn: true,
                                                                  cancelBtnText: 'Cancel',
                                                                  cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                                  onConfirmBtnTap: () async {
                                                                    Response res = await TestimonialFireCrud.deleteRecord(id: unverifiedTestimonials[i].id!);
                                                                  }
                                                              );
                                                            },
                                                            child: Container(
                                                              height: height/26.04,
                                                              decoration: const BoxDecoration(
                                                                color: Color(0xfff44236),
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
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Icon(
                                                                        Icons.cancel_outlined,
                                                                        color: Colors.white,
                                                                        size: width/91.06666666666667,
                                                                      ),
                                                                      KText(
                                                                        text: "Delete",
                                                                        style: GoogleFonts.openSans(
                                                                          color: Colors.white,
                                                                          fontSize: width/136.6,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ) : StreamBuilder(
              stream: TestimonialFireCrud.fetchTestimonials(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<TestimonialsModel> pendingTestimonials = [];
                  List<TestimonialsModel> verifiedTestimonials = [];
                  List<TestimonialsModel> unverifiedTestimonials = [];
                  snapshot.data!.forEach((element) {
                    if(element.status!.toLowerCase() == 'verified'){
                      verifiedTestimonials.add(element);
                    }else if(element.status!.toLowerCase() == 'unverified'){
                      unverifiedTestimonials.add(element);
                    }else{
                      pendingTestimonials.add(element);
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
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "All Testimonials (${verifiedTestimonials.length+pendingTestimonials.length+unverifiedTestimonials.length})",
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
                                      const EdgeInsets.symmetric(horizontal: 8),
                                      child: Center(
                                        child: KText(
                                          text: " Filter by Date ",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/97.57142857142857,
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
                                      generateTestimonialPdf(PdfPageFormat.letter, currentTabIndex == 0 ? pendingTestimonials : currentTabIndex == 1 ? verifiedTestimonials : unverifiedTestimonials,false);
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
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
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
                                      copyToClipBoard(currentTabIndex == 0 ? pendingTestimonials : currentTabIndex == 1 ? verifiedTestimonials : unverifiedTestimonials);
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
                                    onTap: ()  async {
                                      var data = await generateTestimonialPdf(PdfPageFormat.letter, currentTabIndex == 0 ? pendingTestimonials : currentTabIndex == 1 ? verifiedTestimonials : unverifiedTestimonials,true);
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
                                      convertToCsv(currentTabIndex == 0 ? pendingTestimonials : currentTabIndex == 1 ? verifiedTestimonials : unverifiedTestimonials);
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
                                        padding: const EdgeInsets.symmetric(horizontal: 6),
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
                                ],
                              ),
                              SizedBox(height: height/21.7),
                              Container(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                height: height/10.85,
                                width: double.infinity,
                                child: TabBar(
                                  onTap: (int index) {
                                    setState(() {
                                      currentTabIndex = index;
                                    });
                                  },
                                  labelPadding: const EdgeInsets.symmetric(horizontal: 8),
                                  splashBorderRadius: BorderRadius.circular(8),
                                  automaticIndicatorColorAdjustment: true,
                                  dividerColor: Colors.transparent,
                                  controller: _tabController,
                                  indicator: BoxDecoration(
                                    color: Constants().primaryAppColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  labelColor: Colors.black,
                                  tabs: [
                                    Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "Pending Testimonials",
                                          style: GoogleFonts.openSans(
                                            color: currentTabIndex == 0
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: width/97.57142857142857,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "Verified Testimonials",
                                          style: GoogleFonts.openSans(
                                            color: currentTabIndex == 1
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: width/97.57142857142857,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Tab(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Text(
                                          "Unverified Testimonials",
                                          style: GoogleFonts.openSans(
                                            color: currentTabIndex == 2
                                                ? Colors.white
                                                : Colors.black,
                                            fontSize: width/97.57142857142857,
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height/21.7),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
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
                                        width: width/6.83,
                                        child: KText(
                                          text: "Title",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/6.83,
                                        child: KText(
                                          text: "Date",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/5.464,
                                        child: KText(
                                          text: "Description",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/5.464,
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
                              Expanded(
                                child: TabBarView(
                                  controller: _tabController,
                                  children: [
                                    ListView.builder(
                                      itemCount: pendingTestimonials.length,
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
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
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
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: KText(
                                                    text: pendingTestimonials[i].title!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: KText(
                                                    text: pendingTestimonials[i].date!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/5.464,
                                                  child: KText(
                                                    text: pendingTestimonials[i].description!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: width/5.464,
                                                    child: Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            cf.FirebaseFirestore.instance.collection('Testimonials').doc(pendingTestimonials[i].id).update({
                                                              "status" : "verified"
                                                            });
                                                            CoolAlert.show(
                                                              context: context,
                                                              type: CoolAlertType.success,
                                                              title: "Testimonial verified Successfully",
                                                              width: size.width * 0.4,
                                                              backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            );
                                                            // setState(() {
                                                            //   titleController.text = pendingPrayers[i].title!;
                                                            //   descriptionController.text = pendingPrayers[i].description!;
                                                            // });
                                                            // editPopUp(pendingPrayers[i],size);
                                                          },
                                                          child: Container(
                                                            height: height/26.04,
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
                                                              padding: const EdgeInsets.symmetric(horizontal: 6),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.done,
                                                                      color: Colors.white,
                                                                      size: width/91.06666666666667,
                                                                    ),
                                                                    KText(
                                                                      text: "Verify",
                                                                      style: GoogleFonts.openSans(
                                                                        color: Colors.white,
                                                                        fontSize: width/136.6,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: width/273.2),
                                                        InkWell(
                                                          onTap: () {
                                                            cf.FirebaseFirestore.instance.collection('Testimonials').doc(pendingTestimonials[i].id).update({
                                                              "status" : "unverified"
                                                            });
                                                            CoolAlert.show(
                                                              context: context,
                                                              type: CoolAlertType.success,
                                                              title: "Testimonial unverified Successfully",
                                                              width: size.width * 0.4,
                                                              backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            );
                                                            // CoolAlert.show(
                                                            //     context: context,
                                                            //     type: CoolAlertType.info,
                                                            //     text: "${pendingPrayers[i].title} will be deleted",
                                                            //     title: "Delete this Record?",
                                                            //     width: size.width * 0.4,
                                                            //     backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            //     showCancelBtn: true,
                                                            //     cancelBtnText: 'Cancel',
                                                            //     cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                            //     onConfirmBtnTap: () async {
                                                            //       Response res = await PrayersFireCrud.deleteRecord(id: pendingPrayers[i].id!);
                                                            //     }
                                                            // );
                                                          },
                                                          child: Container(
                                                            height: height/26.04,
                                                            decoration: const BoxDecoration(
                                                              color: Color(0xfff44236),
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
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.cancel_outlined,
                                                                      color: Colors.white,
                                                                      size: width/91.06666666666667,
                                                                    ),
                                                                    KText(
                                                                      text: "Unverify",
                                                                      style: GoogleFonts.openSans(
                                                                        color: Colors.white,
                                                                        fontSize: width/136.6,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListView.builder(
                                      itemCount: verifiedTestimonials.length,
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
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
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
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: KText(
                                                    text: verifiedTestimonials[i].title!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: KText(
                                                    text: verifiedTestimonials[i].date!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/5.464,
                                                  child: KText(
                                                    text: verifiedTestimonials[i].description!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: width/5.464,
                                                    child: Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              titleController.text = verifiedTestimonials[i].title!;
                                                              descriptionController.text = verifiedTestimonials[i].description!;
                                                            });
                                                            editPopUp(verifiedTestimonials[i],size);
                                                          },
                                                          child: Container(
                                                            height: height/26.04,
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
                                                              padding: const EdgeInsets.symmetric(horizontal: 6),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.add,
                                                                      color: Colors.white,
                                                                      size: width/91.06666666666667,
                                                                    ),
                                                                    KText(
                                                                      text: "Edit",
                                                                      style: GoogleFonts.openSans(
                                                                        color: Colors.white,
                                                                        fontSize: width/136.6,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: width/273.2),
                                                        InkWell(
                                                          onTap: () {
                                                            CoolAlert.show(
                                                                context: context,
                                                                type: CoolAlertType.info,
                                                                text: "${verifiedTestimonials[i].title} will be deleted",
                                                                title: "Delete this Record?",
                                                                width: size.width * 0.4,
                                                                backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                                showCancelBtn: true,
                                                                cancelBtnText: 'Cancel',
                                                                cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                                onConfirmBtnTap: () async {
                                                                  Response res = await TestimonialFireCrud.deleteRecord(id: verifiedTestimonials[i].id!);
                                                                }
                                                            );
                                                          },
                                                          child: Container(
                                                            height: height/26.04,
                                                            decoration: const BoxDecoration(
                                                              color: Color(0xfff44236),
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
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.cancel_outlined,
                                                                      color: Colors.white,
                                                                      size: width/91.06666666666667,
                                                                    ),
                                                                    KText(
                                                                      text: "Delete",
                                                                      style: GoogleFonts.openSans(
                                                                        color: Colors.white,
                                                                        fontSize: width/136.6,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    ListView.builder(
                                      itemCount: unverifiedTestimonials.length,
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
                                          child: Padding(
                                            padding: const EdgeInsets.all(5.0),
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
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: KText(
                                                    text: unverifiedTestimonials[i].title!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: KText(
                                                    text: unverifiedTestimonials[i].date!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/5.464,
                                                  child: KText(
                                                    text: unverifiedTestimonials[i].description!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    width: width/5.464,
                                                    child: Row(
                                                      children: [
                                                        InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              titleController.text = unverifiedTestimonials[i].title!;
                                                              descriptionController.text = unverifiedTestimonials[i].description!;
                                                            });
                                                            editPopUp(unverifiedTestimonials[i],size);
                                                          },
                                                          child: Container(
                                                            height: height/26.04,
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
                                                              padding: const EdgeInsets.symmetric(horizontal: 6),
                                                              child: Center(
                                                                child: Row(
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.add,
                                                                      color: Colors.white,
                                                                      size: width/91.06666666666667,
                                                                    ),
                                                                    KText(
                                                                      text: "Edit",
                                                                      style: GoogleFonts.openSans(
                                                                        color: Colors.white,
                                                                        fontSize: width/136.6,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(width: width/273.2),
                                                        InkWell(
                                                          onTap: () {
                                                            CoolAlert.show(
                                                                context: context,
                                                                type: CoolAlertType.info,
                                                                text: "${unverifiedTestimonials[i].title} will be deleted",
                                                                title: "Delete this Record?",
                                                                width: size.width * 0.4,
                                                                backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                                showCancelBtn: true,
                                                                cancelBtnText: 'Cancel',
                                                                cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                                onConfirmBtnTap: () async {
                                                                  Response res = await TestimonialFireCrud.deleteRecord(id: unverifiedTestimonials[i].id!);
                                                                }
                                                            );
                                                          },
                                                          child: Container(
                                                            height: height/26.04,
                                                            decoration: const BoxDecoration(
                                                              color: Color(0xfff44236),
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
                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                  children: [
                                                                    Icon(
                                                                      Icons.cancel_outlined,
                                                                      color: Colors.white,
                                                                      size: width/91.06666666666667,
                                                                    ),
                                                                    KText(
                                                                      text: "Delete",
                                                                      style: GoogleFonts.openSans(
                                                                        color: Colors.white,
                                                                        fontSize: width/136.6,
                                                                        fontWeight: FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ],
                                                    )
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ) : Container(),
            SizedBox(height: size.height * 0.04),
            InkWell(
              onTap: () async {
                final Uri toLaunch =
                Uri.parse("http://ardigitalsolutions.co/");
                if (!await launchUrl(toLaunch,
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch $toLaunch');
                }
              },
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:Border.all(color: Constants().primaryAppColor,)
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                Constants.churchLogo,
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Version 1.0.0.1 @ 2023 by AR Digital Solutions. All Rights Reserved",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }



  editPopUp(TestimonialsModel prayer, Size size) {
    double width = size.width;
    double height = size.height;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: size.height * 0.55,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "EDIT TESTIMONIAL",
                          style: GoogleFonts.openSans(
                            fontSize: width/68.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                if (titleController.text != "") {
                                  Response response =
                                  await TestimonialFireCrud.updateRecord(
                                      TestimonialsModel(
                                        id: prayer.id,
                                        date: prayer.date,
                                        time: prayer.time,
                                        timestamp: prayer.timestamp,
                                        title: titleController.text,
                                        description: descriptionController.text,
                                        phone: prayer.phone,
                                        requestedBy: prayer.requestedBy,
                                        status: prayer.status,
                                      )
                                  );
                                  if (response.code == 200) {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Testimonial updated successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    setState(() {
                                      titleController.text = "";
                                      descriptionController.text = "";
                                    });
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to update Testimonial!",
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
                                      text: "Update",
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
                                  titleController.text = "";
                                  descriptionController.text = "";
                                });
                                Navigator.pop(context);
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
                    decoration: const BoxDecoration(
                      color: Color(0xffF7FAFC),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text: "Title *",
                              style: GoogleFonts.openSans(
                                fontSize: width/97.57142857142857,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Material(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              elevation: 10,
                              child: SizedBox(
                                height: height/13.02,
                                width: width/5.464,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    controller: titleController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.openSans(
                                        fontSize: width/97.57142857142857,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
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
                                    fontSize: width/97.57142857142857,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: height/108.5),
                                Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  elevation: 10,
                                  child: SizedBox(
                                    height: height/6.51,
                                    width: size.width * 0.36,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        keyboardType: TextInputType.multiline,
                                        minLines: 1,
                                        maxLines: 5,
                                        controller: descriptionController,
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintStyle: GoogleFonts.openSans(
                                            fontSize: width/97.57142857142857,
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
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  convertToCsv(List<TestimonialsModel> prayers) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Title");
    row.add("Date");
    row.add("Time");
    row.add("Description");
    rows.add(row);
    for (int i = 0; i < prayers.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(prayers[i].title!);
      row.add(prayers[i].date!);
      row.add(prayers[i].time!);
      row.add(prayers[i].description!);
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);
    saveCsvToFile(csv);
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
      ..setAttribute("download", "testimonial.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<TestimonialsModel> prayers) async  {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Title");
    row.add("    ");
    row.add("Description");
    rows.add(row);
    for (int i = 0; i < prayers.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add(prayers[i].title);
      row.add("       ");
      row.add(prayers[i].description);
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
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(color: Color(0xff00A99D)),
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
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(color: Color(0xff00A99D)),
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

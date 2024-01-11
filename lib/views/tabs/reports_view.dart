import 'package:church_management_admin/constants.dart';
import 'package:lottie/lottie.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sfc;
import 'package:bouncing_draggable_dialog/bouncing_draggable_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';
import '../../widgets/event_calender.dart';
import 'package:intl/intl.dart';
import 'package:show_up_animation/show_up_animation.dart' as an;
import 'package:fl_chart/fl_chart.dart';

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab> {

  late sfc.TooltipBehavior _tooltipBehavior;
  int membersCount = 0;

  TextEditingController selectedDateController = TextEditingController(text: '12-09-2000');
  TextEditingController eventNameController = TextEditingController();

  @override
  void initState() {
    getMemberCount();
    _tooltipBehavior = sfc.TooltipBehavior(enable: true);
    super.initState();
  }

  getMemberCount() async {
    var members = await FirebaseFirestore.instance.collection('Members').get();
    var users = await FirebaseFirestore.instance.collection('Users').get();
    var students = await FirebaseFirestore.instance.collection('Students').get();
    var pastors = await FirebaseFirestore.instance.collection('Pastors').get();
    var churchStaffs = await FirebaseFirestore.instance.collection('ChurchStaff').get();
    var choirMembers = await FirebaseFirestore.instance.collection('Chorus').get();
    setState(() {
      selectedDateController.text = DateFormat('dd-MM-yyyy').format(DateTime.now());
    });
    setState(() {
      membersCount = members.docs.length;
      usersCount = users.docs.length;
      studentsCount = students.docs.length;
      pastorsCount = pastors.docs.length;
      churchStaffsCount = churchStaffs.docs.length;
      choirsCount = choirMembers.docs.length;
      totalUsersCount = usersCount+membersCount+studentsCount+pastorsCount+churchStaffsCount+choirsCount;
    });
  }

  int touchedIndex = 1;
  int totalUsersCount = 0;
  int usersCount = 0;
  int studentsCount = 0;
  int pastorsCount = 0;
  int churchStaffsCount = 0;
  int choirsCount = 0;


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
              child: KText(
                text: "Reports",
                style: GoogleFonts.openSans(
                    fontSize: width/52.53846153846154,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("EventsCalender").snapshots(),
              builder: (ctx, snap){
                if(snap.hasData){
                  List<Meeting> events = [];
                  List<Meeting> selectedEvents = [];
                  snap.data!.docs.forEach((element) {
                    events.add(Meeting(element.get("name"), DateFormat("dd-MM-yyyy").parse( element.get("ondate")), DateFormat("dd-MM-yyyy").parse( element.get("ondate")), Constants().primaryAppColor, false));
                  });
                  events.forEach((event) {
                    if(event.from == DateFormat('dd-MM-yyyy').parse(selectedDateController.text)){
                      selectedEvents.add(event);
                    }
                  });
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top:8.0,right: 12),
                          child: Material(
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
                                          setState(() {
                                            selectedDateController.text = DateFormat('dd-MM-yyyy').format(val.date!);
                                          });
                                        },
                                        onLongPress: (val){
                                          setState(() {
                                            selectedDateController.text = DateFormat('dd-MM-yyyy').format(val.date!);
                                          });
                                          showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return BouncingDraggableDialog(
                                                  width: 600,
                                                  height: 350,
                                                  content: eventspop(val.date),
                                                );
                                              });
                                        },
                                        view: CalendarView.month,
                                        allowDragAndDrop: true,
                                        dataSource: MeetingDataSource(events),
                                        monthViewSettings: MonthViewSettings(showAgenda: true),
                                      ),
                                    )

                                  ],
                                )
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top:8.0,right: 12),
                          child: an.ShowUpAnimation(
                            curve: Curves.fastOutSlowIn,
                            direction: an.Direction.horizontal,
                            delayStart: Duration(milliseconds: 200),
                            child: Material(
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
                                        child: Text("Events For ${selectedDateController.text}",style: GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: 18),),
                                      ),
                                      Expanded(
                                        child: selectedEvents.isEmpty
                                            ? Center(
                                              child: Container(
                                                child: Lottie.asset(
                                                  height: 200,
                                                    "assets/no_event.json",
                                                ),
                                              ),
                                            )
                                            : ListView.builder(
                                          itemCount: selectedEvents.length,
                                          itemBuilder: (ctx, i){
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 60,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.grey.shade100,
                                                  borderRadius: BorderRadius.circular(10),
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    children: [
                                                      Text(
                                                        selectedEvents[i].eventName,
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.w700,
                                                          fontSize: 15
                                                        ),
                                                      ),
                                                      Text(
                                                        "${DateFormat('hh:mm aa').format(selectedEvents[i].from)} - ${DateFormat('hh:mm aa').format(selectedEvents[i].to)}",
                                                        style: GoogleFonts.poppins(
                                                          fontWeight: FontWeight.normal,
                                                          color: Colors.grey,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }return Container();
              },
            ),
            FutureBuilder<MembershipReportModel>(
              future: getMemebershipReports(),
              builder: (ctx, snapshot){
                if(snapshot.hasData){
                  return Material(
                    elevation: 7,
                    borderRadius: BorderRadius.circular(12),
                    shadowColor:  Constants().primaryAppColor.withOpacity(0.20),
                    child: Row(
                      children: [
                        SizedBox(width: 20,),
                        Container(
                            width: 450,
                            child: Container(
                              height: 250,
                              width: 850,
                              child: sfc.SfCartesianChart(
                                  primaryXAxis: sfc.CategoryAxis(),
                                  title: sfc.ChartTitle(
                                      text: 'Membership Reports',
                                      textStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      alignment: sfc.ChartAlignment.near
                                  ),
                                  legend: sfc.Legend(isVisible: true),
                                  tooltipBehavior: _tooltipBehavior,
                                  series: <sfc.LineSeries<SalesData, String>>[
                                    sfc.LineSeries<SalesData, String>(
                                      name: "",
                                      dataSource: snapshot.data!.data,
                                      xValueMapper: (SalesData sales, _) => sales.year,
                                      yValueMapper: (SalesData sales, _) => sales.sales,
                                      // Enable data label
                                      dataLabelSettings: sfc.DataLabelSettings(isVisible: true),
                                      color: Constants().primaryAppColor,
                                      width: 5,
                                      animationDuration: 2000,
                                    )
                                  ]
                              ),
                            )
                        ),
                        Column(
                          children: [
                            SizedBox(height: height/32.85,),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Column(
                                    children: [
                                      CircularPercentIndicator(
                                        circularStrokeCap: CircularStrokeCap.round,
                                        radius: 50.0,
                                        lineWidth: 10.0,
                                        percent:  snapshot.data!.regular,
                                        center: Text("${(snapshot.data!.regular*100).toStringAsFixed(2)} %",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
                                        progressColor: Colors.green,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all( 8.0),
                                        child:  ChoiceChip(

                                          label: Text("  Regular  ",style: TextStyle(color: Colors.white),),


                                          onSelected: (bool selected) {

                                            setState(() {

                                            });
                                          },
                                          selectedColor: Color(0xff53B175),
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: Color(0xff53B175))),
                                          backgroundColor: Colors.white,
                                          labelStyle: TextStyle(color: Colors.black),

                                          elevation: 1.5, selected: true,),

                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:  Column(
                                    children: [
                                      CircularPercentIndicator(
                                        circularStrokeCap: CircularStrokeCap.round,
                                        radius: 50.0,
                                        lineWidth: 10.0,
                                        percent: snapshot.data!.irRegular,
                                        center:  Text("${(snapshot.data!.irRegular*100).toStringAsFixed(2)} %",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
                                        progressColor: Colors.red,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all( 8.0),
                                        child: ChoiceChip(
                                          label: const Text("  Ir-regular  ",style: TextStyle(color: Colors.white),),
                                          onSelected: (bool selected) {
                                            setState(() {

                                            });
                                          },
                                          selectedColor: Colors.red,
                                          shape: StadiumBorder(
                                              side: BorderSide(
                                                  color: Colors.red)),
                                          backgroundColor: Colors.white,
                                          labelStyle: TextStyle(color: Colors.black),

                                          elevation: 1.5, selected: true,),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height/32.85),
                          ],
                        ),
                        SizedBox(width: 20,),
                        Material(
                          elevation: 7,
                          borderRadius: BorderRadius.circular(12),
                          shadowColor: Constants().primaryAppColor,
                          child: Container(
                            height: height/7.3,
                            width: width/5.464,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border:Border.all(color: Constants().primaryAppColor,)
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("Total No.of Members",style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20,
                                ),),
                                ChoiceChip(
                                  label: Text("$membersCount Members",style: TextStyle(color: Colors.white),),
                                  onSelected: (bool selected) {
                                    setState(() {
                                    });
                                  },
                                  selectedColor: Constants().primaryAppColor,
                                  shape: StadiumBorder(
                                      side: BorderSide(
                                        color: Constants().primaryAppColor,)),
                                  backgroundColor: Colors.white,
                                  labelStyle: TextStyle(color: Colors.black),
                                  elevation: 1.5, selected: true,),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }return Row(
                  children: [
                    SizedBox(width: 20,),
                    Container(
                        width: 450,
                        child: Container(
                          height: 250,
                          width: 850,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              sfc.SfCartesianChart(
                                  primaryXAxis: sfc.CategoryAxis(),
                                  title: sfc.ChartTitle(
                                      text: '   Membership Reports',
                                      textStyle: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                      alignment: sfc.ChartAlignment.near
                                  ),
                                  legend: sfc.Legend(isVisible: true),
                                  tooltipBehavior: _tooltipBehavior,
                                  series: <sfc.LineSeries<SalesData, String>>[
                                    sfc.LineSeries<SalesData, String>(
                                      name: "",
                                      dataSource: [],
                                      xValueMapper: (SalesData sales, _) => sales.year,
                                      yValueMapper: (SalesData sales, _) => sales.sales,
                                      // Enable data label
                                      dataLabelSettings: sfc.DataLabelSettings(isVisible: true),
                                      color: Constants().primaryAppColor,
                                      width: 5,
                                      animationDuration: 2000,
                                    )
                                  ]
                              ),
                              CircularProgressIndicator()
                            ],
                          ),
                        )
                    ),
                    Column(
                      children: [
                        SizedBox(height: height/32.85,),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  Column(
                                children: [
                                  CircularPercentIndicator(
                                    circularStrokeCap: CircularStrokeCap.round,
                                    radius: 50.0,
                                    lineWidth: 10.0,
                                    percent:  0.00,
                                    center:  Text("0%",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
                                    progressColor: Colors.green,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all( 8.0),
                                    child:  ChoiceChip(

                                      label: Text("  Regular  ",style: TextStyle(color: Colors.white),),


                                      onSelected: (bool selected) {

                                        setState(() {

                                        });
                                      },
                                      selectedColor: Color(0xff53B175),
                                      shape: StadiumBorder(
                                          side: BorderSide(
                                              color: Color(0xff53B175))),
                                      backgroundColor: Colors.white,
                                      labelStyle: TextStyle(color: Colors.black),

                                      elevation: 1.5, selected: true,),

                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child:  Column(
                                children: [
                                  CircularPercentIndicator(
                                    circularStrokeCap: CircularStrokeCap.round,
                                    radius: 50.0,
                                    lineWidth: 10.0,
                                    percent: 0.00,
                                    center:  Text("00%",style: GoogleFonts.poppins(fontSize: 15,fontWeight: FontWeight.w500)),
                                    progressColor: Colors.red,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all( 8.0),
                                    child: ChoiceChip(

                                      label: const Text("  Ir-regular  ",style: TextStyle(color: Colors.white),),


                                      onSelected: (bool selected) {

                                        setState(() {

                                        });
                                      },
                                      selectedColor: Colors.red,
                                      shape: StadiumBorder(
                                          side: BorderSide(
                                              color: Colors.red)),
                                      backgroundColor: Colors.white,
                                      labelStyle: TextStyle(color: Colors.black),

                                      elevation: 1.5, selected: true,),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height/32.85),

                      ],
                    ),
                    SizedBox(width: 20,),
                    Material(
                      elevation: 7,
                      borderRadius: BorderRadius.circular(12),
                      shadowColor: Constants().primaryAppColor,
                      child: Container(
                        height: height/7.3,
                        width: width/5.464,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border:Border.all(color: Constants().primaryAppColor,),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Total No.of Members",style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                            ),),
                            ChoiceChip(

                              label: Text("0 Members",style: TextStyle(color: Constants().btnTextColor,),),


                              onSelected: (bool selected) {

                                setState(() {

                                });
                              },
                              selectedColor: Constants().primaryAppColor,
                              shape: StadiumBorder(
                                  side: BorderSide(
                                    color: Constants().primaryAppColor,)),
                              backgroundColor: Colors.white,
                              labelStyle: TextStyle(color: Colors.black),

                              elevation: 1.5, selected: true,),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Users Pie-Chart',
                style: GoogleFonts.poppins(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
            Container(
              height: 230,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                      width:360,
                      child: PieChart(
                               PieChartData(
                                  pieTouchData: PieTouchData(
                                      touchCallback: (FlTouchEvent event, pieTouchResponse) {
                                        setState(() {
                                          if (!event.isInterestedForInteractions ||
                                              pieTouchResponse == null ||
                                              pieTouchResponse.touchedSection == null) {
                                            touchedIndex = -1;
                                            return;
                                          }
                                          touchedIndex = pieTouchResponse
                                              .touchedSection!.touchedSectionIndex;
                                        });
                                        },
                  ),
                  borderData: FlBorderData(
                    show: false,
                  ),
                  sectionsSpace: 0,
                  centerSpaceRadius: 50,
                  sections: showingSections(),
                ),
              ),
          ),
                  Container(
                    width: 230,
                    child: const Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Indicator(
                          color: Colors.blue,
                          text: 'Users',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: Colors.red,
                          text: 'Members',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: Colors.green,
                          text: 'Students',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: Colors.orange,
                          text: 'Pastors',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: Colors.pink,
                          text: 'Church Staffs',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Indicator(
                          color: Colors.deepPurple,
                          text: 'Choir Members',
                          isSquare: true,
                        ),
                        SizedBox(
                          height: 18,
                        ),
                      ],
                    ),
                ),

        ],
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

  List<PieChartSectionData> showingSections() {
    return List.generate(6, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 10.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [
        Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {

        case 0:
          return PieChartSectionData(
            color: Colors.blue,
            value: (usersCount / totalUsersCount *100),
            title: '${(usersCount/totalUsersCount *100).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle:  GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              //color: AppColors.mainTextColor1,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: Colors.red,
            value: (membersCount / totalUsersCount *100),
            title: '${(membersCount/totalUsersCount *100).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle:  GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              //color: AppColors.mainTextColor1,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.green,
            value: (studentsCount / totalUsersCount *100),
            title: '${(studentsCount/totalUsersCount *100).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle:  GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              //color: AppColors.mainTextColor1,

            ),
          );
        case 3:
          return PieChartSectionData(
            color: Colors.orange,
            value: (pastorsCount / totalUsersCount *100),
            title: '${(pastorsCount / totalUsersCount *100).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle:  GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              //color: AppColors.mainTextColor1,

            ),
          );
        case 4:
          return PieChartSectionData(
            color: Colors.pink,
            value: (churchStaffsCount / totalUsersCount *100),
            title: '${(churchStaffsCount / totalUsersCount *100).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle:  GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              //color: AppColors.mainTextColor1,

            ),
          );
        case 5:
          return PieChartSectionData(
            color: Colors.deepPurple,
            value: (choirsCount / totalUsersCount *100),
            title: '${(choirsCount / totalUsersCount *100).toStringAsFixed(2)}%',
            radius: radius,
            titleStyle:  GoogleFonts.poppins(
              fontSize: fontSize,
              fontWeight: FontWeight.w700,
              //color: AppColors.mainTextColor1,
            ),
          );
        default:
          throw Error();
      }
    });
  }

  List<Meeting> _getDataSource()  {
    List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime startTime2 = today.add(const Duration(days: 5));
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    final DateTime endTime2 = today.add( Duration(days: 5,));

    setState(() {
      //meetings= meetingsmain;
    });

    return meetings;
  }

  Widget eventspop(date) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    List<String> brother = ["Select Option","Remainder","Holiday"];
    String _typeAheadControllertype = "Select Option";
    return StatefulBuilder(
        builder: (context, set) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Add an event',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Divider(
                    color: Colors.black,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:10.0),
                      child: Container(
                          width: width/10.106,
                          height: height/16.42,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Event Type  :",style: GoogleFonts.poppins(fontSize: 15,)),
                          ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Container(

                        child: DropdownButtonHideUnderline(
                          child: DropdownButton2<String>(
                            isExpanded: true,
                            hint:  Row(
                              children: [
                                Icon(
                                  Icons.list,
                                  size: 16,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 4,
                                ),
                                Expanded(
                                  child: Text(
                                    'Select Option',
                                    style: GoogleFonts.poppins(
                                        fontSize: 15
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            items: brother
                                .map((String item) => DropdownMenuItem<String>(
                              value: item,
                              child: Text(
                                item,
                                style:  GoogleFonts.poppins(
                                    fontSize: 15
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ))
                                .toList(),
                            value:  _typeAheadControllertype,
                            onChanged: (String? value) {
                              set(() {
                                _typeAheadControllertype = value!;
                              });
                            },
                            buttonStyleData: ButtonStyleData(
                              height: 50,
                              width: 160,
                              padding: const EdgeInsets.only(left: 14, right: 14),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),

                                color: Color(0xffDDDEEE),
                              ),

                            ),
                            iconStyleData: const IconStyleData(
                              icon: Icon(
                                Icons.arrow_forward_ios_outlined,
                              ),
                              iconSize: 14,
                              iconEnabledColor: Colors.black,
                              iconDisabledColor: Colors.grey,
                            ),
                            dropdownStyleData: DropdownStyleData(
                              maxHeight: 200,
                              width: width/5.464,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: Color(0xffDDDEEE),
                              ),

                              scrollbarTheme: ScrollbarThemeData(
                                radius: const Radius.circular(7),
                                thickness: MaterialStateProperty.all<double>(6),
                                thumbVisibility: MaterialStateProperty.all<bool>(true),
                              ),
                            ),
                            menuItemStyleData: const MenuItemStyleData(
                              height: 40,
                              padding: EdgeInsets.only(left: 14, right: 14),
                            ),
                          ),
                        ),
                        width: width/7.464,
                        height: height/16.425,
                        //color: Color(0xffDDDEEE),
                        decoration: BoxDecoration(color: Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),

                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:10.0),
                      child: Container(
                          width: width/10.106,
                          height: height/16.42,

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Event Name  :",style: GoogleFonts.poppins(fontSize: 15,)),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Container(child: TextFormField(
                        controller: eventNameController,
                        style: GoogleFonts.poppins(
                            fontSize: 15
                        ),
                        decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 10,bottom: 8),
                          border: InputBorder.none,
                        ),
                      ),
                        width: width/7.464,
                        height: height/16.425,
                        //color: Color(0xffDDDEEE),
                        decoration: BoxDecoration(color: Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left:10.0),
                      child: Container(
                          width: width/10.106,
                          height: height/16.42,

                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Text("Date  :",style: GoogleFonts.poppins(fontSize: 15,)),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 25.0),
                      child: Container(child: TextFormField(
                        readOnly:  true,
                        controller: selectedDateController,
                        style: GoogleFonts.poppins(
                            fontSize: 15
                        ),
                        decoration: InputDecoration(contentPadding: EdgeInsets.only(left: 10,bottom: 8),
                          border: InputBorder.none,
                        ),
                      ),
                        width: width/7.464,
                        height: height/16.425,
                        //color: Color(0xffDDDEEE),
                        decoration: BoxDecoration(color: Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 24.0, top: 8.0, bottom: 8.0,right: 153),
                      child: Container(

                        child: GestureDetector(
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return BouncingDraggableDialog(
                                    width: 400,
                                    height: 600,
                                    content: eventspop2(selectedDateController.text),
                                  );
                                });
                          },
                          child: Text(
                            'View Events',
                            style: TextStyle(
                              color: Colors.indigo,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Close',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
                      child: Container(
                        alignment: Alignment.bottomRight,
                        child: GestureDetector(
                          onTap: () {
                            FirebaseFirestore.instance.collection("EventsCalender").doc().set({
                              "name": eventNameController.text,
                              "ondate" : selectedDateController.text,
                              "type" : _typeAheadControllertype,
                              "date": date,
                            });
                            // ScaffoldMessenger.of(context)
                            //     .showSnackBar(snackBar);
                            Navigator.pop(context);
                            //getevents();
                          },
                          child: Text(
                            'Add Event',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }
    );
  }

  Widget eventspop2(date) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Events on $date',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 8.0,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(
              color: Colors.black,
            ),
          ),

          Container(
            width: 400,
            height: 400,
            child: StreamBuilder<QuerySnapshot>(
                stream:  FirebaseFirestore.instance.collection("EventsCalender").where("ondate",isEqualTo: date).snapshots(),
                builder: (context,snap){
                  if(snap.hasData){
                    return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snap.data!.docs.length,
                        itemBuilder: (context,index){

                          return ListTile(
                            title: Text(snap.data!.docs[index]["name"]),
                            subtitle: Text(snap.data!.docs[index]["ondate"]),
                            trailing: Icon(Icons.delete_forever_rounded),
                            onTap: (){
                              FirebaseFirestore.instance.collection("EventsCalender").doc(snap.data!.docs[index].id).delete();
                            },
                          );

                        });
                  }return Container(

                  );
                }),
          ),


          SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Padding(
                padding: const EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
                child: Container(
                  alignment: Alignment.bottomRight,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                      //getevents();
                    },
                    child: Text(
                      'OK',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }


  Future<MembershipReportModel> getMemebershipReports() async {

    List<SalesData> regularList = [];
    List<SalesData> regularList1 = [];

    var membershipDoc = await FirebaseFirestore.instance.collection('MembershipReports').get();

    for(int m = 0; m < membershipDoc.docs.length; m++){
      int presentCount = 0;
        presentCount++;
        DateTime startDate = DateFormat('dd/M/yyyy').parse(membershipDoc.docs[m].get("date"));
        String month = await getMonthForData(startDate.month);
        SalesData sale = SalesData(month, presentCount.toDouble(),'','');
      regularList1.add(sale);
    }

    regularList.add(SalesData('Jan',regularList1.where((element) => element.year == 'Jan').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Feb',regularList1.where((element) => element.year == 'Feb').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Mar',regularList1.where((element) => element.year == 'Mar').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Apr',regularList1.where((element) => element.year == 'Apr').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('June',regularList1.where((element) => element.year == 'June').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('July',regularList1.where((element) => element.year == 'July').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Aug',regularList1.where((element) => element.year == 'Aug').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Sep',regularList1.where((element) => element.year == 'Sep').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Oct',regularList1.where((element) => element.year == 'Oct').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Nov',regularList1.where((element) => element.year == 'Nov').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Dec',regularList1.where((element) => element.year == 'Dec').length.toDouble() * 1000,'',''));


    MembershipReportModel membership = MembershipReportModel(
        regular: regularList.isNotEmpty ? ((regularList.length * 1000) /(membersCount * 12000)) : 0.0,
        irRegular: (regularList.isNotEmpty && membersCount != 0) ? ((membersCount * 12000) - (regularList.length * 1000)) / (membersCount * 12000) : 0.0,
        data: regularList,
    );
    return membership;
  }

  getMonthForData(int month){
    String result = '';
    switch(month){
      case 1:
        result = 'Jan';
        break;
      case 2:
        result = 'Feb';
        break;
      case 3:
        result = 'Mar';
        break;
      case 4:
        result = 'Apr';
        break;
      case 5:
        result = 'May';
        break;
      case 6:
        result = 'June';
        break;
      case 7:
        result = 'July';
        break;
      case 8:
        result = 'Aug';
        break;
      case 9:
        result = 'Sep';
        break;
      case 10:
        result = 'Oct';
        break;
      case 11:
        result = 'Nov';
        break;
      case 12:
        result = 'Dec';
        break;

    }
    return result;
  }

}


class SalesData {
SalesData(this.year, this.sales,this.absentDay, this.presentDay);

final String year;
late double sales;
final String absentDay;
final String presentDay;
}


class MembershipReportModel {
  MembershipReportModel({
    required this.regular,
    required this.irRegular,
    required this.data,
});

  double regular;
  double irRegular;
  List<SalesData> data;
}


class Indicator extends StatelessWidget {
  const Indicator({
    super.key,
    required this.color,
    required this.text,
    required this.isSquare,
    this.size = 16,
    this.textColor,
  });
  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(
          width: 4,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
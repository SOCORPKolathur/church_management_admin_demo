import 'package:church_management_admin/Dashboard2.dart';
import 'package:church_management_admin/views/tabs/reports_view.dart';
import 'package:church_management_admin/views/tabs/user_tab.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_icons/animate_icons.dart';
import '../../models/drawer_model.dart';
import '../../resources/app_colors.dart';
import 'asset_management_tab.dart';
import 'attendance_for_family_tab.dart';
import 'attendance_record_tab.dart';
import 'audio_podcast_tab.dart';
import 'blood_requirement_tab.dart';
import 'bolg_tab.dart';
import 'chrous_tab.dart';
import 'church_staff_tab.dart';
import 'clans_tab.dart';
import 'com_notifications_tab.dart';
import 'committee_tab.dart';
import 'dashboard_tab.dart';
import 'department_tab.dart';
import 'donations_tab.dart';
import 'email_communication_tab.dart';
import 'events_tab.dart';
import 'family_tab.dart';
import 'function_hall_tab.dart';
import 'fund_management_tab.dart';
import 'gallery_tab.dart';
import 'greetings_tab.dart';
import 'login_reports_tab.dart';
import 'manager_role_tab.dart';
import 'meeting_tab.dart';
import 'members_tab.dart';
import 'membership_register_tab.dart';
import 'membership_reports_tab.dart';
import 'memorial_days_tab.dart';
import 'notice_tab.dart';
import 'orders_tab.dart';
import 'pastors_tab.dart';
import 'prayers_tab.dart';
import 'product_tab.dart';
import 'reports_view.dart';
import 'sms_communication_tab.dart';
import 'speech_tab.dart';
import 'student_tab.dart';
import 'testimonials_tab.dart';
import 'user_tab.dart';
import 'website_socialmedia_tab.dart';
import 'zone_areas.dart';
import 'zone_reports_view.dart';
import 'zones_list_view.dart';

class DemoLanding extends StatefulWidget {
  const DemoLanding({super.key});

  @override
  State<DemoLanding> createState() => _DemoLandingState();
}

class _DemoLandingState extends State<DemoLanding> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return  Column(
        children: <Widget>[

          const SizedBox(
            height: 18,
          ),
          Expanded(
            child: Container(
              width: 600,
              height: 600,
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
                  startDegreeOffset: 180,

                  sectionsSpace: 1,
                  centerSpaceRadius: 0,
                  sections: showingSections(),
                ),
              ),
            ),
          ),
        ],
      );

  }

  List<PieChartSectionData> showingSections() {
    return List.generate(
      4,
          (i) {
        final isTouched = i == touchedIndex;
        const color0 =Color(0xff343C6A);
        const color1 = Color(0xffFC7900);
        const color2 = Color(0xff1814F3);
        const color3 = Color(0xffFA00FF);

        switch (i) {
          case 0:
            return PieChartSectionData(
              color: color0,
              value: 30,
              title: '30 \nMembers',
              titleStyle: GoogleFonts.inter(
                fontWeight: FontWeight.w700,
                fontSize: 12,
                color: Colors.white
              ),
              radius: 87,
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                  color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                  color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 1:
            return PieChartSectionData(
              color: color1,
              value: 15,
              title: '15 \nPastors',
              radius: 80,
              titleStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.white
              ),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                  color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                  color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 2:
            return PieChartSectionData(
              color: color2,
              value: 35,
              title: '35 \nStaffs',
              radius: 60,
              titleStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.white
              ),
              titlePositionPercentageOffset: 0.6,
              borderSide: isTouched
                  ? const BorderSide(
                  color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                  color: AppColors.contentColorWhite.withOpacity(0)),
            );
          case 3:
            return PieChartSectionData(
              color: color3,
              value: 20,
              title: '20 \nFlocks',
              radius: 80,
              titleStyle: GoogleFonts.inter(
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                  color: Colors.white
              ),
              titlePositionPercentageOffset: 0.55,
              borderSide: isTouched
                  ? const BorderSide(
                  color: AppColors.contentColorWhite, width: 6)
                  : BorderSide(
                  color: AppColors.contentColorWhite.withOpacity(0)),
            );
          default:
            throw Error();
        }
      },
    );
  }
}

class LineChartSample2 extends StatefulWidget {
  const LineChartSample2({super.key});

  @override
  State<LineChartSample2> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<LineChartSample2> {

  List<Color> gradientColors = [
    Color(0xff2D60FF),
    Color(0xff2D60FF),

  ];

  List<Color> gradientColors2 = [
    Color(0xff2D60FF).withOpacity(0.25),
    Color(0xff2D60FF).withOpacity(0),

  ];

  bool showAvg = false;

  @override
  Widget build(BuildContext context) {
    return  Container(
        width: 600,
        height: 200,
        child: Stack(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(
                right: 30,
                left: 12,
                top: 24,
                bottom: 12,
              ),
              child: LineChart(
                mainData(),

              ),
            ),

          ],
        ),
      );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text =  Text('May', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 2:
        text =  Text('Jun', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 4:
        text =  Text('Jul', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 6:
        text =  Text('Aug', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 8:
        text =  Text('Sep', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 10:
        text =  Text('Oct', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 12:
        text =  Text('Nov', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 14:
        text =  Text('Dec', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 16:
        text =  Text('Jan', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 18:
        text =  Text('Feb', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 20:
        text =  Text('Mar', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      case 22:
        text =  Text('April', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
      default:
        text =  Text('', style: GoogleFonts.inter(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: Color(0xff718EBF)
        ), );
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {

    String text;
    switch (value.toInt()) {
      case 1:
        text = '0';
        break;
      case 3:
        text = '100';
        break;
      case 5:
        text = '200';
        break;
      case 7:
        text = '800';
        break;
      default:
        return Container();
    }

    return Text(text, style: GoogleFonts.inter(
      fontWeight: FontWeight.w400,
      fontSize: 12,
      color: Color(0xff718EBF)
    ), textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,

        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,

        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },

      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 22,
      minY: 0,
      maxY: 9,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3),
            FlSpot(2.6, 2),
            FlSpot(4.9, 5),
            FlSpot(6.8, 3.1),
            FlSpot(8, 4),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
            FlSpot(14, 6),
            FlSpot(16, 3),
            FlSpot(18, 2),
            FlSpot(20, 5),
            FlSpot(22, 4.1),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 3,
         //isStrokeCapRound: true,


          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: gradientColors2,
            ),
          ),

        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots: const [
            FlSpot(0, 3.44),
            FlSpot(2.6, 3.44),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}


class HomeDrawer extends StatefulWidget {
  const HomeDrawer({super.key});

  @override
  State<HomeDrawer> createState() => _HomeDrawerState();
}

class _HomeDrawerState extends State<HomeDrawer> {


  int dawer = 0;
  var pages;
  @override
  void initState() {
    //addinglist();
    setState(() {
      pages=Dashboard2();
    });


    c1 = AnimateIconController();
    c2 = AnimateIconController();
    c3 = AnimateIconController();
    c4 = AnimateIconController();
    c5 = AnimateIconController();
    c6 = AnimateIconController();
    // TODO: implement initState
    super.initState();
  }

  ExpansionTileController admissioncon= new ExpansionTileController();
  ExpansionTileController studdentcon= new ExpansionTileController();
  ExpansionTileController staffcon= new ExpansionTileController();
  ExpansionTileController attdencecon= new ExpansionTileController();
  ExpansionTileController feescon= new ExpansionTileController();
  ExpansionTileController examcon= new ExpansionTileController();
  ExpansionTileController hrcon= new ExpansionTileController();
  ExpansionTileController noticescon= new ExpansionTileController();
  ExpansionTileController timetable= new ExpansionTileController();




  bool col1=false;
  bool col2=false;
  bool col3=false;
  bool col4=false;
  bool col5=false;
  bool col6=false;
  bool col7=false;
  bool col8=false;
  bool col9=false;
  String pagename="";
  late AnimateIconController c1, c2, c3, c4, c5, c6;


  bool onEndIconPress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("onEndIconPress called"),
        duration: Duration(seconds: 1),
      ),
    );
    return true;
  }

  bool onStartIconPress(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("onStartIconPress called"),
        duration: Duration(seconds: 1),
      ),
    );
    return true;
  }

  @override
  Widget build(BuildContext context) {
    final double width=MediaQuery.of(context).size.width;
    final double height=MediaQuery.of(context).size.height;
    return Scaffold(
      body: Row(
        children: [
          Container(
            width: width/5.939,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(),
                  child: Material(
                    elevation: 5,
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: width/5.003,
                      height: height,
                      decoration: BoxDecoration(
                       // borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomLeft: Radius.circular(10)),
                        color: Colors.white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [

                            Container(
                              child: Row(
                                children: [
                                 // Image.asset("assets/imagevidh.png"),
                                  Row(

                                    children: [
                                      GestureDetector(
                                        onTap: (){
                                        },
                                        child: Container(

                                            child: Image.asset("assets/demochurchlogo.png")

                                        ),
                                      ),

                                      Text(
                                        "IKIA Church",
                                        style: GoogleFonts.kanit(
                                            fontSize: 25,
                                            fontWeight: FontWeight.w600,
                                            color:Color(0xff333333)),
                                      ),

                                    ],
                                  ),

                                ],
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.white,
                              ),
                              width: width/4.878,
                              height: height/6.57,

                            ),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Container(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 0
                                          ? 300 : 0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 0
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          pages = Dashboard2();
                                          dawer=0;
                                          col1=false;
                                          col2=false;
                                          col3=false;
                                          col4=false;
                                          col5=false;
                                          col6=false;
                                          col7=false;
                                          col8=false;
                                          col9=false;
                                          pagename="";

                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "Dashboard",
                                              style: GoogleFonts.kanit(
                                                  fontSize: width/95,
                                                  fontWeight: FontWeight.w500,
                                                  color: dawer == 0 ?  Colors.white : Color(0xff9197B3)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Container(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 1
                                          ? 300 : 0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 1
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          //pages = ReportsTab();
                                          dawer=1;
                                          col1=false;
                                          col2=false;
                                          col3=false;
                                          col4=false;
                                          col5=false;
                                          col6=false;
                                          col7=false;
                                          col8=false;
                                          col9=false;
                                          pagename="";
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "Reports",
                                              style: GoogleFonts.kanit(
                                                  fontSize: width/95,
                                                  fontWeight: FontWeight.w500,
                                                  color: dawer == 1 ?  Colors.white : Color(0xff9197B3)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 700),
                                height: col1==true
                                    ? 350 : 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 2
                                          ? 300 : 0,
                                      height: col1==true
                                          ?  350 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 2
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {

                                              dawer=2;
                                              col1 = !col1;
                                              if(col1==true){
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                              }
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Container(
                                                    width: 180,
                                                    child: Text(
                                                      "Church Database",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: dawer == 2 ?  Colors.white : Color(0xff9197B3)),
                                                    ),
                                                  ),
                                                ),

                                                Icon(col1!=true? Icons.arrow_drop_down: Icons.arrow_drop_up,color: dawer==2 ? Colors.white : Color(0xff9197B3),size: 25,)


                                              ],
                                            ),
                                          ),
                                        ),


                                        col1==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = UserTab();
                                              pagename="User List";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col1 == true ? pagename=="User List" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                               color:  col1 == true ? pagename=="User List" ? Colors.white : Colors.transparent : Colors.transparent,
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "User List",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col1 == true ? pagename=="User List" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col1==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = MembersTab();
                                              pagename="Members List";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col1 == true ? pagename=="Members List" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col1 == true ? pagename=="Members List" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Members List",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col1 == true ? pagename=="Members List" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col1==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = FamilyTab();
                                              pagename="Families";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col1 == true ? pagename=="Families" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col1 == true ? pagename=="Families" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Families",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col1 == true ? pagename=="Families" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col1==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = ClansTab();
                                              pagename="Little Flocks";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col1 == true ? pagename=="Little Flocks" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col1 == true ? pagename=="Little Flocks" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Little Flocks",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col1 == true ? pagename=="Little Flocks" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col1==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = StudentTab();
                                              pagename="Student";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col1 == true ? pagename=="Student" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col1 == true ? pagename=="Student" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Student",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col1 == true ? pagename=="Student" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col1==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = CommitteeTab();
                                              pagename="Committee";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col1 == true ? pagename=="Committee" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col1 == true ? pagename=="Committee" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Committee",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col1 == true ? pagename=="Committee" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col1==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = PastorsTab();
                                              pagename="Pastors";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col1 == true ? pagename=="Pastors" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col1 == true ? pagename=="Pastors" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Pastors",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col1 == true ? pagename=="Pastors" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col1==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = ChurchStaffTab();
                                              pagename="Church Staff";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col1 == true ? pagename=="Church Staff" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col1 == true ? pagename=="Church Staff" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Church Staff",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col1 == true ? pagename=="Church Staff" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col1==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = DepartmentTab();
                                              pagename="Department";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col1 == true ? pagename=="Department" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col1 == true ? pagename=="Department" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Department",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col1 == true ? pagename=="Department" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),


                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 700),
                                height: col2==true
                                    ? 115 : 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 3
                                          ? 300 : 0,
                                      height: col2==true
                                          ?  115 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 3
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {

                                              dawer=3;
                                              col2 = !col2;
                                              if(col2==true){
                                                col1=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;

                                              }
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Container(
                                                    width: 180,
                                                    child: Text(
                                                      "Membership",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: dawer == 3 ?  Colors.white : Color(0xff9197B3)),
                                                    ),
                                                  ),
                                                ),

                                                Icon(col2!=true? Icons.arrow_drop_down: Icons.arrow_drop_up,color: dawer==3 ? Colors.white : Color(0xff9197B3),size: 25,)


                                              ],
                                            ),
                                          ),
                                        ),


                                        col2==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = MembershipReportsTab();
                                              pagename="Membership Reports";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col2 == true ? pagename=="Membership Reports" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col2 == true ? pagename=="Membership Reports" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Membership Reports",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col2 == true ? pagename=="Membership Reports" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col2==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = MembershipRegisterTab();
                                              pagename="Membership Register";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col2 == true ? pagename=="Membership Register" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col2 == true ? pagename=="Membership Register" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Membership Register",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col2 == true ? pagename=="Membership Register" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),


                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 700),
                                height: col3==true
                                    ? 145 : 35,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 4
                                          ? 300 : 0,
                                      height: col3==true
                                          ?  145 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 4
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {

                                              dawer=4;
                                              col3 = !col3;
                                              if(col3==true){
                                                col1=false;
                                                col2=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                              }
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Container(
                                                    width: 180,
                                                    child: Text(
                                                      "Finance",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: dawer == 4 ?  Colors.white : Color(0xff9197B3)),
                                                    ),
                                                  ),
                                                ),

                                                Icon(col3!=true? Icons.arrow_drop_down: Icons.arrow_drop_up,color: dawer==4 ? Colors.white : Color(0xff9197B3),size: 25,)


                                              ],
                                            ),
                                          ),
                                        ),


                                        col3==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = FundManagementTab();
                                              pagename="Fund Management";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col3 == true ? pagename=="Fund Management" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col3 == true ? pagename=="Fund Management" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Fund Management",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col3 == true ? pagename=="Fund Management" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col3==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = DonationsTab();
                                              pagename="Donations";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col3 == true ? pagename=="Donations" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col3 == true ? pagename=="Donations" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Donations",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col3 == true ? pagename=="Donations" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col3==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = AssetManagementTab();
                                              pagename="Asset Management";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col3 == true ? pagename=="Asset Management" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col3 == true ? pagename=="Asset Management" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Asset Management",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col3 == true ? pagename=="Asset Management" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),


                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 700),
                                height: col4==true
                                    ? 280 : 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 5
                                          ? 300 : 0,
                                      height: col4==true
                                          ?  280 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 5
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {

                                              dawer=5;
                                              col4 = !col4;
                                              if(col4==true){
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col5=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                              }
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Container(
                                                    width: 180,
                                                    child: Text(
                                                      "Engagement",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: dawer == 5 ?  Colors.white : Color(0xff9197B3)),
                                                    ),
                                                  ),
                                                ),

                                                Icon(col4!=true? Icons.arrow_drop_down: Icons.arrow_drop_up,color: dawer==5 ? Colors.white : Color(0xff9197B3),size: 25,)


                                              ],
                                            ),
                                          ),
                                        ),


                                        col4==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = GreetingsTab();
                                              pagename="Wishes";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col4 == true ? pagename=="Wishes" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col4 == true ? pagename=="Wishes" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Wishes",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col4 == true ? pagename=="Wishes" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col4==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = SmsCommunicationTab();
                                              pagename="SMS Communication";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col4 == true ? pagename=="SMS Communication" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col4 == true ? pagename=="SMS Communication" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "SMS Communication",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col4 == true ? pagename=="SMS Communication" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col4==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = EmailCommunictionTab();
                                              pagename="Email Communication";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col4 == true ? pagename=="Email Communication" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col4 == true ? pagename=="Email Communication" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Email Communication",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col4 == true ? pagename=="Email Communication" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col4==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = ComNotificationsTab();
                                              pagename="Notifications";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col4 == true ? pagename=="Notifications" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col4 == true ? pagename=="Notifications" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Notifications",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col4 == true ? pagename=="Notifications" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col4==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = BloodRequirementTab();
                                              pagename="Blood Requirement";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col4 == true ? pagename=="Blood Requirement" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col4 == true ? pagename=="Blood Requirement" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Blood Requirement",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col4 == true ? pagename=="Blood Requirement" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col4==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = BlogTab();
                                              pagename="Blog";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col4 == true ? pagename=="Blog" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col4 == true ? pagename=="Blog" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Blog",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col4 == true ? pagename=="Blog" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col4==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = WebsiteAndSocialMediaTab();
                                              pagename="Social Media";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col4 == true ? pagename=="Social Media" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col4 == true ? pagename=="Social Media" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Social Media",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col4 == true ? pagename=="Social Media" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),


                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 700),
                                height: col5==true
                                    ? 280 : 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 6
                                          ? 300 : 0,
                                      height: col5==true
                                          ?  280 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 6
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {

                                              dawer=6;
                                              col5 = !col5;
                                              if(col5==true){
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col6=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                              }
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Container(
                                                    width: 180,
                                                    child: Text(
                                                      "Church Tools",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: dawer == 6 ?  Colors.white : Color(0xff9197B3)),
                                                    ),
                                                  ),
                                                ),

                                                Icon(col5!=true? Icons.arrow_drop_down: Icons.arrow_drop_up,color: dawer==6 ? Colors.white : Color(0xff9197B3),size: 25,)


                                              ],
                                            ),
                                          ),
                                        ),


                                        col5==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = SpeechTab();
                                              pagename="Speech";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col5 == true ? pagename=="Speech" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col5 == true ? pagename=="Speech" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Speech",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col5 == true ? pagename=="Speech" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col5==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = TestimonialsTab();
                                              pagename="Testimonials";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col5 == true ? pagename=="Testimonials" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col5 == true ? pagename=="Testimonials" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Testimonials",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col5 == true ? pagename=="Testimonials" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col5==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = PrayersTab();
                                              pagename="Prayers";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col5 == true ? pagename=="Prayers" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col5 == true ? pagename=="Prayers" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Prayers",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col5 == true ? pagename=="Prayers" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col5==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = MeetingsTab();
                                              pagename="Meetings";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col5 == true ? pagename=="Meetings" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col5 == true ? pagename=="Meetings" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Meetings",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col5 == true ? pagename=="Meetings" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col5==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = EventsTab();
                                              pagename="Event Management";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col5 == true ? pagename=="Event Management" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col5 == true ? pagename=="Event Management" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Event Management",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col5 == true ? pagename=="Event Management" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col5==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = RememberDaysTab();
                                              pagename="Memorial  Days";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col5 == true ? pagename=="Memorial  Days" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col5 == true ? pagename=="Memorial  Days" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Memorial  Days",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col5 == true ? pagename=="Memorial  Days" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col5==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = NoticesTab();
                                              pagename="Announcements";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col5 == true ? pagename=="Announcements" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col5 == true ? pagename=="Announcements" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Announcements",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col5 == true ? pagename=="Announcements" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),


                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 700),
                                height: col6==true
                                    ? 110 : 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 7
                                          ? 300 : 0,
                                      height: col6==true
                                          ?  110 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 7
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              dawer=7;
                                              col6 = !col6;
                                              if(col6==true){
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col7=false;
                                                col8=false;
                                                col9=false;
                                              }
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Container(
                                                    width: 180,
                                                    child: Text(
                                                      "Attendance",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: dawer == 7 ?  Colors.white : Color(0xff9197B3)),
                                                    ),
                                                  ),
                                                ),

                                                Icon(col6!=true? Icons.arrow_drop_down: Icons.arrow_drop_up,color: dawer==7 ? Colors.white : Color(0xff9197B3),size: 25,)


                                              ],
                                            ),
                                          ),
                                        ),


                                        col6==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = AttendanceFamilyTab();
                                              pagename="Member Attendance";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col6 == true ? pagename=="Member Attendance" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col6 == true ? pagename=="Member Attendance" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Member Attendance",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col6 == true ? pagename=="Member Attendance" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col6==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = AttendanceRecordTab();
                                              pagename="Student Attendance";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col6 == true ? pagename=="Student Attendance" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col6 == true ? pagename=="Student Attendance" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Student Attendance",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col6 == true ? pagename=="Student Attendance" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),



                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Container(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 8
                                          ? 300 : 0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 8
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          pages = GalleryTab();
                                          dawer=8;
                                          col1=false;
                                          col2=false;
                                          col3=false;
                                          col4=false;
                                          col5=false;
                                          col6=false;
                                          pagename="";
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "Gallery",
                                              style: GoogleFonts.kanit(
                                                  fontSize: width/95,
                                                  fontWeight: FontWeight.w500,
                                                  color: dawer == 8 ?  Colors.white : Color(0xff9197B3)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),


                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 700),
                                height: col7==true
                                    ? 110 : 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 9
                                          ? 300 : 0,
                                      height: col7==true
                                          ?  110 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 9
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {

                                              dawer=9;
                                              col7 = !col7;
                                              if(col7==true){
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col6=false;
                                                col8=false;
                                                col9=false;
                                              }
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Container(
                                                    width: 180,
                                                    child: Text(
                                                      "Security",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: dawer == 9 ?  Colors.white : Color(0xff9197B3)),
                                                    ),
                                                  ),
                                                ),

                                                Icon(col7!=true? Icons.arrow_drop_down: Icons.arrow_drop_up,color: dawer==9 ? Colors.white : Color(0xff9197B3),size: 25,)


                                              ],
                                            ),
                                          ),
                                        ),


                                        col7==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = ManagerRoleTab(currentRole: 'Admin@gmail.com');
                                              pagename="Manage Role";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col7 == true ? pagename=="Manage Role" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col7 == true ? pagename=="Manage Role" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Manage Role",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col7 == true ? pagename=="Manage Role" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col7==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = LoginReportsTab();
                                              pagename="Login Reports";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col7 == true ? pagename=="Login Reports" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col7 == true ? pagename=="Login Reports" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Login Reports",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col7 == true ? pagename=="Login Reports" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),



                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 700),
                                height: col8==true
                                    ? 150 : 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 10
                                          ? 300 : 0,
                                      height: col8==true
                                          ?  150 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 10
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {

                                              dawer=10;
                                              col8 = !col8;
                                              if(col8==true){
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col7=false;
                                                col6=false;
                                                col9=false;
                                              }
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Container(
                                                    width: 180,
                                                    child: Text(
                                                      "Zone Activities",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: dawer == 10 ?  Colors.white : Color(0xff9197B3)),
                                                    ),
                                                  ),
                                                ),

                                                Icon(col8!=true? Icons.arrow_drop_down: Icons.arrow_drop_up,color: dawer==10 ? Colors.white : Color(0xff9197B3),size: 25,)


                                              ],
                                            ),
                                          ),
                                        ),


                                        col8==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = Zone_Areas();
                                              pagename="Zone Areas";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col8 == true ? pagename=="Zone Areas" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col8 == true ? pagename=="Zone Areas" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Zone Areas",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col8 == true ? pagename=="Zone Areas" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col8==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = ZonesListView();
                                              pagename="Zone List";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col8 == true ? pagename=="Zone List" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col8 == true ? pagename=="Zone List" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Zone List",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col8 == true ? pagename=="Zone List" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col8==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = ZoneReportsView();
                                              pagename="Zone Reports";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col8 == true ? pagename=="Zone Reports" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col8 == true ? pagename=="Zone Reports" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Zone Reports",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col8 == true ? pagename=="Zone Reports" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),



                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),

                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: AnimatedContainer(
                                curve: Curves.fastOutSlowIn,
                                duration: Duration(milliseconds: 700),
                                height: col9==true
                                    ? 110 : 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 11
                                          ? 300 : 0,
                                      height: col9==true
                                          ?  110 : 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 11
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            setState(() {
                                              dawer=11;
                                              col9 = !col9;
                                              if(col9==true){
                                                col1=false;
                                                col2=false;
                                                col3=false;
                                                col4=false;
                                                col5=false;
                                                col7=false;
                                                col8=false;
                                                col6=false;
                                              }
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 5.0),
                                            child: Row(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 8.0),
                                                  child: Container(
                                                    width: 180,
                                                    child: Text(
                                                      "Ecommerce",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: dawer == 11 ?  Colors.white : Color(0xff9197B3)),
                                                    ),
                                                  ),
                                                ),

                                                Icon(col9!=true? Icons.arrow_drop_down: Icons.arrow_drop_up,color: dawer==11 ? Colors.white : Color(0xff9197B3),size: 25,)


                                              ],
                                            ),
                                          ),
                                        ),


                                        col9==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = ProductTab();
                                              pagename="Product";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col9 == true ? pagename=="Product" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col9 == true ? pagename=="Product" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Product",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col9 == true ? pagename=="Product" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),
                                        col9==true ?   InkWell(
                                          onTap: () {
                                            setState(() {
                                              pages = OrdersTab();
                                              pagename="Orders";
                                            });

                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(top: 15.0,left:8,right:8),
                                            child: AnimatedContainer(
                                              height: col9 == true ? pagename=="Orders" ? 30 : 17 :0,
                                              decoration: BoxDecoration(
                                                  color:  col9 == true ? pagename=="Orders" ? Colors.white : Colors.transparent : Colors.transparent,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              duration: Duration(milliseconds: 250),
                                              child: Row(
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 20.0),
                                                    child: Text(
                                                      "Orders",
                                                      style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: col9 == true ? pagename=="Orders" ? Color(0xff9197B3)  : Colors.white : Colors.white  ),
                                                    ),
                                                  ),

                                                ],
                                              ),
                                            ),
                                          ),
                                        ) : SizedBox(),




                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Container(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 12
                                          ? 300 : 0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 12
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          pages = FunctionHallTab();
                                          dawer=12;
                                          col1=false;
                                          col2=false;
                                          col3=false;
                                          col4=false;
                                          col5=false;
                                          col6=false;
                                          col7=false;
                                          col8=false;
                                          col9=false;
                                          pagename="";
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "Function Hall",
                                              style: GoogleFonts.kanit(
                                                  fontSize: width/95,
                                                  fontWeight: FontWeight.w500,
                                                  color: dawer == 12 ?  Colors.white : Color(0xff9197B3)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                              Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 6),
                              child: Container(

                                height: 35,

                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),

                                ),
                                child: Stack(
                                  alignment: Alignment.centerLeft,
                                  children: [
                                    AnimatedContainer(
                                      curve: Curves.fastOutSlowIn,
                                      duration: Duration(milliseconds: 700),
                                      width:  dawer == 13
                                          ? 300 : 0,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        color: dawer == 13
                                            ? Color(0xff377DFF) : Colors.transparent,
                                      ),

                                    ),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          pages = AudioPodcastTab();
                                          dawer=13;
                                          col1=false;
                                          col2=false;
                                          col3=false;
                                          col4=false;
                                          col5=false;
                                          col6=false;
                                          col7=false;
                                          col8=false;
                                          col9=false;
                                          pagename="";
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(left: 8.0),
                                            child: Text(
                                              "Audio Podcast",
                                              style: GoogleFonts.kanit(
                                                  fontSize: width/95,
                                                  fontWeight: FontWeight.w500,
                                                  color: dawer == 13 ?  Colors.white : Color(0xff9197B3)),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),

                          ],
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 0.0,top: 0),
            child: Container(
              width: width/1.205,
              height: height/1,

              child: pages,
            ),
          )
        ],
      ),
    );
  }
}

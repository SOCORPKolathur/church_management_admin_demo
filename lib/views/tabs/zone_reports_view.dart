import 'package:church_management_admin/services/zonal_activities_firecrud.dart';
import 'package:church_management_admin/views/tabs/reports_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sfc;
import '../../constants.dart';
import '../../models/response.dart';
import '../../models/task_model.dart';
import '../../models/zone_model.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';

class ZoneReportsView extends StatefulWidget {
  const ZoneReportsView({Key? key}) : super(key: key);

  @override
  State<ZoneReportsView> createState() => _ZoneReportsViewState();
}

class _ZoneReportsViewState extends State<ZoneReportsView> with SingleTickerProviderStateMixin {

  TextEditingController zoneNameController = TextEditingController(text: 'Select Zone');
  TextEditingController zoneIdController = TextEditingController();
  TextEditingController taskNameController = TextEditingController();
  TextEditingController taskDescriptionController = TextEditingController();
  TextEditingController taskDueDateController = TextEditingController();
  TextEditingController leaderNameController = TextEditingController();
  TextEditingController leaderPhoneController = TextEditingController();
  TextEditingController searchZoneIdController = TextEditingController();
  TextEditingController searchZoneNameController = TextEditingController(text: 'Select Zone');

  late sfc.TooltipBehavior _tooltipBehavior;
  int touchedIndex = 1;
  TabController? _tabController;
  int currentTabIndex = 0;
  String currentTab = 'View';
  List<ZoneModel> zonesList = [];

  List leaderName = [];

  @override
  void initState() {
    getZones();
    getZonesLeaders();
    _tabController = TabController(length: 2, vsync: this);
    _tooltipBehavior = sfc.TooltipBehavior(enable: true);
    super.initState();
  }


  getZones() async {
    zonesList.clear();
    zonesList.add(
      ZoneModel(
        timestamp: 000,
        id: '',
        areas: [],
        zoneName: 'Select Zone',
        zoneId: '',
        leaderName: '',
      )
    );
    var zonesDoc = await FirebaseFirestore.instance.collection('Zones').orderBy("timestamp").get();
    for(int i=0; i< zonesDoc.docs.length; i++){
      setState(() {
        zonesList.add(ZoneModel.fromJson(zonesDoc.docs[i].data()));
      });
    }
  }

  getZonesLeaders() async {
    leaderName.clear();
    var zonesDoc = await FirebaseFirestore.instance.collection('Zones').orderBy("timestamp",descending: true).get();
    for(int i=0; i< zonesDoc.docs.length; i++) {
      setState(() {
        leaderName.add(zonesDoc.docs[i]["leaderName"]);
      });
    }
  }

  clearTextControllers(){
    setState(() {
       zoneNameController.text = 'Select Zone';
       zoneIdController.text = "";
       taskNameController.text = "";
       taskDescriptionController.text = "";
       taskDueDateController.text = "";
       leaderNameController.text = "";
       leaderPhoneController.text = "";
       searchZoneIdController.text = "";
       searchZoneNameController.text = 'Select Zone';
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    KText(
                      text: "Zone Reports",
                      style: GoogleFonts.openSans(
                        fontSize: width / 52.53846153846154,
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
                                text: currentTab.toUpperCase() == "VIEW" ? "Assign Task" : "View Reports",
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
                height: height * 1.0,
                width: width,
                margin: EdgeInsets.symmetric(horizontal: width / 68.3, vertical: height / 32.55),
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
                        padding: EdgeInsets.symmetric(
                            horizontal: width / 68.3, vertical: height / 81.375),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            KText(
                              text: "Assign Task",
                              style: GoogleFonts.openSans(
                                fontSize: width / 68.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        padding: EdgeInsets.symmetric(vertical: height / 43.4, horizontal: width / 91.06),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 250,
                                  decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                      )
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Select Zone",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      DropdownButton(
                                        value: zoneNameController.text,
                                        isExpanded: true,
                                        underline: Container(),
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items: zonesList.map((items) {
                                          return DropdownMenuItem(
                                            value: items.zoneName!,
                                            child: Text(items.zoneName!),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setState(() {
                                            zoneNameController.text = newValue!;
                                            if(zoneNameController.text != 'Select Zone'){
                                              for(int i=0; i< zonesList.length; i++){
                                                if(zonesList[i].zoneName!.toLowerCase() == zoneNameController.text.toLowerCase()){
                                                  zoneIdController.text = zonesList[i].zoneId!;
                                                  leaderNameController.text = zonesList[i].leaderName!;
                                                  leaderPhoneController.text = zonesList[i].leaderPhone!;
                                                }
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 40),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Zone ID",
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
                                        width: 200,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                          child: TextFormField(
                                            controller: zoneIdController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Task Name",
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
                                    width: 300,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                      child: TextFormField(
                                        controller: taskNameController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Task Description",
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
                                    height: 100,
                                    width: 300,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                      child: TextFormField(
                                        maxLines: null,
                                        controller: taskDescriptionController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Task Due Date (if applicable)",
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
                                    width: 300,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: taskDueDateController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                        onTap: () async {
                                          DateTime? pickedDate = await Constants().futureDatePicker(context);
                                          if (pickedDate != null) {
                                            setState(() {
                                              taskDueDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            Expanded(child: Container()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (zoneNameController.text != "Select Zone" &&
                                        zoneNameController.text != "" &&
                                        zoneIdController.text != "" &&
                                        taskNameController.text != "" &&
                                        taskDescriptionController.text != "")
                                    {
                                      Response response = await ZonalActivitiesFireCrud.addTask(
                                        task: TaskModel(
                                          zoneId: zoneIdController.text,
                                          zoneName: zoneNameController.text,
                                          id: '',
                                          leaderName: leaderNameController.text,
                                          leaderPhone: leaderPhoneController.text,
                                          submittedDate: '',
                                          submittedTime: '',
                                          timestamp: DateTime.now().millisecondsSinceEpoch,
                                          date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                          feedback: '',
                                          status: 'Pending',
                                          taskDescription: taskDescriptionController.text,
                                          taskDueDate: taskDueDateController.text,
                                          taskName: taskNameController.text,
                                          time: DateFormat('hh:mm aa').format(DateTime.now()),
                                        )
                                      );
                                      if (response.code == 200) {
                                        await CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: "Task assigned successfully!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                        clearTextControllers();
                                        setState(() {
                                          currentTab = 'View';
                                        });
                                      } else {
                                        await CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: "Failed to Assign Task!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  },
                                  child: Container(
                                    height: height / 16.6,
                                    width: width*0.1,
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
                                      padding: EdgeInsets.symmetric(horizontal: width / 190.66),
                                      child: Center(
                                        child: KText(
                                          text: "Assign Task",
                                          style: GoogleFonts.openSans(
                                            color: Colors.white,
                                            fontSize: 15,
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
                  ],
                ),
              )
                  : currentTab.toUpperCase() == "VIEW"
                  ? Column(
                children: [
                  FutureBuilder(
                    future: getGraphData(),
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
                                                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                                              });
                                            },
                                          ),
                                          borderData: FlBorderData(
                                            show: false,
                                          ),
                                          sectionsSpace: 0,
                                          centerSpaceRadius: 50,
                                          sections: showingSections(snapshot.data!.pieChartModelList),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      width: 230,
                                      child: SingleChildScrollView(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: snapshot.data!.pieChartModelList.map((e) => Indicator(color: e.color,text: e.name,isSquare: true)).toList(),
                                          // children: <Widget>[
                                          //   Indicator(
                                          //     color: Colors.blue,
                                          //     text: 'Users',
                                          //     isSquare: true,
                                          //   ),
                                          //   SizedBox(
                                          //     height: 4,
                                          //   ),
                                          //   Indicator(
                                          //     color: Colors.red,
                                          //     text: 'Members',
                                          //     isSquare: true,
                                          //   ),
                                          //   SizedBox(
                                          //     height: 4,
                                          //   ),
                                          //   Indicator(
                                          //     color: Colors.green,
                                          //     text: 'Students',
                                          //     isSquare: true,
                                          //   ),
                                          //   SizedBox(
                                          //     height: 4,
                                          //   ),
                                          //   Indicator(
                                          //     color: Colors.orange,
                                          //     text: 'Pastors',
                                          //     isSquare: true,
                                          //   ),
                                          //   SizedBox(
                                          //     height: 4,
                                          //   ),
                                          //   Indicator(
                                          //     color: Colors.pink,
                                          //     text: 'Church Staffs',
                                          //     isSquare: true,
                                          //   ),
                                          //   SizedBox(
                                          //     height: 4,
                                          //   ),
                                          //   Indicator(
                                          //     color: Colors.deepPurple,
                                          //     text: 'Choir Members',
                                          //     isSquare: true,
                                          //   ),
                                          //   SizedBox(
                                          //     height: 18,
                                          //   ),
                                          // ],
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              ),
                              SizedBox(width: 20,),
                              Container(
                                  width: 450,
                                  child: Container(
                                    height: 250,
                                    child: sfc.SfCartesianChart(
                                        primaryXAxis: sfc.CategoryAxis(),
                                        title: sfc.ChartTitle(
                                            text: 'Graphical View',
                                            textStyle: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                            alignment: sfc.ChartAlignment.near
                                        ),
                                        legend: sfc.Legend(isVisible: true),
                                        tooltipBehavior: _tooltipBehavior,
                                        series: <sfc.LineSeries<SalesData1, String>>[
                                          sfc.LineSeries<SalesData1, String>(
                                            name: "",
                                            dataSource: snapshot.data!.graphModelList,
                                            xValueMapper: (SalesData1 sales, _) => sales.year,
                                            yValueMapper: (SalesData1 sales, _) => sales.sales,
                                            // Enable data label
                                            dataLabelSettings: sfc.DataLabelSettings(isVisible: true),
                                            color: Constants().primaryAppColor,
                                            width: 5,
                                            animationDuration: 3000,
                                          )
                                        ]
                                    ),
                                  )
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
                                            text: 'Graphical View',
                                            textStyle: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                            alignment: sfc.ChartAlignment.near
                                        ),
                                        legend: sfc.Legend(isVisible: true),
                                        tooltipBehavior: _tooltipBehavior,
                                        series: <sfc.LineSeries<SalesData1, String>>[
                                          sfc.LineSeries<SalesData1, String>(
                                            name: "",
                                            dataSource: [],
                                            xValueMapper: (SalesData1 sales, _) => sales.year,
                                            yValueMapper: (SalesData1 sales, _) => sales.sales,
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
                        ],
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: SizedBox(
                      height: 200,
                      width: double.infinity,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: "Best Performing Leaders",
                            style: GoogleFonts.openSans(
                              fontSize: width/97.571,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Expanded(
                            child: ListView.builder(
                              itemCount: leaderName.length,
                              itemBuilder: (ctx, i){
                                return Card(
                                  child: ListTile(
                                    leading: Text("${i + 1}", style: GoogleFonts.openSans(
                                      fontSize: width/97.571,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    title: Text(leaderName[i], style: GoogleFonts.openSans(
                                      fontSize: width/97.571,
                                      fontWeight: FontWeight.w700,
                                    ),),
                                  ),
                                );
                              },
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      height: height * 0.85,
                      width: double.infinity,
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
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                              labelPadding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              splashBorderRadius: BorderRadius.circular(30),
                              automaticIndicatorColorAdjustment: true,
                              dividerColor: Colors.transparent,
                              controller: _tabController,
                              indicator: BoxDecoration(
                                color: Constants().primaryAppColor,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              labelColor: Colors.black,
                              tabs: [
                                Tab(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      "Overall Reports",
                                      style: GoogleFonts.openSans(
                                        color: currentTabIndex == 0
                                            ? Constants().btnTextColor
                                            : Colors.black,
                                        fontSize: width/97.57142857142857,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Padding(
                                    padding:
                                    const EdgeInsets.symmetric(horizontal: 8),
                                    child: Text(
                                      "Zonewise Reports",
                                      style: GoogleFonts.openSans(
                                        color: currentTabIndex == 1
                                            ? Constants().btnTextColor
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
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: TabBarView(
                                dragStartBehavior: DragStartBehavior.down,
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _tabController,
                                children: [
                                  buildOverAllReports(),
                                  buildZoneWiseReports(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ) : Container()
            ],
          ),
        ),
      ),
    );
  }

  buildOverAllReports(){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder(
      stream: ZonalActivitiesFireCrud.fetchOverAllTasks(),
      builder: (context, snap) {
        if(snap.hasData){
          List<TaskModel> tasks = snap.data!;
          return Container(
            child: Column(
              children: [
                SizedBox(height: height/65.1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                  child: SizedBox(
                    child: Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Row(
                        children: [
                          SizedBox(
                            width: width/39.02857142857143,
                            child: KText(
                              text: "SL.",
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: KText(
                              text: "Zone Name",
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: KText(
                              text: "Leader Name",
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: KText(
                              text: "Assigned Date/Time",
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: Center(
                              child: KText(
                                text: "Status",
                                style: GoogleFonts.poppins(
                                  fontSize: width/105.0769230769231,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 150,
                            child: KText(
                              text: "Submitted Date/Time",
                              style: GoogleFonts.poppins(
                                fontSize: width/105.0769230769231,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 250,
                            child: Center(
                              child: KText(
                                text: "Actions",
                                style: GoogleFonts.poppins(
                                  fontSize: width/105.0769230769231,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height/65.1),
                Expanded(
                  child: ListView.builder(
                    itemCount: tasks.length,
                    itemBuilder: (ctx, i){
                      TaskModel task = tasks[i];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                        child: SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: width/39.02857142857143,
                                  child: KText(
                                    text: (i+1).toString(),
                                    style: GoogleFonts.poppins(
                                      fontSize: width/105.0769230769231,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: KText(
                                    text: task.zoneName!,
                                    style: GoogleFonts.poppins(
                                      fontSize: width/105.0769230769231,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: KText(
                                    text: task.leaderName!,
                                    style: GoogleFonts.poppins(
                                      fontSize: width/105.0769230769231,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: KText(
                                    text: "${task.date!}  ${task.time!}",
                                    style: GoogleFonts.poppins(
                                      fontSize: width/105.0769230769231,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: Center(
                                    child: KText(
                                      text: task.status!,
                                      style: GoogleFonts.poppins(
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 150,
                                  child: KText(
                                    text: "${task.submittedDate!}  ${task.submittedTime!}",
                                    style: GoogleFonts.poppins(
                                      fontSize: width/105.0769230769231,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 250,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          viewTaskPopup(task);
                                        },
                                        child: Container(
                                          height: height / 26.04,
                                          decoration: BoxDecoration(
                                            color: Color(0xff2baae4),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(1, 2),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width / 227.66),
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
                                      SizedBox(width: width / 273.2),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            zoneNameController.text = task.zoneName!;
                                            zoneIdController.text = task.zoneId!;
                                            taskNameController.text = task.taskName!;
                                            taskDescriptionController.text = task.taskDescription!;
                                            taskDueDateController.text = task.taskDueDate!;
                                          });
                                          editTaskPopUp(task);
                                        },
                                        child: Container(
                                          height: height /26.04,
                                          decoration:BoxDecoration(
                                            color: Color(
                                                0xffff9700),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors
                                                    .black26,
                                                offset:
                                                Offset(
                                                    1,
                                                    2),
                                                blurRadius:
                                                3,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                width /
                                                    227.66),
                                            child: Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceAround,
                                                children: [
                                                  Icon(
                                                      Icons.add,
                                                      color: Colors.white,
                                                      size: width / 91.066),
                                                  KText(
                                                    text:
                                                    "Edit",
                                                    style: GoogleFonts
                                                        .openSans(
                                                      color:
                                                      Colors.white,
                                                      fontSize:
                                                      width / 136.6,
                                                      fontWeight:
                                                      FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width: width / 273.2),
                                      InkWell(
                                        onTap: () {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.info,
                                              text: "${task.taskName} will be deleted",
                                              title:
                                              "Delete this Record?",
                                              width: width * 0.4,
                                              backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                              showCancelBtn: true,
                                              cancelBtnText: 'Cancel',
                                              cancelBtnTextStyle: TextStyle(
                                                  color: Colors.black,
                                              ),
                                              onConfirmBtnTap: () async {
                                                FirebaseFirestore.instance.collection('Tasks').doc(task.id).delete();
                                              });
                                        },
                                        child: Container(
                                          height: height /
                                              26.04,
                                          decoration:
                                          BoxDecoration(
                                            color: Color(
                                                0xfff44236),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors
                                                    .black26,
                                                offset:
                                                Offset(
                                                    1,
                                                    2),
                                                blurRadius:
                                                3,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets
                                                .symmetric(
                                                horizontal:
                                                width /
                                                    227.66),
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
                                                      size: width /
                                                          91.066),
                                                  KText(
                                                    text:
                                                    "Delete",
                                                    style: GoogleFonts
                                                        .openSans(
                                                      color:
                                                      Colors.white,
                                                      fontSize:
                                                      width / 136.6,
                                                      fontWeight:
                                                      FontWeight.bold,
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
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      }
    );
  }

  buildZoneWiseReports(){
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return StreamBuilder(
        stream: ZonalActivitiesFireCrud.fetchOverAllTasks(),
        builder: (context, snap) {
          if(snap.hasData){
            List<TaskModel> tasks = [];
            List<TaskModel> tasks1 = snap.data!;
            if(searchZoneIdController.text != ""){
              tasks1.forEach((element) {
                if(element.zoneId == searchZoneIdController.text){
                  tasks.add(element);
                }
              });
            }
            return Container(
              child: Column(
                children: [
                  SizedBox(height: height/65.1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                    child: Row(
                      children: [
                        SizedBox(
                          width: width / 4.553,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Zone Name",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width / 105.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              DropdownButton(
                                value: searchZoneNameController.text,
                                isExpanded: true,
                                icon: Icon(Icons.keyboard_arrow_down),
                                items: zonesList.map((items) {
                                  return DropdownMenuItem(
                                    value: items.zoneName!,
                                    child: Text(items.zoneName!),
                                  );
                                }).toList(),
                                onChanged: (newValue) {
                                  setState(() {
                                    searchZoneNameController.text = newValue!;
                                    if(searchZoneNameController.text != 'Select Zone'){
                                      for(int i=0; i< zonesList.length; i++){
                                        if(zonesList[i].zoneName!.toLowerCase() == searchZoneNameController.text.toLowerCase()){
                                          searchZoneIdController.text = zonesList[i].zoneId!;
                                        }
                                      }
                                    }
                                  });
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: width / 68.3),
                        SizedBox(
                          width: width / 4.553,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Zone ID",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width / 105.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextFormField(
                                readOnly: true,
                                style: TextStyle(fontSize: width / 113.83),
                                controller: searchZoneIdController,
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: height/65.1),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                    child: SizedBox(
                      child: Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Row(
                          children: [
                            SizedBox(
                              width: width/39.02857142857143,
                              child: KText(
                                text: "SL.",
                                style: GoogleFonts.poppins(
                                  fontSize: width/105.0769230769231,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: KText(
                                text: "Zone Name",
                                style: GoogleFonts.poppins(
                                  fontSize: width/105.0769230769231,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: KText(
                                text: "Leader Name",
                                style: GoogleFonts.poppins(
                                  fontSize: width/105.0769230769231,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: KText(
                                text: "Assigned Date/Time",
                                style: GoogleFonts.poppins(
                                  fontSize: width/105.0769230769231,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: Center(
                                child: KText(
                                  text: "Status",
                                  style: GoogleFonts.poppins(
                                    fontSize: width/105.0769230769231,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: KText(
                                text: "Submitted Date/Time",
                                style: GoogleFonts.poppins(
                                  fontSize: width/105.0769230769231,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 250,
                              child: Center(
                                child: KText(
                                  text: "Actions",
                                  style: GoogleFonts.poppins(
                                    fontSize: width/105.0769230769231,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: height/65.1),
                  Expanded(
                    child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (ctx, i){
                        TaskModel task = tasks[i];
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15,vertical: 8),
                          child: SizedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width/39.02857142857143,
                                    child: KText(
                                      text: (i+1).toString(),
                                      style: GoogleFonts.poppins(
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: KText(
                                      text: task.zoneName!,
                                      style: GoogleFonts.poppins(
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: KText(
                                      text: task.leaderName!,
                                      style: GoogleFonts.poppins(
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: KText(
                                      text: "${task.date!}  ${task.time!}",
                                      style: GoogleFonts.poppins(
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Center(
                                      child: KText(
                                        text: task.status!,
                                        style: GoogleFonts.poppins(
                                          fontSize: width/105.0769230769231,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: KText(
                                      text: "${task.submittedDate!}  ${task.submittedTime!}",
                                      style: GoogleFonts.poppins(
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: 250,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          InkWell(
                                            onTap: () {
                                              viewTaskPopup(task);
                                            },
                                            child: Container(
                                              height: height / 26.04,
                                              decoration: BoxDecoration(
                                                color: Color(0xff2baae4),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black26,
                                                    offset: Offset(1, 2),
                                                    blurRadius: 3,
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(horizontal: width / 227.66),
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
                                          SizedBox(width: width / 273.2),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                zoneNameController.text = task.zoneName!;
                                                zoneIdController.text = task.zoneId!;
                                                taskNameController.text = task.taskName!;
                                                taskDescriptionController.text = task.taskDescription!;
                                                taskDueDateController.text = task.taskDueDate!;
                                              });
                                              editTaskPopUp(task);
                                            },
                                            child: Container(
                                              height: height /26.04,
                                              decoration:BoxDecoration(
                                                color: Color(
                                                    0xffff9700),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors
                                                        .black26,
                                                    offset:
                                                    Offset(
                                                        1,
                                                        2),
                                                    blurRadius:
                                                    3,
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    width /
                                                        227.66),
                                                child: Center(
                                                  child: Row(
                                                    mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                    children: [
                                                      Icon(
                                                          Icons.add,
                                                          color: Colors.white,
                                                          size: width / 91.066),
                                                      KText(
                                                        text:
                                                        "Edit",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color:
                                                          Colors.white,
                                                          fontSize:
                                                          width / 136.6,
                                                          fontWeight:
                                                          FontWeight.bold,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: width / 273.2),
                                          InkWell(
                                            onTap: () {
                                              CoolAlert.show(
                                                  context: context,
                                                  type: CoolAlertType.info,
                                                  text: "${task.taskName} will be deleted",
                                                  title:
                                                  "Delete this Record?",
                                                  width: width * 0.4,
                                                  backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                  showCancelBtn: true,
                                                  cancelBtnText: 'Cancel',
                                                  cancelBtnTextStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  onConfirmBtnTap: () async {
                                                    FirebaseFirestore.instance.collection('Tasks').doc(task.id).delete();
                                                  });
                                            },
                                            child: Container(
                                              height: height /
                                                  26.04,
                                              decoration:
                                              BoxDecoration(
                                                color: Color(
                                                    0xfff44236),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors
                                                        .black26,
                                                    offset:
                                                    Offset(
                                                        1,
                                                        2),
                                                    blurRadius:
                                                    3,
                                                  ),
                                                ],
                                              ),
                                              child: Padding(
                                                padding: EdgeInsets
                                                    .symmetric(
                                                    horizontal:
                                                    width /
                                                        227.66),
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
                                                          size: width /
                                                              91.066),
                                                      KText(
                                                        text:
                                                        "Delete",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color:
                                                          Colors.white,
                                                          fontSize:
                                                          width / 136.6,
                                                          fontWeight:
                                                          FontWeight.bold,
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
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        }
    );
  }

  viewTaskPopup(TaskModel task) {
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
                          task.taskName!,
                          style: GoogleFonts.openSans(
                            fontSize: width / 68.3,
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
                                          text: "Task Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: task.taskName!,
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
                                          text: "Task Description",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: task.taskDescription!,
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
                                          text: "Assigned Date/Time",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: "${task.date!} ${task.time!}",
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
                                          text: "Due Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: task.taskDueDate!,
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
                                          text: "Submitted Date/Time",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: "${task.submittedDate!} ${task.submittedTime!}",
                                        style: TextStyle(fontSize: width/97.571),
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
                                          text: "Zone Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: task.zoneName!,
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
                                          text: "Leader Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: task.leaderName!,
                                        style: TextStyle(fontSize: width/97.571),
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

  editTaskPopUp(TaskModel task) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setStat) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              height: height * 1.0,
              width: width,
              margin: EdgeInsets.symmetric(horizontal: width / 68.3, vertical: height / 32.55),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: width / 68.3, vertical: height / 81.375),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: "Edit Task",
                            style: GoogleFonts.openSans(
                              fontSize: width / 68.3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                              onTap:(){
                                clearTextControllers();
                                Navigator.pop(context);
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
                                      text: "Cancel",
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
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: height / 43.4, horizontal: width / 91.06),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 250,
                                  decoration:  BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                      )
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Select Zone",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      DropdownButton(
                                        value: zoneNameController.text,
                                        isExpanded: true,
                                        underline: Container(),
                                        icon: Icon(Icons.keyboard_arrow_down),
                                        items: zonesList.map((items) {
                                          return DropdownMenuItem(
                                            value: items.zoneName!,
                                            child: Text(items.zoneName!),
                                          );
                                        }).toList(),
                                        onChanged: (newValue) {
                                          setStat(() {
                                            zoneNameController.text = newValue!;
                                            if(zoneNameController.text != 'Select Zone'){
                                              for(int i=0; i< zonesList.length; i++){
                                                if(zonesList[i].zoneName!.toLowerCase() == zoneNameController.text.toLowerCase()){
                                                  zoneIdController.text = zonesList[i].zoneId!;
                                                  leaderPhoneController.text = zonesList[i].leaderPhone!;
                                                  leaderNameController.text = zonesList[i].leaderName!;
                                                }
                                              }
                                            }
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 40),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Zone ID",
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
                                        width: 200,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                          child: TextFormField(
                                            controller: zoneIdController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Task Name",
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
                                    width: 300,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                      child: TextFormField(
                                        controller: taskNameController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Task Description",
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
                                    height: 100,
                                    width: 300,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                      child: TextFormField(
                                        maxLines: null,
                                        controller: taskDescriptionController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Task Due Date (if applicable)",
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
                                    width: 300,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                      child: TextFormField(
                                        readOnly: true,
                                        controller: taskDueDateController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                        onTap: () async {
                                          DateTime? pickedDate = await Constants().datePicker(context);
                                          if (pickedDate != null) {
                                            setStat(() {
                                              taskDueDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            // Expanded(child: Container()),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (zoneNameController.text != "Select Zone" &&
                                        zoneNameController.text != "" &&
                                        zoneIdController.text != "" &&
                                        taskNameController.text != "" &&
                                        taskDescriptionController.text != "")
                                    {
                                      Response response = await ZonalActivitiesFireCrud.editTask(
                                          task: TaskModel(
                                            zoneId: zoneIdController.text,
                                            zoneName: zoneNameController.text,
                                            id: task.id,
                                            leaderName: leaderNameController.text,
                                            leaderPhone: leaderPhoneController.text,
                                            submittedDate: '',
                                            submittedTime: '',
                                            timestamp: DateTime.now().millisecondsSinceEpoch,
                                            date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                            feedback: '',
                                            status: task.status,
                                            taskDescription: taskDescriptionController.text,
                                            taskDueDate: taskDueDateController.text,
                                            taskName: taskNameController.text,
                                            time: DateFormat('hh:mm aa').format(DateTime.now()),
                                          )
                                      );
                                      if (response.code == 200) {
                                        await CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: "Task updated successfully!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                        clearTextControllers();
                                        setState(() {
                                          currentTab = 'View';
                                        });
                                        Navigator.pop(context);
                                      } else {
                                        await CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: "Failed to update Task!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                      }
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                    }
                                  },
                                  child: Container(
                                    height: height / 16.6,
                                    width: width*0.1,
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
                                      padding: EdgeInsets.symmetric(horizontal: width / 190.66),
                                      child: Center(
                                        child: KText(
                                          text: "Update Task",
                                          style: GoogleFonts.openSans(
                                            color: Colors.white,
                                            fontSize: 15,
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
                  ),
                ],
              ),
            )
          );
        });
      },
    );
  }

  Future<GraphModel> getGraphData() async {

    List<PieChartModel> dataList = [];
    List<SalesData1> dataList1 = [];


    var zoneDoc = await FirebaseFirestore.instance.collection('Zones').orderBy("timestamp").get();

    for(int z = 0; z < zoneDoc.docs.length; z++){
      var taskDoc = await FirebaseFirestore.instance.collection('Tasks').where("zoneId", isEqualTo: zoneDoc.docs[z].get("zoneId")).get();
      List<DocumentSnapshot> pendingTasks = [];
      List<DocumentSnapshot> completedTasks = [];
      PieChartModel piechart =  PieChartModel(
        pendingTasks: pendingTasks,
        completedTasks: completedTasks,
        color: Constants.colorsList[z],
        name: zoneDoc.docs[z].get("zoneName")
      );
      SalesData1 graph = SalesData1(zoneDoc.docs[z].get("zoneName"), 0.0);

      for(int t = 0; t < taskDoc.docs.length; t++){
        if(taskDoc.docs[t].get("status").toString().toLowerCase() == "pending"){
          pendingTasks.add(taskDoc.docs[t]);
        }
        if(taskDoc.docs[t].get("status").toString().toLowerCase() == "completed"){
          completedTasks.add(taskDoc.docs[t]);
          graph.sales++;
        }
      }


      dataList.add(piechart);
      dataList1.add(graph);
    }

    GraphModel graph = GraphModel(
      pieChartModelList: dataList,
        graphModelList: dataList1,
        // pieChartModelList: [
        //   PieChartModel(
        //     name: 'Zone 1',
        //     color: Colors.red,
        //     completedTasks: [],
        //     pendingTasks: [],
        //   ),
        //   PieChartModel(
        //     name: 'Zone 2',
        //     color: Colors.blue,
        //     completedTasks: [],
        //     pendingTasks: [],
        //   )
        // ]
    );
    return graph;
  }

  List<PieChartSectionData> showingSections(List<PieChartModel> pieChartDatas) {

    int totalTasksCount = 0;
    for(int d = 0; d < pieChartDatas.length; d++){
      totalTasksCount += pieChartDatas[d].completedTasks.length;
    }

    return List.generate(pieChartDatas.length, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 16.0 : 10.0;
      final radius = isTouched ? 60.0 : 50.0;
      return PieChartSectionData(
                color: pieChartDatas[i].color,
                value: (pieChartDatas[i].completedTasks.length / totalTasksCount *100),
                title: '${(pieChartDatas[i].completedTasks.length/totalTasksCount *100).toStringAsFixed(2)}%',
                radius: radius,
                titleStyle:  GoogleFonts.poppins(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w700,
                ),
      );
    });
  }

  final snackBar = SnackBar(

    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width:3),
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


class GraphModel{
  GraphModel({required this.pieChartModelList, required this.graphModelList});
  List<PieChartModel> pieChartModelList;
  List<SalesData1> graphModelList;

}


class PieChartModel{
  PieChartModel({required this.color,required this.name, required this.completedTasks, required this.pendingTasks});
  Color color;
  String name;
  List<DocumentSnapshot> completedTasks;
  List<DocumentSnapshot> pendingTasks;
}


class SalesData1 {
  SalesData1(this.year, this.sales);

  final String year;
  late double sales;
}
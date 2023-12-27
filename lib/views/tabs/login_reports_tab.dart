import 'dart:convert';
import 'package:flutter/gestures.dart';
import 'package:http/http.dart' as http;
import 'package:church_management_admin/models/response.dart';
import 'package:church_management_admin/services/greeting_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import '../../models/wish_template_model.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';

class LoginReportsTab extends StatefulWidget {
  const LoginReportsTab({super.key});

  @override
  State<LoginReportsTab> createState() => _LoginReportsTabState();
}

class _LoginReportsTabState extends State<LoginReportsTab> with SingleTickerProviderStateMixin  {

  TabController? _tabController;
  int currentTabIndex = 0;
  
  List<DocumentSnapshot> todayReports = [];
  List<DocumentSnapshot> allReports = [];
  TextEditingController searchDateController = TextEditingController();

  int iosUsersCount = 0;
  int androidUsersCount = 0;
  int webUsersCount = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setUsers();
    super.initState();
  }

  setUsers() async {
    var userDoc = await FirebaseFirestore.instance.collection('LoginReports').orderBy('timestamp',descending: true).get();
    userDoc.docs.forEach((element) {
        if(element.get("deviceOs").toString().toLowerCase() == "android"){
          setState(() {
            androidUsersCount++;
          });
        }else if(element.get("deviceOs").toString().toLowerCase() == "ios"){
          setState(() {
            iosUsersCount++;
          });
        }else{
          setState(() {
            webUsersCount++;
          });
        }
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
              child: KText(
                text: "Login Reports",
                style: GoogleFonts.openSans(
                    fontSize: width/52.53846153846154,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    height: height/4.06875,
                    width: width/4.06875,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(1, 2),
                            blurRadius: 3),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Constants().primaryAppColor,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.06,
                          width: size.width * 0.2,
                          child: Center(
                            child: KText(
                              text: "Total Android Users",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: width/56.916,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: width/4.06875,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width/105.076),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: androidUsersCount.toString(),
                                            style: GoogleFonts.inter(
                                              fontSize: width/41.393,
                                            ),
                                          ),
                                          KText(
                                            text: androidUsersCount.toString(),
                                            style: GoogleFonts.inter(
                                              fontSize: width/85.375,
                                              color:
                                              Color(0xff8A92A6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: width/68.3),
                                      Container(
                                        height: height/16.275,
                                        width: width/34.15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          color: Color(0xfff2d6d3),
                                        ),
                                        child: Center(
                                          child: Icon(
                                            Icons.android,
                                            color: Colors.red,
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height/54.25,
                                      horizontal: width/113.833
                                  ),
                                  child: LinearProgressIndicator(
                                    backgroundColor:
                                    Color(0xfff2d6d3),
                                    color: Color(0xffC03221),
                                    value: 10,
                                    semanticsLabel:
                                    'Linear progress indicator',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: height/4.06875,
                    width: width/4.06875,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(1, 2),
                            blurRadius: 3),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Constants().primaryAppColor,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.06,
                          width: size.width * 0.2,
                          child: Center(
                            child: KText(
                              text: "Total Ios Users",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: width/56.916,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: width/4.06875,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceEvenly,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width/105.076),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: iosUsersCount.toString(),
                                            style: GoogleFonts.inter(
                                              fontSize: width/41.393,
                                            ),
                                          ),
                                          KText(
                                            text: iosUsersCount.toString(),
                                            style: GoogleFonts.inter(
                                              fontSize: width/85.375,
                                              color:
                                              Color(0xff8A92A6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: width/68.3),
                                      Container(
                                        height: height/16.275,
                                        width: width/34.15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          color: Color(0xffcdebec),
                                        ),
                                        child: Center(
                                          child: Icon(
                                              Icons.apple,
                                              color: Color(0xff068B92)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height/54.25,
                                      horizontal: width/113.833
                                  ),
                                  child: LinearProgressIndicator(
                                    backgroundColor:
                                    Color(0xffcdebec),
                                    color: Color(0xff068B92),
                                    value: 4,
                                    semanticsLabel:
                                    'Linear progress indicator',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    height: height/4.06875,
                    width: width/4.06875,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(1, 2),
                            blurRadius: 3),
                      ],
                      borderRadius: BorderRadius.circular(10),
                      color: Constants().primaryAppColor,
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: size.height * 0.06,
                          width: size.width * 0.2,
                          child: Center(
                            child: KText(
                              text: "Total Web Users",
                              style: GoogleFonts.inter(
                                fontWeight: FontWeight.w600,
                                fontSize: width/56.916,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: width/4.06875,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceAround,
                              children: [
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width/105.076),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: webUsersCount.toString(),
                                            style: GoogleFonts.inter(
                                              fontSize: width/41.393,
                                            ),
                                          ),
                                          KText(
                                            text: webUsersCount.toString(),
                                            style: GoogleFonts.inter(
                                              fontSize: width/85.375,
                                              color:
                                              Color(0xff8A92A6),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(width: width/68.3),
                                      Container(
                                        height: height/16.275,
                                        width: width/34.15,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                          BorderRadius.circular(8),
                                          color: Color(0xffd1ecdd),
                                        ),
                                        child: Center(
                                          child: Icon(
                                              Icons.web,
                                              color: Color(0xff17904B)),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: height/54.25,
                                      horizontal: width/113.833
                                  ),
                                  child: LinearProgressIndicator(
                                    backgroundColor:
                                    Color(0xffd1ecdd),
                                    color: Color(0xff17904B),
                                    value: 20,
                                    semanticsLabel:
                                    'Linear progress indicator',
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: size.height * 0.85,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('LoginReports').orderBy('timestamp',descending: true).snapshots(),
                builder: (ctx, snap){
                  if(snap.hasData){
                    todayReports.clear();
                    allReports.clear();
                    snap.data!.docs.forEach((element) {
                      if(searchDateController.text != ""){
                        if(element.get("date").toString().startsWith(searchDateController.text)){
                          todayReports.add(element);
                          allReports.add(element);
                        }
                      }else{
                        allReports.add(element);
                        if(element.get("date") == DateFormat('dd-MM-yyyy').format(DateTime.now()).toString()){
                          todayReports.add(element);
                        }
                        if(element.get("deviceOs").toString().toLowerCase() == "android"){
                          androidUsersCount++;
                        }else if(element.get("deviceOs").toString().toLowerCase() == "ios"){
                          iosUsersCount++;
                        }else{
                          webUsersCount++;
                        }
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
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              height: height/10.85,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Constants().primaryAppColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                              ),
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
                                        "Today Reports",
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
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Constants().primaryAppColor,
                                // borderRadius: const BorderRadius.only(
                                //   topRight: Radius.circular(10),
                                //   topLeft: Radius.circular(10),
                                // ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Material(
                                          elevation: 2,
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            height: 40,
                                            width: 180,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(10),
                                            ),
                                            child: TextField(
                                              readOnly: true,
                                              controller: searchDateController,
                                              decoration: InputDecoration(
                                                hintStyle: TextStyle(color: Color(0xff00A99D)),
                                                hintText: "Select Date",
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                                              ),
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                await Constants().datePicker(context);
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    searchDateController.text = DateFormat('dd-MM-yyyy').format(pickedDate);
                                                  });
                                                }
                                              },
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width/17.075,
                                          child: Text(
                                            "SI.NO",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: width/80.35294117647059,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width/9.106666667,
                                          child: Text(
                                            "Device OS",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: width/80.35294117647059,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width/6.83,
                                          child: Text(
                                            "Device ID",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: width/80.35294117647059,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width/6.83,
                                          child: Text(
                                            "IP Address",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: width/80.35294117647059,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width/7.588888889,
                                          child: Text(
                                            "Location",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: width/80.35294117647059,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width/9.106666667,
                                          child: Text(
                                            "Date",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: width/80.35294117647059,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: width/17.075,
                                          child: Text(
                                            "Time",
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w700,
                                              fontSize: width/80.35294117647059,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: TabBarView(
                                dragStartBehavior: DragStartBehavior.down,
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _tabController,
                                children: [
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: ListView.builder(
                                      itemCount: allReports.length,
                                      itemBuilder: (ctx , i){
                                        var data = allReports[i];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          child: Container(
                                            //height: height/13.02,
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: width/17.075,
                                                  child: Text(
                                                    (i+1).toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106666667,
                                                  child: Text(
                                                    data.get("deviceOs"),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: Text(
                                                    data.get("deviceId"),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 12.0),
                                                    child: Text(
                                                      data.get("ip"),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/85.375,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/7.588888889,
                                                  child: Text(
                                                    data.get("location").toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106666667,
                                                  child: Text(
                                                    data.get("date").toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/17.075,
                                                  child: Text(
                                                    data.get("time").toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                  Container(
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                        bottomRight: Radius.circular(10),
                                        bottomLeft: Radius.circular(10),
                                      ),
                                    ),
                                    child: ListView.builder(
                                      itemCount: todayReports.length,
                                      itemBuilder: (ctx , i){
                                        var data = todayReports[i];
                                        return Padding(
                                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                          child: Container(
                                            //height: height/13.02,
                                            width: double.infinity,
                                            child: Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(
                                                  width: width/17.075,
                                                  child: Text(
                                                    (i+1).toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight.normal,
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106666667,
                                                  child: Text(
                                                    data.get("deviceOs"),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: Text(
                                                    data.get("deviceId"),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/6.83,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(right: 12.0),
                                                    child: Text(
                                                      data.get("ip"),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/85.375,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/7.588888889,
                                                  child: Text(
                                                    data.get("location").toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106666667,
                                                  child: Text(
                                                    data.get("date").toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/17.075,
                                                  child: Text(
                                                    data.get("time").toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/85.375,
                                                      color: Colors.black,
                                                    ),
                                                  ),
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
                            ),

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


}

import 'dart:convert';
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

class _LoginReportsTabState extends State<LoginReportsTab> {


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
            Container(
              height: size.height * 0.85,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('LoginReports').orderBy('timestamp',descending: true).snapshots(),
                builder: (ctx, snap){
                  if(snap.hasData){
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
                                  itemCount: snap.data!.docs.length,
                                  itemBuilder: (ctx , i){
                                    var data = snap.data!.docs[i];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: Container(
                                        height: height/13.02,
                                        width: double.infinity,
                                        child: Row(
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
                                              child: Text(
                                                data.get("ip"),
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/85.375,
                                                  color: Colors.black,
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


}

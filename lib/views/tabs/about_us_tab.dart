
import 'dart:io';

import 'package:church_management_admin/models/church_details_model.dart';
import 'package:church_management_admin/models/verses_model.dart';
import 'package:church_management_admin/services/attendance_record_firecrud.dart';
import 'package:church_management_admin/services/church_details_firecrud.dart';
import 'package:church_management_admin/views/tabs/terms_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';

import 'demo.dart';

class AboutUsTab extends StatefulWidget {
  AboutUsTab({super.key});

  @override
  State<AboutUsTab> createState() => _AboutUsTabState();
}

class _AboutUsTabState extends State<AboutUsTab> {

  bool isViewTerms = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: width / 170.75, vertical: height / 81.375),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: width/68.3),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: width / 170.75,
                      //vertical: height / 81.375,
                    ),
                    child: KText(
                      text: "About Us",
                      style: GoogleFonts.openSans(
                          fontSize: width/37.94,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: width / 170.75,
                   // vertical: height / 81.375,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Material(
                          elevation: 3,
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
                                Text("Version",style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                  fontSize: width/68.3,
                                ),),
                                ChoiceChip(
                                  label: Text("V1.0.0.1",style: TextStyle(color: Colors.white),),
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
                        SizedBox(height: height/32.55),
                        KText(
                          text: "AR Digital Solution",
                          style: GoogleFonts.openSans(
                              fontSize: width/54.64,
                              fontWeight: FontWeight.w600,
                              color: Colors.black,
                          ),
                        ),
                        SizedBox(height: height/32.55),
                        SizedBox(
                          height: height/3.17,
                          width: size.width / 2.5,
                          child: Column(
                            children: [
                              Text(
                                  "We are System Integrators who aim to increase the capabilities of people and the performance of the organizations we serve.",
                                style: GoogleFonts.poppins(
                                  color: Constants().primaryAppColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: width/68.3,
                                ),
                              ),
                              SizedBox(height: height/32.55),
                              Text(
                                "We aim to travel with our customers throughout their journey helping them to evolve their business and inspiring them to redefine their current business mode",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontWeight: FontWeight.w400,
                                  fontSize: width/75.88888888888889,
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                    Container(
                      height: height/1.302,
                      width: size.width / 2.5,
                      child: Center(
                        child: Container(
                          child: Lottie.asset(
                            height: height/1.302,
                            "assets/about_us.json",
                          ),
                        ),
                      )
                    )
                  ],
                ),
              ),
              //SizedBox(height: height/65.1),
              Row(
                children: [
                  SizedBox(width: width/34.15),
                  InkWell(
                    onTap: () async {
                      // setState(() {
                      //   isViewTerms = true;
                      // });
                      Navigator.push(context, MaterialPageRoute(builder: (ctx) => const TermsPage()));
                    },
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        width: 300,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border:Border.all(color: Constants().primaryAppColor,)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 30,
                                    width: 30,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/tandc.png"
                                            )
                                        )
                                    ),
                                  ),
                                  SizedBox(width: width/136.6),
                                  Text(
                                    "Terms & Conditions",
                                    style: GoogleFonts.poppins(
                                      color: Colors.black45,
                                      fontSize: width /97.57142857142857,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height/65.1),
              SizedBox(height: height/65.1),
              SizedBox(height: height/65.1),
              Row(
                children: [
                  SizedBox(width: width/34.15),
                  Material(
                    elevation: 3,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          border:Border.all(color: Constants().primaryAppColor,)
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Help Desk :",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: height/65.1),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: height/9.3,
                                  width: width/19.51428571428571,
                                  decoration: BoxDecoration(
                                      image: DecorationImage(
                                          image: AssetImage(
                                              "assets/help_desk.png"
                                          )
                                      )
                                  ),
                                ),
                                SizedBox(width: width/136.6),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.phone,color: Constants().primaryAppColor,),
                                        SizedBox(width: width/136.6),
                                        Card("+919884890121")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(CupertinoIcons.globe,color: Constants().primaryAppColor,),
                                        SizedBox(width: width/136.6),
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
                                            child: Card("http://ardigitalsolutions.co/")
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Icon(Icons.alternate_email,color: Constants().primaryAppColor,),
                                        SizedBox(width: width/136.6),
                                       Card("satishkumar@ardigitalsolutions.co"),
                                      ],
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: height/65.1),
              Center(
                child: Column(
                  children: [
                    Text(
                      "--Developed By--\n@ 2023 by AR Digital Solutions",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      )
    );
  }

  Widget Card(String value){
    double width = MediaQuery.of(context).size.width;
    return Material(
      elevation: 0,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(30),
        bottomRight: Radius.circular(30),
      ),
      child: Container(
        width: 300,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(10),
            bottomRight: Radius.circular(10),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Text(
                value,
                style: GoogleFonts.poppins(
                  color: Colors.black45,
                  fontSize: width /97.57142857142857,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


}

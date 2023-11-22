import 'dart:html';
import 'dart:typed_data';
import 'package:church_management_admin/models/user_model.dart';
import 'package:church_management_admin/services/user_firecrud.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';
import '../prints/blood_requirement_print.dart';

class BloodRequirementTab extends StatefulWidget {
  BloodRequirementTab({super.key});

  @override
  State<BloodRequirementTab> createState() => _BloodRequirementTabState();
}

class _BloodRequirementTabState extends State<BloodRequirementTab> {

  String dropdownValue = 'Select Blood Group';
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
              child: KText(
                text: "Blood Requirement",
                style: GoogleFonts.openSans(
                    fontSize: width/52.538,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            dropdownValue == "Select Blood Group" ?
            StreamBuilder(
              stream: UserFireCrud.fetchUsers(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<UserModel> users = snapshot.data!;
                  return Container(
                    width: width/1.2418,
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
                            padding: EdgeInsets.symmetric(
                               horizontal: width/68.3, vertical: height/81.375),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "Blood Group List",
                                  style: GoogleFonts.openSans(
                                  fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
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
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.symmetric(horizontal: width/68.3,
                              vertical: height/32.55),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      generateBloodRequirementPdf(PdfPageFormat.letter, users,false);
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
                                            horizontal: width/227.66),
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
                                  SizedBox(width:width/13.66),
                                  InkWell(
                                    onTap: () {
                                      copyToClipBoard(users);
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
                                            horizontal: width/227.66),
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
                                  SizedBox(width:width/13.66),
                                  InkWell(
                                    onTap: () async {
                                      var data = await generateBloodRequirementPdf(PdfPageFormat.letter, users, true);
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
                                            horizontal: width/227.66),
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
                                  SizedBox(width:width/13.66),
                                  InkWell(
                                    onTap: () {
                                      convertToCsv(users);
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
                                            horizontal: width/227.66),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Icon(
                                                  Icons.file_copy_rounded,
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
                              SizedBox(height:height/32.55),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Select Blood Group"),
                                  SizedBox(
                                   height:height/13.02,
                                    child: DropdownButton(
                                      value: dropdownValue,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      items: ["Select Blood Group", "AB+", "AB-","O+","O-","A+","A-","B+","B-"]
                                          .map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        if(newValue != "Select Role") {
                                          setState(() {
                                            dropdownValue = newValue!;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:width/13.66,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/6.83,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                           fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/6.83,
                                        child: KText(
                                          text: "Phone",
                                          style: GoogleFonts.poppins(
                                           fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/6.83,
                                        child: KText(
                                          text: "Blood Group",
                                          style: GoogleFonts.poppins(
                                           fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/5.464,
                                        child: KText(
                                          text: "Address",
                                          style: GoogleFonts.poppins(
                                           fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height:height/65.1),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                     height:height/10.85,
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
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width:width/13.66,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/6.83,
                                            child: KText(
                                              text: "${users[i].firstName!} ${users[i].lastName!}",
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/6.83,
                                            child: KText(
                                              text: users[i].phone!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/6.83,
                                            child: KText(
                                              text: users[i].bloodGroup!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/5.464,
                                            child: KText(
                                              text: users[i].address!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height:height/65.1),
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
              stream: UserFireCrud.fetchUsersWithBlood(dropdownValue),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<UserModel> users = snapshot.data!;
                  return Container(
                    width: width/1.2418,
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
                            padding: EdgeInsets.symmetric(
                               horizontal: width/68.3, vertical: height/81.375),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "Blood Group List",
                                  style: GoogleFonts.openSans(
                                  fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
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
                                    onTap: () {
                                      generateBloodRequirementPdf(PdfPageFormat.letter, users,false);
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
                                            horizontal: width/227.66),
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
                                  SizedBox(width:width/13.66),
                                  InkWell(
                                    onTap: () {
                                      copyToClipBoard(users);
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
                                            horizontal: width/227.66),
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
                                  SizedBox(width:width/13.66),
                                  InkWell(
                                    onTap: () async {
                                      var data = await generateBloodRequirementPdf(PdfPageFormat.letter, users, true);
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
                                            horizontal: width/227.66),
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
                                  SizedBox(width:width/13.66),
                                  InkWell(
                                    onTap: () {
                                      convertToCsv(users);
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
                                            horizontal: width/227.66),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              Icon(
                                                  Icons.file_copy_rounded,
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
                              SizedBox(height:height/32.55),
                              InkWell(
                                onTap: (){
                                  setState(() {
                                    dropdownValue = "Select Blood Group";
                                  });
                                },
                                child: Container(
                                  height:height/18.6,
                                  width: width/15.177,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "Clear Filter",
                                      style: GoogleFonts.openSans(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height:height/21.7),
                              SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width:width/13.66,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/6.83,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                           fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/6.83,
                                        child: KText(
                                          text: "Phone",
                                          style: GoogleFonts.poppins(
                                           fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/6.83,
                                        child: KText(
                                          text: "Blood Group",
                                          style: GoogleFonts.poppins(
                                           fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/5.464,
                                        child: KText(
                                          text: "Address",
                                          style: GoogleFonts.poppins(
                                           fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(height:height/65.1),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                     height:height/10.85,
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
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width:width/13.66,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/6.83,
                                            child: KText(
                                              text: "${users[i].firstName!} ${users[i].lastName!}",
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/6.83,
                                            child: KText(
                                              text: users[i].phone!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/6.83,
                                            child: KText(
                                              text: users[i].bloodGroup!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/5.464,
                                            child: KText(
                                              text: users[i].address!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight:
                                                FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                              SizedBox(height:height/65.1),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ),
            SizedBox(height: size.height * 0.04),
            const DeveloperCardWidget(),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }

  convertToCsv(List<UserModel> users) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Name");
    row.add("Phone");
    row.add("Blood Group");
    row.add("Address");
    rows.add(row);
    for (int i = 0; i < users.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("${users[i].firstName!} ${users[i].lastName!}");
      row.add(users[i].phone!);
      row.add(users[i].bloodGroup!);
      row.add(users[i].address!);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows);
    saveCsvToFile(csv);
  }

  void saveCsvToFile(csvString) async {
    final blob = Blob([Uint8List.fromList(csvString.codeUnits)]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "BloodGroupList.csv")
      ..click();
    Url.revokeObjectUrl(url);
  }

  void savePdfToFile(data) async {
    final blob = Blob([data],'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "BloodGroupList.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<UserModel> users) async  {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Name");
    row.add("    ");
    row.add("Phone");
    row.add("    ");
    row.add("Blood Group");
    row.add("    ");
    row.add("Address");
    rows.add(row);
    for (int i = 0; i < users.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add(users[i].firstName! + users[i].lastName!);
      row.add("       ");
      row.add(users[i].phone);
      row.add("       ");
      row.add(users[i].bloodGroup);
      row.add("       ");
      row.add(users[i].address);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows,fieldDelimiter: null,eol: null,textEndDelimiter: null,delimitAllFields: false,textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",","")));
  }
}

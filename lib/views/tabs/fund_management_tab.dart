import 'dart:convert';
import 'dart:typed_data';

import 'package:church_management_admin/constants.dart';
import 'package:church_management_admin/models/fund_management_model.dart';
import 'package:church_management_admin/models/fund_model.dart';
import 'package:church_management_admin/services/fund_manage_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';
import 'dart:html';

class FundManagementTab extends StatefulWidget {
  FundManagementTab({super.key});

  @override
  State<FundManagementTab> createState() => _FundManagementTabState();
}

class _FundManagementTabState extends State<FundManagementTab>
    with TickerProviderStateMixin {
  TextEditingController dateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController verifierController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  TextEditingController recordTypeController = TextEditingController(text: "Select Type");

  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  DateTime? dateRangeStart;
  DateTime? dateRangeEnd;
  bool isFiltered = false;

  File? profileImage;
  File? documentForUpload;
  var uploadedImage;
  String? selectedImg;
  String docname = "";

  String currentTab = 'View';

  setDateTime() async {
    setState(() {
      dateController.text = formatter.format(DateTime.now());
    });
  }

  selectImage(){
    InputElement input = FileUploadInputElement()
    as InputElement
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

  selectDocument(){
    InputElement input = FileUploadInputElement()
    as InputElement
      ..accept = '/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      FileReader reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          documentForUpload = file;
          docname = file.name;
        });
      });
      setState(() {});
    });
  }

  @override
  void initState() {
    setDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: width/68.3,
        vertical: height/32.55
      ),
      child: SingleChildScrollView(
        child: StreamBuilder(
          stream: FundManageFireCrud.fetchTotalFunds(),
          builder: (ctx, snapshot) {
            if (snapshot.hasError) {
              return Container();
            } else if (snapshot.hasData) {
              FundModel totalFunds = snapshot.data!.first;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "FUND MANAGEMENT",
                          style: GoogleFonts.openSans(
                            fontSize: width/42.6875,
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
                                    text: currentTab.toUpperCase() == "VIEW" ? "Add New Record" : "View Records",
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
                  SizedBox(height: size.height * 0.03),
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
                                    text: "Total Receivable",
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
                                                  text: totalFunds.totalCollect!
                                                      .toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: width/41.393,
                                                  ),
                                                ),
                                                KText(
                                                  text: totalFunds.totalCollect!
                                                      .toString(),
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
                                                  Icons.arrow_upward_outlined,
                                                  color: Color(0xffC03221),
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
                                    text: "Total Expense",
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
                                                  text: totalFunds.totalSpend!
                                                      .toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: width/41.393,
                                                  ),
                                                ),
                                                KText(
                                                  text: totalFunds.totalSpend!
                                                      .toString(),
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
                                                    Icons.arrow_upward_outlined,
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
                                    text: "Current Balance",
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
                                                  text: totalFunds
                                                      .currentBalance!
                                                      .toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: width/41.393,
                                                  ),
                                                ),
                                                KText(
                                                  text: totalFunds
                                                      .currentBalance!
                                                      .toString(),
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
                                                    Icons.arrow_upward_outlined,
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
                  SizedBox(height: size.height * 0.06),
                  currentTab.toUpperCase() == "ADD"
                      ? Container(
                    width: double.infinity,
                    margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black26,
                            offset: Offset(1, 2),
                            blurRadius: 3),
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
                                  text: "ADD NEW RECORD",
                                  style: GoogleFonts.openSans(
                                    fontSize:  width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (verifierController.text != "" &&
                                        amountController.text != "" &&
                                        recordTypeController.text != "Select Type" &&
                                        sourceController.text != "") {
                                      Response response = await FundManageFireCrud.addFund(
                                        image: profileImage, remarks:remarksController.text,
                                        document: documentForUpload,
                                        totalCollect: totalFunds.totalCollect!,
                                        totalSpend: totalFunds.totalSpend!,
                                        currentBalance: totalFunds.currentBalance!,
                                        amount: double.parse(amountController.text),
                                        verifier: verifierController.text,
                                        source: sourceController.text,
                                        date: dateController.text,
                                        recordType: recordTypeController.text,
                                      );
                                      if (response.code == 200) {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text:
                                                "Fund created successfully!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                        setState(() {
                                          currentTab = 'View';
                                          verifierController.text = "";
                                          amountController.text = "";
                                          remarksController.text = "";
                                          recordTypeController.text =
                                              "Select Type";
                                          sourceController.text = "";
                                          uploadedImage = null;
                                          profileImage = null;
                                          docname = "";
                                          documentForUpload = null;
                                        });
                                      } else {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: "Failed to Create Fund!",
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
                                      padding: EdgeInsets.symmetric(
                                          horizontal:width/227.66),
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
                          height: size.height * 1.0,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xffF7FAFC),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "USER INFORMATION",
                                style: GoogleFonts.openSans(
                                  fontSize:width/105.07,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: height/65.1),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                              controller: dateController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none
                                              ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Amount *",
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
                                              controller: amountController,
                                              keyboardType: TextInputType.numberWithOptions(decimal: true),
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                                              ],
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Record Type *",
                                        style: GoogleFonts.openSans(
                                          fontSize: width/97.571,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: height/108.5),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 3,
                                              offset: Offset(2, 3),
                                            )
                                          ],
                                        ),
                                        child: DropdownButton(
                                          underline: Container(),
                                          value: recordTypeController.text,
                                          items: [
                                            "Select Type",
                                            "Receivable",
                                            "Expense"
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              recordTypeController.text =
                                                  newValue!;
                                            });
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: height/65.1),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Verifier *",
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
                                              controller: verifierController,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Source *",
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
                                              controller: sourceController,
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
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Remarks",
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
                                          height: height/3.255,
                                          width: width/2.732,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                            child: TextFormField(
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                              ],
                                              maxLines: null,
                                              controller: remarksController,
                                              decoration: InputDecoration(
                                                contentPadding: EdgeInsets.symmetric(vertical: height/65.1),
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
                              SizedBox(height: height/21.7),
                              Center(
                                child: Container(
                                  height: height/3.829,
                                  width: width/3.902,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants().primaryAppColor,
                                          width: 2),
                                      image: uploadedImage != null
                                          ? DecorationImage(
                                        fit: BoxFit.fill,
                                        image: MemoryImage(
                                          Uint8List.fromList(
                                            base64Decode(uploadedImage!.split(',').last),
                                          ),
                                        ),
                                      )
                                          : null),
                                  child: uploadedImage == null
                                      ? Center(
                                    child: Icon(
                                      Icons.cloud_upload,
                                      size: width/8.5375,
                                      color: Colors.grey,
                                    ),
                                  ) : null,
                                ),
                              ),
                              SizedBox(height: height/65.1),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: selectImage,
                                    child: Container(
                                     height:height/18.6,
                                      width: size.width * 0.23,
                                      color: Constants().primaryAppColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo,
                                              color: Colors.white),
                                          SizedBox(width: width/136.6),
                                          KText(
                                            text: 'Select Picture',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                   height:height/18.6,
                                    width: size.width * 0.23,
                                  ),
                                  InkWell(
                                    onTap: selectDocument,
                                    child: Container(
                                     height:height/18.6,
                                      width: size.width * 0.23,
                                      color: Constants().primaryAppColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.file_copy,
                                              color: Colors.white),
                                          SizedBox(width: width/136.6),
                                          KText(
                                            text: docname == "" ? 'Select Document' : docname,
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                      : currentTab.toUpperCase() == "VIEW" ? isFiltered ?
                  StreamBuilder(
                          stream: recordTypeController.text != "Select Type" ? FundManageFireCrud.fetchFundsWithFilter1(
                              dateRangeStart!,
                              dateRangeEnd!,
                              recordTypeController.text) : FundManageFireCrud.fetchFundsWithFilter(
                              dateRangeStart!,
                              dateRangeEnd!),
                          builder: (ctx, snapshot) {
                            if (snapshot.hasError) {
                              return Container();
                            }
                            else if (snapshot.hasData) {
                              List<FundManagementModel> funds = snapshot.data!;
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                              text:
                                                  "Fund Records (${funds.length})",
                                              style: GoogleFonts.openSans(
                                                fontSize:  width/68.3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  isFiltered = false;
                                                  dateRangeStart = null;
                                                  dateRangeEnd = null;
                                                  recordTypeController.text = "Select Type";
                                                });
                                              },
                                              child: Container(
                                                height: height/16.275,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      offset: Offset(1, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets
                                                      .symmetric(horizontal:width/227.66),
                                                  child: Center(
                                                    child: KText(
                                                      text: "Clear Filter",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        fontSize: width/97.571,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                      height: size.height * 0.7 >
                                          70 + funds.length * 60
                                          ? 70 + funds.length * 60
                                          : size.height * 0.7,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          )),
                                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: width/17.075,
                                                  child: KText(
                                                    text: "No.",
                                                    style:
                                                    GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/136.60,
                                                  child: KText(
                                                    text: "Date",
                                                    style:
                                                    GoogleFonts.poppins(
                                                      fontSize: width/113.83,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.757,
                                                  child: KText(
                                                    text: "Amount",
                                                    style:
                                                    GoogleFonts.poppins(
                                                      fontSize: width/113.83,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106,
                                                  child: KText(
                                                    text: "Verifier",
                                                    style:
                                                    GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106,
                                                  child: KText(
                                                    text: "Source",
                                                    style:
                                                    GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106,
                                                  child: KText(
                                                    text: "Record Type",
                                                    style:
                                                    GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106,
                                                  child: KText(
                                                    text: "Document",
                                                    style:
                                                    GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: height/65.1),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: funds.length,
                                              itemBuilder: (ctx, i) {
                                                return Container(
                                                  height: height/10.850,
                                                  width: double.infinity,
                                                  decoration:
                                                  BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                      top: BorderSide(
                                                        color:
                                                        Color(0xfff1f1f1),
                                                        width: 0.5,
                                                      ),
                                                      bottom: BorderSide(
                                                        color:
                                                        Color(0xfff1f1f1),
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: width/17.075,
                                                        child: KText(
                                                          text: (i + 1)
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/136.60,
                                                        child: KText(
                                                          text: funds[i].date!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/9.757,
                                                        child: KText(
                                                          text: funds[i]
                                                              .amount!
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/9.106,
                                                        child: KText(
                                                          text: funds[i]
                                                              .verifier!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/9.106,
                                                        child: KText(
                                                          text:
                                                          funds[i].source!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/9.106,
                                                        child: KText(
                                                          text: funds[i]
                                                              .recordType!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                            color: funds[i]
                                                                .recordType! ==
                                                                "Receivable"
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                          width: width/9.106,
                                                          child: InkWell(
                                                            onTap: () async {
                                                              final Uri toLaunch =
                                                              Uri.parse(funds[i].document!);
                                                              if (!await launchUrl(toLaunch,
                                                                mode: LaunchMode.externalApplication,
                                                              )) {
                                                                throw Exception('Could not launch $toLaunch');
                                                              }
                                                            },
                                                            child: Container(
                                                             height:height/18.6,
                                                              margin: EdgeInsets.symmetric(horizontal: 10,vertical: height/65.1),
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
                                                                    text: "Download",
                                                                    style: GoogleFonts.openSans(
                                                                      fontSize: width/113.83,
                                                                      fontWeight: FontWeight.bold,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                      ),
                                                    ],
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
                          stream: FundManageFireCrud.fetchFunds(),
                          builder: (ctx, snapshot) {
                            if (snapshot.hasError) {
                              return Container();
                            } else if (snapshot.hasData) {
                              List<FundManagementModel> funds = snapshot.data!;
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
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
                                              text:
                                                  "Fund Records (${funds.length})",
                                              style: GoogleFonts.openSans(
                                                fontSize:  width/68.3,
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
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      offset: Offset(1, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: EdgeInsets
                                                      .symmetric(horizontal:width/227.66),
                                                  child: Center(
                                                    child: KText(
                                                      text: "Filter",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        fontSize: width/97.571,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                      height: size.height * 0.7 >
                                              70 + funds.length * 60
                                          ? 70 + funds.length * 60
                                          : size.height * 0.7,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          )),
                                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: width/17.075,
                                                  child: KText(
                                                    text: "No.",
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/136.60,
                                                  child: KText(
                                                    text: "Date",
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize: width/113.83,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.757,
                                                  child: KText(
                                                    text: "Amount",
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize: width/113.83,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106,
                                                  child: KText(
                                                    text: "Verifier",
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106,
                                                  child: KText(
                                                    text: "Source",
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106,
                                                  child: KText(
                                                    text: "Record Type",
                                                    style:
                                                        GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106,
                                                  child: KText(
                                                    text: "Document",
                                                    style:
                                                    GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight:
                                                      FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(height: height/65.1),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: funds.length,
                                              itemBuilder: (ctx, i) {
                                                return Container(
                                                  height: height/10.850,
                                                  width: double.infinity,
                                                  decoration:
                                                      BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                      top: BorderSide(
                                                        color:
                                                            Color(0xfff1f1f1),
                                                        width: 0.5,
                                                      ),
                                                      bottom: BorderSide(
                                                        color:
                                                            Color(0xfff1f1f1),
                                                        width: 0.5,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: width/17.075,
                                                        child: KText(
                                                          text: (i + 1)
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/136.60,
                                                        child: KText(
                                                          text: funds[i].date!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/9.757,
                                                        child: KText(
                                                          text: funds[i]
                                                              .amount!
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/9.106,
                                                        child: KText(
                                                          text: funds[i]
                                                              .verifier!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/9.106,
                                                        child: KText(
                                                          text:
                                                              funds[i].source!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/9.106,
                                                        child: KText(
                                                          text: funds[i]
                                                              .recordType!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize:width/105.07,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                            color: funds[i]
                                                                        .recordType! ==
                                                                    "Receivable"
                                                                ? Colors.green
                                                                : Colors.red,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: width/9.106,
                                                        child: InkWell(
                                                          onTap: () async {
                                                            final Uri toLaunch =
                                                            Uri.parse(funds[i].document!);
                                                            if (!await launchUrl(toLaunch,
                                                              mode: LaunchMode.externalApplication,
                                                            )) {
                                                              throw Exception('Could not launch $toLaunch');
                                                            }
                                                          },
                                                          child: Container(
                                                           height:height/18.6,
                                                            margin: EdgeInsets.symmetric(horizontal: 10,vertical: height/65.1),
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
                                                                  text: "Download",
                                                                  style: GoogleFonts.openSans(
                                                                    fontSize: width/113.83,
                                                                    fontWeight: FontWeight.bold,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        )
                                                      ),
                                                    ],
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
              );
            }
            return Container(
              height: size.height,
              width: double.infinity,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ),
    );
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
                height: size.height * 0.5,
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
                                  width: width/15.177,
                                  child: KText(
                                    text: "Start Date",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/97.571,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: width/85.375),
                                Container(
                                  height: height/16.275,
                                  width: width/15.177,
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
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Color(0xff00A99D)),
                                      hintText: dateRangeStart != null ? "${dateRangeStart!.day}-${dateRangeStart!.month}-${dateRangeStart!.year}" : "",
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
                                  width: width/15.177,
                                  child: KText(
                                    text: "End Date",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/97.571,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                SizedBox(width: width/85.375),
                                Container(
                                  height: height/16.275,
                                  width: width/15.177,
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
                                    decoration: InputDecoration(
                                      hintStyle: TextStyle(color: Color(0xff00A99D)),
                                      hintText: dateRangeEnd != null ? "${dateRangeEnd!.day}-${dateRangeEnd!.month}-${dateRangeEnd!.year}" : "",
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                KText(
                                  text: "Record Type",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.571,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(width: width/85.375),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black26,
                                        blurRadius: 3,
                                        offset: Offset(2, 3),
                                      )
                                    ],
                                  ),
                                  child: DropdownButton(
                                    underline: Container(),
                                    value: recordTypeController.text,
                                    items: [
                                      "Select Type",
                                      "Receivable",
                                      "Expense"
                                    ].map((items) {
                                      return DropdownMenuItem(
                                        value: items,
                                        child: Text(items),
                                      );
                                    }).toList(),
                                    onChanged: (newValue) {
                                      setState(() {
                                        recordTypeController.text =
                                        newValue!;
                                      });
                                    },
                                  ),
                                )
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
}

import 'dart:convert';
import 'dart:typed_data';

import 'package:church_management_admin/constants.dart';
import 'package:church_management_admin/models/fund_management_model.dart';
import 'package:church_management_admin/models/fund_model.dart';
import 'package:church_management_admin/services/fund_manage_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';
import 'dart:html';

class FundManagementTab extends StatefulWidget {
  const FundManagementTab({super.key});

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
  TextEditingController recordTypeController =
      TextEditingController(text: "Select Type");

  final DateFormat formatter = DateFormat('yyyy-MM-dd');
  DateTime? dateRangeStart;
  DateTime? dateRangeEnd;
  bool isFiltered = false;

  File? profileImage;
  File? documentForUpload;
  var uploadedImage;
  String? selectedImg;
  String docname = "";

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
    return Padding(
      padding: const EdgeInsets.all(20.0),
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
                    padding: const EdgeInsets.all(8.0),
                    child: KText(
                      text: "FUND MANAGEMENT",
                      style: GoogleFonts.openSans(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: size.height * 0.03),
                  SizedBox(
                    width: double.infinity,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 160,
                          width: 320,
                          decoration: BoxDecoration(
                            boxShadow: const [
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
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: 320,
                                  decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13),
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
                                                    fontSize: 33,
                                                  ),
                                                ),
                                                KText(
                                                  text: totalFunds.totalCollect!
                                                      .toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff8A92A6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xfff2d6d3),
                                              ),
                                              child: const Center(
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
                                        padding: const EdgeInsets.all(12.0),
                                        child: LinearProgressIndicator(
                                          backgroundColor:
                                              const Color(0xfff2d6d3),
                                          color: const Color(0xffC03221),
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
                          height: 160,
                          width: 320,
                          decoration: BoxDecoration(
                            boxShadow: const [
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
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: 320,
                                  decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13),
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
                                                    fontSize: 33,
                                                  ),
                                                ),
                                                KText(
                                                  text: totalFunds.totalSpend!
                                                      .toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff8A92A6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xffcdebec),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                    Icons.arrow_upward_outlined,
                                                    color: Color(0xff068B92)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: LinearProgressIndicator(
                                          backgroundColor:
                                              const Color(0xffcdebec),
                                          color: const Color(0xff068B92),
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
                          height: 160,
                          width: 320,
                          decoration: BoxDecoration(
                            boxShadow: const [
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
                                      fontSize: 24,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  width: 320,
                                  decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 13),
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
                                                    fontSize: 33,
                                                  ),
                                                ),
                                                KText(
                                                  text: totalFunds
                                                      .currentBalance!
                                                      .toString(),
                                                  style: GoogleFonts.inter(
                                                    fontSize: 16,
                                                    color:
                                                        const Color(0xff8A92A6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(width: 20),
                                            Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                                color: const Color(0xffd1ecdd),
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                    Icons.arrow_upward_outlined,
                                                    color: Color(0xff17904B)),
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(12.0),
                                        child: LinearProgressIndicator(
                                          backgroundColor:
                                              const Color(0xffd1ecdd),
                                          color: const Color(0xff17904B),
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
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: const [
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "ADD NEW RECORD",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    if (verifierController.text != "" &&
                                        amountController.text != "" &&
                                        remarksController.text != "" &&
                                        recordTypeController.text !=
                                            "Select Type" &&
                                        sourceController.text != "") {
                                      Response response =
                                          await FundManageFireCrud.addFund(
                                        image: profileImage!,
                                            remarks:remarksController.text,
                                        document: documentForUpload!,
                                        totalCollect: totalFunds.totalCollect!,
                                        totalSpend: totalFunds.totalSpend!,
                                        currentBalance:
                                            totalFunds.currentBalance!,
                                        amount:
                                            double.parse(amountController.text),
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
                                    height: 40,
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
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 6),
                                      child: Center(
                                        child: KText(
                                          text: "ADD NOW",
                                          style: GoogleFonts.openSans(
                                            fontSize: 16,
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
                          height: size.height * 0.75,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Color(0xffF7FAFC),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "USER INFORMATION",
                                style: GoogleFonts.openSans(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Date",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        elevation: 10,
                                        child: SizedBox(
                                          height: 40,
                                          width: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: dateController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Amount",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        elevation: 10,
                                        child: SizedBox(
                                          height: 40,
                                          width: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: amountController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Record Type",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          boxShadow: const [
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
                              const SizedBox(height: 10),
                              Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Verifier",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        elevation: 10,
                                        child: SizedBox(
                                          height: 40,
                                          width: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: verifierController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Source",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        elevation: 10,
                                        child: SizedBox(
                                          height: 40,
                                          width: 150,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: sourceController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: GoogleFonts.openSans(
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Remarks",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        elevation: 10,
                                        child: SizedBox(
                                          height: 40,
                                          width: 500,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: TextFormField(
                                              controller: remarksController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintStyle: GoogleFonts.openSans(
                                                  fontSize: 14,
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
                              const SizedBox(height: 30),
                              Center(
                                child: Container(
                                  height: 170,
                                  width: 350,
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
                                      ? const Center(
                                    child: Icon(
                                      Icons.cloud_upload,
                                      size: 160,
                                      color: Colors.grey,
                                    ),
                                  ) : null,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: selectImage,
                                    child: Container(
                                      height: 35,
                                      width: size.width * 0.23,
                                      color: Constants().primaryAppColor,
                                      child: const Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo,
                                              color: Colors.white),
                                          SizedBox(width: 10),
                                          KText(
                                            text: 'Select Profile Photo',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Container(
                                    height: 35,
                                    width: size.width * 0.23,
                                  ),
                                  InkWell(
                                    onTap: selectDocument,
                                    child: Container(
                                      height: 35,
                                      width: size.width * 0.23,
                                      color: Constants().primaryAppColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.file_copy,
                                              color: Colors.white),
                                          const SizedBox(width: 10),
                                          KText(
                                            text: docname == "" ? 'Select Document' : docname,
                                            style: const TextStyle(color: Colors.white),
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
                  ),
                  isFiltered
                      ? StreamBuilder(
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
                                width: 1100,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.1,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            KText(
                                              text:
                                                  "Fund Records (${funds.length})",
                                              style: GoogleFonts.openSans(
                                                fontSize: 20,
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
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      offset: Offset(1, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 6),
                                                  child: Center(
                                                    child: KText(
                                                      text: "Clear Filter",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        fontSize: 14,
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
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          )),
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: Padding(
                                              padding:
                                              const EdgeInsets.all(0.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: KText(
                                                      text: "No.",
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: KText(
                                                      text: "Date",
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 140,
                                                    child: KText(
                                                      text: "Amount",
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: KText(
                                                      text: "Verifier",
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: KText(
                                                      text: "Source",
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: KText(
                                                      text: "Record Type",
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: KText(
                                                      text: "Document",
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: funds.length,
                                              itemBuilder: (ctx, i) {
                                                return Container(
                                                  height: 60,
                                                  width: double.infinity,
                                                  decoration:
                                                  const BoxDecoration(
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
                                                        width: 80,
                                                        child: KText(
                                                          text: (i + 1)
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 100,
                                                        child: KText(
                                                          text: funds[i].date!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 140,
                                                        child: KText(
                                                          text: funds[i]
                                                              .amount!
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: KText(
                                                          text: funds[i]
                                                              .verifier!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: KText(
                                                          text:
                                                          funds[i].source!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                            FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: KText(
                                                          text: funds[i]
                                                              .recordType!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
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
                                                          width: 150,
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
                                                              height: 35,
                                                              margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                                                                    text: "Download",
                                                                    style: GoogleFonts.openSans(
                                                                      fontSize: 12,
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
                        )
                      : StreamBuilder(
                          stream: FundManageFireCrud.fetchFunds(),
                          builder: (ctx, snapshot) {
                            if (snapshot.hasError) {
                              return Container();
                            } else if (snapshot.hasData) {
                              List<FundManagementModel> funds = snapshot.data!;
                              return Container(
                                width: 1100,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: size.height * 0.1,
                                      width: double.infinity,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 8),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            KText(
                                              text:
                                                  "Fund Records (${funds.length})",
                                              style: GoogleFonts.openSans(
                                                fontSize: 20,
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
                                                height: 40,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.black26,
                                                      offset: Offset(1, 2),
                                                      blurRadius: 3,
                                                    ),
                                                  ],
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(horizontal: 6),
                                                  child: Center(
                                                    child: KText(
                                                      text: "Filter",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        fontSize: 14,
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
                                      decoration: const BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          )),
                                      padding: const EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                    width: 80,
                                                    child: KText(
                                                      text: "No.",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: KText(
                                                      text: "Date",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 140,
                                                    child: KText(
                                                      text: "Amount",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: KText(
                                                      text: "Verifier",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: KText(
                                                      text: "Source",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: KText(
                                                      text: "Record Type",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 150,
                                                    child: KText(
                                                      text: "Document",
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          const SizedBox(height: 10),
                                          Expanded(
                                            child: ListView.builder(
                                              itemCount: funds.length,
                                              itemBuilder: (ctx, i) {
                                                return Container(
                                                  height: 60,
                                                  width: double.infinity,
                                                  decoration:
                                                      const BoxDecoration(
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
                                                        width: 80,
                                                        child: KText(
                                                          text: (i + 1)
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 100,
                                                        child: KText(
                                                          text: funds[i].date!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 140,
                                                        child: KText(
                                                          text: funds[i]
                                                              .amount!
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: KText(
                                                          text: funds[i]
                                                              .verifier!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: KText(
                                                          text:
                                                              funds[i].source!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        width: 150,
                                                        child: KText(
                                                          text: funds[i]
                                                              .recordType!,
                                                          style: GoogleFonts
                                                              .poppins(
                                                            fontSize: 13,
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
                                                        width: 150,
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
                                                            height: 35,
                                                            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 10),
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
                                                                  text: "Download",
                                                                  style: GoogleFonts.openSans(
                                                                    fontSize: 12,
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
                        )
                ],
              );
            }
            return Container(
              height: size.height,
              width: double.infinity,
              child: const Center(
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
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: KText(
                              text: "Filter",
                              style: GoogleFonts.openSans(
                                fontSize: 16,
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
                                  width: 90,
                                  child: KText(
                                    text: "Start Date",
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  height: 40,
                                  width: 90,
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
                                  width: 90,
                                  child: KText(
                                    text: "End Date",
                                    style: GoogleFonts.openSans(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  height: 40,
                                  width: 90,
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
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                KText(
                                  text: "Record Type",
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    boxShadow: const [
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
                                    height: 40,
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
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 5),
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context,true);
                                  },
                                  child: Container(
                                    height: 40,
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
                                            fontSize: 16,
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
}

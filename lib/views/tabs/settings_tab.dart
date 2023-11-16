import 'package:church_management_admin/models/church_details_model.dart';
import 'package:church_management_admin/models/verses_model.dart';
import 'package:church_management_admin/services/attendance_record_firecrud.dart';
import 'package:church_management_admin/services/church_details_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';

class SettingsTab extends StatefulWidget {
  SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController buildingnoController = TextEditingController();
  TextEditingController streetController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController websiteController = TextEditingController();
  TextEditingController adminEmailController = TextEditingController();
  TextEditingController adminPasswordController = TextEditingController();
  TextEditingController managerEmailController = TextEditingController();
  TextEditingController managerPasswordController = TextEditingController();
  TextEditingController committeeEmailController = TextEditingController();
  TextEditingController committeePasswordController = TextEditingController();
  TextEditingController staffEmailController = TextEditingController();
  TextEditingController staffPasswordController = TextEditingController();
  TextEditingController memberIDPrefixController = TextEditingController();
  TextEditingController familyIDPrefixController = TextEditingController();

  TextEditingController verseController = TextEditingController();
  TextEditingController textController = TextEditingController();

  bool isAdminPasswordVisible = true;
  bool isManagerPasswordVisible = true;
  bool isCommitteePasswordVisible = true;
  bool isStaffPasswordVisible = true;

  setData(ChurchDetailsModel church) {
    nameController.text = church.name ?? "";
    phoneController.text = church.phone ?? "";
    buildingnoController.text = church.buildingNo ?? "";
    streetController.text = church.streetName ?? "";
    areaController.text = church.area ?? "";
    cityController.text = church.city ?? "";
    stateController.text = church.state ?? "";
    pincodeController.text = church.pincode ?? "";
    websiteController.text = church.website ?? "";
    memberIDPrefixController.text = church.memberIdPrefix ?? "";
    familyIDPrefixController.text = church.familyIdPrefix ?? "";
    roleCredentialsList.clear();
    church.roles!.forEach((element) {
      roleCredentialsList.add(RoleCredentialsModel(
          roleEmail: TextEditingController(text: element.roleName),
          rolePassword: TextEditingController(text: element.rolePassword),
          isObsecure: true));
    });
  }

  List<RoleCredentialsModel> roleCredentialsList = [];

  List<bool> selectVersesList = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width / 170.75, vertical: height / 81.375),
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
                        horizontal: width / 170.75, vertical: height / 81.375),
                    child: KText(
                      text: "SETTINGS",
                      style: GoogleFonts.openSans(
                          fontSize: width/37.94,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                    ),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: EdgeInsets.only(right: width/45.533),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: () {
                            viewVersesPopUp();
                          },
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            elevation: 4,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 170.75,
                                    vertical: height / 81.375),
                                child: Text(
                                  "View Bible Verses",
                                  style: TextStyle(
                                    color: Constants().primaryAppColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: width/68.3),
                        InkWell(
                          onTap: () {
                            addVersesPopUp(true, null);
                          },
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            elevation: 4,
                            child: Center(
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width / 170.75,
                                    vertical: height / 81.375),
                                child: Text(
                                  "Add Bible Verses",
                                  style: TextStyle(
                                    color: Constants().primaryAppColor,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(height: size.height * 0.03),
              StreamBuilder(
                stream: ChurchDetailsFireCrud.fetchChurchDetails2(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    ChurchDetailsModel church1 = snapshot.data!.first;
                    setData(church1);
                    return Center(
                      child: Container(
                        height: size.height * 0.88 ,
                        width: size.width * 0.95,
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
                          children: [
                            Container(height: size.height * 0.09),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    )),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.2,
                                      child: Column(
                                        children: [
                                          SizedBox(height: size.height * 0.1),
                                          Icon(
                                            Icons.church,
                                            size: width/7.588,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.75,
                                      padding: EdgeInsets.symmetric(
                                        vertical: height/32.55,
                                        horizontal: width/68.3
                                      ),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Church Name",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width: width/4.553,
                                                    child: TextFormField(
                                                      controller:
                                                          nameController,
                                                      onTap: () {},
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle:
                                                            GoogleFonts
                                                                .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: width/45.53),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Church Phone Number",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width: width/4.553,
                                                    child: TextFormField(
                                                      controller:
                                                          phoneController,
                                                      onTap: () {},
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle:
                                                            GoogleFonts
                                                                .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: height/21.7),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Building No",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width: width/6.83,
                                                    child: TextFormField(
                                                      controller:
                                                          buildingnoController,
                                                      onTap: () {},
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle:
                                                            GoogleFonts
                                                                .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: width/45.53),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Street Name",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width: width/6.83,
                                                    child: TextFormField(
                                                      controller:
                                                          streetController,
                                                      onTap: () {},
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle:
                                                            GoogleFonts
                                                                .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: width/45.53),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Area",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width: width/6.83,
                                                    child: TextFormField(
                                                      controller:
                                                          areaController,
                                                      onTap: () {},
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle:
                                                            GoogleFonts
                                                                .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: width/45.53),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "City / District",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width: width/6.83,
                                                    child: TextFormField(
                                                      controller:
                                                          cityController,
                                                      onTap: () {},
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle:
                                                            GoogleFonts
                                                                .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: height/21.7),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "State",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width:width/5.464,
                                                    child: TextFormField(
                                                      controller:
                                                          stateController,
                                                      onTap: () {},
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle:
                                                            GoogleFonts
                                                                .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: width/27.32),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Pincode",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width:width/5.464,
                                                    child: TextFormField(
                                                      controller:
                                                          pincodeController,
                                                      onTap: () {},
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle:
                                                            GoogleFonts
                                                                .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width:width/27.32),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Website",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width:width/5.464,
                                                    child: TextFormField(
                                                      controller:
                                                          websiteController,
                                                      onTap: () {},
                                                      decoration:
                                                          InputDecoration(
                                                        hintStyle:
                                                            GoogleFonts
                                                                .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: height/21.7),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "MemberID prefix",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width:width/5.464,
                                                    child: TextFormField(
                                                      controller:
                                                      memberIDPrefixController,
                                                      onTap: () {},
                                                      decoration:
                                                      InputDecoration(
                                                        hintStyle:
                                                        GoogleFonts
                                                            .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(width: width/27.32),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "FamilyID Prefix",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                  SizedBox(height: height/108.5),
                                                  SizedBox(
                                                    height: height/16.275,
                                                    width:width/5.464,
                                                    child: TextFormField(
                                                      controller:
                                                      familyIDPrefixController,
                                                      onTap: () {},
                                                      decoration:
                                                      InputDecoration(
                                                        hintStyle:
                                                        GoogleFonts
                                                            .openSans(
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: height/11.7),

                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  List<RoleUserModel> roles1 =
                                                      [];
                                                  roleCredentialsList
                                                      .forEach((element) {
                                                    roles1.add(RoleUserModel(
                                                        roleName: element
                                                            .roleEmail!.text,
                                                        rolePassword: element
                                                            .rolePassword!
                                                            .text));
                                                  });
                                                  Response response =
                                                      await ChurchDetailsFireCrud
                                                          .updateRecord(
                                                    ChurchDetailsModel(
                                                        phone: phoneController
                                                            .text,
                                                        id: church1.id,
                                                        name:
                                                            nameController.text,
                                                        city:
                                                            cityController.text,
                                                        area:
                                                            areaController.text,
                                                        buildingNo:
                                                            buildingnoController
                                                                .text,
                                                        pincode:
                                                            pincodeController
                                                                .text,
                                                        state: stateController
                                                            .text,
                                                        streetName:
                                                            streetController
                                                                .text,
                                                        website:
                                                            websiteController
                                                                .text,
                                                        memberIdPrefix: memberIDPrefixController.text,
                                                        familyIdPrefix: familyIDPrefixController.text,
                                                        roles: roles1),
                                                  );
                                                  if (response.code == 200) {
                                                    CoolAlert.show(
                                                        context: context,
                                                        type: CoolAlertType
                                                            .success,
                                                        text:
                                                            "Updated successfully!",
                                                        width: size.width * 0.4,
                                                        backgroundColor:
                                                            Constants()
                                                                .primaryAppColor
                                                                .withOpacity(
                                                                    0.8));
                                                  }
                                                  else {
                                                    CoolAlert.show(
                                                        context: context,
                                                        type:
                                                            CoolAlertType.error,
                                                        text:
                                                            "Failed to Update",
                                                        width: size.width * 0.4,
                                                        backgroundColor:
                                                            Constants()
                                                                .primaryAppColor
                                                                .withOpacity(
                                                                    0.8));
                                                  }
                                                },
                                                child: Container(
                                                  height:height/18.6,
                                                  decoration: BoxDecoration(
                                                    color: Constants()
                                                        .primaryAppColor,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8),
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
                                                        EdgeInsets.symmetric(
                                                            horizontal: 6),
                                                    child: Center(
                                                      child: KText(
                                                        text: "Update",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          fontSize: width/105.07,
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
                                        ],
                                      ),
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
                  return Container();
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }

  viewVersesPopUp() async {
    Size size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("BibleVerses")
                .snapshots(),
            builder: (ctx, snap) {
              if (snap.hasData) {
                var verseDocument = snap.data!;
                if (selectVersesList.isEmpty) {
                  verseDocument.docs.forEach((element) {
                    selectVersesList.add(false);
                  });
                }
                return AlertDialog(
                  backgroundColor: Colors.transparent,
                  content: SizedBox(
                    height: size.height * 0.8,
                    width: size.width * 0.7,
                    child: Column(
                      children: [
                        Container(
                          height: size.height * 0.1,
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(horizontal: width/68.3),
                          decoration: BoxDecoration(
                              color: Constants().primaryAppColor,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: "Verses",
                                style: GoogleFonts.openSans(
                                  fontSize: width/68.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
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
                                        EdgeInsets.symmetric(horizontal: width/227.66),
                                    child: Center(
                                      child: KText(
                                        text: "Close",
                                        style: GoogleFonts.openSans(
                                          fontSize: width/97.571,
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            child: Container(
                          height: size.height * 0.47,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                          ),
                          child: ListView.builder(
                            itemCount: verseDocument.docs.length,
                            itemBuilder: (ctx, i) {
                              return Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: width/170.75,
                                    vertical: height/81.375
                                ),
                                child: Row(
                                  children: [
                                    Checkbox(
                                        value: selectVersesList[i],
                                        onChanged: (val) {
                                          setState(() {
                                            selectVersesList[i] =
                                                !selectVersesList[i];
                                            for (int j = 0;
                                                j < selectVersesList.length;
                                                j++) {
                                              if (i != j) {
                                                selectVersesList[j] = false;
                                              }
                                            }
                                          });
                                          updateTodayVerse(verseDocument.docs);
                                        }),
                                    Container(
                                      height: height/8.1375,
                                      width: size.width * 0.65,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      margin: EdgeInsets.symmetric(
                                        vertical: height/130.2,
                                        horizontal: width/273.2
                                      ),
                                      child: ListTile(
                                        style: ListTileStyle.list,
                                        leading: InkWell(
                                          onTap: () {
                                            addVersesPopUp(
                                                false,
                                                Verse(
                                                    id: verseDocument.docs[i]
                                                        ['id'],
                                                    verse: verseDocument.docs[i]
                                                        ['verse'],
                                                    text: verseDocument.docs[i]
                                                        ['text']));
                                          },
                                          child: Icon(Icons.edit),
                                        ),
                                        trailing: InkWell(
                                          onTap: () async {
                                            await CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.info,
                                                text:
                                                    "Are you sure want to delete",
                                                confirmBtnText: 'Delete',
                                                onConfirmBtnTap: () async {
                                                  return deleteVerse(
                                                      verseDocument.docs[i]
                                                          ['id']);
                                                },
                                                cancelBtnText: 'Cancel',
                                                showCancelBtn: true,
                                                width: size.width * 0.4,
                                                backgroundColor: Constants()
                                                    .primaryAppColor
                                                    .withOpacity(0.8));
                                            setState(() {});
                                          },
                                          child: Icon(Icons.delete),
                                        ),
                                        title: Text(
                                          verseDocument.docs[i]['text'],
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          verseDocument.docs[i]['verse'],
                                          style: TextStyle(
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        ))
                      ],
                    ),
                  ),
                );
              }
              return Container();
            },
          );
        });
      },
    );
  }

  updateTodayVerse(listOfVerse) async {
    var church1 =
        await FirebaseFirestore.instance.collection('ChurchDetails').get();
    String id = church1.docs.first.id;
    var church =
        await FirebaseFirestore.instance.collection('ChurchDetails').doc(id);
    String date = formatter.format(DateTime.now());
    String verse = "";
    for (int v = 0; v < selectVersesList.length; v++) {
      if (selectVersesList[v]) {
        verse = listOfVerse[v]['text'];
      }
    }
    Map<String, dynamic> map = {
      "verseForToday": {"date": date, "text": verse}
    };
    await church.update(map);
  }

  addVersesPopUp(bool isAddNew, Verse? verse) async {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          setState(() {
            if (!isAddNew) {
              textController.text = verse!.text;
              verseController.text = verse.verse;
            }
          });
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: isAddNew ? "Add Verses" : "Edit Verse",
                          style: GoogleFonts.openSans(
                            fontSize: width/68.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
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
                              padding: EdgeInsets.symmetric(horizontal: width/227.66),
                              child: Center(
                                child: KText(
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.571,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: size.height * 0.47,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: width/68.3,
                        vertical: height/32.55
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Verse",
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
                                  width: size.width * 0.2,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width / 170.75,
                                        vertical: height / 81.375),
                                    child: TextFormField(
                                      controller: verseController,
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
                          SizedBox(height:height/32.55),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Text",
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
                                  height: size.height * 0.2,
                                  width: size.width * 0.5,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: width / 170.75,
                                        vertical: height / 81.375),
                                    child: TextFormField(
                                      maxLines: null,
                                      controller: textController,
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
                          SizedBox(height:height/32.55),
                          InkWell(
                            onTap: () {
                              if (isAddNew) {
                                if (textController.text != "" &&
                                    verseController.text != "") {
                                  addVerse(Verse(
                                      id: "id",
                                      verse: verseController.text,
                                      text: textController.text));
                                } else {}
                              } else {
                                updateVerse(Verse(
                                    id: verse!.id,
                                    verse: verseController.text,
                                    text: textController.text));
                              }
                            },
                            child: Material(
                              borderRadius: BorderRadius.circular(5),
                              color: Constants().primaryAppColor,
                              elevation: 10,
                              child: SizedBox(
                                height: height/16.275,
                                width: width/9.106,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: width / 170.75,
                                      vertical: height / 81.375),
                                  child: Center(
                                    child: Text(
                                      isAddNew ? "Add Verse" : "Update Verse",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ))
                ],
              ),
            ),
          );
        });
      },
    );
  }

  addVerse(Verse verse) async {
    Size size = MediaQuery.of(context).size;
    var document =
        await FirebaseFirestore.instance.collection("BibleVerses").doc();
    verse.id = document.id;
    var json = verse.toJson();
    Response response = Response();
    await document.set(json).whenComplete(() {
      response.code = 200;
      response.message = 'Success';
    }).catchError((e) {
      response.code = 500;
      response.message = 'Failed';
    });
    if (response.code == 200) {
      await CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Verse created successfully!",
          width: size.width * 0.4,
          backgroundColor: Constants().primaryAppColor.withOpacity(0.8));
      setState(() {
        textController.text = "";
        verseController.text = "";
      });
      Navigator.pop(context);
    } else {
      await CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Failed to create verse!",
          width: size.width * 0.4,
          backgroundColor: Constants().primaryAppColor.withOpacity(0.8));
      Navigator.pop(context);
    }
  }

  updateVerse(Verse verse) async {
    Size size = MediaQuery.of(context).size;
    var document = await FirebaseFirestore.instance
        .collection("BibleVerses")
        .doc(verse.id);
    var json = verse.toJson();
    Response response = Response();
    await document.update(json).whenComplete(() {
      response.code = 200;
      response.message = 'Success';
    }).catchError((e) {
      response.code = 500;
      response.message = 'Failed';
    });
    if (response.code == 200) {
      await CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Verse updated successfully!",
          width: size.width * 0.4,
          backgroundColor: Constants().primaryAppColor.withOpacity(0.8));
      setState(() {
        textController.text = "";
        verseController.text = "";
      });
      Navigator.pop(context);
    } else {
      await CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Failed to update verse!",
          width: size.width * 0.4,
          backgroundColor: Constants().primaryAppColor.withOpacity(0.8));
      Navigator.pop(context);
    }
  }

  deleteVerse(String id) async {
    Size size = MediaQuery.of(context).size;
    Response response = Response();
    await FirebaseFirestore.instance
        .collection("BibleVerses")
        .doc(id)
        .delete()
        .whenComplete(() {
      response.code = 200;
      response.message = 'Success';
    }).catchError((e) {
      response.code = 500;
      response.message = 'Failed';
    });
    if (response.code == 200) {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text: "Verse deleted successfully!",
          width: size.width * 0.4,
          backgroundColor: Constants().primaryAppColor.withOpacity(0.8));
    } else {
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text: "Failed to delete verse!",
          width: size.width * 0.4,
          backgroundColor: Constants().primaryAppColor.withOpacity(0.8));
    }
    return response;
  }
}

class RoleCredentialsModel {
  RoleCredentialsModel(
      {required this.roleEmail,
      required this.rolePassword,
      required this.isObsecure});

  TextEditingController? roleEmail;
  TextEditingController? rolePassword;
  bool? isObsecure;
}

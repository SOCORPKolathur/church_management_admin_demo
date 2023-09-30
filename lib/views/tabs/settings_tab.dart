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
  const SettingsTab({super.key});

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

  TextEditingController verseController = TextEditingController();
  TextEditingController textController = TextEditingController();


  bool isAdminPasswordVisible = true;
  bool isManagerPasswordVisible = true;
  bool isCommitteePasswordVisible = true;
  bool isStaffPasswordVisible = true;

  setData(ChurchDetailsModel church){
      nameController.text = church.name ?? "";
      phoneController.text = church.phone ?? "";
      buildingnoController.text = church.buildingNo ?? "";
      streetController.text = church.streetName ?? "";
      areaController.text = church.area ?? "";
      cityController.text = church.city ?? "";
      stateController.text = church.state ?? "";
      pincodeController.text = church.pincode ?? "";
      websiteController.text = church.website ?? "";
      roleCredentialsList.clear();
      church.roles!.forEach((element) {
        roleCredentialsList.add(
            RoleCredentialsModel(roleEmail: TextEditingController(text: element.roleName), rolePassword: TextEditingController(text: element.rolePassword), isObsecure: true)
        );
      });
  }

  List<RoleCredentialsModel> roleCredentialsList = [];

  List<bool> selectVersesList = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: const Icon(
                        Icons.arrow_back
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: KText(
                      text: "SETTINGS",
                      style: GoogleFonts.openSans(
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                    ),
                  ),
                  Expanded(child: Container()),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Row(
                      children: [
                        InkWell(
                          onTap: (){
                            viewVersesPopUp();
                          },
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            elevation: 4,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                        const SizedBox(width: 20),
                        InkWell(
                          onTap: (){
                            addVersesPopUp(true,null);
                          },
                          child: Material(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            elevation: 4,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
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
                builder: (ctx,snapshot){
                  if(snapshot.hasData){
                    ChurchDetailsModel church1 = snapshot.data!.first;
                    setData(church1);
                    return Center(
                      child: Container(
                        height: size.height * 0.28 * church1.roles!.length,
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
                                          const Icon(
                                            Icons.church,
                                            size: 180,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.75,
                                      padding: const EdgeInsets.all(20),
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
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Material(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    color: const Color(0xffdddeee),
                                                    elevation: 0,
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 300,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: nameController,
                                                          onTap: () {},
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintStyle:
                                                            GoogleFonts.openSans(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(width: 30),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Church Phone Number",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Material(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    color: const Color(0xffdddeee),
                                                    elevation: 1,
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 300,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: phoneController,
                                                          onTap: () {},
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintStyle:
                                                            GoogleFonts.openSans(
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
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Material(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    color: const Color(0xffdddeee),
                                                    elevation: 1,
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 200,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: buildingnoController,
                                                          onTap: () {},
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintStyle:
                                                            GoogleFonts.openSans(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(width: 30),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Street Name",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Material(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    color: const Color(0xffdddeee),
                                                    elevation: 1,
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 200,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: streetController,
                                                          onTap: () {},
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintStyle:
                                                            GoogleFonts.openSans(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(width: 30),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Area",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Material(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    color: const Color(0xffdddeee),
                                                    elevation: 1,
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 200,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: areaController,
                                                          onTap: () {},
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintStyle:
                                                            GoogleFonts.openSans(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(width: 30),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "City / District",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Material(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    color: const Color(0xffdddeee),
                                                    elevation: 1,
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 200,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: cityController,
                                                          onTap: () {},
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintStyle:
                                                            GoogleFonts.openSans(
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
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Material(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    color: const Color(0xffdddeee),
                                                    elevation: 1,
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 250,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: stateController,
                                                          onTap: () {},
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintStyle:
                                                            GoogleFonts.openSans(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(width: 50),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Pincode",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Material(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    color: const Color(0xffdddeee),
                                                    elevation: 1,
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 250,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: pincodeController,
                                                          onTap: () {},
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintStyle:
                                                            GoogleFonts.openSans(
                                                              fontSize: 14,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                              const SizedBox(width: 50),
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Website",
                                                    style: GoogleFonts.openSans(
                                                      color: Colors.black,
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 6),
                                                  Material(
                                                    borderRadius:
                                                    BorderRadius.circular(5),
                                                    color: const Color(0xffdddeee),
                                                    elevation: 1,
                                                    child: SizedBox(
                                                      height: 40,
                                                      width: 250,
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets.all(8.0),
                                                        child: TextFormField(
                                                          controller: websiteController,
                                                          onTap: () {},
                                                          decoration: InputDecoration(
                                                            border: InputBorder.none,
                                                            hintStyle:
                                                            GoogleFonts.openSans(
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
                                          for(int r = 0; r < roleCredentialsList.length; r ++)
                                            Padding(
                                              padding: const EdgeInsets.symmetric(vertical: 10),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      KText(
                                                        text: "${roleCredentialsList[r].roleEmail!.text} Email",
                                                        style: GoogleFonts.openSans(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Material(
                                                        borderRadius:
                                                        BorderRadius.circular(5),
                                                        color: const Color(0xffdddeee),
                                                        elevation: 1,
                                                        child: SizedBox(
                                                          height: 40,
                                                          width: 250,
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(8.0),
                                                            child: TextFormField(
                                                              controller: roleCredentialsList[r].roleEmail,
                                                              onTap: () {},
                                                              decoration: InputDecoration(
                                                                border: InputBorder.none,
                                                                hintStyle:
                                                                GoogleFonts.openSans(
                                                                  fontSize: 14,
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                  const SizedBox(width: 50),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    children: [
                                                      KText(
                                                        text: "${roleCredentialsList[r].rolePassword!.text} Password",
                                                        style: GoogleFonts.openSans(
                                                          color: Colors.black,
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                      const SizedBox(height: 6),
                                                      Material(
                                                        borderRadius:
                                                        BorderRadius.circular(5),
                                                        color: const Color(0xffdddeee),
                                                        elevation: 1,
                                                        child: SizedBox(
                                                          height: 40,
                                                          width: 250,
                                                          child: Padding(
                                                            padding:
                                                            const EdgeInsets.all(8.0),
                                                            child: TextFormField(
                                                              obscureText: roleCredentialsList[r].isObsecure == true?true:false,
                                                              controller: roleCredentialsList[r].rolePassword,
                                                              onTap: () {},
                                                              decoration: InputDecoration(
                                                                  contentPadding: const EdgeInsets.symmetric(vertical: 5),
                                                                  border: InputBorder.none,
                                                                  hintStyle:
                                                                  GoogleFonts.openSans(
                                                                    fontSize: 14,
                                                                  ),
                                                                  suffix: IconButton(
                                                                    onPressed: (){
                                                                      setState(() {
                                                                        roleCredentialsList[r].isObsecure = !roleCredentialsList[r].isObsecure!;
                                                                      });
                                                                      print(roleCredentialsList[r].isObsecure);
                                                                    },
                                                                    icon: Icon(roleCredentialsList[r].isObsecure! ? Icons.visibility : Icons.visibility_off),
                                                                  )
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          Expanded(child: Container()),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  List<RoleUserModel> roles1 = [];
                                                  roleCredentialsList.forEach((element) {
                                                    roles1.add(
                                                        RoleUserModel(
                                                          roleName: element.roleEmail!.text,
                                                          rolePassword: element.rolePassword!.text
                                                        )
                                                    );
                                                  });
                                                  Response response = await ChurchDetailsFireCrud.updateRecord(
                                                    ChurchDetailsModel(
                                                      phone: phoneController.text,
                                                      id: church1.id,
                                                      name: nameController.text,
                                                      city: cityController.text,
                                                      area: areaController.text,
                                                      buildingNo: buildingnoController.text,
                                                      pincode: pincodeController.text,
                                                      state: stateController.text,
                                                      streetName: streetController.text,
                                                      website: websiteController.text,
                                                      roles: roles1
                                                    ),
                                                  );
                                                  if(response.code == 200){
                                                    CoolAlert.show(
                                                        context: context,
                                                        type: CoolAlertType.success,
                                                        text: "Updated successfully!",
                                                        width: size.width * 0.4,
                                                        backgroundColor: Constants()
                                                            .primaryAppColor
                                                            .withOpacity(0.8));
                                                  }else{
                                                    CoolAlert.show(
                                                        context: context,
                                                        type: CoolAlertType.error,
                                                        text: "Failed to Update",
                                                        width: size.width * 0.4,
                                                        backgroundColor: Constants()
                                                            .primaryAppColor
                                                            .withOpacity(0.8));
                                                  }
                                                },
                                                child: Container(
                                                  height: 35,
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
                                                        text: "Update",
                                                        style: GoogleFonts.openSans(
                                                          fontSize: 13,
                                                          fontWeight: FontWeight.bold,
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
                  }return Container();
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
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return StreamBuilder(
            stream: FirebaseFirestore.instance.collection("BibleVerses").snapshots(),
            builder: (ctx, snap){
              if(snap.hasData){
                var verseDocument = snap.data!;
                if(selectVersesList.isEmpty){
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
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              color: Constants().primaryAppColor,
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(10),
                                  topRight: Radius.circular(10))),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: "Verses",
                                style: GoogleFonts.openSans(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 35,
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
                                        text: "Close",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
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
                                    padding:
                                    const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        Checkbox(
                                            value: selectVersesList[i],
                                            onChanged: (val){
                                              setState((){
                                                selectVersesList[i] = !selectVersesList[i];
                                                for(int j = 0; j < selectVersesList.length; j ++){
                                                  if(i != j){
                                                    selectVersesList[j] = false;
                                                  }
                                                }
                                              });
                                              updateTodayVerse(verseDocument.docs);
                                            }
                                        ),
                                        Container(
                                          height: 80,
                                          width: size.width * 0.65,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(
                                                10),
                                          ),
                                          margin:
                                          const EdgeInsets.all(5),
                                          child: ListTile(
                                            style: ListTileStyle.list,
                                            leading: InkWell(
                                              onTap: (){
                                                addVersesPopUp(
                                                    false,
                                                    Verse(
                                                        id: verseDocument.docs[i]['id'],
                                                        verse: verseDocument.docs[i]['verse'],
                                                        text: verseDocument.docs[i]['text']
                                                    )
                                                );
                                              },
                                              child: Icon(Icons.edit),
                                            ),
                                            trailing: InkWell(
                                              onTap: () async {
                                                await CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.info,
                                                    text: "Are you sure want to delete",
                                                    confirmBtnText: 'Delete',
                                                    onConfirmBtnTap: () async {
                                                      return deleteVerse(verseDocument.docs[i]['id']);
                                                    },
                                                    cancelBtnText: 'Cancel',
                                                    showCancelBtn: true,
                                                    width: size.width * 0.4,
                                                    backgroundColor: Constants()
                                                        .primaryAppColor
                                                        .withOpacity(0.8));
                                                setState((){

                                                });
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
                            )
                        )
                      ],
                    ),
                  ),
                );
              }return Container();
            },
          );
        });
      },
    );
  }

  updateTodayVerse(listOfVerse) async {
    var church1 = await FirebaseFirestore.instance.collection('ChurchDetails').get();
    String id = church1.docs.first.id;
    var church = await FirebaseFirestore.instance.collection('ChurchDetails').doc(id);
    String date = formatter.format(DateTime.now());
    String verse = "";
    for(int v = 0; v < selectVersesList.length; v ++){
      if(selectVersesList[v]){
        verse = listOfVerse[v]['text'];
      }
    }
    Map<String,dynamic> map = {
      "verseForToday": {
        "date" : date,
        "text" : verse
      }
    };
    await church.update(map);
  }

  addVersesPopUp(bool isAddNew,Verse? verse) async {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          setState((){
            if(!isAddNew){
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: isAddNew? "Add Verses" : "Edit Verse",
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: 35,
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: 14,
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
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Verse",
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
                                      width: size.width * 0.2,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          controller: verseController,
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
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Text",
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
                                      height: size.height * 0.2,
                                      width: size.width * 0.5,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                          maxLines: null,
                                          controller: textController,
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
                              const SizedBox(height: 20),
                              InkWell(
                                onTap: (){
                                  if(isAddNew){
                                    if(
                                    textController.text != "" &&
                                    verseController.text != ""
                                    ){
                                      addVerse(Verse(
                                          id: "id",verse: verseController.text,text: textController.text
                                      ));
                                    }else{
                                    }
                                  }else{
                                    updateVerse(
                                      Verse(
                                          id: verse!.id,
                                          verse: verseController.text,
                                          text: textController.text
                                      )
                                    );
                                  }
                                },
                                child: Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Constants().primaryAppColor,
                                  elevation: 10,
                                  child: SizedBox(
                                    height: 40,
                                    width: 150,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Center(
                                        child: Text(
                                          isAddNew? "Add Verse" : "Update Verse",
                                          style: const TextStyle(
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
                      )
                  )
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
    var document = await FirebaseFirestore.instance.collection("BibleVerses").doc();
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
    if(response.code == 200){
      await CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text:
          "Verse created successfully!",
          width: size.width * 0.4,
          backgroundColor: Constants()
              .primaryAppColor
              .withOpacity(0.8));
      setState(() {
        textController.text = "";
        verseController.text = "";
      });
      Navigator.pop(context);
    }else{
      await CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text:
          "Failed to create verse!",
          width: size.width * 0.4,
          backgroundColor: Constants()
              .primaryAppColor
              .withOpacity(0.8));
      Navigator.pop(context);
    }
  }

  updateVerse(Verse verse) async {
    Size size = MediaQuery.of(context).size;
    var document = await FirebaseFirestore.instance.collection("BibleVerses").doc(verse.id);
    var json = verse.toJson();
    Response response = Response();
    await document.update(json).whenComplete(() {
      response.code = 200;
      response.message = 'Success';
    }).catchError((e) {
      response.code = 500;
      response.message = 'Failed';
    });
    if(response.code == 200){
      await CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text:
          "Verse updated successfully!",
          width: size.width * 0.4,
          backgroundColor: Constants()
              .primaryAppColor
              .withOpacity(0.8));
      setState(() {
        textController.text = "";
        verseController.text = "";
      });
      Navigator.pop(context);
    }else{
      await CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text:
          "Failed to update verse!",
          width: size.width * 0.4,
          backgroundColor: Constants()
              .primaryAppColor
              .withOpacity(0.8));
      Navigator.pop(context);
    }
  }

  deleteVerse(String id) async {
    Size size = MediaQuery.of(context).size;
    Response response = Response();
    await FirebaseFirestore.instance.collection("BibleVerses").doc(id).delete().whenComplete(() {
      response.code = 200;
      response.message = 'Success';
    }).catchError((e) {
      response.code = 500;
      response.message = 'Failed';
    });
    if(response.code == 200){
      CoolAlert.show(
          context: context,
          type: CoolAlertType.success,
          text:
          "Verse deleted successfully!",
          width: size.width * 0.4,
          backgroundColor: Constants()
              .primaryAppColor
              .withOpacity(0.8));
    }else{
      CoolAlert.show(
          context: context,
          type: CoolAlertType.error,
          text:
          "Failed to delete verse!",
          width: size.width * 0.4,
          backgroundColor: Constants()
              .primaryAppColor
              .withOpacity(0.8));
    }
    return response;
  }

}

class RoleCredentialsModel {
  RoleCredentialsModel({required this.roleEmail, required this.rolePassword, required this.isObsecure});
  TextEditingController? roleEmail;
  TextEditingController? rolePassword;
  bool? isObsecure;

}


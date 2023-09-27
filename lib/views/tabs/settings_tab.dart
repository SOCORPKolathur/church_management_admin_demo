import 'package:church_management_admin/models/church_details_model.dart';
import 'package:church_management_admin/services/church_details_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';

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
      // adminEmailController.text = church.adminEmail ?? "";
      // adminPasswordController.text = church.adminPassword ?? "";
      // managerEmailController.text = church.managerEmail ?? "";
      // managerPasswordController.text = church.managerPassword ?? "";
      // committeeEmailController.text = church.committeeEmail ?? "";
      // committeePasswordController.text = church.committeePassword ?? "";
      // staffEmailController.text = church.staffEmail ?? "";
      // staffPasswordController.text = church.staffPassword ?? "";
  }

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
                        height: size.height * 1.2,
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
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Admin Email",
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
                                                          controller: adminEmailController,
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
                                                    text: "Admin Password",
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
                                                          obscureText: isAdminPasswordVisible,
                                                          controller: adminPasswordController,
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
                                                                  isAdminPasswordVisible = !isAdminPasswordVisible;
                                                                });
                                                              },
                                                              icon: Icon(isAdminPasswordVisible ? Icons.visibility : Icons.visibility_off),
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
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Manager Email",
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
                                                          controller: managerEmailController,
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
                                                    text: "Manger Password",
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
                                                          obscureText: isManagerPasswordVisible,
                                                          controller: managerPasswordController,
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
                                                                    isManagerPasswordVisible = !isManagerPasswordVisible;
                                                                  });
                                                                },
                                                                icon: Icon(isManagerPasswordVisible ? Icons.visibility : Icons.visibility_off),
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
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Committee Email",
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
                                                          controller: committeeEmailController,
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
                                                    text: "Committee Password",
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
                                                          obscureText: isCommitteePasswordVisible,
                                                          controller: committeePasswordController,
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
                                                                    isCommitteePasswordVisible = !isCommitteePasswordVisible;
                                                                  });
                                                                },
                                                                icon: Icon(isCommitteePasswordVisible ? Icons.visibility : Icons.visibility_off),
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
                                          const SizedBox(height: 20),
                                          Row(
                                            children: [
                                              Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  KText(
                                                    text: "Staff Email",
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
                                                          controller: staffEmailController,
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
                                                    text: "Staff Password",
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
                                                          obscureText: isStaffPasswordVisible,
                                                          controller: staffPasswordController,
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
                                                                    isStaffPasswordVisible = !isStaffPasswordVisible;
                                                                  });
                                                                },
                                                                icon: Icon(isStaffPasswordVisible ? Icons.visibility : Icons.visibility_off),
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
                                          Expanded(child: Container()),
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.end,
                                            children: [
                                              InkWell(
                                                onTap: () async {
                                                  Response response = await ChurchDetailsFireCrud.updateRecord(
                                                    ChurchDetailsModel(
                                                      phone: phoneController.text,
                                                      id: church1.id,
                                                      name: nameController.text,
                                                      city: cityController.text,
                                                      // adminEmail: adminEmailController.text,
                                                      // adminPassword: adminPasswordController.text,
                                                      area: areaController.text,
                                                      buildingNo: buildingnoController.text,
                                                      // managerEmail: managerEmailController.text,
                                                      // managerPassword: managerPasswordController.text,
                                                      // committeeEmail: committeeEmailController.text,
                                                      // committeePassword: committeePasswordController.text,
                                                      // staffEmail: staffEmailController.text,
                                                      // staffPassword: staffPasswordController.text,
                                                      pincode: pincodeController.text,
                                                      state: stateController.text,
                                                      streetName: streetController.text,
                                                      website: websiteController.text,
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
}

import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:church_management_admin/models/user_model.dart';
import 'package:church_management_admin/services/user_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';
import '../prints/user_print.dart';


class UserTab extends StatefulWidget {
  const UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController baptizeDateController = TextEditingController();
  TextEditingController anniversaryDateController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController(text: 'Select Blood Group');
  TextEditingController dobController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  //TextEditingController passwordController = TextEditingController();
  //TextEditingController confPaswordController = TextEditingController();
  TextEditingController filterTextController = TextEditingController();
  String filterText = "";
  String marriedController = "Select Status";
  File? profileImage;
  var uploadedImage;
  String? selectedImg;


  selectImage() {
    InputElement input = FileUploadInputElement() as InputElement
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

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: KText(
                text: "USERS",
                style: GoogleFonts.openSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            Container(
              height: marriedController.toUpperCase() ==
                  "MARRIED"? size.height * 1.95 : size.height * 1.85,
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
                            text: "Add User",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
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
                          )),
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                                              base64Decode(uploadedImage!
                                                  .split(',')
                                                  .last),
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
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: selectImage,
                                child: Container(
                                  height: 35,
                                  width: size.width * 0.25,
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
                              const SizedBox(width: 50),
                              Container(
                                height: 35,
                                width: size.width * 0.25,
                                color: Constants().primaryAppColor,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.crop,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
                                    KText(
                                      text: 'Disable Crop',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Firstname",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: firstNameController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Lastname",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: lastNameController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Phone",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: phoneController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Email",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: emailController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              // SizedBox(
                              //   width: 300,
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       KText(
                              //         text: "Password",
                              //         style: GoogleFonts.openSans(
                              //           color: Colors.black,
                              //           fontSize: 13,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       TextFormField(
                              //         style: const TextStyle(fontSize: 12),
                              //         controller: passwordController,
                              //       )
                              //     ],
                              //   ),
                              // ),
                              // const SizedBox(width: 20),
                              // SizedBox(
                              //   width: 300,
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       KText(
                              //         text: "Confirm Password",
                              //         style: GoogleFonts.openSans(
                              //           color: Colors.black,
                              //           fontSize: 13,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       TextFormField(
                              //         style: const TextStyle(fontSize: 12),
                              //         controller: confPaswordController,
                              //       )
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Profession",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: professionController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              //const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Baptize Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: baptizeDateController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Marital status",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      value: marriedController,
                                      icon:
                                      const Icon(Icons.keyboard_arrow_down),
                                      items: ["Select Status", "Married", "Single"]
                                          .map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          marriedController = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Visibility(
                            visible: marriedController.toUpperCase() ==
                                "MARRIED",
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 300,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Anniversary Date",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: 13,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextFormField(
                                        style: const TextStyle(fontSize: 12),
                                        controller: anniversaryDateController,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Blood Group",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 13),
                                    DropdownButton(
                                      isExpanded: true,
                                      value: bloodGroupController.text,
                                      icon: const Icon(Icons.keyboard_arrow_down),
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
                                            bloodGroupController.text = newValue!;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Date of Birth",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: dobController,
                                      decoration: const InputDecoration(
                                        hintText: "Ex: 2/9/2000"
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Locality",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: localityController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Address",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
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
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:
                                                const TextStyle(fontSize: 12),
                                            controller: addressController,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 15,
                                                    top: 4,
                                                    bottom: 4)),
                                            maxLines: null,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "About",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
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
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    const SizedBox(
                                      height: 20,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:
                                                const TextStyle(fontSize: 12),
                                            controller: aboutController,
                                            decoration: const InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: 15,
                                                    top: 4,
                                                    bottom: 4)),
                                            maxLines: null,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (profileImage != null &&
                                      baptizeDateController.text != "" &&
                                      bloodGroupController.text != "Select Blood Group" &&
                                      aboutController.text != "" &&
                                      addressController.text != "" &&
                                      dobController.text != "" &&
                                      emailController.text != "" &&
                                      //passwordController.text != "" &&
                                      marriedController != "Select Status" &&
                                      firstNameController.text != "" &&
                                      //confPaswordController.text != "" &&
                                      lastNameController.text != "" &&
                                      localityController.text != "" &&
                                      phoneController.text != "" &&
                                      professionController.text != "") {
                                    Response response =
                                        await UserFireCrud.addUser(
                                          maritialStatus:marriedController,
                                      image: profileImage!,
                                      baptizeDate: baptizeDateController.text,
                                      anniversaryDate:
                                          anniversaryDateController.text,
                                      bloodGroup: bloodGroupController.text,
                                      dob: dobController.text,
                                      email: emailController.text,
                                      firstName: firstNameController.text,
                                      lastName: lastNameController.text,
                                      locality: localityController.text,
                                      phone: phoneController.text,
                                      profession: professionController.text,
                                      about: aboutController.text,
                                      address: addressController.text,
                                      //password: passwordController.text,
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "User created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        uploadedImage = null;
                                        profileImage = null;
                                        baptizeDateController.text = "";
                                        bloodGroupController.text = "Select Blood Group";
                                        dobController.text = "";
                                        emailController.text = "";
                                        anniversaryDateController.text = "";
                                        marriedController = "Select Status";
                                        firstNameController.text = "";
                                        aboutController.text = "";
                                        addressController.text = "";
                                        lastNameController.text = "";
                                        //passwordController.text = "";
                                        localityController.text = "";
                                        phoneController.text = "";
                                        professionController.text = "";
                                        //confPaswordController.text = "";
                                      });
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create User!",
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Center(
                                      child: KText(
                                        text: "ADD NOW",
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: 10,
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
            filterText != "" ? StreamBuilder(
              stream: UserFireCrud.fetchUsersWithFilter(filterText),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<UserModel> users = snapshot.data!;
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
                                  text: "All Users (${users.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                     filterText = "";
                                     filterTextController.text = "";
                                    });
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
                                          text: "Clear Filter",
                                          style: GoogleFonts.openSans(
                                            fontSize: 13,
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
                          height: size.height * 0.7 > 130 + users.length * 60
                              ? 130 + users.length * 60
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      generateUserPdf(PdfPageFormat.letter, users,false);
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.print,
                                                  color: Colors.white),
                                              KText(
                                                text: "PRINT",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      copyToClipBoard(users);
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.copy,
                                                  color: Colors.white),
                                              KText(
                                                text: "COPY",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async {
                                      var data = await generateUserPdf(PdfPageFormat.letter, users,true);
                                      savePdfToFile(data);
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.picture_as_pdf,
                                                  color: Colors.white),
                                              KText(
                                                text: "PDF",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      convertToCsv(users);
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  Icons.file_copy_rounded,
                                                  color: Colors.white),
                                              KText(
                                                text: "CSV",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 13,
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
                              const SizedBox(height: 30),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: KText(
                                          text: "Photo",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: KText(
                                          text: "Profession",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child: KText(
                                          text: "Phone",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: KText(
                                          text: "Locality",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                    NetworkImage(
                                                        users[i].imgUrl!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 170,
                                              child: KText(
                                                text:
                                                "${users[i].firstName!} ${users[i].lastName!}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: KText(
                                                text: users[i].profession!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 170,
                                              child: KText(
                                                text: users[i].phone!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: KText(
                                                text: users[i].locality!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: 180,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        viewPopup(users[i]);
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        decoration:
                                                        const BoxDecoration(
                                                          color:
                                                          Color(0xff2baae4),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                              Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                ),
                                                                KText(
                                                                  text: "View",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    10,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          baptizeDateController
                                                              .text =
                                                          users[i]
                                                              .baptizeDate!;
                                                          bloodGroupController
                                                              .text =
                                                          users[i]
                                                              .bloodGroup!;
                                                          dobController.text =
                                                          users[i].dob!;
                                                          emailController.text =
                                                          users[i].email!;
                                                          firstNameController
                                                              .text =
                                                          users[i]
                                                              .firstName!;
                                                          aboutController.text =
                                                          users[i].about!;
                                                          addressController
                                                              .text =
                                                          users[i].address!;
                                                          lastNameController
                                                              .text =
                                                          users[i]
                                                              .lastName!;
                                                          // passwordController
                                                          //     .text =
                                                          // users[i]
                                                          //     .password!;
                                                          localityController
                                                              .text =
                                                          users[i]
                                                              .locality!;
                                                          phoneController.text =
                                                          users[i].phone!;
                                                          professionController
                                                              .text =
                                                          users[i]
                                                              .profession!;
                                                          // confPaswordController
                                                          //     .text =
                                                          // users[i]
                                                          //     .password!;
                                                          selectedImg =
                                                              users[i].imgUrl;
                                                          marriedController = users[i].maritialStatus!;
                                                          anniversaryDateController.text = users[i].anniversaryDate!;
                                                        });
                                                        editPopUp(
                                                            users[i], size);
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        decoration:
                                                        const BoxDecoration(
                                                          color:
                                                          Color(0xffff9700),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                              Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                const Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                ),
                                                                KText(
                                                                  text: "Edit",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    10,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    InkWell(
                                                      onTap: () {
                                                        CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType
                                                                .info,
                                                            text:
                                                            "${users[i].firstName} ${users[i].lastName} will be deleted",
                                                            title:
                                                            "Delete this Record?",
                                                            width: size.width *
                                                                0.4,
                                                            backgroundColor:
                                                            Constants()
                                                                .primaryAppColor
                                                                .withOpacity(
                                                                0.8),
                                                            showCancelBtn: true,
                                                            cancelBtnText:
                                                            'Cancel',
                                                            cancelBtnTextStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black),
                                                            onConfirmBtnTap:
                                                                () async {
                                                              Response res = await UserFireCrud
                                                                  .deleteRecord(
                                                                  id: users[
                                                                  i]
                                                                      .id!);
                                                            });
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        decoration:
                                                        const BoxDecoration(
                                                          color:
                                                          Color(0xfff44236),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                              Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .cancel_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                ),
                                                                KText(
                                                                  text:
                                                                  "Delete",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    10,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
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
                  );
                }
                return Container();
              },
            ) : StreamBuilder(
              stream: UserFireCrud.fetchUsers(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<UserModel> users = snapshot.data!;
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
                                  text: "All Users (${users.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: 35,
                                        width: 150,
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: TextField(
                                            controller: filterTextController,
                                            onSubmitted: (val){
                                              setState(() {
                                                filterText = val!;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Filter Profession",
                                              hintStyle: GoogleFonts.openSans(
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 5),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          filterText = filterTextController.text;
                                          filterTextController.text = "";
                                        });
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
                                              text: "Apply",
                                              style: GoogleFonts.openSans(
                                                fontSize: 13,
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
                        Container(
                          height: size.height * 0.7 > 130 + users.length * 60
                              ? 130 + users.length * 60
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
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      generateUserPdf(
                                          PdfPageFormat.letter, users,false);
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.print,
                                                  color: Colors.white),
                                              KText(
                                                text: "PRINT",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      copyToClipBoard(users);
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.copy,
                                                  color: Colors.white),
                                              KText(
                                                text: "COPY",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () async {
                                      var data = await generateUserPdf(PdfPageFormat.letter, users,true);
                                      savePdfToFile(data);
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.picture_as_pdf,
                                                  color: Colors.white),
                                              KText(
                                                text: "PDF",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  InkWell(
                                    onTap: () {
                                      convertToCsv(users);
                                    },
                                    child: Container(
                                      height: 35,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  Icons.file_copy_rounded,
                                                  color: Colors.white),
                                              KText(
                                                text: "CSV",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: 13,
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
                              const SizedBox(height: 30),
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: KText(
                                          text: "Photo",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: KText(
                                          text: "Profession",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child: KText(
                                          text: "Phone",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: KText(
                                          text: "Locality",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: users.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: 80,
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            users[i].imgUrl!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: 170,
                                              child: KText(
                                                text:
                                                    "${users[i].firstName!} ${users[i].lastName!}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: KText(
                                                text: users[i].profession!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 170,
                                              child: KText(
                                                text: users[i].phone!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 150,
                                              child: KText(
                                                text: users[i].locality!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: 13,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: 180,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        viewPopup(users[i]);
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xff2baae4),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                ),
                                                                KText(
                                                                  text: "View",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          baptizeDateController
                                                                  .text =
                                                              users[i]
                                                                  .baptizeDate!;
                                                          bloodGroupController
                                                                  .text =
                                                              users[i]
                                                                  .bloodGroup!;
                                                          dobController.text =
                                                              users[i].dob!;
                                                          emailController.text =
                                                              users[i].email!;
                                                          firstNameController
                                                                  .text =
                                                              users[i]
                                                                  .firstName!;
                                                          aboutController.text =
                                                              users[i].about!;
                                                          addressController
                                                                  .text =
                                                              users[i].address!;
                                                          lastNameController
                                                                  .text =
                                                              users[i]
                                                                  .lastName!;
                                                          // passwordController
                                                          //         .text =
                                                          //     users[i]
                                                          //         .password!;
                                                          localityController
                                                                  .text =
                                                              users[i]
                                                                  .locality!;
                                                          phoneController.text =
                                                              users[i].phone!;
                                                          professionController
                                                                  .text =
                                                              users[i]
                                                                  .profession!;
                                                          // confPaswordController
                                                          //         .text =
                                                          //     users[i]
                                                          //         .password!;
                                                          selectedImg =
                                                              users[i].imgUrl;
                                                          marriedController = users[i].maritialStatus!;
                                                          anniversaryDateController.text = users[i].anniversaryDate!;
                                                        });
                                                        editPopUp(
                                                            users[i], size);
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xffff9700),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                const Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                ),
                                                                KText(
                                                                  text: "Edit",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 5),
                                                    InkWell(
                                                      onTap: () {
                                                        CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType
                                                                .info,
                                                            text:
                                                                "${users[i].firstName} ${users[i].lastName} will be deleted",
                                                            title:
                                                                "Delete this Record?",
                                                            width: size.width *
                                                                0.4,
                                                            backgroundColor:
                                                                Constants()
                                                                    .primaryAppColor
                                                                    .withOpacity(
                                                                        0.8),
                                                            showCancelBtn: true,
                                                            cancelBtnText:
                                                                'Cancel',
                                                            cancelBtnTextStyle:
                                                                const TextStyle(
                                                                    color: Colors
                                                                        .black),
                                                            onConfirmBtnTap:
                                                                () async {
                                                              Response res = await UserFireCrud
                                                                  .deleteRecord(
                                                                      id: users[
                                                                              i]
                                                                          .id!);
                                                            });
                                                      },
                                                      child: Container(
                                                        height: 25,
                                                        decoration:
                                                            const BoxDecoration(
                                                          color:
                                                              Color(0xfff44236),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                const Icon(
                                                                  Icons
                                                                      .cancel_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 15,
                                                                ),
                                                                KText(
                                                                  text:
                                                                      "Delete",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        10,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
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
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  viewPopup(UserModel user) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: size.width * 0.5,
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
              children: [
                SizedBox(
                  height: size.height * 0.1,
                  width: double.infinity,
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.firstName!,
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
                                  text: "CLOSE",
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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: size.width * 0.3,
                            height: size.height * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(user.imgUrl!),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: "${user.firstName!} ${user.lastName!}",
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Phone",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: user.phone!,
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Email",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: user.email!,
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  // Row(
                                  //   children: [
                                  //     SizedBox(
                                  //       width: size.width * 0.15,
                                  //       child: const KText(
                                  //         text: "Password",
                                  //         style: TextStyle(
                                  //             fontWeight: FontWeight.w800,
                                  //             fontSize: 16),
                                  //       ),
                                  //     ),
                                  //     const Text(":"),
                                  //     const SizedBox(width: 20),
                                  //     Text(
                                  //       user.password!,
                                  //       style: const TextStyle(fontSize: 14),
                                  //     )
                                  //   ],
                                  // ),
                                  // const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Position",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: user.profession!,
                                        style: const TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Baptize Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: user.baptizeDate!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Blood Group",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: user.bloodGroup!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Date of Birth",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: user.dob!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Locality",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: user.locality!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "About",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: user.about!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: user.address!,
                                        style: const TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
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

  editPopUp(UserModel user, Size size) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context,setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: marriedController.toUpperCase() ==
                    "MARRIED"? size.height * 1.95 : size.height * 1.85,
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
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                      width: double.infinity,
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            KText(
                              text: "Edit User",
                              style: GoogleFonts.openSans(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  uploadedImage = null;
                                  profileImage = null;
                                  baptizeDateController.text = "";
                                  bloodGroupController.text = "";
                                  dobController.text = "";
                                  addressController.text = "";
                                  anniversaryDateController.text = "";
                                  marriedController = "Select Status";
                                  emailController.text = "";
                                  firstNameController.text = "";
                                  aboutController.text = "";
                                  lastNameController.text = "";
                                  //passwordController.text = "";
                                  localityController.text = "";
                                  phoneController.text = "";
                                  professionController.text = "";
                                  //confPaswordController.text = "";
                                });
                                Navigator.pop(context);
                              },
                              child: const Icon(
                                Icons.cancel_outlined,
                              ),
                            )
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
                            )),
                        padding: const EdgeInsets.all(15),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height: 170,
                                  width: 350,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants().primaryAppColor,
                                          width: 2),
                                      image: selectedImg != null
                                          ? DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(selectedImg!))
                                          : uploadedImage != null
                                              ? DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: MemoryImage(
                                                    Uint8List.fromList(
                                                      base64Decode(uploadedImage!
                                                          .split(',')
                                                          .last),
                                                    ),
                                                  ),
                                                )
                                              : null),
                                  child: selectedImg == null
                                      ? const Center(
                                          child: Icon(
                                            Icons.cloud_upload,
                                            size: 160,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: selectImage,
                                    child: Container(
                                      height: 35,
                                      width: size.width * 0.25,
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
                                  const SizedBox(width: 50),
                                  Container(
                                    height: 35,
                                    width: size.width * 0.25,
                                    color: Constants().primaryAppColor,
                                    child: const Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.crop,
                                          color: Colors.white,
                                        ),
                                        SizedBox(width: 10),
                                        KText(
                                          text: 'Disable Crop',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Firstname",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: const TextStyle(fontSize: 12),
                                          controller: firstNameController,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Lastname",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: const TextStyle(fontSize: 12),
                                          controller: lastNameController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Email",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: const TextStyle(fontSize: 12),
                                          controller: emailController,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Phone",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: const TextStyle(fontSize: 12),
                                          controller: phoneController,
                                        )
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: 300,
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       KText(
                                  //         text: "Password",
                                  //         style: GoogleFonts.openSans(
                                  //           color: Colors.black,
                                  //           fontSize: 13,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       TextFormField(
                                  //         style: const TextStyle(fontSize: 12),
                                  //         controller: passwordController,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  // const SizedBox(width: 20),
                                  // SizedBox(
                                  //   width: 300,
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       KText(
                                  //         text: "Confirm Password",
                                  //         style: GoogleFonts.openSans(
                                  //           color: Colors.black,
                                  //           fontSize: 13,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       TextFormField(
                                  //         style: const TextStyle(fontSize: 12),
                                  //         controller: confPaswordController,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Profession",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: const TextStyle(fontSize: 12),
                                          controller: professionController,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Baptize Date",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: const TextStyle(fontSize: 12),
                                          controller: baptizeDateController,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Marital status",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: marriedController,
                                          icon:
                                          const Icon(Icons.keyboard_arrow_down),
                                          items: ["Select Status", "Married", "Single"]
                                              .map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              marriedController = newValue!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Visibility(
                                visible: marriedController.toUpperCase() ==
                                    "MARRIED",
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: 300,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Anniversary Date",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: 13,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                            style: const TextStyle(fontSize: 12),
                                            controller: anniversaryDateController,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Blood Group",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: const TextStyle(fontSize: 12),
                                          controller: bloodGroupController,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Date of Birth",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: const TextStyle(fontSize: 12),
                                          controller: dobController,
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  SizedBox(
                                    width: 300,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Locality",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: const TextStyle(fontSize: 12),
                                          controller: localityController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
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
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                style:
                                                    const TextStyle(fontSize: 12),
                                                controller: addressController,
                                                decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(
                                                        left: 15,
                                                        top: 4,
                                                        bottom: 4)),
                                                maxLines: null,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "About",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
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
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        const SizedBox(
                                          height: 20,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                style:
                                                    const TextStyle(fontSize: 12),
                                                controller: aboutController,
                                                decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(
                                                        left: 15,
                                                        top: 4,
                                                        bottom: 4)),
                                                maxLines: null,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (baptizeDateController.text != "" &&
                                          bloodGroupController.text != "" &&
                                          aboutController.text != "" &&
                                          dobController.text != "" &&
                                          addressController.text != "" &&
                                          emailController.text != "" &&
                                          //passwordController.text != "" &&
                                          marriedController != "Select Status" &&
                                          firstNameController.text != "" &&
                                          //confPaswordController.text != "" &&
                                          lastNameController.text != "" &&
                                          localityController.text != "" &&
                                          phoneController.text != "" &&
                                          professionController.text != "") {
                                        Response response =
                                            await UserFireCrud.updateRecord(
                                                UserModel(
                                                  id: user.id,
                                                  timestamp: user.timestamp,
                                                  baptizeDate:
                                                      baptizeDateController.text,
                                                  bloodGroup:
                                                      bloodGroupController.text,
                                                  dob: dobController.text,
                                                  address: addressController.text,
                                                  email: emailController.text,
                                                  firstName:
                                                      firstNameController.text,
                                                  maritialStatus: marriedController,
                                                  anniversaryDate:  marriedController.toUpperCase() ==
                                                      "MARRIED"? anniversaryDateController.text : "",
                                                  lastName: lastNameController.text,
                                                  locality: localityController.text,
                                                  phone: phoneController.text,
                                                  profession:
                                                      professionController.text,
                                                  about: aboutController.text,
                                                  //password: passwordController.text,
                                                ),
                                                profileImage,
                                                user.imgUrl ?? "");
                                        if (response.code == 200) {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: "User updated successfully!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          setState(() {
                                            uploadedImage = null;
                                            profileImage = null;
                                            baptizeDateController.text = "";
                                            bloodGroupController.text = "";
                                            dobController.text = "";
                                            emailController.text = "";
                                            firstNameController.text = "";
                                            aboutController.text = "";
                                            lastNameController.text = "";
                                            anniversaryDateController.text = "";
                                            marriedController = "Select Status";
                                            //passwordController.text = "";
                                            localityController.text = "";
                                            phoneController.text = "";
                                            professionController.text = "";
                                            //confPaswordController.text = "";
                                          });
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: "Failed to update User!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: KText(
                                            text: "Update",
                                            style: GoogleFonts.openSans(
                                              color: Colors.white,
                                              fontSize: 10,
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

  convertToCsv(List<UserModel> users) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Name");
    row.add("Phone");
    row.add("Email");
    row.add("Profession");
    row.add("Baptize Date");
    row.add("Marital Status");
    row.add("Blood Group");
    row.add("Date of birth");
    row.add("Locality");
    row.add("Address");
    row.add("About");
    rows.add(row);
    for (int i = 0; i < users.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("${users[i].firstName!} ${users[i].lastName!}");
      row.add(users[i].phone);
      row.add(users[i].email);
      row.add(users[i].profession);
      row.add(users[i].baptizeDate);
      row.add(users[i].maritialStatus);
      row.add(users[i].bloodGroup);
      row.add(users[i].dob);
      row.add(users[i].locality);
      row.add(users[i].address);
      row.add(users[i].about);
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);
    saveCsvToFile(csv);
  }

  void saveCsvToFile(csvString) async {
    final blob = Blob([Uint8List.fromList(csvString.codeUnits)]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "data.csv")
      ..click();
    Url.revokeObjectUrl(url);
  }

  void savePdfToFile(data) async {
    final blob = Blob([data],'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "Users.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<UserModel> users) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Name");
    row.add("    ");
    row.add("Profession");
    row.add("    ");
    row.add("Phone");
    row.add("    ");
    row.add("Locality");
    rows.add(row);
    for (int i = 0; i < users.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add("${users[i].firstName} ${users[i].lastName}");
      row.add("       ");
      row.add(users[i].profession);
      row.add("       ");
      row.add(users[i].phone);
      row.add("       ");
      row.add(users[i].locality);
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows,
        fieldDelimiter: null,
        eol: null,
        textEndDelimiter: null,
        delimitAllFields: false,
        textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",", "")));
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

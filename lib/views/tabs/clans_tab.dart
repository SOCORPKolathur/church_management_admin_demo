import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:church_management_admin/models/clan_member_model.dart';
import 'package:church_management_admin/services/clans_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/clan_model.dart';
import '../../models/response.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';
import '../prints/clan_print.dart';
import 'package:intl/intl.dart';

class ClansTab extends StatefulWidget {
  ClansTab({super.key});

  @override
  State<ClansTab> createState() => _ClansTabState();
}

class _ClansTabState extends State<ClansTab> {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController baptizeDateController = TextEditingController();
  TextEditingController marriageDateController = TextEditingController();
  TextEditingController socialStatusController = TextEditingController(text: "Select");
  TextEditingController jobController = TextEditingController();
  TextEditingController familyController = TextEditingController();
  TextEditingController departmentController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController(text: "Select Blood Group");
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController genderController = TextEditingController(text: 'Select Gender');
  File? profileImage;
  var uploadedImage;
  String? selectedImg;

  String searchString = "";

  String currentTab = 'View';
  String currentClanId = '';
  TextEditingController clanNameController = TextEditingController();


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

  bool isEmail(String input) => EmailValidator.validate(input);
  final _key = GlobalKey<FormFieldState>();

  final _keyFirstname = GlobalKey<FormFieldState>();
  final _keyLastname = GlobalKey<FormFieldState>();
  final _keyPhone = GlobalKey<FormFieldState>();
  final _keyFamily = GlobalKey<FormFieldState>();
  final _keyDepartment = GlobalKey<FormFieldState>();
  final _keyDob = GlobalKey<FormFieldState>();
  final _keyNationality = GlobalKey<FormFieldState>();
  final _keyPincode = GlobalKey<FormFieldState>();
  bool profileImageValidator = false;
  bool isLoading = false;
  bool isCropped = false;
  String chumma = '';

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height/81.375,
          horizontal: width/170.75
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
          vertical: height/81.375,
          horizontal: width/170.75
      ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "FLOCKS",
                    style: GoogleFonts.openSans(
                        fontSize: width/52.538,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                  InkWell(
                      onTap:(){
                        addClanPopUp();
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
                              text: "Add Flock",
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
            currentTab.toUpperCase() == "ADD"
                ? Container(
              height: size.height * 1.51,
              width: width/1.241,
              margin:   EdgeInsets.symmetric(
                          vertical: height/32.55,
                          horizontal: width/68.3
                      ),
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: "ADD FLOCK MEMBER",
                            style: GoogleFonts.openSans(
                                fontSize: width/68.3,
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
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      padding:   EdgeInsets.symmetric(
                          vertical: height/32.55,
                          horizontal: width/68.3
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height:height/3.829,
                               width:width/3.902,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Constants().primaryAppColor,
                                      width: 2),
                                  image: uploadedImage != null
                                      ? DecorationImage(
                                    fit: isCropped ? BoxFit.contain : BoxFit.cover,
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
                                  size:width/8.5375,
                                  color: Colors.grey,
                                ),
                              ) : null,
                            ),
                          ),
                          SizedBox(height:height/32.55),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: selectImage,
                                child: Container(
                                  height:height/18.6,
                                  width: size.width * 0.25,
                                  color: Constants().primaryAppColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          color: Colors.white),
                                      SizedBox(width:width/136.6),
                                      KText(
                                        text: 'Select Profile Photo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width:width/27.32),
                              InkWell(
                                onTap: (){
                                  if(isCropped){
                                    setState(() {
                                      isCropped = false;
                                    });
                                  }else{
                                    setState(() {
                                      isCropped = true;
                                    });
                                  }
                                },
                                child: Container(
                                  height:height/18.6,
                                  width: size.width * 0.25,
                                  color: Constants().primaryAppColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.crop,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width:width/136.6),
                                      KText(
                                        text: 'Disable Crop',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:height/21.7),
                          Row(
                            children: [
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Firstname *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        counterText: "",
                                      ),
                                      maxLength: 40,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                      ],
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: firstNameController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Lastname *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        counterText: "",
                                      ),
                                      maxLength: 40,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                      ],
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: lastNameController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              Container(
                             width:width/4.553,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width:width/910.66
                                    )
                                  )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Gender *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      value: genderController.text,
                                      isExpanded: true,
                                      underline: Container(),
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      items: [
                                        "Select Gender",
                                        "Male",
                                        "Female",
                                        "Transgender"
                                      ].map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          genderController.text = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:height/21.7),
                          Row(
                            children: [
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Phone *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: phoneController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Email",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      key: _key,
                                      validator: (value) {
                                        if (!isEmail(value!)) {
                                          return 'Please enter a valid email.';
                                        }
                                        return null;
                                      },
                                      onEditingComplete: (){
                                        _key.currentState!.validate();
                                      },
                                      onChanged: (val){
                                        _key.currentState!.validate();
                                      },
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: emailController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:height/21.7),
                          Row(
                            children: [
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Position",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        counterText: "",
                                      ),
                                      maxLength: 100,
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                      ],
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: positionController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Baptism Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                        await Constants().datePicker(context);
                                        if (pickedDate != null) {
                                          setState(() {
                                            baptizeDateController.text = formatter.format(pickedDate);
                                          });
                                        }
                                      },
                                      controller: baptizeDateController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:height/21.7),
                          Row(
                            children: [
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Anniversary Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                        await Constants().datePicker(context);
                                        if (pickedDate != null) {
                                          setState(() {
                                            marriageDateController.text = formatter.format(pickedDate);
                                          });
                                        }
                                      },
                                      controller: marriageDateController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              Container(
                             width:width/4.553,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width:width/910.66,
                                      color: Colors.grey
                                    )
                                  )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Social Status",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      isExpanded: true,
                                      value: socialStatusController.text,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: Container(),
                                      items: [
                                        "Select",
                                        "Politicians",
                                        "Social Service",
                                        "Others"
                                      ].map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          socialStatusController.text = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Employment/Job",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: jobController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:height/21.7),
                          Row(
                            children: [
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Family *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: familyController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Department *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        counterText: "",
                                      ),
                                      maxLength: 100,
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: departmentController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Blood Group *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: bloodGroupController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:height/21.7),
                          Row(
                            children: [
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Date of Birth *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      onTap: () async {
                                        DateTime? pickedDate =
                                        await Constants().datePicker(context);
                                        if (pickedDate != null) {
                                          setState(() {
                                            dobController.text = formatter.format(pickedDate);
                                          });
                                        }
                                      },
                                      controller: dobController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Nationality *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      decoration: InputDecoration(
                                        counterText: "",
                                      ),
                                      maxLength: 40,
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: nationalityController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                             width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Pin code *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                           fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: pincodeController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:height/21.7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (profileImage != null &&
                                      baptizeDateController.text != "" &&
                                      bloodGroupController.text != "" &&
                                      departmentController.text != "" &&
                                      dobController.text != "" &&
                                      emailController.text != "" &&
                                      familyController.text != "" &&
                                      pincodeController.text != "" &&
                                      firstNameController.text != "" &&
                                      jobController.text != "" &&
                                      lastNameController.text != "" &&
                                      nationalityController.text != "" &&
                                      phoneController.text != "" &&
                                      positionController.text != "" &&
                                      socialStatusController.text != "") {
                                    //Response response =
                                    // await ClansFireCrud.addClan(
                                    //   image: profileImage!,
                                    //   baptizeDate: baptizeDateController.text,
                                    //   bloodGroup: bloodGroupController.text,
                                    //   pincode: pincodeController.text,
                                    //   department: departmentController.text,
                                    //   dob: dobController.text,
                                    //   email: emailController.text,
                                    //   family: familyController.text,
                                    //   firstName: firstNameController.text,
                                    //   job: jobController.text,
                                    //   lastName: lastNameController.text,
                                    //   marriageDate: marriageDateController.text,
                                    //   nationality: nationalityController.text,
                                    //   phone: phoneController.text,
                                    //   position: positionController.text,
                                    //   socialStatus: socialStatusController.text,
                                    //   country: countryController.text,
                                    //   gender : genderController.text
                                    // );
                                    if (true) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Flock created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        currentTab = 'View';
                                        uploadedImage = null;
                                        profileImage = null;
                                        baptizeDateController.text = "";
                                        bloodGroupController.text = "Select Blood Group";
                                        departmentController.text = "";
                                        pincodeController.text = "";
                                        dobController.text = "";
                                        emailController.text = "";
                                        familyController.text = "";
                                        firstNameController.text = "";
                                        jobController.text = "";
                                        lastNameController.text = "";
                                        marriageDateController.text = "";
                                        nationalityController.text = "";
                                        phoneController.text = "";
                                        positionController.text = "";
                                        socialStatusController.text = "";
                                        countryController.text = "";
                                        genderController.text = "Select Gender";
                                      });
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Clan!",
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
                                  height:height/18.6,
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
                                          color: Colors.white,
                                           fontSize:width/136.6,
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
            )
                : currentTab.toUpperCase() == "VIEW" ?
                StreamBuilder(
                  stream: ClansFireCrud.fetchClans(),
                  builder: (ctx, snap){
                    if(snap.hasData){
                      List<ClansModel> clans1 = snap.data!;
                      List<ClansModel> clans = [];
                      if(searchString != ""){
                        clans1.forEach((element) {
                          if(element.clanName!.toLowerCase().startsWith(searchString.toLowerCase())){
                            clans.add(
                                ClansModel(
                                    id: element.id,
                                    clanName: element.clanName
                                )
                            );
                          }
                        });
                      }else{
                        clans1.forEach((element) {
                          clans.add(
                            ClansModel(
                              id: element.id,
                              clanName: element.clanName
                            )
                          );
                        });
                      }
                      return Container(
                                width: width/1.241,
                                margin:   EdgeInsets.symmetric(
                          vertical: height/32.55,
                          horizontal: width/68.3
                      ),
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
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            KText(
                                              text: "All Flocks (${clans.length})",
                                              style: GoogleFonts.openSans(
                                                  fontSize: width/68.3,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Container(
                                              height:height/18.6,
                                                  width: width/9.106,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: TextField(
                                                onChanged: (val) {
                                                  setState(() {
                                                    searchString = val;
                                                  });
                                                },
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Search',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  contentPadding:  EdgeInsets.only(
                                                      left: width/136.6, bottom: height/65.1),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Container(
                                      height: size.height * 0.73,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(10),
                                            bottomRight: Radius.circular(10),
                                          )),
                                      padding:   EdgeInsets.symmetric(
                          vertical: height/32.55,
                          horizontal: width/68.3
                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: width/455.33,
                                                vertical: height/217
                                              ),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                   width:width/17.075,
                                                    child: KText(
                                                      text: "No.",
                                                      style: GoogleFonts.poppins(
                                                           fontSize:width/105.07,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:width/8.035,
                                                    child: KText(
                                                      text: "Name",
                                                      style: GoogleFonts.poppins(
                                                           fontSize:width/105.07,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width:width/4.878,
                                                    child: KText(
                                                      text: "Actions",
                                                      style: GoogleFonts.poppins(
                                                           fontSize:width/105.07,
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
                                              itemCount: clans.length,
                                              itemBuilder: (ctx, i) {
                                                return Container(
                                                  height:height/10.85,
                                                  width: double.infinity,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    border: Border(
                                                      top: BorderSide(
                                                        color: Color(0xfff1f1f1),
                                                        width:width/2732,
                                                      ),
                                                      bottom: BorderSide(
                                                        color: Color(0xfff1f1f1),
                                                        width:width/2732,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      vertical: height/130.2,
                                                      horizontal: width/273.2
                                                    ),
                                                    child: Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        SizedBox(
                                                         width:width/17.075,
                                                          child: KText(
                                                            text: (i + 1).toString(),
                                                            style: GoogleFonts.poppins(
                                                                 fontSize:width/105.07,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          width:width/8.035,
                                                          child: KText(
                                                            text:
                                                            clans[i].clanName!,
                                                            style: GoogleFonts.poppins(
                                                                 fontSize:width/105.07,
                                                              fontWeight: FontWeight.w600,
                                                            ),
                                                          ),
                                                        ),
                                                        SizedBox(
                                                            width:width/4.878,
                                                            child: Row(
                                                              children: [
                                                                InkWell(
                                                                  onTap: () {
                                                                    addClanMember(clans[i].id!);
                                                                  },
                                                                  child: Container(
                                                                    height: height/26.04,
                                                                    decoration:
                                                                    BoxDecoration(
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
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:width/227.66),
                                                                      child: Center(
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                          children: [
                                                                            KText(
                                                                              text: "Add member",
                                                                              style: GoogleFonts
                                                                                  .openSans(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontSize:width/136.6,
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
                                                                SizedBox(width: width/273.2),
                                                                InkWell(
                                                                  onTap: () {
                                                                    setState(() {
                                                                      currentClanId = clans[i].id!;
                                                                      currentTab = 'View Members';
                                                                    });
                                                                  },
                                                                  child: Container(
                                                                    height: height/26.04,
                                                                    decoration:
                                                                    BoxDecoration(
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
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:width/227.66),
                                                                      child: Center(
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                          children: [
                                                                            KText(
                                                                              text: "View Members",
                                                                              style: GoogleFonts
                                                                                  .openSans(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontSize:width/136.6,
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
                                                                SizedBox(width: width/273.2),
                                                                InkWell(
                                                                  onTap: () {
                                                                    CoolAlert.show(
                                                                        context: context,
                                                                        type: CoolAlertType.info,
                                                                        text: "${clans[i].clanName} will be deleted",
                                                                        title: "Delete this Record?",
                                                                        width: size.width * 0.4,
                                                                        backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                                        showCancelBtn: true,
                                                                        cancelBtnText: 'Cancel',
                                                                        cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                                        onConfirmBtnTap: () async {
                                                                          Response res = await ClansFireCrud.deleteRecord(docId: clans[i].id!);
                                                                        }
                                                                    );
                                                                  },
                                                                  child: Container(
                                                                    height: height/26.04,
                                                                    decoration:
                                                                    BoxDecoration(
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
                                                                      EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:width/227.66),
                                                                      child: Center(
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .spaceAround,
                                                                          children: [
                                                                            Icon(
                                                                              Icons
                                                                                  .cancel_outlined,
                                                                              color: Colors
                                                                                  .white,
                                                                              size:width/91.06,
                                                                            ),
                                                                            KText(
                                                                              text:
                                                                              "Delete",
                                                                              style: GoogleFonts
                                                                                  .openSans(
                                                                                color: Colors
                                                                                    .white,
                                                                                fontSize:width/136.6,
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
                                                            )
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
                              );
                    }return Container();
                  },
                ) : currentTab.toUpperCase() == "VIEW MEMBERS" ?
            StreamBuilder(
              //stream: ClansFireCrud.fetchClanMembers(currentClanId),// searchString != "" ? ClansFireCrud.fetchClansWithSearch(searchString) : ,
              stream: cf.FirebaseFirestore.instance.collection('Clans').doc(currentClanId).collection('ClansMembers').snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  //List<ClanMemberModel> clansMembers = snapshot.data!;
                  List<cf.DocumentSnapshot> clansMembers1 = snapshot.data!.docs;
                  List<ClanMemberModel> clansMembers = [];
                  // clansMembers1.forEach((element) {
                  //   if(searchString != ""){
                  //     if(
                  //     //element.get("profession")!.toLowerCase().startsWith(searchString.toLowerCase())||
                  //     element.firstName!.toLowerCase().startsWith(searchString.toLowerCase())||
                  //         (element.firstName!+element.lastName!).toString().trim().toLowerCase().startsWith(searchString.toLowerCase()) ||
                  //         element.lastName!.toLowerCase().startsWith(searchString.toLowerCase())){
                  //       //element.get("phone")!.toLowerCase().startsWith(searchString.toLowerCase())){
                  //       clansMembers.add(element);
                  //     }else{
                  //       clansMembers.add(element);
                  //     }
                  //   }
                  // });
                  for(int d = 0; d < clansMembers1.length; d++){
                    clansMembers.add(ClanMemberModel.fromJson(clansMembers1[d].data() as Map<String,dynamic>));
                  }
                  return Container(
                    width: width/1.241,
                    margin:   EdgeInsets.symmetric(
                          vertical: height/32.55,
                          horizontal: width/68.3
                      ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "All Flock Members (${clansMembers.length})",
                                  style: GoogleFonts.openSans(
                                      fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Row(
                                  children: [
                                    Container(
                                      height:height/18.6,
                                      width: width/9.106,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: TextField(
                                        onChanged: (val) {
                                          setState(() {
                                            searchString = val;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText: 'Search by Name',
                                          hintStyle: TextStyle(
                                            color: Colors.black,
                                          ),
                                          contentPadding:  EdgeInsets.only(
                                              left: width/136.6, bottom: height/65.1),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          currentClanId = '';
                                          currentTab = 'View';
                                        });
                                      },
                                      child: Container(
                                        height:height/18.6,
                                            width: width/9.106,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                            child: Text("View Flocks"),
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.73,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding:   EdgeInsets.symmetric(
                          vertical: height/32.55,
                          horizontal: width/68.3
                      ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      generateClanPdf(PdfPageFormat.letter, clansMembers, false);
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
                                            horizontal:width/227.66),
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
                                  SizedBox(width:width/136.6),
                                  InkWell(
                                    onTap: () {
                                      copyToClipBoard(clansMembers);
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
                                            horizontal:width/227.66),
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
                                  SizedBox(width:width/136.6),
                                  InkWell(
                                    onTap: () async {
                                      var data = await generateClanPdf(PdfPageFormat.letter, clansMembers, true);
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
                                            horizontal:width/227.66),
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
                                  SizedBox(width:width/136.6),
                                  InkWell(
                                    onTap: () {
                                      convertToCsv(clansMembers);
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
                                            horizontal:width/227.66),
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
                              SizedBox(height:height/21.7),
                              SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                                horizontal: width/455.33,
                                                vertical: height/217
                                              ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                       width:width/17.075,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/13.660,
                                        child: KText(
                                          text: "Photo",
                                          style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/8.035,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                            width: width/9.106,
                                        child: KText(
                                          text: "Position",
                                          style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/8.035,
                                        child: KText(
                                          text: "Phone",
                                          style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                            width: width/9.106,
                                        child: KText(
                                          text: "Gender",
                                          style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/7.588,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
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
                                  itemCount: clansMembers.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height:height/10.85,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          top: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width:width/2732,
                                          ),
                                          bottom: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width:width/2732,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                                      vertical: height/130.2,
                                                      horizontal: width/273.2
                                                    ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                             width:width/17.075,
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                     fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/13.660,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                    NetworkImage(clansMembers[i].imgUrl!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/8.035,
                                              child: KText(
                                                text:
                                                "${clansMembers[i].firstName!} ${clansMembers[i].lastName!}",
                                                style: GoogleFonts.poppins(
                                                     fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                  width: width/9.106,
                                              child: KText(
                                                text: clansMembers[i].position!,
                                                style: GoogleFonts.poppins(
                                                     fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/8.035,
                                              child: KText(
                                                text: clansMembers[i].phone!,
                                                style: GoogleFonts.poppins(
                                                     fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                  width: width/9.106,
                                              child: KText(
                                                text: clansMembers[i].gender!,
                                                style: GoogleFonts.poppins(
                                                     fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width:width/7.588,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        viewPopup(clansMembers[i]);
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                        BoxDecoration(
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
                                                          EdgeInsets
                                                              .symmetric(
                                                              horizontal:width/227.66),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                  color: Colors
                                                                      .white,
                                                                  size:width/91.06,
                                                                ),
                                                                KText(
                                                                  text: "View",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:width/136.6,
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
                                                    SizedBox(width:width/273.2),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          baptizeDateController.text = clansMembers[i].baptizeDate!;
                                                          bloodGroupController.text = clansMembers[i].bloodGroup!;
                                                          departmentController.text = clansMembers[i].department!;
                                                          dobController.text = clansMembers[i].dob!;
                                                          emailController.text = clansMembers[i].email!;
                                                          familyController.text = clansMembers[i].family!;
                                                          firstNameController.text = clansMembers[i].firstName!;
                                                          jobController.text = clansMembers[i].job!;
                                                          lastNameController.text = clansMembers[i].lastName!;
                                                          marriageDateController.text = clansMembers[i].marriageDate!;
                                                          nationalityController.text = clansMembers[i].nationality!;
                                                          phoneController.text = clansMembers[i].phone!;
                                                          positionController.text = clansMembers[i].position!;
                                                          socialStatusController.text = clansMembers[i].socialStatus!;
                                                          countryController.text = clansMembers[i].country!;
                                                          genderController.text = clansMembers[i].gender!;
                                                          pincodeController.text = clansMembers[i].pincode!;
                                                          selectedImg = clansMembers[i].imgUrl;
                                                        });
                                                        editClanMember(currentClanId, clansMembers[i]);
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                        BoxDecoration(
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
                                                          EdgeInsets
                                                              .symmetric(
                                                              horizontal:width/227.66),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size:width/91.06,
                                                                ),
                                                                KText(
                                                                  text: "Edit",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:width/136.6,
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
                                                    SizedBox(width:width/273.2),
                                                    InkWell(
                                                      onTap: () {
                                                        CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType.info,
                                                            text: "${clansMembers[i].firstName} ${clansMembers[i].lastName} will be deleted",
                                                            title: "Delete this Record?",
                                                            width: size.width * 0.4,
                                                            backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            showCancelBtn: true,
                                                            cancelBtnText: 'Cancel',
                                                            cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                            onConfirmBtnTap: () async {
                                                              Response res = await ClansFireCrud.deleteMemberRecord(docId: currentClanId,id: clansMembers[i].id!);
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                        BoxDecoration(
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
                                                          EdgeInsets
                                                              .symmetric(
                                                              horizontal:width/227.66),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .cancel_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size:width/91.06,
                                                                ),
                                                                KText(
                                                                  text:
                                                                  "Delete",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:width/136.6,
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
            ) : Container(),
            SizedBox(height: size.height * 0.04),
            const DeveloperCardWidget(),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }

  viewPopup(ClanMemberModel clan) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: size.width * 0.5,
            margin:   EdgeInsets.symmetric(
                          vertical: height/32.55,
                          horizontal: width/68.3
                      ),
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
              children: [
                SizedBox(
                  height: size.height * 0.1,
                  width: double.infinity,
                  child: Padding(
                    padding:
                    EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          clan.firstName!,
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
                            height:height/16.275,
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
                                  text: "CLOSE",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/85.375,
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
                    decoration: BoxDecoration(
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
                                image: NetworkImage(clan.imgUrl!),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width/136.6, vertical: height/43.4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: "${clan.firstName!} ${clan.lastName!}",
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Phone",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.phone!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Email",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.email!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Gender",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.gender!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Position",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.position!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Department",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.department!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Family",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.family!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Baptism Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.baptizeDate!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Social Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.socialStatus!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Marriage Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.marriageDate!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Employment/Job",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.job!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Blood Group",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.bloodGroup!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Date of Birth",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.dob!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Nationality",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: clan.nationality!,
                                        style: TextStyle(
                                            fontSize:width/97.571
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/32.55),
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

  addClanMember(String docId) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStat) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content:  Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    height: size.height * 1.51,
                    width: width/1.241,
                    margin:   EdgeInsets.symmetric(
                                  vertical: height/32.55,
                                  horizontal: width/68.3
                              ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "ADD FLOCK MEMBER",
                                  style: GoogleFonts.openSans(
                                      fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      uploadedImage = null;
                                      profileImage = null;
                                      baptizeDateController.text = "";
                                      bloodGroupController.text = "Select Blood Group";
                                      departmentController.text = "";
                                      dobController.text = "";
                                      emailController.text = "";
                                      familyController.text = "";
                                      pincodeController.text = "";
                                      firstNameController.text = "";
                                      jobController.text = "";
                                      lastNameController.text = "";
                                      marriageDateController.text = "";
                                      nationalityController.text = "";
                                      phoneController.text = "";
                                      positionController.text = "";
                                      socialStatusController.text = "";
                                      countryController.text = "";
                                      genderController.text = 'Select Gender';
                                    });
                                    Navigator.pop(context);
                                  },
                                  child: Icon(
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
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                            padding:   EdgeInsets.symmetric(
                                  vertical: height/32.55,
                                  horizontal: width/68.3
                              ),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Center(
                                    child: Container(
                                      height:height/3.829,
                                       width:width/3.902,
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
                                            fit: isCropped ? BoxFit.contain : BoxFit.cover,
                                            image: MemoryImage(
                                              Uint8List.fromList(
                                                base64Decode(uploadedImage!
                                                    .split(',')
                                                    .last),
                                              ),
                                            ),
                                          )
                                              : null),
                                      child: (uploadedImage == null && selectedImg == null)
                                          ? Center(
                                        child: Icon(
                                          Icons.cloud_upload,
                                          size:width/8.5375,
                                          color: Colors.grey,
                                        ),
                                      )
                                          : null,
                                    ),
                                  ),
                                  SizedBox(height:height/32.55),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      InkWell(
                                        onTap: (){
                                          InputElement input = FileUploadInputElement()
                                          as InputElement
                                            ..accept = 'image/*';
                                          input.click();
                                          input.onChange.listen((event) {
                                            final file = input.files!.first;
                                            FileReader reader = FileReader();
                                            reader.readAsDataUrl(file);
                                            reader.onLoadEnd.listen((event) {
                                              setStat(() {
                                                profileImage = file;
                                              });
                                              setStat(() {
                                                uploadedImage = reader.result;
                                                selectedImg = null;
                                              });
                                            });
                                            setStat(() {});
                                          });
                                        },
                                        child: Container(
                                          height:height/18.6,
                                          width: size.width * 0.25,
                                          color: Constants().primaryAppColor,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons.add_a_photo,
                                                  color: Colors.white),
                                              SizedBox(width:width/136.6),
                                              KText(
                                                text: 'Select Profile Photo',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      SizedBox(width:width/27.32),
                                      InkWell(
                                        onTap: (){
                                          if(isCropped){
                                            setStat(() {
                                              isCropped = false;
                                            });
                                          }else{
                                            setStat(() {
                                              isCropped = true;
                                            });
                                          }
                                        },
                                        child: Container(
                                          height:height/18.6,
                                          width: size.width * 0.25,
                                          color: Constants().primaryAppColor,
                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.crop,
                                                color: Colors.white,
                                              ),
                                              SizedBox(width:width/136.6),
                                              KText(
                                                text: 'Disable Crop',
                                                style: TextStyle(color: Colors.white),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/21.7),
                                  Row(
                                    children: [
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Firstname *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              key: _keyFirstname,
                                              validator: (val){
                                                if(val!.isEmpty){
                                                  return 'Field is required';
                                                }else{
                                                  return '';
                                                }
                                              },
                                              onChanged: (val){
                                                _keyFirstname.currentState!.validate();
                                              },
                                              decoration: InputDecoration(
                                                counterText: "",
                                              ),
                                              maxLength: 40,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                              ],
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: firstNameController,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Lastname *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              key: _keyLastname,
                                              validator: (val){
                                                if(val!.isEmpty){
                                                  return 'Field is required';
                                                }else{
                                                  return '';
                                                }
                                              },
                                              onChanged: (val){
                                                _keyLastname.currentState!.validate();
                                              },
                                              decoration: InputDecoration(
                                                counterText: "",
                                              ),
                                              maxLength: 40,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                              ],
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: lastNameController,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
                                      Container(
                                     width:width/4.553,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width:width/910.66,
                                              color: Colors.grey
                                            )
                                          )
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Gender *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            DropdownButton(
                                              value: genderController.text,
                                              underline: Container(),
                                              isExpanded: true,
                                              icon: Icon(Icons.keyboard_arrow_down),
                                              items: [
                                                "Select Gender",
                                                "Male",
                                                "Female",
                                                "Transgender"
                                              ].map((items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setStat(() {
                                                  genderController.text = newValue!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/21.7),
                                  Row(
                                    children: [
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Phone *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              key: _keyPhone,
                                              validator: (val){
                                                if(val!.isEmpty) {
                                                  return 'Field is required';
                                                } else if(val.length != 10){
                                                  return 'number must be 10 digits';
                                                }else{
                                                  return '';
                                                }
                                              },
                                              onChanged: (val){
                                                _keyPhone.currentState!.validate();
                                              },
                                              decoration: InputDecoration(
                                                counterText: "",
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]')),
                                              ],
                                              maxLength: 10,
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: phoneController,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Email",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              key: _key,
                                              validator: (value) {
                                                if (!isEmail(value!)) {
                                                  return 'Please enter a valid email.';
                                                }
                                                return null;
                                              },
                                              onEditingComplete: (){
                                                _key.currentState!.validate();
                                              },
                                              onChanged: (val){
                                                _key.currentState!.validate();
                                              },
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: emailController,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/21.7),
                                  Row(
                                    children: [
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Position",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                counterText: "",
                                              ),
                                              maxLength: 100,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                              ],
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: positionController,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Baptism Date",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              readOnly: true,
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: baptizeDateController,
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                await Constants().datePicker(context);
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    baptizeDateController.text = formatter.format(pickedDate);
                                                  });
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/21.7),
                                  Row(
                                    children: [
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Anniversary Date",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              readOnly: true,
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: marriageDateController,
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                await Constants().datePicker(context);
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    marriageDateController.text = formatter.format(pickedDate);
                                                  });
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
                                      Container(
                                     width:width/4.553,
                                        decoration: BoxDecoration(
                                          border: Border(
                                            bottom: BorderSide(
                                              width:width/910.66,
                                              color: Colors.grey
                                            )
                                          )
                                        ),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Social Status",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            DropdownButton(
                                              isExpanded: true,
                                              value: socialStatusController.text,
                                              icon: Icon(Icons.keyboard_arrow_down),
                                              underline: Container(),
                                              items: [
                                                "Select",
                                                "Politicians",
                                                "Social Service",
                                                "Others"
                                              ].map((items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setStat(() {
                                                  socialStatusController.text = newValue!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Employment/Job",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              decoration: InputDecoration(
                                                counterText: "",
                                              ),
                                              maxLength: 100,
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: jobController,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/21.7),
                                  Row(
                                    children: [
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Family *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              key: _keyFamily,
                                              validator: (val){
                                                if(val!.isEmpty){
                                                  return 'Field is required';
                                                }else{
                                                  return '';
                                                }
                                              },
                                              onChanged: (val){
                                                _keyFamily.currentState!.validate();
                                              },
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                              ],
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: familyController,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Department *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              key: _keyDepartment,
                                              validator: (val){
                                                if(val!.isEmpty){
                                                  return 'Field is required';
                                                }else{
                                                  return '';
                                                }
                                              },
                                              onChanged: (val){
                                                _keyDepartment.currentState!.validate();
                                              },
                                              decoration: InputDecoration(
                                                counterText: "",
                                              ),
                                              maxLength: 100,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                              ],
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: departmentController,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
                                      SizedBox(
                                        width: width / 4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Blood Group *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                fontSize: width / 105.076,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: height / 50.076),
                                            DropdownButton(
                                              isExpanded: true,
                                              value: bloodGroupController.text,
                                              icon: const Icon(Icons.keyboard_arrow_down),
                                              items: [
                                                "Select Blood Group",
                                                "AB+",
                                                "AB-",
                                                "O+",
                                                "O-",
                                                "A+",
                                                "A-",
                                                "B+",
                                                "B-"
                                              ].map((items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                if (newValue != "Select Role") {
                                                  setStat(() {
                                                    bloodGroupController.text =
                                                    newValue!;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/21.7),
                                  Row(
                                    children: [
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Date of Birth *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              readOnly: true,
                                              key: _keyDob,
                                              validator: (val){
                                                if(val!.isEmpty){
                                                  return 'Field is required';
                                                }else{
                                                  return '';
                                                }
                                              },
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: dobController,
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                await Constants().datePicker(context);
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    dobController.text = formatter.format(pickedDate);
                                                  });
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Nationality *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              key: _keyNationality,
                                              validator: (val){
                                                if(val!.isEmpty){
                                                  return 'Field is required';
                                                }else{
                                                  return '';
                                                }
                                              },
                                              onChanged: (val){
                                                _keyNationality.currentState!.validate();
                                              },
                                              decoration: InputDecoration(
                                                counterText: "",
                                              ),
                                              maxLength: 40,
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                              ],
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: nationalityController,
                                            )
                                          ],
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
                                      SizedBox(
                                     width:width/4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Pincode *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                   fontSize:width/105.07,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              key: _keyPincode,
                                              validator: (val){
                                                if(val!.length != 6){
                                                  return 'Must be 6 digits';
                                                }else{
                                                  return '';
                                                }
                                              },
                                              onChanged: (val){
                                                _keyPincode.currentState!.validate();
                                              },
                                              decoration: InputDecoration(
                                                counterText: "",
                                              ),
                                              inputFormatters: [
                                                FilteringTextInputFormatter.allow(
                                                    RegExp(r'[0-9]')),
                                              ],
                                              maxLength: 6,
                                              style: TextStyle(fontSize:width/113.83),
                                              controller: pincodeController,
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height:height/21.7),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if(!isLoading){
                                            setState(() {
                                              isLoading = true;
                                            });
                                            _keyFirstname.currentState!.validate();
                                            _keyLastname.currentState!.validate();
                                            _keyPhone.currentState!.validate();
                                            _keyFamily.currentState!.validate();
                                            _keyDepartment.currentState!.validate();
                                            _keyDob.currentState!.validate();
                                            _keyNationality.currentState!.validate();
                                            _keyPincode.currentState!.validate();
                                            // if(profileImage == null){
                                            //   setState(() {
                                            //     profileImageValidator = true;
                                            //   });
                                            // }
                                            if (
                                            //profileImage != null &&
                                                genderController.text != "Select Gender" &&
                                                bloodGroupController.text != "Select Blood Group" &&
                                                departmentController.text != "" &&
                                                pincodeController.text != "" &&
                                                dobController.text != "" &&
                                                familyController.text != "" &&
                                                firstNameController.text != "" &&
                                                lastNameController.text != "" &&
                                                nationalityController.text != "" &&
                                                phoneController.text != "") {
                                              Response response =
                                              await ClansFireCrud.addClanMember(
                                                  image: profileImage,
                                                  docId: docId,
                                                  baptizeDate: baptizeDateController.text,
                                                  bloodGroup: bloodGroupController.text,
                                                  department: departmentController.text,
                                                  dob: dobController.text,
                                                  email: emailController.text,
                                                  family: familyController.text,
                                                  firstName: firstNameController.text,
                                                  job: jobController.text,
                                                  pincode: pincodeController.text,
                                                  lastName: lastNameController.text,
                                                  marriageDate: marriageDateController.text,
                                                  nationality: nationalityController.text,
                                                  phone: phoneController.text,
                                                  position: positionController.text,
                                                  socialStatus: socialStatusController.text,
                                                  country: countryController.text,
                                                  gender : genderController.text
                                              );
                                              if (response.code == 200) {
                                                await CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.success,
                                                    text: "Flock member created successfully!",
                                                    width: size.width * 0.4,
                                                    backgroundColor: Constants()
                                                        .primaryAppColor
                                                        .withOpacity(0.8));
                                                setState(() {
                                                  uploadedImage = null;
                                                  profileImage = null;
                                                  baptizeDateController.text = "";
                                                  bloodGroupController.text = "Select Blood Group";
                                                  departmentController.text = "";
                                                  dobController.text = "";
                                                  pincodeController.text = "";
                                                  emailController.text = "";
                                                  familyController.text = "";
                                                  firstNameController.text = "";
                                                  jobController.text = "";
                                                  lastNameController.text = "";
                                                  marriageDateController.text = "";
                                                  nationalityController.text = "";
                                                  phoneController.text = "";
                                                  positionController.text = "";
                                                  socialStatusController.text = "";
                                                  countryController.text = "";
                                                  genderController.text = "Select Gender";
                                                  isLoading = false;
                                                });
                                                Navigator.pop(context);
                                              } else {
                                                await CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.error,
                                                    text: "Failed to create Flock member!",
                                                    width: size.width * 0.4,
                                                    backgroundColor: Constants()
                                                        .primaryAppColor
                                                        .withOpacity(0.8));
                                                Navigator.pop(context);
                                                setState(() {
                                                  isLoading = false;
                                                });
                                              }
                                            } else {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(snackBar);
                                              setState(() {
                                                isLoading = false;
                                              });
                                            }
                                          }
                                        },
                                        child: Container(
                                          height:height/18.6,
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
                                            padding: EdgeInsets.symmetric(horizontal: width/68.3),
                                            child: Center(
                                              child: KText(
                                                text: "Add",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                   fontSize:width/136.6,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      SizedBox(width:width/68.3),
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
                  Visibility(
                    visible: isLoading,
                    child: Container(
                      alignment: AlignmentDirectional.center,
                      decoration: const BoxDecoration(
                        color: Colors.white70,
                      ),
                      child: Container(
                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                        width: size.width/1.37,
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Center(
                              child: SizedBox(
                                  height: height/1.86,
                                  width: width/2.732,
                                  child: Lottie.asset("assets/loadinganim.json")
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 25.0),
                              child: Center(
                                child: Text(
                                  "loading..Please wait...",
                                  style: TextStyle(
                                    fontSize: width/56.91666666666667,
                                    color: Constants().primaryAppColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        );
      },
    );
  }

  editClanMember(String docId, ClanMemberModel clanMember) {
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
              content:  Container(
                height: size.height * 1.51,
                width: width/1.241,
                margin:   EdgeInsets.symmetric(
                              vertical: height/32.55,
                              horizontal: width/68.3
                          ),
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            KText(
                              text: "EDIT FLOCK MEMBER",
                              style: GoogleFonts.openSans(
                                  fontSize: width/68.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  uploadedImage = null;
                                  profileImage = null;
                                  baptizeDateController.text = "";
                                  bloodGroupController.text = "Select Blood Group";
                                  departmentController.text = "";
                                  dobController.text = "";
                                  emailController.text = "";
                                  familyController.text = "";
                                  pincodeController.text = "";
                                  firstNameController.text = "";
                                  jobController.text = "";
                                  lastNameController.text = "";
                                  marriageDateController.text = "";
                                  nationalityController.text = "";
                                  phoneController.text = "";
                                  positionController.text = "";
                                  socialStatusController.text = "";
                                  countryController.text = "";
                                  genderController.text = 'Select Gender';
                                });
                                Navigator.pop(context);
                              },
                              child: Icon(
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
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        padding:   EdgeInsets.symmetric(
                              vertical: height/32.55,
                              horizontal: width/68.3
                          ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Firstname *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: firstNameController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Lastname *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: lastNameController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  Container(
                                 width:width/4.553,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width:width/910.66,
                                                color: Colors.grey
                                            )
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Gender *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: genderController.text,
                                          underline: Container(),
                                          isExpanded: true,
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Gender",
                                            "Male",
                                            "Female",
                                            "Transgender"
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              genderController.text = newValue!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Phone *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 10,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: phoneController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Email *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          key: _key,
                                          validator: (value) {
                                            if (!isEmail(value!)) {
                                              return 'Please enter a valid email.';
                                            }
                                            return null;
                                          },
                                          onEditingComplete: (){
                                            _key.currentState!.validate();
                                          },
                                          onChanged: (val){
                                            _key.currentState!.validate();
                                          },
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: emailController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Position",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: positionController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Baptism Date",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: baptizeDateController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await Constants().datePicker(context);
                                            if (pickedDate != null) {
                                              setState(() {
                                                baptizeDateController.text = formatter.format(pickedDate);
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Anniversary Date",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: marriageDateController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await Constants().datePicker(context);
                                            if (pickedDate != null) {
                                              setState(() {
                                                marriageDateController.text = formatter.format(pickedDate);
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  Container(
                                 width:width/4.553,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                width:width/910.66,
                                                color: Colors.grey
                                            )
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Social Status",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: socialStatusController.text,
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          underline: Container(),
                                          items: [
                                            "Select",
                                            "Politicians",
                                            "Social Service",
                                            "Others"
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              socialStatusController.text = newValue!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                  width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Employment/Job",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: jobController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: familyController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Department *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: departmentController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Blood Group *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height / 50.076),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: bloodGroupController.text,
                                          icon: const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Blood Group",
                                            "AB+",
                                            "AB-",
                                            "O+",
                                            "O-",
                                            "A+",
                                            "A-",
                                            "B+",
                                            "B-"
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            if (newValue != "Select Role") {
                                              setState(() {
                                                bloodGroupController.text =
                                                newValue!;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Date of Birth *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: dobController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await Constants().datePicker(context);
                                            if (pickedDate != null) {
                                              setState(() {
                                                dobController.text = formatter.format(pickedDate);
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Nationality *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: nationalityController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                 width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Pincode *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                               fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: pincodeController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (baptizeDateController.text != "" &&
                                          bloodGroupController.text != "" &&
                                          departmentController.text != "" &&
                                          pincodeController.text != "" &&
                                          dobController.text != "" &&
                                          emailController.text != "" &&
                                          familyController.text != "" &&
                                          firstNameController.text != "" &&
                                          jobController.text != "" &&
                                          lastNameController.text != "" &&
                                          nationalityController.text != "" &&
                                          phoneController.text != "" &&
                                          positionController.text != "" &&
                                          socialStatusController.text != "") {
                                        Response response =
                                        await ClansFireCrud.updateRecord(
                                            ClanMemberModel(
                                                imgUrl: clanMember.imgUrl,
                                                baptizeDate: baptizeDateController.text,
                                                bloodGroup: bloodGroupController.text,
                                                department: departmentController.text,
                                                dob: dobController.text,
                                                email: emailController.text,
                                                family: familyController.text,
                                                firstName: firstNameController.text,
                                                job: jobController.text,
                                                timestamp: clanMember.timestamp,
                                                id: clanMember.id,
                                                pincode: pincodeController.text,
                                                lastName: lastNameController.text,
                                                marriageDate: marriageDateController.text,
                                                nationality: nationalityController.text,
                                                phone: phoneController.text,
                                                position: positionController.text,
                                                socialStatus: socialStatusController.text,
                                                country: countryController.text,
                                                gender : genderController.text
                                            ),
                                            "",
                                            docId
                                        );
                                        if (response.code == 200) {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: "Flock member updated successfully!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          setState(() {
                                            uploadedImage = null;
                                            profileImage = null;
                                            baptizeDateController.text = "";
                                            bloodGroupController.text = "Select Blood Group";
                                            departmentController.text = "";
                                            dobController.text = "";
                                            pincodeController.text = "";
                                            emailController.text = "";
                                            familyController.text = "";
                                            firstNameController.text = "";
                                            jobController.text = "";
                                            lastNameController.text = "";
                                            marriageDateController.text = "";
                                            nationalityController.text = "";
                                            phoneController.text = "";
                                            positionController.text = "";
                                            socialStatusController.text = "";
                                            countryController.text = "";
                                            genderController.text = "Select Gender";
                                          });
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: "Failed to update Flock member!",
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
                                      height:height/18.6,
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
                                        padding: EdgeInsets.symmetric(horizontal: width/68.3),
                                        child: Center(
                                          child: KText(
                                            text: "Update",
                                            style: GoogleFonts.openSans(
                                              color: Colors.white,
                                               fontSize:width/136.6,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
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

  convertToCsv(List<ClanMemberModel> clans) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Name");
    row.add("Phone");
    row.add("Email");
    row.add("Position");
    row.add("Baptism Date");
    row.add("Marriage Date");
    row.add("Social Status");
    row.add("Job");
    row.add("Family");
    row.add("Department");
    row.add("Gender");
    row.add("Blood Group");
    row.add("Date of Birth");
    row.add("Nationality");
    rows.add(row);
    for (int i = 0; i < clans.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("${clans[i].firstName!} ${clans[i].lastName!}");
      row.add(clans[i].phone);
      row.add(clans[i].email);
      row.add(clans[i].position);
      row.add(clans[i].baptizeDate);
      row.add(clans[i].marriageDate);
      row.add(clans[i].socialStatus);
      row.add(clans[i].job);
      row.add(clans[i].family);
      row.add(clans[i].department);
      row.add(clans[i].gender);
      row.add(clans[i].bloodGroup);
      row.add(clans[i].dob);
      row.add(clans[i].nationality);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows);
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
      ..setAttribute("download", "flocks.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<ClanMemberModel> clans) async  {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Name");
    row.add("    ");
    row.add("Position");
    row.add("    ");
    row.add("Phone");
    row.add("    ");
    row.add("Gender");
    rows.add(row);
    for (int i = 0; i < clans.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add("${clans[i].firstName} ${clans[i].lastName}");
      row.add("       ");
      row.add(clans[i].position);
      row.add("       ");
      row.add(clans[i].phone);
      row.add("       ");
      row.add(clans[i].gender);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows,fieldDelimiter: null,eol: null,textEndDelimiter: null,delimitAllFields: false,textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",","")));
  }

  addClanPopUp(){
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: size.height * 0.35,
            width: size.width * 0.4,
            margin:   EdgeInsets.symmetric(
                          vertical: height/32.55,
                          horizontal: width/68.3
                      ),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Add Flock",
                          style: GoogleFonts.openSans(
                              fontSize: width/68.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            InkWell(
                              onTap: () async {
                                if (clanNameController.text != "") {
                                  Response response =
                                  await ClansFireCrud.addClan(
                                      name: clanNameController.text
                                  );
                                  if (response.code == 200) {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Flock created successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    setState(() {
                                      clanNameController.text = "";
                                    });
                                    Navigator.pop(context);
                                  } else {
                                    await CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to create flock!",
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
                                height:height/16.275,
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
                                      text: "Create",
                                      style: GoogleFonts.openSans(
                                        fontSize:width/85.375,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width:width/136.6),
                            InkWell(
                              onTap: () async {
                                setState(() {
                                  clanNameController.text = "";
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height:height/16.275,
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
                                      text: "CANCEL",
                                      style: GoogleFonts.openSans(
                                        fontSize:width/85.375,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Color(0xffF7FAFC),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10),
                      ),
                    ),
                    padding:   EdgeInsets.symmetric(
                          vertical: height/32.55,
                          horizontal: width/68.3
                      ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text: "Flock Name *",
                              style: GoogleFonts.openSans(
                                fontSize:width/97.571,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 6),
                            Material(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white,
                              elevation: 10,
                              child: SizedBox(
                                height: 50,
                                width: 250,
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
          vertical: height/81.375,
          horizontal: width/170.75
      ),
                                  child: TextFormField(
                                    controller: clanNameController,
                                    decoration: InputDecoration(
                                      contentPadding: EdgeInsets.symmetric(vertical: 5),
                                      border: InputBorder.none,
                                      hintStyle: GoogleFonts.openSans(
                                        fontSize:width/97.571,
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
                  ),
                ),
              ],
            ),
          ),
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

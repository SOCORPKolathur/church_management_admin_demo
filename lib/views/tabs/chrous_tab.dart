import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:church_management_admin/models/chorus_model.dart';
import 'package:church_management_admin/services/chorus_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';
import '../prints/chorus_print.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'members_tab.dart';

class ChorusTab extends StatefulWidget {
  ChorusTab({super.key});

  @override
  State<ChorusTab> createState() => _ChorusTabState();
}

class _ChorusTabState extends State<ChorusTab> {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController baptizeDateController = TextEditingController();
  TextEditingController marriageDateController = TextEditingController();
  TextEditingController socialStatusController = TextEditingController(text: "Select");
  TextEditingController genderController = TextEditingController(text: 'Select Gender');
  TextEditingController jobController = TextEditingController();
  String marriedController = "Select Status";
  TextEditingController familyController = TextEditingController(text: "Select");
  TextEditingController familyIDController = TextEditingController(text: "Select");
  TextEditingController departmentController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController(text: 'Select Blood Group');
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();

  File? profileImage;
  var uploadedImage;
  String? selectedImg;

  String searchString = "";

  String currentTab = 'View';

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

  List<FamilyNameWithId>FamilyIdList=[];

  familydatafetchfunc()async{
    setState((){
      FamilyIdList.clear();
    });
    setState(()  {
      FamilyIdList.add(
          FamilyNameWithId(count: 0, id: "Select", name: "Select")
      );
    });
    var familydata=await cf.FirebaseFirestore.instance.collection("Families").get();
    for(int i=0;i<familydata.docs.length;i++){
      setState((){
        FamilyIdList.add(
            FamilyNameWithId(count: familydata.docs[i]['quantity'], id: familydata.docs[i]['familyId'].toString(), name: familydata.docs[i]['name'].toString()));
      });
    }
  }


  checkAvailableSlot(int count, String familyName) async {
    var committeeData =await cf.FirebaseFirestore.instance.collection("Chorus").get();
    int committeememberCount = 0;
    committeeData.docs.forEach((element) {
      if(element['family'] == familyName){
        committeememberCount++;
      }
    });
    if((count-committeememberCount) <= 0){
      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          text: "Family Count Exceeded",
          width: MediaQuery.of(context).size.width * 0.4,
          backgroundColor: Constants()
              .primaryAppColor
              .withOpacity(0.8));
      setState(() {
        familyIDController.text = "Select";
      });
    }else{

    }
  }
  @override
  void initState() {
    familydatafetchfunc();
    super.initState();
  }

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
              padding: EdgeInsets.symmetric(
                  vertical: height/81.375,
                  horizontal: width/170.75
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "CHOIR",
                    style: GoogleFonts.openSans(
                        fontSize: width/52.538,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
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
                          EdgeInsets.symmetric( horizontal:width/227.66),
                          child: Center(
                            child: KText(
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Choir Member" : "View Choir  Members",
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
              height: size.height * 1.56,
              width: width/1.241,
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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: "ADD CHOIR MEMBER",
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
                      padding: EdgeInsets.symmetric(vertical: height/32.55, horizontal: width/68.3),
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
                                       width:width/683),
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
                              Container(
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
                                decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width:width/910.66,
                                    color: Colors.grey
                                  )
                                )
                                ),
                                  width:width/4.553,
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
                                      isExpanded:true,
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
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: emailController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              Container(
                                width: size.width / 4.553,
                                decoration: BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                    )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Marital status *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: size.width / 105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      isExpanded: true,
                                      value: marriedController,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      underline: Container(),
                                      items: [
                                        "Select Status",
                                        "Married",
                                        "Single"
                                      ].map((items) {
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
                                      text: "Baptize Date",
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
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(3000));
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
                              SizedBox(width:width/68.3),
                              Visibility(
                                visible: marriedController.toUpperCase() == 'MARRIED',
                                child: SizedBox(
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
                                          await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime(3000));
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
                              ),
                            ],
                          ),
                          SizedBox(height:height/21.7),
                          Row(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      width:width/910.66,
                                      color: Colors.grey
                                    )
                                  )
                                ),
                                  width:width/4.553,
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
                                    // TextFormField(
                                    //   style: TextStyle(fontSize:width/113.83),
                                    //   controller: socialStatusController,
                                    // )
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
                                    SizedBox(height: height/65.1),
                                    DropdownButton(
                                      isExpanded: true,
                                      value: bloodGroupController.text,
                                      icon: Icon(Icons.keyboard_arrow_down),
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
                              Container(
                                  width:width/4.553,
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                        width:width/910.66,color: Colors.grey
                                    ))
                                ),
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
                                    DropdownButton(
                                      value: familyController.text,
                                      isExpanded: true,
                                      underline: Container(),
                                      icon:  Icon(Icons.keyboard_arrow_down),
                                      items: FamilyIdList.map((items) {
                                        return DropdownMenuItem(
                                          value: items.name,
                                          child: Text(items.name),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          familyController.text = newValue!;
                                          FamilyIdList.forEach((element) {
                                            if(element.name == newValue){
                                              familyIDController.text = element.id;
                                              checkAvailableSlot(element.count, element.name);
                                            }
                                          });
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              Container(
                                  width:width/4.553,
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                        width:width/910.66,color: Colors.grey
                                    ))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Family ID *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      value: familyIDController.text,
                                      isExpanded: true,
                                      underline: Container(),
                                      icon:  Icon(Icons.keyboard_arrow_down),
                                      items: FamilyIdList.map((items) {
                                        return DropdownMenuItem(
                                          value: items.id,
                                          child: Text(items.id),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          familyIDController.text = newValue!;
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
                                      text: "Department",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                      ],
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: departmentController,
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
                                      controller: dobController,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(3000));
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
                                      text: "Pin code *",
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
                                  if (profileImage != null &&
                                      baptizeDateController.text != "" &&
                                      bloodGroupController.text != "" &&
                                      departmentController.text != "" &&
                                      dobController.text != "" &&
                                      emailController.text != "" &&
                                      pincodeController.text != "" &&
                                      phoneController.text.length == 10 &&
                                      familyController.text != "" &&
                                      firstNameController.text != "" &&
                                      jobController.text != "" &&
                                      lastNameController.text != "" &&
                                      nationalityController.text != "" &&
                                      phoneController.text != "" &&
                                      positionController.text != "" &&
                                      socialStatusController.text != "") {
                                    Response response =
                                    await ChorusFireCrud.addChorus(
                                        image: profileImage!,
                                        familyId: familyIDController.text,
                                        maritalStatus: marriedController,
                                        baptizeDate: baptizeDateController.text,
                                        bloodGroup: bloodGroupController.text,
                                        department: departmentController.text,
                                        dob: dobController.text,
                                        email: emailController.text,
                                        pincode: pincodeController.text,
                                        family: familyController.text,
                                        firstName: firstNameController.text,
                                        job: jobController.text,
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
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Chorus created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        currentTab = 'View';
                                        uploadedImage = null;
                                        profileImage = null;
                                        baptizeDateController.text = "";
                                        bloodGroupController.text = 'Select Blood Group';
                                        departmentController.text = "";
                                        pincodeController.text = "";
                                        dobController.text = "";
                                        emailController.text = "";
                                        familyController.text = "Select";
                                        familyIDController.text = "Select";
                                        marriedController = "Select Status";
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
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Chorus!",
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
              stream: searchString != "" ? ChorusFireCrud.fetchChorusesWithSearch(searchString) : ChorusFireCrud.fetchChoruses(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<ChorusModel> choruses = snapshot.data!;
                  return Container(
                    width: width/1.241,
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "All Members (${choruses.length})",
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
                                        left: width/136.6,
                                        bottom: height/65.1,),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.7 > 130 + choruses.length * 60
                              ? 130 + choruses.length * 60
                              : size.height * 0.7,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.symmetric(
                            horizontal: width/68.3,
                            vertical: height/32.55
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      generateChorusPdf(PdfPageFormat.letter,choruses,false);
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
                                      copyToClipBoard(choruses);
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
                                      var data = await generateChorusPdf(PdfPageFormat.letter,choruses,true);
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
                                      convertToCsv(choruses);
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
                                    vertical: height/217,
                                    horizontal: width/455.33
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
                                        width:width/13.60,
                                        child: KText(
                                          text: "Photo",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                         width:width/ 8.035,
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
                                         width:width/ 8.035,
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
                                  itemCount: choruses.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: height/10.85,
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
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: width/273.2,
                                          vertical: height/130.2
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
                                              width: width/13.66,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                    NetworkImage(choruses[i].imgUrl!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                               width:width/ 8.035,
                                              child: KText(
                                                text:
                                                "${choruses[i].firstName!} ${choruses[i].lastName!}",
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: width/9.106,
                                              child: KText(
                                                text: choruses[i].position!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                               width:width/ 8.035,
                                              child: KText(
                                                text: choruses[i].phone!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: width/9.106,
                                              child: KText(
                                                text: choruses[i].gender!,
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
                                                        viewPopup(choruses[i]);
                                                      },
                                                      child: Container(
                                                         height:height/ 26.04,
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
                                                    SizedBox( width:width/273.2),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          baptizeDateController.text = choruses[i].baptizeDate!;
                                                          bloodGroupController.text = choruses[i].bloodGroup!;
                                                          departmentController.text = choruses[i].department!;
                                                          dobController.text = choruses[i].dob!;
                                                          emailController.text = choruses[i].email!;
                                                          familyController.text = choruses[i].family!;
                                                          familyIDController.text = choruses[i].familyId!;
                                                          marriedController = choruses[i].maritalStatus!;
                                                          firstNameController.text = choruses[i].firstName!;
                                                          jobController.text = choruses[i].job!;
                                                          lastNameController.text = choruses[i].lastName!;
                                                          marriageDateController.text = choruses[i].marriageDate!;
                                                          nationalityController.text = choruses[i].nationality!;
                                                          phoneController.text = choruses[i].phone!;
                                                          positionController.text = choruses[i].position!;
                                                          socialStatusController.text = choruses[i].socialStatus!;
                                                          countryController.text = choruses[i].country!;
                                                          genderController.text = choruses[i].gender!;
                                                          pincodeController.text = choruses[i].pincode!;
                                                          selectedImg = choruses[i].imgUrl;
                                                        });
                                                        editPopUp(choruses[i], size);
                                                      },
                                                      child: Container(
                                                         height:height/ 26.04,
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
                                                    SizedBox( width:width/273.2),
                                                    InkWell(
                                                      onTap: () {
                                                        CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType.info,
                                                            text: "${choruses[i].firstName} ${choruses[i].lastName} will be deleted",
                                                            title: "Delete this Record?",
                                                            width: size.width * 0.4,
                                                            backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            showCancelBtn: true,
                                                            cancelBtnText: 'Cancel',
                                                            cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                            onConfirmBtnTap: () async {
                                                              Response res = await ChorusFireCrud.deleteRecord(id: choruses[i].id!);
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                         height:height/ 26.04,
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
            ) : Container()
          ],
        ),
      ),
    );
  }

  viewPopup(ChorusModel chorus) {
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
          margin: EdgeInsets.symmetric(
                horizontal: width/68.3,
                vertical: height/32.55
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
                          chorus.firstName!,
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
                              EdgeInsets.symmetric( horizontal:width/227.66),
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
                                image: NetworkImage(chorus.imgUrl!),
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
                                        text: "${chorus.firstName!} ${chorus.lastName!}",
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
                                        text: chorus.phone!,
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
                                        text: chorus.email!,
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
                                        text: chorus.gender!,
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
                                        text: chorus.position!,
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
                                        text: chorus.department!,
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
                                        text: chorus.family!,
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
                                          text: "Baptize Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                               fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: chorus.baptizeDate!,
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
                                        text: chorus.socialStatus!,
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
                                        text: chorus.marriageDate!,
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
                                        text: chorus.job!,
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
                                        text: chorus.bloodGroup!,
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
                                        text: chorus.dob!,
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
                                        text: chorus.nationality!,
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

  editPopUp(ChorusModel chorus, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: size.height * 1.51,
                width:width/ 1.241,
              margin: EdgeInsets.symmetric(
                horizontal: width/68.3,
                vertical: height/32.55
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
                              text: "EDIT CHORUS MEMBER",
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
                                  bloodGroupController.text = 'Select Blood Group';
                                  departmentController.text = "";
                                  dobController.text = "";
                                  emailController.text = "";
                                  pincodeController.text = "";
                                  familyController.text = "Select";
                                  familyIDController.text = "Select";
                                  marriedController = "Select Status";
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
                        padding: EdgeInsets.symmetric(
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
                                           width:width/683),
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
                                      ? Center(
                                    child: Icon(
                                      Icons.cloud_upload,
                                      size:width/8.537,
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
                                  Container(
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
                                        bottom: BorderSide(width:width/910.66,color: Colors.grey)
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
                                          text: "Baptize Date",
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
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(3000));
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
                                        // TextFormField(
                                        //   style: TextStyle(fontSize:width/113.83),
                                        //   controller: socialStatusController,
                                        // )
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
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                    width: size.width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Blood Group *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: size.width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: size.height / 50.076),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: bloodGroupController.text,
                                          icon: Icon(Icons.keyboard_arrow_down),
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
                                  Container(
                                      width:width/4.553,
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            width:width/910.66,color: Colors.grey
                                        ))
                                    ),
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
                                        DropdownButton(
                                          value: familyController.text,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon:  Icon(Icons.keyboard_arrow_down),
                                          items: FamilyIdList.map((items) {
                                            return DropdownMenuItem(
                                              value: items.name,
                                              child: Text(items.name),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              familyController.text = newValue!;
                                              FamilyIdList.forEach((element) {
                                                if(element.name == newValue){
                                                  familyIDController.text = element.id;
                                                  checkAvailableSlot(element.count, element.name);
                                                }
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  Container(
                                      width:width/4.553,
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            width:width/910.66,color: Colors.grey
                                        ))
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family ID *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: familyIDController.text,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon:  Icon(Icons.keyboard_arrow_down),
                                          items: FamilyIdList.map((items) {
                                            return DropdownMenuItem(
                                              value: items.id,
                                              child: Text(items.id),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              familyIDController.text = newValue!;
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
                                          text: "Department *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: departmentController,
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
                                          controller: dobController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime(3000));
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
                                      if (
                                          baptizeDateController.text != "" &&
                                          bloodGroupController.text != "" &&
                                          departmentController.text != "" &&
                                          dobController.text != "" &&
                                          emailController.text != "" &&
                                              phoneController.text.length == 10 &&
                                          pincodeController.text != "" &&
                                          familyController.text != "" &&
                                          firstNameController.text != "" &&
                                          jobController.text != "" &&
                                          lastNameController.text != "" &&
                                          nationalityController.text != "" &&
                                          phoneController.text != "" &&
                                          positionController.text != "" &&
                                          socialStatusController.text != "") {
                                        Response response =
                                        await ChorusFireCrud.updateRecord(
                                            ChorusModel(
                                              timestamp: chorus.timestamp,id: chorus.id,
                                                baptizeDate: baptizeDateController.text,
                                                bloodGroup: bloodGroupController.text,
                                                department: departmentController.text,
                                                dob: dobController.text,
                                                email: emailController.text,
                                                family: familyController.text,
                                                firstName: firstNameController.text,
                                                pincode: pincodeController.text,
                                                job: jobController.text,
                                                maritalStatus: marriedController,
                                                familyId: familyIDController.text,
                                                imgUrl: chorus.imgUrl,
                                                lastName: lastNameController.text,
                                                marriageDate: marriageDateController.text,
                                                nationality: nationalityController.text,
                                                phone: phoneController.text,
                                                position: positionController.text,
                                                socialStatus: socialStatusController.text,
                                                country: countryController.text,
                                                gender : genderController.text
                                            ),
                                            profileImage,
                                            chorus.imgUrl ?? ""
                                        );
                                        if (response.code == 200) {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: "Chorus updated successfully!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          setState(() {
                                            uploadedImage = null;
                                            profileImage = null;
                                            baptizeDateController.text = "";
                                            bloodGroupController.text = 'Select Blood Group';
                                            departmentController.text = "";
                                            dobController.text = "";
                                            emailController.text = "";
                                            familyController.text = "Select";
                                            familyIDController.text = "Select";
                                            marriedController = "Select Status";
                                            firstNameController.text = "";
                                            pincodeController.text = "";
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
                                          Navigator.pop(context);
                                        } else {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: "Failed to update Chorus!",
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
                                        padding: EdgeInsets.symmetric(
                                             horizontal:width/227.66),
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

  convertToCsv(List<ChorusModel> choruses) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Name");
    row.add("Phone");
    row.add("Email");
    row.add("Position");
    row.add("Baptize Date");
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
    for (int i = 0; i < choruses.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("${choruses[i].firstName!} ${choruses[i].lastName!}");
      row.add(choruses[i].phone);
      row.add(choruses[i].email);
      row.add(choruses[i].position);
      row.add(choruses[i].baptizeDate);
      row.add(choruses[i].marriageDate);
      row.add(choruses[i].socialStatus);
      row.add(choruses[i].job);
      row.add(choruses[i].family);
      row.add(choruses[i].department);
      row.add(choruses[i].gender);
      row.add(choruses[i].bloodGroup);
      row.add(choruses[i].dob);
      row.add(choruses[i].nationality);
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
      ..setAttribute("download", "chorus.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<ChorusModel> choruses) async  {
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
    for (int i = 0; i < choruses.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add("${choruses[i].firstName} ${choruses[i].lastName}");
      row.add("       ");
      row.add(choruses[i].position);
      row.add("       ");
      row.add(choruses[i].phone);
      row.add("       ");
      row.add(choruses[i].gender);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows,fieldDelimiter: null,eol: null,textEndDelimiter: null,delimitAllFields: false,textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",","")));
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

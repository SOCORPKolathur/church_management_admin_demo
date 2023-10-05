import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:church_management_admin/services/members_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/members_model.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';
import '../prints/member_print.dart';
import 'package:excel/excel.dart' as ex;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as wb;
import 'package:intl/intl.dart';

class MembersTab extends StatefulWidget {
   MembersTab({super.key});

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController memberIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController baptizeDateController = TextEditingController();
  TextEditingController marriageDateController = TextEditingController();
  TextEditingController socialStatusController = TextEditingController(text: "Select");
  TextEditingController jobController = TextEditingController();
  TextEditingController familyController = TextEditingController(text: "Select");
  TextEditingController familyIDController = TextEditingController(text: "Select");
  TextEditingController departmentController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController(text: "Select Blood Group");
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController genderController = TextEditingController(text: 'Select Gender');
  String searchString = "";
  File? profileImage;
  File? documentForUpload;
  var uploadedImage;
  String? selectedImg;
  String docname = "";

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

  setMemberId() async {
    var document = await cf.FirebaseFirestore.instance.collection('Members').get();
    int lastId = document.docs.length + 1;
    String studentId = lastId.toString().padLeft(6,'0');
    setState((){
      memberIdController.text = studentId;
    });
  }

  downloadTemplateExcel() async {
    final wb.Workbook workbook = wb.Workbook();
    final wb.Worksheet sheet   = workbook.worksheets[0];
    sheet.getRangeByName("A1").setText("No.");
    sheet.getRangeByName("B1").setText("Member ID");
    sheet.getRangeByName("C1").setText("Firstname");
    sheet.getRangeByName("D1").setText("Lastname");
    sheet.getRangeByName("E1").setText("Phone");
    sheet.getRangeByName("F1").setText("Email");
    sheet.getRangeByName("G1").setText("Gender");
    sheet.getRangeByName("H1").setText("Position");
    sheet.getRangeByName("I1").setText("Baptize Date");
    sheet.getRangeByName("J1").setText("Marriage Date");
    sheet.getRangeByName("K1").setText("Social Status");
    sheet.getRangeByName("L1").setText("Job");
    sheet.getRangeByName("M1").setText("Family");
    sheet.getRangeByName("N1").setText("Department");
    sheet.getRangeByName("O1").setText("Blood Group");
    sheet.getRangeByName("P1").setText("Date of Birth");
    sheet.getRangeByName("Q1").setText("Nationality");
    sheet.getRangeByName("R1").setText("Address");
    sheet.getRangeByName("S1").setText("Pincode");
    sheet.getRangeByName("T1").setText("Aadhaar Number");

    final List<int>bytes = workbook.saveAsStream();
    workbook.dispose();
    AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', 'MemberTemplate.xlsx')
      ..click();

  }

  @override
  void initState() {
    familydatafetchfunc();
    setMemberId();
    super.initState();
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
    var memberData =await cf.FirebaseFirestore.instance.collection("Members").get();
    int memberCount = 0;
    memberData.docs.forEach((element) {
      if(element['family'] == familyName){
        memberCount++;
      }
    });
    if((count-memberCount) <= 0){
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
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: height/81.375,
        horizontal: width/170.75
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(
                  vertical: height/81.375,
                  horizontal: width/170.75
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "MEMBERS",
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
                        }
                      },
                      child: Container(
                        height: height/18.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow:  [
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
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Member" : "View Members",
                              style: GoogleFonts.openSans(
                                fontSize: width/105.076,
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
              height: size.height * 2.0,
              width: width/1.241,
              margin:  EdgeInsets.symmetric(
                horizontal: width/68.3,
                vertical: height/32.55
              ),
              decoration: BoxDecoration(
                color: Constants().primaryAppColor,
                boxShadow:  [
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
                      padding:  EdgeInsets.symmetric(
                          horizontal: width/68.3, vertical: height/81.375),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: "ADD MEMBER",
                            style: GoogleFonts.openSans(
                              fontSize: width/68.3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              PopupMenuButton(
                                itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                  PopupMenuItem(
                                    child:  Text('Download Template'),
                                    onTap: (){
                                      downloadTemplateExcel();
                                    },
                                  )
                                ],
                                child:  Icon(
                                  Icons.remove_red_eye,
                                  color: Colors.white,
                                ),
                              ),
                               SizedBox(width: width/136.6),
                              InkWell(
                                onTap: () async {
                                  FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['xlsx'],
                                    allowMultiple: false,
                                  );
                                  var bytes = pickedFile!.files.single.bytes;
                                  var excel = ex.Excel.decodeBytes(bytes!);
                                  Response response = await MembersFireCrud.bulkUploadMember(excel);
                                  if(response.code == 200){
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Members created successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor.withOpacity(0.8)
                                    );
                                  }
                                  else{
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to Create Members!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor.withOpacity(0.8)
                                    );
                                  }
                                },
                                child: Container(
                                  height: height/18.6,
                                  width: width/9.106,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow:  [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(1, 2),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(horizontal: width/227.666),
                                    child: Center(
                                      child: KText(
                                        text: "Bulk Upload",
                                        style: GoogleFonts.openSans(
                                          fontSize: width/105.076,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      padding:  EdgeInsets.symmetric(
                        vertical: height/32.55,
                        horizontal: width/68.3
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: height/3.829,
                              width: width/3.902,
                              decoration: BoxDecoration(
                                  border: Border.all(color: Constants().primaryAppColor, width: 2),
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
                                  ?  Center(
                                      child: Icon(
                                        Icons.cloud_upload,
                                        size: width/8.537,
                                        color: Colors.grey,
                                      ),
                                    ) : null,
                            ),
                          ),
                           SizedBox(height: height/32.55),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: selectImage,
                                child: Container(
                                  height: height/18.6,
                                  width: size.width * 0.25,
                                  color: Constants().primaryAppColor,
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          color: Colors.white),
                                      SizedBox(width: width/136.6),
                                      KText(
                                        text: 'Select Profile Photo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: height/18.6,
                                width: size.width * 0.25,
                                color: Constants().primaryAppColor,
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.crop,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: width/136.6),
                                    KText(
                                      text: 'Disable Crop',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                onTap: selectDocument,
                                child: Container(
                                  height: height/18.6,
                                  width: size.width * 0.23,
                                  color: Constants().primaryAppColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Icon(Icons.file_copy,
                                          color: Colors.white),
                                       SizedBox(width: width/136.6),
                                      KText(
                                        text: docname == "" ? 'Select Baptizem Certificate' : docname,
                                        style:  TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Member ID",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: memberIdController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Firstname *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: firstNameController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Lastname *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: lastNameController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Phone *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: phoneController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Email",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: emailController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              Container(
                                width: width/4.553,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                            color: Colors.grey,
                                            width: 1.5
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
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      underline: Container(),
                                      isExpanded: true,
                                      value: genderController.text,
                                      icon:  const Icon(Icons.keyboard_arrow_down),
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
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Position",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: positionController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Baptize Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
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
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Aadhaar Number",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: aadharNoController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Marriage Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
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
                               SizedBox(width: width/68.3),
                              Container(
                                width: width/4.553,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(width: 1.5,color: Colors.grey)
                                  )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Social Status",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),

                                    DropdownButton(
                                      isExpanded: true,
                                      value: socialStatusController.text,
                                      icon:  Icon(Icons.keyboard_arrow_down),
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
                                    //   style:  TextStyle(fontSize: width/113.83),
                                    //   controller: socialStatusController,
                                    // )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Employment/Job",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: jobController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              Container(
                                width: width/4.553,
                                decoration:const  BoxDecoration(
                                border: Border(bottom: BorderSide(
                                  width: 1.5,color: Colors.grey
                                ))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Family Name *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      value: familyController.text,
                                      isExpanded: true,
                                      underline: Container(),
                                      icon:  const Icon(Icons.keyboard_arrow_down),
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
                               SizedBox(width: width/68.3),
                              Container(
                                width: width/4.553,
                                decoration: const BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                        width: 1.5,
                                        color: Colors.grey
                                    ))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Family ID *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      value: familyIDController.text,
                                      isExpanded: true,
                                      underline: Container(),
                                      icon:  const Icon(Icons.keyboard_arrow_down),
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
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Department",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: departmentController,
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width: 300,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Blood Group *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 10),
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
                              SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Date of Birth",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
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
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Nationality *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: nationalityController,
                                    )
                                  ],
                                ),
                              ),


                            ],
                          ),
                           SizedBox(height: height/21.7),

                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Pin code *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: pincodeController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Address",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width/105.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
                                margin:  EdgeInsets.symmetric(
                                  horizontal: width/68.3,
                                  vertical: height/32.55
                                ),
                                decoration: BoxDecoration(
                                  color: Constants().primaryAppColor,
                                  boxShadow:  [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                     SizedBox(
                                      height: height/32.55,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration:  const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:  TextStyle(
                                                fontSize: width/113.83),
                                            controller: addressController,
                                            decoration:  InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: width/91.06,
                                                    top: height/162.75,bottom: height/162.75)
                                            ),
                                            maxLines: null,
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (profileImage != null &&
                                      bloodGroupController.text != "" &&
                                      familyController.text != "" &&
                                      pincodeController.text != "" &&
                                      firstNameController.text != "" &&
                                      genderController.text != "Select Gender" &&
                                      lastNameController.text != "" &&
                                      nationalityController.text != "" &&
                                      phoneController.text != "" ) {
                                    Response response = await MembersFireCrud.addMember(
                                          aadharNo: aadharNoController.text,
                                          membersId: memberIdController.text,
                                      image: profileImage!,
                                      document: documentForUpload,
                                      address: addressController.text,
                                      gender: genderController.text,
                                      baptizeDate: baptizeDateController.text,
                                      bloodGroup: bloodGroupController.text,
                                      department: departmentController.text,
                                      dob: dobController.text,
                                      email: emailController.text,
                                      family: familyController.text,
                                      familyid: familyIDController.text,
                                      firstName: firstNameController.text,
                                      job: jobController.text,
                                      lastName: lastNameController.text,
                                      marriageDate: marriageDateController.text,
                                      nationality: nationalityController.text,
                                      phone: phoneController.text,
                                      position: positionController.text,
                                      socialStatus: socialStatusController.text,
                                      country: countryController.text,
                                          pincode: pincodeController.text,
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Member created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setMemberId();
                                      setState(() {
                                        currentTab = 'View';
                                        uploadedImage = null;
                                        profileImage = null;
                                        baptizeDateController.text = "";
                                        bloodGroupController.text = "Select Blood Group";
                                        genderController.text = "Select Gender";
                                        addressController.text = "";
                                        familyController.text = "Select";
                                        familyIDController.text = "Select";
                                        departmentController.text = "";
                                        docname = "";
                                        documentForUpload = null;
                                        dobController.text = "";
                                        aadharNoController.text = "";
                                        emailController.text = "";
                                        familyController.text = "";
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
                                      });
                                    }
                                    else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Member!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                    }
                                  }

                                  else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Container(
                                  height: height/18.6,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow:  [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(1, 2),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(horizontal: width/227.66),
                                    child: Center(
                                      child: KText(
                                        text: "ADD NOW",
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: width/136.6,
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
              stream: searchString != "" ? MembersFireCrud.fetchMembersWithSearch(searchString) : MembersFireCrud.fetchMembers(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<MembersModel> members = snapshot.data!;
                  return Container(
                    width: width/1.241,
                    margin:  EdgeInsets.symmetric(
                            horizontal: width/68.3,
                        vertical: height/32.55
                    ),
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      boxShadow:  [
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
                            padding:  EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "All Members (${members.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: height/18.6,
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
                                    decoration:  InputDecoration(
                                      border: InputBorder.none,
                                      hintText: 'Search',
                                      hintStyle:  TextStyle(
                                        color: Colors.black,
                                      ),
                                      contentPadding:  EdgeInsets.symmetric(
                                          horizontal: width/136.6, vertical:height/65.1),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.75,
                          width: double.infinity,
                          decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding:  EdgeInsets.symmetric(
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
                                      generateMemberPdf(PdfPageFormat.letter,members,false);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration:  BoxDecoration(
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
                                        padding:  EdgeInsets.symmetric(horizontal: width/227.66),
                                        child: Center(
                                          child: Row(
                                            children: [
                                               Icon(Icons.print,
                                                  color: Colors.white),
                                              KText(
                                                text: "PRINT",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                   SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () {
                                      copyToClipBoard(members);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration:  BoxDecoration(
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
                                        padding:  EdgeInsets.symmetric(
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
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                   SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () async {
                                      var data = await generateMemberPdf(PdfPageFormat.letter,members,true);
                                      savePdfToFile(data);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration:  BoxDecoration(
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
                                        padding:  EdgeInsets.symmetric(
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
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                   SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () {
                                      convertToCsv(members);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration:  BoxDecoration(
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
                                        padding:  EdgeInsets.symmetric(
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
                                                  fontSize: width/105.076,
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
                               SizedBox(height: height/21.7),
                              SizedBox(
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(
                                    vertical: height/217,
                                    horizontal: width/455.33
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: 17.075,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/13.66,
                                        child: KText(
                                          text: "Member ID",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/15.177,
                                        child: KText(
                                          text: "Photo",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/8.035,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/11.38,
                                        child: KText(
                                          text: "Position",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/9.757,
                                        child: KText(
                                          text: "Phone",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/10.507,
                                        child: KText(
                                          text: "Pin Code",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/7.588,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
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
                                  itemCount: members.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: height/10.85,
                                      width: double.infinity,
                                      decoration:  BoxDecoration(
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
                                        padding:  EdgeInsets.symmetric(
                                          horizontal: width/273.2,
                                          vertical: height/130.2
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: width/17.075,
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/13.66,
                                              child: KText(
                                                text: members[i].memberId!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/15.177,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                        NetworkImage(
                                                            members[i].imgUrl!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/8.035,
                                              child: KText(
                                                text:
                                                    "${members[i].firstName!} ${members[i].lastName!}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/9.757,
                                              child: KText(
                                                text: members[i].position!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/11.38,
                                              child: KText(
                                                text: members[i].phone!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/10.507,
                                              child: KText(
                                                text: members[i].pincode!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: width/7.588,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        viewPopup(members[i]);
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
                                                                  horizontal:
                                                                      6),
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
                                                                  size: width/91.06,
                                                                ),
                                                                KText(
                                                                  text: "View",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: width/136.6,
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
                                                          addressController.text = members[i].address!;
                                                          genderController.text = members[i].gender!;
                                                          baptizeDateController.text = members[i].baptizeDate!;
                                                          bloodGroupController.text = members[i].bloodGroup!;
                                                          departmentController.text = members[i].department!;
                                                          dobController.text = members[i].dob!;
                                                          emailController.text = members[i].email!;
                                                          familyController.text = members[i].family!;
                                                          familyIDController.text = members[i].familyid!;
                                                          firstNameController.text = members[i].firstName!;
                                                          jobController.text = members[i].job!;
                                                          lastNameController.text = members[i].lastName!;
                                                          marriageDateController.text = members[i].marriageDate!;
                                                          nationalityController.text = members[i].nationality!;
                                                          phoneController.text = members[i].phone!;
                                                          positionController.text = members[i].position!;
                                                          socialStatusController.text = members[i].socialStatus!;
                                                          countryController.text = members[i].country!;
                                                          selectedImg = members[i].imgUrl;
                                                          pincodeController.text = members[i].pincode!;
                                                          memberIdController.text = members[i].memberId!;
                                                          aadharNoController.text = members[i].aadharNo!;
                                                        });
                                                        editPopUp(members[i], size);
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
                                                                  horizontal:
                                                                      width/227.66),
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
                                                                  size: width/91.06,
                                                                ),
                                                                KText(
                                                                  text: "Edit",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        width/136.6,
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
                                                            text: "${members[i].firstName} ${members[i].lastName} will be deleted",
                                                            title: "Delete this Record?",
                                                            width: size.width * 0.4,
                                                            backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            showCancelBtn: true,
                                                            cancelBtnText: 'Cancel',
                                                            cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                            onConfirmBtnTap: () async {
                                                              Response res = await MembersFireCrud.deleteRecord(id: members[i].id!);
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
                                                                  horizontal:
                                                                      width/227.66),
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
                                                                  size: width/91.06,
                                                                ),
                                                                KText(
                                                                  text:
                                                                      "Delete",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        width/136.6,
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

  viewPopup(MembersModel member) {
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
            margin:  EdgeInsets.symmetric(
                horizontal: width/68.3,
                vertical: height/32.55
            ),
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow:  [
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
                          member.firstName!,
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
                              boxShadow:  [
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
                                  text: "CLOSE",
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
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration:  BoxDecoration(
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
                                image: NetworkImage(member.imgUrl!),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: width/136.6, vertical: height/43.4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                   SizedBox(height: height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Member ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.memberId!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Baptizem Certificate",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      InkWell(
                                        onTap: () async {
                                          final Uri toLaunch =
                                          Uri.parse(member.baptizemCertificate!);
                                          if (!await launchUrl(toLaunch,
                                            mode: LaunchMode.externalApplication,
                                          )) {
                                            throw Exception('Could not launch $toLaunch');
                                          }
                                        },
                                        child: Container(
                                          height: height/18.6,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow:  [
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
                                                text: "Download Document",
                                                style: GoogleFonts.openSans(
                                                  fontSize: width/91.066,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: "${member.firstName!} ${member.lastName!}",
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Phone",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.phone!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Email",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.email!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Gender",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.gender!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Position",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.position!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Department",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.department!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Family Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.family!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Family ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.familyid!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Baptize Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.baptizeDate!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Social Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.socialStatus!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Marriage Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.marriageDate!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Aadhaar Number",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: mask(member.aadharNo!),
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Employment/Job",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.job!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Blood Group",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.bloodGroup!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Date of Birth",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.dob!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Nationality",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.nationality!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.address!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Pin Code",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.pincode!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
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

  editPopUp(MembersModel member, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: size.height * 1.8,
            width: width/1.241,
            margin:  EdgeInsets.symmetric(
                horizontal: width/68.3,
                vertical: height/32.55
            ),
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow:  [
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
                    padding:  EdgeInsets.symmetric(
                        horizontal: width/68.3, vertical: height/217),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "EDIT MEMBER",
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
                              aadharNoController.text = "";
                              departmentController.text = "";
                              dobController.text = "";
                              addressController.text = "";
                              genderController.text = "Select Gender";
                              emailController.text = "";
                              familyController.text = "";
                              firstNameController.text = "";
                              memberIdController.text = "";
                              pincodeController.text = "";
                              jobController.text = "";
                              lastNameController.text = "";
                              marriageDateController.text = "";
                              nationalityController.text = "";
                              phoneController.text = "";
                              positionController.text = "";
                              socialStatusController.text = "";
                              countryController.text = "";
                            });
                            Navigator.pop(context);
                          },
                          child:  Icon(
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
                    decoration:  BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    padding:  EdgeInsets.symmetric(
                      horizontal: width/68.3,
                      vertical: height/32.55
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: height/3.8258,
                              width: width/3.902,
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
                                  ?  Center(
                                child: Icon(
                                  Icons.cloud_upload,
                                  size: width/8.537,
                                  color: Colors.grey,
                                ),
                              )
                                  : null,
                            ),
                          ),
                           SizedBox(height: height/32.55),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: selectImage,
                                child: Container(
                                  height: height/18.6,
                                  width: size.width * 0.25,
                                  color: Constants().primaryAppColor,
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          color: Colors.white),
                                      SizedBox(width: width/136.6),
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
                                height: height/18.6,
                                width: size.width * 0.25,
                                color: Constants().primaryAppColor,
                                child:  Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.crop,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: width/136.6),
                                    KText(
                                      text: 'Disable Crop',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Member ID",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: memberIdController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Firstname",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: firstNameController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Lastname",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: lastNameController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Phone",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: phoneController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Email",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: emailController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              Container(
                                width: width/4.553,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Colors.grey,
                                      width: 1.5
                                    )
                                  )
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Gender",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      value: genderController.text,
                                      isExpanded: true,
                                      underline: Container(),
                                      icon:  Icon(Icons.keyboard_arrow_down),
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
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Position",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: positionController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Baptize Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
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
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Aadhaar Number",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: aadharNoController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Marriage Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
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
                               SizedBox(width: width/68.3),
                              Container(
                                width: width/4.553,
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                       color: Colors.grey,
                                      width: 1.5
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
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      isExpanded: true,
                                      value: socialStatusController.text,
                                      icon:  Icon(Icons.keyboard_arrow_down),
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
                                    //   style:  TextStyle(fontSize: width/113.83),
                                    //   controller: socialStatusController,
                                    // )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Employment/Job",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: jobController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              Container(
                                width: width/4.553,
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                        width: 1.5,color: Colors.grey
                                    ))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Family Name *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
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
                                        });
                                      },
                                    ),
                                    // TextFormField(
                                    //   style:  TextStyle(fontSize: width/113.83),
                                    //   controller: familyController,
                                    // )

                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              Container(
                                width: width/4.553,
                                decoration: BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                        width: 1.5,color: Colors.grey
                                    ))
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Family ID *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
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
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Department",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: departmentController,
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [

                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Blood Group",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: bloodGroupController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Date of Birth",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize: width/113.83),
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
                               SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Nationality",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: nationalityController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Pin code",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      style:  TextStyle(fontSize: width/113.83),
                                      controller: pincodeController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Address",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width/105.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
                                margin:  EdgeInsets.symmetric(
                                    horizontal: width/68.3,
                                    vertical: height/32.55
                                ),
                                decoration: BoxDecoration(
                                  color: Constants().primaryAppColor,
                                  boxShadow:  [
                                    BoxShadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 2),
                                      blurRadius: 3,
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceEvenly,
                                  children: [
                                     SizedBox(
                                      height: height/32.55,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration:  BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:  TextStyle(
                                                fontSize: width/113.83),
                                            controller: addressController,
                                            decoration:  InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: width/91.06,top: height/162.75,
                                                    bottom: height/162.75)
                                            ),
                                            maxLines: null,
                                          )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: height/21.7),
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
                                      familyController.text != "" &&
                                      memberIdController.text != "" &&
                                      pincodeController.text != "" &&
                                      addressController.text != "" &&
                                      genderController.text != "Select Gender" &&
                                      firstNameController.text != "" &&
                                      jobController.text != "" &&
                                      lastNameController.text != "" &&
                                      nationalityController.text != "" &&
                                      phoneController.text != "" &&
                                      positionController.text != "" &&
                                      socialStatusController.text != "") {
                                    Response response =
                                    await MembersFireCrud.updateRecord(
                                      MembersModel(
                                        imgUrl: member.imgUrl,
                                        baptizemCertificate: member.baptizemCertificate,
                                        address: addressController.text,
                                        gender: genderController.text,
                                        id: member.id,
                                        timestamp: member.timestamp,
                                        baptizeDate: baptizeDateController.text,
                                        bloodGroup: bloodGroupController.text,
                                        department: departmentController.text,
                                        dob: dobController.text,
                                        aadharNo: aadharNoController.text,
                                        familyid: member.familyid,
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
                                        memberId: memberIdController.text,
                                      ),
                                        profileImage,
                                        member.imgUrl ?? ""
                                    );
                                    if (response.code == 200) {
                                      await CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Member updated successfully!",
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
                                        memberIdController.text = "";
                                        aadharNoController.text = "";
                                        dobController.text = "";
                                        familyController.text = "Select";
                                        familyIDController.text = "Select";
                                        socialStatusController.text = "Select";
                                        genderController.text = "Select Gender";
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
                                      });
                                      Navigator.pop(context);
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to update Member!",
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
                                  height: height/18.6,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
                                    borderRadius: BorderRadius.circular(8),
                                    boxShadow:  [
                                      BoxShadow(
                                        color: Colors.black26,
                                        offset: Offset(1, 2),
                                        blurRadius: 3,
                                      ),
                                    ],
                                  ),
                                  child: Padding(
                                    padding:  EdgeInsets.symmetric(
                                        horizontal: width/227.66),
                                    child: Center(
                                      child: KText(
                                        text: "Update",
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
                                          fontSize: width/136.6,
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
      },
    );
  }

  convertToCsv(List<MembersModel> members) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Member ID");
    row.add("Name");
    row.add("Phone");
    row.add("Email");
    row.add("Gender");
    row.add("Position");
    row.add("Baptize Date");
    row.add("Marriage Date");
    row.add("Social Status");
    row.add("Job");
    row.add("Family");
    row.add("Department");
    row.add("Blood Group");
    row.add("Date of Birth");
    row.add("Nationality");
    row.add("Address");
    row.add("Pin Code");
    rows.add(row);
    for (int i = 0; i < members.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(members[i].memberId);
      row.add("${members[i].firstName!} ${members[i].lastName!}");
      row.add(members[i].phone);
      row.add(members[i].email);
      row.add(members[i].gender);
      row.add(members[i].position);
      row.add(members[i].baptizeDate);
      row.add(members[i].marriageDate);
      row.add(members[i].socialStatus);
      row.add(members[i].job);
      row.add(members[i].family);
      row.add(members[i].department);
      row.add(members[i].bloodGroup);
      row.add(members[i].dob);
      row.add(members[i].nationality);
      row.add(members[i].address);
      row.add(members[i].pincode);
      rows.add(row);
    }
    String csv =  ListToCsvConverter().convert(rows);
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
      ..setAttribute("download", "members.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<MembersModel> members) async  {
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
    row.add("Country");
    rows.add(row);
    for (int i = 0; i < members.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add("${members[i].firstName} ${members[i].lastName}");
      row.add("       ");
      row.add(members[i].position);
      row.add("       ");
      row.add(members[i].phone);
      row.add("       ");
      row.add(members[i].country);
      rows.add(row);
    }
    String csv =  ListToCsvConverter().convert(rows,fieldDelimiter: null,eol: null,textEndDelimiter: null,delimitAllFields: false,textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",","")));
  }

  String mask(String input) {
    String result = '';
    int maskLen = input.length  - 4;
    for(int i = 0; i < input.length; i++){
      if(i < maskLen){
        result += 'x';
      }else{
        result += input[i].toString();
      }
    }
    return result;
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding:  EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow:  [
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
                onPressed: () => debugPrint("Undid"), child:  Text("Undo"))
          ],
        )),
  );
}


class FamilyNameWithId{
  FamilyNameWithId({ required this.count,required this.id,required this.name});
  String name;
  String id;
  int count;
}
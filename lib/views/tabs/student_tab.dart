import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:age_calculator/age_calculator.dart';
import 'package:church_management_admin/models/student_model.dart';
import 'package:church_management_admin/services/student_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';
import '../prints/student_print.dart';
import 'package:excel/excel.dart' as ex;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as wb;
import 'package:intl/intl.dart';

import 'members_tab.dart';

class StudentTab extends StatefulWidget {
  StudentTab({super.key});

  @override
  State<StudentTab> createState() => _StudentTabState();
}

class _StudentTabState extends State<StudentTab> {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController studentIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController guardianController = TextEditingController();
  TextEditingController guardianPhoneController = TextEditingController();
  TextEditingController baptizeDateController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController classController = TextEditingController(text: "Select Class");
  //TextEditingController marriageDateController = TextEditingController();
  //TextEditingController socialStatusController = TextEditingController();
  TextEditingController genderController = TextEditingController(text: 'Select Gender');
  TextEditingController filterClassController = TextEditingController(text: 'Select Class');
  //TextEditingController jobController = TextEditingController();
  TextEditingController familyController = TextEditingController(text: "Select");
  TextEditingController familyIDController = TextEditingController(text: "Select");
  //TextEditingController departmentController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController(text: 'Select Blood Group');
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController();
  TextEditingController countryController = TextEditingController();

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

  bool isCropped = false;

  setStudentId() async {
    var document = await cf.FirebaseFirestore.instance.collection('Students').get();
    int lastId = document.docs.length + 1;
    String studentId = lastId.toString().padLeft(6,'0');
    setState((){
      studentIdController.text = studentId;
    });
  }

  checkAvailableSlot(int count, String familyName) async {
    var studentData =await cf.FirebaseFirestore.instance.collection("Students").get();
    int studentCount = 0;
    studentData.docs.forEach((element) {
      if(element['family'] == familyName){
        studentCount++;
      }
    });
    if((count-studentCount) <= 0){
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

  downloadTemplateExcel() async {
    final wb.Workbook workbook = wb.Workbook();
    final wb.Worksheet sheet   = workbook.worksheets[0];
    sheet.getRangeByName("A1").setText("No.");
    sheet.getRangeByName("B1").setText("Student ID");
    sheet.getRangeByName("C1").setText("Firstname");
    sheet.getRangeByName("D1").setText("Lastname");
    sheet.getRangeByName("E1").setText("Gender");
    sheet.getRangeByName("F1").setText("Parent/Guardian");
    sheet.getRangeByName("G1").setText("Parent/Guardian Phone");
    sheet.getRangeByName("H1").setText("Baptize Date");
    sheet.getRangeByName("I1").setText("Age");
    sheet.getRangeByName("J1").setText("Class");
    sheet.getRangeByName("K1").setText("Family ID");
    sheet.getRangeByName("L1").setText("Family");
    sheet.getRangeByName("M1").setText("Blood Group");
    sheet.getRangeByName("N1").setText("Date of Birth");
    sheet.getRangeByName("O1").setText("Nationality");
    sheet.getRangeByName("P1").setText("Aadhaar Number");
    sheet.getRangeByName("Q1").setText("Position");

    final List<int>bytes = workbook.saveAsStream();
    workbook.dispose();
    AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', 'StudentTemplate.xlsx')
      ..click();

  }

  String currentTab = 'View';

  @override
  void initState() {
    familydatafetchfunc();
    setStudentId();
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

  clearTextEditingControllers(){
    setState(() {
      currentTab = 'View';
      uploadedImage = null;
      profileImage = null;
      ageController.text = "";
      classController.text = "Select Class";
      guardianController.text = "";
      guardianPhoneController.text = "";
      baptizeDateController.text = "";
      bloodGroupController.text = 'Select Blood Group';
      aadharNoController.text = "";
      //departmentController.text = "";
      dobController.text = "";
      familyController.text = "";
      firstNameController.text = "";
      //jobController.text = "";
      lastNameController.text = "";
      //marriageDateController.text = "";
      nationalityController.text = "";
      //socialStatusController.text = "";
      countryController.text = "";
      genderController.text = 'Select Gender';
    });
  }

  final _keyParentname = GlobalKey<FormFieldState>();
  final _keyFirstname = GlobalKey<FormFieldState>();
  final _keyLastname = GlobalKey<FormFieldState>();
  final _keyPhone = GlobalKey<FormFieldState>();
  final _keyDob = GlobalKey<FormFieldState>();
  final _keyAadhar = GlobalKey<FormFieldState>();
  bool profileImageValidator = false;

  bool isLoading = false;

  setAge(DateTime dob){
    DateDuration duration;
    duration = AgeCalculator.age(dob);
    ageController.text = duration.years.toString();
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
                    text: "STUDENT",
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
                           EdgeInsets.symmetric(horizontal:width/227.66),
                          child: Center(
                            child: KText(
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Student" : "View Students",
                              style: GoogleFonts.openSans(
                                fontSize:width/91.066,
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
                ? Stack(
              alignment: Alignment.center,
                  children: [
                    Container(
              height: size.height * 1.61,
              width: size.width/1.241818182,
              margin:  EdgeInsets.symmetric(horizontal: width/68.3,vertical: height/32.55),
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
                          padding:  EdgeInsets.symmetric(horizontal:width/68.3, vertical:height/81.375),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: "ADD STUDENT",
                                style: GoogleFonts.openSans(
                                  fontSize:width/68.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  PopupMenuButton(
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                      PopupMenuItem(
                                        child: Text('Download Template'),
                                        onTap: (){
                                          downloadTemplateExcel();
                                        },
                                      )
                                    ],
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                    ),
                                  ),
                                   SizedBox(width:width/136.6),
                                  InkWell(
                                    onTap: () async {
                                      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['xlsx'],
                                        allowMultiple: false,
                                      );
                                      var bytes = pickedFile!.files.single.bytes;
                                      var excel = ex.Excel.decodeBytes(bytes!);
                                      Response response = await StudentFireCrud.bulkUploadStudent(excel);
                                      if(response.code == 200){
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: "Students created successfully!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor.withOpacity(0.8)
                                        );
                                      }else{
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: "Failed to Create Students!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor.withOpacity(0.8)
                                        );
                                      }
                                    },
                                    child: Container(
                                      height:height/18.6,
                                      width:width/9.106,
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
                                            text: "Bulk Upload",
                                            style: GoogleFonts.openSans(
                                              fontSize:width/91.066,
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
                          decoration: BoxDecoration(
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
                                                  base64Decode(uploadedImage!
                                                      .split(',')
                                                      .last),
                                                ),
                                              ),
                                            )
                                          : null),
                                  child: uploadedImage == null
                                      ?  Center(
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
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo,
                                              color: Colors.white),
                                          SizedBox(width:width/136.6),
                                          KText(
                                            text: 'Select Profile Photo *',
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
                                      child:  Row(
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
                                          text: "Student ID *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: studentIdController,
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
                                          text: "Firstname *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
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
                                            fontSize:width/91.066,
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
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: lastNameController,
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
                                        bottom: BorderSide(width: 1.5,color: Colors.grey)
                                      )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Gender *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: genderController.text,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon:
                                          Icon(Icons.keyboard_arrow_down),
                                          items: ["Select Gender", "Male", "Female","Transgender"]
                                              .map((items) {
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
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: 'Parent / Guardian *',
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          key: _keyParentname,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return '';
                                            }
                                          },
                                          onChanged: (val){
                                            _keyParentname.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: guardianController,
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
                                          text: "Parent / Guardian Phone *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
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
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: guardianPhoneController,
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
                                            fontSize:width/91.066,
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
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: dobController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now());
                                            if (pickedDate != null) {
                                              setState(() {
                                                dobController.text = formatter.format(pickedDate);
                                                setAge(pickedDate);
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
                                          text: "Age",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly:true,
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 3,
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: ageController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  Container(
                                    width:width/4.553,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 1.5,color: Colors.grey)
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Class *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: classController.text,
                                          underline: Container(),
                                           isExpanded: true,
                                          icon:
                                          Icon(Icons.keyboard_arrow_down),
                                          items:  ["Select Class","LKG","UKG","I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","UG","PG"]
                                              .map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              classController.text = newValue!;
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
                                  Container(
                                    width:width/4.553,
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
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: familyController.text,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon: Icon(Icons.keyboard_arrow_down),
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


                                        // TextFormField(
                                        //   style: TextStyle(fontSize:width/113.83),
                                        //   controller: familyController,
                                        // )

                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  Container(
                                    width:width/4.553,
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
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: familyIDController.text,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          items: FamilyIdList.map((items) {
                                            return DropdownMenuItem(
                                              value: items.id,
                                              child: Text(items.id),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              familyIDController.text = newValue!;
                                              FamilyIdList.forEach((element) {
                                                if(element.id == newValue){
                                                  familyController.text = element.name;
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
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Aadhaar Number",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          key: _keyAadhar,
                                          validator: (val){
                                            if(val!.length != 12){
                                              return 'Must be 12 digits';
                                            }else{
                                              return '';
                                            }
                                          },
                                          onChanged: (val){
                                            _keyAadhar.currentState!.validate();
                                          },
                                          decoration: const InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 12,
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: aadharNoController,
                                        )
                                      ],
                                    ),
                                  ),
                                  // SizedBox(width:width/68.3),
                                  // SizedBox(
                                  //   width:width/4.553,
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       KText(
                                  //         text: "Department",
                                  //         style: GoogleFonts.openSans(
                                  //           color: Colors.black,
                                  //           fontSize:width/91.066,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       TextFormField(
                                  //         style: TextStyle(fontSize:width/113.83),
                                  //         controller: departmentController,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
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
                                          text: "Blood Group *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                         SizedBox(height:height/65.1),
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
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: baptizeDateController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now());
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
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Nationality",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
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
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: nationalityController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/21.7),
                              Visibility(
                                visible: profileImageValidator,
                                child: const Text(
                                  "Please Select Image *",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              SizedBox(height: height/21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if(!isLoading){
                                        setState((){
                                          isLoading = true;
                                        });
                                        _keyFirstname.currentState!.validate();
                                        _keyLastname.currentState!.validate();
                                        _keyParentname.currentState!.validate();
                                        _keyDob.currentState!.validate();
                                        _keyPhone.currentState!.validate();
                                        // if(profileImage == null){
                                        //   setState(() {
                                        //     profileImageValidator = true;
                                        //   });
                                        // }
                                        if (
                                        //profileImage != null &&
                                            classController.text != "Select Class" &&
                                            genderController.text != "" &&
                                            guardianPhoneController.text != "" &&
                                            bloodGroupController.text != "Select Blood Group" &&
                                            dobController.text != "" &&
                                            familyController.text != "" &&
                                            firstNameController.text != "" &&
                                            lastNameController.text != ""
                                        ) {
                                          Response response =
                                          await StudentFireCrud.addStudent(
                                            aadharNo: aadharNoController.text,
                                            studentId: studentIdController.text,
                                            image: profileImage,
                                            baptizeDate: baptizeDateController.text,
                                            bloodGroup: bloodGroupController.text,
                                            clasS: classController.text,
                                            age: ageController.text,
                                            guardian: guardianController.text,
                                            guardianPhone:
                                            guardianPhoneController.text,
                                            dob: dobController.text,

                                            family: familyController.text,
                                            familyid: familyIDController.text,
                                            firstName: firstNameController.text,
                                            //job: jobController.text,
                                            lastName: lastNameController.text,
                                            //marriageDate: marriageDateController.text,
                                            nationality: nationalityController.text,
                                            //socialStatus: socialStatusController.text,
                                            country: countryController.text,
                                            gender: genderController.text,
                                            position: "",
                                            phone: "",
                                            email: "",
                                          );
                                          if (response.code == 200) {
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.success,
                                                text: "Student created successfully!",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants()
                                                    .primaryAppColor
                                                    .withOpacity(0.8));
                                            setStudentId();
                                            clearTextEditingControllers();
                                          } else {
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: "Failed to Create Student!",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants()
                                                    .primaryAppColor
                                                    .withOpacity(0.8));
                                            setState((){
                                              isLoading = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height:height/18.6,
                                      width:width*0.1,
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
                )
                : currentTab.toUpperCase() == "VIEW" ? StreamBuilder(
              stream: filterClassController.text != "Select Class" ? StudentFireCrud.fetchStudentswithFilter(filterClassController.text) : StudentFireCrud.fetchStudents(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<StudentModel> students = snapshot.data!;
                  return Container(
                    width: 1100,
                    margin:  EdgeInsets.symmetric(horizontal: width/68.3,vertical: height/32.55),
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
                            padding:  EdgeInsets.symmetric(
                                horizontal: width/68.3, vertical: height/81.375),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "All Students (${students.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                filterClassController.text != "Select Class"
                                    ? InkWell(
                                  onTap: (){
                                   setState(() {
                                     filterClassController.text = "Select Class";
                                   });
                                  },
                                      child: Container(
                                        height:height/18.6,
                                        width:width/17.075,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(horizontal: width/136.6),
                                            child: Text(
                                              "Cancel",
                                              style: TextStyle(
                                                color: Constants().primaryAppColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )
                                    : Container(
                                  height:height/18.6,
                                  width:width/9.106,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: DropdownButton(
                                      value: filterClassController.text,
                                      underline: Container(),
                                      icon:
                                      Icon(Icons.keyboard_arrow_down),
                                      items:  ["Select Class","LKG","UKG","I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","UG","PG"]
                                          .map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (newValue) {
                                        setState(() {
                                          filterClassController.text = newValue!;
                                        });
                                      },
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.7 > 130 + students.length * 60
                              ? 130 + students.length * 60
                              : size.height * 0.7,
                          width: double.infinity,
                          decoration: BoxDecoration(
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
                                      generateStudentPdf(PdfPageFormat.letter,students,false);
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
                                        padding:  EdgeInsets.symmetric(
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
                                                  fontSize:width/91.066,
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
                                      copyToClipBoard(students);
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
                                        padding:  EdgeInsets.symmetric(
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
                                                  fontSize:width/91.066,
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
                                      var data = await generateStudentPdf(PdfPageFormat.letter,students,true);
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
                                        padding:  EdgeInsets.symmetric(
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
                                                  fontSize:width/91.066,
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
                                      convertToCsv(students);
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
                                        padding:  EdgeInsets.symmetric(
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
                                                  fontSize:width/91.066,
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
                                  padding:  EdgeInsets.symmetric(

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
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/13.66,
                                        child: KText(
                                          text: "Photo",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/8.0352,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/9.106,
                                        child: KText(
                                          text: "Class",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/8.0352,
                                        child: KText(
                                          text: "Parent/Guardian",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/9.106,
                                        child: KText(
                                          text: "Country",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/7.588,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/91.066,
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
                                  itemCount: students.length,
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
                                        padding:  EdgeInsets.symmetric(
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
                                                  fontSize:width/91.066,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/13.66,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                    NetworkImage(students[i].imgUrl!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/8.0352,
                                              child: KText(
                                                text:
                                                "${students[i].firstName!} ${students[i].lastName!}",
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/91.066,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/9.106,
                                              child: KText(
                                                text: students[i].clasS!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/91.066,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/8.0352,
                                              child: KText(
                                                text: students[i].guardian!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/91.066,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/9.106,
                                              child: KText(
                                                text: students[i].nationality!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/91.066,
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
                                                        viewPopup(students[i]);
                                                      },
                                                      child: Container(
                                                        height:height/26.04,
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
                                                          ageController.text = students[i].age!;
                                                          classController.text = students[i].clasS!;
                                                          guardianController.text = students[i].guardian!;
                                                          guardianPhoneController.text = students[i].guardianPhone!;
                                                          baptizeDateController.text = students[i].baptizeDate!;
                                                          bloodGroupController.text = students[i].bloodGroup!;
                                                          //departmentController.text = students[i].department!;
                                                          dobController.text = students[i].dob!;
                                                          familyController.text = students[i].family!;
                                                          familyIDController.text = students[i].familyid!;
                                                          firstNameController.text = students[i].firstName!;
                                                          //jobController.text = students[i].job!;
                                                          lastNameController.text = students[i].lastName!;
                                                          //marriageDateController.text = students[i].marriageDate!;
                                                          nationalityController.text = students[i].nationality!;
                                                          //socialStatusController.text = students[i].socialStatus!;
                                                          countryController.text = students[i].country!;
                                                          genderController.text = students[i].gender!;
                                                          studentIdController.text = students[i].studentId!;
                                                          selectedImg = students[i].imgUrl;
                                                        });
                                                         editPopUp(students[i], size);
                                                      },
                                                      child: Container(
                                                        height:height/26.04,
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
                                                            text: "${students[i].firstName} ${students[i].lastName} will be deleted",
                                                            title: "Delete this Record?",
                                                            width: size.width * 0.4,
                                                            backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            showCancelBtn: true,
                                                            cancelBtnText: 'Cancel',
                                                            cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                            onConfirmBtnTap: () async {
                                                              Response res = await StudentFireCrud.deleteRecord(id: students[i].id!);
                                                              setStudentId();
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height:height/26.04,
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

  viewPopup(StudentModel student) {
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
            margin:  EdgeInsets.symmetric(horizontal: width/68.3,vertical: height/32.55),
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
                     EdgeInsets.symmetric(horizontal:width/68.3, vertical:height/81.375),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          student.firstName!,
                          style: GoogleFonts.openSans(
                            fontSize:width/68.3,
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
                                image: NetworkImage(student.imgUrl!),
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
                                   SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Student ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: student.studentId!,
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
                                        child:  KText(
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
                                        text: "${student.firstName!} ${student.lastName!}",
                                        style:  TextStyle(
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
                                        child:  KText(
                                          text: "Class",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: student.clasS!,
                                        style:  TextStyle(
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
                                        child:  KText(
                                          text: "Age",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: student.age!,
                                        style:  TextStyle(
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
                                        child:  KText(
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
                                        text: student.gender!,
                                        style:  TextStyle(
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
                                          text: "Family Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: student.family!,
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
                                          text: "Family ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: student.familyid!,
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
                                          text: "Aadhaar Number",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: mask(student.aadharNo!),
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
                                        text: student.baptizeDate!,
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
                                        text: student.bloodGroup!,
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
                                        text: student.dob!,
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
                                        text: student.nationality!,
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
                                          text: "Parent/Guardian",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: student.guardian!,
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
                                          text: "Parent/Guardian Contact",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: student.guardianPhone!,
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

  editPopUp(StudentModel student, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context,setStat) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: size.height * 1.51,
                width: width/1.241,
                margin:  EdgeInsets.symmetric(horizontal: width/68.3,vertical: height/32.55),
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
                            horizontal:width/68.3, vertical:height/81.375),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            KText(
                              text: "EDIT STUDENT",
                              style: GoogleFonts.openSans(
                                fontSize:width/68.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  uploadedImage = null;
                                  profileImage = null;
                                  ageController.text = "";
                                  classController.text = "Select Class";
                                  guardianController.text = "";
                                  guardianPhoneController.text = "";
                                  baptizeDateController.text = "";
                                  bloodGroupController.text = 'Select Blood Group';
                                  aadharNoController.text = "";
                                  //departmentController.text = "";
                                  dobController.text = "";
                                  familyController.text = "";
                                  firstNameController.text = "";
                                  //jobController.text = "";
                                  lastNameController.text = "";
                                  //marriageDateController.text = "";
                                  nationalityController.text = "";
                                  //socialStatusController.text = "";
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
                        padding: EdgeInsets.all(20),
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
                                  child: (selectedImg == null && uploadedImage == null)
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
                                          text: "Student ID",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: studentIdController,
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
                                          text: "Firstname ",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
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
                                          text: "Lastname ",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
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
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  Container(
                                    width:width/4.553,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 1.5,color: Colors.grey)
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Gender ",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: genderController.text,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon:
                                          Icon(Icons.keyboard_arrow_down),
                                          items: ["Select Gender", "Male", "Female","Transgender"]
                                              .map((items) {
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
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: 'Parent / Guardian ',
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
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
                                          controller: guardianController,
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
                                          text: "Parent / Guardian Phone ",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
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
                                          controller: guardianPhoneController,
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
                                          text: "Date of Birth",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
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
                                                lastDate: DateTime.now());
                                            if (pickedDate != null) {
                                              setState(() {
                                                dobController.text = formatter.format(pickedDate);
                                                setAge(pickedDate);
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
                                          text: "Age",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly:true,
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 3,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: ageController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  Container(
                                    width:width/4.553,
                                    decoration: BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width: 1.5,color: Colors.grey)
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Class *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: classController.text,
                                          underline: Container(),
                                          isExpanded: true,
                                          icon:
                                          Icon(Icons.keyboard_arrow_down),
                                          items:  ["Select Class","LKG","UKG","I","II","III","IV","V","VI","VII","VIII","IX","X","XI","XII","UG","PG"]
                                              .map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              classController.text = newValue!;
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
                                  Container(
                                    width:width/4.553,
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            width: 1.5,color: Colors.grey
                                        ))
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family Name ",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: familyController.text,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon: Icon(Icons.keyboard_arrow_down),
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


                                        // TextFormField(
                                        //   style: TextStyle(fontSize:width/113.83),
                                        //   controller: familyController,
                                        // )

                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  Container(
                                    width:width/4.553,
                                    decoration: BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            width: 1.5,color: Colors.grey
                                        ))
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family ID ",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: familyIDController.text,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          items: FamilyIdList.map((items) {
                                            return DropdownMenuItem(
                                              value: items.id,
                                              child: Text(items.id),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              familyIDController.text = newValue!;
                                              FamilyIdList.forEach((element) {
                                                if(element.id == newValue){
                                                  familyController.text = element.name;
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
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Aadhaar Number",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
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
                                          maxLength: 12,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: aadharNoController,
                                        )
                                      ],
                                    ),
                                  ),
                                  // SizedBox(width:width/68.3),
                                  // SizedBox(
                                  //   width:width/4.553,
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       KText(
                                  //         text: "Department",
                                  //         style: GoogleFonts.openSans(
                                  //           color: Colors.black,
                                  //           fontSize:width/91.066,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       TextFormField(
                                  //         style: TextStyle(fontSize:width/113.83),
                                  //         controller: departmentController,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
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
                                          text: "Blood Group ",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height:height/65.1),
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
                                            fontSize:width/91.066,
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
                                                lastDate: DateTime.now());
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
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Nationality",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/91.066,
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
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (
                                          classController.text != "Select Class"
                                        ) {
                                        Response response =
                                        await StudentFireCrud.updateRecord(
                                          StudentModel(
                                            id: student.id,
                                            studentId: studentIdController.text,
                                            baptizeDate: baptizeDateController.text,
                                            bloodGroup: bloodGroupController.text,
                                            //department: departmentController.text,
                                            clasS: classController.text,
                                            age: ageController.text,
                                            imgUrl: student.imgUrl,
                                            familyid: familyIDController.text,
                                            timestamp: student.timestamp,
                                            guardian: guardianController.text,
                                            guardianPhone:
                                            guardianPhoneController.text,
                                            aadharNo: aadharNoController.text,
                                            dob: dobController.text,
                                            family: familyController.text,
                                            firstName: firstNameController.text,
                                            //job: jobController.text,
                                            lastName: lastNameController.text,
                                            //marriageDate: marriageDateController.text,
                                            nationality: nationalityController.text,
                                            //socialStatus: socialStatusController.text,
                                            country: countryController.text,
                                            gender: genderController.text,
                                            position: "",
                                            phone: "",
                                            email: "",
                                          ),
                                            profileImage,
                                            student.imgUrl ?? ""
                                        );
                                        if (response.code == 200) {
                                          await CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: "Student updated successfully!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          setState(() {
                                            uploadedImage = null;
                                            profileImage = null;
                                            ageController.text = "";
                                            classController.text = "Select Class";
                                            guardianController.text = "";
                                            guardianPhoneController.text = "";
                                            baptizeDateController.text = "";
                                            aadharNoController.text = "";
                                            bloodGroupController.text = 'Select Blood Group';
                                            //departmentController.text = "";
                                            dobController.text = "";
                                            familyController.text = "";
                                            firstNameController.text = "";
                                            //jobController.text = "";
                                            lastNameController.text = "";
                                            //marriageDateController.text = "";
                                            nationalityController.text = "";
                                            //socialStatusController.text = "";
                                            countryController.text = "";
                                            genderController.text = 'Select Gender';
                                          });
                                          setStudentId();
                                          Navigator.pop(context);
                                        } else {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: "Failed to update Student!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.warning,
                                            text: "Please fill the required fields",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
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

  convertToCsv(List<StudentModel> students) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Student ID");
    row.add("Name");
    row.add("Gender");
    row.add("Guardian");
    row.add("Phone");
    row.add("Baptize Date");
    row.add("Age");
    row.add("Class");
    row.add("Family");
    row.add("Blood Group");
    row.add("Date of Birth");
    row.add("Nationality");
    rows.add(row);
    for (int i = 0; i < students.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(students[i].studentId);
      row.add("${students[i].firstName!} ${students[i].lastName!}");
      row.add(students[i].gender);
      row.add(students[i].guardian);
      row.add(students[i].guardianPhone);
      row.add(students[i].baptizeDate);
      row.add(students[i].age);
      row.add(students[i].clasS);
      row.add(students[i].family);
      row.add(students[i].bloodGroup);
      row.add(students[i].dob);
      row.add(students[i].nationality);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows);
    saveCsvToFile(csv);
  }

  void saveCsvToFile(csvString) async {
    final blob = Blob([Uint8List.fromList(csvString.codeUnits)]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "Students.csv")
      ..click();
    Url.revokeObjectUrl(url);
  }

  void savePdfToFile(data) async {
    final blob = Blob([data],'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "Students.pdf")
      ..click();
    Url.revokeObjectUrl(url);
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

  copyToClipBoard(List<StudentModel> students) async  {
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
    row.add("Nationality");
    rows.add(row);
    for (int i = 0; i < students.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add("${students[i].firstName} ${students[i].lastName}");
      row.add("       ");
      row.add(students[i].position);
      row.add("       ");
      row.add(students[i].phone);
      row.add("       ");
      row.add(students[i].nationality);
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

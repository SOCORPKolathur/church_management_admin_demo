import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:church_management_admin/services/members_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
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
  TextEditingController serviceLanguageController = TextEditingController(text: "Select");
  TextEditingController departmentController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController(text: "Select Blood Group");
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController(text: 'Indian');
  TextEditingController countryController = TextEditingController();
  TextEditingController residentialAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController houseTypeCon = TextEditingController(text: 'Select Type');
  TextEditingController pincodeController = TextEditingController();
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController genderController = TextEditingController(text: 'Select Gender');
  TextEditingController landMarkController = TextEditingController();
  TextEditingController previousChurchController = TextEditingController();
  TextEditingController attendingTimeController = TextEditingController(text: 'Select Time');
  TextEditingController qualificationController = TextEditingController();
  TextEditingController relationToFamilyController = TextEditingController(text: "Select Relation");
  TextEditingController marriedController = TextEditingController(text: 'Select Status');
  String searchString = "";
  File? profileImage;
  File? documentForUpload;
  var uploadedImage;
  String? selectedImg;
  String docname = "";

  String currentTab = 'View';

  bool isCropped = false;

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
    var churchDetails = await cf.FirebaseFirestore.instance.collection('ChurchDetails').get();
    String memberIdPrefix = churchDetails.docs.first.get("memberIdPrefix");
    int lastId = document.docs.length + 1;
    String studentId = lastId.toString().padLeft(6,'0');
    setState((){
      memberIdController.text = memberIdPrefix+studentId;
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
    sheet.getRangeByName("H1").setText("Profession");
    sheet.getRangeByName("I1").setText("Baptism Date");
    sheet.getRangeByName("J1").setText("Marriage Date");
    sheet.getRangeByName("K1").setText("Social Status");
    sheet.getRangeByName("L1").setText("Job");
    sheet.getRangeByName("M1").setText("Family ID");
    sheet.getRangeByName("N1").setText("Family");
    sheet.getRangeByName("O1").setText("Department");
    sheet.getRangeByName("P1").setText("Blood Group");
    sheet.getRangeByName("Q1").setText("Date of Birth");
    sheet.getRangeByName("R1").setText("Nationality");
    sheet.getRangeByName("S1").setText("Address");
    sheet.getRangeByName("T1").setText("Pincode");
    sheet.getRangeByName("U1").setText("Aadhaar Number");
    sheet.getRangeByName("V1").setText("Marital Status");
    sheet.getRangeByName("W1").setText("Attending Time");
    sheet.getRangeByName("X1").setText("Qualification");
    sheet.getRangeByName("Y1").setText("Relationship to Family");
    sheet.getRangeByName("Z1").setText("Previous Church");
    sheet.getRangeByName("AA1").setText("Landmark");

    final List<int>bytes = workbook.saveAsStream();
    workbook.dispose();
    AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', 'MemberTemplate.xlsx')
      ..click();

  }

  clearTextEditingControllers(){
    setState(() {
      currentTab = 'View';
      uploadedImage = null;
      profileImage = null;
      baptizeDateController.text = "";
      bloodGroupController.text = "Select Blood Group";
      genderController.text = "Select Gender";
      permanentAddressController.text = "";
      residentialAddressController.text = "";
      houseTypeCon.text = "Select Type";
      familyController.text = "Select";
      familyIDController.text = "Select";
      departmentController.text = "";
      landMarkController.text = "";
      previousChurchController.text = "";
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
      nationalityController.text = 'Indian';
      phoneController.text = "";
      positionController.text = "";
      serviceLanguageController.text = "Select";
      socialStatusController.text = "";
      countryController.text = "";
      attendingTimeController.text = 'Select Time';
      qualificationController.text = "";
      relationToFamilyController.text = "";
      marriedController.text = 'Select Status';
      isLoading = false;
    });
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

  bool isEmail(String input) => EmailValidator.validate(input);

  final _key = GlobalKey<FormFieldState>();
  final _keyNationality = GlobalKey<FormFieldState>();
  final _keyFirstname = GlobalKey<FormFieldState>();
  final _keyLastname = GlobalKey<FormFieldState>();
  final _keyPhone = GlobalKey<FormFieldState>();
  final _keyPincode= GlobalKey<FormFieldState>();
  final _keyAadhar= GlobalKey<FormFieldState>();
  bool profileImageValidator = false;

  bool isLoading = false;

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final emailNameFocusNode = FocusNode();
  final positionFocusNode = FocusNode();
  final aadhaarFocusNode = FocusNode();
  final jobFocusNode = FocusNode();
  final departmentFocusNode = FocusNode();
  final qualificationFocusNode = FocusNode();
  final prevChurchFocusNode = FocusNode();
  final landmarkFocusNode = FocusNode();
  final nationalityFocusNode = FocusNode();
  final pincodeFocusNode = FocusNode();
  final addressFocusNode = FocusNode();


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
                ? Stack(
              alignment: Alignment.center,
                  children: [
                    Container(
              height: profileImageValidator ? size.height * 2.7 : size.height * 2.7,
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
                                      Response response = await MembersFireCrud.bulkUploadMemberss(excel);
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
                                      border: Border.all(color: Constants().primaryAppColor, width:width/683),
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
                                            text: 'Select Profile Photo *',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
                                            text: docname == "" ? 'Select Baptism Certificate' : docname,
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
                                          text: "Member ID *",
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
                                          key: _keyFirstname,
                                          focusNode: firstNameFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(lastNameFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(lastNameFocusNode);
                                          },
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
                                          key: _keyLastname,
                                          focusNode: lastNameFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(phoneFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(phoneFocusNode);
                                          },
                                          onChanged: (val){
                                            _keyLastname.currentState!.validate();
                                          },
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return '';
                                            }
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
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
                                          key: _keyPhone,
                                          focusNode: phoneFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(emailNameFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(emailNameFocusNode);
                                          },
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
                                          decoration: const InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 10,
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
                                          key: _key,
                                          focusNode: emailNameFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            _key.currentState!.validate();
                                            FocusScope.of(context).requestFocus(positionFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(positionFocusNode);
                                          },
                                          validator: (value) {
                                            if (!isEmail(value!)) {
                                              return 'Please enter a valid email.';
                                            }
                                            return null;
                                          },
                                          onChanged: (val){
                                            _key.currentState!.validate();
                                          },
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: emailController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width: width/68.3),
                                  Container(
                                    width: width/4.553,
                                    decoration:  BoxDecoration(
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
                                          text: "Profession",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: positionFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(aadhaarFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(aadhaarFocusNode);
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
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
                                          text: "Baptism Date",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: baptizeDateController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await DatePicker.showSimpleDatePicker(
                                              context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                              dateFormat: "dd-MM-yyyy",
                                              locale: DateTimePickerLocale.en_us,
                                              looping: true,
                                            );
                                            // await showDatePicker(
                                            //     context: context,
                                            //     initialDate: DateTime.now(),
                                            //     firstDate: DateTime(1900),
                                            //     lastDate: DateTime.now());
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
                                          key: _keyAadhar,
                                          focusNode: aadhaarFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(jobFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(jobFocusNode);
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
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
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 12,
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
                                  Container(
                                    width: width / 4.553,
                                    decoration:  BoxDecoration(
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
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: marriedController.text,
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          underline: Container(),
                                          items: [
                                            "Select Status",
                                            "Single",
                                            "Engaged",
                                            "Married",
                                            "Seperated",
                                            "Divorced",
                                            "Widow"
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              marriedController.text = newValue.toString();
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
                                          text: "Anniversary Date",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: marriageDateController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await DatePicker.showSimpleDatePicker(
                                              context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                              dateFormat: "dd-MM-yyyy",
                                              locale: DateTimePickerLocale.en_us,
                                              looping: true,
                                            );
                                            // await showDatePicker(
                                            //     context: context,
                                            //     initialDate: DateTime.now(),
                                            //     firstDate: DateTime(1900),
                                            //     lastDate: DateTime.now());
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
                                          focusNode: jobFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(departmentFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(departmentFocusNode);
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
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
                                    decoration:  BoxDecoration(
                                    border: Border(bottom: BorderSide(
                                      width:width/910.66,color: Colors.grey
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
                                    decoration:  BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            width:width/910.66,
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
                                  SizedBox(width: width/68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Relationship to Family",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: relationToFamilyController.text,
                                          icon:  const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Relation",
                                            "Father",
                                            "Mother",
                                            "Son",
                                            "Daughter",
                                            "Husband",
                                            "Wife",
                                            "Brother",
                                            "Sister",
                                            "Grand Father",
                                            "Grand Mother",
                                            "Grand Son",
                                            "Grand Daughter",
                                            "Uncle",
                                            "Aunt",
                                            "Nephew",
                                            "Niece",
                                            "Cousins",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              relationToFamilyController.text = newValue!;
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
                                           text: "Department",
                                           style: GoogleFonts.openSans(
                                             color: Colors.black,
                                             fontSize: width/105.076,
                                             fontWeight: FontWeight.bold,
                                           ),
                                         ),
                                         TextFormField(
                                           focusNode: departmentFocusNode,
                                           autofocus: true,
                                           onEditingComplete: (){
                                             FocusScope.of(context).requestFocus(qualificationFocusNode);
                                           },
                                           onFieldSubmitted: (val){
                                             FocusScope.of(context).requestFocus(qualificationFocusNode);
                                           },
                                           decoration: InputDecoration(
                                             counterText: "",
                                           ),
                                           maxLength: 100,
                                           style:  TextStyle(fontSize: width/113.83),
                                           controller: departmentController,
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
                                           text: "Qualification",
                                           style: GoogleFonts.openSans(
                                             color: Colors.black,
                                             fontSize: width/105.076,
                                             fontWeight: FontWeight.bold,
                                           ),
                                         ),
                                         TextFormField(
                                           focusNode: qualificationFocusNode,
                                           autofocus: true,
                                           onEditingComplete: (){
                                             FocusScope.of(context).requestFocus(prevChurchFocusNode);
                                           },
                                           onFieldSubmitted: (val){
                                             FocusScope.of(context).requestFocus(prevChurchFocusNode);
                                           },
                                           decoration: InputDecoration(
                                             counterText: "",
                                           ),
                                           maxLength: 100,
                                           style:  TextStyle(fontSize: width/113.83),
                                           controller: qualificationController,
                                         )
                                       ],
                                     ),
                                   ),
                                   SizedBox(width: width/68.3),
                                   Column(
                                     crossAxisAlignment: CrossAxisAlignment.start,
                                     children: [
                                       KText(
                                         text: "Attending Time",
                                         style: GoogleFonts.openSans(
                                           fontSize: width/97.571,
                                           fontWeight: FontWeight.bold,
                                         ),
                                       ),
                                       SizedBox(height: height/43.4),
                                       SizedBox(
                                         height: height/16.275,
                                         width: width/9.106,
                                         child: DropdownButton(
                                           //underline: Container(),
                                           isExpanded: true,
                                           value: attendingTimeController.text,
                                           icon:  const Icon(Icons.keyboard_arrow_down),
                                           items: [
                                             "Select Time",
                                             "6:00 AM",
                                             "8:00 AM",
                                             "10:30 AM",
                                             "7:00 PM",
                                           ].map((items) {
                                             return DropdownMenuItem(
                                               value: items,
                                               child: Text(items),
                                             );
                                           }).toList(),
                                           onChanged: (newValue) {
                                             setState(() {
                                               attendingTimeController.text = newValue!;
                                             });
                                           },
                                         ),
                                       ),

                                       // SizedBox(
                                       //   height: height/16.275,
                                       //   width: width/9.106,
                                       //   child: Padding(
                                       //     padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                       //     child: TextFormField(
                                       //       readOnly: true,
                                       //       onTap: (){
                                       //         _selectTime(context);
                                       //       },
                                       //       controller: attendingTimeController,
                                       //       decoration: InputDecoration(
                                       //         hintStyle: GoogleFonts.openSans(
                                       //           fontSize: width/97.571,
                                       //         ),
                                       //       ),
                                       //     ),
                                       //   ),
                                       // )
                                     ],
                                   ),
                                 ],
                               ),
                              SizedBox(height: height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "House Type",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height / 50.076),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: houseTypeCon.text,
                                          icon: const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Type",
                                            "Own House",
                                            "Rented House",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            if (newValue != "Select Type") {
                                              setState(() {
                                                houseTypeCon.text = newValue!;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Previous Church",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: prevChurchFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(landmarkFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(landmarkFocusNode);
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: previousChurchController,
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
                                          text: "Landmark",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: landmarkFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(nationalityFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(nationalityFocusNode);
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: landMarkController,
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
                                          text: "Blood Group *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                         SizedBox(height: height/65.1),
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
                                          readOnly: true,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: dobController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await DatePicker.showSimpleDatePicker(
                                              context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                              dateFormat: "dd-MM-yyyy",
                                              locale: DateTimePickerLocale.en_us,
                                              looping: true,
                                            );
                                            // await showDatePicker(
                                            //     context: context,
                                            //     initialDate: DateTime.now(),
                                            //     firstDate: DateTime(1900),
                                            //     lastDate: DateTime.now());
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
                                          key: _keyNationality,
                                          focusNode: nationalityFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(pincodeFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(pincodeFocusNode);
                                          },
                                          onChanged: (val){
                                            _keyNationality.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return '';
                                            }
                                          },
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
                                  Container(
                                    width: width/4.553,
                                    decoration:  BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Service Language",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        DropdownButton(
                                          isExpanded: true,
                                          value: serviceLanguageController.text,
                                          icon:  Icon(Icons.keyboard_arrow_down),
                                          underline: Container(),
                                          items: [
                                            "Select",
                                            "Tamil",
                                            "English",
                                            "Hindi",
                                            "Telugu",
                                            "Malayalam",
                                            "Kannada",
                                            "Marathi",
                                            "Gujarathi",
                                            "Odia",
                                            "Bengali",
                                            "Spanish",
                                            "Portuguese",
                                            "French",
                                            "Dutch",
                                            "German",
                                            "Italian",
                                            "Swedish",
                                            "Luxembourish",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              serviceLanguageController.text = newValue!;
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
                                  Container(
                                    width: width/4.553,
                                    decoration:  BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width:width/910.66,color: Colors.grey)
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
                                          text: "Pin code *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                            key:_keyPincode,
                                          focusNode: pincodeFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(addressFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(addressFocusNode);
                                          },
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
                                    text: "Residential Address",
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
                                                focusNode: addressFocusNode,
                                                autofocus: true,
                                                maxLength: 255,
                                                style:  TextStyle(
                                                    fontSize: width/113.83),
                                                controller: residentialAddressController,
                                                decoration:  InputDecoration(
                                                    counterText: '',
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Permanent Address",
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
                                                maxLength: 255,
                                                style:  TextStyle(
                                                    fontSize: width/113.83),
                                                controller: permanentAddressController,
                                                decoration:  InputDecoration(
                                                    counterText: '',
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
                                        _keyNationality.currentState!.validate();
                                        _keyPincode.currentState!.validate();
                                        _keyPhone.currentState!.validate();
                                        if (bloodGroupController.text != "Select Blood Group" &&
                                            familyController.text != "" &&
                                            familyIDController.text != "" &&
                                            pincodeController.text != "" &&
                                            firstNameController.text != "" &&
                                            genderController.text != "Select Gender" &&
                                            lastNameController.text != "" &&
                                            nationalityController.text != "" &&
                                            phoneController.text != "")
                                        {
                                          Response response = await MembersFireCrud.addMember(
                                            aadharNo: aadharNoController.text,
                                            membersId: memberIdController.text,
                                            serviceLanguage: serviceLanguageController.text,
                                            image: profileImage,
                                            document: documentForUpload,
                                            residentialAddress: residentialAddressController.text,
                                            permanentAddress: permanentAddressController.text,
                                            houseType: houseTypeCon.text,
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
                                            relationToFamily: relationToFamilyController.text,
                                            qualification: qualificationController.text,
                                            maritalStatus: marriedController.text,
                                            attendingTime: attendingTimeController.text,
                                            previousChurch: previousChurchController.text,
                                            landMark: landMarkController.text,
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
                                            clearTextEditingControllers();
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
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        }
                                        else {
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      width: width*0.1,
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
                : currentTab.toUpperCase() == "VIEW" ?
            StreamBuilder(
              stream: MembersFireCrud.fetchMembers(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<MembersModel> members1 = snapshot.data!;
                  List<MembersModel> members = [];
                  members1.forEach((element) {
                    if(searchString != ""){
                      if(element.position!.toLowerCase().startsWith(searchString.toLowerCase())||
                          element.firstName!.toLowerCase().startsWith(searchString.toLowerCase())||
                          element.pincode!.toLowerCase().startsWith(searchString.toLowerCase())||
                          (element.firstName!+element.lastName!).toString().trim().toLowerCase().startsWith(searchString.toLowerCase()) ||
                          element.lastName!.toLowerCase().startsWith(searchString.toLowerCase())||
                          element.phone!.toLowerCase().startsWith(searchString.toLowerCase())){
                        members.add(element);
                      }
                    }else{
                      members.add(element);
                    }
                  });
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
                                Material(
                                  borderRadius:
                                  BorderRadius.circular(5),
                                  color: Colors.white,
                                  elevation: 10,
                                  child: SizedBox(
                                    height: height / 18.6,
                                    width: width / 4.106,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 81.375,
                                          horizontal: width / 170.75),
                                      child: TextField(
                                        onChanged: (val) {
                                          setState(() {
                                            searchString = val;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                          "Search by Name,Profession,Phone,Pincode",
                                          hintStyle:
                                          GoogleFonts.openSans(
                                            fontSize: width/97.571,
                                          ),
                                        ),
                                      ),
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
                                    children: [
                                      SizedBox(
                                        width: width/20.66,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/11.66,
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
                                        width: width/9.6,
                                        child: KText(
                                          text: "Profession",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/11.5,
                                        child: Row(
                                          children: [
                                            KText(
                                              text: "Phone",
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
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
                                        width: width/8.588,
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
                                            Container(
                                              width: width/30.075,
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width/9.66,
                                              child: Center(
                                                child: KText(
                                                  text: members[i].memberId!,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/105.076,
                                                    fontWeight: FontWeight.w600,
                                                  ),
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
                                                    backgroundImage: NetworkImage(members[i].imgUrl!),
                                                    child: Visibility(
                                                      visible: members[i].imgUrl == "",
                                                      // child: Image.asset(
                                                      //   members[i].gender!.toLowerCase() == "male" ? "assets/mavatar.png" : "assets/favatar.png",
                                                      //   height: 40,
                                                      //   width: 40,
                                                      // )
                                                      child: Icon(
                                                          Icons.person
                                                      ),
                                                    ),
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
                                                          residentialAddressController.text = members[i].resistentialAddress!;
                                                          permanentAddressController.text = members[i].permanentAddress!;
                                                          houseTypeCon.text = members[i].houseType!;
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
                                                          marriedController.text = members[i].maritalStatus!;
                                                          attendingTimeController.text = members[i].attendingTime!;
                                                          qualificationController.text = members[i].qualification!;
                                                          relationToFamilyController.text = members[i].relationToFamily!;
                                                          landMarkController.text = members[i].landMark!;
                                                          previousChurchController.text = members[i].previousChurch!;
                                                          serviceLanguageController.text = members[i].serviceLanguage!;
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
                                                              setMemberId();
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
            ) : Container(),
            SizedBox(height: size.height * 0.04),
            InkWell(
              onTap: () async {
                final Uri toLaunch =
                Uri.parse("http://ardigitalsolutions.co/");
                if (!await launchUrl(toLaunch,
                  mode: LaunchMode.externalApplication,
                )) {
                  throw Exception('Could not launch $toLaunch');
                }
              },
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border:Border.all(color: Constants().primaryAppColor,)
                  ),
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          child: Center(
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.network(
                                Constants.churchLogo,
                                height: 40,
                                width: 40,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        Text(
                          "Version 1.0.0.1 @ 2023 by AR Digital Solutions. All Rights Reserved",
                          style: GoogleFonts.poppins(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: size.height * 0.01),
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
                                          text: "Baptism Certificate",
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
                                          text: "Profession",
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
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Service Language",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      KText(
                                        text: member.serviceLanguage!,
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
                                          text: "Landmark",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      KText(
                                        text: member.landMark!,
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
                                          text: "Previuos Church",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      KText(
                                        text: member.previousChurch!,
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
                                          text: "Relationship to Family",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      KText(
                                        text: member.relationToFamily!,
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
                                          text: "Qualification",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      KText(
                                        text: member.qualification!,
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
                                          text: "Attending Time",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      KText(
                                        text: member.attendingTime!,
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
                                          text: "Baptism Date",
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
                                          text: "Marital Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      KText(
                                        text: member.maritalStatus!,
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
                                          text: "Anniversary Date",
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
                                          text: "House Type",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      SizedBox(
                                        width: size.width * 0.3,
                                        child: KText(
                                          text: member.houseType!,
                                          style:  TextStyle(
                                              fontSize: width/97.57
                                          ),
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
                                          text: "Residential Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      SizedBox(
                                        width: size.width * 0.3,
                                        child: KText(
                                          text: member.resistentialAddress!,
                                          style:  TextStyle(
                                              fontSize: width/97.57
                                          ),
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
                                          text: "Permanent Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width/68.3),
                                      SizedBox(
                                        width: size.width * 0.3,
                                        child: KText(
                                          text: member.permanentAddress!,
                                          style:  TextStyle(
                                              fontSize: width/97.57
                                          ),
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
        return StatefulBuilder(
          builder: (context, setStat) {
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
                                clearTextEditingControllers();
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
                                          width:width/683),
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
                                      ): selectedImg != null ? DecorationImage(
                                          fit: isCropped ? BoxFit.contain : BoxFit.cover,
                                          image: NetworkImage(selectedImg!))
                                          : null),
                                  child: (uploadedImage == null && selectedImg == null)
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
                                          text: "Member ID *",
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
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
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
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
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
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 10,
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
                                          text: "Email ",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
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
                               SizedBox(height: height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Profession",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
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
                                          text: "Baptism Date",
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
                                            await DatePicker.showSimpleDatePicker(
                                              context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                              dateFormat: "dd-MM-yyyy",
                                              locale: DateTimePickerLocale.en_us,
                                              looping: true,
                                            );
                                            // await showDatePicker(
                                            //     context: context,
                                            //     initialDate: DateTime.now(),
                                            //     firstDate: DateTime(1900),
                                            //     lastDate: DateTime.now());
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
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 12,
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
                                  Container(
                                    width: width / 4.553,
                                    decoration:  BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Marital status",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: marriedController.text,
                                          icon: Icon(Icons.keyboard_arrow_down),
                                          underline: Container(),
                                          items: [
                                            "Select Status",
                                            "Single",
                                            "Engaged",
                                            "Married",
                                            "Seperated",
                                            "Divorced",
                                            "Widow"
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setStat(() {
                                              marriedController.text = newValue.toString();
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
                                          text: "Anniversary Date",
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
                                            await DatePicker.showSimpleDatePicker(
                                              context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                              dateFormat: "dd-MM-yyyy",
                                              locale: DateTimePickerLocale.en_us,
                                              looping: true,
                                            );
                                            // await showDatePicker(
                                            //     context: context,
                                            //     initialDate: DateTime.now(),
                                            //     firstDate: DateTime(1900),
                                            //     lastDate: DateTime.now());
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
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
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
                                            width:width/910.66,color: Colors.grey
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
                                            setStat(() {
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
                                            setStat(() {
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
                                   SizedBox(width: width/68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Relationship to Family",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: relationToFamilyController.text,
                                          icon:  const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Relation",
                                            "Father",
                                            "Mother",
                                            "Son",
                                            "Daughter",
                                            "Husband",
                                            "Wife",
                                            "Brother",
                                            "Sister",
                                            "Grand Father",
                                            "Grand Mother",
                                            "Grand Son",
                                            "Grand Daughter",
                                            "Uncle",
                                            "Aunt",
                                            "Nephew",
                                            "Niece",
                                            "Cousins",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setStat(() {
                                              relationToFamilyController.text = newValue!;
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
                                          text: "Department",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: departmentController,
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
                                          text: "Qualification",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: qualificationController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Attending Time",
                                        style: GoogleFonts.openSans(
                                          fontSize: width/97.571,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: height/43.4),
                                      SizedBox(
                                        height: height/16.275,
                                        width: width/9.106,
                                        child: DropdownButton(
                                          //underline: Container(),
                                          isExpanded: true,
                                          value: attendingTimeController.text,
                                          icon:  const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Time",
                                            "6:00 AM",
                                            "8:00 AM",
                                            "10:30 AM",
                                            "7:00 PM",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              attendingTimeController.text = newValue!;
                                            });
                                          },
                                        ),
                                      ),

                                      // SizedBox(
                                      //   height: height/16.275,
                                      //   width: width/9.106,
                                      //   child: Padding(
                                      //     padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                      //     child: TextFormField(
                                      //       readOnly: true,
                                      //       onTap: (){
                                      //         _selectTime(context);
                                      //       },
                                      //       controller: attendingTimeController,
                                      //       decoration: InputDecoration(
                                      //         hintStyle: GoogleFonts.openSans(
                                      //           fontSize: width/97.571,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                  // Column(
                                  //   crossAxisAlignment: CrossAxisAlignment.start,
                                  //   children: [
                                  //     KText(
                                  //       text: "Attending Time",
                                  //       style: GoogleFonts.openSans(
                                  //         fontSize: width/97.571,
                                  //         fontWeight: FontWeight.bold,
                                  //       ),
                                  //     ),
                                  //     SizedBox(height: height/43.4),
                                  //     SizedBox(
                                  //       height: height/16.275,
                                  //       width: width/9.106,
                                  //       child: Padding(
                                  //         padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                  //         child: TextFormField(
                                  //           readOnly: true,
                                  //           onTap: (){
                                  //             _selectTime(context);
                                  //           },
                                  //           controller: attendingTimeController,
                                  //           decoration: InputDecoration(
                                  //             hintStyle: GoogleFonts.openSans(
                                  //               fontSize: width/97.571,
                                  //             ),
                                  //           ),
                                  //         ),
                                  //       ),
                                  //     )
                                  //   ],
                                  // ),
                                ],
                              ),
                               SizedBox(height: height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "House Type",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height / 50.076),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: houseTypeCon.text,
                                          icon: const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Type",
                                            "Own House",
                                            "Rented House",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            if (newValue != "Select Type") {
                                              setStat(() {
                                                houseTypeCon.text = newValue!;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Previous Church",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: previousChurchController,
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
                                          text: "Landmark",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: landMarkController,
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
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Blood Group",
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
                                            await DatePicker.showSimpleDatePicker(
                                              context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                              dateFormat: "dd-MM-yyyy",
                                              locale: DateTimePickerLocale.en_us,
                                              looping: true,
                                            );
                                            // await showDatePicker(
                                            //     context: context,
                                            //     initialDate: DateTime.now(),
                                            //     firstDate: DateTime(1900),
                                            //     lastDate: DateTime.now());
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
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
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
                                  Container(
                                    width: width/4.553,
                                    decoration:  BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Service Language",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        DropdownButton(
                                          isExpanded: true,
                                          value: serviceLanguageController.text,
                                          icon:  Icon(Icons.keyboard_arrow_down),
                                          underline: Container(),
                                          items: [
                                            "Select",
                                            "Tamil",
                                            "English",
                                            "Hindi",
                                            "Telugu",
                                            "Malayalam",
                                            "Kannada",
                                            "Marathi",
                                            "Gujarathi",
                                            "Odia",
                                            "Bengali",
                                            "Spanish",
                                            "Portuguese",
                                            "French",
                                            "Dutch",
                                            "German",
                                            "Italian",
                                            "Swedish",
                                            "Luxembourish",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              serviceLanguageController.text = newValue!;
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
                                  Container(
                                    width: width/4.553,
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
                                            setStat(() {
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
                                          text: "Pin code",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
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
                                    text: "Residential Address",
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
                                                maxLength: 255,
                                                style:  TextStyle(
                                                    fontSize: width/113.83),
                                                controller: residentialAddressController,
                                                decoration:  InputDecoration(
                                                  counterText: '',
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Permanent Address",
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
                                                maxLength: 255,
                                                style:  TextStyle(
                                                    fontSize: width/113.83),
                                                controller: permanentAddressController,
                                                decoration:  InputDecoration(
                                                    counterText: '',
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
                                      if (firstNameController.text != "" &&
                                          lastNameController.text != "" &&
                                          memberIdController.text != "" &&
                                          phoneController.text != "" &&
                                          genderController.text != "Select Gender" &&
                                          familyController.text != "") {
                                        Response response =
                                        await MembersFireCrud.updateRecord(
                                          MembersModel(
                                            imgUrl: member.imgUrl,
                                            baptizemCertificate: member.baptizemCertificate,
                                            resistentialAddress: residentialAddressController.text,
                                            permanentAddress: permanentAddressController.text,
                                            houseType: houseTypeCon.text,
                                            gender: genderController.text,
                                            id: member.id,
                                            serviceLanguage: serviceLanguageController.text,
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
                                            attendingTime: attendingTimeController.text,
                                            maritalStatus: marriedController.text,
                                            qualification: qualificationController.text,
                                            relationToFamily: relationToFamilyController.text,
                                            landMark: landMarkController.text,
                                            previousChurch: previousChurchController.text,
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
                                            serviceLanguageController.text = "Select";
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
                                            residentialAddressController.text = "";
                                            permanentAddressController.text = "";
                                            houseTypeCon.text = "Select Type";
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
          }
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
    row.add("Profession");
    row.add("Baptism Date");
    row.add("Marital Status");
    row.add("Marriage Date");
    row.add("Social Status");
    row.add("Job");
    row.add("Family");
    row.add("Relationship to Family");
    row.add("Qualification");
    row.add("Attending Time");
    row.add("Department");
    row.add("Blood Group");
    row.add("Date of Birth");
    row.add("Nationality");
    row.add("Residential Address");
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
      row.add(members[i].maritalStatus);
      row.add(members[i].marriageDate);
      row.add(members[i].socialStatus);
      row.add(members[i].job);
      row.add(members[i].family);
      row.add(members[i].relationToFamily);
      row.add(members[i].qualification);
      row.add(members[i].attendingTime);
      row.add(members[i].department);
      row.add(members[i].bloodGroup);
      row.add(members[i].dob);
      row.add(members[i].nationality);
      row.add(members[i].resistentialAddress);
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
    row.add("Profession");
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

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
        attendingTimeController.text = picked.toString();
      });
    _formatTime(picked!);
  }


  String _formatTime(TimeOfDay time) {
    int hour = time.hourOfPeriod;
    int minute = time.minute;
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    setState(() {
      attendingTimeController.text ='${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    });

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}


class FamilyNameWithId{
  FamilyNameWithId({ required this.count,required this.id,required this.name});
  String name;
  String id;
  int count;
}
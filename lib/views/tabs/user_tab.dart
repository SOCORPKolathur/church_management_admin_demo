import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:card_swiper/card_swiper.dart';
import 'package:church_management_admin/models/user_model.dart';
import 'package:church_management_admin/services/user_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as wb;
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';
import '../prints/user_print.dart';
import 'package:excel/excel.dart' as ex;
import 'package:intl/intl.dart';

class UserTab extends StatefulWidget {
  UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController baptizeDateController = TextEditingController();
  TextEditingController anniversaryDateController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController(text: 'Select Blood Group');
  TextEditingController dobController = TextEditingController();
  TextEditingController localityController = TextEditingController();
  TextEditingController aadharController = TextEditingController();
  TextEditingController nationalityCon = TextEditingController(text: 'Indian');
  TextEditingController houseTypeCon = TextEditingController(text: 'Select Type');
  TextEditingController filterTextController = TextEditingController();
  String filterText = "";
  String marriedController = "Select Status";
  String GenderController = "Select Gender";
  File? profileImage;
  var uploadedImage;
  String? selectedImg;
  String currentTab = 'View';
  final Formkey=GlobalKey<FormState>();
  bool isCropped = false;
  bool isLoading = false;

  selectImage() async {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) async {
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

  downloadTemplateExcel() async {
    final wb.Workbook workbook = wb.Workbook();
    final wb.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName("A1").setText("No.");
    sheet.getRangeByName("B1").setText("Firstname");
    sheet.getRangeByName("C1").setText("Lastname");
    sheet.getRangeByName("D1").setText("Phone");
    sheet.getRangeByName("E1").setText("Email");
    sheet.getRangeByName("F1").setText("Profession");
    sheet.getRangeByName("G1").setText("Baptism Date");
    sheet.getRangeByName("H1").setText("Marital Status");
    sheet.getRangeByName("I1").setText("Gender");
    sheet.getRangeByName("J1").setText("Blood Group");
    sheet.getRangeByName("K1").setText("Date of birth");
    sheet.getRangeByName("L1").setText("Pin code");
    sheet.getRangeByName("M1").setText("Address");
    sheet.getRangeByName("N1").setText("About");
    sheet.getRangeByName("O1").setText("Annivarsary Date");
    sheet.getRangeByName("P1").setText("Aadhaar Number");

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', 'UserTemplate.xlsx')
      ..click();
  }

  clearTextControllers(){
    setState(() {
      firstNameController.clear();
      lastNameController.clear();
      phoneController.clear();
      emailController.clear();
      professionController.clear();
      baptizeDateController.clear();
      anniversaryDateController.clear();
      aboutController.clear();
      addressController.clear();
      pincodeController.clear();
      bloodGroupController.text = 'Select Blood Group';
      dobController.clear();
      localityController.clear();
      aadharController.clear();
      filterTextController.clear();
      filterText = "";
      marriedController = "Select Status";
      GenderController = "Select Gender";
      houseTypeCon.text = "Select Type";
      nationalityCon.text = "Indian";
      profileImage = null;
      uploadedImage = null;
      selectedImg = null;
      currentTab = 'View';
      isLoading = false;
    });
  }

  bool isEmail(String input) => EmailValidator.validate(input);
  final _key = GlobalKey<FormFieldState>();
  final _keyLocality = GlobalKey<FormFieldState>();
  final _keyFirstname = GlobalKey<FormFieldState>();
  final _keyLastname = GlobalKey<FormFieldState>();
  final _keyPhone = GlobalKey<FormFieldState>();
  final _keyDob = GlobalKey<FormFieldState>();
  final _keyAadhar = GlobalKey<FormFieldState>();
  final _keyPincode = GlobalKey<FormFieldState>();
  //bool profileImageValidator = false;

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final professionFocusNode = FocusNode();
  final aadhaarFocusNode = FocusNode();
  final pincodeFocusNode = FocusNode();
  final localityFocusNode = FocusNode();
  final aboutFocusNode = FocusNode();
  final addressFocusNode = FocusNode();

  List totalUsersList = [];

  int documentlength =0 ;
  int pagecount =0 ;
  int temp =1;
  List list = new List<int>.generate(10000, (i) => i + 1);

  List<cf.DocumentSnapshot> documentList = [];

  @override
  void initState() {
    getTotalUsers();
    super.initState();
  }

  getTotalUsers() async {
    var userDoc = await cf.FirebaseFirestore.instance.collection('Users').get();
    //setState(() {
      pagecount = (userDoc.docs.length / 10).toInt();
    //});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height / 81.375, horizontal: width / 170.75),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: height / 81.375, horizontal: width / 170.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "USERS",
                    style: GoogleFonts.openSans(
                        fontSize: width / 52.53,
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
                          clearTextControllers();
                        }

                      },
                      child: Container(
                        height:height/18.6,
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
                           EdgeInsets.symmetric(horizontal:width/227.66),
                          child: Center(
                            child: KText(
                              text: currentTab.toUpperCase() == "VIEW" ? "Add User" : "View Users",
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
                ? Stack(
                alignment: Alignment.center,
                  children: [
                    Container(
              height: marriedController.toUpperCase() == "MARRIED"
                      ? size.height * 2.4
                      : size.height * 2.2,
              width: width,
              margin: EdgeInsets.symmetric(horizontal: width / 68.3, vertical: height / 32.55),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: width / 68.3, vertical: height / 81.375),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: "Add User",
                                style: GoogleFonts.openSans(
                                  fontSize: width / 68.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Row(
                                children: [
                                  PopupMenuButton(
                                    itemBuilder: (BuildContext context) =>
                                        <PopupMenuEntry>[
                                      PopupMenuItem(
                                        child: Text('Download Template'),
                                        onTap: () {
                                          downloadTemplateExcel();
                                        },
                                      )
                                    ],
                                    child: Icon(
                                      Icons.remove_red_eye,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(width: width / 136.6),
                                  InkWell(
                                    onTap: () async {
                                      FilePickerResult? pickedFile =
                                          await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['xlsx'],
                                        allowMultiple: false,
                                      );
                                      var bytes = pickedFile!.files.single.bytes;
                                      var excel = ex.Excel.decodeBytes(bytes!);
                                      Response response =
                                          await UserFireCrud.bulkUploadUser(excel);
                                      if (response.code == 200) {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: "Users created successfully!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                      } else {
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: "Failed to Create Users!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                      }
                                    },
                                    child: Container(
                                      height: height / 18.6,
                                      width: width / 9.106,
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: width / 227.66),
                                        child: Center(
                                          child: KText(
                                            text: "Bulk Upload",
                                            style: GoogleFonts.openSans(
                                              fontSize: width / 105.076,
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
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              ),
                          ),
                          padding: EdgeInsets.symmetric(vertical: height / 43.4, horizontal: width / 91.06),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height: height / 3.829,
                                  width: width / 3.902,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants().primaryAppColor,
                                          width: width/683),
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
                                      ? Center(
                                          child: Icon(
                                            Icons.cloud_upload,
                                            size: width / 8.537,
                                            color: Colors.grey,
                                          ),
                                        )
                                      : null,
                                ),
                              ),
                              SizedBox(height: height / 32.55),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: selectImage,
                                    child: Container(
                                      height: height / 18.6,
                                      width: size.width * 0.25,
                                      color: Constants().primaryAppColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.add_a_photo, color: Colors.white),
                                          SizedBox(width: width / 136.6),
                                          const KText(
                                            text: 'Select Profile Photo *',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width / 27.32),
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
                                      height: height / 18.6,
                                      width: size.width * 0.25,
                                      color: Constants().primaryAppColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          const Icon(Icons.crop, color: Colors.white),
                                          SizedBox(width: width / 136.6),
                                          const KText(
                                            text: 'Disable Crop',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Firstname *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
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
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: firstNameController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Lastname *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
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
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: lastNameController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Phone *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          key: _keyPhone,
                                          focusNode: phoneFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(emailFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(emailFocusNode);
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
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 10,
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: phoneController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Email",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          key: _key,
                                          focusNode: emailFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            _key.currentState!.validate();
                                            FocusScope.of(context).requestFocus(professionFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(professionFocusNode);
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
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: emailController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Profession",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: professionFocusNode,
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
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: professionController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Aadhaar Number",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: aadhaarFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(pincodeFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(pincodeFocusNode);
                                          },
                                          key: _keyAadhar,
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
                                          style:
                                              TextStyle(fontSize: width / 113.83),
                                          controller: aadharController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Baptism Date",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize: width / 113.83),
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await Constants().datePicker(context);
                                                // await showDatePicker(
                                                // context: context,
                                                // initialDate: DateTime.now(),
                                                // firstDate: DateTime(1900),
                                                // lastDate: DateTime.now());
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
                                  SizedBox(width: width / 68.3),
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
                                          value: marriedController,
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
                                              marriedController = newValue!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  Container(
                                    width: width / 10.507,
                                    decoration:  BoxDecoration(
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
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: GenderController,
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
                                              GenderController = newValue!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width / 9.106,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Pin Code",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: pincodeFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(localityFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(localityFocusNode);
                                          },
                                            key:_keyPincode,
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
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: pincodeController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
                              Visibility(
                                visible: marriedController.toUpperCase() == "MARRIED",
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width / 4.553,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Anniversary Date",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width / 105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                            readOnly: true,
                                            style: TextStyle(fontSize: width / 113.83),
                                            controller: anniversaryDateController,
                                            onTap: () async {
                                              DateTime? pickedDate =
                                              await Constants().datePicker(context);
                                              // await showDatePicker(
                                              //     context: context,
                                              //     initialDate: DateTime.now(),
                                              //     firstDate: DateTime(1900),
                                              //     lastDate: DateTime.now());
                                              if (pickedDate != null) {
                                                setState(() {
                                                  anniversaryDateController.text = formatter.format(pickedDate);
                                                });
                                              }
                                            },
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height / 21.7),
                              Row(
                                children: [
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
                                                bloodGroupController.text = newValue!;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Date of Birth *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          key: _keyDob,
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: dobController,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return '';
                                            }
                                          },
                                          onTap: () async {
                                            DateTime? pickedDate =
                                                await Constants().datePicker(context);
                                            // await DatePicker.showSimpleDatePicker(
                                            //   context,
                                            //   initialDate: DateTime.now(),
                                            //   firstDate: DateTime(1900),
                                            //   lastDate: DateTime.now(),
                                            //   dateFormat: "dd-MM-yyyy",
                                            //   locale: DateTimePickerLocale.en_us,
                                            //   looping: true,
                                            // );
                                            // await showDatePicker(
                                            //   context: context,
                                            //   initialDate: DateTime.now(),
                                            //   firstDate: DateTime(1900),
                                            //   lastDate: DateTime.now(),
                                            //   initialEntryMode: DatePickerEntryMode.calendar,
                                            //   initialDatePickerMode: DatePickerMode.year,
                                            // );
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
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Landmark *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: localityFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(addressFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(addressFocusNode);
                                          },
                                          key: _keyLocality,
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          onChanged: (val){
                                            _keyLocality.currentState!.validate();
                                          },
                                          maxLength: 40,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return '';
                                            }
                                          },
                                          // inputFormatters: [
                                          //   FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                          // ],
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: localityController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
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
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Nationality",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
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
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: nationalityCon,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Residential Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: width / 105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                       horizontal: width/68.3,
                                      vertical: height/32.55
                                    ),
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
                                        SizedBox(
                                          height: height / 32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                focusNode: addressFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(aboutFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(aboutFocusNode);
                                                },
                                                maxLength: 255,
                                                style: TextStyle(
                                                    fontSize: width / 113.83),
                                                controller: addressController,
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(
                                                        left: width / 91.06,
                                                        top: height / 162.75,
                                                        bottom: height / 162.75)),
                                                maxLines: null,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Permanent Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: width / 105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width/68.3,
                                        vertical: height/32.55
                                    ),
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
                                        SizedBox(
                                          height: height / 32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                focusNode: aboutFocusNode,
                                                autofocus: true,
                                                maxLength: 255,
                                                style: TextStyle(
                                                    fontSize: width / 113.83),
                                                controller: aboutController,
                                                decoration: InputDecoration(
                                                  counterText: '',
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
                              SizedBox(height: height / 21.7),
                              // Visibility(
                              //   visible: profileImageValidator,
                              //   child: const Text(
                              //     "Please Select Image *",
                              //     style: TextStyle(
                              //         color: Colors.red,
                              //     ),
                              //   ),
                              // ),
                              SizedBox(height: height / 21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if(!isLoading){
                                        setState(() {
                                          isLoading = true;
                                        });
                                        _keyFirstname.currentState!.validate();
                                        _keyLastname.currentState!.validate();
                                        _keyLocality.currentState!.validate();
                                        _keyDob.currentState!.validate();
                                        _keyPhone.currentState!.validate();
                                        // if(profileImage == null){
                                        //   setState(() {
                                        //     profileImageValidator = true;
                                        //   });
                                        // }
                                        if (bloodGroupController.text != "Select Blood Group" &&
                                            firstNameController.text != "" &&
                                            lastNameController.text != "" &&
                                            localityController.text != "" &&
                                            dobController.text != "" &&
                                            phoneController.text != "" &&
                                            GenderController != "Select Gender" &&
                                            marriedController != "Select Status")
                                        {
                                          Response response = await UserFireCrud.addUser(
                                            maritialStatus: marriedController,
                                            pincode: pincodeController.text,
                                            gender: GenderController,
                                            image: profileImage,
                                            baptizeDate: baptizeDateController.text,
                                            nationality: nationalityCon.text,
                                            houseType: houseTypeCon.text,
                                            anniversaryDate: anniversaryDateController.text,
                                            aadharNo: aadharController.text,
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
                                            clearTextControllers();
                                          } else {
                                            await CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: "Failed to Create User!",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants()
                                                    .primaryAppColor
                                                    .withOpacity(0.8));
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        } else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: height / 16.6,
                                      width: width*0.1,
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
                                        padding: EdgeInsets.symmetric(horizontal: width / 190.66),
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
                                  ),
                                   SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: (){
                                      setState(() {
                                        currentTab = 'View';
                                      });
                                      clearTextControllers();
                                    },
                                    child: Container(
                                      height: height / 16.6,
                                      width: width*0.1,
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
                                        padding: EdgeInsets.symmetric(horizontal: width / 190.66),
                                        child: Center(
                                          child: KText(
                                            text: "Cancel",
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
                : currentTab.toUpperCase() == "VIEW" ?
             StreamBuilder(
                    stream: filterText != ""
                        ? cf.FirebaseFirestore.instance.collection('Users').where("firstName", isEqualTo: filterText).limit(10).snapshots()
                        : documentList.isNotEmpty
                        ? cf.FirebaseFirestore.instance.collection('Users').orderBy("timestamp", descending: true).startAfterDocument(documentList[documentList.length - 1]).limit(10).snapshots()
                        : cf.FirebaseFirestore.instance.collection('Users').orderBy("timestamp", descending: true).limit(10).snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasError) {
                        return Container();
                      } else if (snapshot.hasData) {
                        List<UserModelWithDocId> users = [];
                        //documentList.clear();
                        print("object");
                        documentList.addAll(snapshot.data!.docs);
                        for (var element in snapshot.data!.docs) {
                          users.add(UserModelWithDocId(element.id, UserModel.fromJson(element.data())));
                        }
                        // for (var element in snapshot.data!.docs) {
                        //   if(filterText != ""){
                        //     if(element.get("profession")!.toLowerCase().startsWith(filterText.toLowerCase())||
                        //         element.get("firstName")!.toLowerCase().startsWith(filterText.toLowerCase())||
                        //         element.get("pincode")!.toLowerCase().startsWith(filterText.toLowerCase())||
                        //         (element.get("firstName")!+element.get("lastName")!).toString().trim().toLowerCase().startsWith(filterText.toLowerCase()) ||
                        //         element.get("lastName")!.toLowerCase().startsWith(filterText.toLowerCase())||
                        //         element.get("phone")!.toLowerCase().startsWith(filterText.toLowerCase())){
                        //       users.add(
                        //         UserModelWithDocId(element.id, UserModel.fromJson(element.data()))
                        //       );
                        //     }
                        //   }else{
                        //     users.add(UserModelWithDocId(element.id, UserModel.fromJson(element.data())));
                        //   }
                        // }
                        return Container(
                          width: width,
                          margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
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
                                  padding:  EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(
                                        text: "All Users (${users.length})",
                                        style: GoogleFonts.openSans(
                                          fontSize: width / 68.3,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Row(
                                        children: [
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
                                                  controller: filterTextController,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      filterText = val;
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
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * 0.73,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal:width/170.75, vertical: height/65.1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            generateUserPdf(PdfPageFormat.standard, users, false);
                                          },
                                          child: Container(
                                            height: height / 18.6,
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
                                                  horizontal: width / 227.66),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.print,
                                                        color: Colors.white),
                                                    KText(
                                                      text: "PRINT",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color: Colors.white,
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: width / 136.6),
                                        InkWell(
                                          onTap: () {
                                            copyToClipBoard(users);
                                          },
                                          child: Container(
                                            height: height / 18.6,
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
                                                  horizontal: width / 227.66),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.copy,
                                                        color: Colors.white),
                                                    KText(
                                                      text: "COPY",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color: Colors.white,
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: width / 136.6),
                                        InkWell(
                                          onTap: () async {
                                            var data = await generateUserPdf(PdfPageFormat.letter, users, true);
                                            savePdfToFile(data);
                                          },
                                          child: Container(
                                            height: height / 18.6,
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
                                                  horizontal: width / 227.66),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Icon(Icons.picture_as_pdf,
                                                        color: Colors.white),
                                                    KText(
                                                      text: "PDF",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color: Colors.white,
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: width / 136.6),
                                        InkWell(
                                          onTap: () {
                                            convertToCsv(users);
                                          },
                                          child: Container(
                                            height: height / 18.6,
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
                                                  horizontal: width / 227.66),
                                              child: Center(
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                        Icons.file_copy_rounded,
                                                        color: Colors.white),
                                                    KText(
                                                      text: "CSV",
                                                      style:
                                                          GoogleFonts.openSans(
                                                        color: Colors.white,
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                    SizedBox(height: height / 21.7),
                                    SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric( horizontal: width / 273.2,
                                            vertical: height / 130.2),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: width / 17.075,
                                              child: KText(
                                                text: "No.",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 13.660,
                                              child: KText(
                                                text: "Photo",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 8.035,
                                              child: KText(
                                                text: "Name",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 9.106,
                                              child: KText(
                                                text: "Profession",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 8.035,
                                              child: KText(
                                                text: "Phone",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 9.106,
                                              child: KText(
                                                text: "Pin Code",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 7.588,
                                              child: KText(
                                                text: "Actions",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
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
                                            height: height / 10.55,
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
                                                  horizontal: width / 273.2,
                                                  vertical: height / 130.2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: width / 17.075,
                                                    child: KText(
                                                      text: (i + 1).toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 13.660,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage: NetworkImage(users[i].user.imgUrl!),
                                                          child: Visibility(
                                                            visible: users[i].user.imgUrl == "",
                                                              // child: Image.asset(
                                                              //   users[i].user.gender!.toLowerCase() == "male" ? "assets/mavatar.png" : "assets/favatar.png",
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
                                                    width: width / 8.035,
                                                    child: KText(
                                                      text:
                                                          "${users[i].user.firstName.toLowerCase() != 'null' ? users[i].user.firstName : ''} ${users[i].user.lastName.toLowerCase() != 'null' ? users[i].user.lastName : ''}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 9.106,
                                                    child: KText(
                                                      text:
                                                          users[i].user.profession!,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 8.035,
                                                    child: KText(
                                                      text: users[i].user.phone!,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 9.106,
                                                    child: KText(
                                                      text: users[i].user.pincode!,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: width / 7.588,
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              viewPopup(users[i].user);
                                                            },
                                                            child: Container(
                                                              height: height /
                                                                  26.04,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xff2baae4),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            2),
                                                                    blurRadius:
                                                                        3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            width /
                                                                                227.66),
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
                                                                          size: width /
                                                                              91.066),
                                                                      KText(
                                                                        text:
                                                                            "View",
                                                                        style: GoogleFonts
                                                                            .openSans(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              width / 136.6,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: width /
                                                                  273.2),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                GenderController = users[i].user.gender;
                                                                pincodeController.text = users[i].user.pincode;
                                                                baptizeDateController.text = users[i].user.baptizeDate;
                                                                bloodGroupController.text = users[i].user.bloodGroup;
                                                                dobController.text = users[i].user.dob;
                                                                emailController.text = users[i].user.email;
                                                                firstNameController.text = users[i].user.firstName;
                                                                aboutController.text = users[i].user.about;
                                                                addressController.text = users[i].user.address;
                                                                lastNameController.text = users[i].user.lastName;
                                                                localityController.text = users[i].user.locality;
                                                                phoneController.text = users[i].user.phone;
                                                                professionController.text = users[i].user.profession;
                                                                selectedImg = users[i].user.imgUrl;
                                                                uploadedImage = users[i].user.imgUrl;
                                                                marriedController = users[i].user.maritialStatus;
                                                                aadharController.text = users[i].user.aadharNo;
                                                                anniversaryDateController.text = users[i].user.anniversaryDate;
                                                                houseTypeCon.text = users[i].user.houseType;
                                                                nationalityCon.text = users[i].user.nationality;
                                                              });
                                                              editPopUp(users[i].user,users[i].userDocId, size);
                                                            },
                                                            child: Container(
                                                              height: height /
                                                                  26.04,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xffff9700),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            2),
                                                                    blurRadius:
                                                                        3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            width /
                                                                                227.66),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .add,
                                                                          color: Colors
                                                                              .white,
                                                                          size: width /
                                                                              91.066),
                                                                      KText(
                                                                        text:
                                                                            "Edit",
                                                                        style: GoogleFonts
                                                                            .openSans(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              width / 136.6,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: width /
                                                                  273.2),
                                                          InkWell(
                                                            onTap: () {
                                                              CoolAlert.show(
                                                                  context:
                                                                      context,
                                                                  type:
                                                                      CoolAlertType
                                                                          .info,
                                                                  text:
                                                                      "${users[i].user.firstName} ${users[i].user.lastName} will be deleted",
                                                                  title:
                                                                      "Delete this Record?",
                                                                  width: size
                                                                          .width *
                                                                      0.4,
                                                                  backgroundColor: Constants()
                                                                      .primaryAppColor
                                                                      .withOpacity(
                                                                          0.8),
                                                                  showCancelBtn:
                                                                      true,
                                                                  cancelBtnText:
                                                                      'Cancel',
                                                                  cancelBtnTextStyle:
                                                                      TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                  onConfirmBtnTap:
                                                                      () async {
                                                                    Response
                                                                        res = await UserFireCrud.deleteRecord(id: users[i].userDocId);
                                                                  });
                                                            },
                                                            child: Container(
                                                              height: height /
                                                                  26.04,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xfff44236),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            2),
                                                                    blurRadius:
                                                                        3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            width /
                                                                                227.66),
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
                                                                          size: width /
                                                                              91.066),
                                                                      KText(
                                                                        text:
                                                                            "Delete",
                                                                        style: GoogleFonts
                                                                            .openSans(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              width / 136.6,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      //alignment: Alignment.centerRight,
                                      children: [
                                        Container(
                                          width: width * 0.4,
                                          height: 50,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: 10,
                                              itemBuilder: (context,index){
                                                return TextButton(
                                                    onPressed: (){
                                                      // setState(() {
                                                      //   temp= list[index];
                                                      // });
                                                    },
                                                    child: Text((list[index]).toString(),
                                                      style: TextStyle(
                                                        color: temp.toString() == list[index].toString() ?  Constants().primaryAppColor : Colors.black,
                                                      ),
                                                    ),
                                                );
                                              }
                                              ),
                                        ),
                                        SizedBox(width: 5),
                                        Text(
                                          "..." + pagecount.toString(),
                                          style: TextStyle(
                                            color: Colors.black
                                          ),
                                        ),
                                        SizedBox(width: 20),
                                        temp > 1 ?
                                        ElevatedButton(
                                            onPressed: (){
                                          setState(() {
                                            temp= temp-1;
                                            documentList.removeRange(documentList.length - 20, documentList.length);
                                            print(documentList);
                                          });
                                        }, child: Text("Previous Page"))  : Container(),
                                        SizedBox(width: 20),
                                        Container(
                                          child: temp < pagecount ?
                                          ElevatedButton(onPressed: (){
                                            setState(() {
                                              temp= temp+1;
                                            });
                                          }, child: Text("Next Page"))  : Container(),
                                        )
                                      ],
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
                  ) :
            Container(),
            SizedBox(height: size.height * 0.04),
            const DeveloperCardWidget(),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }

  viewPopup(UserModel user) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
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
                    padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.firstName!,
                          style: GoogleFonts.openSans(
                            fontSize: width / 68.3,
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 227.66),
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
                                image: NetworkImage(user.imgUrl!),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width/136.6, vertical: height/43.4),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text:
                                            "${user.firstName!} ${user.lastName!}",
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Phone",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.phone!,
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Email",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.email!,
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Aadhaar Number",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      Text(
                                        mask(user.aadharNo!.toString()),
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Position",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.profession!,
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Baptism Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.baptizeDate!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Blood Group",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.bloodGroup!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Date of Birth",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.dob!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Gender",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.gender!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Landmark",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.locality!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "House Type",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.houseType!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Nationality",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.nationality!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Permanent Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      SizedBox(
                                        width: size.width*0.3,
                                        child: Text(
                                          user.about!,
                                          style: TextStyle(fontSize: width/97.571),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Residential Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      SizedBox(
                                        width: size.width * 0.3,
                                        child: Text(
                                          user.address,
                                          style: TextStyle(fontSize: width/97.571),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Pin Code",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.pincode!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
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

  String mask(String input) {
    String result = '';
    int maskLen = input.length - 4;
    for (int i = 0; i < input.length; i++) {
      if (i < maskLen) {
        result += 'x';
      } else {
        result += input[i].toString();
      }
    }
    return result;
  }

  editPopUp(UserModel user,String userDocID, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setStat) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              height: marriedController.toUpperCase() == "MARRIED"
                  ? size.height * 2
                  : size.height * 1.9,
              width: width / 1.2418,
              margin: EdgeInsets.symmetric(horizontal: width / 68.3, vertical: height / 32.55),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: width / 68.3, vertical: height / 81.375),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: "Edit User",
                            style: GoogleFonts.openSans(
                              fontSize: width / 68.3,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          InkWell(
                              onTap:(){
                                clearTextControllers();
                                Navigator.pop(context);
                              },
                              child: Container(
                                height:height/18.6,
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
                                   EdgeInsets.symmetric(horizontal:width/227.66),
                                  child: Center(
                                    child: KText(
                                      text: "Cancel",
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
                  ),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: height / 43.4, horizontal: width / 91.06),
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
                                        width: width/683),
                                    image: selectedImg != null
                                        ? DecorationImage(
                                        fit: isCropped ? BoxFit.contain : BoxFit.cover,
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
                                child: (selectedImg == null && uploadedImage == null)
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
                            SizedBox(height: height / 32.55),
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
                                    height: height / 18.6,
                                    width: size.width * 0.25,
                                    color: Constants().primaryAppColor,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.add_a_photo, color: Colors.white),
                                        SizedBox(width: width / 136.6),
                                        const KText(
                                          text: 'Select Profile Photo',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: width / 27.32),
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
                                    height: height / 18.6,
                                    width: size.width * 0.25,
                                    color: Constants().primaryAppColor,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.crop, color: Colors.white),
                                        SizedBox(width: width / 136.6),
                                        const KText(
                                          text: 'Disable Crop',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Row(
                              children: [
                                SizedBox(
                                  width: width / 4.553,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Firstname *",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
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
                                        style: TextStyle(fontSize: width / 113.83),
                                        controller: firstNameController,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: width / 68.3),
                                SizedBox(
                                  width: width / 4.553,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Lastname *",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
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
                                        style: TextStyle(fontSize: width / 113.83),
                                        controller: lastNameController,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: width / 68.3),
                                SizedBox(
                                  width: width / 4.553,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Phone *",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
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
                                        style: TextStyle(fontSize: width / 113.83),
                                        controller: phoneController,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Row(
                              children: [
                                SizedBox(
                                  width: width / 4.553,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Email",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
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
                                        style: TextStyle(fontSize: width / 113.83),
                                        controller: emailController,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: width / 68.3),
                                SizedBox(
                                  width: width / 4.553,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Profession",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          counterText: "",
                                        ),
                                        maxLength: 100,
                                        style: TextStyle(fontSize: width / 113.83),
                                        controller: professionController,
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: width / 68.3),
                                SizedBox(
                                  width: width / 4.553,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Aadhaar Number",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
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
                                        style:
                                        TextStyle(fontSize: width / 113.83),
                                        controller: aadharController,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Row(
                              children: [
                                SizedBox(
                                  width: width / 4.553,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Baptism Date",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextFormField(
                                        style: TextStyle(fontSize: width / 113.83),
                                        controller: baptizeDateController,
                                        onTap: () async {
                                          DateTime? pickedDate =
                                          await Constants().datePicker(context);
                                          // await showDatePicker(
                                          //     context: context,
                                          //     initialDate: DateTime.now(),
                                          //     firstDate: DateTime(1900),
                                          //     lastDate: DateTime.now());
                                          if (pickedDate != null) {
                                            setStat(() {
                                              baptizeDateController.text = formatter.format(pickedDate);
                                            });
                                          }
                                        },
                                      )
                                    ],
                                  ),
                                ),
                                SizedBox(width: width / 68.3),
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
                                        value: marriedController,
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
                                            marriedController = newValue!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: width / 68.3),
                                Container(
                                  width: width / 10.507,
                                  decoration:  BoxDecoration(
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
                                          fontSize: width / 105.076,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      DropdownButton(
                                        value: GenderController,
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
                                            GenderController = newValue!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: width / 68.3),
                                SizedBox(
                                  width: width / 9.106,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Pin Code",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
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
                                        style: TextStyle(fontSize: width / 113.83),
                                        controller: pincodeController,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Visibility(
                              visible: marriedController.toUpperCase() == "MARRIED",
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Anniversary Date",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: anniversaryDateController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await Constants().datePicker(context);
                                            // await showDatePicker(
                                            //     context: context,
                                            //     initialDate: DateTime.now(),
                                            //     firstDate: DateTime(1900),
                                            //     lastDate: DateTime.now());
                                            if (pickedDate != null) {
                                              setState(() {
                                                anniversaryDateController.text = formatter.format(pickedDate);
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height / 21.7),
                            Row(
                              children: [
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
                                SizedBox(width: width / 68.3),
                                SizedBox(
                                  width: width / 4.553,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Date of Birth",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextFormField(
                                        style: TextStyle(fontSize: width / 113.83),
                                        controller: dobController,
                                        onTap: () async {
                                          DateTime? pickedDate =
                                          await Constants().datePicker(context);
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
                                SizedBox(width: width / 68.3),
                                SizedBox(
                                  width: width / 4.553,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Landmark *",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextFormField(
                                        decoration: InputDecoration(
                                          counterText: "",
                                        ),
                                        maxLength: 40,
                                        style: TextStyle(fontSize: width / 113.83),
                                        controller: localityController,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height / 21.7),
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
                                  width: width / 4.553,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Nationality",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize: width / 105.076,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextFormField(
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
                                        style: TextStyle(fontSize: width / 113.83),
                                        controller: nationalityCon,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Residential Address",
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: width / 105.076,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.15,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width/68.3,
                                      vertical: height/32.55
                                  ),
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
                                      SizedBox(
                                        height: height / 32.55,
                                        width: double.infinity,
                                      ),
                                      Expanded(
                                        child: Container(
                                            width: double.infinity,
                                            decoration: const BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: TextFormField(
                                              maxLength: 255,
                                              style: TextStyle(
                                                  fontSize: width / 113.83),
                                              controller: addressController,
                                              decoration: InputDecoration(
                                                counterText: '',
                                                  border: InputBorder.none,
                                                  contentPadding: EdgeInsets.only(
                                                      left: width / 91.06,
                                                      top: height / 162.75,
                                                      bottom: height / 162.75)),
                                              maxLines: null,
                                            )),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Permanent Address",
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: width / 105.076,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Container(
                                  height: size.height * 0.15,
                                  width: double.infinity,
                                  margin: EdgeInsets.symmetric(
                                      horizontal: width/68.3,
                                      vertical: height/32.55
                                  ),
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
                                      SizedBox(
                                        height: height / 32.55,
                                        width: double.infinity,
                                      ),
                                      Expanded(
                                        child: Container(
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                            ),
                                            child: TextFormField(
                                              maxLength: 255,
                                              style: TextStyle(
                                                  fontSize: width / 113.83),
                                              controller: aboutController,
                                              decoration: InputDecoration(
                                                counterText: '',
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
                            SizedBox(height: height / 21.7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if (marriedController != "Select Status" &&
                                        firstNameController.text != "" &&
                                        lastNameController.text != "" &&
                                        localityController.text != "" &&
                                        phoneController.text != "") {
                                      Response response = await UserFireCrud.updateRecord(userDocID, UserModel(
                                        id: user.id,
                                        isPrivacyEnabled: user.isPrivacyEnabled,
                                        pincode: pincodeController.text != "" ? pincodeController.text : user.pincode,
                                        timestamp: user.timestamp,
                                        baptizeDate: baptizeDateController.text != "" ? baptizeDateController.text : user.baptizeDate,
                                        bloodGroup: bloodGroupController.text != "" ? bloodGroupController.text : user.bloodGroup,
                                        dob: dobController.text.isNotEmpty ? dobController.text : user.dob,
                                        address: addressController.text.isNotEmpty ? addressController.text : user.address,
                                        email: emailController.text.isNotEmpty ? emailController.text : user.email,
                                        aadharNo: aadharController.text.isNotEmpty ? aadharController.text : user.aadharNo,
                                        firstName: firstNameController.text.isNotEmpty ? firstNameController.text : user.firstName,
                                        maritialStatus: marriedController.isNotEmpty ? marriedController : user.maritialStatus,
                                        fcmToken: user.fcmToken,
                                        gender: GenderController.isNotEmpty ? GenderController : user.gender,
                                        imgUrl: user.imgUrl,
                                        houseType: houseTypeCon.text.isNotEmpty ? houseTypeCon.text : user.houseType,
                                        nationality: nationalityCon.text.isNotEmpty ? nationalityCon.text : user.nationality,
                                        anniversaryDate: marriedController
                                            .toUpperCase() ==
                                            "MARRIED"
                                            ? anniversaryDateController.text
                                            : user.anniversaryDate,
                                        lastName: lastNameController.text.isNotEmpty ? lastNameController.text : user.lastName,
                                        locality: localityController.text.isNotEmpty ? localityController.text : user.locality,
                                        phone: phoneController.text.isNotEmpty ? phoneController.text : user.phone,
                                        profession: professionController.text.isNotEmpty ? professionController.text : user.profession,
                                        about: aboutController.text.isNotEmpty ? aboutController.text : user.about,
                                      ),
                                          profileImage, user.imgUrl ?? "");
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
                                          aadharController.text = "";
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
                                        clearTextControllers();
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
                                        clearTextControllers();
                                        Navigator.pop(context);
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
                                    height: height / 18.6,
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
                                          horizontal: width / 227.66),
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
                                 SizedBox(width: width/136.6),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      currentTab = 'View';
                                    });
                                    clearTextControllers();
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    height: height / 18.6,
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
                                          horizontal: width / 227.66),
                                      child: Center(
                                        child: KText(
                                          text: "Cancel",
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
        });
      },
    );
  }

  convertToCsv(List<UserModelWithDocId> users) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Name");
    row.add("Phone");
    row.add("Email");
    row.add("Profession");
    row.add("Baptism Date");
    row.add("Marital Status");
    row.add("Blood Group");
    row.add("Date of birth");
    row.add("Landmark");
    row.add("Pin Code");
    row.add("Address");
    row.add("About");
    rows.add(row);
    for (int i = 0; i < users.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("${users[i].user.firstName!} ${users[i].user.lastName!}");
      row.add(users[i].user.phone);
      row.add(users[i].user.email);
      row.add(users[i].user.profession);
      row.add(users[i].user.baptizeDate);
      row.add(users[i].user.maritialStatus);
      row.add(users[i].user.bloodGroup);
      row.add(users[i].user.dob);
      row.add(users[i].user.locality);
      row.add(users[i].user.pincode);
      row.add(users[i].user.address);
      row.add(users[i].user.about);
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
    final blob = Blob([data], 'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "Users.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<UserModelWithDocId> users) async {
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
    row.add("Landmark");
    rows.add(row);
    for (int i = 0; i < users.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add("${users[i].user.firstName} ${users[i].user.lastName}");
      row.add("       ");
      row.add(users[i].user.profession);
      row.add("       ");
      row.add(users[i].user.phone);
      row.add("       ");
      row.add(users[i].user.locality);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows,
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
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width:3),
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

class UserModelWithDocId{
  UserModelWithDocId(this.userDocId, this.user);
  String userDocId;
  UserModel user;
}

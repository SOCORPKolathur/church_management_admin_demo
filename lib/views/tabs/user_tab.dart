import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:church_management_admin/models/user_model.dart';
import 'package:church_management_admin/services/user_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as wb;
import '../../constants.dart';
import '../../models/response.dart';
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
  TextEditingController filterTextController = TextEditingController();
  String filterText = "";
  String marriedController = "Select Status";
  String GenderController = "Select Gender";
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

  downloadTemplateExcel() async {
    final wb.Workbook workbook = wb.Workbook();
    final wb.Worksheet sheet   = workbook.worksheets[0];
    sheet.getRangeByName("A1").setText("No.");
    sheet.getRangeByName("B1").setText("Firstname");
    sheet.getRangeByName("C1").setText("Lastname");
    sheet.getRangeByName("D1").setText("Phone");
    sheet.getRangeByName("E1").setText("Email");
    sheet.getRangeByName("F1").setText("Profession");
    sheet.getRangeByName("G1").setText("Baptize Date");
    sheet.getRangeByName("H1").setText("Marital Status");
    sheet.getRangeByName("I1").setText("Gender");
    sheet.getRangeByName("J1").setText("Blood Group");
    sheet.getRangeByName("K1").setText("Date of birth");
    sheet.getRangeByName("L1").setText("Pin code");
    sheet.getRangeByName("M1").setText("Address");
    sheet.getRangeByName("N1").setText("About");
    sheet.getRangeByName("O1").setText("Annivarsary Date");

    final List<int>bytes = workbook.saveAsStream();
    workbook.dispose();
    AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
        ..setAttribute('download', 'UserTemplate.xlsx')
        ..click();

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
              child: KText(
                text: "USERS",
                style: GoogleFonts.openSans(
                    fontSize: width/52.53,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            Container(
              height: marriedController.toUpperCase() ==
                  "MARRIED"? size.height * 1.95 : size.height * 1.85,
              width: width/1.2418,
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
                            text: "Add User",
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
                                  Response response = await UserFireCrud.bulkUploadUser(excel);
                                  if(response.code == 200){
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Users created successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor.withOpacity(0.8)
                                    );
                                  }else{
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to Create Users!",
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
                                     EdgeInsets.symmetric(horizontal:width/227.66),
                                    child: Center(
                                      child: KText(
                                        text: "Bulk Upload",
                                        style: GoogleFonts.openSans(
                                          fontSize:width/105.076,
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
                        vertical: height/43.4,
                        horizontal: width/91.06
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
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
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
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: lastNameController,
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
                                      text: "Phone *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: phoneController,
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
                                      text: "Email",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: emailController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width:width/68.3),
                              // SizedBox(
                              //   width:width/4.553,
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       KText(
                              //         text: "Password",
                              //         style: GoogleFonts.openSans(
                              //           color: Colors.black,
                              //           fontSize:width/105.076,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       TextFormField(
                              //         style:  TextStyle(fontSize:width/113.83),
                              //         controller: passwordController,
                              //       )
                              //     ],
                              //   ),
                              // ),
                              //  SizedBox(width:width/68.3),
                              // SizedBox(
                              //   width:width/4.553,
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       KText(
                              //         text: "Confirm Password",
                              //         style: GoogleFonts.openSans(
                              //           color: Colors.black,
                              //           fontSize:width/105.076,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       TextFormField(
                              //         style:  TextStyle(fontSize:width/113.83),
                              //         controller: confPaswordController,
                              //       )
                              //     ],
                              //   ),
                              // ),
                              SizedBox(
                                width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Profession",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: professionController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width:width/68.3),
                              SizedBox(
                                width:width/4.553,
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Aadhaar Number",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: aadharController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height:height/21.7),
                          Row(
                            children: [
                              // SizedBox(width:width/68.3),
                              SizedBox(
                                width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Baptize Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000));
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
                               SizedBox(width:width/68.3),
                              SizedBox(
                                width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Marital status *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                       isDense: true,
                                      value: marriedController,
                                      icon:
                                       Icon(Icons.keyboard_arrow_down),
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
                              SizedBox(width:width/68.3),
                              SizedBox(
                                width: width/10.507,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Gender *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      isDense: true,
                                      value: GenderController,
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
                                          GenderController = newValue!;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                                width:width/9.106,
                                child:
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Pin Code",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: pincodeController,
                                    )
                                  ],
                                ),
                              ),

                            ],
                          ),
                           SizedBox(height:height/21.7),
                          Visibility(
                            visible: marriedController.toUpperCase() ==
                                "MARRIED",
                            child: Row(
                              children: [
                                SizedBox(
                                  width:width/4.553,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Anniversary Date",
                                        style: GoogleFonts.openSans(
                                          color: Colors.black,
                                          fontSize:width/105.076,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      TextFormField(
                                        style:  TextStyle(fontSize:width/113.83),
                                        controller: anniversaryDateController,
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
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
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                     SizedBox(height:height/50.076),
                                    DropdownButton(
                                      isExpanded: true,
                                      value: bloodGroupController.text,
                                      icon:  Icon(Icons.keyboard_arrow_down),
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
                               SizedBox(width:width/68.3),
                              SizedBox(
                                width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Date of Birth",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: dobController,
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000));
                                        if (pickedDate != null) {
                                          setState(() {
                                            dobController.text = formatter.format(pickedDate);
                                          });
                                        }
                                      },
                                      decoration:  InputDecoration(
                                        hintText: "Ex: 2/9/2000"
                                      ),
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
                                      text: "Locality *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: localityController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height:height/21.7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Address",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize:width/105.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
                                margin:  EdgeInsets.all(20),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                     SizedBox(
                                      height:height/32.55,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration:  BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:
                                                 TextStyle(fontSize:width/113.83),
                                            controller: addressController,
                                            decoration:  InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: width/91.06,
                                                    top: height/162.75,
                                                    bottom: height/162.75)),
                                            maxLines: null,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height:height/21.7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "About",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize:width/105.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
                                margin:  EdgeInsets.all(20),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                     SizedBox(
                                      height:height/32.55,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration:  BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:
                                                 TextStyle(fontSize:width/113.83),
                                            controller: aboutController,
                                            decoration:  InputDecoration(
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
                           SizedBox(height:height/21.7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (profileImage != null &&
                                      bloodGroupController.text != "Select Blood Group" &&
                                      firstNameController.text != "" &&
                                      lastNameController.text != "" &&
                                      localityController.text != "" &&
                                      phoneController.text != "" &&
                                      GenderController != "Select Gender"&&
                                      marriedController != "Select Status"
                                  ) {
                                    Response response = await UserFireCrud.addUser(
                                          maritialStatus:marriedController,
                                         pincode: pincodeController.text,
                                         gender: GenderController,
                                        image: profileImage!,
                                      baptizeDate: baptizeDateController.text,
                                      anniversaryDate:
                                          anniversaryDateController.text,
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
                                        aadharController.text = "";
                                        anniversaryDateController.text = "";
                                        marriedController = "Select Status";
                                        GenderController = "Select Gender";
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
                                    }
                                    else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create User!",
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
                                 height:height/18.6,
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
            filterText != "" ?
            StreamBuilder(
              stream: UserFireCrud.fetchUsersWithFilter(filterText),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<UserModel> users = snapshot.data!;
                  return Container(
                    width: 1100,
                    margin:  EdgeInsets.all(20),
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
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "All Users (${users.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/68.3,
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
                                        height:height/18.6,
                                        width:width/9.106,
                                        child: Padding(
                                          padding:  EdgeInsets.symmetric(
                                              vertical: height/81.375,
                                              horizontal: width/170.75
                                          ),
                                          child: TextField(
                                            controller: filterTextController,
                                            onSubmitted: (val){
                                              setState(() {
                                                filterText = val;
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
                                    SizedBox(width:width/273.2),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          filterText = filterTextController.text;
                                          filterTextController.text = "";
                                        });
                                      },
                                      child: Container(
                                        height:height/18.6,
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
                                          EdgeInsets.symmetric(horizontal:width/227.66),
                                          child: Center(
                                            child: KText(
                                              text: "Apply",
                                              style: GoogleFonts.openSans(
                                                fontSize:width/105.076,
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
                                      generateUserPdf(
                                          PdfPageFormat.letter, users,false);
                                    },
                                    child: Container(
                                      height:height/18.6,
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
                                                  fontSize:width/105.076,
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
                                      copyToClipBoard(users);
                                    },
                                    child: Container(
                                      height:height/18.6,
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
                                                  fontSize:width/105.076,
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
                                      var data = await generateUserPdf(PdfPageFormat.letter, users,true);
                                      savePdfToFile(data);
                                    },
                                    child: Container(
                                      height:height/18.6,
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
                                                  fontSize:width/105.076,
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
                                      convertToCsv(users);
                                    },
                                    child: Container(
                                      height:height/18.6,
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
                                                  fontSize:width/105.076,
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
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/136.60,
                                        child: KText(
                                          text: "Photo",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/8.035,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/9.106,
                                        child: KText(
                                          text: "Profession",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/8.035,
                                        child: KText(
                                          text: "Phone",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/9.106,
                                        child: KText(
                                          text: "Pin Code",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/7.588,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
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
                                      height:height/10.55,
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
                                              width:width/17.075,
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.076,
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
                                                    NetworkImage(
                                                        users[i].imgUrl!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/8.035,
                                              child: KText(
                                                text:
                                                "${users[i].firstName!} ${users[i].lastName!}",
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/9.106,
                                              child: KText(
                                                text: users[i].profession!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/8.035,
                                              child: KText(
                                                text: users[i].phone!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/9.106,
                                              child: KText(
                                                text: users[i].pincode!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.076,
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
                                                        viewPopup(users[i]);
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
                                                          EdgeInsets.symmetric(horizontal: width/227.66),
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
                                                                    size:width/91.066
                                                                ),
                                                                KText(
                                                                  text: "View",
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
                                                    SizedBox(width:width/273.2),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          GenderController=users[i].gender!;
                                                          pincodeController.text=users[i].pincode!;
                                                          baptizeDateController.text = users[i].baptizeDate!;
                                                          bloodGroupController.text =
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
                                                          lastNameController.text =
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
                                                          users[i].profession!;
                                                          // confPaswordController
                                                          //         .text =
                                                          //     users[i]
                                                          //         .password!;
                                                          selectedImg =
                                                              users[i].imgUrl;
                                                          marriedController = users[i].maritialStatus!;
                                                          anniversaryDateController.text = users[i].anniversaryDate!;
                                                        });
                                                        editPopUp(users[i], size);
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
                                                                    size:width/91.066
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
                                                    SizedBox(width:width/273.2),
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
                                                            TextStyle(
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
                                                                    size:width/91.066
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
            ) :
            StreamBuilder(
              stream: UserFireCrud.fetchUsers(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<UserModel> users = snapshot.data!;
                  return Container(
                    width: 1100,
                    margin:  EdgeInsets.all(20),
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
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "All Users (${users.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/68.3,
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
                                       height:height/18.6,
                                        width:width/9.106,
                                        child: Padding(
                                         padding:  EdgeInsets.symmetric(
        vertical: height/81.375,
        horizontal: width/170.75
      ),
                                          child: TextField(
                                            controller: filterTextController,
                                            onSubmitted: (val){
                                              setState(() {
                                                filterText = val;
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
                                     SizedBox(width:width/273.2),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          filterText = filterTextController.text;
                                          filterTextController.text = "";
                                        });
                                      },
                                      child: Container(
                                       height:height/18.6,
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
                                           EdgeInsets.symmetric(horizontal:width/227.66),
                                          child: Center(
                                            child: KText(
                                              text: "Apply",
                                              style: GoogleFonts.openSans(
                                                fontSize:width/105.076,
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
                                      generateUserPdf(
                                          PdfPageFormat.letter, users,false);
                                    },
                                    child: Container(
                                     height:height/18.6,
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
                                                  fontSize:width/105.076,
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
                                      copyToClipBoard(users);
                                    },
                                    child: Container(
                                     height:height/18.6,
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
                                                  fontSize:width/105.076,
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
                                      var data = await generateUserPdf(PdfPageFormat.letter, users,true);
                                      savePdfToFile(data);
                                    },
                                    child: Container(
                                     height:height/18.6,
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
                                                  fontSize:width/105.076,
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
                                      convertToCsv(users);
                                    },
                                    child: Container(
                                     height:height/18.6,
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
                                                  fontSize:width/105.076,
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
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/136.60,
                                        child: KText(
                                          text: "Photo",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/8.035,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/9.106,
                                        child: KText(
                                          text: "Profession",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/8.035,
                                        child: KText(
                                          text: "Phone",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/9.106,
                                        child: KText(
                                          text: "Pin Code",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/7.588,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
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
                                      height:height/10.55,
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
                                             width:width/17.075,
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.076,
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
                                                        NetworkImage(
                                                            users[i].imgUrl!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/8.035,
                                              child: KText(
                                                text:
                                                    "${users[i].firstName!} ${users[i].lastName!}",
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/9.106,
                                              child: KText(
                                                text: users[i].profession!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/8.035,
                                              child: KText(
                                                text: users[i].phone!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/9.106,
                                              child: KText(
                                                text: users[i].pincode!,
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.076,
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
                                                        viewPopup(users[i]);
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
                                                               EdgeInsets.symmetric(horizontal: width/227.66),
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
                                                                 size:width/91.066
                                                                ),
                                                                KText(
                                                                  text: "View",
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
                                                     SizedBox(width:width/273.2),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          GenderController=users[i].gender!;
                                                          pincodeController.text=users[i].pincode!;
                                                          baptizeDateController.text = users[i].baptizeDate!;
                                                          bloodGroupController.text =
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
                                                          lastNameController.text =
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
                                                              users[i].profession!;
                                                          // confPaswordController
                                                          //         .text =
                                                          //     users[i]
                                                          //         .password!;
                                                          selectedImg =
                                                              users[i].imgUrl;
                                                          marriedController = users[i].maritialStatus!;
                                                          anniversaryDateController.text = users[i].anniversaryDate!;
                                                        });
                                                        editPopUp(users[i], size);
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
                                                                 size:width/91.066
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
                                                     SizedBox(width:width/273.2),
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
                                                                 TextStyle(
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
                                                                 size:width/91.066
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
            )
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
            margin:  EdgeInsets.all(20),
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
                         EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.firstName!,
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
                            height: 40,
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
                                   EdgeInsets.symmetric(horizontal:width/227.66),
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
                                image: NetworkImage(user.imgUrl!),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                   SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: "${user.firstName!} ${user.lastName!}",
                                        style:  TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Phone",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.phone!,
                                        style:  TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Email",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.email!,
                                        style:  TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Aadhaar Number",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      Text(
                                        mask(user.aadharNo!.toString()),
                                        style:  TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Position",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.profession!,
                                        style:  TextStyle(fontSize: 14),
                                      )
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Baptize Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.baptizeDate!,
                                        style:  TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Blood Group",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.bloodGroup!,
                                        style:  TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Date of Birth",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.dob!,
                                        style:  TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Gender",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.gender!,
                                        style:  TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Locality",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.locality!,
                                        style:  TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "About",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.about!,
                                        style:  TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.address!,
                                        style:  TextStyle(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                   SizedBox(height:height/32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Pin Code",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width:width/68.3),
                                      KText(
                                        text: user.pincode!,
                                        style:  TextStyle(fontSize: 14),
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

  editPopUp(UserModel user, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
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
                margin:  EdgeInsets.all(20),
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
                        padding:
                             EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            KText(
                              text: "Edit User",
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
                                  baptizeDateController.text = "";
                                  bloodGroupController.text = "";
                                  dobController.text = "";
                                  addressController.text = "";
                                  aadharController.text = "";
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
                                  pincodeController.text="";
                                  //confPaswordController.text = "";
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
                        padding:  EdgeInsets.all(15),
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
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style:  TextStyle(fontSize:width/113.83),
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
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
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
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Email",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: emailController,
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
                                          text: "Phone *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          ],
                                          style:  TextStyle(fontSize:width/113.83),
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
                                          text: "Aadhaar Number",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          ],
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: aadharController,
                                        )
                                      ],
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width:width/4.553,
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       KText(
                                  //         text: "Password",
                                  //         style: GoogleFonts.openSans(
                                  //           color: Colors.black,
                                  //           fontSize:width/105.076,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       TextFormField(
                                  //         style:  TextStyle(fontSize:width/113.83),
                                  //         controller: passwordController,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                  //  SizedBox(width:width/68.3),
                                  // SizedBox(
                                  //   width:width/4.553,
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       KText(
                                  //         text: "Confirm Password",
                                  //         style: GoogleFonts.openSans(
                                  //           color: Colors.black,
                                  //           fontSize:width/105.076,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       TextFormField(
                                  //         style:  TextStyle(fontSize:width/113.83),
                                  //         controller: confPaswordController,
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
                                          text: "Profession",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: professionController,
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
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: baptizeDateController,
                                        )
                                      ],
                                    ),
                                  ),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Marital status *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: marriedController,
                                          icon:
                                           Icon(Icons.keyboard_arrow_down),
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
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width: 160,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Gender *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: GenderController,
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
                                              GenderController = newValue!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/21.7),
                              Visibility(
                                visible: marriedController.toUpperCase() ==
                                    "MARRIED",
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width:width/4.553,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Anniversary Date",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize:width/105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                            style:  TextStyle(fontSize:width/113.83),
                                            controller: anniversaryDateController,
                                          )
                                        ],
                                      ),
                                    ),
                                     SizedBox(width:width/68.3),
                                    SizedBox(
                                      width:width/4.553,
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Pin Code",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize:width/105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                            ],
                                            style:  TextStyle(fontSize:width/113.83),
                                            controller: pincodeController,
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: bloodGroupController,
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
                                          text: "Date of Birth",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style:  TextStyle(fontSize:width/113.83),
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
                                          text: "Locality *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style:  TextStyle(fontSize:width/113.83),
                                          controller: localityController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height:height/21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
                                    margin:  EdgeInsets.all(20),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                         SizedBox(
                                          height:height/32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration:  BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                style:
                                                     TextStyle(fontSize:width/113.83),
                                                controller: addressController,
                                                decoration:  InputDecoration(
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
                               SizedBox(height:height/21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "About",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
                                    margin:  EdgeInsets.all(20),
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                         SizedBox(
                                          height:height/32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration:  BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                style:
                                                     TextStyle(fontSize:width/113.83),
                                                controller: aboutController,
                                                decoration:  InputDecoration(
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
                               SizedBox(height:height/21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      print("dufffffffffffffffffffffffffffffffffffffffffffffffffff");
                                      print(pincodeController.text);
                                      if (baptizeDateController.text != "" &&
                                          bloodGroupController.text != "" &&
                                          aboutController.text != "" &&
                                          dobController.text != "" &&
                                          addressController.text != "" &&
                                          emailController.text != "" &&
                                          marriedController != "Select Status" &&
                                          firstNameController.text != "" &&
                                          lastNameController.text != "" &&
                                          localityController.text != "" &&
                                          phoneController.text != "" &&
                                          phoneController.text != "" &&
                                          pincodeController.text != "") {
                                        print("Enteredddddd");

                                        Response response =
                                            await UserFireCrud.updateRecord(
                                                UserModel(
                                                  id: user.id,
                                                  pincode: pincodeController.text,
                                                  timestamp: user.timestamp,
                                                  baptizeDate: baptizeDateController.text,
                                                  bloodGroup: bloodGroupController.text,
                                                  dob: dobController.text,
                                                  address: addressController.text,
                                                  email: emailController.text,
                                                  aadharNo: aadharController.text,
                                                  firstName: firstNameController.text,
                                                  maritialStatus: marriedController,
                                                  anniversaryDate:  marriedController.toUpperCase() ==
                                                      "MARRIED"? anniversaryDateController.text : "",
                                                  lastName: lastNameController.text,
                                                  locality: localityController.text,
                                                  phone: phoneController.text,
                                                  profession: professionController.text,
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
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        }
                                        else {
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
                                     height:height/18.6,
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
    row.add("Pin Code");
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
      row.add(users[i].pincode);
      row.add(users[i].address);
      row.add(users[i].about);
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
    String csv =  ListToCsvConverter().convert(rows,
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

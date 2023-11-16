import 'dart:html';
import 'dart:typed_data';
import 'package:church_management_admin/models/department_model.dart';
import 'package:church_management_admin/services/department_firecrud.dart';
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
import '../prints/department_print.dart';
import 'package:excel/excel.dart' as ex;

class DepartmentTab extends StatefulWidget {
  DepartmentTab({super.key});

  @override
  State<DepartmentTab> createState() => _DepartmentTabState();
}

class _DepartmentTabState extends State<DepartmentTab> {

  TextEditingController nameController = TextEditingController();
  TextEditingController leadernameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zoneController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  String searchString = "";

  String currentTab = 'View';

  bool isLoading = false;

  final _keyDeptName = GlobalKey<FormFieldState>();
  final _keyDeptLeadName = GlobalKey<FormFieldState>();
  final _keyPhone = GlobalKey<FormFieldState>();
  final _keyDeptArea = GlobalKey<FormFieldState>();
  final _keyzone = GlobalKey<FormFieldState>();

  final nameFocusNode = FocusNode();
  final leaderNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final areaFocusNode = FocusNode();
  final descriptionFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final cityFocusNode = FocusNode();
  final countryFocusNode = FocusNode();
  final postFocusNode = FocusNode();

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
                    text: "DEPARTMENTS",
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
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Department" : "View Departments",
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
              height: size.height * 1.4,
              width: double.infinity,
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
                            children: [
                              Icon(Icons.account_tree),
                              SizedBox(width: width/136.6),
                              KText(
                                text: "ADD DEPARTMENT",
                                style: GoogleFonts.openSans(
                                 fontSize: width/68.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Expanded(child: Container()),
                              // InkWell(
                              //   onTap: () async {
                              //     FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                              //       type: FileType.custom,
                              //       allowedExtensions: ['xlsx'],
                              //       allowMultiple: false,
                              //     );
                              //     var bytes = pickedFile!.files.single.bytes;
                              //     var excel = ex.Excel.decodeBytes(bytes!);
                              //     Response response = await DepartmentFireCrud.bulkUploadDepartment(excel);
                              //     if(response.code == 200){
                              //       CoolAlert.show(
                              //           context: context,
                              //           type: CoolAlertType.success,
                              //           text: "Department created successfully!",
                              //           width: size.width * 0.4,
                              //           backgroundColor: Constants()
                              //               .primaryAppColor.withOpacity(0.8)
                              //       );
                              //     }else{
                              //       CoolAlert.show(
                              //           context: context,
                              //           type: CoolAlertType.error,
                              //           text: "Failed to Create Department!",
                              //           width: size.width * 0.4,
                              //           backgroundColor: Constants()
                              //               .primaryAppColor.withOpacity(0.8)
                              //       );
                              //     }
                              //   },
                              //   child: Container(
                              //     height:height/18.6,
                              //     width: width/9.106,
                              //     decoration: BoxDecoration(
                              //       color: Colors.white,
                              //       borderRadius: BorderRadius.circular(8),
                              //       boxShadow: [
                              //         BoxShadow(
                              //           color: Colors.black26,
                              //           offset: Offset(1, 2),
                              //           blurRadius: 3,
                              //         ),
                              //       ],
                              //     ),
                              //     child: Padding(
                              //       padding:
                              //       EdgeInsets.symmetric(horizontal:width/227.66),
                              //       child: Center(
                              //         child: KText(
                              //           text: "Bulk Upload",
                              //           style: GoogleFonts.openSans(
                              //            fontSize:width/105.07,
                              //             fontWeight: FontWeight.bold,
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              // SizedBox(width: width/136.6),
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
                      horizontal: width/68.3,
                      vertical: height/32.55
              ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Department Name/Title *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                           fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: nameFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(leaderNameFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(leaderNameFocusNode);
                                          },
                                          key: _keyDeptName,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return '';
                                            }
                                          },
                                          onChanged: (val){
                                            _keyDeptName.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                                RegExp(r'[0-9]')),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: nameController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Department Leader Name *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                           fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: leaderNameFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(phoneFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(phoneFocusNode);
                                          },
                                          key: _keyDeptLeadName,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return '';
                                            }
                                          },
                                          onChanged: (val){
                                            _keyDeptLeadName.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                                RegExp(r'[0-9]')),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: leadernameController,
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
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Department Contact *",
                                          style: GoogleFonts.openSans(
                                            color:Colors.black,
                                           fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: phoneFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(areaFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(areaFocusNode);
                                          },
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
                                          controller: numberController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Department Area/Zone/Location *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                           fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: areaFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(descriptionFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(descriptionFocusNode);
                                          },
                                          key: _keyDeptArea,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return '';
                                            }
                                          },
                                          onChanged: (val){
                                            _keyDeptArea.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                                RegExp(r'[0-9]')),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: locationController,
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
                                    text: "Description",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                     fontSize:width/105.07,
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
                                      boxShadow: [
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
                                          height:height/32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                focusNode: descriptionFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(addressFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(addressFocusNode);
                                                },
                                                maxLength: 255,
                                                style: TextStyle(
                                                    fontSize:width/113.83),
                                                controller: descriptionController,
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(left: width/91.06,top: height/162.75,bottom: height/162.75)
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
                              SizedBox(height: height/65.1),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                     fontSize:width/105.07,
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
                                      boxShadow: [
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
                                          height:height/32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                focusNode: addressFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(cityFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(cityFocusNode);
                                                },
                                                maxLength: 40,
                                                style: TextStyle(
                                                    fontSize:width/113.83),
                                                controller: addressController,
                                                decoration: InputDecoration(
                                                  counterText: '',
                                                  border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(left: width/91.06,top: height/162.75,bottom: height/162.75)
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
                              SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width:width/6.830,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "City",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                           fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: cityFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(countryFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(countryFocusNode);
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                                RegExp(r'[0-9]')),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: cityController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/6.830,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Country",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                           fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: countryFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(postFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(postFocusNode);
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.deny(
                                                RegExp(r'[0-9]')),
                                          ],
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: countryController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width:width/68.3),
                                  SizedBox(
                                    width:width/6.830,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Postal/Zone *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                           fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: postFocusNode,
                                          autofocus: true,
                                          key: _keyzone,
                                          validator: (val){
                                            if(val!.length != 6){
                                              return 'Must be 6 digits';
                                            }else{
                                              return '';
                                            }
                                          },
                                          onChanged: (val){
                                            _keyzone.currentState!.validate();
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
                                          controller: zoneController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if(!isLoading){
                                        setState((){
                                          isLoading = true;
                                        });
                                        _keyDeptName.currentState!.validate();
                                        _keyDeptLeadName.currentState!.validate();
                                        _keyPhone.currentState!.validate();
                                        _keyDeptArea.currentState!.validate();
                                        _keyzone.currentState!.validate();

                                        if (nameController.text != "" &&
                                            leadernameController.text != "" &&
                                            zoneController.text != "" &&
                                            locationController.text != "" &&
                                            numberController.text != "") {
                                          Response response = await DepartmentFireCrud.addDepartment(
                                              name: nameController.text,
                                              leaderName: leadernameController.text,
                                              contactNumber: numberController.text,
                                              city: cityController.text,
                                              zone: zoneController.text,
                                              address: addressController.text,
                                              country: countryController.text,
                                              description: descriptionController.text,
                                              location: locationController.text
                                          );
                                          if (response.code == 200) {
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.success,
                                                text: "Department created successfully!",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants()
                                                    .primaryAppColor.withOpacity(0.8)
                                            );
                                            setState(() {
                                              currentTab = 'View';
                                              nameController.text = "";
                                              leadernameController.text = "";
                                              numberController.text = "";
                                              locationController.text = "";
                                              descriptionController.text = "";
                                              cityController.text = "";
                                              addressController.text = "";
                                              countryController.text = "";
                                              zoneController.text = "";
                                              isLoading = false;
                                            });
                                          } else {
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: "Failed to Create Department!",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants()
                                                    .primaryAppColor.withOpacity(0.8)
                                            );
                                            setState((){
                                              isLoading = false;
                                            });
                                          }
                                        } else {
                                          setState((){
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
              stream: DepartmentFireCrud.fetchDepartments(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<DepartmentModel> departments1 = snapshot.data!;
                  List<DepartmentModel> departments = [];
                  departments1.forEach((element) {
                    if(searchString != ""){
                      if(element.name!.toLowerCase().startsWith(searchString.toLowerCase())||
                          element.leaderName!.toLowerCase().startsWith(searchString.toLowerCase())||
                          element.zone!.toLowerCase().startsWith(searchString.toLowerCase())||
                          element.contactNumber!.toLowerCase().startsWith(searchString.toLowerCase())){
                        departments.add(element);
                      }
                    }else{
                      departments.add(element);
                    }
                  });
                  return Container(
                    width: width/1.241,
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
                                  text: "All Departments (${departments.length})",
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
                                          "Search by Name,Leadername,Phone,Pincode",
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
                          height: size.height * 0.7 > 110 + departments.length * 80
                              ? 100 + departments.length * 80
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
                                      generateDepartmentPdf(PdfPageFormat.letter, departments, false);
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
                                  SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () {
                                      copyToClipBoard(departments);
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
                                  SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () async {
                                      var data = await generateDepartmentPdf(PdfPageFormat.letter, departments, true);
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
                                  SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () {
                                      convertToCsv(departments);
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
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width/17.075,
                                      child: KText(
                                        text: "No.",
                                        style: GoogleFonts.poppins(
                                         fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/7.588,
                                      child: KText(
                                        text: "Department Name/Title",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/7.588,
                                      child: KText(
                                        text: "Department Leader Name",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/8.035,
                                      child: KText(
                                        text: "Department Contact",
                                        style: GoogleFonts.poppins(
                                         fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/6.830,
                                      child: KText(
                                        text: "Department Area/Zone",
                                        style: GoogleFonts.poppins(
                                         fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/9.106,
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
                              SizedBox(height: height/65.1),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: departments.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: height/10.85,
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          top: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width: width/2732,
                                          ),
                                          bottom: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width: width/2732,
                                          ),
                                        ),
                                      ),
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: width/17.075,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/7.588,
                                            child: KText(
                                              text: departments[i].name!,
                                              style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/7.588,
                                            child: KText(
                                              text: departments[i].leaderName!,
                                              style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/8.035,
                                            child: KText(
                                              text: departments[i].contactNumber!,
                                              style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/6.830,
                                            child: KText(
                                              text: departments[i].location!,
                                              style: GoogleFonts.poppins(
                                               fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:width/6.830,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      viewPopup(departments[i]);
                                                    },
                                                    child: Container(
                                                      height: height/26.04,
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                            0xff2baae4),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .black26,
                                                            offset: Offset(
                                                                1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
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
                                                                  fontWeight: FontWeight
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
                                                        nameController.text = departments[i].name!;
                                                        leadernameController.text = departments[i].leaderName!;
                                                        numberController.text = departments[i].contactNumber!;
                                                        locationController.text = departments[i].location!;
                                                        descriptionController.text = departments[i].description!;
                                                        addressController.text = departments[i].address!;
                                                        cityController.text = departments[i].city!;
                                                        countryController.text = departments[i].country!;
                                                        zoneController.text = departments[i].zone!;
                                                      });
                                                      editPopUp(departments[i],size);
                                                    },
                                                    child: Container(
                                                      height: height/26.04,
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                            0xffff9700),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .black26,
                                                            offset: Offset(
                                                                1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
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
                                                                  fontSize: width/136.6,
                                                                  fontWeight: FontWeight
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
                                                          text: "${departments[i].name} will be deleted",
                                                          title: "Delete this Record?",
                                                          width: size.width * 0.4,
                                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          showCancelBtn: true,
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                          onConfirmBtnTap: () async {
                                                            Response res = await DepartmentFireCrud.deleteRecord(id: departments[i].id!);
                                                          }
                                                      );
                                                    },
                                                    child: Container(
                                                      height: height/26.04,
                                                      decoration: BoxDecoration(
                                                        color: Color(
                                                            0xfff44236),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors
                                                                .black26,
                                                            offset: Offset(
                                                                1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment
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
                                                                text: "Delete",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: width/136.6,
                                                                  fontWeight: FontWeight
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

  viewPopup(DepartmentModel department) {
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
                    EdgeInsets.symmetric( horizontal: width/68.3, vertical: height/81.375),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          department.name!,
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
                              EdgeInsets.symmetric(horizontal:width/227.66),
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
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: SizedBox(
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
                                        fontSize: width/85.375
                                    ),
                                  ),
                                ),
                                Text(":"),
                                SizedBox(width:width/68.3),
                                KText(
                                  text: department.name!,
                                  style: TextStyle(
                                     fontSize: width/97.571
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
                                    text: "Leader Name",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: width/85.375
                                    ),
                                  ),
                                ),
                                Text(":"),
                                SizedBox(width:width/68.3),
                                KText(
                                  text: department.leaderName!,
                                  style: TextStyle(
                                     fontSize: width/97.571
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
                                    text: "Contact Number",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: width/85.375
                                    ),
                                  ),
                                ),
                                Text(":"),
                                SizedBox(width:width/68.3),
                                KText(
                                  text: department.contactNumber!,
                                  style: TextStyle(
                                     fontSize: width/97.571
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
                                    text: "Description",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: width/85.375
                                    ),
                                  ),
                                ),
                                Text(":"),
                                SizedBox(width:width/68.3),
                                SizedBox(
                                  width: size.width * 0.3,
                                  child: KText(
                                    text: department.description!,
                                    style: TextStyle(
                                       fontSize: width/97.571
                                    ),
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
                                    text: "Address",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: width/85.375
                                    ),
                                  ),
                                ),
                                Text(":"),
                                SizedBox(width:width/68.3),
                                SizedBox(
                                  width: size.width * 0.3,
                                  child: KText(
                                    text: department.address!,
                                    style: TextStyle(
                                       fontSize: width/97.571
                                    ),
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
                                    text: "Location",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: width/85.375
                                    ),
                                  ),
                                ),
                                Text(":"),
                                SizedBox(width:width/68.3),
                                SizedBox(
                                  width: size.width * 0.3,
                                  child: KText(
                                    text: department.location!,
                                    style: TextStyle(
                                       fontSize: width/97.571
                                    ),
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
                                    text: "City",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: width/85.375
                                    ),
                                  ),
                                ),
                                Text(":"),
                                SizedBox(width:width/68.3),
                                KText(
                                  text: department.city!,
                                  style: TextStyle(
                                     fontSize: width/97.571
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
                                    text: "Post/Zone",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: width/85.375
                                    ),
                                  ),
                                ),
                                Text(":"),
                                SizedBox(width:width/68.3),
                                KText(
                                  text: department.zone!,
                                  style: TextStyle(
                                     fontSize: width/97.571
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
                                    text: "Country",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800,
                                        fontSize: width/85.375
                                    ),
                                  ),
                                ),
                                Text(":"),
                                SizedBox(width:width/68.3),
                                KText(
                                  text: department.country!,
                                  style: TextStyle(
                                     fontSize: width/97.571
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height:height/32.55),
                          ],
                        ),
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

  editPopUp(DepartmentModel department, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: size.height * 1.2,
            width: double.infinity,
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
                          text: "EDIT DEPARTMENT",
                          style: GoogleFonts.openSans(
                           fontSize: width/68.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        InkWell(
                          onTap: (){
                            setState(() {
                              nameController.text = "";
                              leadernameController.text = "";
                              numberController.text = "";
                              locationController.text = "";
                              descriptionController.text = "";
                              cityController.text = "";
                              addressController.text = "";
                              countryController.text = "";
                              zoneController.text = "";
                            });
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel_outlined),
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
                  horizontal: width/68.3,
                  vertical: height/32.55
              ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Department Name/Title *",
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
                                      controller: nameController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Department Leader Name *",
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
                                      controller: leadernameController,
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
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Department Contact *",
                                      style: GoogleFonts.openSans(
                                        color:Colors.black,
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
                                      controller: numberController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                                width: width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Department Area/Zone/Location *",
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
                                      controller: locationController,
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
                                text: "Description",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                 fontSize:width/105.07,
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
                                  boxShadow: [
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
                                      height:height/32.55,
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
                                                fontSize:width/113.83),
                                            controller: descriptionController,
                                            decoration: InputDecoration(
                                              counterText: '',
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: width/91.06,top: height/162.75,bottom: height/162.75)
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
                          SizedBox(height: height/65.1),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Address *",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                 fontSize:width/105.07,
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
                                  boxShadow: [
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
                                      height:height/32.55,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            maxLength: 40,
                                            style: TextStyle(
                                                fontSize:width/113.83),
                                            controller: addressController,
                                            decoration: InputDecoration(
                                              counterText: '',
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: width/91.06,top: height/162.75,bottom: height/162.75)
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
                          SizedBox(height:height/21.7),
                          Row(
                            children: [
                              SizedBox(
                                width:width/6.830,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "City",
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
                                      controller: cityController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                                width:width/6.830,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Country *",
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
                                      controller: countryController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width:width/68.3),
                              SizedBox(
                                width:width/6.830,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Postal/Zone *",
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
                                      controller: zoneController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height/65.1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (nameController.text != "" &&
                                      leadernameController.text != "" &&
                                      locationController.text != "" &&
                                      numberController.text.length == 10 &&
                                      numberController.text != "" &&
                                      addressController.text != "" &&
                                      countryController.text != "" &&
                                      zoneController.text != "") {
                                    Response response = await DepartmentFireCrud
                                        .updateRecord(
                                      DepartmentModel(
                                        id: department.id,
                                          timestamp: department.timestamp,
                                          name: nameController.text,
                                          leaderName: leadernameController.text,
                                          contactNumber: numberController.text,
                                          city: cityController.text,
                                          zone: zoneController.text,
                                          address: addressController.text,
                                          country: countryController.text,
                                          description: descriptionController.text,
                                          location: locationController.text
                                      )
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Department updated successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor.withOpacity(0.8)
                                      );
                                      setState(() {
                                        nameController.text = "";
                                        leadernameController.text = "";
                                        numberController.text = "";
                                        locationController.text = "";
                                        descriptionController.text = "";
                                        cityController.text = "";
                                        addressController.text = "";
                                        countryController.text = "";
                                        zoneController.text = "";
                                      });
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to update Department!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor.withOpacity(0.8)
                                      );
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
                                    padding:
                                    EdgeInsets.symmetric(horizontal:width/227.66),
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

  convertToCsv(List<DepartmentModel> departments) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Name");
    row.add("Leader name");
    row.add("Phone");
    row.add("Location");
    row.add("Description");
    row.add("Address");
    row.add("City");
    row.add("Country");
    row.add("Zone");
    rows.add(row);
    for (int i = 0; i < departments.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(departments[i].name!);
      row.add(departments[i].leaderName);
      row.add(departments[i].contactNumber);
      row.add(departments[i].location);
      row.add(departments[i].description);
      row.add(departments[i].address);
      row.add(departments[i].city);
      row.add(departments[i].country);
      row.add(departments[i].zone);
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
      ..setAttribute("download", "Departments.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<DepartmentModel> departments) async  {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Name");
    row.add("    ");
    row.add("Leader name");
    row.add("    ");
    row.add("Phone");
    row.add("    ");
    row.add("Area");
    rows.add(row);
    for (int i = 0; i < departments.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add(departments[i].name);
      row.add("       ");
      row.add(departments[i].leaderName);
      row.add("       ");
      row.add(departments[i].contactNumber);
      row.add("       ");
      row.add(departments[i].zone);
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

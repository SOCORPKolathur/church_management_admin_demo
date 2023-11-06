import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:age_calculator/age_calculator.dart';
import 'package:church_management_admin/models/chorus_model.dart';
import 'package:church_management_admin/services/chorus_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:pdf/pdf.dart';
import '../../constants.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'members_tab.dart';

class RememberDaysTab extends StatefulWidget {
  const RememberDaysTab({super.key});

  @override
  State<RememberDaysTab> createState() => _RememberDaysTabState();
}

class _RememberDaysTabState extends State<RememberDaysTab> with SingleTickerProviderStateMixin {

  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController nameController = TextEditingController();
  TextEditingController memberIdController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  TextEditingController dobController = TextEditingController();
  TextEditingController dodController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController genderController = TextEditingController(text: 'Select Gender');

  TabController? _tabController;
  int currentTabIndex = 0;
  bool isLoading = false;
  bool isAltreadyMember = false;
  String currentTab = 'View';
  List<FamilyNameWithId>FamilyIdList=[];

  static final List<String> regnos = [];
  static final List<String> names = [];
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  clearTextEditingControllers(){
    setState(() {
      isAltreadyMember = false;
      nameController.text = "";
      memberIdController.text = '';
      ageController.text = "";
      dobController.text = "";
      dodController.text = "";
      descriptionController.text = "";
      genderController.text = 'Select Gender';
    });
  }

  getMemberById() async {
    var document = await cf.FirebaseFirestore.instance.collection("Members").get();
    for(int i=0;i<document.docs.length;i++){
      if(memberIdController.text == document.docs[i]["memberId"]){
        setState(() {
          nameController.text = document.docs[i]["firstName"]+" "+document.docs[i]["lastName"];
          dobController.text = document.docs[i]["dob"];
          genderController.text = document.docs[i]["gender"];
          ageController.text = (AgeCalculator.age(document.docs[i]["dob"])).years.toString();
        }
        );
      }
    }
  }
  getMemberByName() async {
    var document = await cf.FirebaseFirestore.instance.collection("Members").get();
    for(int i=0;i<document.docs.length;i++){
      if(nameController.text == document.docs[i]["firstName"]+" "+document.docs[i]["lastName"]){
        setState(() {
          memberIdController.text = document.docs[i]["memberId"];
          dobController.text = document.docs[i]["dob"];
          genderController.text = document.docs[i]["gender"];
          ageController.text = (AgeCalculator.age(DateFormat('dd-MM-yyyy').parse(document.docs[i]["dob"]))).years.toString();
        });
      }
    }
  }

  static List<String> getSuggestionsregno(String query) {
    List<String> matches = <String>[];
    matches.addAll(regnos);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
  static List<String> getSuggestionsstudent(String query) {
    List<String> matches = <String>[];
    matches.addAll(names);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  adddropdownvalue() async {
    setState(() {
      regnos.clear();
      names.clear();
    });
    var document = await  cf.FirebaseFirestore.instance.collection("Members").orderBy("timestamp").get();
    var document2 = await  cf.FirebaseFirestore.instance.collection("Members").orderBy("firstName").get();
    for(int i=0;i<document.docs.length;i++) {
      setState(() {
        regnos.add(document.docs[i]["memberId"]);
      });
    }
    for(int i=0;i<document2.docs.length;i++) {
      setState(() {
        names.add(document2.docs[i]["firstName"]+" "+document2.docs[i]["lastName"]);
      });
    }
  }

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    adddropdownvalue();
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
                    text: "Memorial Days",
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
                          clearTextEditingControllers();
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
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Memorial day" : "View Memorial days",
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
                  height: size.height * 1.25,
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
                                text: "Add Memorial Day",
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
                              Row(
                                children: [
                                  KText(
                                    text: "If Member ",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.07,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Checkbox(
                                      value: isAltreadyMember,
                                      onChanged: (val){
                                        setState(() {
                                          isAltreadyMember = val!;
                                        });
                                      }
                                  )
                                ],
                              ),
                              SizedBox(height:height/21.7),
                              isAltreadyMember ? Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:0.0),
                                        child: Text("Member Name",style: GoogleFonts.poppins(color: Colors.black,
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.bold,
                                        )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0.0,right: 25),
                                        child: Container(
                                          width: width/3.902,
                                          height: height/16.425,
                                          //color: Color(0xffDDDEEE),
                                          decoration: BoxDecoration(
                                              color:  Colors.white,
                                              borderRadius: BorderRadius.circular(5),
                                            border: Border.all(color: Colors.black26)
                                          ),

                                          child:
                                          TypeAheadFormField(
                                            suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                                                color: Color(0xffDDDEEE),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(5),
                                                  bottomRight: Radius.circular(5),
                                                )
                                            ),

                                            textFieldConfiguration: TextFieldConfiguration(
                                              style:  GoogleFonts.poppins(
                                                  fontSize: 15
                                              ),
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.only(left: 10,bottom: 8),
                                                border: InputBorder.none,
                                              ),
                                              controller: nameController,
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return getSuggestionsstudent(pattern);
                                            },
                                            itemBuilder: (context, String suggestion) {
                                              return ListTile(
                                                title: Text(suggestion),
                                              );
                                            },

                                            transitionBuilder: (context, suggestionsBox, controller) {
                                              return suggestionsBox;
                                            },
                                            onSuggestionSelected: (String suggestion) {
                                              setState(() {
                                                nameController.text = suggestion;
                                              });
                                              getMemberByName();
                                            },
                                            suggestionsBoxController: suggestionBoxController,
                                            validator: (value) =>
                                            value!.isEmpty ? 'Please select a class' : null,
                                          ),

                                        ),
                                      ),

                                    ],

                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(right:0.0),
                                        child: Text("Member ID",
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontSize:width/105.07,
                                              fontWeight: FontWeight.bold,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(left: 0.0,right: 25),
                                        child: Container(width: width/3.902,
                                          height: height/16.425,
                                          //color: Color(0xffDDDEEE),
                                          decoration: BoxDecoration(
                                              color:  Colors.white,
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(color: Colors.black26)
                                          ),child:
                                          TypeAheadFormField(
                                            suggestionsBoxDecoration: const SuggestionsBoxDecoration(
                                                color: Color(0xffDDDEEE),
                                                borderRadius: BorderRadius.only(
                                                  bottomLeft: Radius.circular(5),
                                                  bottomRight: Radius.circular(5),
                                                )
                                            ),
                                            textFieldConfiguration: TextFieldConfiguration(
                                              style:  GoogleFonts.poppins(
                                                  fontSize: 15
                                              ),
                                              decoration: const InputDecoration(
                                                contentPadding: EdgeInsets.only(left: 10,bottom: 8),
                                                border: InputBorder.none,
                                              ),
                                              controller: memberIdController,
                                            ),
                                            suggestionsCallback: (pattern) {
                                              return getSuggestionsregno(pattern);
                                            },
                                            itemBuilder: (context, String suggestion) {
                                              return ListTile(
                                                title: Text(suggestion),
                                              );
                                            },
                                            transitionBuilder: (context, suggestionsBox, controller) {
                                              return suggestionsBox;
                                            },
                                            onSuggestionSelected: (String suggestion) {
                                              setState(() {
                                                memberIdController.text = suggestion;
                                              });
                                              getMemberById();
                                            },
                                            suggestionsBoxController: suggestionBoxController,
                                            validator: (value) =>
                                            value!.isEmpty ? 'Please select a class' : null,
                                          ),

                                        ),
                                      ),

                                    ],

                                  ),
                                ],
                              ) : Row(
                                children: [
                                  SizedBox(
                                    width:width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Name ",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
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
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: nameController,
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
                                          text: "Gender ",
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
                                          text: "Age ",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          validator: (val){
                                            if(val!.isEmpty) {
                                              return 'Field is required';
                                            } else if(val.length != 10){
                                              return 'number must be 10 digits';
                                            }else{
                                              return '';
                                            }
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 3,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: ageController,
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
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly:true,
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
                                          text: "Date of Death",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly:true,
                                          style: TextStyle(fontSize:width/113.83),
                                          controller: dodController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await showDatePicker(
                                                context: context,
                                                initialDate: DateTime.now(),
                                                firstDate: DateTime(1900),
                                                lastDate: DateTime.now());
                                            if (pickedDate != null) {
                                              setState(() {
                                                dodController.text = formatter.format(pickedDate);
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
                                    height: size.height * 0.2,
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
                                                    contentPadding: EdgeInsets.only(left:width/91.06,top:height/162.75,bottom:height/162.75)
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
                                      cf.FirebaseFirestore.instance.collection('RememberDays').doc().set({

                                        "memberId" : memberIdController.text,
                                        "name": nameController.text,
                                        "gender" : genderController.text,
                                        "age" : ageController.text,
                                        "dob" : dobController.text,
                                        "dod" : dodController.text,
                                        "description" : descriptionController.text,
                                        "timestamp" : DateTime.now().millisecondsSinceEpoch,

                                      }).whenComplete((){
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: "Remember day created successfully!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                        clearTextEditingControllers();
                                      });
                                      setState(() {
                                        currentTab = 'View';
                                      });
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
              stream: cf.FirebaseFirestore.instance.collection('RememberDays').snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<cf.DocumentSnapshot> todayDays = [];
                  snapshot.data!.docs.forEach((element) {
                    if(element.get("dod") == DateFormat('dd-MM-yyyy').format(DateTime.now())){
                      todayDays.add(element);
                    }
                  });
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
                                  text: "Remember Days (${snapshot.data!.docs.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Material(
                                //   borderRadius:
                                //   BorderRadius.circular(5),
                                //   color: Colors.white,
                                //   elevation: 10,
                                //   child: SizedBox(
                                //     height: height / 18.6,
                                //     width: width / 5.106,
                                //     child: Padding(
                                //       padding: EdgeInsets.symmetric(
                                //           vertical: height / 81.375,
                                //           horizontal: width / 170.75),
                                //       child: TextField(
                                //         onChanged: (val) {
                                //           setState(() {
                                //             searchString = val;
                                //           });
                                //         },
                                //         decoration: InputDecoration(
                                //           border: InputBorder.none,
                                //           hintText:
                                //           "Search by Name,Position,Phone",
                                //           hintStyle:
                                //           GoogleFonts.openSans(
                                //             fontSize: width/97.571,
                                //           ),
                                //         ),
                                //       ),
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          height: height/10.85,
                          width: double.infinity,
                          child: TabBar(
                            onTap: (int index) {
                              setState(() {
                                currentTabIndex = index;
                              });
                            },
                            labelPadding:
                            const EdgeInsets.symmetric(horizontal: 8),
                            splashBorderRadius: BorderRadius.circular(30),
                            automaticIndicatorColorAdjustment: true,
                            dividerColor: Colors.transparent,
                            controller: _tabController,
                            indicator: BoxDecoration(
                              color: Constants().primaryAppColor,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            labelColor: Colors.black,
                            tabs: [
                              Tab(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "All Memorial Days",
                                    style: GoogleFonts.openSans(
                                      color: currentTabIndex == 0
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: width/97.57142857142857,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                              Tab(
                                child: Padding(
                                  padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                                  child: Text(
                                    "Today Memorial Days",
                                    style: GoogleFonts.openSans(
                                      color: currentTabIndex == 1
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: width/97.57142857142857,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: size.height * 0.7,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.symmetric(
                            //horizontal: width/68.3,
                              vertical: height/32.55
                          ),
                          child: currentTabIndex == 0 ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: height/217,
                                    //horizontal: width/455.33
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
                                          text: "Description",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/ 8.035,
                                        child: KText(
                                          text: "Date",
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
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (ctx, i) {
                                    var data = snapshot.data!.docs[i];
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
                                              width:width/ 8.035,
                                              child: KText(
                                                text: data.get("name"),
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/9.106,
                                              child: KText(
                                                text: data.get("description"),
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width:width/ 8.035,
                                              child: KText(
                                                text: data.get("dod"),
                                                style: GoogleFonts.poppins(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ) : Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    vertical: height/217,
                                    //horizontal: width/455.33
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
                                          text: "Description",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.07,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/ 8.035,
                                        child: KText(
                                          text: "Date",
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
                                  itemCount: todayDays.length,
                                  itemBuilder: (ctx, i) {
                                    var data = todayDays[i];
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
                                                  width:width/ 8.035,
                                                  child: KText(
                                                    text: data.get("name"),
                                                    style: GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/9.106,
                                                  child: KText(
                                                    text: data.get("description"),
                                                    style: GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width:width/ 8.035,
                                                  child: KText(
                                                    text: data.get("dod"),
                                                    style: GoogleFonts.poppins(
                                                      fontSize:width/105.07,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
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
                }
                return Container();
              },
            ) : Container()
          ],
        ),
      ),
    );
  }

}

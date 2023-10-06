import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:church_management_admin/models/speech_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart'as cf;
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../services/speech_firecrud.dart';
import '../../widgets/kText.dart';
import '../prints/speech_print.dart';
import 'package:intl/intl.dart';

class SpeechTab extends StatefulWidget {
  SpeechTab({super.key});

  @override
  State<SpeechTab> createState() => _SpeechTabState();
}

class _SpeechTabState extends State<SpeechTab> {
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController speechController = TextEditingController();
  TextEditingController facebookController = TextEditingController();
  TextEditingController twitterController = TextEditingController();
  TextEditingController googleplusController = TextEditingController();
  TextEditingController linkedinController = TextEditingController();
  TextEditingController youtubeController = TextEditingController();
  TextEditingController pinterestController = TextEditingController();
  TextEditingController instagramController = TextEditingController();
  TextEditingController whatsappController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController TimeController = TextEditingController();

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


  List<String> Usernamelist=[];
  List<String> Userphonelist=[];
  List<String> Useridlist=[];
  String dropdownvalue_userid="Select";
  String dropdownvalue_username="Select";
  String dropdownvalue_userphone="Select";
  String currentTab = 'View';

  userdataaddfunction()async{
    setState(() {
     Usernamelist.clear();
       Userphonelist.clear();
      Useridlist.clear();
    });
    setState(() {
      Usernamelist.add("Select");
      Userphonelist.add("Select");
      Useridlist.add("Select");
    });
    var userdata=await cf.FirebaseFirestore.instance.collection("Users").get();
    for(int i=0;i<userdata.docs.length;i++){
      setState(() {
        Usernamelist.add(userdata.docs[i]['firstName']);
        Userphonelist.add(userdata.docs[i]['phone']);
        Useridlist.add(userdata.docs[i]['id']);
      });
    }


  }


  userdatafetchfunction(value)async{

    var userdata = await cf.FirebaseFirestore.instance.collection("Users").get();
    for(int i=0;i<userdata.docs.length;i++){
      if(value==userdata.docs[i]['id'] ||
          value==userdata.docs[i]['firstName'].toString() ||
          value==userdata.docs[i]['phone']){
        setState(() {
          dropdownvalue_userphone=userdata.docs[i]['phone'].toString();
          lastNameController.text=userdata.docs[i]['phone'].toString();
          dropdownvalue_userid=userdata.docs[i]['id'].toString();
          positionController.text=userdata.docs[i]['id'].toString();
          dropdownvalue_username=userdata.docs[i]['firstName'].toString();
          firstNameController.text=userdata.docs[i]['firstName'].toString();
        });
      }
    }
    print("Username:$dropdownvalue_username ");
    print("Userphone:$dropdownvalue_userphone ");
    print("Userid:$dropdownvalue_userid ");


  }



  @override
  void initState() {
    userdataaddfunction();
    // TODO: implement initState
    super.initState();
  }

  final DateFormat formatter = DateFormat('dd-MM-yyyy');

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
              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "SPEECH",
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
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Speech" : "View Speeches",
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
              height: size.height * 1.2,
              width: width/1.241,
              margin: EdgeInsets.symmetric(vertical: height/32.55, horizontal: width/68.3),
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
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: "ADD SPEECH",
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
                      padding: EdgeInsets.symmetric(vertical: height/32.55, horizontal: width/68.3)
                      ,child: Column(
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
                          SizedBox( height:height/32.55),
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
                                      text: "Name *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      isExpanded: true,
                                      value: dropdownvalue_username,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      items:Usernamelist.map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (newValue1) {
                                        setState(() {
                                           dropdownvalue_username = newValue1!.toString();
                                        });
                                        userdatafetchfunction(newValue1!.toString());
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
                                      text: "Phone *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      isExpanded: true,
                                      value: dropdownvalue_userphone,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      items: Userphonelist.map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (newValue2) {

                                        setState(() {
                                          dropdownvalue_userphone= newValue2!.toString();
                                        });
                                        userdatafetchfunction(newValue2!.toString());
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
                                      text: "User-Id *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    DropdownButton(
                                      isExpanded: true,
                                      value: dropdownvalue_userid,
                                      icon: Icon(Icons.keyboard_arrow_down),
                                      items: Useridlist.map((items) {
                                        return DropdownMenuItem(
                                          value: items,
                                          child: Text(items),
                                        );
                                      }).toList(),
                                      onChanged: (newValue3) {
                                        setState(() {
                                          dropdownvalue_userid = newValue3!.toString();
                                        });
                                        userdatafetchfunction(newValue3!.toString());
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
                                      text: "Date *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000));
                                        if (pickedDate != null) {
                                          setState(() {
                                            dateController.text = formatter.format(pickedDate);
                                          });
                                        }
                                      },
                                      controller: dateController,
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
                                      text: "Time *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      onTap: () async {
                                        _selectTime(context);
                                          },
                                      controller: TimeController,
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
                                text: "Speech *",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize:width/105.07,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: height/32.55, horizontal: width/68.3)
                                ,decoration: BoxDecoration(
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
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:
                                                TextStyle(fontSize:width/113.83),
                                            controller: speechController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: width/91.066,top: height/162.75,bottom: height/162.75)
                                            ),
                                            maxLines: null,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:height/21.7),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Facebook",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: facebookController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Twitter",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: twitterController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Google+",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: googleplusController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Linkedin",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: linkedinController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height:height/21.7),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Youtube",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: youtubeController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Pinterest",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: pinterestController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Instagram",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: instagramController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Whatsapp",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: whatsappController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height:height/21.7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (profileImage != null &&
                                      firstNameController.text != "" &&
                                      lastNameController.text != "" &&
                                      positionController.text != "" &&
                                      speechController.text != ""
                                      // facebookController.text != "" &&
                                      // twitterController.text != "" &&
                                      // googleplusController.text != "" &&
                                      // linkedinController.text != "" &&
                                      // pinterestController.text != "" &&
                                      // youtubeController.text != "" &&
                                      // instagramController.text != "" &&
                                      // whatsappController.text != ""
                                  ) {
                                    Response response =
                                        await SpeechFireCrud.addSpeech(
                                      image: profileImage!,
                                      linkedin: linkedinController.text,
                                      pinterest: pinterestController.text,
                                      speech: speechController.text,
                                      twitter: twitterController.text,
                                      whatsapp: whatsappController.text,
                                      youtube: youtubeController.text,
                                      instagram: instagramController.text,
                                      google: googleplusController.text,
                                      facebook: facebookController.text,
                                      position: positionController.text,
                                      lastName: lastNameController.text,
                                      firstName: firstNameController.text,
                                            Date:dateController.text,
                                          Time: TimeController.text
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Speech created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        currentTab = 'View';
                                        uploadedImage = null;
                                        profileImage = null;
                                        linkedinController.text == "";
                                        pinterestController.text == "";
                                        speechController.text == "";
                                        twitterController.text == "";
                                        whatsappController.text == "";
                                        youtubeController.text == "";
                                        instagramController.text == "";
                                        googleplusController.text == "";
                                        facebookController.text == "";
                                        positionController.text == "";
                                        lastNameController.text == "";
                                        firstNameController.text == "";
                                        dateController.text == "";
                                        TimeController.text == "";
                                      });
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Speech!",
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
                : currentTab.toUpperCase() == "VIEW" ? StreamBuilder(
              stream: SpeechFireCrud.fetchSpeechList(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<SpeechModel> speechList = snapshot.data!;
                  return Container(
                    width: width/1.241,
                    margin: EdgeInsets.symmetric(vertical: height/32.55, horizontal: width/68.3)
                    ,decoration: BoxDecoration(
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
                                  text: "All Speeches (${speechList.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.75,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xfff5f5f5),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.symmetric(horizontal: width/34.15),
                          child: Column(
                            children: [
                              SizedBox(height:height/21.7),
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      generateSpeechPdf(PdfPageFormat.letter, speechList, false);
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
                                      copyToClipBoard(speechList);
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
                                      var data = await generateSpeechPdf(PdfPageFormat.letter, speechList, true);
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
                                      convertToCsv(speechList);
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
                              Expanded(
                                child: GridView.builder(
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisSpacing: 4.0,
                                      mainAxisSpacing: 4.0,
                                      crossAxisCount: 3,
                                      childAspectRatio: 9 / 9,
                                    ),
                                    itemCount: speechList.length,
                                    itemBuilder: (ctx, i) {
                                      SpeechModel data = speechList[i];
                                      return Padding(
                                        padding: EdgeInsets.symmetric(horizontal: width/54.64,vertical: height/81.375),
                                        child: SizedBox(
                                          child: Stack(
                                            children: [
                                              Container(
                                                padding: EdgeInsets.only(
                                                    top: height/9.3, left: width/62.09, right: width/62.09),
                                                child: Container(
                                                  color: Colors.white,
                                                  width: double.infinity,
                                                  padding:
                                                      EdgeInsets.only(top: height/9.3),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.center,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.spaceEvenly,
                                                    children: [
                                                      KText(
                                                        text: data.position!,
                                                        style: TextStyle(
                                                            color: Colors.grey,
                                                            fontSize:width/97.57),
                                                      ),
                                                      KText(
                                                        text:
                                                            "${data.firstName!} ${data.lastName!}",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: width/75.88,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: height/10.85,
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding: EdgeInsets.symmetric(
                                                            horizontal: width/170.75,
                                                            vertical: height/81.375
                                                          ),
                                                          child: KText(
                                                            text:
                                                            data.speech!,
                                                            style: TextStyle(
                                                              color: Colors.black54,
                                                              fontSize:width/105.07,
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                      Center(
                                                        child: Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            InkWell(
                                                              onTap: () {
                                                                viewPopup(speechList[i]);
                                                              },
                                                              child: Container(
                                                                height:height/26.04,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xff2baae4),
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
                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                      children: [
                                                                        Icon(
                                                                          Icons.remove_red_eye,
                                                                          color: Colors.white,
                                                                          size: width/91.06,
                                                                        ),
                                                                        KText(
                                                                          text: "View",
                                                                          style: GoogleFonts.openSans(
                                                                            color: Colors.white,
                                                                            fontSize:width/136.6,
                                                                            fontWeight: FontWeight.bold,
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
                                                                  firstNameController.text = speechList[i].firstName!;
                                                                  lastNameController.text = speechList[i].lastName!;
                                                                  positionController.text = speechList[i].position!;
                                                                  speechController.text = speechList[i].speech!;
                                                                  selectedImg = speechList[i].imgUrl;
                                                                });
                                                                editPopUp(speechList[i], size);
                                                              },
                                                              child: Container(
                                                                height:height/26.04,
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
                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                      children: [
                                                                        Icon(
                                                                          Icons.add,
                                                                          color: Colors.white,
                                                                          size: width/91.06,
                                                                        ),
                                                                        KText(
                                                                          text: "Edit",
                                                                          style: GoogleFonts.openSans(
                                                                            color: Colors.white,
                                                                            fontSize:width/136.6,
                                                                            fontWeight: FontWeight.bold,
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
                                                                    text: "${speechList[i].firstName} ${speechList[i].lastName} will be deleted",
                                                                    title: "Delete this Record?",
                                                                    width: size.width * 0.4,
                                                                    backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                                    showCancelBtn: true,
                                                                    cancelBtnText: 'Cancel',
                                                                    cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                                    onConfirmBtnTap: () async {
                                                                      Response res = await SpeechFireCrud.deleteRecord(id: speechList[i].id!);
                                                                    }
                                                                );
                                                              },
                                                              child: Container(
                                                                height:height/26.04,
                                                                decoration: BoxDecoration(
                                                                  color: Color(0xfff44236),
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
                                                                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                      children: [
                                                                        Icon(
                                                                          Icons.cancel_outlined,
                                                                          color: Colors.white,
                                                                          size: width/91.06,
                                                                        ),
                                                                        KText(
                                                                          text: "Delete",
                                                                          style: GoogleFonts.openSans(
                                                                            color: Colors.white,
                                                                            fontSize:width/136.6,
                                                                            fontWeight: FontWeight.bold,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                              ),
                                              Positioned(
                                                top: height/26.04,
                                                left: width/136.6,
                                                right: width/136.6,
                                                child: Container(
                                                  height: height/6.51,
                                                  width:width/136.60,
                                                  decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      color:
                                                          Constants().primaryAppColor,
                                                      image: data.imgUrl != null
                                                          ? DecorationImage(
                                                              fit: BoxFit.contain,
                                                              image: NetworkImage(
                                                                  data.imgUrl!))
                                                          : null),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
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

  viewPopup(SpeechModel speech) {
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
            margin: EdgeInsets.symmetric(vertical: height/32.55, horizontal: width/68.3)
            ,decoration: BoxDecoration(
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
                          speech.firstName!,
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
                                image: NetworkImage(speech.imgUrl!),
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
                                  SizedBox( height:height/32.55),
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
                                        text: "${speech.firstName!} ${speech.lastName!}",
                                        style: TextStyle(
                                            fontSize:width/97.57
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox( height:height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Position",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width:width/68.3),
                                      KText(
                                        text: speech.position!,
                                        style: TextStyle(
                                            fontSize:width/97.57
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox( height:height/32.55),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Speech",
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
                                          text: speech.speech!,
                                          style: TextStyle(
                                              fontSize:width/97.57
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox( height:height/32.55),
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

  editPopUp(SpeechModel speech, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: size.height * 1.05,
            width: width/1.241,
            margin: EdgeInsets.symmetric(vertical: height/32.55, horizontal: width/68.3)
            ,decoration: BoxDecoration(
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
                          text: "EDIT SPEECH",
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
                              firstNameController.text = "";
                              lastNameController.text = "";
                              positionController.text = "";
                              speechController.text = "";
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
                    padding: EdgeInsets.symmetric(vertical: height/32.55, horizontal: width/68.3)
                    ,child: SingleChildScrollView(
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
                          SizedBox( height:height/32.55),
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
                                      style: TextStyle(fontSize:width/113.83),
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
                                      text: "Position",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: positionController,
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
                                text: "Speech *",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize:width/105.07,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
                                margin: EdgeInsets.symmetric(vertical: height/32.55, horizontal: width/68.3)
                                ,decoration: BoxDecoration(
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
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:
                                            TextStyle(fontSize:width/113.83),
                                            controller: speechController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: 15,top: 4,bottom: 4)
                                            ),
                                            maxLines: null,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height:height/21.7),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Facebook",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: facebookController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Twitter",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: twitterController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Google+",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: googleplusController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Linkedin",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: linkedinController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height:height/21.7),
                          // Row(
                          //   children: [
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Youtube",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: youtubeController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Pinterest",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: pinterestController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Instagram",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: instagramController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //     SizedBox(width:width/68.3),
                          //     SizedBox(
                          //       width: 230,
                          //       child: Column(
                          //         crossAxisAlignment: CrossAxisAlignment.start,
                          //         children: [
                          //           KText(
                          //             text: "Whatsapp",
                          //             style: GoogleFonts.openSans(
                          //               color: Colors.black,
                          //               fontSize:width/105.07,
                          //               fontWeight: FontWeight.bold,
                          //             ),
                          //           ),
                          //           TextFormField(
                          //             style: TextStyle(fontSize:width/113.83),
                          //             controller: whatsappController,
                          //           )
                          //         ],
                          //       ),
                          //     ),
                          //   ],
                          // ),
                          // SizedBox(height:height/21.7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (
                                      firstNameController.text != "" &&
                                      lastNameController.text != "" &&
                                      positionController.text != "" &&
                                      speechController.text != ""
                                     // facebookController.text != "" &&
                                     // twitterController.text != "" &&
                                     // googleplusController.text != "" &&
                                     // linkedinController.text != "" &&
                                     // pinterestController.text != "" &&
                                     // youtubeController.text != "" &&
                                     // instagramController.text != "" &&
                                     // whatsappController.text != ""
                                  ) {
                                    Response response =
                                    await SpeechFireCrud.updateRecord(
                                      SpeechModel(
                                        id: speech.id,
                                        timestamp: speech.timestamp,
                                        linkedin: linkedinController.text,
                                        pinterest: pinterestController.text,
                                        speech: speechController.text,
                                        twitter: twitterController.text,
                                        whatsapp: whatsappController.text,
                                        youtube: youtubeController.text,
                                        instagram: instagramController.text,
                                        google: googleplusController.text,
                                        facebook: facebookController.text,
                                        position: positionController.text,
                                        lastName: lastNameController.text,
                                        firstName: firstNameController.text,
                                      ),
                                        profileImage,
                                        speech.imgUrl ?? ""
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Speech updated successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        uploadedImage = null;
                                        profileImage = null;
                                        linkedinController.text == "";
                                        pinterestController.text == "";
                                        speechController.text == "";
                                        twitterController.text == "";
                                        whatsappController.text == "";
                                        youtubeController.text == "";
                                        instagramController.text == "";
                                        googleplusController.text == "";
                                        facebookController.text == "";
                                        positionController.text == "";
                                        lastNameController.text == "";
                                        firstNameController.text == "";
                                      });
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to update Speech!",
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
      },
    );
  }

  convertToCsv(List<SpeechModel> speeches) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Name");
    row.add("Position");
    row.add("Speech");
    rows.add(row);
    for (int i = 0; i < speeches.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("${speeches[i].firstName!} ${speeches[i].lastName!}");
      row.add(speeches[i].position);
      row.add(speeches[i].speech);
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
      ..setAttribute("download", "Speeches.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<SpeechModel> speeches) async  {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Name");
    row.add("    ");
    row.add("Position");
    row.add("    ");
    row.add("Speech");
    rows.add(row);
    for (int i = 0; i < speeches.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add("${speeches[i].firstName} ${speeches[i].lastName}");
      row.add("       ");
      row.add(speeches[i].position);
      row.add("       ");
      row.add(speeches[i].speech);
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


    TimeOfDay _selectedTime = TimeOfDay.now();

    Future<void> _selectTime(BuildContext context) async {
      TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: _selectedTime,
      );

      if (picked != null && picked != _selectedTime)
        setState(() {
          _selectedTime = picked;
          TimeController.text = picked.toString();
        });
      _formatTime(picked!);
    }


  String _formatTime(TimeOfDay time) {
    int hour = time.hourOfPeriod;
    int minute = time.minute;
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    setState(() {
      TimeController.text ='${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    });

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }


}

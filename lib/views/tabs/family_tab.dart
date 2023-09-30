import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';

import 'package:church_management_admin/models/family_model.dart';
import 'package:church_management_admin/services/family_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;

import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';

class FamilyTab extends StatefulWidget {
   FamilyTab({super.key});

  @override
  State<FamilyTab> createState() => _FamilyTabState();
}

class _FamilyTabState extends State<FamilyTab> {

  TextEditingController familynameController = TextEditingController();
  TextEditingController familyleadernameController = TextEditingController();
  TextEditingController familynumberController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController countryController = TextEditingController();
  TextEditingController zoneController = TextEditingController();
  TextEditingController familyIdController = TextEditingController();
  int familyQuanity = 0;

  TextEditingController filterTextController = TextEditingController();
  String filterText = "";

  setFamilyId() async {
    var document = await cf.FirebaseFirestore.instance.collection('Families').get();
    int lastId = document.docs.length + 1;
    String familyId = lastId.toString();
    for(int i = 0; i < 5; i++) {
      if(familyId.length < 7){
        familyId = "0$familyId";
      }
    }
    setState((){
      familyIdController.text = familyId;
    });
  }

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

  @override
  void initState() {
    setFamilyId();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding:  EdgeInsets.symmetric(vertical: height/81.375,horizontal: width/170.75),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
            padding:  EdgeInsets.symmetric(vertical: height/81.375,horizontal: width/170.75),
              child: KText(
                text: "FAMILIES",
                style: GoogleFonts.openSans(
                    fontSize: width/52.538,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            Container(
              height: size.height * 1.4,
              width: double.infinity,
              margin:  EdgeInsets.symmetric(
                horizontal: width/68.3,vertical: height/32.55
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
                        children: [
                           Icon(Icons.group),
                           SizedBox(width:width/136.6),
                          KText(
                            text: "ADD FAMILY",
                            style: GoogleFonts.openSans(
                              fontSize:width/68.3,
                              fontWeight: FontWeight.bold,
                            ),
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
                      padding:  EdgeInsets.symmetric(horizontal: width/68.5,vertical: height/32.5),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height:height/3.829,
                              width: width/3.902,
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
                                  size: width/8.537,
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
                                        text: 'Select Family Leader Photo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                               SizedBox(width: width/27.32),
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
                                      text: "Family ID",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: familyIdController,
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
                                      text: "Family Name/Title",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: familynameController,
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
                                      text: "Family Leader Name",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: familyleadernameController,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    KText(
                                      text: "Family Members Count",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                         SizedBox(width:width/68.3),
                                        Text(
                                          familyQuanity.toString(),
                                          style:  TextStyle(
                                            fontSize:width/68.3,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  familyQuanity++;
                                                });
                                              },
                                              child: Container(
                                                height:height/21.7,
                                                width:width/68.3,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    boxShadow:  [
                                                      BoxShadow(
                                                          color:
                                                              Color(0xffc0c0c1),
                                                          offset: Offset(2, 3),
                                                          blurRadius: 3)
                                                    ]),
                                                child:  Center(
                                                  child:
                                                      Icon(Icons.arrow_drop_up),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (familyQuanity >= 1) {
                                                  setState(() {
                                                    familyQuanity--;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height:height/21.7,
                                                width:width/68.3,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    boxShadow:  [
                                                      BoxShadow(
                                                          color:
                                                              Color(0xffc0c0c1),
                                                          offset: Offset(2, 3),
                                                          blurRadius: 3)
                                                    ]),
                                                child:  Center(
                                                  child: Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
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
                                      text: "Family Contact Number",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/97.57,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: familynumberController,
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
                                      text: "Family Email",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/97.57,
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
                                margin:  EdgeInsets.symmetric(
                                  vertical: height/32.55,
                                  horizontal: width/68.3
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          maxLines: null,
                                            style:  TextStyle(fontSize:width/113.83),
                                            controller: addressController,
                                          decoration:  InputDecoration(
                                            border: InputBorder.none,
                                            contentPadding: EdgeInsets.only(left: width/91.06,top: height/162.75,bottom: height/162.75)
                                          ),
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
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
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
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
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
                                      text: "Postal/Zone",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: zoneController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (profileImage != null &&
                                      familynameController.text != "" &&
                                      familyleadernameController.text != "" &&
                                      familynumberController.text != "" &&
                                      familyIdController.text != "" &&
                                      emailController.text != "" &&
                                      familyQuanity != 0 &&
                                      cityController.text != "" &&
                                      addressController.text != "" &&
                                      countryController.text != "" &&
                                      zoneController.text != "") {
                                    Response response =  await FamilyFireCrud.addFamily(
                                        image: profileImage!,
                                      familyId: familyIdController.text,
                                      name: familynameController.text,
                                      email: emailController.text,
                                      leaderName: familyleadernameController.text,
                                      contactNumber: familynumberController.text,
                                     city: cityController.text,
                                     zone: zoneController.text,
                                     address: addressController.text,
                                     country: countryController.text,
                                     quantity: familyQuanity
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Family created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8)
                                      );
                                      setFamilyId();
                                      setState(() {
                                        uploadedImage = null;
                                        profileImage = null;
                                        familynameController.text = "";
                                            familyleadernameController.text = "";
                                            familynumberController.text = "";
                                            familyQuanity = 0;
                                            cityController.text = "";
                                            emailController.text = "";
                                            addressController.text = "";
                                            countryController.text = "";
                                            zoneController.text = "";
                                      });
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Family!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8)
                                      );
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
                                    padding:
                                     EdgeInsets.symmetric(horizontal:width/227.66),
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
            filterText != "" ? StreamBuilder(
              stream: FamilyFireCrud.fetchFamiliesWithFilter(filterText),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<FamilyModel> families = snapshot.data!;
                  return Container(
                    width: 1100,
                    margin:  EdgeInsets.symmetric(
                                  vertical: height/32.55,
                                  horizontal: width/68.3
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
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "ALL Families (${families.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      filterText = "";
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
                                          text: "Clear Filter",
                                          style: GoogleFonts.openSans(
                                            fontSize:width/105.076,
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
                        Container(
                          height: size.height * 0.7 > 70 + families.length * 60 ? 70 + families.length * 60 : size.height * 0.7,
                          width: double.infinity,
                          decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                           padding:  EdgeInsets.symmetric(horizontal: width/68.5,vertical: height/32.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding:  EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Family Name/Title",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Family Leader Name",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child: KText(
                                          text: "Family Quantity",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/68.30,
                                        child: KText(
                                          text: "Contact Number",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
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
                               SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: families.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: 60,
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
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: families[i].name!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: families[i].leaderName!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 170,
                                            child: KText(
                                              text: families[i].quantity!.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/68.30,
                                            child: KText(
                                              text: families[i].contactNumber!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:width/68.30,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      viewPopup(families[i]);
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:  BoxDecoration(
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
                                                        padding:  EdgeInsets.symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                               Icon(
                                                                Icons.remove_red_eye,
                                                                color: Colors.white,
                                                                size: 15,
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
                                                   SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        familynameController.text = families[i].name!;
                                                        familyleadernameController.text = families[i].leaderName!;
                                                        familyQuanity = families[i].quantity!;
                                                        familynumberController.text = families[i].contactNumber!;
                                                        addressController.text = families[i].address!;
                                                        cityController.text = families[i].city!;
                                                        emailController.text = families[i].email!;
                                                        countryController.text = families[i].country!;
                                                        zoneController.text = families[i].zone!;
                                                        familyIdController.text = families[i].familyId!;
                                                      });
                                                      editPopUp(families[i],size);
                                                    },
                                                    child: Container(
                                                      height: 25,
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
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                               Icon(
                                                                Icons.add,
                                                                color: Colors.white,
                                                                size: 15,
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
                                                   SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.info,
                                                          text: "${families[i].name} will be deleted",
                                                          title: "Delete this Record?",
                                                          width: size.width * 0.4,
                                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          showCancelBtn: true,
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                          onConfirmBtnTap: () async {
                                                            Response res = await FamilyFireCrud.deleteRecord(id: families[i].id!);
                                                          }
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:  BoxDecoration(
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
                                                        padding:  EdgeInsets.symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                               Icon(
                                                                Icons.cancel_outlined,
                                                                color: Colors.white,
                                                                size: 15,
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
            ) : StreamBuilder(
              stream: FamilyFireCrud.fetchFamilies(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<FamilyModel> families = snapshot.data!;
                  return Container(
                    width: 1100,
                    margin:  EdgeInsets.symmetric(
                                  vertical: height/32.55,
                                  horizontal: width/68.3
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
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "ALL Families (${families.length})",
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
                                        width: 150,
                                        child: Padding(
                                        padding:  EdgeInsets.symmetric(vertical: height/81.375,horizontal: width/170.75),
                                          child: TextField(
                                            controller: filterTextController,
                                            onSubmitted: (val){
                                              setState(() {
                                                filterText = val;
                                              });
                                            },
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: "Filter Postal code",
                                              hintStyle: GoogleFonts.openSans(
                                                fontSize:width/97.57,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                     SizedBox(width: 5),
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
                          height: size.height * 0.7 > 70 + families.length * 60 ? 70 + families.length * 60 : size.height * 0.7,
                          width: double.infinity,
                          decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                           padding:  EdgeInsets.symmetric(horizontal: width/68.5,vertical: height/32.5),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding:  EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 80,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Family Name/Title",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Family Leader Name",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/113.83,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 170,
                                        child: KText(
                                          text: "Family Quantity",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width:width/68.30,
                                        child: KText(
                                          text: "Contact Number",
                                          style: GoogleFonts.poppins(
                                            fontSize:width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
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
                               SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: families.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: 60,
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
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: families[i].name!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: families[i].leaderName!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 170,
                                            child: KText(
                                              text: families[i].quantity!.toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/68.30,
                                            child: KText(
                                              text: families[i].contactNumber!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:width/68.30,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      viewPopup(families[i]);
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:  BoxDecoration(
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
                                                        padding:  EdgeInsets.symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                               Icon(
                                                                Icons.remove_red_eye,
                                                                color: Colors.white,
                                                                size: 15,
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
                                                   SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        familynameController.text = families[i].name!;
                                                        familyleadernameController.text = families[i].leaderName!;
                                                        familyQuanity = families[i].quantity!;
                                                        familynumberController.text = families[i].contactNumber!;
                                                        addressController.text = families[i].address!;
                                                        cityController.text = families[i].city!;
                                                        emailController.text = families[i].email!;
                                                        countryController.text = families[i].country!;
                                                        zoneController.text = families[i].zone!;
                                                        familyIdController.text = families[i].familyId!;
                                                      });
                                                      editPopUp(families[i],size);
                                                    },
                                                    child: Container(
                                                      height: 25,
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
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                               Icon(
                                                                Icons.add,
                                                                color: Colors.white,
                                                                size: 15,
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
                                                   SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.info,
                                                          text: "${families[i].name} will be deleted",
                                                          title: "Delete this Record?",
                                                          width: size.width * 0.4,
                                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          showCancelBtn: true,
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                          onConfirmBtnTap: () async {
                                                            Response res = await FamilyFireCrud.deleteRecord(id: families[i].id!);
                                                          }
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:  BoxDecoration(
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
                                                        padding:  EdgeInsets.symmetric(
                                                            horizontal:width/227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                               Icon(
                                                                Icons.cancel_outlined,
                                                                color: Colors.white,
                                                                size: 15,
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
            )
          ],
        ),
      ),
    );
  }

  viewPopup(FamilyModel family) {
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
                                  vertical: height/32.55,
                                  horizontal: width/68.3
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
                     EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          family.name!,
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
                    child: SizedBox(
                      width: double.infinity,
                      child: Padding(
                        padding:  EdgeInsets.symmetric(
                            horizontal: 10, vertical: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                width: size.width * 0.3,
                                height: size.height * 0.4,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image: NetworkImage(family.leaderImgUrl!),
                                  ),
                                ),
                              ),
                               SizedBox(height:height/32.55),
                              Row(
                                children: [
                                  SizedBox(
                                    width: size.width * 0.15,
                                    child:  KText(
                                      text: "Family ID",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.familyId!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
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
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.name!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
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
                                      text: "Email",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.email!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
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
                                      text: "Leader Name",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.leaderName!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
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
                                      text: "Family members count",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.quantity!.toString(),
                                    style:  TextStyle(
                                        fontSize:width/97.57
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
                                    child:  KText(
                                      text: "Contact Number",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.contactNumber!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
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
                                    child:  KText(
                                      text: "Address",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  SizedBox(
                                    width: size.width * 0.3,
                                    child: KText(
                                      text: family.address!,
                                      style:  TextStyle(
                                          fontSize:width/97.57
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
                                    child:  KText(
                                      text: "City",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.city!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
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
                                    child:  KText(
                                      text: "Post/Zone",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.zone!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
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
                                    child:  KText(
                                      text: "Country",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w800,
                                          fontSize: 16
                                      ),
                                    ),
                                  ),
                                   Text(":"),
                                   SizedBox(width:width/68.3),
                                  KText(
                                    text: family.country!,
                                    style:  TextStyle(
                                        fontSize:width/97.57
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
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  editPopUp(FamilyModel family, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: size.height * 0.95,
            width: double.infinity,
            margin:  EdgeInsets.symmetric(
                                  vertical: height/32.55,
                                  horizontal: width/68.3
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
                        horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                         Icon(Icons.group),
                         SizedBox(width:width/136.6),
                        KText(
                          text: "EDIT FAMILY",
                          style: GoogleFonts.openSans(
                            fontSize:width/68.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                         Expanded(child: SizedBox()),
                        InkWell(
                          onTap: (){
                            setState(() {
                              uploadedImage = null;
                              profileImage = null;
                              familynameController.text = "";
                              familyleadernameController.text = "";
                              familynumberController.text = "";
                              familyQuanity = 0;
                              cityController.text = "";
                              emailController.text = "";
                              addressController.text = "";
                              countryController.text = "";
                              zoneController.text = "";
                            });
                            Navigator.pop(context);
                          },
                          child:  Icon(Icons.cancel_outlined),
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
                    padding:  EdgeInsets.symmetric(vertical: height/32.55,horizontal: width/68.3),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width:width/4.553,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Family ID",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      readOnly: true,
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: familyIdController,
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
                                      text: "Family Name/Title",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: familynameController,
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
                                      text: "Family Leader Name",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: familyleadernameController,
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    KText(
                                      text: "Family Members Quantity",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                         SizedBox(width:width/68.3),
                                        Text(
                                          familyQuanity.toString(),
                                          style:  TextStyle(
                                            fontSize:width/68.3,
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            InkWell(
                                              onTap: () {
                                                setState(() {
                                                  familyQuanity++;
                                                });
                                              },
                                              child: Container(
                                                height:height/21.7,
                                                width:width/68.3,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5),
                                                    boxShadow:  [
                                                      BoxShadow(
                                                          color:
                                                          Color(0xffc0c0c1),
                                                          offset: Offset(2, 3),
                                                          blurRadius: 3)
                                                    ]),
                                                child:  Center(
                                                  child:
                                                  Icon(Icons.arrow_drop_up),
                                                ),
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                if (familyQuanity >= 1) {
                                                  setState(() {
                                                    familyQuanity--;
                                                  });
                                                }
                                              },
                                              child: Container(
                                                height:height/21.7,
                                                width:width/68.3,
                                                decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        5),
                                                    boxShadow:  [
                                                      BoxShadow(
                                                          color:
                                                          Color(0xffc0c0c1),
                                                          offset: Offset(2, 3),
                                                          blurRadius: 3)
                                                    ]),
                                                child:  Center(
                                                  child: Icon(
                                                      Icons.arrow_drop_down),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
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
                                      text: "Family Contact Number",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/97.57,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: familynumberController,
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
                                      text: "Family Email",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/97.57,
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
                                margin:  EdgeInsets.symmetric(
                                  vertical: height/32.55,
                                  horizontal: width/68.3
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
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                            maxLines: null,
                                            style:  TextStyle(fontSize:width/113.83),
                                            controller: addressController,
                                            decoration:  InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: 15,top: 4,bottom: 4)
                                            ),
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
                                width:width/68.30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "City",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style:  TextStyle(fontSize:width/113.83),
                                      controller: cityController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width:width/68.3),
                              SizedBox(
                                width:width/68.30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Country",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: countryController,
                                    )
                                  ],
                                ),
                              ),
                               SizedBox(width:width/68.3),
                              SizedBox(
                                width:width/68.30,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Postal/Zone",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.076,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize:width/113.83),
                                      controller: zoneController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (familynameController.text != "" &&
                                      familyleadernameController.text != "" &&
                                      familyIdController.text != "" &&
                                      familynumberController.text != "" &&
                                      familyQuanity != 0 &&
                                      cityController.text != "" &&
                                      addressController.text != "" &&
                                      emailController.text != "" &&
                                      countryController.text != "" &&
                                      zoneController.text != "") {
                                    Response response =  await FamilyFireCrud.updateRecord(
                                        FamilyModel(
                                          id: family.id,
                                            timestamp: family.timestamp,
                                            familyId: family.familyId,
                                            name: familynameController.text,
                                            leaderName: familyleadernameController.text,
                                            contactNumber: familynumberController.text,
                                            city: cityController.text,
                                            email: emailController.text,
                                            zone: zoneController.text,
                                            address: addressController.text,
                                            country: countryController.text,
                                            quantity: familyQuanity
                                        ),
                                        profileImage,
                                        family.leaderImgUrl ?? ""
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Family updated successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8)
                                      );
                                      setState(() {
                                        uploadedImage = null;
                                        profileImage = null;
                                        familynameController.text = "";
                                        familyleadernameController.text = "";
                                        familynumberController.text = "";
                                        familyQuanity = 0;
                                        cityController.text = "";
                                        emailController.text = "";
                                        addressController.text = "";
                                        countryController.text = "";
                                        zoneController.text = "";
                                      });
                                      setFamilyId();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to update Family!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8)
                                      );
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
                                    padding:
                                     EdgeInsets.symmetric(horizontal:width/227.66),
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

import 'dart:convert';
import 'dart:html';
import 'dart:math';
import 'dart:typed_data';
import 'package:church_management_admin/models/asset_management_model.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../services/asset_management_firecrud.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';

class AssetManagementTab extends StatefulWidget {
  const AssetManagementTab({super.key});

  @override
  State<AssetManagementTab> createState() => _AssetManagementTabState();
}

class _AssetManagementTabState extends State<AssetManagementTab> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController amcDateController = TextEditingController();
  TextEditingController approxValueController = TextEditingController();
  TextEditingController verifierController = TextEditingController();
  TextEditingController assetsController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime selectedAMCDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');

  DateTime? dateRangeStart;
  DateTime? dateRangeEnd;
  String? amcDateRange;
  bool isFiltered= false;
  File? profileImage;
  File? documentForUpload;
  var uploadedImage;
  String? selectedImg;
  String docname = "";

  String currentTab = 'View';

  setDateTime() async {
    setState(() {
      dateController.text = formatter.format(selectedDate);
    });
  }

  setAMCDateTime() async {
    setState(() {
      amcDateController.text = formatter.format(selectedDate);
    });
  }

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


  @override
  void initState() {
    setDateTime();
    setAMCDateTime();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "ASSET MANAGEMENT",
                    style: GoogleFonts.openSans(
                        fontSize: 26,
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
                        height: 35,
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
                          const EdgeInsets.symmetric(horizontal: 6),
                          child: Center(
                            child: KText(
                              text: currentTab.toUpperCase() == "VIEW" ? "Add New Record" : "View Records",
                              style: GoogleFonts.openSans(
                                fontSize: 13,
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
              width: double.infinity,
              margin: const EdgeInsets.all(20),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          const Icon(Icons.attach_money_outlined),
                          const SizedBox(width: 10),
                          KText(
                            text: "ADD NEW RECORD",
                            style: GoogleFonts.openSans(
                              fontSize: 20,
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
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: 170,
                              width: 350,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Constants().primaryAppColor,
                                      width: 2),
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
                                  ? const Center(
                                child: Icon(
                                  Icons.cloud_upload,
                                  size: 160,
                                  color: Colors.grey,
                                ),
                              ) : null,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              InkWell(
                                onTap: selectImage,
                                child: Container(
                                  height: 35,
                                  width: size.width * 0.23,
                                  color: Constants().primaryAppColor,
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          color: Colors.white),
                                      SizedBox(width: 10),
                                      KText(
                                        text: 'Select Profile Photo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: 35,
                                width: size.width * 0.23,
                                color: Constants().primaryAppColor,
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.crop,
                                      color: Colors.white,
                                    ),
                                    SizedBox(width: 10),
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
                                  height: 35,
                                  width: size.width * 0.23,
                                  color: Constants().primaryAppColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(Icons.file_copy,
                                          color: Colors.white),
                                      const SizedBox(width: 10),
                                      KText(
                                        text: docname == "" ? 'Select Document' : docname,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 230,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: dateController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 230,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Assets",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: assetsController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 230,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Approximate Value",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: approxValueController,
                                    )
                                  ],
                                ),
                              ),
                              const SizedBox(width: 20),
                              SizedBox(
                                width: 230,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Verifier",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: const TextStyle(fontSize: 12),
                                      controller: verifierController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Row(
                            children: [
                              SizedBox(
                                width: 230,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "AMC Date",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000));
                                        if (pickedDate != null) {
                                          setState(() {
                                            amcDateController.text = formatter.format(pickedDate);
                                          });
                                        }
                                      },
                                      style: const TextStyle(fontSize: 12),
                                      controller: amcDateController,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Note/Description",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.16,
                                width: double.infinity,
                                margin: const EdgeInsets.all(20),
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
                                    const SizedBox(
                                      height: 20,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            maxLines: null,
                                            style:
                                                const TextStyle(fontSize: 12),
                                            controller: descriptionController,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: 15,top: 4,bottom: 4)
                                            ),
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (assetsController.text != "" &&
                                      verifierController.text != "" &&
                                      descriptionController.text != "" &&
                                      approxValueController.text != "" &&
                                      amcDateController.text != "" &&
                                      dateController.text != "") {
                                    Response response =
                                        await AssetManagementFireCrud
                                            .addAssetManagement(
                                          amcDate: amcDateController.text,
                                      document: documentForUpload!,
                                      image: profileImage!,
                                      description: descriptionController.text,
                                      date: dateController.text,
                                      verifier: verifierController.text,
                                      approxValue: approxValueController.text,
                                      assets: assetsController.text,
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Asset created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        currentTab = 'View';
                                        approxValueController.text = "";
                                        verifierController.text = "";
                                        assetsController.text = "";
                                        descriptionController.text = "";
                                        uploadedImage = null;
                                        profileImage = null;
                                        docname = "";
                                        documentForUpload = null;
                                      });
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Asset!",
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
                                  height: 35,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
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
            )
                : currentTab.toUpperCase() == "VIEW" ? amcDateRange != null ? StreamBuilder(
              stream: AssetManagementFireCrud.fetchAssetManagementsWithAmcDate(amcDateRange!),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<AssetManagementModel> assets = snapshot.data!;
                  return Container(
                    width: 1100,
                    margin: const EdgeInsets.all(20),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "Recent Records (${assets.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isFiltered = false;
                                      amcDateRange = null;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
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
                                      const EdgeInsets.symmetric(horizontal: 6),
                                      child: Center(
                                        child: KText(
                                          text: "Clear Filter",
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
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
                        Container(
                          height: size.height * 0.7 > 70 + assets.length * 60
                              ? 70 + assets.length * 60
                              : size.height * 0.7,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: KText(
                                          text: "SL.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: KText(
                                          text: "Date",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: KText(
                                          text: "AMC Date",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: KText(
                                          text: "Assets",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Approximate Value",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Note",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: assets.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
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
                                            width: 50,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: KText(
                                              text: assets[i].date!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: KText(
                                              text: assets[i].amcDate!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: KText(
                                              text: assets[i].assets!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: assets[i].approxValue!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: assets[i].description!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: 180,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        dateController.text = assets[i].date!;
                                                        assetsController.text = assets[i].assets!;
                                                        approxValueController.text = assets[i].approxValue!;
                                                        verifierController.text = assets[i].verifier!;
                                                        descriptionController.text = assets[i].description!;
                                                      });
                                                      editPopUp(assets[i],size);
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:
                                                      const BoxDecoration(
                                                        color:
                                                        Color(0xffff9700),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Colors.black26,
                                                            offset:
                                                            Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 6),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                              KText(
                                                                text: "Edit",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
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
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.info,
                                                          text: "${assets[i].assets} will be deleted",
                                                          title: "Delete this Record?",
                                                          width: size.width * 0.4,
                                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          showCancelBtn: true,
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                          onConfirmBtnTap: () async {
                                                            Response res = await AssetManagementFireCrud.deleteRecord(id: assets[i].id!);
                                                          }
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:
                                                      const BoxDecoration(
                                                        color:
                                                        Color(0xfff44236),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Colors.black26,
                                                            offset:
                                                            Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 6),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                              KText(
                                                                text: "Delete",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
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
            ) : dateRangeStart != null ? StreamBuilder(
              stream: AssetManagementFireCrud.fetchAssetManagementsWithFilter(dateRangeStart!,dateRangeEnd!),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<AssetManagementModel> assets = snapshot.data!;
                  return Container(
                    width: 1100,
                    margin: const EdgeInsets.all(20),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "Recent Records (${assets.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isFiltered = false;
                                      dateRangeStart = null;
                                      dateRangeEnd = null;
                                    });
                                  },
                                  child: Container(
                                    height: 40,
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
                                      const EdgeInsets.symmetric(horizontal: 6),
                                      child: Center(
                                        child: KText(
                                          text: "Clear Filter",
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
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
                        Container(
                          height: size.height * 0.7 > 70 + assets.length * 60
                              ? 70 + assets.length * 60
                              : size.height * 0.7,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: KText(
                                          text: "SL.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: KText(
                                          text: "Date",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: KText(
                                          text: "AMC Date",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: KText(
                                          text: "Assets",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Approximate Value",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Note",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: assets.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
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
                                            width: 50,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: KText(
                                              text: assets[i].date!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: KText(
                                              text: assets[i].amcDate!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: KText(
                                              text: assets[i].assets!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: assets[i].approxValue!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: assets[i].description!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: 180,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        dateController.text = assets[i].date!;
                                                        assetsController.text = assets[i].assets!;
                                                        approxValueController.text = assets[i].approxValue!;
                                                        verifierController.text = assets[i].verifier!;
                                                        descriptionController.text = assets[i].description!;
                                                      });
                                                      editPopUp(assets[i],size);
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xffff9700),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black26,
                                                            offset:
                                                                Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 6),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                              KText(
                                                                text: "Edit",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
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
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.info,
                                                          text: "${assets[i].assets} will be deleted",
                                                          title: "Delete this Record?",
                                                          width: size.width * 0.4,
                                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          showCancelBtn: true,
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                          onConfirmBtnTap: () async {
                                                            Response res = await AssetManagementFireCrud.deleteRecord(id: assets[i].id!);
                                                          }
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:
                                                          const BoxDecoration(
                                                        color:
                                                            Color(0xfff44236),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                                Colors.black26,
                                                            offset:
                                                                Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .symmetric(
                                                                horizontal: 6),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .spaceAround,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                              KText(
                                                                text: "Delete",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
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
              stream: AssetManagementFireCrud.fetchAssetManagements(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<AssetManagementModel> assets = snapshot.data!;
                  return Container(
                    width: 1100,
                    margin: const EdgeInsets.all(20),
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
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "Recent Records (${assets.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    var result = await filterPopUp();
                                    if(result){
                                      setState(() {
                                        isFiltered = true;
                                      });
                                    }
                                  },
                                  child: Container(
                                    height: 40,
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
                                      const EdgeInsets.symmetric(horizontal: 6),
                                      child: Center(
                                        child: KText(
                                          text: "Filter",
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
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
                        Container(
                          height: size.height * 0.7 > 70 + assets.length * 60
                              ? 70 + assets.length * 60
                              : size.height * 0.7,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(0.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 50,
                                        child: KText(
                                          text: "SL.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: KText(
                                          text: "Date",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 120,
                                        child: KText(
                                          text: "AMC Date",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: KText(
                                          text: "Assets",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Approximate Value",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Note",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 180,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: assets.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: 60,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
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
                                            width: 50,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: KText(
                                              text: assets[i].date!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 120,
                                            child: KText(
                                              text: assets[i].amcDate!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: KText(
                                              text: assets[i].assets!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: assets[i].approxValue!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: assets[i].description!,
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: 180,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      viewPopup(assets[i]);
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:
                                                      const BoxDecoration(
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
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal:
                                                            6),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .remove_red_eye,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                              KText(
                                                                text: "View",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:
                                                                  10,
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
                                                  const SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        dateController.text = assets[i].date!;
                                                        assetsController.text = assets[i].assets!;
                                                        approxValueController.text = assets[i].approxValue!;
                                                        verifierController.text = assets[i].verifier!;
                                                        descriptionController.text = assets[i].description!;
                                                      });
                                                      editPopUp(assets[i],size);
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:
                                                      const BoxDecoration(
                                                        color:
                                                        Color(0xffff9700),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Colors.black26,
                                                            offset:
                                                            Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 6),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              const Icon(
                                                                Icons.add,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                              KText(
                                                                text: "Edit",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
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
                                                  const SizedBox(width: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.info,
                                                          text: "${assets[i].assets} will be deleted",
                                                          title: "Delete this Record?",
                                                          width: size.width * 0.4,
                                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          showCancelBtn: true,
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                          onConfirmBtnTap: () async {
                                                            Response res = await AssetManagementFireCrud.deleteRecord(id: assets[i].id!);
                                                          }
                                                      );
                                                    },
                                                    child: Container(
                                                      height: 25,
                                                      decoration:
                                                      const BoxDecoration(
                                                        color:
                                                        Color(0xfff44236),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color:
                                                            Colors.black26,
                                                            offset:
                                                            Offset(1, 2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                        const EdgeInsets
                                                            .symmetric(
                                                            horizontal: 6),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                            children: [
                                                              const Icon(
                                                                Icons
                                                                    .cancel_outlined,
                                                                color: Colors
                                                                    .white,
                                                                size: 15,
                                                              ),
                                                              KText(
                                                                text: "Delete",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 10,
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

  editPopUp(AssetManagementModel asset, Size size) {
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: size.height * 0.62,
            width: double.infinity,
            margin: const EdgeInsets.all(20),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 8),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_money_outlined),
                        const SizedBox(width: 10),
                        KText(
                          text: "EDIT RECORD",
                          style: GoogleFonts.openSans(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          onTap: () {
                            setState(() {
                              approxValueController.text = "";
                              verifierController.text = "";
                              assetsController.text = "";
                              descriptionController.text = "";
                              dateController.text = formatter.format(DateTime.now());
                            });
                            Navigator.pop(context);
                          },
                          child: const Icon(Icons.cancel_outlined),
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
                        )),
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 230,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Date",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 12),
                                    controller: dateController,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 230,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Assets",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 12),
                                    controller: assetsController,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 230,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Approximate Value",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 12),
                                    controller: approxValueController,
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            SizedBox(
                              width: 230,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Verifier",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 12),
                                    controller: verifierController,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            KText(
                              text: "Note/Description",
                              style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              height: size.height * 0.16,
                              width: double.infinity,
                              margin: const EdgeInsets.all(20),
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
                                  const SizedBox(
                                    height: 20,
                                    width: double.infinity,
                                  ),
                                  Expanded(
                                    child: Container(
                                        width: double.infinity,
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                        ),
                                        child: TextFormField(
                                          maxLines: null,
                                          style:
                                          const TextStyle(fontSize: 12),
                                          controller: descriptionController,
                                          decoration: const InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(left: 15,top: 4,bottom: 4)
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                setState(() {
                                  approxValueController.text = "";
                                  verifierController.text = "";
                                  assetsController.text = "";
                                  descriptionController.text = "";
                                  dateController.text = formatter.format(DateTime.now());
                                });
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Constants().primaryAppColor,
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
                                  const EdgeInsets.symmetric(horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "Cancel",
                                      style: GoogleFonts.openSans(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 20),
                            InkWell(
                              onTap: () async {
                                if (assetsController.text != "" &&
                                    verifierController.text != "" &&
                                    descriptionController.text != "" &&
                                    approxValueController.text != "" &&
                                    dateController.text != "") {
                                  Response response =
                                  await AssetManagementFireCrud
                                      .updateRecord(
                                    AssetManagementModel(
                                      id: asset.id,
                                      timestamp: asset.timestamp,
                                      description: descriptionController.text,
                                      date: dateController.text,
                                      verifier: verifierController.text,
                                      approxValue: approxValueController.text,
                                      assets: assetsController.text,
                                    )
                                  );
                                  if (response.code == 200) {
                                    Navigator.pop(context);
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Asset Updated successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    setState(() {
                                      approxValueController.text = "";
                                      verifierController.text = "";
                                      assetsController.text = "";
                                      descriptionController.text = "";
                                    });
                                  } else {
                                    Navigator.pop(context);
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to Update Asset!",
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
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Constants().primaryAppColor,
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6),
                                  child: Center(
                                    child: KText(
                                      text: "UPDATE",
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
        );
      },
    );
  }

  viewPopup(AssetManagementModel asset) {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: size.width * 0.5,
            margin: const EdgeInsets.all(20),
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
              children: [
                SizedBox(
                  height: size.height * 0.1,
                  width: double.infinity,
                  child: Padding(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          asset.date!,
                          style: GoogleFonts.openSans(
                            fontSize: 20,
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
                              const EdgeInsets.symmetric(horizontal: 6),
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
                    decoration: const BoxDecoration(
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
                                image: NetworkImage(asset.imgUrl!),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 15),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Assets",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text:asset.assets!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Document",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      InkWell(
                                        onTap: () async {
                                          final Uri toLaunch =
                                          Uri.parse(asset.document!);
                                          if (!await launchUrl(toLaunch,
                                          mode: LaunchMode.externalApplication,
                                          )) {
                                          throw Exception('Could not launch $toLaunch');
                                          }
                                        },
                                        child: Container(
                                          height: 35,
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
                                            const EdgeInsets.symmetric(horizontal: 6),
                                            child: Center(
                                              child: KText(
                                                text: "Download Document",
                                                style: GoogleFonts.openSans(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Approximate Value",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text:asset.approxValue!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        asset.date!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "AMC Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      Text(
                                        asset.amcDate!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Verifier",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: asset.verifier!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      )
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: const KText(
                                          text: "Description",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 16
                                          ),
                                        ),
                                      ),
                                      const Text(":"),
                                      const SizedBox(width: 20),
                                      KText(
                                        text: asset.description!,
                                        style: const TextStyle(
                                            fontSize: 14
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
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

  filterPopUp() {
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
            builder: (context,setState) {
              return AlertDialog(
                backgroundColor: Colors.transparent,
                content: Container(
                  height: size.height * 0.4,
                  width: size.width * 0.3,
                  decoration: BoxDecoration(
                    color: Constants().primaryAppColor,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: size.height * 0.07,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: KText(
                                text: "Filter",
                                style: GoogleFonts.openSans(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )
                          ),
                          width: double.infinity,
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: KText(
                                      text: "Start Date",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                          offset: Offset(2, 3),
                                        )
                                      ],
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(color: Color(0xff00A99D)),
                                        hintText: dateRangeStart != null ? "${dateRangeStart!.day}-${dateRangeStart!.month}-${dateRangeStart!.year}" : "",
                                        border: InputBorder.none,
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000));
                                        if (pickedDate != null) {
                                          setState(() {
                                            dateRangeStart = pickedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: KText(
                                      text: "End Date",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                          offset: Offset(2, 3),
                                        )
                                      ],
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(color: Color(0xff00A99D)),
                                        hintText: dateRangeEnd != null ? "${dateRangeEnd!.day}-${dateRangeEnd!.month}-${dateRangeEnd!.year}" : "",
                                        border: InputBorder.none,
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000));
                                        if (pickedDate != null) {
                                          setState(() {
                                            dateRangeEnd = pickedDate;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  SizedBox(
                                    width: 90,
                                    child: KText(
                                      text: "AMC Date",
                                      style: GoogleFonts.openSans(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Container(
                                    height: 40,
                                    width: 90,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                          offset: Offset(2, 3),
                                        )
                                      ],
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintStyle: const TextStyle(color: Color(0xff00A99D)),
                                        border: InputBorder.none,
                                        hintText: amcDateRange,
                                      ),
                                      onTap: () async {
                                        DateTime? pickedDate = await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(3000));
                                        if (pickedDate != null) {
                                          setState(() {
                                            amcDateRange = formatter.format(pickedDate);
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context,false);
                                    },
                                    child: Container(
                                      height: 40,
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
                                        const EdgeInsets.symmetric(horizontal: 6),
                                        child: Center(
                                          child: KText(
                                            text: "Cancel",
                                            style: GoogleFonts.openSans(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context,true);
                                    },
                                    child: Container(
                                      height: 40,
                                      decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
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
                                        const EdgeInsets.symmetric(horizontal: 6),
                                        child: Center(
                                          child: KText(
                                            text: "Apply",
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
                              )
                            ],
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

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow: const [
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
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Please fill required fields !!',
                  style: TextStyle(color: Colors.black)),
            ),
            const Spacer(),
            TextButton(
                onPressed: () => debugPrint("Undid"), child: const Text("Undo"))
          ],
        )),
  );
}

import 'package:church_management_admin/models/donation_model.dart';
import 'package:church_management_admin/services/donation_firecrud.dart';
import 'package:church_management_admin/services/fund_manage_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';

class DonationsTab extends StatefulWidget {
  DonationsTab({super.key});

  @override
  State<DonationsTab> createState() => _DonationsTabState();
}

class _DonationsTabState extends State<DonationsTab> {
  TextEditingController descriptionController = TextEditingController();
  TextEditingController viaController = TextEditingController();
  TextEditingController sourceController = TextEditingController();
  TextEditingController verifierController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  DateTime? dateRangeStart;
  DateTime? dateRangeEnd;
  bool isFiltered= false;

  String currentTab = 'View';

  setDateTime() async {
    setState(() {
      dateController.text = formatter.format(selectedDate);
    });
  }

  @override
  void initState() {
    setDateTime();
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
              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "DONATIONS",
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
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Donation" : "View Records",
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
              height: size.height * 0.78,
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
                            text: "ADD DONATION",
                            style: GoogleFonts.openSans(
                              fontSize: width/68.3,
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
                                      text: "Date *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize: width/113.83),
                                      controller: dateController,
                                      onTap: () async {
                                        DateTime? pickedDate =
                                        await showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime(1900),
                                            lastDate: DateTime(3000));
                                        if (pickedDate != null) {
                                          setState(() {
                                            dateController.text = formatter.format(pickedDate);
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
                                      text: "Amount *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize: width/113.83),
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                      ],
                                      controller: amountController,
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
                                      text: "Source *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize: width/113.83),
                                      controller: sourceController,
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
                                      text: "Through/By/Via *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize: width/113.83),
                                      controller: viaController,
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
                                      text: "Cheque/Bank/UPI ",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize: width/113.83),
                                      controller: bankController,
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
                                      text: "Verifier *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize:width/105.07,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize: width/113.83),
                                      controller: verifierController,
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
                                text: "Note/Description",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize:width/105.07,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height:height/130.2),
                              Container(
                                height: size.height * 0.16,
                                width: double.infinity,
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
                                            maxLines: null,
                                            style:
                                                TextStyle(fontSize: width/113.83),
                                            controller: descriptionController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left:width/91.06,
                                                    top:height/162.75,
                                                    bottom:height/162.75)),
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
                                  if (amountController.text != "" &&
                                      verifierController.text != "" &&
                                      viaController.text != "" &&
                                      dateController.text != "" &&
                                      sourceController.text != "") {
                                    Response response =
                                        await DonationFireCrud.addDonation(
                                      description: descriptionController.text,
                                      date: dateController.text,
                                      amount: amountController.text,
                                      bank: bankController.text,
                                      source: sourceController.text,
                                      verifier: verifierController.text,
                                      via: viaController.text,
                                    );
                                    var document = await FirebaseFirestore.instance.collection('Funds').get();
                                    var fund = FirebaseFirestore.instance.collection('Funds').doc("x18zE9lNxDto7AXHlXDA").update({
                                      "currentBalance": document.docs.first.get('currentBalance') + double.parse(amountController.text),
                                      "totalCollect": document.docs.first.get('totalCollect') + double.parse(amountController.text),
                                    });
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text:
                                              "Donation created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        currentTab = 'View';
                                        amountController.text = "";
                                        verifierController.text != "";
                                        bankController.text = "";
                                        descriptionController.text = "";
                                        sourceController.text = "";
                                        viaController.text = "";
                                        dateController.text = "";
                                      });
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Donation!",
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
                : currentTab.toUpperCase() == "VIEW" ? dateRangeStart != null ?
            StreamBuilder(
              stream: DonationFireCrud.fetchDonationsWithFilter(dateRangeStart!,dateRangeEnd!),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<DonationModel> donations = snapshot.data!;
                  return Container(
                    width:width/1.241,
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
                                  text: "Recent Records (${donations.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
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
                                    height:height/16.275,
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
                                          text: "Clear Filter",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/97.571,
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
                          height: size.height * 0.7 > 70 + donations.length * 60
                              ? 70 + donations.length * 60
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
                              SizedBox(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width/39.028,
                                      child: KText(
                                        text: "SL.",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/15.177,
                                      child: KText(
                                        text: "Date",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/10.507,
                                      child: KText(
                                        text: "Amount",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/9.106,
                                      child: KText(
                                        text: "Source",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/68.30,
                                      child: KText(
                                        text: "Through/by/via",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/5.464,
                                      child: KText(
                                        text: "Cheque/Bank/UPI/Other Info",
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
                                  itemCount: donations.length,
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
                                            width: width/39.028,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/15.177,
                                            child: KText(
                                              text: donations[i].date!,
                                              style: GoogleFonts.poppins(
                                                fontSize: width/113.83,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/10.507,
                                            child: KText(
                                              text: donations[i].amount!,
                                              style: GoogleFonts.poppins(
                                                fontSize: width/113.83,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/9.106,
                                            child: KText(
                                              text: donations[i].source!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/68.30,
                                            child: KText(
                                              text: donations[i].via!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/5.464,
                                            child: KText(
                                              text: donations[i].bank!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: width/17.075,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        sourceController.text =
                                                        donations[i]
                                                            .source!;
                                                        dateController.text = donations[i].date!;
                                                        amountController.text = donations[i].amount!;
                                                        viaController.text = donations[i].via!;
                                                        bankController.text = donations[i].bank!;
                                                        verifierController.text = donations[i].verifier!;
                                                        descriptionController.text = donations[i].description!;
                                                      });
                                                      editPopUp(
                                                          donations[i], size);
                                                    },
                                                    child: Container(
                                                      height: height/26.04,
                                                      decoration:
                                                      BoxDecoration(
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
                                                                size: width/91.066,
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
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType
                                                              .info,
                                                          text:
                                                          "${donations[i].description} will be deleted",
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
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                          onConfirmBtnTap:
                                                              () async {
                                                            Response res =
                                                            await DonationFireCrud
                                                                .deleteRecord(
                                                                id: donations[i]
                                                                    .id!);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: height/26.04,
                                                      decoration:
                                                      BoxDecoration(
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
                                                                size: width/91.066,
                                                              ),
                                                              KText(
                                                                text: "Delete",
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
              stream: DonationFireCrud.fetchDonations(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<DonationModel> donations = snapshot.data!;
                  return Container(
                    width:width/1.241,
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
                                  text: "Recent Records (${donations.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
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
                                    height:height/16.275,
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
                                          text: "Filter",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/97.571,
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
                          height: size.height * 0.7 > 70 + donations.length * 60
                              ? 70 + donations.length * 60
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
                              SizedBox(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width/39.028,
                                      child: KText(
                                        text: "SL.",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/15.177,
                                      child: KText(
                                        text: "Date",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/10.507,
                                      child: KText(
                                        text: "Amount",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/9.106,
                                      child: KText(
                                        text: "Source",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/68.30,
                                      child: KText(
                                        text: "Through/by/via",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/5.464,
                                      child: KText(
                                        text: "Cheque/Bank/UPI/Other Info",
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
                                  itemCount: donations.length,
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
                                            width: width/39.028,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/15.177,
                                            child: KText(
                                              text: donations[i].date!,
                                              style: GoogleFonts.poppins(
                                                fontSize: width/113.83,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/10.507,
                                            child: KText(
                                              text: donations[i].amount!,
                                              style: GoogleFonts.poppins(
                                                fontSize: width/113.83,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/9.106,
                                            child: KText(
                                              text: donations[i].source!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/68.30,
                                            child: KText(
                                              text: donations[i].via!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/5.464,
                                            child: KText(
                                              text: donations[i].bank!,
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: width/17.075,
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        sourceController.text =
                                                            donations[i]
                                                                .source!;
                                                        dateController.text = donations[i].date!;
                                                        amountController.text = donations[i].amount!;
                                                        viaController.text = donations[i].via!;
                                                        bankController.text = donations[i].bank!;
                                                        verifierController.text = donations[i].verifier!;
                                                        descriptionController.text = donations[i].description!;
                                                      });
                                                      editPopUp(
                                                          donations[i], size);
                                                    },
                                                    child: Container(
                                                      height: height/26.04,
                                                      decoration:
                                                          BoxDecoration(
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
                                                                size: width/91.066,
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
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType
                                                              .info,
                                                          text:
                                                              "${donations[i].description} will be deleted",
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
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                          onConfirmBtnTap:
                                                              () async {
                                                            Response res =
                                                                await DonationFireCrud
                                                                    .deleteRecord(
                                                                        id: donations[i]
                                                                            .id!);
                                                          });
                                                    },
                                                    child: Container(
                                                      height: height/26.04,
                                                      decoration:
                                                          BoxDecoration(
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
                                                                size: width/91.066,
                                                              ),
                                                              KText(
                                                                text: "Delete",
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

  editPopUp(DonationModel donation, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            height: size.height * 0.78,
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
                    padding:
                        EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                    child: Row(
                      children: [
                        Icon(Icons.account_tree),
                        SizedBox(width: width/136.6),
                        KText(
                          text: "EDIT DONATION",
                          style: GoogleFonts.openSans(
                            fontSize: width/68.3,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Expanded(child: Container()),
                        InkWell(
                          onTap: () {
                            setState(() {
                              amountController.text = "";
                              verifierController.text = "";
                              bankController.text = "";
                              descriptionController.text = "";
                              sourceController.text = "";
                              viaController.text = "";
                              dateController.text = formatter.format(DateTime.now());
                            });
                            Navigator.pop(context);
                          },
                          child: Icon(Icons.cancel_outlined),
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
                                    text: "Date",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.07,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: TextStyle(fontSize: width/113.83),
                                    controller: dateController,
                                    onTap: () async {
                                      DateTime? pickedDate =
                                      await showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1900),
                                          lastDate: DateTime(3000));
                                      if (pickedDate != null) {
                                        setState(() {
                                          dateController.text = formatter.format(pickedDate);
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
                                    text: "Amount",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.07,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: TextStyle(fontSize: width/113.83),
                                    inputFormatters: [
                                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                    ],
                                    controller: amountController,
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
                                    text: "Source",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.07,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: TextStyle(fontSize: width/113.83),
                                    controller: sourceController,
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
                                    text: "Through/By/Via",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.07,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: TextStyle(fontSize: width/113.83),
                                    controller: viaController,
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
                                    text: "Cheque/Bank/UPI",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.07,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: TextStyle(fontSize: width/113.83),
                                    controller: bankController,
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
                                    text: "Verifier",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.07,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: TextStyle(fontSize: width/113.83),
                                    controller: verifierController,
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
                              text: "Note/Description",
                              style: GoogleFonts.openSans(
                                color: Colors.black,
                                fontSize:width/105.07,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height:height/130.2),
                            Container(
                              height: size.height * 0.16,
                              width: double.infinity,
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
                                          maxLines: null,
                                          style: TextStyle(fontSize: width/113.83),
                                          controller: descriptionController,
                                          decoration: InputDecoration(
                                              border: InputBorder.none,
                                              contentPadding: EdgeInsets.only(
                                                  left:width/91.06, top:height/162.75, bottom:height/162.75)),
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
                              onTap: () {
                                setState(() {
                                  amountController.text = "";
                                  verifierController.text = "";
                                  bankController.text = "";
                                  descriptionController.text = "";
                                  sourceController.text = "";
                                  viaController.text = "";
                                  dateController.text = formatter.format(DateTime.now());
                                });
                                Navigator.pop(context);
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
                            ),
                            SizedBox(width: width/68.3),
                            InkWell(
                              onTap: () async {
                                if (amountController.text != "" &&
                                    verifierController.text != "" &&
                                    bankController.text != "" &&
                                    descriptionController.text != "" &&
                                    viaController.text != "" &&
                                    dateController.text != "" &&
                                    sourceController.text != "") {
                                  Response response =
                                      await DonationFireCrud.updateRecord(
                                          DonationModel(
                                    id: donation.id,
                                    timestamp: donation.timestamp,
                                    description: descriptionController.text,
                                    date: dateController.text,
                                    amount: amountController.text,
                                    bank: bankController.text,
                                    source: sourceController.text,
                                    verifier: verifierController.text,
                                    via: viaController.text,
                                  ));
                                  if (response.code == 200) {
                                    Navigator.pop(ctx);
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text: "Donation Updated successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    setState(() {
                                      amountController.text = "";
                                      verifierController.text != "";
                                      bankController.text = "";
                                      descriptionController.text = "";
                                      sourceController.text = "";
                                      viaController.text = "";
                                      dateController.text = formatter.format(DateTime.now());
                                    });
                                  } else {
                                    Navigator.pop(ctx);
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text: "Failed to Update Donation!",
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
                                  padding:
                                      EdgeInsets.symmetric(horizontal:width/227.66),
                                  child: Center(
                                    child: KText(
                                      text: "UPDATE",
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

  filterPopUp() {
    Size size = MediaQuery.of(context).size;
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
                              padding: EdgeInsets.symmetric(horizontal: width/68.3),
                              child: KText(
                                text: "Filter",
                                style: GoogleFonts.openSans(
                                  fontSize: width/85.375,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomRight: Radius.circular(10),
                                bottomLeft: Radius.circular(10),
                              )
                          ),
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                  horizontal: width/68.3,
                  vertical: height/32.55
              ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                children: [
                                  SizedBox(
                                    width: width/15.177,
                                    child: KText(
                                      text: "Start Date",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/85.375),
                                  Container(
                                    height:height/16.275,
                                    width: width/15.177,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                          offset: Offset(2, 3),
                                        )
                                      ],
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(color: Color(0xff00A99D)),
                                        hintText: dateRangeStart != null ? "${dateRangeStart!.day}/${dateRangeStart!.month}/${dateRangeStart!.year}" : "",
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
                                    width: width/15.177,
                                    child: KText(
                                      text: "End Date",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/85.375),
                                  Container(
                                    height:height/16.275,
                                    width: width/15.177,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(7),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black26,
                                          blurRadius: 3,
                                          offset: Offset(2, 3),
                                        )
                                      ],
                                    ),
                                    child: TextField(
                                      decoration: InputDecoration(
                                        hintStyle: TextStyle(color: Color(0xff00A99D)),
                                        hintText: dateRangeEnd != null ? "${dateRangeEnd!.day}/${dateRangeEnd!.month}/${dateRangeEnd!.year}" : "",
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
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context,false);
                                    },
                                    child: Container(
                                      height:height/16.275,
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
                                            text: "Cancel",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/85.375,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width:width/273.2),
                                  InkWell(
                                    onTap: () {
                                      Navigator.pop(context,true);
                                    },
                                    child: Container(
                                      height:height/16.275,
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
                                            text: "Apply",
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

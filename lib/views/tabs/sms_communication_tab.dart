import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:textfield_tags/textfield_tags.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/department_model.dart';
import '../../services/department_firecrud.dart';
import '../../widgets/kText.dart';

class SmsCommunicationTab extends StatefulWidget {
  SmsCommunicationTab({super.key});

  @override
  State<SmsCommunicationTab> createState() => _SmsCommunicationTabState();
}

class _SmsCommunicationTabState extends State<SmsCommunicationTab> {

  TextfieldTagsController controller = TextfieldTagsController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  static List<String> _pickLanguage = <String>[];
  String currentTab = 'View';


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
                    text: "SMS COMMUNICATION",
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
                              text: currentTab.toUpperCase() == "VIEW" ? "Send SMS" : "View SMS",
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
              height: size.height * 0.67,
              width: double.infinity,
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
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                      child: Row(
                        children: [
                          Icon(Icons.message),
                          SizedBox(width:width/136.6),
                          KText(
                            text: "SMS",
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
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          )),
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(horizontal: width/68.3,vertical: height/65.1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Single/Mulitiple Phone Numbers *",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.07,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Autocomplete<String>(
                                    optionsViewBuilder: (context, onSelected, options) {
                                      return Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal:width/136.6, vertical: height/162.75),
                                        child: Align(
                                          alignment: Alignment.topCenter,
                                          child: Material(
                                            elevation: 4.0,
                                            child: ConstrainedBox(
                                              constraints:  const BoxConstraints(maxHeight: 20),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                itemCount: options.length,
                                                itemBuilder: (BuildContext context, int index) {
                                                  final dynamic option = options.elementAt(index);
                                                  return TextButton(
                                                    onPressed: () {
                                                      onSelected(option);
                                                    },
                                                    child: Align(
                                                      alignment: Alignment.centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets.symmetric(
                                                            vertical: height/43.4),
                                                        child: Text(
                                                          '#$option',
                                                          textAlign: TextAlign.left,
                                                          style: TextStyle(
                                                            color: Color.fromARGB(255, 74, 137, 92),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                    optionsBuilder: (TextEditingValue textEditingValue) {
                                      if (textEditingValue.text == '') {
                                        return Iterable<String>.empty();
                                      }
                                      return _pickLanguage.where((String option) {
                                        return option.contains(textEditingValue.text.toLowerCase());
                                      });
                                    },
                                    onSelected: (String selectedTag) {
                                      controller.addTag = selectedTag;
                                    },
                                    fieldViewBuilder: (context, ttec, tfn, onFieldSubmitted) {
                                      return TextFieldTags(
                                        textEditingController: ttec,
                                        focusNode: tfn,
                                        textfieldTagsController: controller,
                                        initialTags: [],
                                        textSeparators: [' ',','],
                                        letterCase: LetterCase.normal,
                                        validator: (String tag) {
                                          if (tag == 'php') {
                                            return 'No, please just no';
                                          } else if (controller.getTags!.contains(tag)) {
                                            return 'you already entered that';
                                          }
                                          return null;
                                        },
                                        inputfieldBuilder:
                                            (context, tec, fn, error, onChanged, onSubmitted) {
                                          return ((context, sc, tags, onTagDelete) {
                                            return Padding(
                                              padding: EdgeInsets.symmetric(horizontal:width/136.6),
                                              child: TextField(
                                                controller: tec,
                                                focusNode: fn,
                                                decoration: InputDecoration(
                                                  border: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Constants().primaryAppColor,
                                                      width: width/455.333,
                                                    ),
                                                  ),
                                                  focusedBorder: UnderlineInputBorder(
                                                    borderSide: BorderSide(
                                                      color: Constants().primaryAppColor,
                                                      width: width/455.333,
                                                    ),
                                                  ),
                                                  helperStyle: TextStyle(
                                                    color: Constants().primaryAppColor,
                                                  ),
                                                  errorText: error,
                                                  prefixIconConstraints: BoxConstraints(
                                                      maxWidth: size.width * 0.74),
                                                  prefixIcon: tags.isNotEmpty
                                                      ? SingleChildScrollView(
                                                    controller: sc,
                                                    scrollDirection: Axis.horizontal,
                                                    child: Row(
                                                        children: tags.map((String tag) {
                                                          return Container(
                                                            decoration: BoxDecoration(
                                                              borderRadius: BorderRadius.all(
                                                                Radius.circular(20.0),
                                                              ),
                                                              color: Constants().primaryAppColor,
                                                            ),
                                                            margin:
                                                            EdgeInsets.only(right: width/136.6),
                                                            padding: EdgeInsets.symmetric(
                                                                horizontal: width/136.6, vertical: height/162.75),
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment.spaceBetween,
                                                              children: [
                                                                InkWell(
                                                                  child: Text(
                                                                    tag,
                                                                    style: TextStyle(
                                                                        color: Colors.white),
                                                                  ),
                                                                ),
                                                                SizedBox(width: width/341.5),
                                                                InkWell(
                                                                  child: Icon(
                                                                      Icons.cancel,
                                                                      size:width/97.571,
                                                                      color: Colors.black
                                                                  ),
                                                                  onTap: () {
                                                                    onTagDelete(tag);
                                                                  },
                                                                )
                                                              ],
                                                            ),
                                                          );
                                                        }).toList()),
                                                  )
                                                      : null,
                                                ),
                                                onChanged: (text){
                                                  if(text.length == 10){
                                                    setState(() {
                                                      controller.addTag = text;
                                                    });
                                                  }
                                                },
                                                onSubmitted: onSubmitted,
                                              ),
                                            );
                                          });
                                        },
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height/21.7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(left: width/54.64),
                                child: KText(
                                  text: "Description",
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize:width/105.07,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
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
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style: TextStyle(
                                                fontSize:width/113.83),
                                            controller: descriptionController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: width/91.066,top: height/162.75,bottom: height/162.75)
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
                          SizedBox(height:height/65.1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: (){},
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
                                      child: Row(
                                        children: [
                                          Icon(Icons.send, color: Colors.white),
                                          SizedBox(width:width/273.2),
                                          KText(
                                            text: "SEND",
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
                : currentTab.toUpperCase() == "VIEW" ? StreamBuilder(
              stream: DepartmentFireCrud.fetchDepartments(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<DepartmentModel> sms = [];
                  return Container(
                   width:width/1.241,
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
                                  text: "SMS (${sms.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.73,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width/34.15,
                                      child: KText(
                                        text: "No.",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/17.075,
                                      child: KText(
                                        text: "Time",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/136.60,
                                      child: KText(
                                        text: "Phone",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/136.60,
                                      child: KText(
                                        text: "Content",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/136.60,
                                      child: KText(
                                        text: "SMS ID",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/9.106,
                                      child: KText(
                                        text: "SMS Network",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/136.60,
                                      child: KText(
                                        text: "SMS Cost",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/6.83,
                                      child: KText(
                                        text: "Current Balance",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width:width/9.106,
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
                              SizedBox(height:height/65.1),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: 0,
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
                                      child: Row(
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
                                            width:width/7.588,
                                            child: KText(
                                              text: "departments[i].name!",
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/7.588,
                                            child: KText(
                                              text: "departments[i].leaderName!",
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/8.035,
                                            child: KText(
                                              text: "departments[i].contactNumber!",
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width:width/6.83,
                                            child: KText(
                                              text: "departments[i].location!",
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width:width/6.83,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      height:height/26.04,
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
                                                                size:width/91.06,
                                                              ),
                                                              KText(
                                                                text: "View",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:width/136.6,
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
                                                  SizedBox(width:width/273.2),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      height:height/26.04,
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
                                                                size:width/91.06,
                                                              ),
                                                              KText(
                                                                text: "Edit",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:width/136.6,
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
                                                  SizedBox(width:width/273.2),
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      height:height/26.04,
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
                                                                size:width/91.06,
                                                              ),
                                                              KText(
                                                                text: "Delete",
                                                                style: GoogleFonts
                                                                    .openSans(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize:width/136.6,
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
            )
                : Container(),
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

import 'package:church_management_admin/models/zone_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localization/flutter_localization.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/members_model.dart';
import '../../models/response.dart';
import '../../services/zonal_activities_firecrud.dart';
import '../../widgets/kText.dart';

class ZonesListView extends StatefulWidget {
  const ZonesListView({Key? key}) : super(key: key);

  @override
  State<ZonesListView> createState() => _ZonesListViewState();
}

class _ZonesListViewState extends State<ZonesListView> with SingleTickerProviderStateMixin {

  TextEditingController zoneIdController = TextEditingController();
  TextEditingController zoneNameController = TextEditingController();
  TextEditingController leaderNameController = TextEditingController();
  TextEditingController leaderPhoneController = TextEditingController();
  TextEditingController areaController = TextEditingController();
  String currentTab = 'View';
  List<String> areasList = [];
  List<String> zoneAreasList = [];
  List<MembersModel> zoneHelpersList = [];
  List<MembersModel> membersList = [];
  int selectedTabIndex = 0;
  int membersCount = 0;

  TextEditingController memberNameController = TextEditingController();
  TextEditingController memberIdController = TextEditingController();
  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  TabController? _tabController;
  int currentTabIndex = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    getAreas();
    getMembers();
    super.initState();
  }

  getAreas() async {
    areasList.clear();
    var areaDoc = await FirebaseFirestore.instance.collection('AreaMaster').orderBy("areaName").get();
    for(int i = 0; i < areaDoc.docs.length; i++){
      setState(() {
        areasList.add(areaDoc.docs[i].get("areaName"));
      });
    }
  }

  getMembers() async {
    membersList.clear();
    var memberDoc = await FirebaseFirestore.instance.collection('Members').get();
    for(int i = 0; i < memberDoc.docs.length; i++){
      setState(() {
        membersList.add(MembersModel.fromJson(memberDoc.docs[i].data()));
      });
    }
  }

  static List<String> getSuggestionsregno(String query, List<MembersModel> membersList1) {
    List<String> matches = <String>[];
    membersList1.forEach((element) {
      matches.add(element.memberId!);
    });
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
  static List<String> getSuggestionsstudent(String query, List<MembersModel> membersList1) {
    List<String> matches = <String>[];
    membersList1.forEach((element) {
      matches.add(element.firstName!+" "+element.lastName!);
    });
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  getMemberById() async {
    for(int i=0;i< membersList.length;i++){
      if(memberIdController.text == membersList[i].memberId){
        setState(() {
          memberNameController.text = "${membersList[i].firstName!} ${membersList[i].lastName!}";
        }
        );
      }
    }
  }

  getMemberByName() async {
    for(int i=0;i< membersList.length;i++){
      if(memberNameController.text == "${membersList[i].firstName!} ${membersList[i].lastName!}"){
        setState(() {
          memberIdController.text = membersList[i].memberId!;
        }
        );
      }
    }
  }

  getLeaderByName() async {
    for(int i=0;i< membersList.length;i++){
      if(leaderNameController.text == "${membersList[i].firstName!} ${membersList[i].lastName!}"){
        setState(() {
          leaderPhoneController.text = membersList[i].phone!;
        }
        );
      }
    }
  }

  MembersModel getMember(){
    MembersModel member = MembersModel();
    for(int i=0;i< membersList.length;i++){
      if(memberIdController.text == membersList[i].memberId){
        member = membersList[i];
      }
    }
    return member;
  }

  generateZoneID() async {
    var zoneDoc = await FirebaseFirestore.instance.collection('Zones').get();
    int lastId = zoneDoc.docs.length + 1;
    String zoneId = lastId.toString().padLeft(6,'0');
    setState(() {
      zoneIdController.text = "BCAGZ$zoneId";
    });
  }

  clearTextControllers() {
    setState(() {
      zoneIdController.clear();
      zoneNameController.clear();
      areaController.clear();
      leaderNameController.clear();
      leaderPhoneController.clear();
      zoneAreasList.clear();
      zoneHelpersList.clear();
      selectedTabIndex = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "Zone List",
                    style: GoogleFonts.openSans(
                      fontSize: width / 52.53846153846154,
                      fontWeight: FontWeight.w900,
                      color: Colors.black,
                    ),
                  ),
                  InkWell(
                      onTap:(){
                        if(currentTab.toUpperCase() == "VIEW") {
                          setState(() {
                            currentTab = "Add";
                            generateZoneID();
                          });
                        }else{
                          setState(() {
                            currentTab = 'View';
                            clearTextControllers();
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
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Zone" : "View zones",
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
              height: size.height * 1.7,
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
                            text: "Add Zone",
                            style: GoogleFonts.openSans(
                              fontSize: width / 68.3,
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
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: height / 43.4, horizontal: width / 91.06),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Zone ID",
                                style: GoogleFonts.openSans(
                                  fontSize: width/97.571,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: height/108.5),
                              Material(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white,
                                elevation: 10,
                                child: SizedBox(
                                  height: height/13.02,
                                  width: 200,
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                    child: TextFormField(
                                      controller: zoneIdController,
                                      decoration: InputDecoration(
                                          border: InputBorder.none
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: height / 21.7),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Zone Name",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/97.571,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: height/108.5),
                                  Material(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    elevation: 10,
                                    child: SizedBox(
                                      height: height/13.02,
                                      width: 250,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                        child: TextFormField(
                                          controller: zoneNameController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            //FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(width: width/68.3),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Leader Name",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/97.571,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: height/108.5),
                                  Material(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    elevation: 10,
                                    child: SizedBox(
                                      width: width/3.902,
                                      height: height/16.425,
                                      child: TypeAheadFormField(
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
                                          controller: leaderNameController,
                                        ),
                                        suggestionsCallback: (pattern) {
                                          return getSuggestionsstudent(pattern,membersList);
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
                                            leaderNameController.text = suggestion;
                                          });
                                          getLeaderByName();
                                        },
                                        suggestionsBoxController: suggestionBoxController,
                                        validator: (value) =>
                                        value!.isEmpty ? 'Please select a class' : null,
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              SizedBox(width: width/68.3),
                              Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Leader Phone",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/97.571,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: height/108.5),
                                  Material(
                                    borderRadius: BorderRadius.circular(5),
                                    color: Colors.white,
                                    elevation: 10,
                                    child: SizedBox(
                                      height: height/13.02,
                                      width: 200,
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                        child: TextFormField(
                                          controller: leaderPhoneController,
                                          decoration: InputDecoration(
                                            border: InputBorder.none,
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: height / 21.7),
                          Container(
                            height: 300,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Area",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: 270,
                                        width: width * 0.35,
                                        child: ListView.builder(
                                          itemCount: areasList.length,
                                          itemBuilder: (ctx ,i){
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  KText(
                                                    text: areasList[i],
                                                    style: GoogleFonts.openSans(
                                                      fontSize: width/97.571,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: (){
                                                      setState(() {
                                                        if(!zoneAreasList.contains(areasList[i])){
                                                          zoneAreasList.add(areasList[i]);
                                                        }
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.add_circle_outlined,
                                                      color: Constants().primaryAppColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(width: width/68.3),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Zone Area",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: 270,
                                        width: width * 0.35,
                                        child: ListView.builder(
                                          itemCount: zoneAreasList.length,
                                          itemBuilder: (ctx ,i){
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  KText(
                                                    text: zoneAreasList[i],
                                                    style: GoogleFonts.openSans(
                                                      fontSize: width/97.571,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: (){
                                                      setState(() {
                                                        zoneAreasList.removeAt(i);
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.remove_circle_outlined,
                                                      color: Constants().primaryAppColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height / 21.7),
                          Container(
                            height: 300,
                            width: double.infinity,
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Members",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: 270,
                                        width: width * 0.35,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.only(right:0.0),
                                                  child: Text("Member Name",style: GoogleFonts.poppins(fontSize: 15,)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 0.0,right: 25),
                                                  child: Container(
                                                    width: width/3.902,
                                                    height: height/16.425,
                                                    //color: Color(0xffDDDEEE),
                                                    decoration: BoxDecoration(color: const Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),

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
                                                        controller: memberNameController,
                                                      ),
                                                      suggestionsCallback: (pattern) {
                                                        return getSuggestionsstudent(pattern,membersList);
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
                                                          memberNameController.text = suggestion;
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
                                                  child: Text("Member ID",style: GoogleFonts.poppins(fontSize: 15,)),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.only(left: 0.0,right: 25),
                                                  child: Container(width: width/3.902,
                                                    height: height/16.425,
                                                    //color: Color(0xffDDDEEE),
                                                    decoration: BoxDecoration(color: const Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),child:
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
                                                        return getSuggestionsregno(pattern,membersList);
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
                                            SizedBox(height: 20),
                                            InkWell(
                                              onTap: (){
                                                if(memberIdController.text != ""){
                                                  setState(() {
                                                    zoneHelpersList.add(getMember());
                                                    memberIdController.clear();
                                                    memberNameController.clear();
                                                  });
                                                }else{
                                                  CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.info,
                                                    title: "Member Not Found",
                                                    text: 'Please add member',
                                                    width: MediaQuery.of(context).size.width * 0.4,
                                                    backgroundColor: Constants()
                                                        .primaryAppColor
                                                        .withOpacity(0.8),
                                                  );
                                                }
                                              },
                                              child: Container(
                                                width: width/10.507,
                                                height: height/16.425,
                                                decoration: BoxDecoration(
                                                  color: Constants().primaryAppColor,
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Add",
                                                    style: GoogleFonts.poppins(
                                                      color: Constants().btnTextColor,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: width/68.3),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Zone Leader Supporters",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: 270,
                                        width: width * 0.35,
                                        child: ListView.builder(
                                          itemCount: zoneHelpersList.length,
                                          itemBuilder: (ctx ,i){
                                            return Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  KText(
                                                    text: "${zoneHelpersList[i].firstName!} ${zoneHelpersList[i].lastName!}",
                                                    style: GoogleFonts.openSans(
                                                      fontSize: width/97.571,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  IconButton(
                                                    onPressed: (){
                                                      setState(() {
                                                        zoneHelpersList.removeAt(i);
                                                      });
                                                    },
                                                    icon: Icon(
                                                      Icons.remove_circle_outlined,
                                                      color: Constants().primaryAppColor,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: height / 21.7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if(zoneIdController.text != "" &&
                                      zoneNameController.text != "" &&
                                      leaderNameController.text != ""
                                  ){

                                    Response response = await ZonalActivitiesFireCrud.addZone(
                                      zoneName: zoneNameController.text,
                                      zoneId: zoneIdController.text,
                                      leaderName: leaderNameController.text,
                                      leaderPhone: leaderPhoneController.text,
                                      areas: zoneAreasList,
                                      supportersList: zoneHelpersList,
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Zone created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      clearTextControllers();
                                      setState(() {
                                        currentTab = 'View';
                                      });
                                    } else {
                                      await CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Zone!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));

                                    }

                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                        text: "Submit",
                                        style: GoogleFonts.openSans(
                                          color: Constants().btnTextColor,
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
            )
                : currentTab.toUpperCase() == "VIEW"
                ? StreamBuilder(
              stream: ZonalActivitiesFireCrud.fetchZones(),
              builder: (ctx, snap){
                if(snap.hasData){
                  List<ZoneModel> zones = snap.data!;
                  return Container(
                    width: width/1.241,
                    margin:   EdgeInsets.symmetric(
                        vertical: height/32.55,
                        horizontal: width/68.3
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
                                  text: "All Zones (${zones.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                // Container(
                                //   height:height/18.6,
                                //   width: width/9.106,
                                //   decoration: BoxDecoration(
                                //     color: Colors.white,
                                //     borderRadius:
                                //     BorderRadius.circular(10),
                                //   ),
                                //   child: TextField(
                                //     onChanged: (val) {
                                //       setState(() {
                                //         //searchString = val;
                                //       });
                                //     },
                                //     decoration: InputDecoration(
                                //       border: InputBorder.none,
                                //       hintText: 'Search',
                                //       hintStyle: TextStyle(
                                //         color: Colors.black,
                                //       ),
                                //       contentPadding:  EdgeInsets.only(
                                //           left: width/136.6, bottom: height/65.1),
                                //     ),
                                //   ),
                                // ),
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
                          padding:   EdgeInsets.symmetric(
                              vertical: height/32.55,
                              horizontal: width/68.3
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                child: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: width/13.66,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/6.83,
                                        child: KText(
                                          text: "Zone Name",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/6.83,
                                        child: KText(
                                          text: "Total Area",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/5.464,
                                        child: KText(
                                          text: "Zone Leader",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/5.464,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
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
                                  itemCount: zones.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: height/10.85,
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
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: width/13.66,
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/6.83,
                                              child: KText(
                                                text: zones[i].zoneName!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/6.83,
                                              child: KText(
                                                text: zones[i].areas!.length.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/5.464,
                                              child: KText(
                                                text: zones[i].leaderName!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: width/5.464,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          zoneNameController.text = zones[i].zoneName!;
                                                          zoneIdController.text = zones[i].zoneId!;
                                                          leaderNameController.text = zones[i].leaderName!;
                                                          zoneAreasList.add("All Areas");
                                                          zones[i].areas!.forEach((element) {
                                                            zoneAreasList.add(element);
                                                          });
                                                          zones[i].supporters!.forEach((element) {
                                                            zoneHelpersList.add(element);
                                                          });
                                                          areaController.text = zoneAreasList.first;
                                                          currentTab = "View Members";
                                                        });
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration: const BoxDecoration(
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
                                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Icon(
                                                                  Icons.remove_red_eye,
                                                                  color: Colors.white,
                                                                  size: width/91.06666666666667,
                                                                ),
                                                                KText(
                                                                  text: "View",
                                                                  style: GoogleFonts.openSans(
                                                                    color: Colors.white,
                                                                    fontSize: width/136.6,
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
                                                          zoneAreasList.clear();
                                                          zoneHelpersList.clear();
                                                          zoneIdController.text = zones[i].zoneId!;
                                                          zoneNameController.text = zones[i].zoneName!;
                                                          leaderNameController.text = zones[i].leaderName!;
                                                          leaderPhoneController.text = zones[i].leaderPhone!;
                                                          zones[i].areas!.forEach((element) {
                                                            zoneAreasList.add(element);
                                                          });
                                                          zones[i].supporters!.forEach((element) {
                                                            zoneHelpersList.add(element);
                                                          });
                                                        });
                                                        editPopUp(zones[i],size);
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration: const BoxDecoration(
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
                                                          padding: const EdgeInsets.symmetric(horizontal: 6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Icon(
                                                                  Icons.add,
                                                                  color: Colors.white,
                                                                  size: width/91.06666666666667,
                                                                ),
                                                                KText(
                                                                  text: "Edit",
                                                                  style: GoogleFonts.openSans(
                                                                    color: Colors.white,
                                                                    fontSize: width/136.6,
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
                                                            text: "${zones[i].zoneName} will be deleted",
                                                            title: "Delete this Record?",
                                                            width: size.width * 0.4,
                                                            backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            showCancelBtn: true,
                                                            cancelBtnText: 'Cancel',
                                                            cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                            onConfirmBtnTap: () async {
                                                              FirebaseFirestore.instance.collection('Zones').doc(zones[i].id).delete();
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration: const BoxDecoration(
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
                                                          padding: const EdgeInsets.symmetric(
                                                              horizontal: 6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                              children: [
                                                                Icon(
                                                                  Icons.cancel_outlined,
                                                                  color: Colors.white,
                                                                  size: width/91.06666666666667,
                                                                ),
                                                                KText(
                                                                  text: "Delete",
                                                                  style: GoogleFonts.openSans(
                                                                    color: Colors.white,
                                                                    fontSize: width/136.6,
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
                                      ),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }return Container();
              },
            )
                : currentTab.toUpperCase() == "VIEW MEMBERS"
                ? Container(
              width: width/1.241,
              margin:   EdgeInsets.symmetric(
                  vertical: height/32.55,
                  horizontal: width/68.3
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
                            text: "View Members",
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
                    height: size.height * 0.73,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        )),
                    padding:   EdgeInsets.symmetric(
                        vertical: height/32.55,
                        horizontal: width/68.3
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: width / 4.553,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Zone ID",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: width / 105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    style: TextStyle(fontSize: width / 113.83),
                                    controller: zoneIdController,
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
                                    text: "Zone Name",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: width / 105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    style: TextStyle(fontSize: width / 113.83),
                                    controller: zoneNameController,
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
                                    text: "Leader Name",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: width / 105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    readOnly: true,
                                    style: TextStyle(fontSize: width / 113.83),
                                    controller: leaderNameController,
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height / 32.55),
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Areas",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width / 105.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: zoneAreasList.length,
                                  itemBuilder: (ctx,i){
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            setState(() {
                                              selectedTabIndex = i;
                                              areaController.text = zoneAreasList[i];
                                            });
                                          });
                                        },
                                        child: Container(
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color: selectedTabIndex == i ? Constants().primaryAppColor : Colors.white,
                                            border: Border.all(color: selectedTabIndex == i ? Colors.white : Constants().primaryAppColor),
                                            borderRadius: BorderRadius.circular(10),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(horizontal: 20),
                                            child: KText(
                                              text: zoneAreasList[i],
                                              style: GoogleFonts.openSans(
                                                color: selectedTabIndex == i ? Colors.white : Colors.black,
                                                fontSize: 14,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              )
                              // DropdownButton(
                              //   isExpanded: true,
                              //   value: areaController.text,
                              //   icon: Icon(Icons.keyboard_arrow_down),
                              //   underline: Container(),
                              //   items: zoneAreasList.map((items) {
                              //     return DropdownMenuItem(
                              //       value: items,
                              //       child: Text(items),
                              //     );
                              //   }).toList(),
                              //   onChanged: (newValue) {
                              //     setState(() {
                              //       areaController.text = newValue.toString();
                              //     });
                              //   },
                              // ),
                            ],
                          ),
                        ),
                        SizedBox(height: height / 32.55),
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          height: height/10.85,
                          width: double.infinity,
                          color: Constants().primaryAppColor,
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
                                    "Member in Area",
                                    style: GoogleFonts.openSans(
                                      color: currentTabIndex == 0
                                          ? Constants().btnTextColor
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
                                    "Zone Leader Supporters",
                                    style: GoogleFonts.openSans(
                                      color: currentTabIndex == 1
                                          ? Constants().btnTextColor
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
                        SizedBox(height: height / 32.55),
                        SizedBox(
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  width: width/13.66,
                                  child: KText(
                                    text: "No.",
                                    style: GoogleFonts.poppins(
                                      fontSize: width/105.0769230769231,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width/6.83,
                                  child: KText(
                                    text: "Name",
                                    style: GoogleFonts.poppins(
                                      fontSize: width/105.0769230769231,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width/6.83,
                                  child: KText(
                                    text: "Phone",
                                    style: GoogleFonts.poppins(
                                      fontSize: width/105.0769230769231,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: width/5.464,
                                  child: KText(
                                    text: "Address",
                                    style: GoogleFonts.poppins(
                                      fontSize: width/105.0769230769231,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                // SizedBox(
                                //   width: width/5.464,
                                //   child: KText(
                                //     text: "Actions",
                                //     style: GoogleFonts.poppins(
                                //       fontSize: width/105.0769230769231,
                                //       fontWeight: FontWeight.w600,
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            dragStartBehavior: DragStartBehavior.down,
                            physics: const NeverScrollableScrollPhysics(),
                            controller: _tabController,
                            children: [
                              FutureBuilder(
                                  future: getMembersForArea(areaController.text,zoneAreasList),
                                  //future: FirebaseFirestore.instance.collection('Users').where("address", isEqualTo: areaController.text).get(),
                                  builder: (context,snap) {
                                    if(snap.hasData){
                                      var val = snap.data!;
                                      return ListView.builder(
                                        itemCount: val.length,
                                        itemBuilder: (ctx, i) {
                                          var data = val[i];
                                          return Container(
                                            height: height/10.85,
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
                                            child: Padding(
                                              padding: const EdgeInsets.all(5.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    width: width/13.66,
                                                    child: KText(
                                                      text: (i + 1).toString(),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/6.83,
                                                    child: KText(
                                                      text: data.get("firstName") +" "+data.get("lastName"),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/6.83,
                                                    child: KText(
                                                      text: data.get("phone"),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width/5.464,
                                                    child: KText(
                                                      text: data.get("resistentialAddress"),
                                                      style: GoogleFonts.poppins(
                                                        fontSize: width/105.0769230769231,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: width/5.464,
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              viewPopup(MembersModel.fromJson(data.data() as Map<String,dynamic>));
                                                            },
                                                            child: Container(
                                                              height: height/26.04,
                                                              decoration: const BoxDecoration(
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
                                                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                    children: [
                                                                      Icon(
                                                                        Icons.remove_red_eye,
                                                                        color: Colors.white,
                                                                        size: width/91.06666666666667,
                                                                      ),
                                                                      KText(
                                                                        text: "View",
                                                                        style: GoogleFonts.openSans(
                                                                          color: Colors.white,
                                                                          fontSize: width/136.6,
                                                                          fontWeight: FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          // SizedBox(width: width/273.2),
                                                          // InkWell(
                                                          //   onTap: () {
                                                          //     setState(() {
                                                          //       zoneIdController.text = zones[i].zoneId!;
                                                          //       zoneNameController.text = zones[i].zoneName!;
                                                          //       leaderNameController.text = zones[i].leaderName!;
                                                          //       zones[i].areas!.forEach((element) {
                                                          //         zoneAreasList.add(element);
                                                          //       });
                                                          //     });
                                                          //     editPopUp(zones[i],size);
                                                          //   },
                                                          //   child: Container(
                                                          //     height: height/26.04,
                                                          //     decoration: const BoxDecoration(
                                                          //       color: Color(0xffff9700),
                                                          //       boxShadow: [
                                                          //         BoxShadow(
                                                          //           color: Colors.black26,
                                                          //           offset: Offset(1, 2),
                                                          //           blurRadius: 3,
                                                          //         ),
                                                          //       ],
                                                          //     ),
                                                          //     child: Padding(
                                                          //       padding: const EdgeInsets.symmetric(horizontal: 6),
                                                          //       child: Center(
                                                          //         child: Row(
                                                          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          //           children: [
                                                          //             Icon(
                                                          //               Icons.add,
                                                          //               color: Colors.white,
                                                          //               size: width/91.06666666666667,
                                                          //             ),
                                                          //             KText(
                                                          //               text: "Edit",
                                                          //               style: GoogleFonts.openSans(
                                                          //                 color: Colors.white,
                                                          //                 fontSize: width/136.6,
                                                          //                 fontWeight: FontWeight.bold,
                                                          //               ),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          // ),
                                                          // SizedBox(width: width/273.2),
                                                          // InkWell(
                                                          //   onTap: () {
                                                          //     CoolAlert.show(
                                                          //         context: context,
                                                          //         type: CoolAlertType.info,
                                                          //         text: "${zones[i].zoneName} will be deleted",
                                                          //         title: "Delete this Record?",
                                                          //         width: size.width * 0.4,
                                                          //         backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          //         showCancelBtn: true,
                                                          //         cancelBtnText: 'Cancel',
                                                          //         cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                          //         onConfirmBtnTap: () async {
                                                          //           FirebaseFirestore.instance.collection('Zones').doc(zones[i].id).delete();
                                                          //         }
                                                          //     );
                                                          //   },
                                                          //   child: Container(
                                                          //     height: height/26.04,
                                                          //     decoration: const BoxDecoration(
                                                          //       color: Color(0xfff44236),
                                                          //       boxShadow: [
                                                          //         BoxShadow(
                                                          //           color: Colors.black26,
                                                          //           offset: Offset(1, 2),
                                                          //           blurRadius: 3,
                                                          //         ),
                                                          //       ],
                                                          //     ),
                                                          //     child: Padding(
                                                          //       padding: const EdgeInsets.symmetric(
                                                          //           horizontal: 6),
                                                          //       child: Center(
                                                          //         child: Row(
                                                          //           mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                          //           children: [
                                                          //             Icon(
                                                          //               Icons.cancel_outlined,
                                                          //               color: Colors.white,
                                                          //               size: width/91.06666666666667,
                                                          //             ),
                                                          //             KText(
                                                          //               text: "Delete",
                                                          //               style: GoogleFonts.openSans(
                                                          //                 color: Colors.white,
                                                          //                 fontSize: width/136.6,
                                                          //                 fontWeight: FontWeight.bold,
                                                          //               ),
                                                          //             ),
                                                          //           ],
                                                          //         ),
                                                          //       ),
                                                          //     ),
                                                          //   ),
                                                          // )
                                                        ],
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    }
                                    return Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                              ),
                              ListView.builder(
                                itemCount: zoneHelpersList.length,
                                itemBuilder: (ctx, i) {
                                  var data = zoneHelpersList[i];
                                  return Container(
                                    height: height/10.85,
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
                                    child: Padding(
                                      padding: const EdgeInsets.all(5.0),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: width/13.66,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/6.83,
                                            child: KText(
                                              text: data.firstName! +" "+data.lastName!,
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/6.83,
                                            child: KText(
                                              text: data.phone!,
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/5.464,
                                            child: KText(
                                              text: data.resistentialAddress!,
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: width/5.464,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      viewPopup(data);
                                                    },
                                                    child: Container(
                                                      height: height/26.04,
                                                      decoration: const BoxDecoration(
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
                                                        padding: const EdgeInsets.symmetric(horizontal: 6),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.remove_red_eye,
                                                                color: Colors.white,
                                                                size: width/91.06666666666667,
                                                              ),
                                                              KText(
                                                                text: "View",
                                                                style: GoogleFonts.openSans(
                                                                  color: Colors.white,
                                                                  fontSize: width/136.6,
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
                                              )
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
                : Container()
          ],
        ),
      ),
    );
  }

  editPopUp(ZoneModel zone,Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setStat) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              height: size.height * 1.7,
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
                            text: "Edit Zone",
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
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Zone ID",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.571,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: height/108.5),
                                Material(
                                  borderRadius: BorderRadius.circular(5),
                                  color: Colors.white,
                                  elevation: 10,
                                  child: SizedBox(
                                    height: height/13.02,
                                    width: 200,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                      child: TextFormField(
                                        controller: zoneIdController,
                                        decoration: InputDecoration(
                                            border: InputBorder.none
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Zone Name",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: height/13.02,
                                        width: 250,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                          child: TextFormField(
                                            controller: zoneNameController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              counterText: "",
                                            ),
                                            maxLength: 40,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(width: width/68.3),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Leader Name",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        width: width/3.902,
                                        height: height/16.425,
                                        child: TypeAheadFormField(
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
                                            controller: leaderNameController,
                                          ),
                                          suggestionsCallback: (pattern) {
                                            return getSuggestionsstudent(pattern,membersList);
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
                                              leaderNameController.text = suggestion;
                                            });
                                            getLeaderByName();
                                          },
                                          suggestionsBoxController: suggestionBoxController,
                                          validator: (value) =>
                                          value!.isEmpty ? 'Please select a class' : null,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(width: width/68.3),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Leader Phone",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/97.571,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: height/108.5),
                                    Material(
                                      borderRadius: BorderRadius.circular(5),
                                      color: Colors.white,
                                      elevation: 10,
                                      child: SizedBox(
                                        height: height/13.02,
                                        width: 200,
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                          child: TextFormField(
                                            controller: leaderPhoneController,
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              counterText: "",
                                            ),
                                            maxLength: 40,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                            ],
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: height / 21.7),
                            Container(
                              height: 300,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Area",
                                        style: GoogleFonts.openSans(
                                          fontSize: width/97.571,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: height/108.5),
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        elevation: 10,
                                        child: SizedBox(
                                          height: 270,
                                          width: width * 0.35,
                                          child: ListView.builder(
                                            itemCount: areasList.length,
                                            itemBuilder: (ctx ,i){
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    KText(
                                                      text: areasList[i],
                                                      style: GoogleFonts.openSans(
                                                        fontSize: width/97.571,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: (){
                                                        setStat(() {
                                                          if(!zoneAreasList.contains(areasList[i])){
                                                            zoneAreasList.add(areasList[i]);
                                                          }
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.add_circle_outlined,
                                                        color: Constants().primaryAppColor,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(width: width/68.3),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Zone Area",
                                        style: GoogleFonts.openSans(
                                          fontSize: width/97.571,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: height/108.5),
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        elevation: 10,
                                        child: SizedBox(
                                          height: 270,
                                          width: width * 0.35,
                                          child: ListView.builder(
                                            itemCount: zoneAreasList.length,
                                            itemBuilder: (ctx ,i){
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    KText(
                                                      text: zoneAreasList[i],
                                                      style: GoogleFonts.openSans(
                                                        fontSize: width/97.571,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: (){
                                                        setStat(() {
                                                          zoneAreasList.removeAt(i);
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.remove_circle_outlined,
                                                        color: Constants().primaryAppColor,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height / 21.7),
                            Container(
                              height: 300,
                              width: double.infinity,
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Members",
                                        style: GoogleFonts.openSans(
                                          fontSize: width/97.571,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: height/108.5),
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        elevation: 10,
                                        child: SizedBox(
                                          height: 270,
                                          width: width * 0.35,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding: const EdgeInsets.only(right:0.0),
                                                    child: Text("Member Name",style: GoogleFonts.poppins(fontSize: 15,)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 0.0,right: 25),
                                                    child: Container(
                                                      width: width/3.902,
                                                      height: height/16.425,
                                                      //color: Color(0xffDDDEEE),
                                                      decoration: BoxDecoration(color: const Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),

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
                                                          controller: memberNameController,
                                                        ),
                                                        suggestionsCallback: (pattern) {
                                                          return getSuggestionsstudent(pattern,membersList);
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
                                                            memberNameController.text = suggestion;
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
                                                    child: Text("Member ID",style: GoogleFonts.poppins(fontSize: 15,)),
                                                  ),
                                                  Padding(
                                                    padding: const EdgeInsets.only(left: 0.0,right: 25),
                                                    child: Container(width: width/3.902,
                                                      height: height/16.425,
                                                      //color: Color(0xffDDDEEE),
                                                      decoration: BoxDecoration(color: const Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),child:
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
                                                          return getSuggestionsregno(pattern,membersList);
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
                                              SizedBox(height: 20),
                                              InkWell(
                                                onTap: (){
                                                  if(memberIdController.text != ""){
                                                    setStat(() {
                                                      zoneHelpersList.add(getMember());
                                                      memberIdController.clear();
                                                      memberNameController.clear();
                                                    });
                                                  }else{
                                                    CoolAlert.show(
                                                      context: context,
                                                      type: CoolAlertType.info,
                                                      title: "Member Not Found",
                                                      text: 'Please add member',
                                                      width: MediaQuery.of(context).size.width * 0.4,
                                                      backgroundColor: Constants()
                                                          .primaryAppColor
                                                          .withOpacity(0.8),
                                                    );
                                                  }
                                                },
                                                child: Container(
                                                  width: width/10.507,
                                                  height: height/16.425,
                                                  decoration: BoxDecoration(
                                                    color: Constants().primaryAppColor,
                                                    borderRadius: BorderRadius.circular(5),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "Add",
                                                      style: GoogleFonts.poppins(
                                                        color:Constants().btnTextColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(width: width/68.3),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Zone Leader Supporters",
                                        style: GoogleFonts.openSans(
                                          fontSize: width/97.571,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: height/108.5),
                                      Material(
                                        borderRadius: BorderRadius.circular(5),
                                        color: Colors.white,
                                        elevation: 10,
                                        child: SizedBox(
                                          height: 270,
                                          width: width * 0.35,
                                          child: ListView.builder(
                                            itemCount: zoneHelpersList.length,
                                            itemBuilder: (ctx ,i){
                                              return Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: Row(
                                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    KText(
                                                      text: "${zoneHelpersList[i].firstName!} ${zoneHelpersList[i].lastName!}",
                                                      style: GoogleFonts.openSans(
                                                        fontSize: width/97.571,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    IconButton(
                                                      onPressed: (){
                                                        setStat(() {
                                                          zoneHelpersList.removeAt(i);
                                                        });
                                                      },
                                                      icon: Icon(
                                                        Icons.remove_circle_outlined,
                                                        color: Constants().primaryAppColor,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: height / 21.7),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    if(zoneIdController.text != "" &&
                                        zoneNameController.text != "" &&
                                        leaderNameController.text != "" &&
                                        leaderPhoneController.text != ""
                                    ){
                                      Response response = await ZonalActivitiesFireCrud.updateZone(
                                        ZoneModel(
                                          zoneName: zoneNameController.text,
                                          zoneId: zoneIdController.text,
                                          leaderName: leaderNameController.text,
                                          areas: zoneAreasList,
                                          supporters: zoneHelpersList,
                                          leaderPhone: leaderPhoneController.text,
                                          id: zone.id,
                                          timestamp: zone.timestamp,
                                        ),
                                      );
                                      if (response.code == 200) {
                                        await CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: "Zone updated successfully!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                        clearTextControllers();
                                        setState(() {
                                          currentTab = 'View';
                                        });
                                        Navigator.pop(context);
                                      } else {
                                        await CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: "Failed to update Zone!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));

                                      }

                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
                                          text: "Update",
                                          style: GoogleFonts.openSans(
                                            color: Constants().btnTextColor,
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
                  ),
                ],
              ),
            )
          );
        });
      },
    );
  }

  Future<List<DocumentSnapshot>> getMembersForArea(String area,List<String> areaNames) async {
    List<DocumentSnapshot> users = [];
    membersCount = 0;

    //var userDoc = await FirebaseFirestore.instance.collection('Members').where((element) => element.get('resistentialAddress').toString().toLowerCase().contains(area.toLowerCase())).get();
    var userDoc = await FirebaseFirestore.instance.collection('Members').get();

    for(int i=0; i < userDoc.docs.length; i++){
      if(area.toLowerCase() != 'all areas'){
        if(userDoc.docs[i].get("resistentialAddress").toString().toLowerCase().contains(area.toLowerCase().toLowerCase())){
          setState(() {
            users.add(userDoc.docs[i]);
          });
        }
      }else{
        for(int a = 0; a < areaNames.length; a++){
          if(userDoc.docs[i].get("resistentialAddress").toString().toLowerCase().contains(areaNames[a].toLowerCase().toLowerCase())){
            setState(() {
              users.add(userDoc.docs[i]);
            });
          }
        }
      }
    }
    setState(() {
      membersCount = users.length;
    });
    return users;
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
                                      /*  KText(
                                        text: member.serviceLanguage!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      )*/
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

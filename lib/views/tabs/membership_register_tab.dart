import 'dart:html';
import 'package:church_management_admin/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:cool_alert/cool_alert.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:show_up_animation/show_up_animation.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';
import '../prints/print_membership_payment.dart';

class MembershipRegisterTab extends StatefulWidget {
  const MembershipRegisterTab({super.key});

  @override
  State<MembershipRegisterTab> createState() => _MembershipRegisterTabState();
}

class _MembershipRegisterTabState extends State<MembershipRegisterTab> {
  final _formkey = GlobalKey<FormState>();

  List<MembersWithDetails> membersList = [];

  TextEditingController memberNameController = TextEditingController();
  TextEditingController memberIdController = TextEditingController();
  String memberId = '';
  String selectedMonth = '';

  SuggestionsBoxController suggestionBoxController = SuggestionsBoxController();

  TextEditingController _typeAheadControllerfees = TextEditingController();
  TextEditingController _typeAheadControllerPaymentMode = TextEditingController();

  static final List<String> regno = [];
  static final List<String> student = [];

  static List<String> getSuggestionsregno(String query) {
    List<String> matches = <String>[];
    matches.addAll(regno);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }
  static List<String> getSuggestionsstudent(String query) {
    List<String> matches = <String>[];
    matches.addAll(student);
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  static List<String> getSuggestionsfees(String query) {
    List<String> matches = <String>[];
    matches.addAll(months);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  List<String> paymentModes = [
    "Card",
    "Cash",
    "UPI"
  ];

  List<String> getSuggestionsPaymentMode(String query) {
    List<String> matches = <String>[];
    matches.addAll(paymentModes);

    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }


  static final List<String> months = [];

  monthDrop() async {
    setState(() {
      months.clear();
    });
    List<String> payedMonths = [];
    var memberDoc = await cf.FirebaseFirestore.instance.collection('Members').doc(memberId).collection('Membership').get();
    memberDoc.docs.forEach((element) {
      payedMonths.add(element.id);
    });
    for (int i = 0; i <= DateTime.now().add(Duration(days: 365)).difference(DateTime.now().subtract(Duration(days: 365))).inDays; i++) {
      if(!months.contains(DateFormat('MMM yyyy').format(DateTime.now().subtract(Duration(days: 365)).add(Duration(days: i))))) {
        if(!payedMonths.contains(DateFormat('MMM yyyy').format(DateTime.now().subtract(Duration(days: 365)).add(Duration(days: i))))){
          months.add(DateFormat('MMM yyyy').format(DateTime.now().subtract(Duration(days: 365)).add(Duration(days: i))));
        }
      }
    }
  }

  getMemberById() async {
    var document = await cf.FirebaseFirestore.instance.collection("Members").get();
    for(int i=0;i<document.docs.length;i++){
        if(memberIdController.text == document.docs[i]["memberId"]){
          setState(() {
            memberNameController.text = document.docs[i]["firstName"]+" "+document.docs[i]["lastName"];
            memberId = document.docs[i].id;
          }
          );
        }
    }
  }

  getMemberByName() async {
    var document = await cf.FirebaseFirestore.instance.collection("Members").get();
    for(int i=0;i<document.docs.length;i++){
        if(memberNameController.text == document.docs[i]["firstName"]+" "+document.docs[i]["lastName"]){
          setState(() {
            memberIdController.text = document.docs[i]["memberId"];
            memberId = document.docs[i].id;
          });
        }
    }
  }

  updatefees({required String month,required String family,required String memberid,required String name,required String paymentMode}){
    cf.FirebaseFirestore.instance.collection("Members").doc(memberId).collection("Membership").doc(month).set({
      "date": "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "payOn": "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "payment" : true,
      "method" : "Accounts",
      "paymentMode" : paymentMode,
      "month" : month,
      "amount" : Constants.MembershipAmount,
      "time": DateFormat("hh:mm aa").format(DateTime.now()),
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });
    cf.FirebaseFirestore.instance.collection("MembershipReports").doc().set({
      "amount" : Constants.MembershipAmount,
      "date": "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "payOn": "${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
      "time": DateFormat("hh:mm aa").format(DateTime.now()),
      "family" : family,
      "memberId" : memberid,
      "method" : "Accounts",
      "paymentMode" : paymentMode,
      "name" : name,
      "month" : month,
      "timestamp": DateTime.now().millisecondsSinceEpoch,
    });

  }

  adddropdownvalue() async {
    setState(() {
      regno.clear();
      student.clear();
    });
    var document = await  cf.FirebaseFirestore.instance.collection("Members").orderBy("timestamp").get();
    var document2 = await  cf.FirebaseFirestore.instance.collection("Members").orderBy("firstName").get();
    for(int i=0;i<document.docs.length;i++) {
      setState(() {
        regno.add(document.docs[i]["memberId"]);
      });
    }
    for(int i=0;i<document2.docs.length;i++) {
      setState(() {
        student.add(document2.docs[i]["firstName"]+" "+document2.docs[i]["lastName"]);
      });
    }
  }

  String churchName = '';
  String churchAddress = '';
  String churchLogo = '';
  String churchPhone = '';

  getadmin() async {
    var document = await cf.FirebaseFirestore.instance.collection("ChurchDetails").get();
    setState(() {
      churchName = document.docs[0]["name"];
      churchAddress = "${document.docs[0]["area"]} ${document.docs[0]["city"]} ${document.docs[0]["pincode"]}";
      churchLogo = Constants.networkChurchLogo;
      churchPhone = document.docs[0]["phone"];
    });
  }

  @override
  void initState() {
    adddropdownvalue();
    getadmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            width: width/1.050,
            height: height/8.212,
            decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.only(left: 38.0,top: 30),
              child: Text("Membership Register",style: GoogleFonts.poppins(fontSize: 18,fontWeight: FontWeight.bold),),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Container(
              width:  width/1.050,
              decoration: BoxDecoration(color: Colors.white,borderRadius: BorderRadius.circular(12)),
              child:  Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0,top:0,bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
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
                        InkWell(
                          onTap: (){
                            getMemberByName();
                          },
                          child: Container(
                            child: Center(child: Text("Search",style: GoogleFonts.poppins(color:Constants().btnTextColor,),)),
                            width: width/10.507,
                            height: height/16.425,
                            // color:Color(0xff00A0E3),
                            decoration: BoxDecoration(
                                color: Constants().primaryAppColor,
                                borderRadius: BorderRadius.circular(5),
                            ),

                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left:25.0),
                          child: InkWell(
                            onTap: (){
                              setState(() {
                                memberIdController.text = "";
                                memberNameController.text = "";
                                memberId = "";
                              });
                            },
                            child: Container(child: Center(child: Text("Clear",style: GoogleFonts.poppins(color:Colors.white),)),
                              width: width/10.507,
                              height: height/16.425,
                              // color:Color(0xff00A0E3),
                              decoration: BoxDecoration(color:  Colors.red,borderRadius: BorderRadius.circular(5)),

                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  memberId == ""
                      ? Container(
                    height: size.height * 0.73,
                  )
                      :
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    child: SingleChildScrollView(
                      child: ShowUpAnimation(
                        curve: Curves.fastOutSlowIn,
                        direction: Direction.horizontal,
                        delayStart: Duration(milliseconds: 200),
                        child:
                        FutureBuilder<dynamic>(
                          future: cf.FirebaseFirestore.instance.collection('Members').doc(memberId).get(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData==null)
                            {
                              return Container(
                                  width: width/17.075,
                                  height: height/8.212,
                                  child: Center(child:CircularProgressIndicator(),));
                            }
                            Map<String,dynamic>?value = snapshot.data!.data();
                            return
                              Padding(
                                padding:EdgeInsets.only(left: width/93.3,top:0),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Material(
                                          elevation: 15,
                                          borderRadius: BorderRadius.circular(15),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color:Colors.white,
                                                borderRadius: BorderRadius.circular(15)
                                            ),
                                            width: width/4.44,
                                            height: height/1.600,
                                            child: Column(
                                              children: [
                                                SizedBox(height:height/30,),
                                                GestureDetector(
                                                  onTap: (){

                                                  },
                                                  child: CircleAvatar(
                                                    radius: width/26.6666,
                                                    backgroundImage: NetworkImage(value!['imgUrl']),

                                                  ),
                                                ),

                                                SizedBox(height:height/52.15,),
                                                Center(
                                                  child:Text('${value['firstName']+" "+value['lastName']}',style: GoogleFonts.montserrat(
                                                      fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                  ),),
                                                ),
                                                SizedBox(height:height/130.3,),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    Text('Member ID :',style: GoogleFonts.montserrat(
                                                        fontWeight:FontWeight.w500,color: Colors.black,fontSize: width/124.4
                                                    ),),
                                                    Text(value['memberId'],style: GoogleFonts.montserrat(
                                                        fontWeight:FontWeight.w500,color: Colors.black,fontSize: width/124.4
                                                    ),),
                                                  ],
                                                ),


                                                SizedBox(height:height/52.15),
                                                Divider(),
                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height:height/20.86),
                                                    SizedBox(width:width/62.2),
                                                    Text('Family Details',style: GoogleFonts.montserrat(
                                                        fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                    ),),
                                                  ],
                                                ),
                                                SizedBox(height: height/65.7,),
                                                Row(
                                                  children: [
                                                    SizedBox(width:width/62.2),
                                                    Material(
                                                      elevation: 7,
                                                      borderRadius: BorderRadius.circular(12),
                                                      shadowColor:  Constants().primaryAppColor,
                                                      child: Container(
                                                        height: height/8.212,
                                                        width: width/7.588,
                                                        decoration: BoxDecoration(
                                                            borderRadius: BorderRadius.circular(12),
                                                            border:Border.all(color:  Constants().primaryAppColor,),
                                                        ),
                                                        child:  Column(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            Text("Family / Family ID",style:GoogleFonts.montserrat(
                                                                fontWeight:FontWeight.w600,color: Colors.black,fontSize:width/98.13
                                                            ),),
                                                            SizedBox(height: height/65.7,),
                                                            ChoiceChip(
                                                              label: Text(
                                                                "${value["family"]} / ${value["familyid"]}",
                                                                style: TextStyle(color:Constants().btnTextColor,),
                                                              ),
                                                              onSelected: (bool selected) {},
                                                              selectedColor: Constants().primaryAppColor,
                                                              shape: StadiumBorder(
                                                                  side: BorderSide(
                                                                      color: Constants().primaryAppColor,)),
                                                              backgroundColor: Colors.white,
                                                              labelStyle: TextStyle(color: Colors.black),

                                                              elevation: 1.5, selected: true,),
                                                          ],
                                                        ),

                                                      ),


                                                    ),
                                                  ],
                                                ),
                                                Divider(),
                                                SizedBox(height:height/32.85,),
                                                Row(children: [
                                                  SizedBox(width:width/62.2),
                                                  Icon(Icons.call,),
                                                  SizedBox(width:width/373.2),
                                                  GestureDetector(onTap: (){

                                                  },
                                                    child: Text('${value["phone"]}',style: GoogleFonts.montserrat(
                                                        fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/124.4
                                                    ),),
                                                  ),
                                                ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(width:width/62.2,),
                                    Column(
                                      children: [
                                        Material(
                                          elevation: 15,
                                          borderRadius: BorderRadius.circular(15 ),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(15),
                                                color:Colors.white
                                            ),
                                            width:width/1.86,
                                            height:  height/1.600,
                                            child: Padding(
                                              padding: EdgeInsets.only(left:width/62.2,right:width/62.2),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  children: [
                                                    SizedBox(height:height/30,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.start,
                                                      children: [
                                                        Container(
                                                          width:160,
                                                          child: Row(
                                                            children: [
                                                              Text('Select Month',style: GoogleFonts.montserrat(
                                                                  fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                              ),),
                                                              InkWell(
                                                                onTap: (){
                                                                  monthDrop();
                                                                },
                                                                child: Padding(
                                                                  padding: const EdgeInsets.only(left: 4.0),
                                                                  child: Icon(Icons.refresh),
                                                                ),
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.only(left: 50.0,right: 25),
                                                          child: Container(width: width/4.83,
                                                            height: height/16.42,
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
                                                                controller: this._typeAheadControllerfees,
                                                              ),
                                                              suggestionsCallback: (pattern) {
                                                                return getSuggestionsfees(pattern);
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
                                                                  this._typeAheadControllerfees.text = suggestion;
                                                                  selectedMonth = _typeAheadControllerfees.text;
                                                                  monthDrop();
                                                                });

                                                              },
                                                              suggestionsBoxController: suggestionBoxController,
                                                              validator: (value) =>
                                                              value!.isEmpty ? 'Please select a fees': null,
                                                            ),

                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height:height/27,),
                                                    selectedMonth != ""
                                                        ? Column(
                                                      crossAxisAlignment: CrossAxisAlignment.center,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width:130,

                                                              child: Text('Month',style: GoogleFonts.montserrat(
                                                                  fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                              ),),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 50.0,right: 25),
                                                              child: Container(width: width/4.83,
                                                                  height: height/16.42,
                                                                  //color: Color(0xffDDDEEE),
                                                                  decoration: BoxDecoration(color: const Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),

                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(_typeAheadControllerfees.text,style: GoogleFonts.montserrat(
                                                                        fontWeight:FontWeight.w600,color: Colors.black,fontSize:width/85.13
                                                                    ),),
                                                                  )

                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height:height/37,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width:130,
                                                              child: Row(
                                                                children: [
                                                                  Text('Payement Mode',style: GoogleFonts.montserrat(
                                                                      fontWeight:FontWeight.bold,color: Colors.black,
                                                                      fontSize:width/101.13
                                                                  ),),
                                                                ],
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 50.0,right: 25),
                                                              child: Container(width: width/4.83,
                                                                height: height/16.42,
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
                                                                    controller: this._typeAheadControllerPaymentMode,
                                                                  ),
                                                                  suggestionsCallback: (pattern) {
                                                                    return getSuggestionsPaymentMode(pattern);
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
                                                                      this._typeAheadControllerPaymentMode.text = suggestion;
                                                                    });

                                                                  },
                                                                  suggestionsBoxController: suggestionBoxController,
                                                                  validator: (value) =>
                                                                  value!.isEmpty ? 'Please select a fees': null,
                                                                ),

                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height:height/37,),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.start,
                                                          children: [
                                                            Container(
                                                              width:130,
                                                              child: Text('Amount',style: GoogleFonts.montserrat(
                                                                  fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                              ),),
                                                            ),
                                                            Padding(
                                                              padding: const EdgeInsets.only(left: 50.0,right: 25),
                                                              child: Container(width: width/4.83,
                                                                  height: height/16.42,
                                                                  //color: Color(0xffDDDEEE),
                                                                  decoration: BoxDecoration(color: const Color(0xffDDDEEE),borderRadius: BorderRadius.circular(5)),

                                                                  child: Padding(
                                                                    padding: const EdgeInsets.all(8.0),
                                                                    child: Text(Constants.MembershipAmount,style: GoogleFonts.montserrat(
                                                                        fontWeight:FontWeight.w600,color: Colors.red,fontSize:width/85.13
                                                                    ),
                                                                    ),
                                                                  )
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                        SizedBox(height:height/25),
                                                        Row(
                                                          mainAxisAlignment: MainAxisAlignment.center,
                                                          children: [
                                                            GestureDetector(
                                                              onTap: () async {
                                                                await updatefees(
                                                                  paymentMode: _typeAheadControllerPaymentMode.text,
                                                                    name: value["firstName"]+" "+value["lastName"],family: value["family"],memberid: value["memberId"],month: selectedMonth
                                                                );
                                                                await CoolAlert.show(
                                                                    context: context,
                                                                    type: CoolAlertType.success,
                                                                    text: "Payment completed successfully!",
                                                                    width: size.width * 0.4,
                                                                    confirmBtnText: 'Ok & Print',
                                                                    onConfirmBtnTap: () async {
                                                                      MembershipPaymentPdfModel paymentDetails = MembershipPaymentPdfModel(
                                                                        date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                                                        time: DateFormat('hh:mm aa').format(DateTime.now()),
                                                                        amount: Constants.MembershipAmount,
                                                                        month: selectedMonth,
                                                                        churchAddress: churchAddress,
                                                                        churchName: churchName,
                                                                        churchLogo: churchLogo,
                                                                        churchPhone: churchPhone,
                                                                        memberAddress: value["address"],
                                                                        memberName: value["firstName"]+" "+value["lastName"],
                                                                        paymentMode: _typeAheadControllerPaymentMode.text,
                                                                      );
                                                                      await generateMembershipPaymentPdf(PdfPageFormat.a4, paymentDetails);
                                                                      //savePdfToFile(data);
                                                                    },
                                                                    backgroundColor: Constants()
                                                                        .primaryAppColor
                                                                        .withOpacity(0.8),
                                                                );
                                                                setState(() {
                                                                  selectedMonth = '';
                                                                  _typeAheadControllerfees.clear();
                                                                  _typeAheadControllerPaymentMode.clear();
                                                                });
                                                              },
                                                              child: Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Container(
                                                                  height: height/16.425,
                                                                  // color:Color(0xff00A0E3),
                                                                  decoration: BoxDecoration(color: Constants().primaryAppColor,borderRadius: BorderRadius.circular(5)),
                                                                  child: Center(
                                                                      child: Padding(
                                                                        padding: const EdgeInsets.symmetric(horizontal: 20),
                                                                        child: Text("Payment Received & Print Receipt",style: GoogleFonts.poppins(color:Colors.white,fontWeight: FontWeight.w600),),
                                                                      )),

                                                                ),
                                                              ),
                                                            ),
                                                            // SizedBox(width:20),
                                                            // GestureDetector(
                                                            //   onTap: () async {
                                                            //     // StudentFeesPdfModel feesDetails = StudentFeesPdfModel(
                                                            //     //   date: DateFormat('dd/MM/yyyy').format(DateTime.now()),
                                                            //     //   time: DateFormat('hh:mm aa').format(DateTime.now()),
                                                            //     //   amount: value2["amount"].toString(),
                                                            //     //   feesName: value2["feesname"].toString(),
                                                            //     //   schoolAdderss: schooladdress,
                                                            //     //   schoolName: schoolname,
                                                            //     //   schoolLogo: schoollogo,
                                                            //     //   schoolPhone: schoolphone,
                                                            //     //   studentAddress: value['address'].toString(),
                                                            //     //   studentName: value['stname'].toString(),
                                                            //     // );
                                                            //     // setState(() {
                                                            //     //   isloading = true;
                                                            //     // });
                                                            //     // await generateInvoice(PdfPageFormat.a4,feesDetails);
                                                            //     // setState(() {
                                                            //     //   isloading = false;
                                                            //     // });
                                                            //   },
                                                            //   child: Padding(
                                                            //     padding: const EdgeInsets.all(8.0),
                                                            //     child: Container(child: Center(child: Text("",style: GoogleFonts.poppins(color:Colors.white,fontWeight: FontWeight.w600),)),
                                                            //       width: width/5.464,
                                                            //       height: height/16.425,
                                                            //       // color:Color(0xff00A0E3),
                                                            //       decoration: BoxDecoration(color: Constants().primaryAppColor,borderRadius: BorderRadius.circular(5)),
                                                            //     ),
                                                            //   ),
                                                            // ),
                                                          ],
                                                        ),
                                                      ],) : Container(),
                                                    Row(
                                                      children: [
                                                        Container(

                                                          child: Text('Previous Payments,',style: GoogleFonts.montserrat(
                                                              fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                          ),),
                                                        ),
                                                      ],
                                                    ),
                                                    SizedBox(height: 15,),
                                                    Row(
                                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                      children: [
                                                        Container(
                                                          width:130,
                                                          child: Text('Month',style: GoogleFonts.montserrat(
                                                              fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                          ),),
                                                        ),
                                                        Container(
                                                          width:130,
                                                          child: Text('Amount',style: GoogleFonts.montserrat(
                                                              fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                          ),),
                                                        ),
                                                        Container(
                                                          width:130,
                                                          child: Text('Status',style: GoogleFonts.montserrat(
                                                              fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                          ),),
                                                        ),
                                                        Container(
                                                          width:130,
                                                          child: Text('Date',style: GoogleFonts.montserrat(
                                                              fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                          ),),
                                                        ),
                                                        Container(
                                                          width:130,
                                                          child: Text('Time',style: GoogleFonts.montserrat(
                                                              fontWeight:FontWeight.bold,color: Colors.black,fontSize:width/81.13
                                                          ),),
                                                        ),
                                                      ],
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Divider(),
                                                    ),
                                                    StreamBuilder(
                                                        stream: cf.FirebaseFirestore.instance.collection("Members").doc(memberId).collection("Membership").orderBy("timestamp").snapshots(),
                                                        builder: (context,snapshot){
                                                          double totalAmount = 0.0;
                                                          snapshot.data!.docs.forEach((element) {
                                                            if(element.get("payment") == true){
                                                              totalAmount += double.parse(element.get("amount").toString());
                                                            }
                                                          });
                                                          return Column(
                                                            children: [
                                                              ListView.builder(
                                                                  shrinkWrap: true,
                                                                  physics: NeverScrollableScrollPhysics(),
                                                                  itemCount: snapshot.data!.docs.length,
                                                                  itemBuilder: (context,index){
                                                                    return snapshot.data!.docs[index]["payment"]==true?
                                                                      Row(
                                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                                        children: [
                                                                          Container(
                                                                            width:130,
                                                                            child: Text(
                                                                              snapshot.data!.docs[index].id.toString(),//snapshot.data!.docs[index]["feesname"],
                                                                              style: GoogleFonts.montserrat(
                                                                                fontWeight:FontWeight.w600,color: Colors.black,fontSize:width/91.13
                                                                            ),),
                                                                          ),
                                                                          Container(
                                                                            width:130,
                                                                            child: Text(
                                                                              snapshot.data!.docs[index]["amount"].toString(),
                                                                              style: GoogleFonts.montserrat(
                                                                                fontWeight:FontWeight.w600,color: Colors.black,fontSize:width/91.13
                                                                            ),),
                                                                          ),
                                                                          Container(
                                                                            width:130,
                                                                            child: Text(
                                                                     snapshot.data!.docs[index]["payment"]==true?"Paid": "Unpaid",
                                                                     style: GoogleFonts.montserrat(
                                                                                fontWeight:FontWeight.bold,color:snapshot.data!.docs[index]["payment"]==true? Color(0xff53B175):Colors.red,fontSize:width/91.13
                                                                            ),),
                                                                          ),
                                                                          Container(
                                                                            width:130,
                                                                            child: Text(
                                                                              snapshot.data!.docs[index]["date"],
                                                                              style: GoogleFonts.montserrat(
                                                                                fontWeight:FontWeight.w600,color: Colors.black,fontSize:width/91.13
                                                                            ),),
                                                                          ),
                                                                          Container(
                                                                            width:130,
                                                                            child: Text(
                                                                              snapshot.data!.docs[index]["time"],
                                                                              style: GoogleFonts.montserrat(
                                                                                fontWeight:FontWeight.w600,color: Colors.black,fontSize:width/91.13
                                                                            ),),
                                                                          ),
                                                                        ],
                                                                      )  : Container();
                                                                  }),
                                                              Padding(
                                                                padding: const EdgeInsets.all(8.0),
                                                                child: Material(
                                                                  elevation: 4,
                                                                  borderRadius: BorderRadius.circular(10),
                                                                  child: Container(
                                                                    height: 50,
                                                                    width: double.infinity,
                                                                    decoration: BoxDecoration(
                                                                      color: Colors.white,
                                                                      borderRadius:   BorderRadius.circular(10),
                                                                    ),
                                                                    child: Padding(
                                                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                                                                      child: Row(
                                                                        mainAxisAlignment: MainAxisAlignment.end,
                                                                        children: [
                                                                          Text(
                                                                            "Total : ",//snapshot.data!.docs[index]["feesname"],
                                                                            style: GoogleFonts.montserrat(
                                                                                fontWeight:FontWeight.w600,color: Colors.black,fontSize:width/91.13
                                                                            ),),
                                                                          Text(
                                                                            "$totalAmount",//snapshot.data!.docs[index]["feesname"],
                                                                            style: GoogleFonts.montserrat(
                                                                                fontWeight:FontWeight.w600,color: Colors.black,fontSize:width/91.13
                                                                            ),),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              )
                                                            ],
                                                          );

                                                        }),



                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],)
                                  ],),
                              );
                          },
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ),
          ),
          SizedBox(height: size.height * 0.04),
          const DeveloperCardWidget(),
          SizedBox(height: size.height * 0.01),
        ],
      ),
    );
  }

  // void savePdfToFile(data) async {
  //   final blob = Blob([data],'application/pdf');
  //   final url = Url.createObjectUrlFromBlob(blob);
  //   final anchor = AnchorElement(href: url)
  //     ..setAttribute("download", "Membership_Payment.pdf")
  //     ..click();
  //   Url.revokeObjectUrl(url);
  // }

}

class MembersWithDetails {
  MembersWithDetails(
      {required this.name, required this.familyName, required this.memberId, required this.docId});

  String name;
  String memberId;
  String familyName;
  String docId;
}

class MembershipPaymentPdfModel {
  MembershipPaymentPdfModel(
      {
        required this.churchName,
        required this.churchAddress,
        required this.churchPhone,
        required this.memberName,
        required this.churchLogo,
        required this.memberAddress,
        required this.month,
        required this.amount,
        required this.date,
        required this.time,
        required this.paymentMode
      }
      );

  String churchName;
  String churchAddress;
  String churchPhone;
  String memberName;
  String churchLogo;
  String memberAddress;
  String month;
  String amount;
  String date;
  String time;
  String paymentMode;
}

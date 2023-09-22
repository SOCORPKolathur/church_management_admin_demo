import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../models/department_model.dart';
import '../../services/department_firecrud.dart';
import '../../widgets/kText.dart';

class ComNotificationsTab extends StatefulWidget {
  const ComNotificationsTab({super.key});

  @override
  State<ComNotificationsTab> createState() => _ComNotificationsTabState();
}

class _ComNotificationsTabState extends State<ComNotificationsTab> {

  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController genderController = TextEditingController(text: 'Select Gender');
  TextEditingController classController = TextEditingController(text: 'Select Class');

  bool isAll = false;
  bool isStudent = false;
  bool isMarried = false;
  bool isSingle = false;

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
              child: KText(
                text: "NOTIFICATIONS",
                style: GoogleFonts.openSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            Container(
              height: size.height * 0.97,
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
                          const Icon(Icons.message),
                          const SizedBox(width: 10),
                          KText(
                            text: "Send Notification",
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: SizedBox(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Gender",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                          BorderRadius.circular(10),
                                          boxShadow: const [
                                            BoxShadow(
                                              color: Colors.black26,
                                              blurRadius: 3,
                                              offset: Offset(2, 3),
                                            )
                                          ],
                                        ),
                                        child: DropdownButton(
                                          underline: Container(),
                                          value: genderController.text,
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
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Marital Status",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: isMarried,
                                                onChanged: (val){
                                                  setState(() {
                                                    isMarried = val!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                              const Text("Married")
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: isSingle,
                                                onChanged: (val){
                                                  setState(() {
                                                    isSingle = val!;
                                                  });
                                                },
                                              ),
                                              const SizedBox(width: 10),
                                              const Text("Single")
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Student",
                                        style: GoogleFonts.openSans(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Column(
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: isStudent,
                                                onChanged: (val){
                                                  setState(() {
                                                    isStudent = val!;
                                                  });
                                                },
                                              ),
                                              SizedBox(width: 10),
                                              Text("Student")
                                            ],
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Visibility(
                                    visible: isStudent,
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Class",
                                          style: GoogleFonts.openSans(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                            BorderRadius.circular(10),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                blurRadius: 3,
                                                offset: Offset(2, 3),
                                              )
                                            ],
                                          ),
                                          child: DropdownButton(
                                            underline: Container(),
                                            value: classController.text,
                                            items: ["Select Class", "LKG", "UKG", "I","II","III","IV","V","VI","VII","VIII","XI","X","XI","XII"]
                                                .map((items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                classController.text = newValue!;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: isAll,
                                        onChanged: (val){
                                          setState(() {
                                            isAll = val!;
                                          });
                                          if(isAll){
                                            setState(() {
                                              isStudent = true;
                                              isMarried = true;
                                              isSingle = true;
                                            });
                                          }else{
                                            setState(() {
                                              isStudent = false;
                                              isMarried = false;
                                              isSingle = false;
                                            });
                                          }
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      const  Text("ALL")
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Subject",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: const TextStyle(fontSize: 12),
                                    controller: subjectController,
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 25),
                                child: KText(
                                  text: "Description",
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
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
                                            style:
                                            const TextStyle(fontSize: 12),
                                            controller: descriptionController,
                                            decoration: const InputDecoration(
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
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: ()  {
                                  sendNotification();
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
                                      child: Row(
                                        children: [
                                          const Icon(Icons.send,
                                              color: Colors.white),
                                          const SizedBox(width: 5),
                                          KText(
                                            text: "SEND",
                                            style: GoogleFonts.openSans(
                                              color: Colors.white,
                                              fontSize: 10,
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
            ),
            StreamBuilder(
              stream: DepartmentFireCrud.fetchDepartments(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<DepartmentModel> email = [];
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
                                  text: "Notifications (${email.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.7 > 70 + email.length * 60
                              ? 70 + email.length * 60
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
                                        width: 80,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 110,
                                        child: KText(
                                          text: "Time",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: KText(
                                          text: "To",
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
                                        child: KText(
                                          text: "Subject",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: KText(
                                          text: "Content",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 200,
                                        child: KText(
                                          text: "SMS Network",
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 150,
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
                                  itemCount: 0,
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
                                            width: 80,
                                            child: KText(
                                              text: (i + 1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text: "departments[i].name!",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 180,
                                            child: KText(
                                              text:
                                              "departments[i].leaderName!",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 170,
                                            child: KText(
                                              text:
                                              "departments[i].contactNumber!",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: KText(
                                              text: "departments[i].location!",
                                              style: GoogleFonts.poppins(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                              width: 200,
                                              child: Row(
                                                children: [
                                                  InkWell(
                                                    onTap: () {},
                                                    child: Container(
                                                      height: 25,
                                                      decoration:
                                                      const BoxDecoration(
                                                        color:
                                                        Color(0xff2baae4),
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
                                                  const SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () {},
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
                                                  const SizedBox(width: 5),
                                                  InkWell(
                                                    onTap: () {},
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
            )
          ],
        ),
      ),
    );
  }

  sendNotification() async {
    List<String> userFcmList = [];
    var documentUsers = await FirebaseFirestore.instance.collection('Users').get();
    var documentStudents = await FirebaseFirestore.instance.collection('Students').get();
    if(isAll){
      documentUsers.docs.forEach((element) {
        if(element['fcmToken'] != ""){
          userFcmList.add(element['fcmToken']);
        }
      });
      documentStudents.docs.forEach((element) { 
        for(int i = 0; i < documentUsers.docs.length; i ++){
          if(documentUsers.docs[i]['phone'] == element.get('phone')){
            userFcmList.add(documentUsers.docs[i]['fcmToken']);
          }
        }
      });
    }else{
      if(isMarried){
        documentUsers.docs.forEach((element) {
          if(element['fcmToken'] != "" && element['maritialStatus'].toString().toLowerCase() == 'married'){
            userFcmList.add(element['fcmToken']);
          }
        });
      }else{
        documentUsers.docs.forEach((element) {
          if(element['fcmToken'] != "" && element['maritialStatus'].toString().toLowerCase() == 'single'){
            userFcmList.add(element['fcmToken']);
          }
        });
      }
      if(genderController.text.toLowerCase() == "male"){
        documentUsers.docs.forEach((element) {
          if(element['fcmToken'] != "" && element['gender'].toString().toLowerCase() == 'male'){
            userFcmList.add(element['fcmToken']);
          }
        });
      }else if(genderController.text.toLowerCase() == "female"){
        documentUsers.docs.forEach((element) {
          if(element['fcmToken'] != "" && element['gender'].toString().toLowerCase() == 'female'){
            userFcmList.add(element['fcmToken']);
          }
        });
      }
      if(isStudent){
        if(classController.text != "Select Class"){
          documentStudents.docs.forEach((element) {
            if(element['clasS'] == classController.text){
              for(int i = 0; i < documentUsers.docs.length; i ++){
                if(documentUsers.docs[i]['phone'] == element.get('guardianPhone')){
                  userFcmList.add(documentUsers.docs[i]['fcmToken']);
                }
              }
            }
          });
        }else{
          documentStudents.docs.forEach((element) {
            for(int i = 0; i < documentUsers.docs.length; i ++){
              if(documentUsers.docs[i]['phone'] == element.get('guardianPhone')){
                userFcmList.add(documentUsers.docs[i]['fcmToken']);
              }
            }
          });
        }
      }
    }
    userFcmList.forEach((token) async {
      bool isSended = await sendPushMessage(token, descriptionController.text, subjectController.text);
      if(isSended){
        subjectController.clear();
        descriptionController.clear();
        classController.text = 'Select Class';
        genderController.text = 'Select Gender';
        setState(() {
          isAll = false;
          isStudent = false;
          isMarried = false;
          isSingle = false;
        });
      }else{
        print("Succesfully Sended");
      }
    });
  }

  Future<bool> sendPushMessage(String token, String body, String title) async {
    bool isSended = false;
    try {
      var response = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
          'key=AAAAuzKqCXA:APA91bHpckZw1E2JuVr8MTPvoic6pDOOtxmTddTsSBno2ZYd3fMDo7kFmbsHHRfmuZurh0ut8n_46FgPAI5YdtfpwmJk85o9qeTMca9QgVhy7CiDUOdSer_ifyqaAQcGtF_oyBaX8UMQ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{'body': body, 'title': title},
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": token,
          },
        ),
      );
      if(response.statusCode == 200 || response.statusCode == 201){
        isSended = true;
      }else{
        isSended = false;
      }
    } catch (e) {
      print("error push notification");
    }
    return isSended;
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

import 'dart:convert';
import 'package:church_management_admin/models/chorus_model.dart';
import 'package:church_management_admin/models/church_staff_model.dart';
import 'package:church_management_admin/models/committee_model.dart';
import 'package:church_management_admin/models/department_model.dart';
import 'package:church_management_admin/models/members_model.dart';
import 'package:church_management_admin/models/notification_model.dart';
import 'package:church_management_admin/models/pastors_model.dart';
import 'package:church_management_admin/models/student_model.dart';
import 'package:church_management_admin/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../../constants.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';

class ComNotificationsTab extends StatefulWidget {
  ComNotificationsTab({super.key});

  @override
  State<ComNotificationsTab> createState() => _ComNotificationsTabState();
}

class _ComNotificationsTabState extends State<ComNotificationsTab> {
  List<UserModel> totalusersList = [];
  TextEditingController subjectController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController genderController = TextEditingController(text: 'Select Gender');
  TextEditingController classController = TextEditingController(text: 'Select Class');
  String dropdownValue = 'Select Blood Group';
  String searchString = '';
  bool isAllUsers = false;
  bool isUsers = false;
  bool isPastors = false;
  bool isMembers = false;
  bool isCommittee = false;
  bool isStudent = false;
  bool isChorus = false;
  bool isChurchStaff = false;
  bool isDepartment = false;
  bool isMarried = false;
  bool isSingle = false;

  List<UserModel> usersList = [];
  List<MembersModel> membersList = [];
  List<PastorsModel> pastorsList = [];
  List<StudentModel> studentsList = [];
  List<ChurchStaffModel> churchStaffsList = [];
  List<CommitteeModel> committiesList = [];
  List<ChorusModel> chorusesList = [];
  List<DepartmentModel> departmentsList = [];
  List<MembersModel> genderusersList = [];
  List<UserModel> bloodusersList = [];
  List<UserModel> singleusersList = [];
  List<UserModel> marriedusersList = [];
  List<MembersModel> picodeUserList = [];

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
                    text: "NOTIFICATIONS",
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
                              text: currentTab.toUpperCase() == "VIEW" ? "Send Notification" : "View Notifications",
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
                 height: size.height * 0.97,
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
                      padding: EdgeInsets.symmetric( horizontal: width/68.3, vertical: height/81.375),
                      child: Row(
                        children: [
                          Icon(Icons.message),
                          SizedBox(width:width/136.6),
                          KText(
                            text: "Send Notification",
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
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Padding(
                          //   padding: EdgeInsets.only(left: width/54.64),
                          //   child: SizedBox(
                          //     width: double.infinity,
                          //     child: Row(
                          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //       children: [
                          //         Column(
                          //           crossAxisAlignment:
                          //           CrossAxisAlignment.start,
                          //           children: [
                          //             KText(
                          //               text: "Gender",
                          //               style: GoogleFonts.openSans(
                          //                 fontSize: width/97.57,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             SizedBox(height: 6),
                          //             Container(
                          //               decoration: BoxDecoration(
                          //                 color: Colors.white,
                          //                 borderRadius:
                          //                 BorderRadius.circular(10),
                          //                 boxShadow: [
                          //                   BoxShadow(
                          //                     color: Colors.black26,
                          //                     blurRadius: 3,
                          //                     offset: Offset(2, 3),
                          //                   )
                          //                 ],
                          //               ),
                          //               child: DropdownButton(
                          //                 underline: Container(),
                          //                 value: genderController.text,
                          //                 items: [
                          //                   "Select Gender",
                          //                   "Male",
                          //                   "Female",
                          //                   "Transgender"
                          //                 ].map((items) {
                          //                   return DropdownMenuItem(
                          //                     value: items,
                          //                     child: Text(items),
                          //                   );
                          //                 }).toList(),
                          //                 onChanged: (newValue) {
                          //                   setState(() {
                          //                     genderController.text = newValue!;
                          //                   });
                          //                 },
                          //               ),
                          //             )
                          //           ],
                          //         ),
                          //         Column(
                          //           crossAxisAlignment:
                          //           CrossAxisAlignment.start,
                          //           children: [
                          //             KText(
                          //               text: "Marital Status",
                          //               style: GoogleFonts.openSans(
                          //                 fontSize: width/97.57,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             SizedBox(height: 6),
                          //             Column(
                          //               crossAxisAlignment: CrossAxisAlignment.start,
                          //               children: [
                          //                 Row(
                          //                   children: [
                          //                     Checkbox(
                          //                       value: isMarried,
                          //                       onChanged: (val){
                          //                         setState(() {
                          //                           isMarried = val!;
                          //                         });
                          //                       },
                          //                     ),
                          //                     SizedBox(width:width/136.6),
                          //                     Text("Married")
                          //                   ],
                          //                 ),
                          //                 Row(
                          //                   children: [
                          //                     Checkbox(
                          //                       value: isSingle,
                          //                       onChanged: (val){
                          //                         setState(() {
                          //                           isSingle = val!;
                          //                         });
                          //                       },
                          //                     ),
                          //                     SizedBox(width:width/136.6),
                          //                     Text("Single")
                          //                   ],
                          //                 ),
                          //               ],
                          //             )
                          //           ],
                          //         ),
                          //         Column(
                          //           crossAxisAlignment:
                          //           CrossAxisAlignment.start,
                          //           children: [
                          //             KText(
                          //               text: "Student",
                          //               style: GoogleFonts.openSans(
                          //                 fontSize: width/97.57,
                          //                 fontWeight: FontWeight.bold,
                          //               ),
                          //             ),
                          //             SizedBox(height: 6),
                          //             Column(
                          //               children: [
                          //                 Row(
                          //                   children: [
                          //                     Checkbox(
                          //                       value: isStudent,
                          //                       onChanged: (val){
                          //                         setState(() {
                          //                           isStudent = val!;
                          //                         });
                          //                       },
                          //                     ),
                          //                     SizedBox(width:width/136.6),
                          //                     Text("Student")
                          //                   ],
                          //                 ),
                          //               ],
                          //             )
                          //           ],
                          //         ),
                          //         Visibility(
                          //           visible: isStudent,
                          //           child: Column(
                          //             crossAxisAlignment:
                          //             CrossAxisAlignment.start,
                          //             children: [
                          //               KText(
                          //                 text: "Class",
                          //                 style: GoogleFonts.openSans(
                          //                   fontSize: width/97.57,
                          //                   fontWeight: FontWeight.bold,
                          //                 ),
                          //               ),
                          //               SizedBox(height: 6),
                          //               Container(
                          //                 decoration: BoxDecoration(
                          //                   color: Colors.white,
                          //                   borderRadius:
                          //                   BorderRadius.circular(10),
                          //                   boxShadow: [
                          //                     BoxShadow(
                          //                       color: Colors.black26,
                          //                       blurRadius: 3,
                          //                       offset: Offset(2, 3),
                          //                     )
                          //                   ],
                          //                 ),
                          //                 child: DropdownButton(
                          //                   underline: Container(),
                          //                   value: classController.text,
                          //                   items: ["Select Class", "LKG", "UKG", "I","II","III","IV","V","VI","VII","VIII","XI","X","XI","XII"]
                          //                       .map((items) {
                          //                     return DropdownMenuItem(
                          //                       value: items,
                          //                       child: Text(items),
                          //                     );
                          //                   }).toList(),
                          //                   onChanged: (newValue) {
                          //                     setState(() {
                          //                       classController.text = newValue!;
                          //                     });
                          //                   },
                          //                 ),
                          //               )
                          //             ],
                          //           ),
                          //         ),
                          //         Row(
                          //           children: [
                          //             Checkbox(
                          //               value: isAll,
                          //               onChanged: (val){
                          //                 setState(() {
                          //                   isAll = val!;
                          //                 });
                          //                 if(isAll){
                          //                   setState(() {
                          //                     isStudent = true;
                          //                     isMarried = true;
                          //                     isSingle = true;
                          //                   });
                          //                 }else{
                          //                   setState(() {
                          //                     isStudent = false;
                          //                     isMarried = false;
                          //                     isSingle = false;
                          //                   });
                          //                 }
                          //               },
                          //             ),
                          //             SizedBox(width:width/136.6),
                          //              Text("ALL")
                          //           ],
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          // SizedBox(height: height/65.1),
                          Padding(
                            padding: EdgeInsets.only(left: width/54.64),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/5.464,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isUsers,
                                            onChanged: (val) {
                                              setState(() {
                                                isUsers = val!;
                                              });
                                              if(isUsers) {
                                                addUserPopUp(usersList,"Users");
                                              }else{
                                                usersList.clear();
                                              }
                                            },
                                          ),
                                          SizedBox(width:width/136.6),
                                          Text("Users")
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/5.464,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isPastors,
                                            onChanged: (val) {
                                              setState(() {
                                                isPastors = val!;
                                              });
                                              if(isPastors) {
                                                addPastorPopUp(pastorsList);
                                              }else{
                                                pastorsList.clear();
                                              }
                                            },
                                          ),
                                          SizedBox(width:width/136.6),
                                          Text("Pastors")
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/5.464,
                                      child: Row(
                                        children: [
                                          Text("Gender"),
                                          SizedBox(width:width/136.6),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
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
                                              onChanged: (newValue) async {
                                                setState(() {
                                                  genderController.text =
                                                      newValue!;
                                                });

                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/5.464,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isMembers,
                                            onChanged: (val) {
                                              setState(() {
                                                isMembers = val!;
                                              });
                                              if(isMembers) {
                                                addMemberPopUp(membersList);
                                              }else{
                                                membersList.clear();
                                              }
                                            },
                                          ),
                                          SizedBox(width:width/136.6),
                                          Text("Members")
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/5.464,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isCommittee,
                                            onChanged: (val) {
                                              setState(() {
                                                isCommittee = val!;
                                              });
                                              if(isCommittee) {
                                                addCommitteePopUp(committiesList);
                                              }else{
                                                committiesList.clear();
                                              }
                                            },
                                          ),
                                          SizedBox(width:width/136.6),
                                          Text("Committee")
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height/10.85,
                                      width: width/5.464,
                                      child: Row(
                                        children: [
                                          Text("Pincode"),
                                          SizedBox(width:width/136.6),
                                          Material(
                                            elevation: 2,
                                            child: Container(
                                               height:height/18.6,
                                              width: width/9.106,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                BorderRadius.circular(10),
                                              ),
                                              child: TextField(
                                                controller: pincodeController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText: 'Search Pincode',
                                                  hintStyle: TextStyle(
                                                    color: Colors.black,
                                                  ),
                                                  contentPadding: EdgeInsets.symmetric(
                                                      horizontal: width/136.6, vertical: height/65.1),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/6.83,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isStudent,
                                            onChanged: (val) {
                                              setState(() {
                                                isStudent = val!;
                                              });
                                              if(isStudent) {
                                                addStudentPopUp(studentsList);
                                              }else{
                                                studentsList.clear();
                                              }
                                            },
                                          ),
                                          SizedBox(width:width/136.6),
                                          Text("Student")
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/6.83,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isChorus,
                                            onChanged: (val) {
                                              setState(() {
                                                isChorus = val!;
                                              });
                                              if(isChorus) {
                                                addChorusPopUp(chorusesList);
                                              }else{
                                                chorusesList.clear();
                                              }
                                            },
                                          ),
                                          SizedBox(width:width/136.6),
                                          Text("Chorus")
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/6.83,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isChurchStaff,
                                            onChanged: (val) {
                                              setState(() {
                                                isChurchStaff = val!;
                                              });
                                              if(isChurchStaff) {
                                                addChurchStaffPopUp(churchStaffsList);
                                              }else{
                                                churchStaffsList.clear();
                                              }
                                            },
                                          ),
                                          SizedBox(width:width/136.6),
                                          Text("Church Staff")
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/5.464,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: isDepartment,
                                            onChanged: (val) {
                                              setState(() {
                                                isDepartment = val!;
                                              });
                                              if(isDepartment) {
                                                addDepartmentPopUp(departmentsList);
                                              }else{
                                                departmentsList.clear();
                                              }
                                            },
                                          ),
                                          SizedBox(width:width/136.6),
                                          Text("Department")
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/5.253,
                                      child: Row(
                                        children: [
                                          Text("Blood Group"),
                                          SizedBox(width: width/170.75),
                                          Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  blurRadius: 3,
                                                  offset: Offset(2, 3),
                                                )
                                              ],
                                            ),
                                            child: DropdownButton(
                                              underline: Container(),
                                              value: dropdownValue,
                                              items: ["Select Blood Group", "AB+", "AB-","O+","O-","A+","A-","B+","B-"].map((items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) async {
                                                setState(() {
                                                  dropdownValue = newValue!;
                                                });
                                                if(dropdownValue != "Select Blood Group"){
                                                  var users = await FirebaseFirestore.instance.collection('Users').get();
                                                  users.docs.forEach((user) {
                                                    if(user['bloodGroup'] == dropdownValue && user['fcmToken'] != ""){
                                                      bloodusersList.add(UserModel.fromJson(user.data()));
                                                    }
                                                  });
                                                }else{
                                                  bloodusersList.clear();
                                                }
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: height/13.02,
                                      width: width/5.464,
                                      child: Row(
                                        children: [
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: isMarried,
                                                onChanged: (val) {
                                                  setState(() {
                                                    isMarried = val!;
                                                  });
                                                  if(isMarried) {
                                                    addMarriedPopUp(marriedusersList);
                                                  }else{
                                                    marriedusersList.clear();
                                                  }
                                                },
                                              ),
                                              SizedBox(width:width/136.6),
                                              Text("Married"),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Checkbox(
                                                value: isSingle,
                                                onChanged: (val) {
                                                  setState(() {
                                                    isSingle = val!;
                                                  });
                                                  if(isSingle) {
                                                    addSinglePopUp(singleusersList);
                                                  }else{
                                                    singleusersList.clear();
                                                  }
                                                },
                                              ),
                                              SizedBox(width:width/136.6),
                                              Text("Single"),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  addUsersForSendNotification();
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
                                    padding: EdgeInsets.symmetric(horizontal: width/136.6),
                                    child: Center(
                                      child: KText(
                                        text: "Apply",
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
                          ),
                          SizedBox(height: height/65.1),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width/68.3, vertical: height/65.1),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Subject",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:width/105.07,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  TextFormField(
                                    style: TextStyle(fontSize: width/113.83),
                                    controller: subjectController,
                                  )
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
                                margin: EdgeInsets.symmetric(vertical: height/32.55,horizontal: width/68.3),
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
                                            style:
                                                TextStyle(fontSize: width/113.83),
                                            controller: descriptionController,
                                            decoration: InputDecoration(
                                                border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(
                                                    left: width/91.06,
                                                    top: height/162.75,
                                                    bottom: height/162.75)),
                                            maxLines: null,
                                          )),
                                    ),
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
                                  sendNotification();
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
                                      child: Row(
                                        children: [
                                          Icon(Icons.send,
                                              color: Colors.white),
                                          SizedBox(width: width/273.2),
                                          KText(
                                            text: "SEND",
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
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
                : currentTab.toUpperCase() == "VIEW" ? StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('Notifications')
                  .snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List notifications = snapshot.data!.docs;
                  return Container(
                    width: width/1.2418,
                    margin: EdgeInsets.symmetric(vertical: height/32.55,horizontal: width/68.3),
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
                                  text:
                                      "Notifications (${notifications.length})",
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
                          height:
                              size.height * 0.7 > 70 + notifications.length * 60
                                  ? 70 + notifications.length * 60
                                  : size.height * 0.7,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.symmetric(vertical: height/32.55,horizontal: width/68.3),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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
                                      width: width/12.418,
                                      child: KText(
                                        text: "Date",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/12.418,
                                      child: KText(
                                        text: "Time",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/9.106,
                                      child: KText(
                                        text: "To",
                                        style: GoogleFonts.poppins(
                                          fontSize: width/113.83,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/6.83,
                                      child: KText(
                                        text: "Subject",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: width/6.83,
                                      child: KText(
                                        text: "Content",
                                        style: GoogleFonts.poppins(
                                          fontSize:width/105.07,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(height: height/65.1),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: notifications.length,
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
                                            width: width/12.418,
                                            child: KText(
                                              text: notifications[i]['date'],
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/12.418,
                                            child: KText(
                                              text: notifications[i]['time'],
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/9.106,
                                            child: KText(
                                              text: notifications[i]['to'],
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/6.83,
                                            child: KText(
                                              text: notifications[i]['subject'],
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/6.83,
                                            child: KText(
                                              text: notifications[i]['content'],
                                              style: GoogleFonts.poppins(
                                                fontSize:width/105.07,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
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

  addUserPopUp(List<UserModel> users, String type) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userDocument = await FirebaseFirestore.instance.collection("Users").get();
    bool isAll = false;
    return showDialog(
      context: context,
      builder: (ctx) {
        return
          StatefulBuilder(builder: (ctx, setState) {
          return
            AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Users",
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: 5),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAll,
                            onChanged: (val) {
                              setState(() {
                                isAll = !isAll;
                                if(isAll){
                                  userDocument.docs.forEach((element) {
                                    users.add(UserModel.fromJson(element.data()));
                                  });
                                }else{
                                  users.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(width:width/136.6),
                          Text("Select All"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      height: size.height * 0.47,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                      ),
                      child: ListView.builder(
                        itemCount: userDocument.docs.length,
                        itemBuilder: (ctx, i) {
                          return Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                            child: Container(
                              height: height/8.1375,
                              width: size.width * 0.7,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                BorderRadius.circular(
                                    10),
                              ),
                              margin:
                              EdgeInsets.symmetric(vertical: height/130.2, horizontal: width/273.2),
                              child: ListTile(
                                style: ListTileStyle.list,
                                leading: Checkbox(
                                  value: users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty,
                                  onChanged: (val) {
                                    setState(() {
                                      if(!users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty){
                                        users.add(UserModel.fromJson(userDocument.docs[i].data()));
                                      }else{
                                        users.removeWhere((element) => element.id == userDocument.docs[i]['id']);
                                      }
                                    });
                                  },
                                ),
                                title: Text(
                                    userDocument.docs[i]['firstName'] + userDocument.docs[i]['lastName']
                                ),
                                subtitle: Text(
                                    userDocument.docs[i]['phone']
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    )
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  addUsersForSendNotification() async {
    var users = await FirebaseFirestore.instance.collection('Users').get();
    var members = await FirebaseFirestore.instance.collection('Members').get();
    totalusersList.addAll(usersList);
    totalusersList.addAll(bloodusersList);
    totalusersList.addAll(singleusersList);
    totalusersList.addAll(marriedusersList);
    members.docs.forEach((member) {
      if(genderController.text != "Select Gender"){
        if(member['gender'] == genderController.text){
          genderusersList.add(MembersModel.fromJson(member.data()));
        }
      }
      if(pincodeController.text != ""){
        if(member['pincode'] == pincodeController.text){
          picodeUserList.add(MembersModel.fromJson(member.data()));
        }
      }
    });
    users.docs.forEach((user) {
      pastorsList.forEach((pastor) {
        if(user['phone'] == pastor.phone && user['fcmToken'] != ""){
          totalusersList.add(UserModel.fromJson(user.data()));
        }
      });
      membersList.forEach((member) {
        if(user['phone'] == member.phone && user['fcmToken'] != ""){
          totalusersList.add(UserModel.fromJson(user.data()));
        }
      });
      genderusersList.forEach((member) {
        if(user['phone'] == member.phone && user['fcmToken'] != ""){
          totalusersList.add(UserModel.fromJson(user.data()));
        }
      });
      picodeUserList.forEach((member) {
        if(user['phone'] == member.phone && user['fcmToken'] != ""){
          totalusersList.add(UserModel.fromJson(user.data()));
        }
      });
      studentsList.forEach((student) {
        if(user['phone'] == student.guardianPhone && user['fcmToken'] != ""){
          totalusersList.add(UserModel.fromJson(user.data()));
        }
      });
      churchStaffsList.forEach((churchStaffs) {
        if(user['phone'] == churchStaffs.phone && user['fcmToken'] != ""){
          totalusersList.add(UserModel.fromJson(user.data()));
        }
      });
      committiesList.forEach((committiee) {
        if(user['phone'] == committiee.phone && user['fcmToken'] != ""){
          totalusersList.add(UserModel.fromJson(user.data()));
        }
      });
      chorusesList.forEach((chorus) {
        if(user['phone'] == chorus.phone && user['fcmToken'] != ""){
          totalusersList.add(UserModel.fromJson(user.data()));
        }
      });
      departmentsList.forEach((department) {
        if(user['phone'] == department.contactNumber && user['fcmToken'] != ""){
          totalusersList.add(UserModel.fromJson(user.data()));
        }
      });
    });

    totalusersList.toSet().toList();
  }

  sendNotification() async {
    totalusersList.forEach((user) async {
      bool isSended = await sendPushMessage(
          user.fcmToken!, descriptionController.text, subjectController.text);
      bool isSended1 = await addToNotificationCollection(
          subjectController.text, descriptionController.text, user);
      bool isSended2 = await addToUserNotificationCollection(
          subjectController.text, descriptionController.text, user);
      if (isSended) {
        currentTab = 'View';
        subjectController.clear();
        descriptionController.clear();
        classController.text = 'Select Class';
        genderController.text = 'Select Gender';
        dropdownValue = 'Select Blood Group';
        pincodeController.text = "";
        picodeUserList.clear();
        usersList.clear();
        pastorsList.clear();
        membersList.clear();
        studentsList.clear();
        churchStaffsList.clear();
        committiesList.clear();
        chorusesList.clear();
        departmentsList.clear();
        genderusersList.clear();
        bloodusersList.clear();
        singleusersList.clear();
        marriedusersList.clear();
        setState(() {
          isAllUsers = false;
          isStudent = false;
          isMarried = false;
          isSingle = false;
        });
      }
    });
  }

  Future<bool> addToNotificationCollection(String title, String body, UserModel user) async {
    bool isAdded = false;
    NotificationModel notificationModel = NotificationModel(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      time: DateFormat('hh:mm a').format(DateTime.now()),
      content: body,
      to: user.phone,
      subject: title,
    );
    var json = notificationModel.toJson();
    await FirebaseFirestore.instance
        .collection('Notifications')
        .add(json)
        .whenComplete(() {
      isAdded = true;
    }).catchError((e) {
      isAdded = false;
    });
    return isAdded;
  }

  Future<bool> addToUserNotificationCollection(String title, String body, UserModel user) async {
    bool isAdded = false;
    NotificationModel notificationModel = NotificationModel(
      date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
      time: DateFormat('hh:mm a').format(DateTime.now()),
      content: body,
      to: user.phone,
      subject: title,
      isViewed: false,
    );
    var json = notificationModel.toJson();
    var userDocument =
        await FirebaseFirestore.instance.collection('Users').get();
    for (int i = 0; i < userDocument.docs.length; i++) {
      if (userDocument.docs[i]["id"] == user.id) {
        await FirebaseFirestore.instance
            .collection('Users')
            .doc(userDocument.docs[i].id)
            .collection('Notifications')
            .add(json)
            .whenComplete(() {
          isAdded = true;
        }).catchError((e) {
          isAdded = false;
        });
      }
    }
    return isAdded;
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
      if (response.statusCode == 200 || response.statusCode == 201) {
        isSended = true;
      } else {
        isSended = false;
      }
    } catch (e) {
      print("error push notification");
    }
    return isSended;
  }

  addPastorPopUp(List<PastorsModel> users) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userDocument = await FirebaseFirestore.instance.collection("Pastors").get();
    bool isAll = false;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Pastors",
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: 5),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAll,
                            onChanged: (val) {
                              setState(() {
                                isAll = !isAll;
                                if(isAll){
                                  userDocument.docs.forEach((element) {
                                    users.add(PastorsModel.fromJson(element.data()));
                                  });
                                }else{
                                  users.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(width:width/136.6),
                          Text("Select All"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: size.height * 0.47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                        ),
                        child: ListView.builder(
                          itemCount: userDocument.docs.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                              child: Container(
                                height: height/8.1375,
                                width: size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                ),
                                margin:
                                EdgeInsets.symmetric(vertical: height/130.2, horizontal: width/273.2),
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  leading: Checkbox(
                                    value: users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty,
                                    onChanged: (val) {
                                      setState(() {
                                        if(!users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty){
                                          users.add(PastorsModel.fromJson(userDocument.docs[i].data()));
                                        }else{
                                          users.removeWhere((element) => element.id == userDocument.docs[i]['id']);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                      userDocument.docs[i]['firstName'] + userDocument.docs[i]['lastName']
                                  ),
                                  subtitle: Text(
                                      userDocument.docs[i]['phone']
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  addMemberPopUp(List<MembersModel> users) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userDocument = await FirebaseFirestore.instance.collection("Members").get();
    bool isAll = false;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Members",
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: 5),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAll,
                            onChanged: (val) {
                              setState(() {
                                isAll = !isAll;
                                if(isAll){
                                  userDocument.docs.forEach((element) {
                                    users.add(MembersModel.fromJson(element.data()));
                                  });
                                }else{
                                  users.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(width:width/136.6),
                          Text("Select All"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: size.height * 0.47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                        ),
                        child: ListView.builder(
                          itemCount: userDocument.docs.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                              child: Container(
                                height: height/8.1375,
                                width: size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                ),
                                margin:
                                EdgeInsets.symmetric(vertical: height/130.2, horizontal: width/273.2),
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  leading: Checkbox(
                                    value: users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty,
                                    onChanged: (val) {
                                      setState(() {
                                        if(!users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty){
                                          users.add(MembersModel.fromJson(userDocument.docs[i].data()));
                                        }else{
                                          users.removeWhere((element) => element.id == userDocument.docs[i]['id']);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                      userDocument.docs[i]['firstName'] + userDocument.docs[i]['lastName']
                                  ),
                                  subtitle: Text(
                                      userDocument.docs[i]['phone']
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  addStudentPopUp(List<StudentModel> users) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userDocument = await FirebaseFirestore.instance.collection("Students").get();
    bool isAll = false;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Students",
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: 5),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAll,
                            onChanged: (val) {
                              setState(() {
                                isAll = !isAll;
                                if(isAll){
                                  userDocument.docs.forEach((element) {
                                    users.add(StudentModel.fromJson(element.data()));
                                  });
                                }else{
                                  users.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(width:width/136.6),
                          Text("Select All"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: size.height * 0.47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                        ),
                        child: ListView.builder(
                          itemCount: userDocument.docs.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                              child: Container(
                                height: height/8.1375,
                                width: size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                ),
                                margin:
                                EdgeInsets.symmetric(vertical: height/130.2, horizontal: width/273.2),
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  leading: Checkbox(
                                    value: users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty,
                                    onChanged: (val) {
                                      setState(() {
                                        if(!users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty){
                                          users.add(StudentModel.fromJson(userDocument.docs[i].data()));
                                        }else{
                                          users.removeWhere((element) => element.id == userDocument.docs[i]['id']);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                      userDocument.docs[i]['firstName'] + userDocument.docs[i]['lastName']
                                  ),
                                  subtitle: Text(
                                      userDocument.docs[i]['guardianPhone']
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  addChurchStaffPopUp(List<ChurchStaffModel> users) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userDocument = await FirebaseFirestore.instance.collection("ChurchStaff").get();
    bool isAll = false;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Church Staff",
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: 5),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAll,
                            onChanged: (val) {
                              setState(() {
                                isAll = !isAll;
                                if(isAll){
                                  userDocument.docs.forEach((element) {
                                    users.add(ChurchStaffModel.fromJson(element.data()));
                                  });
                                }else{
                                  users.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(width:width/136.6),
                          Text("Select All"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: size.height * 0.47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                        ),
                        child: ListView.builder(
                          itemCount: userDocument.docs.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                              child: Container(
                                height: height/8.1375,
                                width: size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                ),
                                margin:
                                EdgeInsets.symmetric(vertical: height/130.2, horizontal: width/273.2),
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  leading: Checkbox(
                                    value: users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty,
                                    onChanged: (val) {
                                      setState(() {
                                        if(!users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty){
                                          users.add(ChurchStaffModel.fromJson(userDocument.docs[i].data()));
                                        }else{
                                          users.removeWhere((element) => element.id == userDocument.docs[i]['id']);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                      userDocument.docs[i]['firstName'] + userDocument.docs[i]['lastName']
                                  ),
                                  subtitle: Text(
                                      userDocument.docs[i]['phone']
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  addCommitteePopUp(List<CommitteeModel> users) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userDocument = await FirebaseFirestore.instance.collection("Committee").get();
    bool isAll = false;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Committies",
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: 5),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAll,
                            onChanged: (val) {
                              setState(() {
                                isAll = !isAll;
                                if(isAll){
                                  userDocument.docs.forEach((element) {
                                    users.add(CommitteeModel.fromJson(element.data()));
                                  });
                                }else{
                                  users.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(width:width/136.6),
                          Text("Select All"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: size.height * 0.47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                        ),
                        child: ListView.builder(
                          itemCount: userDocument.docs.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                              child: Container(
                                height: height/8.1375,
                                width: size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                ),
                                margin:
                                EdgeInsets.symmetric(vertical: height/130.2, horizontal: width/273.2),
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  leading: Checkbox(
                                    value: users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty,
                                    onChanged: (val) {
                                      setState(() {
                                        if(!users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty){
                                          users.add(CommitteeModel.fromJson(userDocument.docs[i].data()));
                                        }else{
                                          users.removeWhere((element) => element.id == userDocument.docs[i]['id']);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                      userDocument.docs[i]['firstName'] + userDocument.docs[i]['lastName']
                                  ),
                                  subtitle: Text(
                                      userDocument.docs[i]['phone']
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  addChorusPopUp(List<ChorusModel> users) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userDocument = await FirebaseFirestore.instance.collection("Chorus").get();
    bool isAll = false;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Chorus",
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: 5),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAll,
                            onChanged: (val) {
                              setState(() {
                                isAll = !isAll;
                                if(isAll){
                                  userDocument.docs.forEach((element) {
                                    users.add(ChorusModel.fromJson(element.data()));
                                  });
                                }else{
                                  users.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(width:width/136.6),
                          Text("Select All"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: size.height * 0.47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                        ),
                        child: ListView.builder(
                          itemCount: userDocument.docs.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                              child: Container(
                                height: height/8.1375,
                                width: size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                ),
                                margin:
                                EdgeInsets.symmetric(vertical: height/130.2, horizontal: width/273.2),
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  leading: Checkbox(
                                    value: users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty,
                                    onChanged: (val) {
                                      setState(() {
                                        if(!users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty){
                                          users.add(ChorusModel.fromJson(userDocument.docs[i].data()));
                                        }else{
                                          users.removeWhere((element) => element.id == userDocument.docs[i]['id']);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                      userDocument.docs[i]['firstName'] + userDocument.docs[i]['lastName']
                                  ),
                                  subtitle: Text(
                                      userDocument.docs[i]['phone']
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  addDepartmentPopUp(List<DepartmentModel> users) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userDocument = await FirebaseFirestore.instance.collection("Departments").get();
    bool isAll = false;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Departments",
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: 5),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAll,
                            onChanged: (val) {
                              setState(() {
                                isAll = !isAll;
                                if(isAll){
                                  userDocument.docs.forEach((element) {
                                    users.add(DepartmentModel.fromJson(element.data()));
                                  });
                                }else{
                                  users.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(width:width/136.6),
                          Text("Select All"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: size.height * 0.47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                        ),
                        child: ListView.builder(
                          itemCount: userDocument.docs.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                              child: Container(
                                height: height/8.1375,
                                width: size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                ),
                                margin:
                                EdgeInsets.symmetric(vertical: height/130.2, horizontal: width/273.2),
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  leading: Checkbox(
                                    value: users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty,
                                    onChanged: (val) {
                                      setState(() {
                                        if(!users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty){
                                          users.add(DepartmentModel.fromJson(userDocument.docs[i].data()));
                                        }else{
                                          users.removeWhere((element) => element.id == userDocument.docs[i]['id']);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                      userDocument.docs[i]['name']
                                  ),
                                  subtitle: Text(
                                      userDocument.docs[i]['contactNumber']
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  addMarriedPopUp(List<UserModel> users) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userDocument = await FirebaseFirestore.instance.collection("Users").get();
    bool isAll = false;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Users",
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: 5),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAll,
                            onChanged: (val) {
                              setState(() {
                                isAll = !isAll;
                                if(isAll){
                                  userDocument.docs.forEach((element) {
                                    users.add(UserModel.fromJson(element.data()));
                                  });
                                }else{
                                  users.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(width:width/136.6),
                          Text("Select All"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: size.height * 0.47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                        ),
                        child: ListView.builder(
                          itemCount: userDocument.docs.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding:
                              EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                              child: Container(
                                height: height/8.1375,
                                width: size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                ),
                                margin:
                                EdgeInsets.symmetric(vertical: height/130.2, horizontal: width/273.2),
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  leading: Checkbox(
                                    value: users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty,
                                    onChanged: (val) {
                                      setState(() {
                                        if(!users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty){
                                          users.add(UserModel.fromJson(userDocument.docs[i].data()));
                                        }else{
                                          users.removeWhere((element) => element.id == userDocument.docs[i]['id']);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                      userDocument.docs[i]['firstName']+userDocument.docs[i]['lastName']
                                  ),
                                  subtitle: Text(
                                      userDocument.docs[i]['phone']
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  addSinglePopUp(List<UserModel> users) async {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    var userDocument = await FirebaseFirestore.instance.collection("Users").get();
    bool isAll = false;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: SizedBox(
              height: size.height * 0.8,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(horizontal: width/68.3),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "Users",
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
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    color: Colors.white,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: 5),
                      child: Row(
                        children: [
                          Checkbox(
                            value: isAll,
                            onChanged: (val) {
                              setState(() {
                                isAll = !isAll;
                                if(isAll){
                                  userDocument.docs.forEach((element) {
                                    users.add(UserModel.fromJson(element.data()));
                                  });
                                }else{
                                  users.clear();
                                }
                              });
                            },
                          ),
                          SizedBox(width:width/136.6),
                          Text("Select All"),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                        height: size.height * 0.47,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                        ),
                        child: ListView.builder(
                          itemCount: userDocument.docs.length,
                          itemBuilder: (ctx, i) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                              child: Container(
                                height: height/8.1375,
                                width: size.width * 0.7,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                  BorderRadius.circular(
                                      10),
                                ),
                                margin: EdgeInsets.symmetric(vertical: height/130.2, horizontal: width/273.2),
                                child: ListTile(
                                  style: ListTileStyle.list,
                                  leading: Checkbox(
                                    value: users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty,
                                    onChanged: (val) {
                                      setState(() {
                                        if(!users.where((element) => element.id == userDocument.docs[i]['id']).isNotEmpty){
                                          users.add(UserModel.fromJson(userDocument.docs[i].data()));
                                        }else{
                                          users.removeWhere((element) => element.id == userDocument.docs[i]['id']);
                                        }
                                      });
                                    },
                                  ),
                                  title: Text(
                                      userDocument.docs[i]['firstName']+userDocument.docs[i]['lastName']
                                  ),
                                  subtitle: Text(
                                      userDocument.docs[i]['phone']
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      )
                  )
                ],
              ),
            ),
          );
        });
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

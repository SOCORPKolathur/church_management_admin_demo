
import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:church_management_admin/models/message_model.dart';
import 'package:church_management_admin/services/messages_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../constants.dart';
import '../../models/notification_model.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';

class MessagesTab extends StatefulWidget {
   MessagesTab({super.key});

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab>  with SingleTickerProviderStateMixin {

  TabController? _tabController;
  int currentTabIndex = 0;

  int messageCount = 0;
  int requestCount = 0;

  @override
  void initState() {
    _tabController = TabController(length: 2, vsync: this);
    setBadgeCount();
    super.initState();
  }

  setBadgeCount() async {
    var messages = await FirebaseFirestore.instance.collection('Messages').get();
    var requests = await FirebaseFirestore.instance.collection('ProfileEditRequest').get();
    messages.docs.forEach((element) {
      if(element.get("isViewed") == false){
        messageCount++;
      }
    });
    setState(() {
      requestCount += requests.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding:  EdgeInsets.symmetric(vertical: height/65.1,horizontal: width/136.6),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding:  EdgeInsets.only(left: width/68.3),
                    child: InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child:  Icon(
                          Icons.arrow_back
                      ),
                    ),
                  ),
                  Padding(
                    padding:  EdgeInsets.symmetric(horizontal: width/170.75,vertical: height/81.375),
                    child: KText(
                      text: 'MESSAGES',
                      style: GoogleFonts.openSans(
                        fontSize: width/42.687,
                        fontWeight: FontWeight.w900,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              Container(
                width: double.infinity,
                margin:  EdgeInsets.symmetric(
                  vertical: height/32.55,
                  horizontal: width/68.3,
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
                      child: TabBar(
                        controller: _tabController,
                        onTap: (index){
                          setState(() {
                            currentTabIndex = index;
                          });
                        },
                        labelPadding:
                        const EdgeInsets.symmetric(horizontal: 8),
                        splashBorderRadius: BorderRadius.circular(30),
                        automaticIndicatorColorAdjustment: true,
                        dividerColor: Colors.transparent,
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
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Messages",
                                    style: GoogleFonts.openSans(
                                      color: currentTabIndex == 0
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: width/97.57142857142857,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Visibility(
                                    visible: messageCount != 0,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Text(
                                          messageCount.toString(),
                                          style: TextStyle(
                                            color: Constants().primaryAppColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Tab(
                            child: Padding(
                              padding:
                              const EdgeInsets.symmetric(horizontal: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Edit Requests",
                                    style: GoogleFonts.openSans(
                                      color: currentTabIndex == 1
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: width/97.57142857142857,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Visibility(
                                    visible: requestCount != 0,
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Text(
                                          requestCount.toString(),
                                          style: TextStyle(
                                            color: Constants().primaryAppColor,
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
                    ),
                    Container(
                      height: size.height * 0.7,
                      width: double.infinity,
                      decoration:  BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                      ),
                      padding:  EdgeInsets.symmetric(
                          horizontal: width/68.3,
                          vertical: height/32.55
                      ),
                      child: TabBarView(
                        dragStartBehavior: DragStartBehavior.down,
                        physics: const NeverScrollableScrollPhysics(),
                        controller: _tabController,
                        children: [
                          StreamBuilder(
                              stream: MessagesFireCrud.fetchMessages(),
                              builder: (ctx, snap){
                                if(snap.hasData){
                                  return buildMessages(snap.data!);
                                }return Container();
                              }
                          ),
                          StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('ProfileEditRequest').snapshots(),
                              builder: (ctx, snap){
                                if(snap.hasData){
                                  return buildRequests(snap.data!.docs);
                                }return Container();
                              }
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
              // StreamBuilder(
              //   stream: MessagesFireCrud.fetchMessages(),
              //   builder: (ctx, snapshot) {
              //     if (snapshot.hasError) {
              //       return Container();
              //     } else if (snapshot.hasData) {
              //       List<MessageModel> messages = snapshot.data!;
              //       return Container(
              //         width: double.infinity,
              //         margin:  EdgeInsets.symmetric(
              //           vertical: height/32.55,
              //           horizontal: width/68.3,
              //         ),
              //         decoration: BoxDecoration(
              //           color: Constants().primaryAppColor,
              //           boxShadow:  [
              //             BoxShadow(
              //               color: Colors.black26,
              //               offset: Offset(1, 2),
              //               blurRadius: 3,
              //             ),
              //           ],
              //           borderRadius: BorderRadius.circular(10),
              //         ),
              //         child: Column(
              //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //           children: [
              //             SizedBox(
              //               height: size.height * 0.1,
              //               width: double.infinity,
              //               child: Padding(
              //                 padding:  EdgeInsets.symmetric(
              //                     horizontal: width/68.3, vertical: height/81.375),
              //                 child: Row(
              //                   mainAxisAlignment:
              //                       MainAxisAlignment.spaceBetween,
              //                   children: [
              //                     KText(
              //                       text: "All Messages (${messages.length})",
              //                       style: GoogleFonts.openSans(
              //                         fontSize: width/68.3,
              //                         fontWeight: FontWeight.bold,
              //                       ),
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //             Container(
              //               height: size.height * 0.7,
              //               width: double.infinity,
              //               decoration:  BoxDecoration(
              //                   color: Colors.white,
              //                   borderRadius: BorderRadius.only(
              //                     bottomLeft: Radius.circular(10),
              //                     bottomRight: Radius.circular(10),
              //                   )),
              //               padding:  EdgeInsets.symmetric(
              //                 horizontal: width/68.3,
              //                 vertical: height/32.55
              //               ),
              //               child: SingleChildScrollView(
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: [
              //                     ListView.builder(
              //                       itemCount: messages.length,
              //                       shrinkWrap: true,
              //                       physics: const BouncingScrollPhysics(),
              //                       itemBuilder: (ctx, i) {
              //                         return Padding(
              //                           padding:  EdgeInsets.symmetric(
              //                             vertical: height/81.375,
              //                             horizontal: width/170.75
              //                           ),
              //                           child: VisibilityDetector(
              //                             key: Key('my-widget-key1 $i'),
              //                             onVisibilityChanged: (VisibilityInfo visibilityInfo){
              //                               var visiblePercentage = visibilityInfo.visibleFraction;
              //                               if(!messages[i].isViewed!){
              //                                 updateMessageViewStatus(messages[i]);
              //                               }
              //                             },
              //                             child: Container(
              //                               height: height/6.0,
              //                               width: double.infinity,
              //                               decoration: BoxDecoration(
              //                                 borderRadius:
              //                                     BorderRadius.circular(10),
              //                                 color: Colors.grey.shade50,
              //                               ),
              //                               padding:  EdgeInsets.symmetric(
              //                                   horizontal: width/68.3,
              //                                   vertical: height/32.55),
              //                               child: Row(
              //                                 mainAxisAlignment:
              //                                     MainAxisAlignment.spaceBetween,
              //                                 children: [
              //                                   Column(
              //                                     crossAxisAlignment:
              //                                         CrossAxisAlignment.start,
              //                                     children: [
              //                                       Text(
              //                                         messages[i].title!,
              //                                         style:  TextStyle(
              //                                           fontSize: width/75.888  ,
              //                                           fontWeight: FontWeight.bold,
              //                                         ),
              //                                       ),
              //                                      //  SizedBox(height: height/32.55),
              //                                       SizedBox(
              //                                         height: height/15.4,
              //                                         width: width/1.366,
              //                                         child: Text(
              //                                           messages[i].content!,
              //                                           style:  TextStyle(
              //                                             fontSize: width/91.066,
              //                                             fontWeight:
              //                                                 FontWeight.normal,
              //                                           ),
              //                                         ),
              //                                       )
              //                                     ],
              //                                   ),
              //                                   Column(
              //                                     crossAxisAlignment:
              //                                         CrossAxisAlignment.start,
              //                                     children: [
              //                                       Visibility(
              //                                         visible: !messages[i].isViewed!,
              //                                         child: Container(
              //                                           height: 20,
              //                                           width: 80,
              //                                           decoration: BoxDecoration(
              //                                             color: Constants().primaryAppColor,
              //                                             borderRadius: BorderRadius.circular(30)
              //                                           ),
              //                                           child: Center(
              //                                             child: Text(
              //                                                 "New",
              //                                               style: TextStyle(
              //                                                 fontSize: 16,
              //                                                 fontWeight: FontWeight.bold,
              //                                                 color: Colors.white
              //                                               ),
              //                                             ),
              //                                           ),
              //                                         ),
              //                                       ),
              //                                       Row(
              //                                         children: [
              //                                            Text(
              //                                             "Date : ",
              //                                             style: TextStyle(
              //                                               fontSize: width/97.571,
              //                                               fontWeight:
              //                                                   FontWeight.bold,
              //                                             ),
              //                                           ),
              //                                           Text(
              //                                             messages[i].date!,
              //                                             style:  TextStyle(
              //                                               fontSize: width/97.571,
              //                                               fontWeight:
              //                                                   FontWeight.normal,
              //                                             ),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                        Visibility(
              //                                          visible: messages[i].isViewed!,
              //                                            child: SizedBox(height: height/32.55),
              //                                        ),
              //                                       Row(
              //                                         children: [
              //                                            Text(
              //                                             "Time : ",
              //                                             style: TextStyle(
              //                                               fontSize: width/97.571,
              //                                               fontWeight:
              //                                                   FontWeight.bold,
              //                                             ),
              //                                           ),
              //                                           Text(
              //                                             messages[i].time!,
              //                                             style:  TextStyle(
              //                                               fontSize: width/97.571,
              //                                               fontWeight:
              //                                                   FontWeight.normal,
              //                                             ),
              //                                           ),
              //                                         ],
              //                                       ),
              //                                     ],
              //                                   ),
              //                                 ],
              //                               ),
              //                             ),
              //                           ),
              //                         );
              //                       },
              //                     ),
              //                   ],
              //                 ),
              //               ),
              //             ),
              //           ],
              //         ),
              //       );
              //     }
              //     return Container();
              //   },
              // )
            ],
          ),
        ),
    );
  }

  buildMessages(List<MessageModel> messages){
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            itemCount: messages.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx, i) {
              return Padding(
                padding:  EdgeInsets.symmetric(
                    vertical: height/81.375,
                    horizontal: width/170.75
                ),
                child: VisibilityDetector(
                  key: Key('my-widget-key1 $i'),
                  onVisibilityChanged: (VisibilityInfo visibilityInfo){
                    var visiblePercentage = visibilityInfo.visibleFraction;
                    if(!messages[i].isViewed!){
                      updateMessageViewStatus(messages[i]);
                    }
                  },
                  child: Container(
                    height: height/6.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius:
                      BorderRadius.circular(10),
                      color: Colors.grey.shade50,
                    ),
                    padding:  EdgeInsets.symmetric(
                        horizontal: width/68.3,
                        vertical: height/32.55),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Text(
                              messages[i].title!,
                              style:  TextStyle(
                                fontSize: width/75.888  ,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            //  SizedBox(height: height/32.55),
                            SizedBox(
                              height: height/15.4,
                              width: width/1.366,
                              child: Text(
                                messages[i].content!,
                                style:  TextStyle(
                                  fontSize: width/91.066,
                                  fontWeight:
                                  FontWeight.normal,
                                ),
                              ),
                            )
                          ],
                        ),
                        Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Visibility(
                              visible: !messages[i].isViewed!,
                              child: Container(
                                height: 20,
                                width: 80,
                                decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
                                    borderRadius: BorderRadius.circular(30)
                                ),
                                child: Center(
                                  child: Text(
                                    "New",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Date : ",
                                  style: TextStyle(
                                    fontSize: width/97.571,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  messages[i].date!,
                                  style:  TextStyle(
                                    fontSize: width/97.571,
                                    fontWeight:
                                    FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                            Visibility(
                              visible: messages[i].isViewed!,
                              child: SizedBox(height: height/32.55),
                            ),
                            Row(
                              children: [
                                Text(
                                  "Time : ",
                                  style: TextStyle(
                                    fontSize: width/97.571,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  messages[i].time!,
                                  style:  TextStyle(
                                    fontSize: width/97.571,
                                    fontWeight:
                                    FontWeight.normal,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  buildRequests(List<DocumentSnapshot> requests){
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
      child: requests.isEmpty
          ? Center(
        child: Lottie.asset(
          'assets/no_message.json',
          fit: BoxFit.contain,
          height: size.height * 0.6,
          width: size.width * 0.7,
        ),
      )
          : Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListView.builder(
            itemCount: requests.length,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx, i) {
              return Padding(
                padding:  EdgeInsets.symmetric(
                    vertical: height/81.375,
                    horizontal: width/170.75
                ),
                child: Container(
                  height: height/6.0,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.circular(10),
                    color: Colors.grey.shade100,
                  ),
                  padding:  EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: 100,
                        width: size.width * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              "Profile Edit Request from ${requests[i].get("firstName")}",
                              style:  TextStyle(
                                fontSize: width/75.888  ,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'USER ID : ${requests[i].get("userDocId")}',
                              style:  TextStyle(
                                fontSize: width/91.066,
                                fontWeight:
                                FontWeight.normal,
                              ),
                            )
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          InkWell(
                            onTap:(){
                              viewPopup(requests[i]);
                            },
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "View Details",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  viewPopup(DocumentSnapshot user) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: size.width * 0.5,
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
              children: [
                SizedBox(
                  height: size.height * 0.1,
                  width: double.infinity,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.get("firstName")+" "+user.get("lastName"),
                          style: GoogleFonts.openSans(
                            fontSize: width / 68.3,
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 227.66),
                              child: Center(
                                child: KText(
                                  text: "CLOSE",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/85.375,
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
                                image: NetworkImage(user.get("imgUrl")),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width/136.6, vertical: height/43.4),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text:
                                        "${user.get("firstName")} ${user.get("lastName")}",
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Phone",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.get("phone"),
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Email",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.get("email"),
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Profession",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.get("profession"),
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Locality",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: user.get("locality"),
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "About",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      SizedBox(
                                        width: size.width*0.3,
                                        child: Text(
                                          user.get("about"),
                                          style: TextStyle(fontSize: width/97.571),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      SizedBox(
                                        width: size.width * 0.3,
                                        child: Text(
                                          user.get("address"),
                                          style: TextStyle(fontSize: width/97.571),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  elevation: 4,
                  color: Colors.grey.shade100,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () async {
                              await updateProfile(user.get("userDocId"),user);
                              await CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "User Updated successfully!",
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  backgroundColor: Constants()
                                      .primaryAppColor
                                      .withOpacity(0.8),
                              );
                            },
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "Approve",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          InkWell(
                            onTap: () async {
                              await denyRequest(user.id,user.get("userDocId"));
                              await CoolAlert.show(
                                  context: context,
                                  type: CoolAlertType.success,
                                  text: "User Request denied",
                                  width: MediaQuery.of(context).size.width * 0.4,
                                  backgroundColor: Constants()
                                      .primaryAppColor
                                      .withOpacity(0.8));
                            },
                            child: Material(
                              elevation: 4,
                              borderRadius: BorderRadius.circular(10),
                              child: Container(
                                height: 35,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      "Deny",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
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
            ),
          ),
        );
      },
    );
  }

  String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  denyRequest(String id,String userDocId) async {
    String title = "Denied Request";
    String body = "Your Profile edit request denied";
    String docId = generateRandomString(16);
    FirebaseFirestore.instance.collection('ProfileEditRequest').doc(id).delete();
    Navigator.pop(context);
    var user = await FirebaseFirestore.instance.collection('Users').doc(userDocId).get();
    String token = user.get("fcmToken");
    String phone = user.get("phone");
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
    NotificationModel notificationModel = NotificationModel(
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        time: DateFormat('hh:mm a').format(DateTime.now()),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        content: body,
        to: phone,
        subject: title,
        isViewed: false,
        viewsCount: []
    );
    var json = notificationModel.toJson();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userDocId)
        .collection('Notifications').doc(docId)
        .set(json)
        .whenComplete(() {
    }).catchError((e) {
    });
  }

  updateProfile(String userDocId,DocumentSnapshot snap) async {
    FirebaseFirestore.instance.collection('Users').doc(userDocId).update({
      "firstName": snap.get("firstName"),
      "lastName": snap.get("lastName"),
      "imgUrl": snap.get("imgUrl"),
      "email": snap.get("email"),
      "phone": snap.get("phone"),
      "maritialStatus": snap.get("maritalStatus"),
      "anniversaryDate": snap.get("anniversaryDate"),
      "locality": snap.get("locality"),
      "profession": snap.get("profession"),
      "address": snap.get("address"),
      "about": snap.get("about"),
    });

    String title = "Request Approved";
    String body = "Your Profile edit request approved. Your profile will updated";
    String docId = generateRandomString(16);
    FirebaseFirestore.instance.collection('ProfileEditRequest').doc(snap.id).delete();
    Navigator.pop(context);
    var user = await FirebaseFirestore.instance.collection('Users').doc(userDocId).get();
    String token = user.get("fcmToken");
    String phone = user.get("phone");
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
    NotificationModel notificationModel = NotificationModel(
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        time: DateFormat('hh:mm a').format(DateTime.now()),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        content: body,
        to: phone,
        subject: title,
        isViewed: false,
        viewsCount: []
    );
    var json = notificationModel.toJson();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userDocId)
        .collection('Notifications').doc(docId)
        .set(json)
        .whenComplete(() {
    }).catchError((e) {
    });
  }

  updateMessageViewStatus(MessageModel message) async {
    var document = await FirebaseFirestore.instance.collection('Messages').doc(message.id).update({
      "isViewed": true
    });
  }
}

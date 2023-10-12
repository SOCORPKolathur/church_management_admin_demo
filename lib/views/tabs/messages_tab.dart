
import 'package:church_management_admin/models/message_model.dart';
import 'package:church_management_admin/services/messages_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../constants.dart';
import '../../widgets/kText.dart';

class MessagesTab extends StatefulWidget {
   MessagesTab({super.key});

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
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
              StreamBuilder(
                stream: MessagesFireCrud.fetchMessages(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasError) {
                    return Container();
                  } else if (snapshot.hasData) {
                    List<MessageModel> messages = snapshot.data!;
                    return Container(
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
                            child: Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: width/68.3, vertical: height/81.375),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  KText(
                                    text: "All Messages (${messages.length})",
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
                            height: size.height * 0.7,
                            width: double.infinity,
                            decoration:  BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                            padding:  EdgeInsets.symmetric(
                              horizontal: width/68.3,
                              vertical: height/32.55
                            ),
                            child: SingleChildScrollView(
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
        ));
  }

  updateMessageViewStatus(MessageModel message) async {
    var document = await FirebaseFirestore.instance.collection('Messages').doc(message.id).update({
      "isViewed": true
    });
  }
}

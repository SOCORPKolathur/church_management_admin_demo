
import 'package:church_management_admin/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/kText.dart';

class MembershipReportsTab extends StatefulWidget {
  const MembershipReportsTab({super.key});

  @override
  State<MembershipReportsTab> createState() => _MembershipReportsTabState();
}

class _MembershipReportsTabState extends State<MembershipReportsTab> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: KText(
              text: "Membership Reports",
              style: GoogleFonts.openSans(
                  fontSize: width/52.53846153846154,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
          ),

          FutureBuilder<MembershipDetailModel>(
            future: getMembershipDetails(),
            builder: (ctx, snap){
              if(snap.hasData){
                return Container(
                  height: 150,
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        height: height/4.06875,
                        width: width/4.06875,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(1, 2),
                                blurRadius: 3),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Constants().primaryAppColor,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.06,
                              width: size.width * 0.2,
                              child: Center(
                                child: KText(
                                  text: "Total Members",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: width/56.916,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: width/4.06875,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width/105.076),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: snap.data!.totalMembers.length.toString(),
                                                style: GoogleFonts.inter(
                                                  fontSize: width/41.393,
                                                ),
                                              ),
                                              KText(
                                                text: snap.data!.totalMembers.length.toString(),
                                                style: GoogleFonts.inter(
                                                  fontSize: width/85.375,
                                                  color:
                                                  Color(0xff8A92A6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: width/68.3),
                                          Container(
                                            height: height/16.275,
                                            width: width/34.15,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              color: Colors.green.withOpacity(0.3),
                                            ),
                                            child: const Center(
                                              child: Icon(
                                                Icons.arrow_upward_outlined,
                                                color: Colors.green,
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height/54.25,
                                          horizontal: width/113.833
                                      ),
                                      child: LinearProgressIndicator(
                                        backgroundColor:
                                        Colors.green.withOpacity(0.3),
                                        color: Colors.green,
                                        value: 10,
                                        semanticsLabel:
                                        'Linear progress indicator',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: height/4.06875,
                        width: width/4.06875,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(1, 2),
                                blurRadius: 3),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Constants().primaryAppColor,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.06,
                              width: size.width * 0.2,
                              child: Center(
                                child: KText(
                                  text: "Due Members",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: width/56.916,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: width/4.06875,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width/105.076),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: snap.data!.dueMembers.length.toString(),
                                                style: GoogleFonts.inter(
                                                  fontSize: width/41.393,
                                                ),
                                              ),
                                              KText(
                                                text: snap.data!.dueMembers.length.toString(),
                                                style: GoogleFonts.inter(
                                                  fontSize: width/85.375,
                                                  color:
                                                  Color(0xff8A92A6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: width/68.3),
                                          Container(
                                            height: height/16.275,
                                            width: width/34.15,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              color: Color(0xfff2d6d3),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_upward_outlined,
                                                color: Color(0xffC03221),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height/54.25,
                                          horizontal: width/113.833
                                      ),
                                      child: LinearProgressIndicator(
                                        backgroundColor:
                                        Color(0xfff2d6d3),
                                        color: Color(0xffC03221),
                                        value: 10,
                                        semanticsLabel:
                                        'Linear progress indicator',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Container(
                        height: height/4.06875,
                        width: width/4.06875,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black26,
                                offset: Offset(1, 2),
                                blurRadius: 3),
                          ],
                          borderRadius: BorderRadius.circular(10),
                          color: Constants().primaryAppColor,
                        ),
                        child: Column(
                          children: [
                            SizedBox(
                              height: size.height * 0.06,
                              width: size.width * 0.2,
                              child: Center(
                                child: KText(
                                  text: "Total Due Amount",
                                  style: GoogleFonts.inter(
                                    fontWeight: FontWeight.w600,
                                    fontSize: width/56.916,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                width: width/4.06875,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: width/105.076),
                                      child: Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                        children: [
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: snap.data!.totalDueAmount.toString(),
                                                style: GoogleFonts.inter(
                                                  fontSize: width/41.393,
                                                ),
                                              ),
                                              KText(
                                                text: snap.data!.totalDueAmount.toString(),
                                                style: GoogleFonts.inter(
                                                  fontSize: width/85.375,
                                                  color:
                                                  Color(0xff8A92A6),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(width: width/68.3),
                                          Container(
                                            height: height/16.275,
                                            width: width/34.15,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(8),
                                              color: Color(0xfff2d6d3),
                                            ),
                                            child: Center(
                                              child: Icon(
                                                Icons.arrow_upward_outlined,
                                                color: Color(0xffC03221),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height/54.25,
                                          horizontal: width/113.833
                                      ),
                                      child: LinearProgressIndicator(
                                        backgroundColor:
                                        Color(0xfff2d6d3),
                                        color: Color(0xffC03221),
                                        value: 10,
                                        semanticsLabel:
                                        'Linear progress indicator',
                                      ),
                                    ),
                                  ],
                                ),
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
          ),
          SizedBox(height: 10),
          StreamBuilder(
            stream: FirebaseFirestore.instance.collection('MembershipReports').orderBy('timestamp',descending: true).snapshots(),
            builder: (ctx, snap){
              if(snap.hasData){
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Material(
                      elevation: 3,
                      borderRadius: BorderRadius.circular(10),
                      child: Column(
                        children: [
                          Container(
                            height: 50,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Constants().primaryAppColor,
                              borderRadius: const BorderRadius.only(
                                topRight: Radius.circular(10),
                                topLeft: Radius.circular(10),
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 80,
                                    child: Text(
                                      "SI.NO",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      "Name",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      "Amount",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 150,
                                    child: Text(
                                      "Months",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Text(
                                      "Method",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 17,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 200,
                                    child: Center(
                                      child: Text(
                                        "View",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 17,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            child: Container(
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10),
                                ),
                              ),
                              child: ListView.builder(
                                itemCount: snap.data!.docs.length,
                                itemBuilder: (ctx , i){
                                  var data = snap.data!.docs[i];
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                    child: Container(
                                      height: 50,
                                      width: double.infinity,
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 80,
                                            child: Text(
                                              (i+1).toString(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.normal,
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              data.get("name"),
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              data.get("amount").toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 150,
                                            child: Text(
                                              data.get("months").toString(),
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: Text(
                                              data.get("method"),
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: 200,
                                            child: InkWell(
                                              child: Material(
                                                elevation: 3,
                                                borderRadius: BorderRadius.circular(10),
                                                child: Container(
                                                  height: 35,
                                                  width: 180,
                                                  decoration: BoxDecoration(
                                                    color: Constants().primaryAppColor,
                                                    borderRadius: BorderRadius.circular(10),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "View",
                                                      style: GoogleFonts.poppins(
                                                        fontSize: 15,
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
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              }return Container();
            },
          )
        ],
      )
    );
  }

  Future<MembershipDetailModel> getMembershipDetails() async {
    List<DocumentSnapshot> totalMembers = [];
    List<DocumentSnapshot> dueMembers = [];
    double totalDueAmount = 0.0;
    var membersDocument = await FirebaseFirestore.instance.collection('Members').orderBy('timestamp',descending: true).get();
    membersDocument.docs.forEach((member) async {
      totalMembers.add(member);
      var membershipDoc = await FirebaseFirestore.instance.collection('Members').doc(member.id).collection('Membership').get();
      membershipDoc.docs.forEach((element) {
        if(element.get("payment") == false){
          totalDueAmount += 1000.0;
          dueMembers.add(member);
        }
      });
    });
    await Future.delayed(const Duration(seconds: 10));
    MembershipDetailModel details = MembershipDetailModel(
      dueMembers: dueMembers,
      totalDueAmount: totalDueAmount,
      totalMembers: totalMembers
    );
    return details;
  }


}

class MembershipDetailModel{
  MembershipDetailModel({required this.dueMembers, required this.totalMembers, required this.totalDueAmount});
  List<DocumentSnapshot> dueMembers;
  List<DocumentSnapshot> totalMembers;
  double totalDueAmount;
}

class MemberForMembership {
  MemberForMembership({required this.member, required this.payment});
  bool payment;
  DocumentSnapshot member;
}

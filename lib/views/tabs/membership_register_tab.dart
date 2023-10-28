import 'package:church_management_admin/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/kText.dart';

class MembershipRegisterTab extends StatefulWidget {
  const MembershipRegisterTab({super.key});

  @override
  State<MembershipRegisterTab> createState() => _MembershipRegisterTabState();
}

class _MembershipRegisterTabState extends State<MembershipRegisterTab> {
  final _formkey = GlobalKey<FormState>();

  List<MembersWithDetails> membersList = [];

  TextEditingController memberNameController =
      TextEditingController();
  TextEditingController memberIdController =
      TextEditingController();
  TextEditingController memberFamilyNameController =
      TextEditingController();
  TextEditingController paytype = TextEditingController();
  TextEditingController amount = TextEditingController();
  TextEditingController methodController = TextEditingController();
  TextEditingController monthController = TextEditingController();

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
              text: "Membership Register",
              style: GoogleFonts.openSans(
                  fontSize: width / 52.53846153846154,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
          ),
          StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('Members').snapshots(),
            builder: (ctx, snap) {
              if (snap.hasData) {
                membersList.clear();
                membersList.add(MembersWithDetails(name: '', familyName: '', memberId: '', docId: ''));
                snap.data!.docs.forEach((member) {
                  membersList.add(MembersWithDetails(
                      name: member.get("firstName"),
                      familyName: member.get("family"),
                      memberId: member.get("memberId"),
                    docId: member.id
                  ),
                  );
                });
                return Expanded(
                    child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 20),
                  child: Form(
                    key: _formkey,
                    child: Container(
                      width: width / 1.050,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: width / 1.050,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Select Member ID :",
                                      style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    Container(
                                      width: width / 6.83,
                                      height: height / 16.42,
                                      //color: Color(0xffDDDEEE),
                                      decoration: BoxDecoration(
                                          color: const Color(0xffDDDEEE),
                                          borderRadius:
                                              BorderRadius.circular(5)),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton2<String>(
                                          isExpanded: true,
                                          hint: Row(
                                            children: [
                                              Icon(
                                                Icons.list,
                                                size: 16,
                                                color: Colors.black,
                                              ),
                                              SizedBox(
                                                width: 4,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'Select Option',
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 15),
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ],
                                          ),
                                          items: membersList
                                              .map((item) =>
                                                  DropdownMenuItem<String>(
                                                    value: item.memberId,
                                                    child: Text(
                                                      item.memberId,
                                                      style:
                                                          GoogleFonts.poppins(
                                                              fontSize: 15),
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ))
                                              .toList(),
                                          value: memberIdController.text,
                                          onChanged: (String? value) {
                                            membersList.forEach((element) {
                                              if (element.memberId == value) {
                                                setState(() {
                                                  memberIdController.text =
                                                      element.memberId;
                                                  memberFamilyNameController
                                                          .text =
                                                      element.familyName;
                                                  memberNameController.text =
                                                      element.name;
                                                });
                                              }
                                            });
                                          },
                                          buttonStyleData: ButtonStyleData(
                                            height: 50,
                                            width: 160,
                                            padding: const EdgeInsets.only(
                                                left: 14, right: 14),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              color: Color(0xffDDDEEE),
                                            ),
                                          ),
                                          iconStyleData: const IconStyleData(
                                            icon: Icon(
                                              Icons.arrow_forward_ios_outlined,
                                            ),
                                            iconSize: 14,
                                            iconEnabledColor: Colors.black,
                                            iconDisabledColor: Colors.grey,
                                          ),
                                          dropdownStyleData: DropdownStyleData(
                                            maxHeight: 200,
                                            width: width / 5.464,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(14),
                                              color: Color(0xffDDDEEE),
                                            ),
                                            scrollbarTheme: ScrollbarThemeData(
                                              radius: const Radius.circular(7),
                                              thickness: MaterialStateProperty
                                                  .all<double>(6),
                                              thumbVisibility:
                                                  MaterialStateProperty.all<
                                                      bool>(true),
                                            ),
                                          ),
                                          menuItemStyleData:
                                              const MenuItemStyleData(
                                            height: 40,
                                            padding: EdgeInsets.only(
                                                left: 14, right: 14),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 0.0),
                                          child: Text("Select Name *",
                                              style: GoogleFonts.poppins(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w700)),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 0.0, right: 25),
                                          child: Container(
                                            width: width / 6.83,
                                            height: height / 16.42,
                                            //color: Color(0xffDDDEEE),
                                            decoration: BoxDecoration(
                                                color: const Color(0xffDDDEEE),
                                                borderRadius:
                                                    BorderRadius.circular(5)),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton2<String>(
                                                isExpanded: true,
                                                hint: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.list,
                                                      size: 16,
                                                      color: Colors.black,
                                                    ),
                                                    SizedBox(
                                                      width: 4,
                                                    ),
                                                    Expanded(
                                                      child: Text(
                                                        'Select Option',
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 15),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                items: membersList
                                                    .map((item) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value: item.name,
                                                          child: Text(
                                                            item.name,
                                                            style: GoogleFonts
                                                                .poppins(
                                                                    fontSize:
                                                                        15),
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ))
                                                    .toList(),
                                                value: memberNameController.text,
                                                onChanged: (String? value) {
                                                  membersList
                                                      .forEach((element) {
                                                    if (element.name == value) {
                                                      setState(() {
                                                        memberNameController.text = element.name;
                                                        memberFamilyNameController.text = element.familyName;
                                                        memberIdController.text = element.memberId;
                                                      });
                                                    }
                                                  });
                                                },
                                                buttonStyleData:
                                                    ButtonStyleData(
                                                  height: 50,
                                                  width: 160,
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 14, right: 14),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    color: Color(0xffDDDEEE),
                                                  ),
                                                ),
                                                iconStyleData:
                                                    const IconStyleData(
                                                  icon: Icon(
                                                    Icons
                                                        .arrow_forward_ios_outlined,
                                                  ),
                                                  iconSize: 14,
                                                  iconEnabledColor:
                                                      Colors.black,
                                                  iconDisabledColor:
                                                      Colors.grey,
                                                ),
                                                dropdownStyleData:
                                                    DropdownStyleData(
                                                  maxHeight: 200,
                                                  width: width / 5.464,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            14),
                                                    color: Color(0xffDDDEEE),
                                                  ),
                                                  scrollbarTheme:
                                                      ScrollbarThemeData(
                                                    radius:
                                                        const Radius.circular(
                                                            7),
                                                    thickness:
                                                        MaterialStateProperty
                                                            .all<double>(6),
                                                    thumbVisibility:
                                                        MaterialStateProperty
                                                            .all<bool>(true),
                                                  ),
                                                ),
                                                menuItemStyleData:
                                                    const MenuItemStyleData(
                                                  height: 40,
                                                  padding: EdgeInsets.only(
                                                      left: 14, right: 14),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(width: 20),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 0.0),
                                      child: Text("Select Family Name *",
                                          style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0.0, right: 25),
                                      child: Container(
                                        width: width / 6.83,
                                        height: height / 16.42,
                                        decoration: BoxDecoration(
                                            color: const Color(0xffDDDEEE),
                                            borderRadius:
                                                BorderRadius.circular(5)),
                                        child: DropdownButtonHideUnderline(
                                          child: DropdownButton2<String>(
                                            isExpanded: true,
                                            hint: Row(
                                              children: [
                                                Icon(
                                                  Icons.list,
                                                  size: 16,
                                                  color: Colors.black,
                                                ),
                                                SizedBox(
                                                  width: 4,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    'Select Option',
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 15),
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            items: membersList
                                                .map((item) =>
                                                    DropdownMenuItem<String>(
                                                      value: item.familyName,
                                                      child: Text(
                                                        item.familyName,
                                                        style:
                                                            GoogleFonts.poppins(
                                                                fontSize: 15),
                                                        overflow: TextOverflow
                                                            .ellipsis,
                                                      ),
                                                    ))
                                                .toList(),
                                            value:
                                                memberFamilyNameController.text,
                                            onChanged: (String? value) {
                                              membersList.forEach((element) {
                                                if (element.familyName ==
                                                    value) {
                                                  setState(() {
                                                    memberFamilyNameController
                                                            .text =
                                                        element.familyName;
                                                    memberNameController.text =
                                                        element.name;
                                                    memberIdController.text =
                                                        element.memberId;
                                                  });
                                                }
                                              });
                                            },
                                            buttonStyleData: ButtonStyleData(
                                              height: 50,
                                              width: 160,
                                              padding: const EdgeInsets.only(
                                                  left: 14, right: 14),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                color: Color(0xffDDDEEE),
                                              ),
                                            ),
                                            iconStyleData: const IconStyleData(
                                              icon: Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                              ),
                                              iconSize: 14,
                                              iconEnabledColor: Colors.black,
                                              iconDisabledColor: Colors.grey,
                                            ),
                                            dropdownStyleData:
                                                DropdownStyleData(
                                              maxHeight: 200,
                                              width: width / 5.464,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(14),
                                                color: Color(0xffDDDEEE),
                                              ),
                                              scrollbarTheme:
                                                  ScrollbarThemeData(
                                                radius:
                                                    const Radius.circular(7),
                                                thickness: MaterialStateProperty
                                                    .all<double>(6),
                                                thumbVisibility:
                                                    MaterialStateProperty.all<
                                                        bool>(true),
                                              ),
                                            ),
                                            menuItemStyleData:
                                                const MenuItemStyleData(
                                              height: 40,
                                              padding: EdgeInsets.only(
                                                  left: 14, right: 14),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          right: 0.0),
                                      child: Text("Amount *",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                          ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 0.0, right: 25),
                                      child: Container(
                                        child: TextFormField(
                                          controller: amount,
                                          style: GoogleFonts.poppins(
                                              fontSize: 15),
                                          validator: (value) => value!
                                              .isEmpty
                                              ? 'Field Cannot be Empty'
                                              : null,
                                          decoration:
                                          const InputDecoration(
                                            contentPadding:
                                            EdgeInsets.only(
                                                left: 10, bottom: 8),
                                            border: InputBorder.none,
                                          ),
                                        ),
                                        width: width / 6.83,
                                        height: height / 16.425,
                                        //color: Color(0xffDDDEEE),
                                        decoration: BoxDecoration(
                                            color:
                                            const Color(0xffDDDEEE),
                                            borderRadius:
                                            BorderRadius.circular(5)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            width: width / 1.050,
                            height: height / 5.212,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(left: 10.0, top: 8),
                                  child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 0.0),
                                            child: Text("Method *",
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 25),
                                            child: Container(
                                              child: TextFormField(
                                                controller: methodController,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 15),
                                                validator: (value) => value!
                                                    .isEmpty
                                                    ? 'Field Cannot be Empty'
                                                    : null,
                                                decoration:
                                                const InputDecoration(
                                                  contentPadding:
                                                  EdgeInsets.only(
                                                      left: 10, bottom: 8),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                              width: width / 6.83,
                                              height: height / 16.425,
                                              //color: Color(0xffDDDEEE),
                                              decoration: BoxDecoration(
                                                  color:
                                                  const Color(0xffDDDEEE),
                                                  borderRadius:
                                                  BorderRadius.circular(5)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                right: 0.0),
                                            child: Text("No.of Months *",
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 0.0, right: 25),
                                            child: Container(
                                              child: TextFormField(
                                                controller: monthController,
                                                style: GoogleFonts.poppins(
                                                    fontSize: 15),
                                                validator: (value) => value!
                                                    .isEmpty
                                                    ? 'Field Cannot be Empty'
                                                    : null,
                                                decoration:
                                                const InputDecoration(
                                                  contentPadding:
                                                  EdgeInsets.only(
                                                      left: 10, bottom: 8),
                                                  border: InputBorder.none,
                                                ),
                                              ),
                                              width: width / 6.83,
                                              height: height / 16.425,
                                              //color: Color(0xffDDDEEE),
                                              decoration: BoxDecoration(
                                                  color:
                                                  const Color(0xffDDDEEE),
                                                  borderRadius:
                                                  BorderRadius.circular(5)),
                                            ),
                                          ),
                                        ],
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          FirebaseFirestore.instance.collection('MembershipReports').doc().set({
                                            "memberId" : memberIdController.text,
                                            "name" : memberNameController.text,
                                            "family" : memberFamilyNameController.text,
                                            "amount" : double.parse(amount.text.toString()),
                                            "months" : int.parse(monthController.text.toString()),
                                            "method" : methodController.text,
                                            "timestamp" : DateTime.now().millisecondsSinceEpoch,
                                          });
                                          setState(() {
                                            memberIdController.clear();
                                            memberNameController.clear();
                                            memberFamilyNameController.clear();
                                            memberFamilyNameController.clear();
                                            memberFamilyNameController.clear();
                                            memberFamilyNameController.clear();
                                          });
                                        },
                                        child: Container(
                                          child: Center(
                                              child: Text(
                                            "Save",
                                            style: GoogleFonts.poppins(
                                                color: Colors.white),
                                          )),
                                          width: width / 10.507,
                                          height: height / 16.425,
                                          // color:Color(0xff00A0E3),
                                          decoration: BoxDecoration(
                                              color: Constants().primaryAppColor,
                                              borderRadius:
                                                  BorderRadius.circular(5)),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
              }
              return Container();
            },
          )
        ],
      ),
    );
  }
}

class MembersWithDetails {
  MembersWithDetails(
      {required this.name, required this.familyName, required this.memberId, required this.docId});

  String name;
  String memberId;
  String familyName;
  String docId;
}

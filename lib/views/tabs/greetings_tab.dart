import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:church_management_admin/models/response.dart';
import 'package:church_management_admin/services/greeting_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/notification_model.dart';
import '../../models/user_model.dart';
import '../../models/wish_template_model.dart';
import '../../widgets/kText.dart';
import 'package:intl/intl.dart';

class GreetingsTab extends StatefulWidget {
  const GreetingsTab({super.key});

  @override
  State<GreetingsTab> createState() => _GreetingsTabState();
}

class _GreetingsTabState extends State<GreetingsTab> {
  String date = "";

  List<WishesTemplate> birthdayTemplateList = [];
  List<WishesTemplate> anniversaryTemplateList = [];

  TextEditingController templateTitleController = TextEditingController();
  TextEditingController templateContentController = TextEditingController();

  @override
  void initState() {
    setDate();
    super.initState();
  }

  setDate() {
    date = "${DateTime.now().day}-${DateTime.now().month}";
  }

  List<UserModel> selectedbirthUsers = [];
  List<UserModel> selectedAnnivarUsers = [];
  List<bool> selectedBirth = [];
  List<bool> selectedAnnivarsary = [];

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
              child: KText(
                text: "Wishes",
                style: GoogleFonts.openSans(
                    fontSize: width/52.53846153846154,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                StreamBuilder(
                  stream: GreetingFireCrud.fetchBirthydays(date),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return Container();
                    } else if (snapshot.hasData) {
                      List<UserModel> users = snapshot.data!;
                      users.forEach((element) {
                        selectedBirth.add(false);
                      });
                      return Container(
                        width: size.width / 2.7,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    KText(
                                      text:
                                          "Today's Birthday Babies (${users.length})",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/68.3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showSendWishesPopUp(true, selectedbirthUsers);
                                      },
                                      child: Container(
                                        height: height/16.275,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                            child: KText(
                                              text: "Send Wishes",
                                              style: GoogleFonts.openSans(
                                                fontSize: width/97.57142857142857,
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
                            ),
                            Container(
                              height: size.height * 0.7 > 65 + users.length * 60
                                  ? 65 + users.length * 60
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
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: width/136.6,
                                          ),
                                          SizedBox(
                                            width: width/17.075,
                                            child: KText(
                                              text: "Photo",
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/8.035294117647059,
                                            child: KText(
                                              text: "Name",
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/8.035294117647059,
                                            child: KText(
                                              text: "Phone",
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
                                      itemCount: users.length,
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
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: width/136.6,
                                                  child: Checkbox(
                                                    onChanged: (val){
                                                      setState(() {
                                                        selectedBirth[i] = val!;
                                                      });
                                                      if(val == true){
                                                        selectedbirthUsers.add(users[i]);
                                                      }else{
                                                        selectedbirthUsers.removeWhere((element) => element.id == users[i].id);
                                                      }
                                                    },
                                                    value: selectedBirth[i],
                                                  ),
                                                ),
                                                SizedBox(width: width/136.6),
                                                SizedBox(
                                                  width: width/17.075,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                users[i]
                                                                    .imgUrl!),
                                                        child: Visibility(
                                                          visible: users[i].imgUrl == "",
                                                          // child: Image.asset(
                                                          //   users[i].user.gender!.toLowerCase() == "male" ? "assets/mavatar.png" : "assets/favatar.png",
                                                          //   height: 40,
                                                          //   width: 40,
                                                          // )
                                                          child: Icon(
                                                              Icons.person
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/8.035294117647059,
                                                  child: KText(
                                                    text:
                                                    "${users[i].firstName!} ${users[i].lastName!="Null"? users[i].lastName! : ""}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/8.035294117647059,
                                                  child: KText(
                                                    text: users[i].phone!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight:
                                                          FontWeight.w600,
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
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                    return Container();
                  },
                ),
                StreamBuilder(
                  stream: GreetingFireCrud.fetchAnniversaries(date),
                  builder: (ctx, snapshot) {
                    if (snapshot.hasError) {
                      return Container();
                    } else if (snapshot.hasData) {
                      List<UserModel> users = snapshot.data!;
                      users.forEach((element) {
                        selectedAnnivarsary.add(false);
                      });
                      return Container(
                        width: size.width / 2.7,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    KText(
                                      text:
                                          "Today's Anniversaries (${users.length})",
                                      style: GoogleFonts.openSans(
                                        fontSize: width/68.3,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showSendWishesPopUp(false, selectedAnnivarUsers);
                                      },
                                      child: Container(
                                        height: height/16.275,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
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
                                            child: KText(
                                              text: "Send Wishes",
                                              style: GoogleFonts.openSans(
                                                fontSize: width/97.57142857142857,
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
                            ),
                            Container(
                              height: size.height * 0.7 > 65 + users.length * 60
                                  ? 65 + users.length * 60
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
                                      padding: const EdgeInsets.all(3.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          SizedBox(
                                            width: width/136.6,
                                          ),
                                          SizedBox(
                                            width: width/17.075,
                                            child: KText(
                                              text: "Photo",
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/8.035294117647059,
                                            child: KText(
                                              text: "Name",
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.0769230769231,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            width: width/8.035294117647059,
                                            child: KText(
                                              text: "Phone",
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
                                      itemCount: users.length,
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
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                SizedBox(
                                                  width: width/136.6,
                                                  child: Checkbox(
                                                    onChanged: (val){
                                                      setState(() {
                                                        selectedAnnivarsary[i] = val!;
                                                      });
                                                      if(val == true){
                                                        selectedAnnivarUsers.add(users[i]);
                                                      }else{
                                                        selectedAnnivarUsers.removeWhere((element) => element.id == users[i].id);
                                                      }
                                                    },
                                                    value: selectedAnnivarsary[i],
                                                  ),
                                                ),
                                                SizedBox(width: width/136.6),
                                                SizedBox(
                                                  width: width/17.075,
                                                  child: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    children: [
                                                      CircleAvatar(
                                                        backgroundImage:
                                                            NetworkImage(
                                                                users[i]
                                                                    .imgUrl!),

                                                        child: Visibility(
                                                          visible: users[i].imgUrl == "",
                                                          // child: Image.asset(
                                                          //   users[i].user.gender!.toLowerCase() == "male" ? "assets/mavatar.png" : "assets/favatar.png",
                                                          //   height: 40,
                                                          //   width: 40,
                                                          // )
                                                          child: Icon(
                                                              Icons.person
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/8.035294117647059,
                                                  child: KText(
                                                    text:
                                                    "${users[i].firstName!} ${users[i].lastName!="Null"? users[i].lastName! : ""}",
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                  width: width/8.035294117647059,
                                                  child: KText(
                                                    text: users[i].phone!,
                                                    style: GoogleFonts.poppins(
                                                      fontSize: width/105.0769230769231,
                                                      fontWeight:
                                                          FontWeight.w600,
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
            )
          ],
        ),
      ),
    );
  }

  addTemplatePopUp(bool isBirthday) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (ctx, setState) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              height: size.height * 0.5,
              width: size.width * 0.7,
              child: Column(
                children: [
                  Container(
                    height: size.height * 0.1,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        color: Constants().primaryAppColor,
                        borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10))),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: isBirthday
                              ? "Add Birthday Template"
                              : "Add Anniversary Template",
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
                            height: height/18.6,
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
                              const EdgeInsets.symmetric(horizontal: 6),
                              child: Center(
                                child: KText(
                                  text: "Close",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/97.57142857142857,
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
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: width/4.553333333333333,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Title",
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: width/105.0769230769231,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextFormField(
                                  style: TextStyle(fontSize: width/113.8333333333333),
                                  controller: templateTitleController,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: height/32.55),
                          SizedBox(
                            width: width/4.553333333333333,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                KText(
                                  text: "Content",
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: width/105.0769230769231,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                TextFormField(
                                  style: TextStyle(fontSize: width/113.8333333333333),
                                  controller: templateContentController,
                                )
                              ],
                            ),
                          ),
                          SizedBox(height: height/32.55),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  WishesTemplate template = WishesTemplate(
                                      title: templateTitleController.text, content: templateContentController.text, selected: false, id: "",withName:false,
                                  );
                                  Response response = await GreetingFireCrud.addWishTemplate(template: template, isBirthday: isBirthday);
                                  if (response.code == 200) {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.success,
                                        text:
                                        "Wish Added  Successfully!",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    Navigator.pop(context);
                                    Navigator.pop(context);
                                  } else {
                                    CoolAlert.show(
                                        context: context,
                                        type: CoolAlertType.error,
                                        text:
                                        "Failed to add wish",
                                        width: size.width * 0.4,
                                        backgroundColor: Constants()
                                            .primaryAppColor
                                            .withOpacity(0.8));
                                    Navigator.pop(context);
                                  }
                                },
                                child: Container(
                                  height: height/18.6,
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
                                      child: KText(
                                        text: "ADD NOW",
                                        style: GoogleFonts.openSans(
                                          color: Constants().btnTextColor,
                                          fontSize: width/136.6,
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
                  )
                ],
              ),
            ),
          );
        });
      },
    );
  }

  showSendWishesPopUp(bool isBirthday, List<UserModel> users) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setState) {
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
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                          color: Constants().primaryAppColor,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(10),
                              topRight: Radius.circular(10))),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: isBirthday
                                ? "Send Birthday Wishes"
                                : "Send Anniversary Wishes",
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
                              height: height/18.6,
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
                                    const EdgeInsets.symmetric(horizontal: 6),
                                child: Center(
                                  child: KText(
                                    text: "Close",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/97.57142857142857,
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
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: KText(
                                      text: "Select Template",
                                      style: GoogleFonts.openSans(
                                          fontSize: width/85.375, color: Colors.black),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: InkWell(
                                      onTap: (){
                                        addTemplatePopUp(isBirthday);
                                      },
                                      child: KText(
                                        text: "Add Template",
                                        style: GoogleFonts.openSans(
                                            fontSize: width/85.375, color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              isBirthday
                                  ? StreamBuilder(
                                      stream: GreetingFireCrud.fetchBirthdayWishesTemplates(),
                                      builder: (ctx, snapshot) {
                                        if (snapshot.hasError) {
                                          return Container();
                                        } else if (snapshot.hasData) {
                                          List<WishesTemplate>
                                              birthdayTemplateList1 =
                                              snapshot.data!;
                                          if (birthdayTemplateList.length != birthdayTemplateList1.length) {
                                            birthdayTemplateList = birthdayTemplateList1;
                                          }
                                          return Container(
                                            height: size.height * 0.47,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ListView.builder(
                                              itemCount:
                                                  birthdayTemplateList.length,
                                              itemBuilder: (ctx, i) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                        const EdgeInsets.all(5),
                                                    child: ListTile(
                                                      style: ListTileStyle.list,
                                                      leading: Checkbox(
                                                        value:
                                                            birthdayTemplateList[
                                                                    i]
                                                                .selected,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            birthdayTemplateList[
                                                                        i]
                                                                    .selected =
                                                                !birthdayTemplateList[
                                                                        i]
                                                                    .selected!;
                                                          });
                                                        },
                                                      ),
                                                      title: Text(
                                                        birthdayTemplateList[i].withName == true ?  "${birthdayTemplateList[i].title!} {Name}" : birthdayTemplateList[i].title!,
                                                      ),
                                                      subtitle: Text(
                                                        birthdayTemplateList[i]
                                                            .content!,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                        return Container();
                                      },
                                    )
                                  : StreamBuilder(
                                      stream: GreetingFireCrud
                                          .fetchAnniversaryWishesTemplates(),
                                      builder: (ctx, snapshot) {
                                        if (snapshot.hasError) {
                                          return Container();
                                        } else if (snapshot.hasData) {
                                          List<WishesTemplate>
                                              anniversaryTemplateList1 =
                                              snapshot.data!;
                                          if (anniversaryTemplateList.length != anniversaryTemplateList1.length) {
                                            anniversaryTemplateList =
                                                anniversaryTemplateList1;
                                          }
                                          return Container(
                                            height: size.height * 0.47,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
                                              color: Colors.grey.shade50,
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: ListView.builder(
                                              itemCount: anniversaryTemplateList
                                                  .length,
                                              itemBuilder: (ctx, i) {
                                                return Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
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
                                                        const EdgeInsets.all(5),
                                                    child: ListTile(
                                                      style: ListTileStyle.list,
                                                      leading: Checkbox(
                                                        value:
                                                            anniversaryTemplateList[
                                                                    i]
                                                                .selected,
                                                        onChanged: (val) {
                                                          setState(() {
                                                            anniversaryTemplateList[
                                                                        i]
                                                                    .selected =
                                                                !anniversaryTemplateList[
                                                                        i]
                                                                    .selected!;
                                                          });
                                                        },
                                                      ),
                                                      title: Text(
                                                        anniversaryTemplateList[i].withName == true ? "${anniversaryTemplateList[i].title!} {Name}" : anniversaryTemplateList[i].title! ,
                                                      ),
                                                      subtitle: Text(
                                                        anniversaryTemplateList[i].content!,
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              },
                                            ),
                                          );
                                        }
                                        return Container();
                                      },
                                    ),
                              SizedBox(height: height/21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {

                                        Response response = await sendWishes(
                                            users,
                                            isBirthday
                                                ? birthdayTemplateList
                                                : anniversaryTemplateList);
                                        if (response.code == 200) {
                                          await CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text:
                                              "Wish Sended to Users Successfully!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          Navigator.pop(context);
                                        } else {
                                          await CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: response.message,
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          Navigator.pop(context);
                                        }
                                    },
                                    child: Container(
                                      height: height/18.6,
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
                                          child: KText(
                                            text: "SEND NOW",
                                            style: GoogleFonts.openSans(
                                              color: Constants().btnTextColor,
                                              fontSize: width/136.6,
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
                    )
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<Response> sendWishes(
      List<UserModel> users, List<WishesTemplate> templates) async {
    Response response = Response();
    List<WishesTemplate> wishes = [];
    for (int i = 0; i < templates.length; i++) {
      if (templates[i].selected == true) {
        for (int j = 0; j < users.length; j++) {
          setState(() {
            templates[i].selected = false;
          });
          if(templates[i].withName == true){
            wishes.add(
              WishesTemplate(
                content: templates[i].content,
                id: templates[i].id,
                selected: false,
                title: "${templates[i].title} ${users[i].firstName + users[i].lastName !="Null"?users[i].lastName : ""}",
                withName: false,
              )
            );
          }else{
           wishes.add(templates[i]);
          }
        }
      }
    }
    if(wishes.isNotEmpty){
      users.forEach((element) async {
        await sendEmail([element.email!], wishes[0].title!, wishes[0].content!);
        await sendPushMessage(element.fcmToken!, wishes[0].title!, wishes[0].content!);
        await addToNotificationCollection(wishes[0].title!,wishes[0].content!,element);
        await addToUserNotificationCollection(wishes[0].title!,wishes[0].content!,element);
      });
      response.code = 200;
      response.message = "Wishes send Successfully";
    }else{
      response.code = 500;
      response.message = "Please Select one Template";
    }
    return response;
  }

  Future<Response> sendEmail(List<String> receiversList, String subject, String description) async {
    Response response = Response();
    for(int i = 0; i < receiversList.length; i ++) {
      DocumentReference documentReferencer = FirebaseFirestore.instance
          .collection('mail').doc();
      var json = {
        "to": receiversList[i],
        "message": {
          "subject": subject,
          "text": description,
        },
      };
      var result = await documentReferencer.set(json).whenComplete(() {
        response.code = 200;
        response.message = "Sucessfully added to the database";
      }).catchError((e) {
        response.code = 500;
        response.message = e;
      });
    }
    return response;
  }

  Future<bool> addToNotificationCollection(String title,String body,UserModel user) async {
    bool isAdded = false;
    NotificationModel notificationModel = NotificationModel(
      date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      time: DateFormat('hh:mm a').format(DateTime.now()),
      timestamp: DateTime.now().millisecondsSinceEpoch,
      content: body,
      to: user.phone,
      subject: title,
      isViewed: false,
      viewsCount: [],
      // date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      // time: DateFormat('hh:mm a').format(DateTime.now()),
      // timestamp: DateTime.now().millisecondsSinceEpoch,
      // content: body,
      // to: user.phone,
      // subject: title,
    );
    var json = notificationModel.toJson();
    await FirebaseFirestore.instance.collection('Notifications').add(json).whenComplete(() {
      isAdded = true;
    }).catchError((e) {
      isAdded = false;
    });
    return isAdded;
  }

  Future<bool> addToUserNotificationCollection(String title,String body,UserModel user) async {
    bool isAdded = false;
    NotificationModel notificationModel = NotificationModel(
        date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
        time: DateFormat('hh:mm a').format(DateTime.now()),
        timestamp: DateTime.now().millisecondsSinceEpoch,
        content: body,
        to: user.phone,
        subject: title,
        isViewed: false,
        viewsCount: [],
      // date: DateFormat('dd-MM-yyyy').format(DateTime.now()),
      // time: DateFormat('hh:mm a').format(DateTime.now()),
      // timestamp: DateTime.now().millisecondsSinceEpoch,
      // content: body,
      // to: user.phone,
      // subject: title,
    );
    var json = notificationModel.toJson();
    var userDocument = await FirebaseFirestore.instance.collection('Users').get();
    for(int i = 0; i < userDocument.docs.length; i ++){
      if(userDocument.docs[i]["id"] == user.id){
        await FirebaseFirestore.instance.collection('Users').doc(userDocument.docs[i].id).collection('Notifications').add(json).whenComplete(() {
          isAdded = true;
        }).catchError((e) {
          isAdded = false;
        });
      }
    }
    return isAdded;
  }

  Future<bool> sendPushMessage(String token, String title, String body) async {
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

}

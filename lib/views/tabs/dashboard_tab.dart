import 'dart:math';
import 'package:church_management_admin/views/tabs/settings_tab.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:translator/translator.dart';
import 'package:intl/intl.dart';
import '../../constants.dart';
import '../../models/dashboard_model.dart';
import '../../models/manage_role_model.dart';
import '../../services/dashboard_firecrud.dart';
import '../../services/role_permission_firecrud.dart';
import '../../widgets/kText.dart';
import '../login_view.dart';
import 'messages_tab.dart';

class DashBoardTab extends StatefulWidget {
   DashBoardTab({super.key, required this.currentRole});

  final String currentRole;
  @override
  State<DashBoardTab> createState() => _DashBoardTabState();
}

class _DashBoardTabState extends State<DashBoardTab> {
  GoogleTranslator translator = GoogleTranslator();

  List<String> rolesList = [];
  List<String> dashboardItemsList = [];
  bool isFetched = false;
  DashboardModel dashboard = DashboardModel();

   _showPopupMenu() async {
     double height=MediaQuery.of(context).size.height;
     double width=MediaQuery.of(context).size.width;
     
    await showMenu(
        context: context,
        color: Colors.white,
        position:  const RelativeRect.fromLTRB(200, 100, 100, 500),
        items: [
          PopupMenuItem(
            child: PopupMenuButton(
              onSelected: (val) {
                Navigator.pop(context);
              },
              position: PopupMenuPosition.over,
              itemBuilder: (ctx) {
                return [
                  PopupMenuItem<String>(
                    value: 'ta',
                    child:  const Text('Tamil'),
                    onTap: () {
                      changeLocale(context, 'ta');
                      changeHomeViewLanguage();
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'hi',
                    child:  const Text('Hindi'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'hi');
                        changeHomeViewLanguage();
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'te',
                    child:  const Text('Telugu'),
                    onTap: () {
                      changeLocale(context, 'te');
                      changeHomeViewLanguage();
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'ml',
                    child:  const Text('Malayalam'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'ml');
                        changeHomeViewLanguage();
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'kn',
                    child:  const Text('Kannada'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'kn');
                        changeHomeViewLanguage();
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'mr',
                    child:  const Text('Marathi'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'mr');
                        changeHomeViewLanguage();
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'gu',
                    child:  const Text('Gujarati'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'gu');
                        changeHomeViewLanguage();
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'or',
                    child:  const Text('Odia'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'or');
                        changeHomeViewLanguage();
                      });
                    },
                  ),
                ];
              },
              child: Row(
                children: [
                  CountryFlag.fromLanguageCode(
                    "hi",
                    height: height/16.275,
                    width: width/45.53,
                  ),
                   SizedBox(width: width/136.6),
                   const Text("South India"),
                ],
              ),
            ),
          ),
          PopupMenuItem<String>(
            value: 'en_US',
            child: Row(
              children: [
                CountryFlag.fromLanguageCode(
                  "en",
                  height: height/16.275,
                  width: width/45.53,
                ),
                 SizedBox(width: width/136.6),
                 const Text('English'),
              ],
            ),
            onTap: () {
              changeLocale(context, 'en_US');
              changeHomeViewLanguage();
            },
          ),
          PopupMenuItem<String>(
            value: 'bn',
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  "BD",
                  height: height/16.275,
                  width: width/45.53,
                ),
                 SizedBox(width: width/136.6),
                 const Text('Bengali'),
              ],
            ),
            onTap: () {
              changeLocale(context, 'bn');
              changeHomeViewLanguage();
            },
          ),
          PopupMenuItem<String>(
            value: 'es',
            child: Row(
              children: [
                CountryFlag.fromLanguageCode(
                  "es",
                  height: height/16.275,
                  width: width/45.53,
                ),
                 SizedBox(width: width/136.6),
                 const Text('Spanish'),
              ],
            ),
            onTap: () {
              setState(() {
                changeLocale(context, 'es');
                changeHomeViewLanguage();
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'pt',
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  "PT",
                  height: height/16.275,
                  width: width/45.53,
                ),
                 SizedBox(width: width/136.6),
                 const Text('Portuguese'),
              ],
            ),
            onTap: () {
              setState(() {
                changeLocale(context, 'pt');
                changeHomeViewLanguage();
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'fr',
            child: Row(
              children: [
                CountryFlag.fromLanguageCode(
                  "fr",
                  height: height/16.275,
                  width: width/45.53,
                ),
                 SizedBox(width: width/136.6),
                 const Text('French'),
              ],
            ),
            onTap: () {
              setState(() {
                changeLocale(context, 'fr');
                changeHomeViewLanguage();
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'nl',
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  "NL",
                  height: height/16.275,
                  width: width/45.53,
                ),
                 SizedBox(width: width/136.6),
                 const Text('Dutch'),
              ],
            ),
            onTap: () {
              setState(() {
                changeLocale(context, 'nl');
                changeHomeViewLanguage();
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'de',
            child: Row(
              children: [
                CountryFlag.fromLanguageCode(
                  "de",
                  height: height/16.275,
                  width: width/45.53,
                ),
                 SizedBox(width: width/136.6),
                 const Text('German'),
              ],
            ),
            onTap: () {
              setState(() {
                changeLocale(context, 'de');
                changeHomeViewLanguage();
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'it',
            child: Row(
              children: [
                CountryFlag.fromLanguageCode(
                  "it",
                  height: height/16.275,
                  width: width/45.53,
                ),
                 SizedBox(width: width/136.6),
                 const Text('Italian'),
              ],
            ),
            onTap: () {
              setState(() {
                changeLocale(context, 'it');
                changeHomeViewLanguage();
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'sv',
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  "SE",
                  height: height/16.275,
                  width: width/45.53,
                ),
                 SizedBox(width: width/136.6),
                 const Text('Swedish'),
              ],
            ),
            onTap: () {
              setState(() {
                changeLocale(context, 'sv');
                changeHomeViewLanguage();
              });
            },
          ),
        ],
        elevation: 8.0,
        useRootNavigator: true);
  }



  int randomNumFromDate = 1;
   ///////

  changeHomeViewLanguage() {
    setState(() {});
  }

  setRoles(ManageRoleModel roles){
    rolesList.clear();
    dashboardItemsList.clear();
    if(roles.role != null){
      if(roles.permissions!.isNotEmpty) {
        for (int j = 0; j < roles.permissions!.length; j ++) {
          rolesList.add(roles.permissions![j]);
        }
      }else{
        rolesList = [];
      }
      if(roles.dashboardItems!.isNotEmpty){
        for (int j = 0; j < roles.dashboardItems!.length; j ++) {
          dashboardItemsList.add(roles.dashboardItems![j]);
        }
      }else{
        dashboardItemsList = [];
      }
    }else{
      rolesList = [];
      dashboardItemsList = [];
    }
    isFetched = true;
  }

  @override
  void initState() {
    fetchDashboardValues();
    super.initState();
  }

  fetchDashboardValues() async {
    setState(() {
      isFetched = true;
    });
    var dashDocument = await DashboardFireCrud.fetchDashBoard();
    setState(() {
      dashboard = dashDocument;
    });
    setState(() {
      isFetched = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    int currentDate = DateTime.now().day;
    int month = DateTime.now().month;
    int rand = int.parse((month / 4).floor().toString());
    randomNumFromDate = currentDate * rand;
    Size size = MediaQuery.of(context).size;
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          decoration:  const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/Background.png"),
            ),
          ),
        ),
        Container(
          decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.white12,
                Colors.white,
              ])),
        ),
        Padding(
          padding:  EdgeInsets.symmetric(vertical: height/21.7,horizontal: width/45.53),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          KText(
                            text: 'WELCOME TO IKIA',
                            style: GoogleFonts.openSans(
                              fontSize: width/42.687,
                              fontWeight: FontWeight.w900,
                              color: Constants().primaryAppColor,
                            ),
                          ),
                          KText(
                            text: 'TO DO THE PREACHING OF JESUS',
                            style: GoogleFonts.openSans(
                                fontSize: width/68.3,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                      color: Constants().primaryAppColor,
                                      offset:  const Offset(2, 2),
                                      blurRadius: 3)
                                ]),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: size.width * 0.13,
                        child: Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                          children: [
                            InkWell(
                              onTap: () {
                                _showPopupMenu();
                              },
                              child:
                              Icon(Icons.g_translate, size: width/50.59),
                            ),
                            StreamBuilder(
                              stream: FirebaseFirestore.instance.collection('Messages').snapshots(),
                              builder: (ctx,snap){
                                if(snap.hasData){
                                  int count = 0;
                                  snap.data!.docs.forEach((element) {
                                    if(element.get("isViewed") == false){
                                      count++;
                                    }
                                  });
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  MessagesTab()));
                                    },
                                    child: count != 0 ? Badge(
                                        label: Text(count.toString()),
                                        backgroundColor: Constants().primaryAppColor,
                                        child: Icon(CupertinoIcons.mail, size: width/50.59)
                                    ) : Icon(CupertinoIcons.mail, size: width/50.59),
                                  );
                                }return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (ctx) =>
                                                MessagesTab()));
                                  },
                                  child:  Icon(CupertinoIcons.mail, size: width/50.59),
                                );
                              },
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (ctx) => SettingsTab()));
                              },
                              child:  Icon(Icons.settings, size: width/50.59),
                            ),
                            InkWell(
                              onTap: () async {
                                await CoolAlert.show(
                                    context: context,
                                    type: CoolAlertType.info,
                                    text: "Are you sure want to logout",
                                    confirmBtnText: 'Log Out',
                                    onConfirmBtnTap: () async {
                                      await FirebaseAuth.instance.signOut();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                              const LoginView()));
                                    },
                                    cancelBtnText: 'Cancel',
                                    showCancelBtn: true,
                                    width: size.width * 0.4,
                                    backgroundColor: Constants()
                                        .primaryAppColor
                                        .withOpacity(0.8));
                              },
                              child:  Icon(Icons.logout, size: width/50.59),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: size.height * 0.04),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('ChurchDetails').snapshots(),
                  builder: (ctx, snap){
                    if(snap.hasData){
                      var churchDeatils = snap.data!.docs.first;
                      return StreamBuilder(
                        stream: FirebaseFirestore.instance.collection('BibleVerses').snapshots(),
                        builder: (ctx, snapshot){
                          if(snapshot.hasData){
                            var bibleVerses = snapshot.data!;
                            var randnum = Random().nextInt(bibleVerses.docs.length);
                            return KText(
                              text: churchDeatils['verseForToday']['date'] == DateFormat('dd-MM-yyyy').format(DateTime.now()) ? churchDeatils['verseForToday']['text'] : bibleVerses.docs[randnum]['text'],
                              style: GoogleFonts.amaranth(
                                fontSize: width/50.59,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                shadows:  [
                                  const Shadow(
                                      color: Colors.black,
                                      offset: Offset(2, 2),
                                      blurRadius: 3)
                                ],
                              ),
                              maxLines: 4,
                            );
                          }return Container();
                        },
                      );
                    }return Container();
                  },
                ),
                SizedBox(height: size.height * 0.04),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     SizedBox(
                //       width: size.width * 0.7,
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Row(
                //             mainAxisAlignment: MainAxisAlignment.start,
                //             children: [
                //                SizedBox(width: 20),
                //               Container(
                //                 height: 120,
                //                 width: 270,
                //                 decoration: BoxDecoration(
                //                   border: Border.all(
                //                       color:  Color(0xff4EC812)),
                //                   borderRadius: BorderRadius.circular(10),
                //                   color:  Color(0xffDCFFCB),
                //                 ),
                //                 child: Padding(
                //                   padding:
                //                       EdgeInsets.all(size.height * 0.015),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       KText(
                //                         text: "Total Collect",
                //                         style: GoogleFonts.poppins(
                //                           fontSize: width/75.888,
                //                           color:  Color(0xff121843),
                //                         ),
                //                       ),
                //                       KText(
                //                         text:
                //                             r"$ " + dashboard.totalCollect! ??
                //                                 0.toString(),
                //                         style: GoogleFonts.rubik(
                //                           fontSize: 48,
                //                           color:  Color(0xff121843),
                //                         ),
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //                SizedBox(width: 20),
                //               Container(
                //                 height: 120,
                //                 width: 270,
                //                 decoration: BoxDecoration(
                //                   border: Border.all(
                //                       color:  Color(0xffFE8C8C)),
                //                   borderRadius: BorderRadius.circular(10),
                //                   color:  Color(0xffFFD1D1),
                //                 ),
                //                 child: Padding(
                //                   padding:
                //                       EdgeInsets.all(size.height * 0.015),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       KText(
                //                         text: "Total Spend",
                //                         style: GoogleFonts.poppins(
                //                           fontSize: width/75.888,
                //                           color:  Color(0xff121843),
                //                         ),
                //                       ),
                //                       KText(
                //                         text: r"$ " + dashboard.totalSpend! ??
                //                             0.toString(),
                //                         style: GoogleFonts.rubik(
                //                           fontSize: 48,
                //                           color:  Color(0xff121843),
                //                         ),
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //               ),
                //                SizedBox(width: 20),
                //               Container(
                //                 height: 120,
                //                 width: 270,
                //                 decoration: BoxDecoration(
                //                   border: Border.all(
                //                       color:  Color(0xff3786F1)),
                //                   borderRadius: BorderRadius.circular(10),
                //                   color:  Color(0xffE8F0FB),
                //                 ),
                //                 child: Padding(
                //                   padding:
                //                       EdgeInsets.all(size.height * 0.015),
                //                   child: Column(
                //                     mainAxisAlignment:
                //                         MainAxisAlignment.center,
                //                     crossAxisAlignment:
                //                         CrossAxisAlignment.start,
                //                     children: [
                //                       KText(
                //                         text: "Current Balance",
                //                         style: GoogleFonts.poppins(
                //                           fontSize: width/75.888,
                //                           color:  Color(0xff121843),
                //                         ),
                //                       ),
                //                       KText(
                //                         text: r"$ " +
                //                                 dashboard.currentBalance! ??
                //                             0.toString(),
                //                         style: GoogleFonts.rubik(
                //                           fontSize: 48,
                //                           color:  Color(0xff121843),
                //                         ),
                //                       )
                //                     ],
                //                   ),
                //                 ),
                //               )
                //             ],
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                //SizedBox(height: size.height * 0.06),
                StreamBuilder(
                  stream: RolePermissionFireCrud.fetchPermissionsfordashboard(),
                  builder: (ctx, snaps){
                    if(snaps.hasData){
                      List<ManageRoleModel> roles = snaps.data!;
                      ManageRoleModel managerRole = ManageRoleModel();
                      roles.forEach((element) {
                        if(element.role!.toUpperCase() == widget.currentRole.toUpperCase()){
                          managerRole = element;
                        }else if(widget.currentRole.toLowerCase() == 'ADMIN@GMAIL.COM@gmail.com'){
                          managerRole = element;
                        }
                      });
                      setRoles(managerRole);
                      return SizedBox(
                        width: size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Visibility(
                              visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true :
                              (dashboardItemsList.contains("Pastors") || dashboardItemsList.contains("Users") || dashboardItemsList.contains("Committee")),
                              child: Container(
                                height: size.height * 0.15,
                                width: width/1.393,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                  Border.all(color:  const Color(0xffE0E0E0)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Users"),
                                      child: SizedBox(
                                        width: width/4.553,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                              const Color(0xffE1F1FF),
                                              radius: 35,
                                              child: SvgPicture.asset(
                                                  "assets/basil_user-solid.svg"),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Container(
                                              height: size.height * 0.06,
                                              width: width/1366,
                                              color:  const Color(0xffE0A700),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                KText(
                                                  text: "Total Users",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/75.888,
                                                    color:  const Color(0xff121843),
                                                  ),
                                                ),
                                                SizedBox(height: height/217),
                                                KText(
                                                  text: dashboard.totalUsers ??
                                                      0.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width/68.3,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Committee"),
                                      child: SizedBox(
                                        width: width/4.553,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor:
                                                const Color(0xffD1F3E0),
                                                radius: 35,
                                                child: Icon(
                                                  Icons.groups,
                                                  size: width/27.32,
                                                  color: Colors.green,
                                                )),
                                            SizedBox(width: width/91.066),
                                            Container(
                                              height: size.height * 0.06,
                                              width: width/1366,
                                              color:  const Color(0xffE0A700),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                KText(
                                                  text: "Total Committee",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/75.888,
                                                    color:  const Color(0xff121843),
                                                  ),
                                                ),
                                                SizedBox(height: height/217),
                                                KText(
                                                  text: dashboard.totalCommite ??
                                                      0.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width/68.3,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Pastors"),
                                      child: SizedBox(
                                        width: width/4.553,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor:
                                                const Color(0xffFFF2D8),
                                                radius: 35,
                                                child: Icon(
                                                  Icons.person,
                                                  size: width/27.32,
                                                  color: Colors.amber,
                                                )),
                                            SizedBox(width: width/91.066),
                                            Container(
                                              height: size.height * 0.06,
                                              width: width/1366,
                                              color:  const Color(0xffE0A700),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                KText(
                                                  text: "Total Pastors",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/75.888,
                                                    color:  const Color(0xff121843),
                                                  ),
                                                ),
                                                SizedBox(height: height/217),
                                                KText(
                                                  text: dashboard.totalPastors ??
                                                      0.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width/68.3,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Visibility(
                              visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : (dashboardItemsList.contains("Clans") || dashboardItemsList.contains("Chorus") || dashboardItemsList.contains("Staff")),
                              child: Container(
                                height: size.height * 0.15,
                                width: width/1.393,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                  Border.all(color:  const Color(0xffE0E0E0)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Clans"),
                                      child: SizedBox(
                                        width: width/4.553,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                              const Color(0xffFFF1E1),
                                              radius: 35,
                                              child: SvgPicture.asset(
                                                  "assets/ri_group-2-fill.svg"),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Container(
                                              height: size.height * 0.06,
                                              width: width/1366,
                                              color:  const Color(0xffE0A700),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                KText(
                                                  text: "Total Clans",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/75.888,
                                                    color:  const Color(0xff121843),
                                                  ),
                                                ),
                                                SizedBox(height: height/217),
                                                KText(
                                                  text: dashboard.totalClans ??
                                                      0.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width/68.3,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Chorus"),
                                      child: SizedBox(
                                        width: width/4.553,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                              const Color(0xffE6D1F3),
                                              radius: 35,
                                              child: SvgPicture.asset(
                                                  "assets/typcn_group-outline.svg"),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Container(
                                              height: size.height * 0.06,
                                              width: width/1366,
                                              color:  const Color(0xffE0A700),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                KText(
                                                  text: "Total Chorus",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/75.888,
                                                    color:  const Color(0xff121843),
                                                  ),
                                                ),
                                                SizedBox(height: height/217),
                                                KText(
                                                  text: dashboard.totalChorus ??
                                                      0.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width/68.3,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Staff"),
                                      child: SizedBox(
                                        width: width/4.553,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                              const Color(0xffC5FFF8),
                                              radius: 35,
                                              child: SvgPicture.asset(
                                                  "assets/medical-icon_i-care-staff-area.svg"),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Container(
                                              height: size.height * 0.06,
                                              width: width/1366,
                                              color:  const Color(0xffE0A700),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                KText(
                                                  text: "Total Staffs",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/75.888,
                                                    color:  const Color(0xff121843),
                                                  ),
                                                ),
                                                SizedBox(height: height/217),
                                                KText(
                                                  text: dashboard.totalStaffs ??
                                                      0.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width/68.3,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Visibility(
                              visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : (dashboardItemsList.contains("Member") || dashboardItemsList.contains("Families") || dashboardItemsList.contains("Student")),
                              child: Container(
                                height: size.height * 0.15,
                                width: width/1.393,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                  Border.all(color:  const Color(0xffE0E0E0)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Student"),
                                      child: SizedBox(
                                        width: width/4.553,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                              const Color(0xffFFE1F7),
                                              radius: 35,
                                              child: SvgPicture.asset(
                                                  "assets/ph_student-bold.svg"),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Container(
                                              height: size.height * 0.06,
                                              width: width/1366,
                                              color:  const Color(0xffE0A700),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                KText(
                                                  text: "Total Students",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/75.888,
                                                    color:  const Color(0xff121843),
                                                  ),
                                                ),
                                                SizedBox(height: height/217),
                                                KText(
                                                  text: dashboard.totalStudents ??
                                                      0.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width/68.3,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Member"),
                                      child: SizedBox(
                                        width: width/4.553,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                              backgroundColor:
                                              const Color(0xffFFF495),
                                              radius: 35,
                                              child: SvgPicture.asset(
                                                  "assets/fluent_people-28-regular.svg"),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Container(
                                              height: size.height * 0.06,
                                              width: width/1366,
                                              color:  const Color(0xffE0A700),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                KText(
                                                  text: "Total Members",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/75.888,
                                                    color:  const Color(0xff121843),
                                                  ),
                                                ),
                                                SizedBox(height: height/217),
                                                KText(
                                                  text: dashboard.totalMembers ??
                                                      0.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width/68.3,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Families"),
                                      child: SizedBox(
                                        width: width/4.553,
                                        child: Row(
                                          children: [
                                            CircleAvatar(
                                                backgroundColor: const Color(0xffE1F1FF),
                                                radius: 35,
                                                child: Icon(Icons.family_restroom,
                                                    color: const Color(0xff3F7AFC),
                                                    size: width/27.32)),
                                            SizedBox(width: width/91.066),
                                            Container(
                                              height: size.height * 0.06,
                                              width: width/1366,
                                              color:  const Color(0xffE0A700),
                                            ),
                                            SizedBox(width: width/91.066),
                                            Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                              MainAxisAlignment.center,
                                              children: [
                                                KText(
                                                  text: "Total Families",
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/75.888,
                                                    color:  const Color(0xff121843),
                                                  ),
                                                ),
                                                SizedBox(height: height/217),
                                                KText(
                                                  text: dashboard.totalFamilies ??
                                                      0.toString(),
                                                  style: GoogleFonts.poppins(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: width/68.3,
                                                    color: Colors.black,
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
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Visibility(
                              visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : (dashboardItemsList.contains("Birthday") || dashboardItemsList.contains("Anniversary")),
                              child: Container(
                                height: size.height * 0.15,
                                width: width/1.393,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                  Border.all(color:  const Color(0xffE0E0E0)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Birthday"),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundColor:  const Color(0xffFFE1F7),
                                              radius: 35,
                                              child: Icon(
                                                Icons.cake,
                                                size: width/27.32,
                                                color: Colors.pink,
                                              )),
                                          SizedBox(width: width/91.066),
                                          Container(
                                            height: size.height * 0.06,
                                            width: width/1366,
                                            color:  const Color(0xffE0A700),
                                          ),
                                          SizedBox(width: width/91.066),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              KText(
                                                text: "Today's Birthday Count",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/75.888,
                                                  color:  const Color(0xff121843),
                                                ),
                                              ),
                                              SizedBox(height: height/217),
                                              KText(
                                                text: dashboard.birthdayCount ??
                                                    0.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: width/68.3,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Anniversary"),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundColor:  const Color(0xffFFF495),
                                              radius: 35,
                                              child: Icon(
                                                Icons.wallet_giftcard,
                                                size: width/27.32,
                                                color: Colors.amber,
                                              )),
                                          SizedBox(width: width/91.066),
                                          Container(
                                            height: size.height * 0.06,
                                            width: width/1366,
                                            color:  const Color(0xffE0A700),
                                          ),
                                          SizedBox(width: width/91.066),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              KText(
                                                text: "Today's Anniversary Count",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/75.888,
                                                  color:  const Color(0xff121843),
                                                ),
                                              ),
                                              SizedBox(height: height/217),
                                              KText(
                                                text: dashboard.annivarsaryCount ??
                                                    0.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: width/68.3,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Visibility(
                              visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : (dashboardItemsList.contains("MemberPresent") || dashboardItemsList.contains("Event Count")),
                              child: Container(
                                height: size.height * 0.15,
                                width: width/1.393,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border:
                                  Border.all(color:  const Color(0xffE0E0E0)),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Row(
                                  children: [
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("MemberPresent"),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundColor: Colors.orange.withOpacity(0.2),
                                              radius: 35,
                                              child: Icon(
                                                Icons.receipt_long_outlined,
                                                size: width/27.32,
                                                color: Colors.orange,
                                              )),
                                          SizedBox(width: width/91.066),
                                          Container(
                                            height: size.height * 0.06,
                                            width: width/1366,
                                            color:  const Color(0xffE0A700),
                                          ),
                                          SizedBox(width: width/91.066),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              KText(
                                                text: "Members Present Today",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/75.888,
                                                  color:  const Color(0xff121843),
                                                ),
                                              ),
                                              SizedBox(height: height/217),
                                              KText(
                                                text: dashboard.todayPresentMembers ??
                                                    0.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: width/68.3,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Event Count"),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                              backgroundColor:  const Color(0xffD1F3E0),
                                              radius: 35,
                                              child: Icon(
                                                Icons.notifications_on_sharp,
                                                size: width/27.32,
                                                color: Colors.green,
                                              )),
                                          SizedBox(width: width/91.066),
                                          Container(
                                            height: size.height * 0.06,
                                            width: width/1366,
                                            color:  const Color(0xffE0A700),
                                          ),
                                          SizedBox(width: width/91.066),
                                          Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              KText(
                                                text: "Today Events Count",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/75.888,
                                                  color:  const Color(0xff121843),
                                                ),
                                              ),
                                              SizedBox(height: height/217),
                                              KText(
                                                text: dashboard.todayEventsCount ??
                                                    0.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: width/68.3,
                                                  color: Colors.black,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }return Container();
                  },
                )
              ],
            )
          ),
        ),
        Visibility(
          visible: isFetched,
          child: CircleAvatar(
            radius: width/15.17777777777778,
            backgroundColor: Colors.white,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Center(
                  child: Lottie.asset(
                    'assets/churchLoading.json',
                    fit: BoxFit.contain,
                    height: size.height * 0.4,
                    width: size.width * 0.7,
                  ),
                ),
                SizedBox(
                  height: height/4.34,
                  width: width/9.106666666666667,
                  child: CircularProgressIndicator(
                    strokeWidth: 7.0,
                    backgroundColor: Colors.yellow,
                    color: Constants().primaryAppColor,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

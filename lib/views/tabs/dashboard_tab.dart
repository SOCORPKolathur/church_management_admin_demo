
import 'dart:async';
import 'dart:math';
import 'package:church_management_admin/views/tabs/reports_view.dart';
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
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:lottie/lottie.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:syncfusion_flutter_charts/charts.dart' as sfc;
import 'package:show_up_animation/show_up_animation.dart' as an;
import 'package:translator/translator.dart';
import '../../constants.dart';
import '../../models/dashboard_model.dart';
import '../../models/manage_role_model.dart';
import '../../services/dashboard_firecrud.dart';
import '../../services/role_permission_firecrud.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/event_calender.dart';
import '../../widgets/kText.dart';
import '../login_view.dart';
import 'about_us_tab.dart';
import 'messages_tab.dart';
import 'package:intl/intl.dart';

class DashBoardTab extends StatefulWidget {
   DashBoardTab({super.key, required this.currentRole,required this.sessionStateStream});

  final String currentRole;
   final StreamController<SessionState> sessionStateStream;

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
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'hi',
                    child:  const Text('Hindi'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'hi');
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'te',
                    child:  const Text('Telugu'),
                    onTap: () {
                      changeLocale(context, 'te');
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'ml',
                    child:  const Text('Malayalam'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'ml');
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'kn',
                    child:  const Text('Kannada'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'kn');
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'mr',
                    child:  const Text('Marathi'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'mr');
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'gu',
                    child:  const Text('Gujarati'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'gu');
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'or',
                    child:  const Text('Odia'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'or');
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'bn',
                    child:  const Text('Bengali'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'bn');
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
                   const Text("India"),
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
              //changeHomeViewLanguage();
            },
          ),
          // PopupMenuItem<String>(
          //   value: 'bn',
          //   child: Row(
          //     children: [
          //       CountryFlag.fromCountryCode(
          //         "BD",
          //         height: height/16.275,
          //         width: width/45.53,
          //       ),
          //        SizedBox(width: width/136.6),
          //        const Text('Bengali'),
          //     ],
          //   ),
          //   onTap: () {
          //     changeLocale(context, 'bn');
          //     changeHomeViewLanguage();
          //   },
          // ),
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
                //changeHomeViewLanguage();
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
                //changeHomeViewLanguage();
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
                //changeHomeViewLanguage();
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
                //changeHomeViewLanguage();
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
                //changeHomeViewLanguage();
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
                //changeHomeViewLanguage();
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
                //changeHomeViewLanguage();
              });
            },
          ),
          PopupMenuItem<String>(
            value: 'ltz',
            child: Row(
              children: [
                CountryFlag.fromCountryCode(
                  "LU",
                  height: height/16.275,
                  width: width/45.53,
                ),
                SizedBox(width: width/136.6),
                const Text('Luxembourish'),
              ],
            ),
            onTap: () {
              setState(() {
                changeLocale(context, 'ltz');
                //changeHomeViewLanguage();
              });
            },
          ),
        ],
        elevation: 8.0,
        useRootNavigator: true);
  }


  int randomNumFromDate = 1;
   ///////

  // changeHomeViewLanguage() {
  //   setState(() {});
  // }

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
    isFetched = false;
  }

  @override
  void initState() {
    _tooltipBehavior = sfc.TooltipBehavior(enable: true);
    fetchDashboardValues();
    super.initState();
  }

  String churchName = '';
  String churchLogo = '';

  fetchDashboardValues() async {
    var profileRequestDoc = await FirebaseFirestore.instance.collection('ProfileEditRequest').get();
    var churchDetails = await FirebaseFirestore.instance.collection('ChurchDetails').get();
    setState(() {
      churchName = churchDetails.docs.first.get("name");
      churchLogo = churchDetails.docs.first.get("logo");
      Constants.churchLogo = churchLogo;
      count += profileRequestDoc.docs.length;
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

  int count = 0;

  TextEditingController selectedDateController = TextEditingController(text: '12-09-2000');

  String page ="Dashboard";

  @override
  Widget build(BuildContext context) {
    widget.sessionStateStream.add(SessionState.startListening);
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    int currentDate = DateTime.now().day;
    int month = DateTime.now().month;
    int rand = int.parse((month / 4).floor().toString());
    randomNumFromDate = currentDate * rand;
    Size size = MediaQuery.of(context).size;
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return page == "Dashboard" ?Stack(
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
          padding:  EdgeInsets.only(top: height/21.7,left: width/45.53,right: width/45.53),
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
                          Text(
                            'WELCOME TO $churchName',
                            style: GoogleFonts.openSans(
                              fontSize: width/42.687,
                              fontWeight: FontWeight.w900,
                              color: Constants().primaryAppColor,
                            ),
                          ),
                          KText(
                            //text: 'TO DO THE PREACHING OF JESUS',
                            text: 'DILIGENTLY UNDERSTAND THE CONDITION OF YOUR SHEEP',
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
                                                  MessagesTab(),
                                          ),
                                      );
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
                            StatefulBuilder(
                              builder: (context,setStat) {
                                return PopupMenuButton(
                                  itemBuilder: (context) => [
                                    PopupMenuItem<String>(
                                      value: 'Settings',
                                      child: const Text('Settings'),
                                      onTap: () async {
                                        final navigator = Navigator.of(context);
                                        await Future.delayed(Duration.zero);
                                        navigator.push(
                                          MaterialPageRoute(builder: (_) => SettingsTab()),
                                        );
                                      },
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'About Us',
                                      child: const Text('About Us'),
                                      onTap: () async {
                                        final navigator = Navigator.of(context);
                                        await Future.delayed(Duration.zero);
                                        navigator.push(
                                          MaterialPageRoute(builder: (_) => AboutUsTab()),
                                        );
                                      },
                                    ),
                                    PopupMenuItem<String>(
                                      value: 'Log Out',
                                      child: const Text('Log Out'),
                                      onTap: () async {
                                        final navigator = Navigator.of(context);
                                        await Future.delayed(Duration.zero);
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
                                                       LoginView(sessionStateStream: widget.sessionStateStream)));
                                            },
                                            cancelBtnText: 'Cancel',
                                            showCancelBtn: true,
                                            width: width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                      },
                                    ),
                                  ],
                                  position: PopupMenuPosition.over,
                                  offset: const Offset(0, 30),
                                  color: const Color(0xffFFFFFF),
                                  elevation: 2,
                                    shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(20.0),
                                      ),
                                    ),
                                    child: const Icon(Icons.arrow_drop_down_circle_outlined,
                                        size: 28, color: Colors.black,
                                    )
                                );
                              }
                            ),
                            // InkWell(
                            //   onTap: () async {
                            //     await showMenu(
                            //     context: context,
                            //     color: Colors.white,
                            //     position:  const RelativeRect.fromLTRB(300, 100, 50, 500),
                            //     items: [
                            //       PopupMenuItem<String>(
                            //         value: 'Settings',
                            //         child: const Text('Settings'),
                            //         onTap: () {
                            //           Navigator.push(context, MaterialPageRoute(
                            //               builder: (context) => SettingsTab()));
                            //         },
                            //       ),
                            //       PopupMenuItem<String>(
                            //         value: 'About Us',
                            //         child: const Text('About Us'),
                            //         onTap: () {
                            //           Navigator.push(context, MaterialPageRoute(builder: (ctx) => AboutUsTab()));
                            //         },
                            //       ),
                            //       PopupMenuItem<String>(
                            //         value: 'Log Out',
                            //         child: const Text('Log Out'),
                            //         onTap: () async {
                            //           await CoolAlert.show(
                            //               context: context,
                            //               type: CoolAlertType.info,
                            //               text: "Are you sure want to logout",
                            //               confirmBtnText: 'Log Out',
                            //               onConfirmBtnTap: () async {
                            //                 await FirebaseAuth.instance.signOut();
                            //                 Navigator.pushReplacement(
                            //                     context,
                            //                     MaterialPageRoute(
                            //                         builder: (ctx) =>
                            //                         const LoginView()));
                            //               },
                            //               cancelBtnText: 'Cancel',
                            //               showCancelBtn: true,
                            //               width: width * 0.4,
                            //               backgroundColor: Constants()
                            //                   .primaryAppColor
                            //                   .withOpacity(0.8));
                            //         },
                            //       ),
                            //     ],
                            //     elevation: 8.0,
                            //     useRootNavigator: true,
                            //     );
                            //   },
                            //   child:  Icon(Icons.arrow_drop_down_circle_outlined, size: width/50.59),
                            // ),
                            // InkWell(
                            //   onTap: () {
                            //     Navigator.push(
                            //         context,
                            //         MaterialPageRoute(
                            //             builder: (ctx) => SettingsTab()));
                            //   },
                            //   child:  Icon(Icons.settings, size: width/50.59),
                            // ),
                            // InkWell(
                            //   onTap: () async {
                            //     await CoolAlert.show(
                            //         context: context,
                            //         type: CoolAlertType.info,
                            //         text: "Are you sure want to logout",
                            //         confirmBtnText: 'Log Out',
                            //         onConfirmBtnTap: () async {
                            //           await FirebaseAuth.instance.signOut();
                            //           Navigator.pushReplacement(
                            //               context,
                            //               MaterialPageRoute(
                            //                   builder: (ctx) =>
                            //                   const LoginView()));
                            //         },
                            //         cancelBtnText: 'Cancel',
                            //         showCancelBtn: true,
                            //         width: size.width * 0.4,
                            //         backgroundColor: Constants()
                            //             .primaryAppColor
                            //             .withOpacity(0.8));
                            //   },
                            //   child:  Icon(Icons.logout, size: width/50.59),
                            // ),
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
                        width: size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Visibility(
                              visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true :
                              (dashboardItemsList.contains("Pastors") || dashboardItemsList.contains("Users") || dashboardItemsList.contains("Committee")),
                              child: Container(
                                height: size.height * 0.15,
                                width: width,
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
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Users";
                                          });
                                        },
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
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Committee"),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Committee";
                                          });
                                        },
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
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Pastors"),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Pastors";
                                          });
                                        },
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
                                width: width,
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
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Clans";
                                          });
                                        },
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
                                                    text: "Total Flocks",
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
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Chorus"),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Chorus";
                                          });
                                        },
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
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Staff"),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Staffs";
                                          });
                                        },
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
                                width: width,
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
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Students";
                                          });
                                        },
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
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Member"),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Members";
                                          });
                                        },
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
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Families"),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Families";
                                          });
                                        },
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
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Visibility(
                              visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : (dashboardItemsList.contains("Birthday") || dashboardItemsList.contains("Anniversary")),
                              child: InkWell(
                                onTap: (){
                                  setState(() {
                                    page="Birthday";
                                  });
                                },
                                child: Container(
                                  height: size.height * 0.15,
                                  width: width,
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
                            ),
                            SizedBox(height: size.height * 0.02),
                            Visibility(
                              visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : (dashboardItemsList.contains("MemberPresent") || dashboardItemsList.contains("Event Count")),
                              child: Container(
                                height: size.height * 0.15,
                                width: width,
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
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Members Attendance";
                                          });
                                        },
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
                                    ),
                                    SizedBox(width: width/91.066),
                                    Visibility(
                                      visible: widget.currentRole.toUpperCase() == "ADMIN@GMAIL.COM" ? true : dashboardItemsList.contains("Event Count"),
                                      child: InkWell(
                                        onTap: (){
                                          setState(() {
                                            page="Events";
                                          });
                                        },
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
                ),
                SizedBox(height: size.height * 0.04),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FutureBuilder<MembershipReportModel>(
                      future: getMemebershipReports(),
                      builder: (ctx, snapshot){
                        if(snapshot.hasData){
                          return Material(
                            elevation: 7,
                            borderRadius: BorderRadius.circular(12),
                            shadowColor:  Constants().primaryAppColor.withOpacity(0.20),
                            child: Column(
                              children: [
                                SizedBox(height: 20,),
                                Text("Membership Reports",style: GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: 18),),
                                Container(
                                  height: 370,
                                    width: width * 0.38,
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 40),
                                      child: Container(
                                        height: 170,
                                        width: 850,
                                        child: sfc.SfCartesianChart(
                                            primaryXAxis: sfc.CategoryAxis(),
                                            title: sfc.ChartTitle(
                                                text: '',
                                                textStyle: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black,
                                                ),
                                                alignment: sfc.ChartAlignment.near
                                            ),
                                            legend: sfc.Legend(isVisible: true),
                                            tooltipBehavior: _tooltipBehavior,
                                            series: <sfc.LineSeries<SalesData, String>>[
                                              sfc.LineSeries<SalesData, String>(
                                                name: "",
                                                dataSource: snapshot.data!.data,
                                                xValueMapper: (SalesData sales, _) => sales.year,
                                                yValueMapper: (SalesData sales, _) => sales.sales,
                                                // Enable data label
                                                dataLabelSettings: sfc.DataLabelSettings(isVisible: true),
                                                color: Constants().primaryAppColor,
                                                width: 5,
                                                animationDuration: 2000,
                                              )
                                            ]
                                        ),
                                      ),
                                    )
                                ),
                              ],
                            ),
                          );
                        }return Row(
                          children: [
                            SizedBox(width: 20,),
                            Container(
                                width: width/2.7,
                                child: Container(
                                  height: 420,
                                  width: 850,
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      sfc.SfCartesianChart(
                                          primaryXAxis: sfc.CategoryAxis(),
                                          title: sfc.ChartTitle(
                                              text: '   Membership Reports',
                                              textStyle: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                color: Colors.black,
                                              ),
                                              alignment: sfc.ChartAlignment.near,
                                          ),
                                          legend: sfc.Legend(isVisible: true),
                                          tooltipBehavior: _tooltipBehavior,
                                          series: <sfc.LineSeries<SalesData, String>>[
                                            sfc.LineSeries<SalesData, String>(
                                              name: "",
                                              dataSource: [],
                                              xValueMapper: (SalesData sales, _) => sales.year,
                                              yValueMapper: (SalesData sales, _) => sales.sales,
                                              // Enable data label
                                              dataLabelSettings: sfc.DataLabelSettings(isVisible: true),
                                              color: Constants().primaryAppColor,
                                              width: 5,
                                              animationDuration: 2000,
                                            )
                                          ]
                                      ),
                                      CircularProgressIndicator()
                                    ],
                                  ),
                                )
                            ),
                          ],
                        );
                      },
                    ),
                    StreamBuilder(
                      stream: FirebaseFirestore.instance.collection("EventsCalender").snapshots(),
                      builder: (ctx, snap){
                        if(snap.hasData){
                          List<Meeting> events = [];
                          List<Meeting> selectedEvents = [];
                          snap.data!.docs.forEach((element) {
                            events.add(Meeting(element.get("name"), DateFormat("dd-MM-yyyy").parse( element.get("ondate")), DateFormat("dd-MM-yyyy").parse( element.get("ondate")), Constants().primaryAppColor, false));
                          });
                          events.forEach((event) {
                            if(event.from == DateFormat('dd-MM-yyyy').parse(selectedDateController.text)){
                              selectedEvents.add(event);
                            }
                          });
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(top:8.0,right: 12),
                                  child: Material(
                                    elevation: 7,
                                    borderRadius: BorderRadius.circular(12),
                                    shadowColor:  Constants().primaryAppColor.withOpacity(0.20),
                                    child: Container(
                                        width: width * 0.38,
                                        height: 420,
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(12),
                                            border:Border.all(color: Constants().primaryAppColor.withOpacity(0.20))
                                        ),
                                        child:  Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(top:20.0,left: 15),
                                              child: Text("Events Calendar",style: GoogleFonts.poppins(fontWeight: FontWeight.w700,fontSize: 18),),
                                            ),
                                            Container(
                                              width: 500,
                                              height: 370,
                                              child: SfCalendar(
                                                onTap: (val){
                                                  setState(() {
                                                    selectedDateController.text = DateFormat('dd-MM-yyyy').format(val.date!);
                                                  });
                                                },
                                                // onLongPress: (val){
                                                //   setState(() {
                                                //     selectedDateController.text = DateFormat('dd-MM-yyyy').format(val.date!);
                                                //   });
                                                //   showDialog(
                                                //       context: context,
                                                //       builder: (BuildContext context) {
                                                //         return BouncingDraggableDialog(
                                                //           width: 600,
                                                //           height: 350,
                                                //           content: eventspop(val.date),
                                                //         );
                                                //       });
                                                // },
                                                view: CalendarView.month,
                                                allowDragAndDrop: true,
                                                dataSource: MeetingDataSource(events),
                                                monthViewSettings: MonthViewSettings(showAgenda: true),
                                              ),
                                            )

                                          ],
                                        )
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }return Container();
                      },
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.04),
                const DeveloperCardWidget(),
                SizedBox(height: size.height * 0.01),
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
    ) : Stack(
      alignment: Alignment.topCenter,
      children: [
        // page == "Users" ? UserTab():
        // page == "Committee" ? CommitteeTab():
        // page == "Pastors" ? PastorsTab():
        // page == "Clans" ? ClansTab():
        // page == "Chorus" ? ChorusTab():
        // page == "Staffs" ? ChurchStaffTab():
        // page == "Students" ? StudentTab():
        // page == "Members" ? MembersTab():
        // page == "Families" ? FamilyTab():
        // page == "Birthday" ? GreetingsTab():
        // page == "Members Attendance" ? AttendanceFamilyTab():
        // page == "Events" ? EventsTab():
        //UserTab(),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: InkWell(
            onTap: (){
              setState(() {
                page = "Dashboard";
              });
            },
            child: Material(
              elevation: 3,
              shadowColor: Constants().primaryAppColor,
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width:30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color:Constants().primaryAppColor)
                ),
                child: Center(
                  child: Icon(Icons.close,size: 15,),
                ),
              ),

            ),
          ),
        ),
      ],
    );
  }

  late sfc.TooltipBehavior _tooltipBehavior;
  int membersCount = 0;

  Future<MembershipReportModel> getMemebershipReports() async {

    List<SalesData> regularList = [];
    List<SalesData> regularList1 = [];

    var membershipDoc = await FirebaseFirestore.instance.collection('MembershipReports').get();

    for(int m = 0; m < membershipDoc.docs.length; m++){
      int presentCount = 0;
      presentCount++;
      DateTime startDate = DateFormat('dd/M/yyyy').parse(membershipDoc.docs[m].get("date"));
      String month = await getMonthForData(startDate.month);
      SalesData sale = SalesData(month, presentCount.toDouble(),'','');
      regularList1.add(sale);
    }

    regularList.add(SalesData('Jan',regularList1.where((element) => element.year == 'Jan').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Feb',regularList1.where((element) => element.year == 'Feb').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Mar',regularList1.where((element) => element.year == 'Mar').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Apr',regularList1.where((element) => element.year == 'Apr').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('June',regularList1.where((element) => element.year == 'June').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('July',regularList1.where((element) => element.year == 'July').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Aug',regularList1.where((element) => element.year == 'Aug').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Sep',regularList1.where((element) => element.year == 'Sep').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Oct',regularList1.where((element) => element.year == 'Oct').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Nov',regularList1.where((element) => element.year == 'Nov').length.toDouble() * 1000,'',''));
    regularList.add(SalesData('Dec',regularList1.where((element) => element.year == 'Dec').length.toDouble() * 1000,'',''));


    MembershipReportModel membership = MembershipReportModel(
      regular: ((regularList.length * 1000) /(membersCount * 12000)),
      irRegular: ((membersCount * 12000) - (regularList.length * 1000)) / (membersCount * 12000),
      data: regularList,
    );
    return membership;
  }

  getMonthForData(int month){
    String result = '';
    switch(month){
      case 1:
        result = 'Jan';
        break;
      case 2:
        result = 'Feb';
        break;
      case 3:
        result = 'Mar';
        break;
      case 4:
        result = 'Apr';
        break;
      case 5:
        result = 'May';
        break;
      case 6:
        result = 'June';
        break;
      case 7:
        result = 'July';
        break;
      case 8:
        result = 'Aug';
        break;
      case 9:
        result = 'Sep';
        break;
      case 10:
        result = 'Oct';
        break;
      case 11:
        result = 'Nov';
        break;
      case 12:
        result = 'Dec';
        break;

    }
    return result;
  }


}


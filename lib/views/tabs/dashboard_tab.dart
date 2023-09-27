import 'package:church_management_admin/models/dashboard_model.dart';
import 'package:church_management_admin/services/dashboard_firecrud.dart';
import 'package:church_management_admin/views/tabs/messages_tab.dart';
import 'package:church_management_admin/views/tabs/settings_tab.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:translator/translator.dart';
import '../../constants.dart';
import '../../models/verses_model.dart';
import '../../widgets/kText.dart';
import '../login_view.dart';

class DashBoardTab extends StatefulWidget {
  const DashBoardTab({super.key});

  @override
  State<DashBoardTab> createState() => _DashBoardTabState();
}

class _DashBoardTabState extends State<DashBoardTab> {
  GoogleTranslator translator = GoogleTranslator();

  void _showPopupMenu() async {
    await showMenu(
        context: context,
        color: Colors.white,
        position: const RelativeRect.fromLTRB(200, 100, 100, 500),
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
                    child: const Text('Tamil'),
                    onTap: () {
                      changeLocale(context, 'ta');
                      changeHomeViewLanguage();
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'hi',
                    child: const Text('Hindi'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'hi');
                        changeHomeViewLanguage();
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'te',
                    child: const Text('Telugu'),
                    onTap: () {
                      changeLocale(context, 'te');
                      changeHomeViewLanguage();
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'ml',
                    child: const Text('Malayalam'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'ml');
                        changeHomeViewLanguage();
                      });
                    },
                  ),
                  PopupMenuItem<String>(
                    value: 'kn',
                    child: const Text('Kannada'),
                    onTap: () {
                      setState(() {
                        changeLocale(context, 'kn');
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
                    height: 40,
                    width: 30,
                  ),
                  const SizedBox(width: 10),
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
                  height: 40,
                  width: 30,
                ),
                const SizedBox(width: 10),
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
                  height: 40,
                  width: 30,
                ),
                const SizedBox(width: 10),
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
                  height: 40,
                  width: 30,
                ),
                const SizedBox(width: 10),
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
                  height: 40,
                  width: 30,
                ),
                const SizedBox(width: 10),
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
                  height: 40,
                  width: 30,
                ),
                const SizedBox(width: 10),
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
                  height: 40,
                  width: 30,
                ),
                const SizedBox(width: 10),
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
                  height: 40,
                  width: 30,
                ),
                const SizedBox(width: 10),
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
                  height: 40,
                  width: 30,
                ),
                const SizedBox(width: 10),
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
                  height: 40,
                  width: 30,
                ),
                const SizedBox(width: 10),
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

  void _showPopupMenu1() async {
    await showMenu(
      context: context,
      color: Colors.white,
      position: const RelativeRect.fromLTRB(250, 100, 100, 500),
      items: [],
      elevation: 8.0,
    );
  }

  int randomNumFromDate = 1;

  changeHomeViewLanguage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    int currentDate = DateTime.now().day;
    int month = DateTime.now().month;
    int rand = int.parse((month / 4).floor().toString());
    randomNumFromDate = currentDate * rand;
    Size size = MediaQuery.of(context).size;
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage("assets/Background.png"),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                Colors.white12,
                Colors.white,
              ])),
        ),
        Padding(
          padding: const EdgeInsets.all(30.0),
          child: SingleChildScrollView(
            child: FutureBuilder(
              future: DashboardFireCrud.fetchDashBoard(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container(
                    child: Text(snapshot.error.toString()),
                  );
                } else if (snapshot.hasData) {
                  DashboardModel dashboard = snapshot.data!;
                  return Column(
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
                                  text: 'WELCOME TO STAY CONNECTED',
                                  style: GoogleFonts.openSans(
                                    fontSize: 32,
                                    fontWeight: FontWeight.w900,
                                    color: Constants().primaryAppColor,
                                  ),
                                ),
                                KText(
                                  text: 'TO DO THE PREACHING OF JESUS',
                                  style: GoogleFonts.openSans(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                            color: Constants().primaryAppColor,
                                            offset: const Offset(2, 2),
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
                                        const Icon(Icons.g_translate, size: 27),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const MessagesTab()));
                                    },
                                    child: const Icon(CupertinoIcons.mail,
                                        size: 27),
                                  ),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  const SettingsTab()));
                                    },
                                    child: const Icon(Icons.settings, size: 27),
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.info,
                                          text: "Are you sure want to logout",
                                          confirmBtnText: 'Log Out',
                                          onConfirmBtnTap: () async {
                                            await FirebaseAuth.instance
                                                .signOut();
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
                                    child: const Icon(Icons.logout, size: 27),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: size.height * 0.04),
                      KText(
                        text:
                            "“${Verses().versesList[randomNumFromDate].text}”",
                        style: GoogleFonts.amaranth(
                            fontSize: 27,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff000850),
                            shadows: [
                              Shadow(
                                  color: Constants().primaryAppColor,
                                  offset: Offset(2, 2),
                                  blurRadius: 3)
                            ],
                        ),
                        maxLines: 4,
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
                      //               const SizedBox(width: 20),
                      //               Container(
                      //                 height: 120,
                      //                 width: 270,
                      //                 decoration: BoxDecoration(
                      //                   border: Border.all(
                      //                       color: const Color(0xff4EC812)),
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   color: const Color(0xffDCFFCB),
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
                      //                           fontSize: 18,
                      //                           color: const Color(0xff121843),
                      //                         ),
                      //                       ),
                      //                       KText(
                      //                         text:
                      //                             r"$ " + dashboard.totalCollect! ??
                      //                                 0.toString(),
                      //                         style: GoogleFonts.rubik(
                      //                           fontSize: 48,
                      //                           color: const Color(0xff121843),
                      //                         ),
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //               const SizedBox(width: 20),
                      //               Container(
                      //                 height: 120,
                      //                 width: 270,
                      //                 decoration: BoxDecoration(
                      //                   border: Border.all(
                      //                       color: const Color(0xffFE8C8C)),
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   color: const Color(0xffFFD1D1),
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
                      //                           fontSize: 18,
                      //                           color: const Color(0xff121843),
                      //                         ),
                      //                       ),
                      //                       KText(
                      //                         text: r"$ " + dashboard.totalSpend! ??
                      //                             0.toString(),
                      //                         style: GoogleFonts.rubik(
                      //                           fontSize: 48,
                      //                           color: const Color(0xff121843),
                      //                         ),
                      //                       )
                      //                     ],
                      //                   ),
                      //                 ),
                      //               ),
                      //               const SizedBox(width: 20),
                      //               Container(
                      //                 height: 120,
                      //                 width: 270,
                      //                 decoration: BoxDecoration(
                      //                   border: Border.all(
                      //                       color: const Color(0xff3786F1)),
                      //                   borderRadius: BorderRadius.circular(10),
                      //                   color: const Color(0xffE8F0FB),
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
                      //                           fontSize: 18,
                      //                           color: const Color(0xff121843),
                      //                         ),
                      //                       ),
                      //                       KText(
                      //                         text: r"$ " +
                      //                                 dashboard.currentBalance! ??
                      //                             0.toString(),
                      //                         style: GoogleFonts.rubik(
                      //                           fontSize: 48,
                      //                           color: const Color(0xff121843),
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
                      SizedBox(
                        width: size.width * 0.8,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              height: size.height * 0.15,
                              width: 980,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xffE0E0E0)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xffE1F1FF),
                                          radius: 35,
                                          child: SvgPicture.asset(
                                              "assets/basil_user-solid.svg"),
                                        ),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: size.height * 0.06,
                                          width: 1,
                                          color: const Color(0xffE0A700),
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            KText(
                                              text: "Total Users",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: const Color(0xff121843),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            KText(
                                              text: dashboard.totalUsers ??
                                                  0.toString(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundColor:
                                                const Color(0xffD1F3E0),
                                            radius: 35,
                                            child: Icon(
                                              Icons.groups,
                                              size: 50,
                                              color: Colors.green,
                                            )),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: size.height * 0.06,
                                          width: 1,
                                          color: const Color(0xffE0A700),
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            KText(
                                              text: "Total Committee",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: const Color(0xff121843),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            KText(
                                              text: dashboard.totalCommite ??
                                                  0.toString(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                            backgroundColor:
                                                const Color(0xffFFF2D8),
                                            radius: 35,
                                            child: Icon(
                                              Icons.person,
                                              size: 50,
                                              color: Colors.amber,
                                            )),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: size.height * 0.06,
                                          width: 1,
                                          color: const Color(0xffE0A700),
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            KText(
                                              text: "Total Pastors",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: const Color(0xff121843),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            KText(
                                              text: dashboard.totalPastors ??
                                                  0.toString(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
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
                            SizedBox(height: size.height * 0.02),
                            Container(
                              height: size.height * 0.15,
                              width: 980,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xffE0E0E0)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xffFFF1E1),
                                          radius: 35,
                                          child: SvgPicture.asset(
                                              "assets/ri_group-2-fill.svg"),
                                        ),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: size.height * 0.06,
                                          width: 1,
                                          color: const Color(0xffE0A700),
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            KText(
                                              text: "Total Clans",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: const Color(0xff121843),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            KText(
                                              text: dashboard.totalClans ??
                                                  0.toString(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xffE6D1F3),
                                          radius: 35,
                                          child: SvgPicture.asset(
                                              "assets/typcn_group-outline.svg"),
                                        ),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: size.height * 0.06,
                                          width: 1,
                                          color: const Color(0xffE0A700),
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            KText(
                                              text: "Total Chorus",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: const Color(0xff121843),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            KText(
                                              text: dashboard.totalChorus ??
                                                  0.toString(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xffC5FFF8),
                                          radius: 35,
                                          child: SvgPicture.asset(
                                              "assets/medical-icon_i-care-staff-area.svg"),
                                        ),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: size.height * 0.06,
                                          width: 1,
                                          color: const Color(0xffE0A700),
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            KText(
                                              text: "Total Staffs",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: const Color(0xff121843),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            KText(
                                              text: dashboard.totalStaffs ??
                                                  0.toString(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
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
                            SizedBox(height: size.height * 0.02),
                            Container(
                              height: size.height * 0.15,
                              width: 980,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xffE0E0E0)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xffFFE1F7),
                                          radius: 35,
                                          child: SvgPicture.asset(
                                              "assets/ph_student-bold.svg"),
                                        ),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: size.height * 0.06,
                                          width: 1,
                                          color: const Color(0xffE0A700),
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            KText(
                                              text: "Total Students",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: const Color(0xff121843),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            KText(
                                              text: dashboard.totalStudents ??
                                                  0.toString(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          backgroundColor:
                                              const Color(0xffFFF495),
                                          radius: 35,
                                          child: SvgPicture.asset(
                                              "assets/fluent_people-28-regular.svg"),
                                        ),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: size.height * 0.06,
                                          width: 1,
                                          color: const Color(0xffE0A700),
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            KText(
                                              text: "Total Members",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: const Color(0xff121843),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            KText(
                                              text: dashboard.totalMembers ??
                                                  0.toString(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 15),
                                  SizedBox(
                                    width: 300,
                                    child: Row(
                                      children: [
                                        const CircleAvatar(
                                            backgroundColor: Color(0xffE1F1FF),
                                            radius: 35,
                                            child: Icon(Icons.family_restroom,
                                                color: Color(0xff3F7AFC),
                                                size: 50)),
                                        const SizedBox(width: 15),
                                        Container(
                                          height: size.height * 0.06,
                                          width: 1,
                                          color: const Color(0xffE0A700),
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            KText(
                                              text: "Total Families",
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                color: const Color(0xff121843),
                                              ),
                                            ),
                                            const SizedBox(height: 3),
                                            KText(
                                              text: dashboard.totalFamilies ??
                                                  0.toString(),
                                              style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 20,
                                                color: Colors.black,
                                              ),
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: size.height * 0.02),
                            Container(
                              height: size.height * 0.15,
                              width: 980,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xffE0E0E0)),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 15),
                                  const CircleAvatar(
                                      backgroundColor: const Color(0xffFFE1F7),
                                      radius: 35,
                                      child: Icon(
                                        Icons.cake,
                                        size: 50,
                                        color: Colors.pink,
                                      )),
                                  const SizedBox(width: 15),
                                  Container(
                                    height: size.height * 0.06,
                                    width: 1,
                                    color: const Color(0xffE0A700),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      KText(
                                        text: "Today's Birthday Count",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: const Color(0xff121843),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      KText(
                                        text: dashboard.birthdayCount ??
                                            0.toString(),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(width: 15),
                                  const CircleAvatar(
                                      backgroundColor: const Color(0xffFFF495),
                                      radius: 35,
                                      child: Icon(
                                        Icons.wallet_giftcard,
                                        size: 50,
                                        color: Colors.amber,
                                      )),
                                  const SizedBox(width: 15),
                                  Container(
                                    height: size.height * 0.06,
                                    width: 1,
                                    color: const Color(0xffE0A700),
                                  ),
                                  const SizedBox(width: 15),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      KText(
                                        text: "Today's Anniversary Count",
                                        style: GoogleFonts.poppins(
                                          fontSize: 18,
                                          color: const Color(0xff121843),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      KText(
                                        text: dashboard.annivarsaryCount ??
                                            0.toString(),
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                }
                return Container(
                  height: size.height,
                  width: double.infinity,
                  child: const Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}

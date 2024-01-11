import 'package:church_management_admin/constants.dart';
import 'package:church_management_admin/views/login_view.dart';
import 'package:church_management_admin/views/tabs/about_us_tab.dart';
import 'package:church_management_admin/views/tabs/settings_tab.dart';
import 'package:church_management_admin/widgets/event_calender.dart';
import 'package:church_management_admin/widgets/kText.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import 'views/tabs/HomeDrawer.dart';

class Dashboard2 extends StatefulWidget {
  const Dashboard2({super.key});

  @override
  State<Dashboard2> createState() => _Dashboard2State();
}

class _Dashboard2State extends State<Dashboard2> {

  List name =["JD", "MJ", "VJ"];
  List namelist =["John David", "Mary Jane", "Vignesh Joe"];

  List<Meeting> events = [];
  _showPopupMenu() async {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;

    await showMenu(
        context: context,
        color: Colors.white,
        position:  const RelativeRect.fromLTRB(200, 100, 100, 500),
        items: [
          PopupMenuItem<String>(
            value: 'en_US',
            child: const Text('English'),
            onTap: () {
              changeLocale(context, 'en_US');
              //changeHomeViewLanguage();
            },
          ),
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
          PopupMenuItem<String>(
            value: 'req',
            child:  const Text('Request Language'),
            onTap: () {
              setState(() {
                //changeLocale(context, 'bn');
              });
            },
          ),


        /*  PopupMenuItem<String>(
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
          ),*/
        ],
        elevation: 8.0,
        useRootNavigator: true);
  }

  @override
  Widget build(BuildContext context) {
    final double width=MediaQuery.of(context).size.width;
    final double height=MediaQuery.of(context).size.height;
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            Material(
              elevation: 2,
              child: Container(
                width: double.infinity,
                height: 70,
                color: Colors.white,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: KText(text:"Dashboard",
                        style: GoogleFonts.kanit(
                            fontSize: width/60,
                            fontWeight: FontWeight.w500,
                            color:   Color(0xff333333)),),
                    ),

                    Padding(
                      padding: const EdgeInsets.only(right: 20.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                              onTap: (){
                                _showPopupMenu();
                              },
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Color(0xff377DFF).withOpacity(0.20),
                                  borderRadius: BorderRadius.circular(8)
                                ),
                                child: Center(child: Icon(Icons.g_translate,color: Color(0xff377DFF),)),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: StatefulBuilder(
                                builder: (context,setStat) {
                                  return PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem<String>(
                                          value: 'Settings',
                                          child:  KText(text:'Settings', style: GoogleFonts.openSans(
                                              fontSize: width/105,
                                              fontWeight: FontWeight.w500,
                                             ),),
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
                                          child:  KText(text:'About Us',style: GoogleFonts.openSans(
                                            fontSize: width/105,
                                            fontWeight: FontWeight.w500,
                                          ),),
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
                                          child:  KText(text:'Log Out',style: GoogleFonts.openSans(
                                            fontSize: width/105,
                                            fontWeight: FontWeight.w500,
                                          ),),
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
                                                /*  Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              LoginView(sessionStateStream: widget.,)));*/
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
                                      child: Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                            color: Color(0xff377DFF).withOpacity(0.20),
                                            borderRadius: BorderRadius.circular(8)
                                        ),
                                        child: const Icon(Icons.settings,
                                          size: 28, color: Color(0xff377DFF),
                                        ),
                                      )
                                  );
                                }
                            ),
                          ),
                        ],
                      ),
                    ),





                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20.0,left: 15,bottom: 20),
              child: Row(
                children: [
                  Column(
                    children: [
                      Container(
                        width: 700,
                        height: 130,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Color(0xff0077FF)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 20,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,left: 10),
                                    child: KText(text:"Welcome Admin 👋",
                                      style: GoogleFonts.openSans(
                                          fontSize: width/50,
                                          fontWeight: FontWeight.w700,
                                          color:   Colors.white),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,left: 10),
                                    child: Container(
                                      width: 350,
                                      child: KText(text:"Cast your cares on the LORD and he will sustain you;\nhe will never let the righteous be shaken.",

                                        maxLines: 3,
                                        style: GoogleFonts.openSans(
                                            fontSize: width/105,
                                            fontWeight: FontWeight.w500,
                                            color:   Colors.white),
                                      ),
                                    ),
                                  ),


                                ],
                              ),
                              SizedBox(
                                width: 130,
                              ),
                              Image.asset("assets/churchbanner.png")
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 256,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:12.0),
                                    child: KText(text:"Church Database",
                                      style: GoogleFonts.kanit(
                                          fontSize: width/80,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff333333)),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 70.0),
                                    child: Container(
                                      width: 100,
                                        height: 100,
                                        child: DemoLanding()),
                                  ),
                                ],
                              ),

                            ),
                          ),
                          SizedBox(width: 8,),
                          Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 466,
                              height: 300,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:12.0),
                                    child: KText(text:"Membership Reports",
                                      style: GoogleFonts.kanit(
                                          fontSize: width/80,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff333333)),),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 50.0),
                                    child: LineChartSample2(),
                                  )
                                ],
                              ),

                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Row(
                        children: [
                          Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 436,
                              height: 240,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:15.0,left: 10,right: 10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        KText(text:"Messages",
                                          style: GoogleFonts.kanit(
                                              fontSize: width/80,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff333333)),),
                                        KText(text:"View All",
                                          style: GoogleFonts.kanit(
                                              fontSize: width/95,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xff0077FF)),),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: 400,
                                    child: Divider(
                                      thickness: 1.5,
                                      color: Color(0xffECECEC),
                                    ),
                                  ),
                                  Container(
                                    height: 180,
                                    child: ListView.builder(
                                      physics: NeverScrollableScrollPhysics(),
                                        itemCount: 3,
                                        itemBuilder: (context,index){
                                          return Column(
                                            children: [
                                              ListTile(
                                                leading: Container(
                                                  width: 35,
                                                  height: 35,
                                                  decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(70),
                                                    color: Constants.colorsList[index]
                                                  ),
                                                  child: Center(child: KText(text:name[index],style: GoogleFonts.openSans(
                                                      fontSize: width/80,
                                                      fontWeight: FontWeight.w600,
                                                      color:   Colors.white)))
                                                ),
                                                title: KText(text:namelist[index],style: GoogleFonts.kanit(
                                                    fontSize: width/95,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff333333)),),
                                                subtitle: KText(text:"Request to edit profile image",style: GoogleFonts.kanit(
                                          fontSize: width/110,
                                          fontWeight: FontWeight.w400,
                                          color: Color(0xff333333)),),
                                              ),
                                              Container(
                                                width: 400,
                                                child: Divider(
                                                  thickness: 1.5,
                                                  color: Color(0xffECECEC),
                                                ),
                                              ),
                                            ],
                                          );

                                    }),
                                  )

                                ],
                              ),

                            ),
                          ),
                          SizedBox(width: 8,),
                          Material(
                            elevation: 1,
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              width: 286,
                              height: 240,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20)
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top:15.0,),
                                    child: KText(text:"New Joined users",
                                      style: GoogleFonts.kanit(
                                          fontSize: width/80,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff333333)),),
                                  ),
                                  Container(
                                    height: 180,
                                    child: ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        itemCount: 3,
                                        itemBuilder: (context,index){
                                          return Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                color: Constants.colorsList[Constants.colorsList.length - (index+1)]
                                              ),
                                              child: ListTile(
                                                leading: Container(
                                                    width: 35,
                                                    height: 35,
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(70),
                                                        color: Constants.colorsList[index]
                                                    ),
                                                    child: Center(child: KText(text:name[name.length - (index+1)],style: GoogleFonts.openSans(
                                                        fontSize: width/80,
                                                        fontWeight: FontWeight.w600,
                                                        color:   Colors.white)))
                                                ),
                                                title: KText(text:namelist[name.length - (index+1)],style: GoogleFonts.kanit(
                                                    fontSize: width/95,
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.white),),
                                                subtitle: KText(text:"Today 5:30 AM",style: GoogleFonts.kanit(
                                                    fontSize: width/110,
                                                    fontWeight: FontWeight.w400,
                                                    color: Colors.white),),
                                              ),
                                            ),
                                          );

                                        }),
                                  )

                                ],
                              ),

                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(width: 20,),
                  Column(
                    children: [
                      Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 398,
                          height: 640,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20)
                          ),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(top:12.0,left:10),
                                child: Row(
                                  children: [
                                    KText(text:"Events Calendar",
                                      style: GoogleFonts.kanit(
                                          fontSize: width/80,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff333333)),),
                                  ],
                                ),
                              ),
                              Container(
                                width: 500,
                                height: 340,
                                child: SfCalendar(
                                  onTap: (val){
                                    setState(() {
                                      //selectedDateController.text = DateFormat('dd-MM-yyyy').format(val.date!);
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
                              ),

                              Padding(
                                padding: const EdgeInsets.only(top:15.0,left: 10,right: 10),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    KText(text:"Upcoming Events",
                                      style: GoogleFonts.kanit(
                                          fontSize: width/80,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff333333)),),
                                    KText(text:"View All",
                                      style: GoogleFonts.kanit(
                                          fontSize: width/95,
                                          fontWeight: FontWeight.w500,
                                          color: Color(0xff0077FF)),),
                                  ],
                                ),
                              ),
                              Container(
                                height: 225,
                                child: ListView.builder(
                                    physics: NeverScrollableScrollPhysics(),
                                    itemCount: 3,
                                    itemBuilder: (context,index){
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(20),
                                            color: Constants.colorsList[Constants.colorsList.length - (index+2)].withOpacity(0.40),
                                          ),

                                          child: ListTile(
                                            leading: Container(
                                                width: 35,
                                                height: 35,
                                                decoration: BoxDecoration(
                                                    borderRadius: BorderRadius.circular(70),
                                                    color: Constants.colorsList[index]
                                                ),
                                                child: Center(child: KText(text:name[index],style: GoogleFonts.openSans(
                                                    fontSize: width/80,
                                                    fontWeight: FontWeight.w600,
                                                    color:   Colors.white)))
                                            ),
                                            title: KText(text:namelist[index],style: GoogleFonts.kanit(
                                                fontSize: width/95,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff333333)),),
                                            subtitle: KText(text:"Request to edit profile image",style: GoogleFonts.kanit(
                                                fontSize: width/110,
                                                fontWeight: FontWeight.w400,
                                                color: Color(0xff333333)),),
                                          ),
                                        ),
                                      );

                                    }),
                              )


                            ],
                          ),

                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}

import 'dart:math';

import 'package:church_management_admin/constants.dart';
import 'package:church_management_admin/views/login_view.dart';
import 'package:church_management_admin/views/tabs/about_us_tab.dart';
import 'package:church_management_admin/views/tabs/messages_tab.dart';
import 'package:church_management_admin/views/tabs/settings_tab.dart';
import 'package:church_management_admin/widgets/developer_card_widget.dart';
import 'package:church_management_admin/widgets/event_calender.dart';
import 'package:church_management_admin/widgets/kText.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:country_flags/country_flags.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'calde.dart';
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
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
      .toggledOff; // Can be toggled on/off by longpressing a date
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    // Implementation example
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null; // Important to clean those
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    // `start` or `end` could be null
    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
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
                                    child: Row(
                                      children: [
                                        KText(text:"Welcome Admin",
                                          style: GoogleFonts.openSans(
                                              fontSize: width/50,
                                              fontWeight: FontWeight.w700,
                                              color:   Colors.white),
                                        ),
                                        Container(
                                            width: 30,
                                            height: 30,

                                            child: Image.asset("assets/handwave.png"))
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0,left: 10),
                                    child: Container(
                                      width:350,
                                      child: StreamBuilder(
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
                                                    style: GoogleFonts.openSans(
                                                        fontSize: width/105,
                                                        fontWeight: FontWeight.w500,
                                                        color:   Colors.white),
                                                    maxLines: 3,
                                                  );
                                                }return Container();
                                              },
                                            );
                                          }return Container();
                                        },
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
                                        InkWell(
                                          onTap: (){
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (ctx) =>
                                                        MessagesTab()));
                                          },
                                          child: KText(text:"View All",
                                            style: GoogleFonts.kanit(
                                                fontSize: width/95,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xff0077FF)),),
                                        ),
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
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection("Messages").orderBy('timestamp',descending: true).snapshots(),
                                      builder: (context,snap) {
                                        return ListView.builder(
                                          physics: NeverScrollableScrollPhysics(),
                                            itemCount: 2,
                                            itemBuilder: (context,index){
                                              return InkWell(
                                                onTap: (){

                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (ctx) =>
                                                              MessagesTab()));
                                                },
                                                child: Column(
                                                  children: [
                                                    ListTile(
                                                      leading: Container(
                                                        width: 35,
                                                        height: 35,
                                                        decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(70),
                                                          color: Constants.colorsList[index]
                                                        ),
                                                        child: Center(child: KText(text:snap.data!.docs[index]['title'].toString().substring(0,1),style: GoogleFonts.openSans(
                                                            fontSize: width/80,
                                                            fontWeight: FontWeight.w600,
                                                            color:   Colors.white)))
                                                      ),
                                                      title: KText(text:snap.data!.docs[index]['title'],style: GoogleFonts.kanit(
                                                          fontSize: width/95,
                                                          fontWeight: FontWeight.w500,
                                                          color: Color(0xff333333)),),
                                                      subtitle: KText(text:"Date: ${snap.data!.docs[index]['date']} - Time: ${snap.data!.docs[index]['time']}",style: GoogleFonts.kanit(
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
                                                ),
                                              );

                                        });
                                      }
                                    ),
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
                                    child: StreamBuilder(
                                      stream: FirebaseFirestore.instance.collection("Users").orderBy('timestamp',descending: true).snapshots(),
                                      builder: (context,snap) {

                                        if(snap.hasError){
                                          return Center(child: CircularProgressIndicator());
                                        }
                                        if(snap.data==null){
                                          return Center(child: CircularProgressIndicator());
                                        }

                                        return ListView.builder(
                                            physics: NeverScrollableScrollPhysics(),
                                            itemCount: 2,
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
                                                        ),
                                                        child: snap.data!.docs[index]['imgUrl'] != ""? ClipRRect(
                                                            borderRadius: BorderRadius.circular(70),
                                                            child: Image.network(snap.data!.docs[index]['imgUrl'],fit: BoxFit.cover,)) :
                                                         Center(child: KText(text:snap.data!.docs[index]['firstName'].toString().substring(0,1).toUpperCase(),style: GoogleFonts.openSans(
                                                            fontSize: width/80,
                                                            fontWeight: FontWeight.w600,
                                                            color:   Colors.white)))
                                                    ),
                                                    title: KText(text:snap.data!.docs[index]['firstName'],style: GoogleFonts.kanit(
                                                        fontSize: width/95,
                                                        fontWeight: FontWeight.w500,
                                                        color: Colors.white),),
                                                    subtitle: KText(text:snap.data!.docs[index]['resaddress'],
                                                    maxLines: 1,
                                                      style: GoogleFonts.kanit(
                                                        fontSize: width/110,
                                                        fontWeight: FontWeight.w400,

                                                        color: Colors.white),),
                                                  ),
                                                ),
                                              );

                                            });
                                      }
                                    ),
                                  )

                                ],
                              ),

                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                  SizedBox(width: 10,),
                  Column(
                    children: [
                      Material(
                        elevation: 1,
                        borderRadius: BorderRadius.circular(20),
                        child: Container(
                          width: 378,
                          height: 715,
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
                                child:  TableCalendar<Event>(
                                  firstDay: kFirstDay,
                                  lastDay: kLastDay,
                                  focusedDay: _focusedDay,
                                  selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                                  rangeStartDay: _rangeStart,
                                  rangeEndDay: _rangeEnd,
                                  calendarFormat: _calendarFormat,
                                  rangeSelectionMode: _rangeSelectionMode,
                                  eventLoader: _getEventsForDay,
                                  startingDayOfWeek: StartingDayOfWeek.monday,
                                  headerStyle: HeaderStyle(
                                    formatButtonTextStyle: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    ),
                                    titleTextStyle: GoogleFonts.inter(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500
                                    ),
                                  ),

                                  calendarStyle: CalendarStyle(
                                    // Use `CalendarStyle` to customize the UI
                                      outsideDaysVisible: false,
                                      todayTextStyle: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500
                                      ),
                                      defaultTextStyle: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      ),
                                      outsideTextStyle: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      ),
                                      rangeEndTextStyle: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      ),
                                      rangeStartTextStyle: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      ),
                                      weekendTextStyle: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      ),
                                      weekNumberTextStyle:GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      ),

                                      withinRangeTextStyle: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      ),
                                      todayDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(100),
                                          color: Color(0xff377DFF).withOpacity(0.50)
                                      ),

                                      selectedTextStyle: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500
                                      ),
                                      holidayTextStyle: GoogleFonts.inter(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w500
                                      ),

                                      markerDecoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(20),
                                          color: Color(0xff377DFF)
                                      ),

                                      selectedDecoration: BoxDecoration(
                                          color: Color(0xff377DFF),
                                          borderRadius: BorderRadius.circular(100)

                                      )
                                  ),
                                  onDaySelected: _onDaySelected,
                                  onRangeSelected: _onRangeSelected,
                                  onFormatChanged: (format) {
                                    if (_calendarFormat != format) {
                                      setState(() {
                                        _calendarFormat = format;
                                      });
                                    }
                                  },
                                  onPageChanged: (focusedDay) {
                                    _focusedDay = focusedDay;
                                  },
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
                                height: 250,
                                child: StreamBuilder(
                                  stream: FirebaseFirestore.instance.collection("Events").orderBy('timestamp').snapshots(),
                                  builder: (context,snap) {

                                    if(snap.hasError){
                                      return Center(child: CircularProgressIndicator());
                                    }
                                    if(snap.data==null){
                                      return Center(child: CircularProgressIndicator());
                                    }

                                    return ListView.builder(
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
                                                    child: Center(child: KText(text:snap.data!.docs[index]['title'].toString().substring(0,1).toUpperCase(),style: GoogleFonts.openSans(
                                                        fontSize: width/80,
                                                        fontWeight: FontWeight.w600,
                                                        color:   Colors.white)))
                                                ),
                                                title: KText(text:snap.data!.docs[index]['title'],style: GoogleFonts.kanit(
                                                    fontSize: width/95,
                                                    fontWeight: FontWeight.w500,
                                                    color: Color(0xff333333)),),
                                                subtitle: KText(text:snap.data!.docs[index]["date"],style: GoogleFonts.kanit(
                                                    fontSize: width/110,
                                                    fontWeight: FontWeight.w400,
                                                    color: Color(0xff333333)),),
                                              ),
                                            ),
                                          );

                                        });
                                  }
                                ),
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
            Padding(
              padding:  EdgeInsets.only(left: width/45.53,right: width/45.53),
              child: DeveloperCardWidget(),
            ),
            SizedBox(height: height * 0.01),
          ],
        ),
      ),

    );
  }
}

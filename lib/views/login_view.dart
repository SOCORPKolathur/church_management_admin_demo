import 'dart:async';

import 'package:country_ip/country_ip.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter/services.dart';
import 'package:church_management_admin/constants.dart';
import 'package:church_management_admin/services/church_details_firecrud.dart';
import 'package:church_management_admin/views/tabs/home_view.dart';
import 'package:church_management_admin/widgets/custom_textfield.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ip_country_lookup/ip_country_lookup.dart';
import 'package:ip_country_lookup/models/ip_country_data_model.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import '../models/church_details_model.dart';
import '../services/location_api.dart';
import '../widgets/kText.dart';
import 'package:intl/intl.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key,required this.sessionStateStream});

  final StreamController<SessionState> sessionStateStream;


  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {



  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _success = false;
  String _userEmail = '';

  FirebaseAuth auth = FirebaseAuth.instance;

  String ip = '';
  String deviceLocation = '';
  String deviceOs = 'Windows';
  String deviceId = '';
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();


  @override
  void initState() {
    getChurchDetails();
    getUserLocation();
    super.initState();
  }



  String? validateEmail(String? value) {
    const pattern = r"(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'"
        r'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-'
        r'\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*'
        r'[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:(2(5[0-5]|[0-4]'
        r'[0-9])|1[0-9][0-9]|[1-9]?[0-9]))\.){3}(?:(2(5[0-5]|[0-4][0-9])|1[0-9]'
        r'[0-9]|[1-9]?[0-9])|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\'
        r'x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])';
    final regex = RegExp(pattern);

    return value!.isNotEmpty && !regex.hasMatch(value)
        ? 'Enter a valid email address'
        : null;
  }

  String churchLogo = '';
  String churchName = '';
  getChurchDetails() async {
    var church = await FirebaseFirestore.instance.collection('ChurchDetails').get();
    churchLogo = church.docs.first.get("logo");
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: StreamBuilder(
        stream: ChurchDetailsFireCrud.fetchChurchDetails(),
        builder: (ctx, snapshot){
          if(snapshot.hasData){
            ChurchDetailsModel church = snapshot.data!.first;
            return Stack(
              children: [
                Container(
                  height: size.height,
                  width: size.width,
                  decoration: const BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage(
                            "assets/Background.png"
                        )
                    ),
                  ),
                ),
                Positioned(
                  left: size.width * 0.04,
                  top: size.height / 2.8,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      churchLogo != ""
                          ? Container(
                        height: 110,
                        width: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(200),
                              color: Colors.white
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(200),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.network(
                        churchLogo,
                        height: 110,
                        width: 110,
                      ),
                              ),
                            ),
                          )
                          : const Icon(
                        Icons.church,
                        size: 80,
                      ),
                      Container(
                        width: size.width/2.8,
                        child: Text(
                          church.name!,
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w800,
                            fontSize: size.height * 0.07,
                          ),
                        ),
                      ),
                      Text(
                        "MANAGEMENT ADMIN",
                        style: GoogleFonts.openSans(
                          fontWeight: FontWeight.w900,
                          fontSize: size.height * 0.045,
                        ),
                      ),
                    ],
                  ),
                ),

                Positioned(
                  right: 0,
                  child: Container(
                    height: size.height,
                    width: size.width / 2,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: size.height/8,),
                          Center(
                            child: Column(
                              children: [
                                churchLogo != ""
                                    ? Image.network(
                                  churchLogo,
                                  height: 70,
                                  width: 70,
                                )
                                    : const Icon(
                                  Icons.church,
                                  size: 50,
                                ),
                                KText(
                                  text: "Welcome to",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w900,
                                    fontSize: size.height * 0.04,
                                  ),
                                ),
                                KText(
                                  text: church.name!,
                                  style: GoogleFonts.poppins(
                                    color: const Color(0xff878484),
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(height: size.height*0.03,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Email address",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    CustomTextField(
                                      hint: "Email",
                                      passType: false,
                                      controller: emailController,
                                      validator: validateEmail,
                                      onSubmitted: (val){

                                      },
                                    )
                                  ],
                                ),
                                SizedBox(height: size.height*0.03,),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text:"Password",
                                      style: GoogleFonts.poppins(
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    CustomTextField(
                                      hint: "Password",
                                      passType: true,
                                      controller: passwordController,
                                      validator: validateEmail,
                                      onSubmitted: (val){
                                        authenticate(church);
                                      },
                                    ),
                                    const SizedBox(height: 8),
                                    /*const KText(
                                      text:"Forgot password?",
                                      style: TextStyle(
                                          fontSize: 12,
                                          decoration: TextDecoration.underline
                                      ),
                                    )*/
                                  ],
                                ),
                                SizedBox(height: size.height*0.03,),
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      test.add("S1");
                                    });

                                    authenticate(church);
                                  },
                                  child: Container(
                                    height: size.height * 0.08,
                                    width: size.width * 0.35,
                                    decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
                                        borderRadius: BorderRadius.circular(30)
                                    ),
                                    child: Center(
                                      child: KText(
                                        text: "Log In",
                                        style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            //color: Colors.white
                                            color: Constants().btnTextColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                SizedBox(height: size.height*0.02),
                              /*  SizedBox(
                                  height: size.height * 0.08,
                                  width: size.width * 0.35,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Container(
                                        height: 2,
                                        width: size.width * 0.14,
                                        color: const Color(0xff000000),
                                      ),
                                      KText(
                                        text: "Or",
                                        style: GoogleFonts.poppins(
                                          fontSize: 15,
                                        ),
                                      ),
                                      Container(
                                        height: 2,
                                        width: size.width * 0.14,
                                        color: const Color(0xff000000),
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Material(
                                        color: Colors.white,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(1,2),
                                                  blurRadius: 2,
                                                )
                                              ]
                                          ),
                                          child: SvgPicture.asset("assets/flat-color-icons_google@3x.svg"),
                                        )
                                    ),
                                    SizedBox(width: size.width * 0.035),
                                    Material(
                                        color: Colors.white,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          padding: const EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow: const [
                                                BoxShadow(
                                                  color: Colors.black12,
                                                  offset: Offset(1,2),
                                                  blurRadius: 2,
                                                )
                                              ]
                                          ),
                                          child: SvgPicture.asset("assets/Group.svg"),
                                        )
                                    )
                                  ],
                                )*/
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }return Container();
        },
      )
    );
  }


  List test = [];

  Future<void> authenticate(ChurchDetailsModel church) async {

    setState((){
      test.add("S2");
    });
    bool isAuthenticated = await _signInWithEmailAndPassword();
    if(isAuthenticated){
        setState((){
      test.add("S9");
    });
      if(church.roles!.isNotEmpty){
        church.roles!.forEach((element) async {
            setState((){
      test.add("S10");
    });
          if(emailController.text == element.roleName! && passwordController.text == element.rolePassword!){
              setState((){
      test.add("S11");
    });
            Navigator.pushReplacement(context, MaterialPageRoute(
                builder: (ctx) =>  HomeView(currentRole: element.roleName!,sessionStateStream: widget.sessionStateStream)));
          }
        });
      }
    }
  }

  Future<bool> _signInWithEmailAndPassword() async {
      setState((){
      test.add("S3");
    });
    bool result = false;
    final User? user = (await auth.signInWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    ).catchError((e){
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    })).user;
      setState((){
      test.add("S4");
    });
    if (user != null) {
        setState((){
      test.add("S5");
    });
      //IpCountryData? countryData = await IpCountryLookup().getIpLocationData();
        final countryIpResponse = await CountryIp.find();
        setState(() {
          test.add("New1");
        });
        setState(() {
          test.add("New2");
        });
      //String? ipv4 = countryData.ip.toString();//await Ipify.ipv4();
      String? ipv4 = countryIpResponse!.ip.toString();//await Ipify.ipv4();
        setState(() {
          test.add(ipv4);
          test.add("1R");
          test.add("2R");
        });


      setState(() {

        test.add(countryIpResponse!.country);
        test.add("Location");
        deviceId = "Browser";
        deviceLocation = countryIpResponse!.country;
        ip = ipv4.toString();
      });
        setState((){
      test.add("S6");
    });
      FirebaseFirestore.instance.collection('LoginReports').doc().set({
        "deviceId": deviceId,
        "deviceOs": deviceOs,
        "ip": ip,
        "location": deviceLocation,
        "date" : DateFormat('dd-MM-yyyy').format(DateTime.now()),
        "time" : DateFormat('hh:mm aa').format(DateTime.now()),
        "timestamp": DateTime.now().millisecondsSinceEpoch,
      });
        setState((){
      test.add("S7");
    });
      setState(() {
        _success = true;
        result = true;
        _userEmail = user.uid;
      });
    } else {
      setState(() {
        _success = false;
        result = false;
      });
    }
      setState((){
      test.add("S8");
    });
    return result;
  }

  String adnroidInfo1 = '';
  String countryData1 = '';
  String countryDataError = '';

  Future<String> getUserLocation() async {
    IpCountryData? countryData;
    try{
      countryData = await IpCountryLookup().getIpLocationData();
    }catch (e){
      countryDataError = e.toString();
    }
    WebBrowserInfo androidInfo = await deviceInfo.webBrowserInfo;
    adnroidInfo1 = androidInfo.toString();
    countryData1 = countryData.toString();
    String? ipv4 = countryData!.ip.toString();//await Ipify.ipv4();
    String location = await LocationAPI().fetchData(ipv4);
    setState(() {
      deviceId = androidInfo.productSub!;
      deviceLocation = location;
      ip = ipv4.toString();
    });
    return "";
  }

  void _register() async {
    final User? user = (
        await
    auth.createUserWithEmailAndPassword(
      email: emailController.text,
      password: passwordController.text,
    )
    ).user;
    if (user != null) {
      setState(() {
        _success = true;
        _userEmail = user.uid;
      });
    } else {
      setState(() {
        _success = true;
      });
    }
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              spreadRadius: 2.0,
              blurRadius: 8.0,
              offset: Offset(2, 4),
            )
          ],
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          children: [
            Icon(Icons.info_outline, color: Constants().primaryAppColor ),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Invalid Credentials !!', style: TextStyle(color: Colors.black)),
            ),
            const Spacer(),
            TextButton(onPressed: () => debugPrint("Undid"), child: Text("Undo"))
          ],
        )
    ),
  );

}

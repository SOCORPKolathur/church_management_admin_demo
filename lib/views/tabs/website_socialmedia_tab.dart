import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webviewx/webviewx.dart';
import 'dart:ui' as ui;
import '../../constants.dart';
import '../../widgets/kText.dart';

class WebsiteAndSocialMediaTab extends StatefulWidget {
  const WebsiteAndSocialMediaTab({super.key});

  @override
  State<WebsiteAndSocialMediaTab> createState() => _WebsiteAndSocialMediaTabState();
}

class _WebsiteAndSocialMediaTabState extends State<WebsiteAndSocialMediaTab> {

   late WebViewXController webviewControllerfacebook;
   late WebViewXController webviewControllerinsta;

  String facebookUrl = 'https://www.facebook.com/bcagchennai';
  String instaUrl = 'https://www.instagram.com/bcagchennai';

  bool isView = false;
  bool isFacebook = false;

  final initialContent = '<h4> The Page is being loaded Please wait... <h2>';

  @override
  void initState() {
    getAdmin();
    super.initState();
  }

   @override
   void dispose() {
     webviewControllerinsta.dispose();
     webviewControllerfacebook.dispose();
     super.dispose();
   }

   String churchLogo = '';
   String churchWebsite = '';

  getAdmin() async {
    var churchDetails = await FirebaseFirestore.instance.collection('ChurchDetails').get();
    setState(() {
      churchLogo = churchDetails.docs.first.get("logo");
      churchWebsite = churchDetails.docs.first.get("website");
    });
  }

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
              child: Row(
                children: [
                  Visibility(
                    visible: isView,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: (){
                            setState(() {
                              isView = false;
                            });
                          },
                          icon: Icon(
                            Icons.arrow_back,
                          ),
                        ),
                        SizedBox(width: 20),
                      ],
                    ),
                  ),
                  KText(
                    text: "Church Social Media",
                    style: GoogleFonts.openSans(
                        fontSize: width/52.53846153846154,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            !isView
                ? Container(
              height: size.height*0.9,
                  child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        InkWell(
                          onTap:() async {
                            setState(() {
                              isView = true;
                              isFacebook = true;
                            });
                            await Future.delayed(Duration(seconds: 2)).then((value){
                              webviewControllerfacebook.loadContent(
                                facebookUrl,
                                SourceType.url,
                              );
                            });
                          },
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 80,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Icon(
                                          Icons.facebook,
                                          color: Colors.blue,
                                        ),
                                      ),
                                    ),
                                    KText(
                                      text: "Facebook",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                          onTap:() async {
                            setState(() {
                              isView = true;
                              isFacebook = false;
                            });
                            await Future.delayed(Duration(seconds: 2)).then((value){
                              webviewControllerinsta.loadContent(
                                instaUrl,
                                SourceType.url,
                              );
                            });
                          },
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 80,
                              width: 300,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: [
                                    Colors.purple,
                                    Colors.pink,
                                    Colors.orange,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                       child: Image.asset(
                                         "assets/insta.png",
                                         height: 40,
                                         width: 40,
                                       ),
                                      ),
                                    ),
                                    KText(
                                      text: "Instagram",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                          onTap:(){

                          },
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 80,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                         child: KText(
                                            text: "X",
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          )
                                      ),
                                    ),
                                    KText(
                                      text: "X",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      children: [
                        InkWell(
                          onTap:(){

                          },
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 80,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: Image.asset(
                                          "assets/thread.png",
                                          height: 40,
                                          width: 40,
                                        ),
                                      ),
                                    ),
                                    KText(
                                      text: "Thread",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 20),
                        InkWell(
                          onTap:() async {
                            setState(() {
                              isView = true;
                              isFacebook = false;
                            });
                            await Future.delayed(Duration(seconds: 2)).then((value){
                              webviewControllerinsta.loadContent(
                                churchWebsite,
                                SourceType.url,
                              );
                            });
                          },
                          child: Material(
                            elevation: 4,
                            borderRadius: BorderRadius.circular(10),
                            child: Container(
                              height: 80,
                              width: 300,
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(3.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    CircleAvatar(
                                      backgroundColor: Colors.white,
                                      child: Center(
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(100),
                                          child: Image.network(
                                            churchLogo,
                                            height: 40,
                                            width: 40,
                                          ),
                                        ),
                                      ),
                                    ),
                                    KText(
                                      text: "Church Website",
                                      style: GoogleFonts.poppins(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(child: Container()),
                    SizedBox(height: size.height * 0.04),
                    InkWell(
                      onTap: () async {
                        final Uri toLaunch =
                        Uri.parse("http://ardigitalsolutions.co/");
                        if (!await launchUrl(toLaunch,
                          mode: LaunchMode.externalApplication,
                        )) {
                          throw Exception('Could not launch $toLaunch');
                        }
                      },
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border:Border.all(color: Constants().primaryAppColor,)
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Center(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: Image.network(
                                        Constants.churchLogo,
                                        height: 40,
                                        width: 40,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  "Version 1.0.0.1 @ 2023 by AR Digital Solutions. All Rights Reserved",
                                  style: GoogleFonts.poppins(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                  ],
              ),
            ),
                )
                : Container(
              height: 550,
              width: double.infinity,
              child: isFacebook ? _buildWebViewXFacebook() : _buildWebViewXInsta(),
            ),
          ],
        ),
      ),
    );
  }


  Widget _buildWebViewXInsta() {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialContent: initialContent,
      initialSourceType: SourceType.html,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      onWebViewCreated: (controller) => webviewControllerinsta = controller,
      onPageStarted: (src) =>
          debugPrint('A new page has started loading: $src\n'),
      onPageFinished: (src) =>
          debugPrint('The page has finished loading: $src\n'),
      jsContent: const {
        EmbeddedJsContent(
          js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
        ),
        EmbeddedJsContent(
          webJs:
          "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
          mobileJs:
          "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
        ),
      },
      webSpecificParams: const WebSpecificParams(
        printDebugInfo: true,
      ),
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
      navigationDelegate: (navigation) {
        debugPrint(navigation.content.sourceType.toString());
        return NavigationDecision.navigate;
      },
    );
  }

  Widget _buildWebViewXFacebook() {
    return WebViewX(
      key: const ValueKey('webviewx'),
      initialContent: initialContent,
      initialSourceType: SourceType.html,
      height: MediaQuery
          .of(context)
          .size
          .height,
      width: MediaQuery
          .of(context)
          .size
          .width,
      onWebViewCreated: (controller) => webviewControllerfacebook = controller,
      onPageStarted: (src) =>
          debugPrint('A new page has started loading: $src\n'),
      onPageFinished: (src) =>
          debugPrint('The page has finished loading: $src\n'),
      jsContent: const {
        EmbeddedJsContent(
          js: "function testPlatformIndependentMethod() { console.log('Hi from JS') }",
        ),
        EmbeddedJsContent(
          webJs:
          "function testPlatformSpecificMethod(msg) { TestDartCallback('Web callback says: ' + msg) }",
          mobileJs:
          "function testPlatformSpecificMethod(msg) { TestDartCallback.postMessage('Mobile callback says: ' + msg) }",
        ),
      },

      webSpecificParams: const WebSpecificParams(
        printDebugInfo: true,
      ),
      mobileSpecificParams: const MobileSpecificParams(
        androidEnableHybridComposition: true,
      ),
      navigationDelegate: (navigation) {
        debugPrint(navigation.content.sourceType.toString());
        return NavigationDecision.navigate;
      },
    );
  }


}

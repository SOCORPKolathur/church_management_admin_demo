import 'dart:async';
import 'dart:math';
import 'package:church_management_admin/constants.dart';
import 'package:church_management_admin/views/login_view.dart';
import 'package:church_management_admin/views/tabs/about_us_tab.dart';
import 'package:church_management_admin/views/tabs/gallery_tab.dart';
import 'package:church_management_admin/views/tabs/home_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:webview_flutter_web/webview_flutter_web.dart';
import 'calde.dart';
import 'views/tabs/HomeDrawer.dart';
import 'firebase_options.dart';
import 'models/church_details_model.dart';
import 'models/verses_model.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WebViewPlatform.instance = WebWebViewPlatform();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  var delegate = await LocalizationDelegate.create(
    basePath: 'assets/i18n/',
      fallbackLocale: 'en_US',
      supportedLocales: ['ta','te','ml','kn','en_US','bn','hi','es','pt','fr','nl','de','it','sv','mr','gu','or',]);
  runApp(LocalizedApp(delegate, const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  final _navigatorKey = GlobalKey<NavigatorState>();
  NavigatorState get _navigator => _navigatorKey.currentState!;
  final sessionStateStream = StreamController<SessionState>();

  User? user = FirebaseAuth.instance.currentUser;

  ///Call this function while changing database

  initialFunction() {
    String roleDocId = generateRandomString(16);
    FirebaseFirestore.instance.collection("RolePermissions").doc(roleDocId).set({
      "id" : roleDocId,
      "role" : "Admin@gmail.com",
      "permissions" : [],
      "dashboardItems" : [],
    });

    FirebaseFirestore.instance.collection("Funds").doc('x18zE9lNxDto7AXHlXDA').set({
      "currentBalance" : 0,
      "totalCollect" : 00,
      "totalSpend" : 0,
    });

    String annDocId = generateRandomString(16);
    FirebaseFirestore.instance.collection("AnniversaryWishTemplates").doc(annDocId).set({
      "content" : "Many more happy return of the day",
      "id" : annDocId,
      "selected" : false,
      "title" : "Happy Anniversary",
      "withName" : true,
    });

    String birDocId = generateRandomString(16);
    FirebaseFirestore.instance.collection("BirthdayWishTemplates").doc(birDocId).set({
      "content" : "Many more happy return of the day",
      "id" : birDocId,
      "selected" : false,
      "title" : "Happy Anniversary",
      "withName" : true,
    });

    String churchDocId = generateRandomString(16);
    ChurchDetailsModel church = ChurchDetailsModel(
      phone: '',
      name: '',
      id: churchDocId,
      aboutChurch: [],
      area: '',
      buildingNo: '',
      city: '',
      familyIdPrefix: '',
      memberIdPrefix: '',
      logo: '',
      pincode: '',
      verseForToday: VerseTodayModel(
        text: '',
        date: '',
      ),
      roles: [
        RoleUserModel(
          roleName: "admin@gmail.com",
          rolePassword: "admin@1234",
        )
      ],
      state: '',
      streetName: '',
      website: '',
    );

    var churchJson = church.toJson();

    FirebaseFirestore.instance.collection("ChurchDetails").doc(churchDocId).set(churchJson);



    for(int v = 0; v < versesList.length; v++){
      String docId = generateRandomString(16);
      FirebaseFirestore.instance.collection("BibleVerses").doc(docId).set({
        "id" : docId,
        "text" : versesList[v].text,
        "verse" : versesList[v].verse,
      });
    }

  }

  /// 1. Connect with Firebase
  /// 2. Enable email/password authentication.
  /// 3. Add User with below credentials
  ///      username : admin@gmail.com
  ///      password: admin@1234
  ///
  /// 4. Run the initial function.
  /// 5. Run the app
  /// 6. Edit Church details in settings page
  /// 7. Enable Firebase Storage.
  /// 8. Enable Firebase Cloud messaging.
  /// 9. Copy the server api key from cloud messaging tab in firebase and copy to apiKeyForNotification in constants.dart
  /// 10. Enable {Trigger Email from Firestore} Extension from firebase extensions.


  // @override
  // void initState() {
  //   initialFunction();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    final sessionConfig = SessionConfig(
      invalidateSessionForAppLostFocus: const Duration(minutes: 30),
      invalidateSessionForUserInactivity: const Duration(minutes: 30),
    );
    sessionConfig.stream.listen((SessionTimeoutState timeoutEvent) {
      sessionStateStream.add(SessionState.stopListening);
      if (timeoutEvent == SessionTimeoutState.userInactivityTimeout) {
        FirebaseAuth.instance.signOut();
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=> LoginView(sessionStateStream: sessionStateStream)));
        _navigator.pushReplacement(MaterialPageRoute(
          builder: (_) => LoginView(sessionStateStream: sessionStateStream),
        ));
      } else if (timeoutEvent == SessionTimeoutState.appFocusTimeout) {
        FirebaseAuth.instance.signOut();
        //Navigator.pushReplacement(context, MaterialPageRoute(builder: (ctx)=> LoginView(sessionStateStream: sessionStateStream)));
        // handle user  app lost focus timeout
        _navigator.pushReplacement(MaterialPageRoute(
          builder: (_) => LoginView(sessionStateStream: sessionStateStream),
        ));
      }
    });
    sessionStateStream.add(SessionState.startListening);
    var localizationDelegate = LocalizedApp.of(context).delegate;
    return LocalizationProvider(
      state: LocalizationProvider.of(context).state,
      child: SessionTimeoutManager(
        //userActivityDebounceDuration: const Duration(seconds: 10),
        sessionConfig: sessionConfig,
        sessionStateStream: sessionStateStream.stream,
        child: MaterialApp(
          navigatorKey: _navigatorKey,
          title: 'Church Management Admin',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Constants().primaryAppColor),
            useMaterial3: true,
          ),
          home: user != null ? HomeDrawer(/*currentRole: user!.email!, sessionStateStream: sessionStateStream*/) : LoginView(sessionStateStream: sessionStateStream),
         // home: TableEventsExample(),
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            localizationDelegate
          ],
          supportedLocales: localizationDelegate.supportedLocales,
          locale: localizationDelegate.currentLocale,
        ),
      ),
    );
  }

  static String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

}
///
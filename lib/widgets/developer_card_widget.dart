import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

import '../constants.dart';

class DeveloperCardWidget extends StatelessWidget {
  const DeveloperCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
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
              //color: Colors.white,
              color: Color(0xfffafae8),
              borderRadius: BorderRadius.circular(12),
              border:Border.all(color: Constants().primaryAppColor,)
          ),
          child: Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "IKIA",
                  style: GoogleFonts.poppins(
                    //color: Colors.black,
                    color: Color(0xffb80d38),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
                // CircleAvatar(
                //   backgroundColor: Colors.white,
                //   child: Center(
                //     child: ClipRRect(
                //       borderRadius: BorderRadius.circular(100),
                //       child: Image.network(
                //         churchLogo,
                //         height: 40,
                //         width: 40,
                //       ),
                //     ),
                //   ),
                // ),
                SizedBox(width: 20),
                Text(
                  "Version 1.0.0.1 @ 2023 by AR Digital Solutions. All Rights Reserved",
                  style: GoogleFonts.poppins(
                    color: Color(0xffb80d38),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

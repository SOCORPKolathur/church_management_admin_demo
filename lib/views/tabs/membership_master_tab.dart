import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../widgets/kText.dart';

class MembershipMasterTab extends StatefulWidget {
  const MembershipMasterTab({super.key});

  @override
  State<MembershipMasterTab> createState() => _MembershipMasterTabState();
}

class _MembershipMasterTabState extends State<MembershipMasterTab> {


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: KText(
              text: "Membership Master",
              style: GoogleFonts.openSans(
                  fontSize: width/52.53846153846154,
                  fontWeight: FontWeight.w900,
                  color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

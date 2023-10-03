import 'package:church_management_admin/views/tabs/settings_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/church_details_model.dart';
import '../../services/church_details_firecrud.dart';
import '../../widgets/kText.dart';

class manager_rol_tab_page extends StatefulWidget {
  const manager_rol_tab_page({Key? key}) : super(key: key);

  @override
  State<manager_rol_tab_page> createState() => _manager_rol_tab_pageState();
}

class _manager_rol_tab_pageState extends State<manager_rol_tab_page> {


  setData(ChurchDetailsModel church) {
    roleCredentialsList.clear();
    church.roles!.forEach((element) {
      roleCredentialsList.add(RoleCredentialsModel(
          roleEmail: TextEditingController(text: element.roleName),
          rolePassword: TextEditingController(text: element.rolePassword),
          isObsecure: true));
    });
  }

  List<RoleCredentialsModel> roleCredentialsList = [];

  List<bool> selectVersesList = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: width / 170.75, vertical: height / 81.375),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: width/68.3),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_back),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: width / 170.75, vertical: height / 81.375),
                    child: KText(
                      text: "SETTINGS",
                      style: GoogleFonts.openSans(
                          fontSize: width/37.94,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                    ),
                  ),
                  Expanded(child: Container()),

                ],
              ),
              SizedBox(height: size.height * 0.03),
              StreamBuilder(
                stream: ChurchDetailsFireCrud.fetchChurchDetails2(),
                builder: (ctx, snapshot) {
                  if (snapshot.hasData) {
                    ChurchDetailsModel church1 = snapshot.data!.first;
                    setData(church1);
                    return Center(
                      child: Container(
                        height: size.height * 0.28 * church1.roles!.length,
                        width: size.width * 0.95,
                        decoration: BoxDecoration(
                          color: Constants().primaryAppColor,
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 2),
                              blurRadius: 3,
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            Container(height: size.height * 0.09),
                            Expanded(
                              child: Container(
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomRight: Radius.circular(10),
                                      bottomLeft: Radius.circular(10),
                                    )),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: size.width * 0.2,
                                      child: Column(
                                        children: [
                                          SizedBox(height: size.height * 0.1),
                                          Icon(
                                            Icons.church,
                                            size: width/7.588,
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: size.width * 0.75,
                                      padding: EdgeInsets.symmetric(
                                          vertical: height/32.55,
                                          horizontal: width/68.3
                                      ),
                                      child: Column(
                                        children: [

                                          for (int r = 0;
                                          r < roleCredentialsList.length;
                                          r++)
                                            Padding(
                                              padding: EdgeInsets.symmetric(
                                                  vertical: height/65.1),
                                              child: Row(
                                                children: [
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      KText(
                                                        text:
                                                        "User Name",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color: Colors.black,
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                      SizedBox(height: height/108.5),
                                                      SizedBox(
                                                        height: height/16.275,
                                                        width:width/5.464,
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets.symmetric(
                                                              horizontal: width/170.75,
                                                              vertical: height/81.375
                                                          ),
                                                          child:
                                                          TextFormField(
                                                            controller:
                                                            roleCredentialsList[r].roleEmail,
                                                            onTap: () {},
                                                            decoration:
                                                            InputDecoration(
                                                              border:
                                                              InputBorder
                                                                  .none,
                                                              hintStyle:
                                                              GoogleFonts
                                                                  .openSans(
                                                                fontSize: width/97.571,
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  SizedBox(width:width/27.32),
                                                  Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      KText(
                                                        text:
                                                        "Password",
                                                        style: GoogleFonts
                                                            .openSans(
                                                          color: Colors.black,
                                                          fontSize: width/97.571,
                                                        ),
                                                      ),
                                                      SizedBox(height: height/108.5),
                                                      Material(
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(5),
                                                        color:
                                                        Color(0xffdddeee),
                                                        elevation: 1,
                                                        child: SizedBox(
                                                          height: height/16.275,
                                                          width:width/5.464,
                                                          child: Padding(
                                                            padding:
                                                            EdgeInsets.symmetric(
                                                                horizontal: width/170.75,
                                                                vertical: height/81.375
                                                            ),
                                                            child:
                                                            TextFormField(
                                                              obscureText:
                                                              roleCredentialsList[r].isObsecure == true ? true : false,
                                                              controller: roleCredentialsList[r].rolePassword,
                                                              decoration:
                                                              InputDecoration(
                                                                  contentPadding: EdgeInsets.symmetric(
                                                                      vertical:
                                                                      5),
                                                                  border: InputBorder
                                                                      .none,
                                                                  hintStyle:
                                                                  GoogleFonts
                                                                      .openSans(
                                                                    fontSize:
                                                                    14,
                                                                  ),
                                                                  suffix:
                                                                  IconButton(
                                                                    onPressed: () {
                                                                      setState(() {
                                                                            roleCredentialsList[r].isObsecure =
                                                                            !roleCredentialsList[r].isObsecure!;
                                                                          });
                                                                      print(roleCredentialsList[r].isObsecure);
                                                                    },
                                                                    icon: Icon(roleCredentialsList[r].isObsecure!
                                                                        ? Icons.visibility
                                                                        : Icons.visibility_off),
                                                                  )),
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ),
                                          Expanded(child: Container()),

                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                  return Container();
                },
              ),
              SizedBox(height: size.height * 0.03),
            ],
          ),
        ),
      ),
    );
  }
}

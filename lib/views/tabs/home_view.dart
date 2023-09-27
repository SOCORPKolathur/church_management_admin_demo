import 'package:church_management_admin/models/church_details_model.dart';
import 'package:church_management_admin/models/manage_role_model.dart';
import 'package:church_management_admin/services/church_details_firecrud.dart';
import 'package:church_management_admin/services/role_permission_firecrud.dart';
import 'package:church_management_admin/views/tabs/attendance_record_tab.dart';
import 'package:church_management_admin/views/tabs/blood_requirement_tab.dart';
import 'package:church_management_admin/views/tabs/bolg_tab.dart';
import 'package:church_management_admin/views/tabs/chrous_tab.dart';
import 'package:church_management_admin/views/tabs/church_staff_tab.dart';
import 'package:church_management_admin/views/tabs/clans_tab.dart';
import 'package:church_management_admin/views/tabs/com_notifications_tab.dart';
import 'package:church_management_admin/views/tabs/committee_tab.dart';
import 'package:church_management_admin/views/tabs/dashboard_tab.dart';
import 'package:church_management_admin/views/tabs/department_tab.dart';
import 'package:church_management_admin/views/tabs/email_communication_tab.dart';
import 'package:church_management_admin/views/tabs/family_tab.dart';
import 'package:church_management_admin/views/tabs/manager_role_tab.dart';
import 'package:church_management_admin/views/tabs/members_tab.dart';
import 'package:church_management_admin/views/tabs/notice_tab.dart';
import 'package:church_management_admin/views/tabs/orders_tab.dart';
import 'package:church_management_admin/views/tabs/pastors_tab.dart';
import 'package:church_management_admin/views/tabs/prayers_tab.dart';
import 'package:church_management_admin/views/tabs/product_tab.dart';
import 'package:church_management_admin/views/tabs/sms_communication_tab.dart';
import 'package:church_management_admin/views/tabs/speech_tab.dart';
import 'package:church_management_admin/views/tabs/student_tab.dart';
import 'package:church_management_admin/views/tabs/user_tab.dart';
import 'package:church_management_admin/views/tabs/website_socialmedia_tab.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../models/drawer_model.dart';
import '../../widgets/kText.dart';
import 'asset_management_tab.dart';
import 'attendance_for_family_tab.dart';
import 'donations_tab.dart';
import 'events_tab.dart';
import 'fund_management_tab.dart';
import 'gallery_tab.dart';
import 'greetings_tab.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key, required this.currentRole});

  String currentRole;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  int selectedIndex = 100;
  int expandedIndex = 100;
  bool isFetched = false;
  List<DrawerModel> drawerItems = [];
  List<DrawerModel> drawerItems1 = [
    DrawerModel(
        name: "Dashboard",
        icon: Icons.dashboard,
        page: const DashBoardTab(),
        isExpanded: false,
        children: []
    ),
    DrawerModel(
      name: "User",
      page: const UserTab(),
      icon: Icons.person_pin,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Members",
      icon: Icons.family_restroom_sharp,
      page: const MembersTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Families",
      icon: Icons.group,
      page: const FamilyTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Student",
      page: const StudentTab(),
      icon: Icons.person,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Pastors",
      icon: Icons.person_pin_outlined,
      isExpanded: false,
      page: const PastorsTab(),
      children: [],
    ),
    DrawerModel(
      name: "Church Staff",
      page: const ChurchStaffTab(),
      icon: Icons.person_pin_outlined,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Chorus",
      page: const ChorusTab(),
      icon: Icons.music_video,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Department",
      icon: Icons.account_tree,
      page: const DepartmentTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Committee",
      icon: Icons.groups,
      page: const CommitteeTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Clans",
      page: const ClansTab(),
      icon: Icons.class_,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Finance",
      icon: Icons.attach_money,
      isExpanded: false,
      children: [
        DrawerChildren(
            name: 'Fund Management',
            icon: Icons.add,
            page: const FundManagementTab()),
        DrawerChildren(
          name: 'Donations',
          icon: Icons.add,
          page: const DonationsTab(),
        ),
        DrawerChildren(
          name: 'Asset Management',
          page: const AssetManagementTab(),
          icon: Icons.add,
        )
      ],
    ),
    DrawerModel(
      name: "Gallery",
      icon: CupertinoIcons.photo,
      page: const GalleryTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Speech",
      icon: CupertinoIcons.speaker_2_fill,
      page: const SpeechTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Notices",
      icon: CupertinoIcons.square_list_fill,
      page: const NoticesTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Communication",
      icon: Icons.message,
      isExpanded: false,
      children: [
        DrawerChildren(
          name: 'SMS Communication',
          page: const SmsCommunicationTab(),
          icon: Icons.add,
        ),
        DrawerChildren(
          name: 'Email Communication',
          page: const EmailCommunictionTab(),
          icon: Icons.add,
        ),
        DrawerChildren(
          name: 'Notifications',
          page: const ComNotificationsTab(),
          icon: Icons.add,
        ),
      ],
    ),
    DrawerModel(
      name: "Event Management",
      icon: Icons.notifications_on_sharp,
      page: const EventsTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Blood Requirement",
      icon: Icons.bloodtype,
      page: const BloodRequirementTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Prayers",
      icon: Icons.person_rounded,
      page: const PrayersTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Greeting",
      icon: Icons.cake,
      page: const GreetingsTab(),
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Blog",
      page: const BlogTab(),
      icon: Icons.web,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Social Media",
      page: const WebsiteAndSocialMediaTab(),
      icon: Icons.facebook,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Manage Role",
      page: ManagerRoleTab(currentRole: 'Admin'),
      icon: Icons.remove_from_queue,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Attendance Records",
      page: const AttendanceRecordTab(),
      icon: Icons.insert_drive_file_sharp,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Member Attendance",
      page: const AttendanceFamilyTab(),
      icon: Icons.insert_drive_file_sharp,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Product",
      page: const ProductTab(),
      icon: Icons.shopping_bag,
      isExpanded: false,
      children: [],
    ),
    DrawerModel(
      name: "Orders",
      page: const OrdersTab(),
      icon: Icons.shopping_cart_rounded,
      isExpanded: false,
      children: [],
    )
  ];

  setDrawerItems(List<ManageRoleModel> roles) {
    if (drawerItems.isEmpty) {
      for (int i = 0; i < roles.length; i++) {
        if (roles[i].role == widget.currentRole) {
          for (int j = 0; j < roles[i].permissions!.length; j++) {
            switch (roles[i].permissions![j].toString().toUpperCase()) {
              case "DASHBOARD":
                drawerItems.add(DrawerModel(
                    name: "Dashboard",
                    icon: Icons.dashboard,
                    page: const DashBoardTab(),
                    isExpanded: false,
                    children: []));
                break;
              case "GALLERY":
                drawerItems.add(DrawerModel(
                    name: "Gallery",
                    icon: CupertinoIcons.photo,
                    page: const GalleryTab(),
                    isExpanded: false,
                    children: []));
                break;
              case "FINANCE":
                drawerItems.add(
                  DrawerModel(
                    name: "Finance",
                    icon: Icons.attach_money,
                    isExpanded: false,
                    children: [
                      DrawerChildren(
                          name: 'Fund Management',
                          icon: Icons.add,
                          page: const FundManagementTab()),
                      DrawerChildren(
                        name: 'Donations',
                        icon: Icons.add,
                        page: const DonationsTab(),
                      ),
                      DrawerChildren(
                        name: 'Asset Management',
                        page: const AssetManagementTab(),
                        icon: Icons.add,
                      )
                    ],
                  ),
                );
                break;
              case "EVENT MANAGEMENT":
                drawerItems.add(DrawerModel(
                  name: "Event Management",
                  icon: Icons.notifications_on_sharp,
                  page: const EventsTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "BLOOD REQUIREMENT":
                drawerItems.add(DrawerModel(
                  name: "Blood Requirement",
                  icon: Icons.bloodtype,
                  page: const BloodRequirementTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "PRAYERS":
                drawerItems.add(DrawerModel(
                  name: "Prayers",
                  icon: Icons.person_rounded,
                  page: const PrayersTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "NOTICES":
                drawerItems.add(DrawerModel(
                  name: "Notices",
                  icon: CupertinoIcons.square_list_fill,
                  page: const NoticesTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "SPEECH":
                drawerItems.add(DrawerModel(
                  name: "Speech",
                  icon: CupertinoIcons.speaker_2_fill,
                  page: const SpeechTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "FAMILIES":
                drawerItems.add(DrawerModel(
                  name: "Families",
                  icon: Icons.group,
                  page: const FamilyTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "GREETINGS":
                drawerItems.add(DrawerModel(
                  name: "Greetings",
                  icon: Icons.group,
                  page: const GreetingsTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "DEPARTMENT":
                drawerItems.add(DrawerModel(
                  name: "Department",
                  icon: Icons.account_tree,
                  page: const DepartmentTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "COMMITTEE":
                drawerItems.add(
                  DrawerModel(
                    name: "Committee",
                    icon: Icons.groups,
                    page: const CommitteeTab(),
                    isExpanded: false,
                    children: [],
                  ),
                );
                break;
              case "MEMBERS":
                drawerItems.add(DrawerModel(
                  name: "Members",
                  icon: Icons.family_restroom_sharp,
                  page: const MembersTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "PASTORS":
                drawerItems.add(DrawerModel(
                  name: "Pastors",
                  icon: Icons.person_pin_outlined,
                  isExpanded: false,
                  page: const PastorsTab(),
                  children: [],
                ));
                break;
              case "CLANS":
                drawerItems.add(DrawerModel(
                  name: "Clans",
                  page: const ClansTab(),
                  icon: Icons.class_,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "CHORUS":
                drawerItems.add(DrawerModel(
                  name: "Chorus",
                  page: const ChorusTab(),
                  icon: Icons.music_video,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "CHURCH STAFF":
                drawerItems.add(DrawerModel(
                  name: "Church Staff",
                  page: const ChurchStaffTab(),
                  icon: Icons.person_pin_outlined,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "STUDENT":
                drawerItems.add(DrawerModel(
                  name: "Student",
                  page: const StudentTab(),
                  icon: Icons.person,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "USER":
                drawerItems.add(DrawerModel(
                  name: "User",
                  page: const UserTab(),
                  icon: Icons.person_pin,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "ATTENDANCE RECORD":
                drawerItems.add(DrawerModel(
                  name: "Attendance Records",
                  page: const AttendanceRecordTab(),
                  icon: Icons.insert_drive_file_sharp,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "COMMUNICATION":
                drawerItems.add(
                  DrawerModel(
                    name: "Communication",
                    icon: Icons.message,
                    isExpanded: false,
                    children: [
                      DrawerChildren(
                        name: 'SMS Communication',
                        page: const SmsCommunicationTab(),
                        icon: Icons.add,
                      ),
                      DrawerChildren(
                        name: 'Email Communication',
                        page: const EmailCommunictionTab(),
                        icon: Icons.add,
                      ),
                      DrawerChildren(
                        name: 'Notifications',
                        page: const ComNotificationsTab(),
                        icon: Icons.add,
                      ),
                    ],
                  ),
                );
                break;
              case "BLOG":
                drawerItems.add(DrawerModel(
                  name: "Blog",
                  page: const BlogTab(),
                  icon: Icons.web,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "SOCIAL MEDIA":
                drawerItems.add(DrawerModel(
                  name: "Social Media",
                  page: const WebsiteAndSocialMediaTab(),
                  icon: Icons.facebook,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "PRODUCT":
                drawerItems.add(DrawerModel(
                  name: "Product",
                  page: const ProductTab(),
                  icon: Icons.shopping_bag,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "ORDERS":
                drawerItems.add(DrawerModel(
                  name: "Orders",
                  page: const OrdersTab(),
                  icon: Icons.shopping_cart_rounded,
                  isExpanded: false,
                  children: [],
                ));
                break;
            }
          }
        } else if (widget.currentRole.toUpperCase() == 'ADMIN') {
          drawerItems = drawerItems1;
        }
      }
    }
    isFetched = true;
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        body: StreamBuilder(
      stream: ChurchDetailsFireCrud.fetchChurchDetails1(),
      builder: (ctx, snapshot) {
        if (snapshot.hasData) {
          ChurchDetailsModel churchHome = snapshot.data!.first;
          return StreamBuilder(
            stream: RolePermissionFireCrud.fetchPermissions(),
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return Container();
              } else if (snapshot.hasData) {
                List<ManageRoleModel> roles = snapshot.data!;
                setDrawerItems(roles);
                return !isFetched
                    ? Container()
                    : Container(
                        height: size.height,
                        width: size.width,
                        // decoration: const BoxDecoration(
                        //   image: DecorationImage(
                        //     fit: BoxFit.cover,
                        //     image: AssetImage("assets/Background.png"),
                        //   ),
                        // ),
                        decoration: BoxDecoration(
                           color: Constants().primaryAppColor
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                                SizedBox(
                                  height: size.height,
                                  width: size.width * 0.18,
                                  child: Column(
                                    children: [
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Icon(
                                              Icons.church,
                                              size: 52,
                                              color: Colors.white,
                                            ),
                                            SizedBox(
                                              width: double.infinity,
                                              child: Text(
                                                churchHome.name ?? "",
                                                style: GoogleFonts.openSans(
                                                  fontWeight: FontWeight.w900,
                                                  fontSize: 20,
                                                  color: Colors.white
                                                ),
                                              ),
                                            ),
                                            Text(
                                              "MANAGEMENT ADMIN",
                                              style: GoogleFonts.openSans(
                                                fontWeight: FontWeight.w900,
                                                fontSize: 15,
                                                color: Colors.white
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Stack(
                                          children: [
                                            SizedBox(
                                                width: double.infinity,
                                                child: ListView.builder(
                                                  itemCount: drawerItems.length,
                                                  itemBuilder: (ctx, i) {
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          currentIndex = i;
                                                          selectedIndex = 0;
                                                          drawerItems[i]
                                                                  .isExpanded =
                                                              !drawerItems[i]
                                                                  .isExpanded!;
                                                        });
                                                      },
                                                      child: Column(
                                                        children: [
                                                          Container(
                                                            height: expandedIndex ==
                                                                    i
                                                                ? drawerItems[i]
                                                                        .children!
                                                                        .length *
                                                                    60
                                                                : 50,
                                                            width:
                                                                double.infinity,
                                                            color: currentIndex ==
                                                                    i
                                                                ? Colors.white
                                                                : Colors
                                                                    .transparent,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          10),
                                                              child: Column(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Row(
                                                                    children: [
                                                                      Icon(
                                                                        drawerItems[i]
                                                                            .icon,
                                                                        color: currentIndex ==
                                                                                i
                                                                            ? Constants().primaryAppColor
                                                                            : Colors.white,
                                                                      ),
                                                                      const SizedBox(
                                                                          width:
                                                                              20),
                                                                      KText(
                                                                        text: drawerItems[i]
                                                                            .name!,
                                                                        style: currentIndex ==
                                                                                i
                                                                            ? GoogleFonts.poppins(
                                                                                fontWeight: FontWeight.w900,
                                                                                fontSize: 15,
                                                                                color: Constants().primaryAppColor,
                                                                              )
                                                                            : GoogleFonts.poppins(
                                                                                fontSize: 13,
                                                                                color: Colors.white
                                                                                //color: const Color(0xff1B1616),
                                                                              ),
                                                                      ),
                                                                      const Expanded(
                                                                          child:
                                                                              SizedBox()),
                                                                      Visibility(
                                                                        visible: drawerItems[i]
                                                                            .children!
                                                                            .isNotEmpty,
                                                                        child:
                                                                            InkWell(
                                                                          onTap:
                                                                              () {
                                                                            setState(() {
                                                                              drawerItems[i].isExpanded = !drawerItems[i].isExpanded!;
                                                                            });
                                                                          },
                                                                          child: drawerItems[i].isExpanded!
                                                                              ? RotatedBox(
                                                                                  quarterTurns: 2,
                                                                                  child: Icon(
                                                                                    Icons.expand_circle_down_outlined,
                                                                                    color: currentIndex == i ? Constants().primaryAppColor : Colors.black,
                                                                                  ))
                                                                              : Icon(
                                                                                  Icons.expand_circle_down_outlined,
                                                                                  color: currentIndex == i ? Constants().primaryAppColor : Colors.black,
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  )
                                                                ],
                                                              ),
                                                            ),
                                                          ),
                                                          Visibility(
                                                            visible: (drawerItems[
                                                                        i]
                                                                    .children!
                                                                    .isNotEmpty &&
                                                                drawerItems[i]
                                                                    .isExpanded!),
                                                            child: SizedBox(
                                                              height: drawerItems[
                                                                          i]
                                                                      .children!
                                                                      .length *
                                                                  50,
                                                              width: double
                                                                  .infinity,
                                                              child: ListView
                                                                  .builder(
                                                                itemCount:
                                                                    drawerItems[
                                                                            i]
                                                                        .children!
                                                                        .length,
                                                                itemBuilder:
                                                                    (ctx, j) {
                                                                  return InkWell(
                                                                    onTap: () {
                                                                      setState(
                                                                          () {
                                                                        currentIndex =
                                                                            i;
                                                                        selectedIndex =
                                                                            j;
                                                                      });
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      width: double
                                                                          .infinity,
                                                                      color: Colors
                                                                          .transparent,
                                                                      child:
                                                                          Padding(
                                                                        padding: const EdgeInsets.only(
                                                                            left:
                                                                                20,
                                                                            right:
                                                                                10),
                                                                        child:
                                                                            Column(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Row(
                                                                              children: [
                                                                                const SizedBox(width: 10),
                                                                                Icon(
                                                                                  drawerItems[i].children![j].icon,
                                                                                  color: (currentIndex == i && selectedIndex == j) ? Colors.white : Colors.black,
                                                                                ),
                                                                                const SizedBox(width: 20),
                                                                                KText(
                                                                                  text: drawerItems[i].children![j].name!,
                                                                                  style: (currentIndex == i && selectedIndex == j) ? GoogleFonts.poppins(fontWeight: FontWeight.w900, fontSize: 13, color: Colors.white) : GoogleFonts.poppins(fontSize: 12, color: const Color(0xff1B1616)),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                )),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Container(
                              height: size.height,
                              width: size.width * 0.82,
                              color: Colors.white,
                              child:
                                  drawerItems[currentIndex].children!.isNotEmpty
                                      ? drawerItems[currentIndex]
                                          .children![selectedIndex]
                                          .page
                                      : drawerItems[currentIndex].page,
                            )
                          ],
                        ),
                      );
              }
              return Container();
            },
          );
        }
        return Container();
      },
    ));
  }
}

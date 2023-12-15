import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_session_timeout/local_session_timeout.dart';
import '../../constants.dart';
import '../../models/church_details_model.dart';
import '../../models/drawer_model.dart';
import '../../models/manage_role_model.dart';
import '../../services/church_details_firecrud.dart';
import '../../services/role_permission_firecrud.dart';
import '../../widgets/kText.dart';
import 'asset_management_tab.dart';
import 'attendance_for_family_tab.dart';
import 'attendance_record_tab.dart';
import 'blood_requirement_tab.dart';
import 'bolg_tab.dart';
import 'chrous_tab.dart';
import 'church_staff_tab.dart';
import 'clans_tab.dart';
import 'com_notifications_tab.dart';
import 'committee_tab.dart';
import 'dashboard_tab.dart';
import 'department_tab.dart';
import 'donations_tab.dart';
import 'email_communication_tab.dart';
import 'events_tab.dart';
import 'family_tab.dart';
import 'fund_management_tab.dart';
import 'gallery_tab.dart';
import 'greetings_tab.dart';
import 'login_reports_tab.dart';
import 'manager_role_tab.dart';
import 'meeting_tab.dart';
import 'members_tab.dart';
import 'membership_register_tab.dart';
import 'membership_reports_tab.dart';
import 'memorial_days_tab.dart';
import 'notice_tab.dart';
import 'orders_tab.dart';
import 'pastors_tab.dart';
import 'prayers_tab.dart';
import 'product_tab.dart';
import 'reports_view.dart';
import 'sms_communication_tab.dart';
import 'speech_tab.dart';
import 'student_tab.dart';
import 'testimonials_tab.dart';
import 'user_tab.dart';
import 'website_socialmedia_tab.dart';
import 'zone_areas.dart';
import 'zone_reports_view.dart';
import 'zones_list_view.dart';

class HomeView extends StatefulWidget {
  HomeView({super.key, required this.currentRole,required this.sessionStateStream,});

  String currentRole;
  final StreamController<SessionState> sessionStateStream;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int currentIndex = 0;
  int selectedIndex = 100;
  int expandedIndex = 100;
  bool isFetched = false;
  List<DrawerModel> drawerItems = [];
  List<DrawerModel> drawerItems1 = [];
  String churchLogo = '';
  getChurchDetails() async {
    var church = await FirebaseFirestore.instance.collection('ChurchDetails').get();
    churchLogo = church.docs.first.get("logo");
  }
  setDrawerItems(List<ManageRoleModel> roles) {
    if (drawerItems.isEmpty) {
      for (int i = 0; i < roles.length; i++) {
        if (widget.currentRole.toUpperCase() == 'ADMIN@GMAIL.COM') {
          drawerItems = drawerItems1;
        }else  if (roles[i].role!.toLowerCase() == widget.currentRole.toLowerCase()) {
          for (int j = 0; j < roles[i].permissions!.length; j++) {
            switch (roles[i].permissions![j].toString().toUpperCase()) {
              case "DASHBOARD":
                drawerItems.add(DrawerModel(
                    name: "Dashboard",
                    icon: Icons.dashboard,
                    page: DashBoardTab(currentRole: widget.currentRole,sessionStateStream: widget.sessionStateStream),
                    isExpanded: false,
                    children: []));
                break;
              case "GALLERY":
                drawerItems.add(DrawerModel(
                    name: "Gallery",
                    icon: CupertinoIcons.photo,
                    page:  GalleryTab(),
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
                          page:  FundManagementTab()),
                      DrawerChildren(
                        name: 'Donations',
                        icon: Icons.add,
                        page:  DonationsTab(),
                      ),
                      DrawerChildren(
                        name: 'Asset Management',
                        page:  AssetManagementTab(),
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
                  page:  EventsTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "BLOOD REQUIREMENT":
                drawerItems.add(DrawerModel(
                  name: "Blood Requirement",
                  icon: Icons.bloodtype,
                  page:  BloodRequirementTab(),
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
                  name: "Announcements",
                  icon: CupertinoIcons.square_list_fill,
                  page:  NoticesTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "SPEECH":
                drawerItems.add(DrawerModel(
                  name: "Speech",
                  icon: CupertinoIcons.speaker_2_fill,
                  page:  SpeechTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "FAMILIES":
                drawerItems.add(DrawerModel(
                  name: "Families",
                  icon: Icons.group,
                  page:  FamilyTab(),
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
                  page:  DepartmentTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "COMMITTEE":
                drawerItems.add(
                  DrawerModel(
                    name: "Committee",
                    icon: Icons.groups,
                    page:  CommitteeTab(),
                    isExpanded: false,
                    children: [],
                  ),
                );
                break;
              case "MEMBERS":
                drawerItems.add(DrawerModel(
                  name: "Members",
                  icon: Icons.family_restroom_sharp,
                  page:  MembersTab(),
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "PASTORS":
                drawerItems.add(DrawerModel(
                  name: "Pastors",
                  icon: Icons.person_pin_outlined,
                  isExpanded: false,
                  page:  PastorsTab(),
                  children: [],
                ));
                break;
              case "CLANS":
                drawerItems.add(DrawerModel(
                  name: "Clans",
                  page:  ClansTab(),
                  icon: Icons.class_,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "CHORUS":
                drawerItems.add(DrawerModel(
                  name: "Choir",
                  page:  ChorusTab(),
                  icon: Icons.music_video,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "CHURCH STAFF":
                drawerItems.add(DrawerModel(
                  name: "Church Staff",
                  page:  ChurchStaffTab(),
                  icon: Icons.person_pin_outlined,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "STUDENT":
                drawerItems.add(DrawerModel(
                  name: "Student",
                  page:  StudentTab(),
                  icon: Icons.person,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "USER":
                drawerItems.add(DrawerModel(
                  name: "User",
                  page:  UserTab(),
                  icon: Icons.person_pin,
                  isExpanded: false,
                  children: [],
                ));
                break;
              case "ATTENDANCE RECORD":
                drawerItems.add(DrawerModel(
                  name: "Student Attendance",
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
                        page:  SmsCommunicationTab(),
                        icon: Icons.add,
                      ),
                      DrawerChildren(
                        name: 'Email Communication',
                        page:  EmailCommunictionTab(),
                        icon: Icons.add,
                      ),
                      DrawerChildren(
                        name: 'Notifications',
                        page:  ComNotificationsTab(),
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
        }
      }
    }
    isFetched = true;
  }

  @override
  void initState() {
    getChurchDetails();
    super.initState();
  }

  double containerWidth = 0.0;
  bool drawerExpaned = true;

  @override
  Widget build(BuildContext context) {
    widget.sessionStateStream.add(SessionState.startListening);
    var size = MediaQuery.of(context).size;
    drawerItems1 = [
      // DrawerModel(
      //     name: "Dashboard",
      //     icon: Icons.dashboard,
      //     page:  DashBoardTab(currentRole: 'Admin@gmail.com',sessionStateStream: widget.sessionStateStream),
      //     isExpanded: false,
      //     children: []
      // ),
      // DrawerModel(
      //   name: "User",
      //   page:  UserTab(),
      //   icon: Icons.person_pin,
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Members",
      //   icon: Icons.family_restroom_sharp,
      //   page:  MembersTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Families",
      //   icon: Icons.group,
      //   page:  FamilyTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Little Flocks",
      //   page:  ClansTab(),
      //   icon: Icons.class_,
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Student",
      //   page:  StudentTab(),
      //   icon: Icons.person,
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Committee",
      //   icon: Icons.groups,
      //   page:  CommitteeTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Pastors",
      //   icon: Icons.person_pin_outlined,
      //   isExpanded: false,
      //   page:  PastorsTab(),
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Church Staff",
      //   page:  ChurchStaffTab(),
      //   icon: Icons.person_pin_outlined,
      //   isExpanded: false,
      //   children: [],
      // ),
      // // DrawerModel(
      // //   name: "Choir",
      // //   page:  ChorusTab(),
      // //   icon: Icons.music_video,
      // //   isExpanded: false,
      // //   children: [],
      // // ),
      // DrawerModel(
      //   name: "Department",
      //   icon: Icons.account_tree,
      //   page:  DepartmentTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      //
      // DrawerModel(
      //   name: "Membership",
      //   icon: Icons.card_membership,
      //   isExpanded: false,
      //   children: [
      //     DrawerChildren(
      //       name: 'Membership Reports',
      //       icon: Icons.add,
      //       page: const MembershipReportsTab(),
      //     ),
      //     DrawerChildren(
      //       name: 'Membership Register',
      //       icon: Icons.add,
      //       page: const MembershipRegisterTab(),
      //     ),
      //     // DrawerChildren(
      //     //   name: 'Membership Master',
      //     //   page: const MembershipMasterTab(),
      //     //   icon: Icons.add,
      //     // )
      //   ],
      // ),
      // DrawerModel(
      //   name: "Finance",
      //   icon: Icons.attach_money,
      //   isExpanded: false,
      //   children: [
      //     DrawerChildren(
      //       name: 'Fund Management',
      //       icon: Icons.add,
      //       page:  FundManagementTab(),
      //     ),
      //     DrawerChildren(
      //       name: 'Donations',
      //       icon: Icons.add,
      //       page:  DonationsTab(),
      //     ),
      //     DrawerChildren(
      //       name: 'Asset Management',
      //       page:  AssetManagementTab(),
      //       icon: Icons.add,
      //     )
      //   ],
      // ),
      // DrawerModel(
      //   name: "Wishes",
      //   icon: Icons.cake,
      //   page: const GreetingsTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Memorial  Days",
      //   icon: Icons.date_range,
      //   page: const RememberDaysTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Speech",
      //   icon: CupertinoIcons.speaker_2_fill,
      //   page:  SpeechTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Testimonials",
      //   icon: Icons.person_rounded,
      //   page: const TestimonialsTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Prayers",
      //   icon: Icons.person_rounded,
      //   page: const PrayersTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Gallery",
      //   icon: CupertinoIcons.photo,
      //   page:  GalleryTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Meetings",
      //   icon: Icons.date_range,
      //   page: const MeetingsTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Event Management",
      //   icon: Icons.notifications_on_sharp,
      //   page:  EventsTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Announcements",
      //   icon: CupertinoIcons.square_list_fill,
      //   page:  NoticesTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Communication",
      //   icon: Icons.message,
      //   isExpanded: false,
      //   children: [
      //     DrawerChildren(
      //       name: 'SMS Communication',
      //       page:  SmsCommunicationTab(),
      //       icon: Icons.add,
      //     ),
      //     DrawerChildren(
      //       name: 'Email Communication',
      //       page:  EmailCommunictionTab(),
      //       icon: Icons.add,
      //     ),
      //     DrawerChildren(
      //       name: 'Notifications',
      //       page:  ComNotificationsTab(),
      //       icon: Icons.add,
      //     ),
      //   ],
      // ),
      // DrawerModel(
      //   name: "Blog",
      //   page: const BlogTab(),
      //   icon: Icons.web,
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Social Media",
      //   page: const WebsiteAndSocialMediaTab(),
      //   icon: Icons.web_rounded,
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Manage Role",
      //   page: ManagerRoleTab(currentRole: 'Admin@gmail.com'),
      //   icon: Icons.remove_from_queue,
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Member Attendance",
      //   page: const AttendanceFamilyTab(),
      //   icon: Icons.insert_drive_file_sharp,
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Student Attendance",
      //   page: const AttendanceRecordTab(),
      //   icon: Icons.insert_drive_file_sharp,
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Blood Requirement",
      //   icon: Icons.bloodtype,
      //   page:  BloodRequirementTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Zone Activities",
      //   icon: Icons.public,
      //   isExpanded: false,
      //   children: [
      //     DrawerChildren(
      //       name: 'Zone Areas',
      //       page: const Zone_Areas(),
      //       icon: Icons.people,
      //     ),
      //     DrawerChildren(
      //       name: 'Zone List',
      //       page: const ZonesListView(),
      //       icon: Icons.list,
      //     ),
      //     DrawerChildren(
      //       name: 'Zone Reports',
      //       page: const ZoneReportsView(),
      //       icon: Icons.bar_chart,
      //     ),
      //   ],
      // ),
      // DrawerModel(
      //   name: "Reports",
      //   icon: Icons.bar_chart,
      //   page: const ReportsTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Login Reports",
      //   icon: Icons.login,
      //   page: const LoginReportsTab(),
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Product",
      //   page: const ProductTab(),
      //   icon: Icons.shopping_bag,
      //   isExpanded: false,
      //   children: [],
      // ),
      // DrawerModel(
      //   name: "Orders",
      //   page: const OrdersTab(),
      //   icon: Icons.shopping_cart_rounded,
      //   isExpanded: false,
      //   children: [],
      // )
      DrawerModel(
          name: "Dashboard",
          icon: Icons.dashboard,
          page:  DashBoardTab(currentRole: 'Admin@gmail.com',sessionStateStream: widget.sessionStateStream),
          isExpanded: false,
          children: []
      ),
      DrawerModel(
        name: "Church Data",
        page:  UserTab(),
        icon: Icons.file_copy_sharp,
        isExpanded: false,
        children: [
          DrawerChildren(
            name: "User",
            page:  UserTab(),
            icon: Icons.person_pin,
          ),
          DrawerChildren(
            name: "Members",
            icon: Icons.family_restroom_sharp,
            page:  MembersTab(),
          ),
          DrawerChildren(
            name: "Families",
            icon: Icons.group,
            page:  FamilyTab(),
          ),
          DrawerChildren(
            name: "Little Flocks",
            page:  ClansTab(),
            icon: Icons.class_,
          ),
          DrawerChildren(
            name: "Student",
            page:  StudentTab(),
            icon: Icons.person,
          ),
          DrawerChildren(
            name: "Committee",
            icon: Icons.groups,
            page:  CommitteeTab(),
          ),
          DrawerChildren(
            name: "Pastors",
            icon: Icons.person_pin_outlined,
            page:  PastorsTab(),
          ),
          DrawerChildren(
            name: "Church Staff",
            page:  ChurchStaffTab(),
            icon: Icons.person_pin_outlined,
          ),
          DrawerChildren(
            name: "Department",
            icon: Icons.account_tree,
            page:  DepartmentTab(),
          ),
        ],
      ),
      DrawerModel(
        name: "Reports",
        icon: Icons.bar_chart,
        page: const ReportsTab(),
        isExpanded: false,
        children: [],
      ),
      DrawerModel(
        name: "Membership",
        icon: Icons.card_membership,
        isExpanded: false,
        children: [
          DrawerChildren(
            name: 'Membership Reports',
            icon: Icons.add,
            page: const MembershipReportsTab(),
          ),
          DrawerChildren(
            name: 'Membership Register',
            icon: Icons.add,
            page: const MembershipRegisterTab(),
          ),
        ],
      ),
      DrawerModel(
        name: "Finance",
        icon: Icons.attach_money,
        isExpanded: false,
        children: [
          DrawerChildren(
            name: 'Fund Management',
            icon: Icons.add,
            page:  FundManagementTab(),
          ),
          DrawerChildren(
            name: 'Donations',
            icon: Icons.add,
            page:  DonationsTab(),
          ),
          DrawerChildren(
            name: 'Asset Management',
            page:  AssetManagementTab(),
            icon: Icons.add,
          )
        ],
      ),
      DrawerModel(
        name: "Engagement",
        icon: Icons.cake_outlined,
        isExpanded: false,
        children: [
          DrawerChildren(
            name: "Wishes",
            icon: Icons.cake,
            page: const GreetingsTab(),
          ),
          DrawerChildren(
            name: 'SMS Communication',
            page:  SmsCommunicationTab(),
            icon: Icons.add,
          ),
          DrawerChildren(
            name: 'Email Communication',
            page:  EmailCommunictionTab(),
            icon: Icons.add,
          ),
          DrawerChildren(
            name: 'Notifications',
            page:  ComNotificationsTab(),
            icon: Icons.add,
          ),
          DrawerChildren(
            name: "Blood Requirement",
            icon: Icons.bloodtype,
            page:  BloodRequirementTab(),
          ),
          DrawerChildren(
            name: "Blog",
            page: const BlogTab(),
            icon: Icons.web,
          ),
          DrawerChildren(
            name: "Social Media",
            page: const WebsiteAndSocialMediaTab(),
            icon: Icons.web_rounded,
          )
        ],
      ),
      DrawerModel(
        name: "Church Tools",
        icon: Icons.ads_click,
        isExpanded: false,
        children: [
          DrawerChildren(
            name: "Speech",
            icon: CupertinoIcons.speaker_2_fill,
            page:  SpeechTab(),
          ),
          DrawerChildren(
            name: "Testimonials",
            icon: Icons.person_rounded,
            page: const TestimonialsTab(),
          ),
          DrawerChildren(
            name: "Prayers",
            icon: Icons.person_rounded,
            page: const PrayersTab(),
          ),
          DrawerChildren(
            name: "Meetings",
            icon: Icons.date_range,
            page: const MeetingsTab(),
          ),
          DrawerChildren(
            name: "Event Management",
            icon: Icons.notifications_on_sharp,
            page:  EventsTab(),
          ),
          DrawerChildren(
            name: "Memorial  Days",
            icon: Icons.date_range,
            page: const RememberDaysTab(),
          ),
          DrawerChildren(
            name: "Announcements",
            icon: CupertinoIcons.square_list_fill,
            page:  NoticesTab(),
          ),
        ],
      ),
      DrawerModel(
        name: "Gallery",
        icon: CupertinoIcons.photo,
        page:  GalleryTab(),
        isExpanded: false,
        children: [],
      ),
      DrawerModel(
        name: "Attendance",
        icon: Icons.insert_drive_file_sharp,
        page:  GalleryTab(),
        isExpanded: false,
        children: [
          DrawerChildren(
            name: "Member Attendance",
            page: const AttendanceFamilyTab(),
            icon: Icons.insert_drive_file_sharp,
          ),
          DrawerChildren(
            name: "Student Attendance",
            page: const AttendanceRecordTab(),
            icon: Icons.insert_drive_file_sharp,
          )
        ],
      ),
      DrawerModel(
        name: "Security",
        icon: Icons.security,
        page:  GalleryTab(),
        isExpanded: false,
        children: [
          DrawerChildren(
            name: "Manage Role",
            page: ManagerRoleTab(currentRole: 'Admin@gmail.com'),
            icon: Icons.remove_from_queue,
          ),
          DrawerChildren(
            name: "Login Reports",
            icon: Icons.login,
            page: const LoginReportsTab(),
          )
        ],
      ),
      DrawerModel(
        name: "Zone Activities",
        icon: Icons.public,
        isExpanded: false,
        children: [
          DrawerChildren(
            name: 'Zone Areas',
            page: const Zone_Areas(),
            icon: Icons.people,
          ),
          DrawerChildren(
            name: 'Zone List',
            page: const ZonesListView(),
            icon: Icons.list,
          ),
          DrawerChildren(
            name: 'Zone Reports',
            page: const ZoneReportsView(),
            icon: Icons.bar_chart,
          ),
        ],
      ),
      DrawerModel(
        name: "Ecommerce",
        icon: Icons.shopping_cart,
        isExpanded: false,
        children: [
          DrawerChildren(
            name: "Product",
            page: const ProductTab(),
            icon: Icons.shopping_bag,
          ),
          DrawerChildren(
            name: "Orders",
            page: const OrdersTab(),
            icon: Icons.shopping_cart_rounded,
          ),
        ],
      ),
    ];
    if(drawerExpaned){
      containerWidth = size.width * 0.82;
    }else{
      containerWidth = size.width * 0.97;
    }
    return Scaffold(
      backgroundColor: Colors.white,
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
                        decoration: BoxDecoration(
                            //color: Constants().primaryAppColor,
                            color: Colors.white,
                        ),
                        child: Row(
                          children: [
                            Stack(
                              children: [
                               AnimatedContainer(
                                 duration: const Duration(milliseconds: 500),
                                  height:size.height,
                                  width: drawerExpaned ? size.width * 0.18 : 40,
                                  child: drawerExpaned ? Container(
                                    color: Constants().primaryAppColor,
                                    child: Column(
                                      children: [
                                        Container(
                                          width: double.infinity,
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  churchLogo != ""
                                                      ? Container(
                                                    height: 72,
                                                    width: 72,
                                                        decoration: BoxDecoration(borderRadius: BorderRadius.circular(50),
                                                        color: Colors.white),
                                                        child: ClipRRect(
                                                          borderRadius: BorderRadius.circular(50),
                                                          child: Padding(
                                                            padding: const EdgeInsets.all(8.0),
                                                            child: Image.network(
                                                    churchLogo,
                                                    height: 60,
                                                    width: 60,fit: BoxFit.contain,
                                                  ),
                                                          ),
                                                        ),
                                                      )
                                                      : const Icon(
                                                    Icons.church,
                                                    color: Colors.white,
                                                    size: 52,
                                                  ),
                                                  IconButton(
                                                      onPressed: (){
                                                        setState(() {
                                                          if(drawerExpaned){
                                                            drawerExpaned = false;
                                                          }
                                                        });
                                                      },
                                                      icon: Icon(
                                                        drawerExpaned ? Icons.chevron_left_outlined : Icons.chevron_right_outlined,
                                                        color: Colors.white,
                                                      ),
                                                  )
                                                ],
                                              ),
                                              SizedBox(
                                                width: double.infinity,
                                                child: Text(
                                                  "WELCOME TO ${churchHome.name}" ?? "",
                                                  style: GoogleFonts.openSans(
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 20,
                                                    color: Colors.white
                                                  ),
                                                ),
                                              ),
                                              // Text(
                                              //   "MANAGEMENT ADMIN",
                                              //   style: GoogleFonts.openSans(
                                              //     fontWeight: FontWeight.w900,
                                              //     fontSize: 15,
                                              //     color: Colors.white
                                              //   ),
                                              // ),
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
                                  ) :  Container(
                                    decoration: BoxDecoration(
                                      color: Constants().primaryAppColor,
                                    ),
                                    height: size.height,
                                    width: drawerExpaned ? size.width * 0.18 : 40,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        SizedBox(height: 36),
                                        IconButton(
                                          onPressed: (){
                                            setState(() {
                                              containerWidth = size.width;
                                              drawerExpaned = !drawerExpaned;
                                            });
                                          },
                                          icon: Icon(
                                            drawerExpaned ? Icons.chevron_left_outlined : Icons.chevron_right_outlined,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                               //     : Container(
                               //   height: 40,
                               //   width: 40,
                               //   child: Center(
                               //     child: IconButton(
                               //       onPressed: (){
                               //         setState(() {
                               //           containerWidth = size.width;
                               //           drawerExpaned = !drawerExpaned;
                               //         });
                               //       },
                               //       icon: Icon(
                               //         drawerExpaned ? Icons.chevron_left_outlined : Icons.chevron_right_outlined,
                               //       ),
                               //     ),
                               //   ),
                               // )
                              ],
                            ),
                            Container(
                              height: size.height,
                              //width: size.width * 0.82,
                              width: containerWidth,
                              //color: Colors.white,
                              color: const Color(0xfffdff8c),
                              child: drawerItems[currentIndex].children!.isNotEmpty
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

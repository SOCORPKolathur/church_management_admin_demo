import 'package:church_management_admin/models/manage_role_model.dart';
import 'package:church_management_admin/models/response.dart';
import 'package:church_management_admin/services/role_permission_firecrud.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../constants.dart';
import '../../widgets/kText.dart';

class ManagerRoleTab extends StatefulWidget {
  ManagerRoleTab({super.key, required this.currentRole});

  String currentRole;

  @override
  State<ManagerRoleTab> createState() => _ManagerRoleTabState();
}

class _ManagerRoleTabState extends State<ManagerRoleTab> {

  List<String> rolesList = [];
  bool isFetched = false;

  setRoles(List<ManageRoleModel> roles){
    if(rolesList.isEmpty){
      for (int i = 0; i < roles.length; i ++) {
          for (int j = 0; j < roles[i].permissions!.length; j ++) {
            rolesList.add(roles[i].permissions![j]);
          }
      }
    }
    isFetched = true;
  }

  updateRole(String content, bool isAlreadyIn, String id) async {
    setState(() {
      if(isAlreadyIn){
        rolesList.removeWhere((element) => element == content);
      }else{
        rolesList.add(content);
      }
    });
    //// update to firebase
    ManageRoleModel role = ManageRoleModel();
    role.role = 'Manager';
    role.id = id;
    role.permissions = rolesList;
    Response res = await RolePermissionFireCrud.updatedRole(role);
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: KText(
                text: "MANAGERS ROLE PERMISSION",
                style: GoogleFonts.openSans(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: Colors.black),
              ),
            ),
            StreamBuilder(
              stream: RolePermissionFireCrud.fetchPermissions(),
              builder: (ctx,snapshot){
                if(snapshot.hasError){
                  return Container();
                }else if(snapshot.hasData){
                  List<ManageRoleModel> roles = snapshot.data!;
                  ManageRoleModel managerRole = ManageRoleModel();
                  roles.forEach((element) {
                    if(element.role!.toUpperCase() == "MANAGER"){
                      managerRole = element;
                    }
                  });
                  setRoles(roles);
                  return !isFetched ? Container() : Container(
                    height: size.height * 0.72,
                    width: 1100,
                    margin: const EdgeInsets.all(20),
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
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "Manage Role's Permission",
                                  style: GoogleFonts.openSans(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                )),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const SizedBox(height: 20),
                                Center(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text("Select Role"),
                                      SizedBox(
                                        height: 50,
                                        width: 300,
                                        child: DropdownButton(
                                          value: widget.currentRole,
                                          icon: const Icon(Icons.keyboard_arrow_down),
                                          items: ["Select Role", "Admin", "Manager"]
                                              .map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            if(newValue != "Select Role") {
                                              setState(() {
                                                 widget.currentRole= newValue!;
                                              });
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 30),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Dashboard"),
                                            onChanged: (val) {
                                              updateRole("Dashboard", rolesList.contains("Dashboard"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Dashboard",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Gallery"),
                                            onChanged: (val) {
                                              updateRole("Gallery", rolesList.contains("Gallery"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Gallery",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Finance"),
                                            onChanged: (val) {
                                              updateRole("Finance", rolesList.contains("Finance"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Finance",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Event Management"),
                                            onChanged: (val) {
                                              updateRole("Event Management", rolesList.contains("Event Management"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Event Management",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Prayers"),
                                            onChanged: (val) {
                                              updateRole("Prayers", rolesList.contains("Prayers"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Prayers",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Notices"),
                                            onChanged: (val) {
                                              updateRole("Notices", rolesList.contains("Notices"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Notices",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Speech"),
                                            onChanged: (val) {
                                              updateRole("Speech", rolesList.contains("Speech"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Speech",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Families"),
                                            onChanged: (val) {
                                              updateRole("Families", rolesList.contains("Families"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Families",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Department"),
                                            onChanged: (val) {
                                              updateRole("Department", rolesList.contains("Department"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Department",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Committee"),
                                            onChanged: (val) {
                                              updateRole("Committee", rolesList.contains("Committee"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Committee",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Members"),
                                            onChanged: (val) {
                                              updateRole("Members", rolesList.contains("Members"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Members",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Pastors"),
                                            onChanged: (val) {
                                              updateRole("Pastors", rolesList.contains("Pastors"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Pastors",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Clans"),
                                            onChanged: (val) {
                                              updateRole("Clans", rolesList.contains("Clans"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Clans",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Chorus"),
                                            onChanged: (val) {
                                              updateRole("Chorus", rolesList.contains("Chorus"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Chorus",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Church Staff"),
                                            onChanged: (val) {
                                              updateRole("Church Staff", rolesList.contains("Church Staff"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Church Staff",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Student"),
                                            onChanged: (val) {
                                              updateRole("Student", rolesList.contains("Student"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Student",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("User"),
                                            onChanged: (val) {
                                              updateRole("User", rolesList.contains("User"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "User",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Attendance Record"),
                                            onChanged: (val) {
                                              updateRole("Attendance Record", rolesList.contains("Attendance Record"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Attendance Record",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Communication"),
                                            onChanged: (val) {
                                              updateRole("Communication", rolesList.contains("Communication"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Communication",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Blog"),
                                            onChanged: (val) {
                                              updateRole("Blog", rolesList.contains("Blog"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Blog",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Product"),
                                            onChanged: (val) {
                                              updateRole("Product", rolesList.contains("Product"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Product",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Orders"),
                                            onChanged: (val) {
                                              updateRole("Orders", rolesList.contains("Orders"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Orders",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Greetings"),
                                            onChanged: (val) {
                                              updateRole("Greetings", rolesList.contains("Greetings"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Greetings",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Blood Requirement"),
                                            onChanged: (val) {
                                              updateRole("Blood Requirement", rolesList.contains("Blood Requirement"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Blood Requirement",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      width: 250,
                                      child: Row(
                                        children: [
                                          Checkbox(
                                            value: widget.currentRole.toUpperCase() == "ADMIN" ? true : rolesList.contains("Social Media"),
                                            onChanged: (val) {
                                              updateRole("Social Media", rolesList.contains("Social Media"),managerRole.id!);
                                            },
                                          ),
                                          const SizedBox(width: 10),
                                          const KText(
                                            text: "Website & Social Media",
                                            style: TextStyle(color: Colors.black),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(
                                        width: 250
                                    ),
                                    const SizedBox(
                                        width: 250
                                    ),
                                    const SizedBox(
                                      width: 250
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
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
            Icon(Icons.info_outline, color: Constants().primaryAppColor),
            const Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Please fill required fields !!',
                  style: TextStyle(color: Colors.black)),
            ),
            const Spacer(),
            TextButton(
                onPressed: () => debugPrint("Undid"), child: const Text("Undo"))
          ],
        )),
  );
}

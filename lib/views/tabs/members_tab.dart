import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:age_calculator/age_calculator.dart';
import 'package:church_management_admin/services/members_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:flutter/services.dart';
import 'package:flutter_holo_date_picker/date_picker.dart';
import 'package:flutter_holo_date_picker/i18n/date_picker_i18n.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:pdf/pdf.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants.dart';
import '../../models/members_model.dart';
import '../../models/response.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';
import '../../widgets/switch_button.dart';
import '../prints/member_print.dart';
import 'package:excel/excel.dart' as ex;
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as wb;
import 'package:intl/intl.dart';
import 'package:church_management_admin/SatusModel.dart' as StatusModel;


class MembersTab extends StatefulWidget {
   MembersTab({super.key});

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController memberIdController = TextEditingController();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController positionController = TextEditingController();
  TextEditingController baptizeDateController = TextEditingController();
  TextEditingController marriageDateController = TextEditingController();
  TextEditingController socialStatusController = TextEditingController(text: "Select");
  TextEditingController jobController = TextEditingController();
  TextEditingController familyController = TextEditingController(text: "Select");
  TextEditingController familyIDController = TextEditingController(text: "Select");
  TextEditingController serviceLanguageController = TextEditingController(text: "Select");
  TextEditingController departmentController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController(text: "Select Blood Group");
  TextEditingController dobController = TextEditingController();
  TextEditingController nationalityController = TextEditingController(text: 'Indian');
  TextEditingController residentialAddressController = TextEditingController();
  TextEditingController permanentAddressController = TextEditingController();
  TextEditingController houseTypeCon = TextEditingController(text: 'Select Type');
  TextEditingController pincodeController = TextEditingController();
  TextEditingController aadharNoController = TextEditingController();
  TextEditingController genderController = TextEditingController(text: 'Select Gender');
  TextEditingController landMarkController = TextEditingController();
  TextEditingController previousChurchController = TextEditingController();
  TextEditingController attendingTimeController = TextEditingController(text: 'Select Time');
  TextEditingController qualificationController = TextEditingController();
  TextEditingController relationToFamilyController = TextEditingController(text: "Select Relation");
  TextEditingController marriedController = TextEditingController(text: 'Select Status');
  TextEditingController prefixController = TextEditingController(text: 'Select Prefix');
  TextEditingController confirmDateController = TextEditingController();
  TextEditingController cityController = TextEditingController(text:'Select City'); /// select city controller
  TextEditingController countryController = TextEditingController(text:'India'); /// select Country controller
  TextEditingController stateController = TextEditingController(text:'Select State'); /// select State controller
  TextEditingController alterNativeemailController = TextEditingController();
  TextEditingController companynameController = TextEditingController();
  TextEditingController alphoneController = TextEditingController();
  TextEditingController aboutController = TextEditingController();


  List<String> StateList = <String>[
    'Select State',
    "Andhra Pradesh",
    "Arunachal Pradesh",
    "Assam",
    "Bihar",
    "Chhattisgarh",
    "Goa",
    'Gujarat',
    "Haryana",
    "Himachal Pradesh",
    "Jharkhand",
    "Karnataka",
    "Kerala",
    "Madhya Pradesh",
    "Maharashtra",
    "Manipur",
    "Meghalaya",
    "Mizoram",
    "Nagaland",
    "Odisha",
    "Punjab",
    "Rajasthan",
    "Sikkim",
    "Tamil Nadu",
    "Telangana",
    "Tripura",
    "Uttarakhand",
    " Uttar Pradesh",
    "West Bengal",
  ];


  List<String> coutryList = <String>[
    'Select Country',
    "Afghanistan",
    "Albania",
    "Algeria",
    "Andorra",
    "Angola",
    "Antigua and Barbuda",
    "Argentina",
    "Armenia",
    "Australia",
    "Austria",
    "Azerbaijan",
    "Bahamas",
    "Bahrain",
    "Bangladesh",
    "Barbados",
    "Belarus",
    "Belgium",
    'Belize',
    "Bhutan",
    'Bolivia',
    'Bosnia and Herzegovina',
    'Botswana',
    'Brazil',
    'Brunei',
    'Bulgaria',
    'Burkina Faso',
    'Burundi',
    "Côte d'Ivoire",
    'Cabo Verde  ',
    'Cambodia',
    'Cameroon  ',
    'Canada',
    'Central African Republic',
    'Chad',
    'Chile',
    'China',
    'Colombia',
    'Comoros',
    'Congo (Congo-Brazzaville) ',
    'Costa Rica  ',
    'Croatia ',
    'Cuba  ',
    'Cyprus  ',
    'Czechia (Czech Republic)',
    'Democratic Republic of the Congo',
    'Denmark',
    'Djibouti',
    'Dominica',
    'Dominican Republic',
    'Ecuador',
    'Egypt',
    'El Salvador',
    'Equatorial Guinea',
    'Eritrea ',
    'Estonia ',
    'Eswatini (Swaziland)  ',
    'Ethiopia  ',
    'Fiji  ',
    'Finland ',
    'France  ',
    'Gabon ',
    'Gambia  ',
    'Georgia',
    'Germany',
    'Ghana',
    'Greece',
    'Grenada',
    'Guatemala',
    'Guinea',
    'Guinea-Bissau',
    'Guyana',
    'Haiti',
    'Holy See  ',
    'Honduras',
    'Hungary',
    'Iceland',
    'India',
    'Indonesia',
    'Iran',
    'Iraq',
    'Ireland',
    'Israel',
    'Italy',
    'Jamaica',
    'Japan',
    'Jordan',
    'Kazakhstan',
    'Kenya',
    'Kiribati',
    'Kuwait',
    'Kyrgyzstan',
    'Laos',
    'Latvia',
    'Lebanon',
    'Lesotho',
    'Liberia',
    'Libya',
    'Liechtenstein',
    'Lithuania',
    'Luxembourg',
    'Madagascar',
    'Malawi',
    'Malaysia',
    'Maldives',
    'Mali',
    'Malta',
    'Marshall Islands  ',
    'Mauritania',
    'Mauritius',
    'Mexico',
    'Micronesia',
    'Moldova',
    'Monaco',
    'Mongolia',
    'Montenegro',
    'Morocco',
    'Mozambique',
    'Myanmar (formerly Burma)',
    'Namibia',
    'Nauru',
    'Nepal',
    'Netherlands',
    'New Zealand',
    'Nicaragua',
    'Niger',
    'Nigeria',
    'North Korea',
    'North Macedonia',
    'Norway',
    'Oman',
    'Pakistan',
    'Palau',
    'Palestine State',
    'Panama',
    'Papua New Guinea',
    'Paraguay',
    'Peru',
    'Philippines',
    'Poland',
    'Portugal',
    'Qatar',
    'Romania',
    'Russia',
    'Rwanda',
    'Saint Kitts and Nevis ',
    'Saint Lucia ',
    'Saint Vincent and the Grenadines  ',
    'Samoa',
    'San Marino  ',
    'Sao Tome and Principe ',
    'Saudi Arabia  ',
    'Senegal',
    'Serbia',
    'Seychelles  ',
    'Sierra Leone  ',
    'Singapore',
    'Slovakia',
    'Slovenia',
    'Solomon Islands ',
    'Somalia',
    'South Africa',
    'South Korea',
    'South Sudan',
    'Spain',
    'Sri Lanka',
    'Sudan',
    'Suriname',
    'Sweden',
    'Switzerland',
    'Syria',
    'Tajikistan',
    'Tanzania',
    'Thailand',
    'Timor-Leste',
    'Togo',
    'Tonga',
    'Trinidad and Tobago',
    'Tunisia',
    'Turkey',
    'Turkmenistan',
    'Tuvalu',
    'Uganda',
    'Ukraine',
    'United Arab Emirates',
    'United Kingdom  ',
    'United States of America  ',
    'Uruguay ',
    'Uzbekistan  ',
    'Vanuatu ',
    'Venezuela ',
    'Vietnam ',
    'Yemen',
    'Zambia',
    'Zimbabwe',
  ];

  List <String> _cities = [
    'Select City',
  ];
  Future getResponse() async {
    var res = await rootBundle.loadString(
        'packages/country_state_city_picker/lib/assets/country.json');
    return jsonDecode(res);
  }
  Future getCity(state) async {
    setState(() {
      _cities.clear();
    });
    setState(() {
      _cities.add('Select City');
    });
    var response = await getResponse();
    var takestate = response
        .map((map) => StatusModel.StatusModel.fromJson(map))
        .where((item) => item.emoji + "    " + item.name == "🇮🇳    India")
        .map((item) => item.state)
        .toList();
    var states = takestate as List;
    states.forEach((f) {
      var name = f.where((item) => item.name == state);
      var cityname = name.map((item) => item.city).toList();
      cityname.forEach((ci) {
        if (!mounted) return;
        setState(() {
          var citiesname = ci.map((item) => item.name).toList();
          for (var citynames in citiesname) {
            _cities.add(citynames.toString());
          }
        });
      });
    });
    print("Get cityssss");
    print(_cities);
    return _cities;
  }

  String searchString = "";
  File? profileImage;
  File? documentForUpload;
  var uploadedImage;
  String? selectedImg;
  String docname = "";

  String currentTab = 'View';

  bool isCropped = false;

  selectImage(){
    InputElement input = FileUploadInputElement()
    as InputElement
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      FileReader reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          profileImage = file;
        });
        setState(() {
          uploadedImage = reader.result;
          selectedImg = null;
        });
      });
      setState(() {});
    });
  }

  selectDocument(){
    InputElement input = FileUploadInputElement()
    as InputElement
      ..accept = '/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      FileReader reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          documentForUpload = file;
          docname = file.name;
        });
      });
      setState(() {});
    });
  }

  setMemberId() async {
    var document = await cf.FirebaseFirestore.instance.collection('Members').get();
    var churchDetails = await cf.FirebaseFirestore.instance.collection('ChurchDetails').get();
    String memberIdPrefix = churchDetails.docs.first.get("memberIdPrefix");
    int lastId = document.docs.length + 1;
    String studentId = lastId.toString().padLeft(6,'0');
    setState((){
      memberIdController.text = memberIdPrefix+studentId;
    });
  }

  downloadTemplateExcel() async {
    final wb.Workbook workbook = wb.Workbook();
    final wb.Worksheet sheet   = workbook.worksheets[0];
    sheet.getRangeByName("A1").setText("No.");
    sheet.getRangeByName("B1").setText("Member ID");
    sheet.getRangeByName("C1").setText("Firstname");
    sheet.getRangeByName("D1").setText("Lastname");
    sheet.getRangeByName("E1").setText("Phone");
    sheet.getRangeByName("F1").setText("Email");
    sheet.getRangeByName("G1").setText("Gender");
    sheet.getRangeByName("H1").setText("Profession");
    sheet.getRangeByName("I1").setText("Baptism Date");
    sheet.getRangeByName("J1").setText("Marriage Date");
    sheet.getRangeByName("K1").setText("Social Status");
    sheet.getRangeByName("L1").setText("Job");
    sheet.getRangeByName("M1").setText("Family ID");
    sheet.getRangeByName("N1").setText("Family");
    sheet.getRangeByName("O1").setText("Department");
    sheet.getRangeByName("P1").setText("Blood Group");
    sheet.getRangeByName("Q1").setText("Date of Birth");
    sheet.getRangeByName("R1").setText("Nationality");
    sheet.getRangeByName("S1").setText("Address");
    sheet.getRangeByName("T1").setText("Pincode");
    sheet.getRangeByName("U1").setText("Aadhaar Number");
    sheet.getRangeByName("V1").setText("Marital Status");
    sheet.getRangeByName("W1").setText("Attending Time");
    sheet.getRangeByName("X1").setText("Qualification");
    sheet.getRangeByName("Y1").setText("Relationship to Family");
    sheet.getRangeByName("Z1").setText("Previous Church");
    sheet.getRangeByName("AA1").setText("Landmark");
    sheet.getRangeByName("AB1").setText("House Type");
    sheet.getRangeByName("AC1").setText("Service Language");

    final List<int>bytes = workbook.saveAsStream();
    workbook.dispose();
    AnchorElement(href: 'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', 'MemberTemplate.xlsx')
      ..click();

  }

  clearTextEditingControllers(){
    setState(() {
      uploadedImage = null;
      profileImage = null;
      baptizeDateController.text = "";
      bloodGroupController.text = "Select Blood Group";
      genderController.text = "Select Gender";
      prefixController.text = "Select Prefix";
      middleNameController.clear();
      permanentAddressController.text = "";
      residentialAddressController.text = "";
      houseTypeCon.text = "Select Type";
      familyController.text = "Select";
      familyIDController.text = "Select";
      departmentController.text = "";
      landMarkController.text = "";
      previousChurchController.text = "";
      docname = "";
      documentForUpload = null;
      dobController.text = "";
      aadharNoController.text = "";
      emailController.text = "";
      familyController.text = "";
      firstNameController.text = "";
      pincodeController.text = "";
      jobController.text = "";
      lastNameController.text = "";
      marriageDateController.text = "";
      nationalityController.text = 'Indian';
      phoneController.text = "";
      positionController.text = "";
      serviceLanguageController.text = "Select";
      socialStatusController.text = "";
      countryController.text = "";
      attendingTimeController.text = 'Select Time';
      qualificationController.text = "";
      relationToFamilyController.text = "";
      marriedController.text = 'Select Status';
      isLoading = false;
    });
  }

  @override
  void initState() {
    getCity("Tamil Nadu");
    familydatafetchfunc();
    setMemberId();
    getTotalMembers();
    super.initState();
  }


  List<FamilyNameWithId>FamilyIdList=[];

  familydatafetchfunc()async{
    setState((){
      FamilyIdList.clear();
    });
    setState(()  {
      FamilyIdList.add(
        FamilyNameWithId(count: 0, id: "Select", name: "Select")
      );
    });
    var familydata=await cf.FirebaseFirestore.instance.collection("Families").get();
    for(int i=0;i<familydata.docs.length;i++){
      setState((){
        FamilyIdList.add(
          FamilyNameWithId(count: familydata.docs[i]['quantity'], id: familydata.docs[i]['familyId'].toString(), name: familydata.docs[i]['name'].toString()));
      });
    }
  }


  checkAvailableSlot(int count, String familyName) async {
    var memberData =await cf.FirebaseFirestore.instance.collection("Members").get();
    int memberCount = 0;
    memberData.docs.forEach((element) {
      if(element['family'] == familyName){
        memberCount++;
      }
    });
    if((count-memberCount) <= 0){
      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          text: "Family Count Exceeded",
          width: MediaQuery.of(context).size.width * 0.4,
          backgroundColor: Constants()
              .primaryAppColor
              .withOpacity(0.8));
      setState(() {
        familyIDController.text = "Select";
      });
    }else{

    }
  }

  bool isEmail(String input) => EmailValidator.validate(input);

  final _key = GlobalKey<FormFieldState>();
  final _keyNationality = GlobalKey<FormFieldState>();
  final _keyFirstname = GlobalKey<FormFieldState>();
  final _keyLastname = GlobalKey<FormFieldState>();
  final _keyPhone = GlobalKey<FormFieldState>();
  final _keyPincode= GlobalKey<FormFieldState>();
  final _keyDob= GlobalKey<FormFieldState>();
  final _keyAadhar= GlobalKey<FormFieldState>();
  bool profileImageValidator = false;

  bool isLoading = false;

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final emailNameFocusNode = FocusNode();
  final positionFocusNode = FocusNode();
  final aadhaarFocusNode = FocusNode();
  final jobFocusNode = FocusNode();
  final departmentFocusNode = FocusNode();
  final qualificationFocusNode = FocusNode();
  final prevChurchFocusNode = FocusNode();
  final landmarkFocusNode = FocusNode();
  final nationalityFocusNode = FocusNode();
  final pincodeFocusNode = FocusNode();
  final addressFocusNode = FocusNode();
  final localityFocusNode = FocusNode();
  final aboutFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final alterNativeemailFocusNode = FocusNode();


  int documentlength =0 ;
  int pagecount =0 ;
  int totalMembersCount =0 ;
  int memberRemainder =0 ;
  int temp = 1;
  int shift =0;
  List list = new List<int>.generate(10000, (i) => i + 1);

  List<cf.DocumentSnapshot> documentList = [];
  List<MembersModel> membersListForPrint = [];
  cf.QuerySnapshot? memberDocument;


  getTotalMembers() async {
    var memberDoc = await cf.FirebaseFirestore.instance.collection('Members').get();
    setState(() {
      memberDocument = memberDoc;
      pagecount = (memberDoc.docs.length + 10) ~/ 10;
      totalMembersCount = memberDoc.docs.length;
      memberRemainder = (memberDoc.docs.length) % 10;
    });
  }

  setAge(DateTime dob){
    Size size = MediaQuery.of(context).size;
    DateDuration duration;
    duration = AgeCalculator.age(dob);
    if(duration.years != 0){
      setState(() {
        dobController.text = formatter.format(dob);
      });
    }else{
      CoolAlert.show(
          context: context,
          type: CoolAlertType.info,
          text: "Age will be greater than 0",
          title: "Please select date of birth correctly!",
          width: size.width * 0.4,
          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
          showCancelBtn: true,
          cancelBtnTextStyle: TextStyle(color: Colors.black),
          confirmBtnText: 'OK',
          onConfirmBtnTap: () async {
            dobController.clear();
          },
          onCancelBtnTap: () async {
            dobController.clear();
          }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;

    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical: height/81.375,
        horizontal: width/170.75
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding:  EdgeInsets.symmetric(
                  vertical: height/81.375,
                  horizontal: width/170.75
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap:() async {
                      var memberss = await cf.FirebaseFirestore.instance.collection('Members').get();
                      for(int y = 0; y < memberss.docs.length; y++){
                        cf.FirebaseFirestore.instance.collection('Members').doc(memberss.docs[y].id).update({
                          "status" : true,
                        });
                      }
                    },
                    child: KText(
                      text: "MEMBERS",
                      style: GoogleFonts.openSans(
                          fontSize: width/52.538,
                          fontWeight: FontWeight.w900,
                          color: Colors.black),
                    ),
                  ),
                  InkWell(
                      onTap:(){
                        if(currentTab.toUpperCase() == "VIEW") {
                          setState(() {
                            currentTab = "Add";
                          });
                          //clearTextEditingControllers();
                        }else{
                          setState(() {
                            currentTab = 'View';
                          });
                          clearTextEditingControllers();
                        }
                      },
                      child: Container(
                        height: height/18.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow:  [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: width/227.66),
                          child: Center(
                            child: KText(
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Member" : "View Members",
                              style: GoogleFonts.openSans(
                                fontSize: width/105.076,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      )
                  ),
                ],
              ),
            ),
            currentTab.toUpperCase() == "ADD"
                ? Stack(
              alignment: Alignment.center,
                  children: [
                    Container(
              height: profileImageValidator ? size.height * 3.1: size.height * 3.9,
              width: width,
              margin:  EdgeInsets.symmetric(
                    horizontal: width/68.3,
                    vertical: height/32.55
              ),
              decoration: BoxDecoration(
                    color: Constants().primaryAppColor,
                    boxShadow:  [
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
                          padding:  EdgeInsets.symmetric(
                              horizontal: width/68.3, vertical: height/81.375),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              KText(
                                text: "ADD MEMBER",
                                style: GoogleFonts.openSans(
                                  fontSize: width/68.3,
                                  fontWeight: FontWeight.bold,
                                  color: Constants().subHeadingColor,
                                ),
                              ),
                              Row(
                                children: [
                                  PopupMenuButton(
                                    itemBuilder: (BuildContext context) => <PopupMenuEntry>[
                                      PopupMenuItem(
                                        child:  Text('Download Template'),
                                        onTap: (){
                                          downloadTemplateExcel();
                                        },
                                      )
                                    ],
                                    child:  Icon(
                                      Icons.remove_red_eye,
                                      color: Constants().btnTextColor,
                                    ),
                                  ),
                                   SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () async {
                                      FilePickerResult? pickedFile = await FilePicker.platform.pickFiles(
                                        type: FileType.custom,
                                        allowedExtensions: ['xlsx'],
                                        allowMultiple: false,
                                      );
                                      var bytes = pickedFile!.files.single.bytes;
                                      var excel = ex.Excel.decodeBytes(bytes!);
                                      Response response = await MembersFireCrud.bulkUploadMemberss(excel);
                                      if(response.code == 200){
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: "Members created successfully!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor.withOpacity(0.8)
                                        );
                                      }
                                      else{
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: "Failed to Create Members!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor.withOpacity(0.8)
                                        );
                                      }
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      width: width/9.106,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow:  [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: width/227.666),
                                        child: Center(
                                          child: KText(
                                            text: "Bulk Upload",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding:  EdgeInsets.symmetric(
                            vertical: height/32.55,
                            horizontal: width/68.3
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height: height/3.829,
                                  width: width/3.902,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Constants().primaryAppColor, width:width/683),
                                      image: uploadedImage != null
                                          ? DecorationImage(
                                        fit: isCropped ? BoxFit.contain : BoxFit.cover,
                                              image: MemoryImage(
                                                Uint8List.fromList(
                                                  base64Decode(uploadedImage!.split(',').last),
                                                ),
                                              ),
                                            )
                                          : null),
                                  child: uploadedImage == null
                                      ?  Center(
                                          child: Icon(
                                            Icons.cloud_upload,
                                            size: width/8.537,
                                            color: Colors.grey,
                                          ),
                                        ) : null,
                                ),
                              ),
                              SizedBox(height: height/32.55),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  InkWell(
                                    onTap: selectImage,
                                    child: Container(
                                      height: height/18.6,
                                      width: size.width * 0.25,
                                      color: Constants().primaryAppColor,
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo,
                                              color: Constants().btnTextColor,),
                                          SizedBox(width: width/136.6),
                                          KText(
                                            text: 'Select Profile Photo *',
                                            style: TextStyle(color: Constants().btnTextColor,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      if(isCropped){
                                        setState(() {
                                          isCropped = false;
                                        });
                                      }else{
                                        setState(() {
                                          isCropped = true;
                                        });
                                      }
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      width: size.width * 0.25,
                                      color: Constants().primaryAppColor,
                                      child:  Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.crop,
                                            color: Constants().btnTextColor,
                                          ),
                                          SizedBox(width: width/136.6),
                                          KText(
                                            text: 'Disable Crop',
                                            style: TextStyle(color: Constants().btnTextColor,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: selectDocument,
                                    child: Container(
                                      height: height/18.6,
                                      width: size.width * 0.23,
                                      color: Constants().primaryAppColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                           Icon(Icons.file_copy,
                                              color: Constants().btnTextColor,),
                                           SizedBox(width: width/136.6),
                                          KText(
                                            text: docname == "" ? 'Select Baptism Certificate' : docname,
                                            style:  TextStyle(color: Constants().btnTextColor,),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height/21.7),
                              KText(
                                text: "Personal Details",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width / 80.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              SizedBox(height: height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Member ID *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: memberIdController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height/21.7),
                              Row(
                                children: [
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Firstname *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          key: _keyFirstname,
                                          focusNode: firstNameFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(lastNameFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(lastNameFocusNode);
                                          },
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return null;
                                            }
                                          },
                                          onChanged: (val){
                                            //_keyFirstname.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: firstNameController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Middle Name",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          onEditingComplete: (){

                                          },
                                          onFieldSubmitted: (val){

                                          },
                                          onChanged: (val){
                                            //_keyFirstname.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: middleNameController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Lastname *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          key: _keyLastname,
                                          focusNode: lastNameFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(phoneFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(phoneFocusNode);
                                          },
                                          onChanged: (val){
                                            //_keyLastname.currentState!.validate();
                                          },
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return null;
                                            }
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: lastNameController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height/21.7),
                              Row(
                                children: [
                                  Container(
                                    width: width/4.553,
                                    decoration:  BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(
                                                color: Colors.grey,
                                                width:width/910.66
                                            )
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Gender *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          underline: Container(),
                                          isExpanded: true,
                                          value: genderController.text,
                                          icon:  const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Gender",
                                            "Male",
                                            "Female",
                                            "Transgender"
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              genderController.text = newValue!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Blood Group *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height/65.1),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: bloodGroupController.text,
                                          icon: const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Blood Group",
                                            "AB+",
                                            "AB-",
                                            "O+",
                                            "O-",
                                            "A+",
                                            "A-",
                                            "B+",
                                            "B-"
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            if (newValue != "Select Role") {
                                              setState(() {
                                                bloodGroupController.text =
                                                newValue!;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Date of Birth *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          key: _keyDob,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return null;
                                            }
                                          },
                                          readOnly: true,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: dobController,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await Constants().datePicker(context);
                                            // await showDatePicker(
                                            //     context: context,
                                            //     initialDate: DateTime.now(),
                                            //     firstDate: DateTime(1900),
                                            //     lastDate: DateTime.now());
                                            if (pickedDate != null) {
                                              setState(() {
                                                setAge(pickedDate);
                                              });
                                            }
                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
                              /// Baptism Date and Aadhar Number and House type
                              Row(
                                children: [


                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Baptism Date",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize: width / 113.83),
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await Constants().datePicker(context);
                                            // await showDatePicker(
                                            // context: context,
                                            // initialDate: DateTime.now(),
                                            // firstDate: DateTime(1900),
                                            // lastDate: DateTime.now());
                                            if (pickedDate != null) {
                                              setState(() {
                                                baptizeDateController.text = formatter.format(pickedDate);
                                              });
                                            }
                                          },
                                          controller: baptizeDateController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Confirmation Date",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize: width / 113.83),
                                          readOnly: true,
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await Constants().datePicker(context);
                                            // await showDatePicker(
                                            // context: context,
                                            // initialDate: DateTime.now(),
                                            // firstDate: DateTime(1900),
                                            // lastDate: DateTime.now());
                                            if (pickedDate != null) {
                                              setState(() {
                                                confirmDateController.text = formatter.format(pickedDate);
                                              });
                                            }
                                          },
                                          controller: confirmDateController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),

                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Aadhaar Number",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: aadhaarFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(pincodeFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(pincodeFocusNode);
                                          },
                                          key: _keyAadhar,
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Filed must be not emty';
                                            }else if(val!.length != 12){
                                              return 'Must be 12 digits';
                                            }else{
                                              return null;
                                            }
                                          },
                                          onChanged: (val){
                                            //_keyAadhar.currentState!.validate();
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 12,
                                          style:
                                          TextStyle(fontSize: width / 113.83),
                                          controller: aadharNoController,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),

                              SizedBox(height: height / 21.7),

                              ///Material Status
                              Padding(
                                padding:  EdgeInsets.only(top:height/31.375,bottom:height/81.375),
                                child: KText(
                                  text: "Marital Information",
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: width / 80.076,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding:  EdgeInsets.only(top:height/51.375),
                                child: Row(
                                  children: [
                                    Container(
                                      width: width / 4.553,
                                      decoration:  BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                          )
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Marital status *",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width / 105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          DropdownButton(
                                            isExpanded: true,
                                            value: marriedController.text,
                                            icon: Icon(Icons.keyboard_arrow_down),
                                            underline: Container(),
                                            items: [
                                              "Select Status",
                                              "Single",
                                              "Engaged",
                                              "Married",
                                              "Seperated",
                                              "Divorced",
                                              "Widow"
                                            ].map((items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                marriedController.text = newValue!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width / 68.3),
                                    Visibility(
                                      visible: marriedController.text.toUpperCase() == "MARRIED",
                                      child: SizedBox(
                                        width: width / 4.553,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Anniversary Date",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                fontSize: width / 105.076,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              readOnly: true,
                                              style: TextStyle(fontSize: width / 113.83),
                                              controller: marriageDateController,
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                await Constants().datePicker(context);
                                                // await showDatePicker(
                                                //     context: context,
                                                //     initialDate: DateTime.now(),
                                                //     firstDate: DateTime(1900),
                                                //     lastDate: DateTime.now());
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    marriageDateController.text = formatter.format(pickedDate);
                                                  });
                                                }
                                              },
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height/21.7),

                              ///Family Details
                              KText(
                                text: "Family Details",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width / 80.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              SizedBox(height: height/21.7),
                              Row(
                                children: [
                                  Container(
                                    width: width/4.553,
                                    decoration:  BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            width:width/910.66,color: Colors.grey
                                        ))
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family Name *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: familyController.text,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon:  const Icon(Icons.keyboard_arrow_down),
                                          items: FamilyIdList.map((items) {
                                            return DropdownMenuItem(
                                              value: items.name,
                                              child: Text(items.name),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              familyController.text = newValue!;
                                              FamilyIdList.forEach((element) {
                                                if(element.name == newValue){
                                                  familyIDController.text = element.id;
                                                  checkAvailableSlot(element.count, element.name);
                                                }
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  Container(
                                    width: width/4.553,
                                    decoration:  BoxDecoration(
                                        border: Border(bottom: BorderSide(
                                            width:width/910.66,
                                            color: Colors.grey
                                        ))
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Family ID *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: familyIDController.text,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon:  const Icon(Icons.keyboard_arrow_down),
                                          items: FamilyIdList.map((items) {
                                            return DropdownMenuItem(
                                              value: items.id,
                                              child: Text(items.id),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              familyIDController.text = newValue!;
                                              FamilyIdList.forEach((element) {
                                                if(element.id == newValue){
                                                  familyController.text = element.name;
                                                  checkAvailableSlot(element.count, element.name);
                                                }
                                              });
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Relationship to Family",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: relationToFamilyController.text,
                                          icon:  const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Relation",
                                            "Father",
                                            "Mother",
                                            "Son",
                                            "Daughter",
                                            "Husband",
                                            "Wife",
                                            "Brother",
                                            "Sister",
                                            "Grand Father",
                                            "Grand Mother",
                                            "Grand Son",
                                            "Grand Daughter",
                                            "Uncle",
                                            "Aunt",
                                            "Nephew",
                                            "Niece",
                                            "Cousin",
                                            "Father-in-law",
                                            "Mother-in-law",
                                            "Daughter-in-law",
                                            "Son-in-law",
                                            "Brother-in-law",
                                            "Sister-in-law",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              relationToFamilyController.text = newValue!;
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height/21.7),

                              ///Church Deatils
                              KText(
                                text: "Church Details",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width / 80.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              SizedBox(height: height/21.7),


                              Row(
                                children: [
                                  SizedBox(
                                    width: width/4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Previous Church",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: prevChurchFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(landmarkFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(landmarkFocusNode);
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 100,
                                          style:  TextStyle(fontSize: width/113.83),
                                          controller: previousChurchController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  Container(
                                    width: width/4.553,
                                    decoration:  BoxDecoration(
                                        border: Border(
                                            bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                        )
                                    ),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Service Language",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),

                                        DropdownButton(
                                          isExpanded: true,
                                          value: serviceLanguageController.text,
                                          icon:  Icon(Icons.keyboard_arrow_down),
                                          underline: Container(),
                                          items: [
                                            "Select",
                                            "Tamil",
                                            "English",
                                            "Hindi",
                                            "Telugu",
                                            "Malayalam",
                                            "Kannada",
                                            "Marathi",
                                            "Gujarathi",
                                            "Odia",
                                            "Bengali",
                                            "Spanish",
                                            "Portuguese",
                                            "French",
                                            "Dutch",
                                            "German",
                                            "Italian",
                                            "Swedish",
                                            "Luxembourish",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              serviceLanguageController.text = newValue!;
                                            });
                                          },
                                        ),

                                        // TextFormField(
                                        //   style:  TextStyle(fontSize: width/113.83),
                                        //   controller: socialStatusController,
                                        // )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      KText(
                                        text: "Attending Time",
                                        style: GoogleFonts.openSans(
                                          fontSize: width/97.571,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: height/43.4),
                                      SizedBox(
                                        height: height/16.275,
                                        width: width/9.106,
                                        child: DropdownButton(
                                          //underline: Container(),
                                          isExpanded: true,
                                          value: attendingTimeController.text,
                                          icon:  const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Time",
                                            "6:00 AM",
                                            "8:00 AM",
                                            "10:30 AM",
                                            "7:00 PM",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            setState(() {
                                              attendingTimeController.text = newValue!;
                                            });
                                          },
                                        ),
                                      ),

                                      // SizedBox(
                                      //   height: height/16.275,
                                      //   width: width/9.106,
                                      //   child: Padding(
                                      //     padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                      //     child: TextFormField(
                                      //       readOnly: true,
                                      //       onTap: (){
                                      //         _selectTime(context);
                                      //       },
                                      //       controller: attendingTimeController,
                                      //       decoration: InputDecoration(
                                      //         hintStyle: GoogleFonts.openSans(
                                      //           fontSize: width/97.571,
                                      //         ),
                                      //       ),
                                      //     ),
                                      //   ),
                                      // )
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(height: height/21.7),

                              ///professional Details

                              KText(
                                text: "Professional Details",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width / 80.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),
                              Padding(
                                padding:  EdgeInsets.only(top:height/31.375,),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width / 4.553,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Profession",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width / 105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                            focusNode: positionFocusNode,
                                            autofocus: true,
                                            onEditingComplete: (){
                                              FocusScope.of(context).requestFocus(aadhaarFocusNode);
                                            },
                                            onFieldSubmitted: (val){
                                              FocusScope.of(context).requestFocus(aadhaarFocusNode);
                                            },
                                            decoration: InputDecoration(
                                              counterText: "",
                                            ),
                                            maxLength: 100,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                            ],
                                            style: TextStyle(fontSize: width / 113.83),
                                            controller: positionController,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width / 68.3),

                                    SizedBox(
                                      width: width/4.553,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Qualification",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width/105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z .]")),
                                            ],
                                            decoration: InputDecoration(
                                              counterText: "",
                                            ),
                                            maxLength: 100,
                                            style:  TextStyle(fontSize: width/113.83),
                                            controller: qualificationController,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width/68.3),

                                    SizedBox(
                                      width: width/4.553,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Company Name",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width/105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                            ],
                                            decoration: InputDecoration(
                                              counterText: "",
                                            ),
                                            maxLength: 100,
                                            style:  TextStyle(fontSize: width/113.83),
                                            controller: companynameController,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: height / 21.7),
                              ///Contact Details
                              KText(
                                text: "Contact Details",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width / 80.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),

                              ///phone number  and email and alternative Email
                              Padding(
                                padding:  EdgeInsets.only(top:height/81.375),
                                child: Row(
                                  children: [
                                    SizedBox(
                                      width: width / 4.553,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Phone *",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width / 105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                            key: _keyPhone,
                                            focusNode: phoneFocusNode,
                                            autofocus: true,
                                            onEditingComplete: (){
                                              FocusScope.of(context).requestFocus(emailNameFocusNode);
                                            },
                                            onFieldSubmitted: (val){
                                              FocusScope.of(context).requestFocus(emailNameFocusNode);
                                            },
                                            validator: (val){
                                              if(val!.isEmpty) {
                                                return 'Field is required';
                                              } else if(val.length != 10){
                                                return 'number must be 10 digits';
                                              }else{
                                                return null;
                                              }
                                            },
                                            onChanged: (val){
                                              //_keyPhone.currentState!.validate();
                                            },
                                            decoration: InputDecoration(
                                              counterText: "",
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            maxLength: 10,
                                            style: TextStyle(fontSize: width / 113.83),
                                            controller: phoneController,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width / 68.3),
                                    SizedBox(
                                      width: width / 4.553,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Alternative Phone",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width / 105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                            //key: _keyAlterEmail,
                                            //focusNode: alterNativeemailFocusNode,
                                            autofocus: true,

                                            decoration: InputDecoration(
                                              counterText: "",
                                            ),
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(
                                                  RegExp(r'[0-9]')),
                                            ],
                                            maxLength: 10,
                                            validator: (val){
                                              if(val!.isNotEmpty) {
                                                if(val.length != 10){
                                                  return 'number must be 10 digits';
                                                }
                                              }else{
                                                return null;
                                              }
                                            },
                                            onChanged: (val){
                                              //_key.currentState!.validate();
                                            },
                                            style: TextStyle(fontSize: width / 113.83),
                                            controller: alphoneController,
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width / 68.3),
                                    SizedBox(
                                      width: width / 4.553,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Email",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width / 105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          TextFormField(
                                            key: _key,
                                            focusNode: emailFocusNode,
                                            autofocus: true,
                                         /*   onEditingComplete: (){
                                              _key.currentState!.validate();
                                              FocusScope.of(context).requestFocus(professionFocusNode);
                                            },
                                            onFieldSubmitted: (val){
                                              FocusScope.of(context).requestFocus(professionFocusNode);
                                            },*/
                                            validator: (value) {
                                              if (!isEmail(value!)) {
                                                return 'Please enter a valid email.';
                                              }
                                              return null;
                                            },
                                            onChanged: (val){
                                              //_key.currentState!.validate();
                                            },
                                            style: TextStyle(fontSize: width / 113.83),
                                            controller: emailController,
                                          )
                                        ],
                                      ),
                                    ),



                                  ],
                                ),
                              ),


                              SizedBox(height: height / 21.7),



                              Row(
                                  children:[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: [

                                          SizedBox(
                                            width: width / 4.553,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                KText(
                                                  text: "Alternative Email",
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.black,
                                                    fontSize: width / 105.076,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                TextFormField(
                                                  //key: _keyAlterEmail,
                                                  focusNode: alterNativeemailFocusNode,
                                                  autofocus: true,
                                                 /* onEditingComplete: (){
                                                    // _keyAlterEmail.currentState!.validate();
                                                    FocusScope.of(context).requestFocus(professionFocusNode);
                                                  },
                                                  onFieldSubmitted: (val){
                                                    FocusScope.of(context).requestFocus(professionFocusNode);
                                                  },*/
                                                  validator: (value) {
                                                    if (!isEmail(value!)) {
                                                      return 'Please enter a valid email.';
                                                    }
                                                    return null;
                                                  },
                                                  onChanged: (val){
                                                    //_key.currentState!.validate();
                                                  },
                                                  style: TextStyle(fontSize: width / 113.83),
                                                  controller: alterNativeemailController,
                                                )
                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ]
                              ),

                              SizedBox(height: height / 21.7),


                              /// State And City  and Country Dropdown container
                              Row(
                                  children:[
                                    Padding(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Row(
                                        children: [

                                          ///State Dropdown
                                          SizedBox(
                                            height: height/7.5,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                KText(
                                                  text: 'State',
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.black,
                                                    fontSize: width / 105.076,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: height/123.1666),
                                                Container(
                                                  height: height/15.114,
                                                  width: width/4.6,
                                                  decoration: const BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide()
                                                      )
                                                  ),
                                                  padding: EdgeInsets.only(left:width/273.2),
                                                  child:
                                                  DropdownButtonFormField2<String>(
                                                    value:stateController.text,
                                                    isExpanded:true,
                                                    autovalidateMode: AutovalidateMode.onUserInteraction,
                                                    hint: Padding(
                                                      padding: const EdgeInsets.only(left:8.0),
                                                      child: Text(
                                                        'Select State',
                                                        style:
                                                        GoogleFonts.openSans(
                                                          color: Colors.black,
                                                          fontSize: width / 105.076,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    items: StateList.map((String item) => DropdownMenuItem<
                                                        String>(
                                                      value:item, child:
                                                    Text(
                                                      item,
                                                      style:
                                                      GoogleFonts.openSans(
                                                        color: Colors.black,
                                                        fontSize: width / 105.076,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    )).toList(),

                                                    onChanged: (String? value) {

                                                      setState(() {
                                                        stateController.text = value!;
                                                      });
                                                      getCity(value.toString());
                                                    },
                                                    buttonStyleData:
                                                    ButtonStyleData(height:20,
                                                      width:
                                                      width / 2.571,
                                                    ),
                                                    menuItemStyleData: const MenuItemStyleData(),
                                                    decoration:
                                                    const InputDecoration(
                                                        border:
                                                        InputBorder
                                                            .none),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: width/46.5454),
                                          ///city
                                          SizedBox(
                                            height: height/7.5,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                KText(
                                                  text: 'City',
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.black,
                                                    fontSize: width / 105.076,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: height/123.1666),
                                                Container(
                                                  height: height/15.114,
                                                  width: width/4.6,
                                                  decoration: const BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide()
                                                      )
                                                  ),
                                                  child:
                                                  DropdownButtonFormField2<
                                                      String>(
                                                    isExpanded:true,
                                                    hint: Text(
                                                      'Select City',
                                                      style:
                                                      GoogleFonts.openSans(
                                                        color: Colors.black,
                                                        fontSize: width / 105.076,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    items: _cities
                                                        .map((String
                                                    item) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value:
                                                          item,
                                                          child:
                                                          Text(
                                                            item,
                                                            style:
                                                            GoogleFonts.openSans(
                                                              color: Colors.black,
                                                              fontSize: width / 105.076,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ))
                                                        .toList(),
                                                    value:
                                                    cityController.text,
                                                    onChanged: (String?
                                                    value) {
                                                      setState(() {
                                                        cityController.text = value!;
                                                      });

                                                    },
                                                    buttonStyleData:
                                                    const ButtonStyleData(

                                                    ),
                                                    menuItemStyleData:
                                                    const MenuItemStyleData(

                                                    ),
                                                    decoration:
                                                    const InputDecoration(
                                                        border:
                                                        InputBorder
                                                            .none),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          SizedBox(width: width/43.8857),

                                          ///Country Dropdown
                                          SizedBox(
                                            height: height/7.5,
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .start,
                                              children: [
                                                KText(
                                                  text: 'Country',
                                                  style: GoogleFonts.openSans(
                                                    color: Colors.black,
                                                    fontSize: width / 105.076,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: height/123.1666),
                                                Container(
                                                  height: height/15.114,
                                                  width: width/4.6,
                                                  decoration: const BoxDecoration(
                                                      border: Border(
                                                          bottom: BorderSide()
                                                      )
                                                  ),
                                                  child:
                                                  DropdownButtonFormField2<
                                                      String>(
                                                    isExpanded:true,
                                                    hint: Text(
                                                      'Select Country',
                                                      style:
                                                      GoogleFonts.openSans(
                                                        color: Colors.black,
                                                        fontSize: width / 105.076,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    items: coutryList
                                                        .map((String
                                                    item) =>
                                                        DropdownMenuItem<
                                                            String>(
                                                          value:
                                                          item,
                                                          child:
                                                          Text(
                                                            item,
                                                            style:
                                                            GoogleFonts.openSans(
                                                              color: Colors.black,
                                                              fontSize: width / 105.076,
                                                              fontWeight: FontWeight.bold,
                                                            ),
                                                          ),
                                                        ))
                                                        .toList(),
                                                    value:
                                                    countryController.text,
                                                    onChanged: (String?
                                                    value) {
                                                      setState(() {
                                                        countryController.text = value!;
                                                      });

                                                    },
                                                    buttonStyleData:
                                                    const ButtonStyleData(

                                                    ),
                                                    menuItemStyleData:
                                                    const MenuItemStyleData(

                                                    ),
                                                    decoration:
                                                    const InputDecoration(
                                                        border:
                                                        InputBorder
                                                            .none),
                                                  ),
                                                ),

                                              ],
                                            ),
                                          ),

                                        ],
                                      ),
                                    ),
                                  ]
                              ),
                              SizedBox(height: height / 21.7),

                              /// Pin code container
                              Row(
                                children: [

                                  /* SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Nationality",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return null;
                                            }
                                          },
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: nationalityCon,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),*/
                                  SizedBox(
                                    width: width / 4.6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Pin Code *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          focusNode: pincodeFocusNode,
                                          autofocus: true,
                                          onEditingComplete: (){
                                            FocusScope.of(context).requestFocus(localityFocusNode);
                                          },
                                          onFieldSubmitted: (val){
                                            FocusScope.of(context).requestFocus(localityFocusNode);
                                          },
                                          key:_keyPincode,
                                          validator: (val){
                                            if(val!.length != 6){
                                              return 'Must be 6 digits';
                                            }else{
                                              return null;
                                            }
                                          },
                                          onChanged: (val){
                                            //_keyPincode.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(
                                                RegExp(r'[0-9]')),
                                          ],
                                          maxLength: 6,
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: pincodeController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width / 68.3),
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "House Type",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height / 50.076),
                                        DropdownButton(
                                          isExpanded: true,
                                          value: houseTypeCon.text,
                                          icon: const Icon(Icons.keyboard_arrow_down),
                                          items: [
                                            "Select Type",
                                            "Own House",
                                            "Rented House",
                                          ].map((items) {
                                            return DropdownMenuItem(
                                              value: items,
                                              child: Text(items),
                                            );
                                          }).toList(),
                                          onChanged: (newValue) {
                                            if (newValue != "Select Type") {
                                              setState(() {
                                                houseTypeCon.text = newValue!;
                                              });
                                            }
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Residential Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: width / 105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width/68.3,
                                        vertical: height/32.55
                                    ),
                                    decoration: BoxDecoration(
                                      color: Constants().primaryAppColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: height / 32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                focusNode: addressFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(aboutFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(aboutFocusNode);
                                                },
                                                maxLength: 255,
                                                style: TextStyle(
                                                    fontSize: width / 113.83),
                                                controller: residentialAddressController,
                                                decoration: InputDecoration(
                                                    counterText: '',
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(
                                                        left: width / 91.06,
                                                        top: height / 162.75,
                                                        bottom: height / 162.75)),
                                                maxLines: null,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Permanent Address",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize: width / 105.076,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
                                    margin: EdgeInsets.symmetric(
                                        horizontal: width/68.3,
                                        vertical: height/32.55
                                    ),
                                    decoration: BoxDecoration(
                                      color: Constants().primaryAppColor,
                                      boxShadow: const [
                                        BoxShadow(
                                          color: Colors.black26,
                                          offset: Offset(1, 2),
                                          blurRadius: 3,
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: height / 32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                focusNode: aboutFocusNode,
                                                autofocus: true,
                                                maxLength: 255,
                                                style: TextStyle(
                                                    fontSize: width / 113.83),
                                                controller: aboutController,
                                                decoration: InputDecoration(
                                                    counterText: '',
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(
                                                        left: 15,
                                                        top: 4,
                                                        bottom: 4)),
                                                maxLines: null,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),

                              Visibility(
                                visible: profileImageValidator,
                                child: const Text(
                                  "Please Select Image *",
                                  style: TextStyle(
                                    color: Colors.red,
                                  ),
                                ),
                              ),
                              SizedBox(height: height/21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if(!isLoading){
                                        setState((){
                                          isLoading = true;
                                        });
                                        _keyFirstname.currentState!.validate();
                                        _keyLastname.currentState!.validate();
                                        _keyDob.currentState!.validate();
                                        _keyNationality.currentState!.validate();
                                        _keyPincode.currentState!.validate();
                                        _keyPhone.currentState!.validate();
                                        if(profileImage == null){
                                          setState(() {
                                            profileImageValidator = true;
                                          });
                                        }else{
                                          setState(() {
                                            profileImageValidator = false;
                                          });
                                        }
                                        if (
                                            profileImage != null &&
                                                firstNameController.text != "" &&
                                                lastNameController.text != "" &&
                                                dobController.text != "" &&
                                                _keyPhone.currentState!.validate() &&
                                                genderController.text != "Select Gender" &&
                                                bloodGroupController.text != "Select Blood Group" &&
                                            familyController.text != "Select" &&
                                            familyIDController.text != "Select" &&
                                                _keyPincode.currentState!.validate() &&
                                                validateEmail(emailController.text.isNotEmpty) &&
                                                validateAadhaar(aadharNoController.text.isNotEmpty) &&
                                            nationalityController.text != ""
                                            )
                                        {
                                          Response response = await MembersFireCrud.addMember(
                                            aadharNo: aadharNoController.text,
                                            middleName: middleNameController.text,
                                            prefix: prefixController.text,
                                            membersId: memberIdController.text,
                                            serviceLanguage: serviceLanguageController.text,
                                            image: profileImage,
                                            document: documentForUpload,
                                            residentialAddress: residentialAddressController.text,
                                            permanentAddress: permanentAddressController.text,
                                            houseType: houseTypeCon.text,
                                            gender: genderController.text,
                                            baptizeDate: baptizeDateController.text,
                                            bloodGroup: bloodGroupController.text,
                                            department: departmentController.text,
                                            dob: dobController.text,
                                            email: emailController.text,
                                            family: familyController.text,
                                            familyid: familyIDController.text,
                                            firstName: firstNameController.text,
                                            job: jobController.text,
                                            lastName: lastNameController.text,
                                            marriageDate: marriageDateController.text,
                                            nationality: nationalityController.text,
                                            phone: phoneController.text,
                                            position: positionController.text,
                                            socialStatus: socialStatusController.text,
                                            country: countryController.text,
                                            pincode: pincodeController.text,
                                            relationToFamily: relationToFamilyController.text,
                                            qualification: qualificationController.text,
                                            maritalStatus: marriedController.text,
                                            attendingTime: attendingTimeController.text,
                                            previousChurch: previousChurchController.text,
                                            landMark: landMarkController.text,
                                            alterNativeemail: "",
                                            state: "",
                                            contry: ""
                                          );
                                          if (response.code == 200) {
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.success,
                                                text: "Member created successfully!",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants()
                                                    .primaryAppColor
                                                    .withOpacity(0.8));
                                            setMemberId();
                                            setState(() {
                                              currentTab = 'View';
                                            });
                                            clearTextEditingControllers();
                                          }
                                          else {
                                            CoolAlert.show(
                                                context: context,
                                                type: CoolAlertType.error,
                                                text: "Failed to Create Member!",
                                                width: size.width * 0.4,
                                                backgroundColor: Constants()
                                                    .primaryAppColor
                                                    .withOpacity(0.8));
                                            setState(() {
                                              isLoading = false;
                                            });
                                          }
                                        }
                                        else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(snackBar);
                                        }
                                      }
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      width: width*0.1,
                                      decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow:  [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(horizontal: width/227.66),
                                        child: Center(
                                          child: KText(
                                            text: "ADD NOW",
                                            style: GoogleFonts.openSans(
                                              color: Constants().btnTextColor,
                                              fontSize: width/136.6,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
              ),
            ),
                    Visibility(
                      visible: isLoading,
                      child: Container(
                        alignment: AlignmentDirectional.center,
                        decoration: const BoxDecoration(
                          color: Colors.white70,
                        ),
                        child: Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10.0)),
                          width: size.width/1.37,
                          alignment: AlignmentDirectional.center,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Center(
                                child: SizedBox(
                                    height: height/1.86,
                                    width: width/2.732,
                                    child: Lottie.asset("assets/loadinganim.json")
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 25.0),
                                child: Center(
                                  child: Text(
                                    "loading..Please wait...",
                                    style: TextStyle(
                                      fontSize: width/56.91666666666667,
                                      color: Constants().primaryAppColor,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                )
                : currentTab.toUpperCase() == "VIEW" ?
            StreamBuilder(
              //stream: MembersFireCrud.fetchMembers(),
              stream: documentList.isNotEmpty
                  ? cf.FirebaseFirestore.instance.collection('Members').orderBy("timestamp", descending: true).startAfterDocument(documentList[documentList.length - 1]).limit(10).snapshots()
                  : cf.FirebaseFirestore.instance.collection('Members').orderBy("timestamp", descending: true).limit(10).snapshots(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<cf.DocumentSnapshot> members1 = snapshot.data!.docs;
                  List<MembersModel> members = [];
                  membersListForPrint.clear();
                  //documentList.addAll(snapshot.data!.docs);

                  if(searchString != ""){
                    for (var element in memberDocument!.docs) {
                      if(element.get("position")!.toLowerCase().startsWith(searchString.toLowerCase())||
                          element.get("firstName")!.toLowerCase().startsWith(searchString.toLowerCase())||
                          element.get("pincode")!.toLowerCase().startsWith(searchString.toLowerCase())||
                          element.get("firstName").toString().trim().toLowerCase().startsWith(searchString.toLowerCase()) ||
                          element.get("lastName")!.toLowerCase().startsWith(searchString.toLowerCase())||
                          element.get("phone")!.toLowerCase().startsWith(searchString.toLowerCase())){
                        members.add(MembersModel.fromJson(element.data() as Map<String, dynamic>));
                        membersListForPrint.add(MembersModel.fromJson(element.data() as Map<String, dynamic>));
                      }
                    }
                  }else{
                    for (var element in members1) {
                      members.add(MembersModel.fromJson(element.data() as Map<String, dynamic>));
                    }
                    if(memberDocument != null){
                      for (var element in memberDocument!.docs) {
                        membersListForPrint.add(MembersModel.fromJson(element.data() as Map<String, dynamic>));
                      }
                    }
                  }

                  // members1.forEach((element) {
                  //   if(searchString != ""){
                  //     if(element.get("position")!.toLowerCase().startsWith(searchString.toLowerCase())||
                  //         element.get("firstName")!.toLowerCase().startsWith(searchString.toLowerCase())||
                  //         element.get("pincode")!.toLowerCase().startsWith(searchString.toLowerCase())||
                  //         element.get("firstName").toString().trim().toLowerCase().startsWith(searchString.toLowerCase()) ||
                  //         element.get("lastName")!.toLowerCase().startsWith(searchString.toLowerCase())||
                  //         element.get("phone")!.toLowerCase().startsWith(searchString.toLowerCase())){
                  //       members.add(MembersModel.fromJson(element.data() as Map<String, dynamic>));
                  //     }
                  //   }else{
                  //     documentList.add(element);
                  //     members.add(MembersModel.fromJson(element.data() as Map<String, dynamic>));
                  //   }
                  // });
                  return Container(
                    width: width,
                    margin:  EdgeInsets.symmetric(
                            horizontal: width/68.3,
                        vertical: height/32.55
                    ),
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      boxShadow:  [
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
                            padding:  EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "All Members ($totalMembersCount)",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                    color: Constants().subHeadingColor,
                                  ),
                                ),
                                Material(
                                  borderRadius:
                                  BorderRadius.circular(5),
                                  color: Colors.white,
                                  elevation: 10,
                                  child: SizedBox(
                                    height: height / 18.6,
                                    width: width / 4.106,
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(
                                          vertical: height / 81.375,
                                          horizontal: width / 170.75),
                                      child: TextField(
                                        onChanged: (val) {
                                          setState(() {
                                            searchString = val;
                                          });
                                        },
                                        decoration: InputDecoration(
                                          border: InputBorder.none,
                                          hintText:
                                          "Search by Name,Profession,Phone,Pincode",
                                          hintStyle:
                                          GoogleFonts.openSans(
                                            fontSize: width/97.571,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          height: size.height * 0.75,
                          width: double.infinity,
                          decoration:  BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding:  EdgeInsets.symmetric(
                              horizontal: width/68.3,
                              vertical: height/32.55
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      if(searchString != ""){
                                        generateMemberPdf(PdfPageFormat.letter,members,false);
                                      }else{
                                        generateMemberPdf(PdfPageFormat.letter,membersListForPrint,false);
                                      }
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration:  BoxDecoration(
                                        color: Color(0xfffe5722),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(horizontal: width/227.66),
                                        child: Center(
                                          child: Row(
                                            children: [
                                               Icon(Icons.print,
                                                  color: Colors.white),
                                              KText(
                                                text: "PRINT",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                   SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () {
                                      if(searchString != ""){
                                        copyToClipBoard(members);
                                      }else{
                                        copyToClipBoard(membersListForPrint);
                                      }
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration:  BoxDecoration(
                                        color: Color(0xffff9700),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(
                                            horizontal: width/227.66),
                                        child: Center(
                                          child: Row(
                                            children: [
                                               Icon(Icons.copy,
                                                  color: Colors.white),
                                              KText(
                                                text: "COPY",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                   SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () async {
                                      if(searchString != ""){
                                        var data = await generateMemberPdf(PdfPageFormat.letter,members,true);
                                        savePdfToFile(data);
                                      }else{
                                        var data = await generateMemberPdf(PdfPageFormat.letter,membersListForPrint,true);
                                        savePdfToFile(data);
                                      }
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration:  BoxDecoration(
                                        color: Color(0xff9b28b0),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(
                                            horizontal: width/227.66),
                                        child: Center(
                                          child: Row(
                                            children: [
                                               Icon(Icons.picture_as_pdf,
                                                  color: Colors.white),
                                              KText(
                                                text: "PDF",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                   SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: () {
                                      if(searchString != ""){
                                        convertToCsv(members);
                                      }else{
                                        convertToCsv(membersListForPrint);
                                      }
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration:  BoxDecoration(
                                        color: Color(0xff019688),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(
                                            horizontal: width/227.66),
                                        child: Center(
                                          child: Row(
                                            children: [
                                               Icon(
                                                  Icons.file_copy_rounded,
                                                  color: Colors.white),
                                              KText(
                                                text: "CSV",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                               SizedBox(height: height/21.7),
                              SizedBox(
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(
                                    vertical: height/217,
                                    horizontal: width/455.33
                                  ),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: width/20.66,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/11.66,
                                        child: KText(
                                          text: "Member ID",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/15.177,
                                        child: KText(
                                          text: "Photo",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/8.035,
                                        child: KText(
                                          text: "Name",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/9.6,
                                        child: KText(
                                          text: "Status",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/11.5,
                                        child: Row(
                                          children: [
                                            KText(
                                              text: "Phone",
                                              style: GoogleFonts.poppins(
                                                fontSize: width/105.076,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/10.507,
                                        child: KText(
                                          text: "Pin Code",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/8.588,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: searchString != ""
                                    ?  ListView.builder(
                                  itemCount: members.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: height/10.85,
                                      width: double.infinity,
                                      decoration:  BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          top: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width: 0.5,
                                          ),
                                          bottom: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(
                                            horizontal: width/273.2,
                                            vertical: height/130.2
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: width/30.075,
                                              child: KText(
                                                text: ((i + 1)+((temp-1)*10)).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width/9.66,
                                              child: Center(
                                                child: KText(
                                                  text: members[i].memberId!,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/105.076,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/15.177,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(members[i].imgUrl!),
                                                    child: Visibility(
                                                      visible: members[i].imgUrl == "",
                                                      // child: Image.asset(
                                                      //   members[i].gender!.toLowerCase() == "male" ? "assets/mavatar.png" : "assets/favatar.png",
                                                      //   height: 40,
                                                      //   width: 40,
                                                      // )
                                                      child: Icon(
                                                          Icons.person
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/8.035,
                                              child: KText(
                                                text:
                                                "${members[i].firstName!.toLowerCase() != 'null' ? members[i].firstName : ''} ${members[i].lastName!.toLowerCase() != 'null' ? members[i].lastName : ''}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/9.757,
                                              child: Row(
                                                children: [
                                                  FlutterSwitch(
                                                    width: 65,
                                                    height: 32,
                                                    valueFontSize: 11,
                                                    toggleSize: 0,
                                                    value: members[i].status!,
                                                    borderRadius: 30,
                                                    padding: 8.0,
                                                    showOnOff: true,
                                                    activeColor: Colors.green,
                                                    activeText: "Active",
                                                    inactiveColor: Colors.red,
                                                    inactiveText: "Inactive",
                                                    activeToggleColor: Colors.green,
                                                    inactiveToggleColor: Colors.red,
                                                    onToggle: (val) {
                                                      String statsu = !val ? "Inactive" : "Active";
                                                      CoolAlert.show(
                                                          context: context,
                                                          type: CoolAlertType.info,
                                                          text: "${members[i].firstName} ${members[i].lastName}'s status will be $statsu",
                                                          title: "Update this Record?",
                                                          width: size.width * 0.4,
                                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          showCancelBtn: true,
                                                          cancelBtnText: 'Cancel',
                                                          cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                          onConfirmBtnTap: () async {
                                                            await updateMemberStatus(members[i].id!, val);
                                                          }
                                                      );
                                                    },
                                                  ),
                                                  // Row(
                                                  //   children: [
                                                  //     Text(
                                                  //        !members[i].status! == true ? "Inactive" : "Active",
                                                  //     ),
                                                  //
                                                  //   ],
                                                  // ),
                                                  // Switch(
                                                  //   value: members[i].status!,
                                                  //   onChanged: (val) {
                                                  //     String statsu = !val ? "Inactive" : "Active";
                                                  //     CoolAlert.show(
                                                  //         context: context,
                                                  //         type: CoolAlertType.info,
                                                  //         text: "${members[i].firstName} ${members[i].lastName}'s status will be $statsu",
                                                  //         title: "Delete this Record?",
                                                  //         width: size.width * 0.4,
                                                  //         backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                  //         showCancelBtn: true,
                                                  //         cancelBtnText: 'Cancel',
                                                  //         cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                  //         onConfirmBtnTap: () async {
                                                  //           await updateMemberStatus(members[i].id!, val);
                                                  //         }
                                                  //     );
                                                  //   },
                                                  //   activeColor: Colors.green,
                                                  //   inactiveTrackColor: Colors.grey,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/11.38,
                                              child: KText(
                                                text:  members[i].phone.toString().toLowerCase() != 'null' ? members[i].phone! : "",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/10.507,
                                              child: KText(
                                                text: members[i].pincode!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: width/7.588,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        viewPopup(members[i]);
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                        BoxDecoration(
                                                          color:
                                                          Color(0xff2baae4),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                              Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                  color: Colors
                                                                      .white,
                                                                  size: width/91.06,
                                                                ),
                                                                KText(
                                                                  text: "View",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: width/136.6,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: width/273.2),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          residentialAddressController.text = members[i].resistentialAddress!;
                                                          permanentAddressController.text = members[i].permanentAddress!;
                                                          houseTypeCon.text = members[i].houseType!;
                                                          genderController.text = members[i].gender!;
                                                          baptizeDateController.text = members[i].baptizeDate!;
                                                          bloodGroupController.text = members[i].bloodGroup!;
                                                          departmentController.text = members[i].department!;
                                                          dobController.text = members[i].dob!;
                                                          emailController.text = members[i].email!;
                                                          familyController.text = members[i].family!;
                                                          familyIDController.text = members[i].familyid!;
                                                          firstNameController.text = members[i].firstName!;
                                                          jobController.text = members[i].job!;
                                                          lastNameController.text = members[i].lastName!;
                                                          marriageDateController.text = members[i].marriageDate!;
                                                          nationalityController.text = members[i].nationality!;
                                                          phoneController.text = members[i].phone!;
                                                          positionController.text = members[i].position!;
                                                          socialStatusController.text = members[i].socialStatus!;
                                                          countryController.text = members[i].country!;
                                                          selectedImg = members[i].imgUrl;
                                                          pincodeController.text = members[i].pincode!;
                                                          memberIdController.text = members[i].memberId!;
                                                          aadharNoController.text = members[i].aadharNo!;
                                                          marriedController.text = members[i].maritalStatus!;
                                                          attendingTimeController.text = members[i].attendingTime!;
                                                          qualificationController.text = members[i].qualification!;
                                                          relationToFamilyController.text = members[i].relationToFamily!;
                                                          landMarkController.text = members[i].landMark!;
                                                          previousChurchController.text = members[i].previousChurch!;
                                                          prefixController.text = members[i].prefix!;
                                                          middleNameController.text = members[i].middleName!;
                                                          // serviceLanguageController.text = members[i].serviceLanguage!;
                                                        });
                                                        editPopUp(members[i], size);
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                        BoxDecoration(
                                                          color:
                                                          Color(0xffff9700),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                              Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              width/227.66),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: width/91.06,
                                                                ),
                                                                KText(
                                                                  text: "Edit",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    width/136.6,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    SizedBox(width: width/273.2),
                                                    InkWell(
                                                      onTap: () {
                                                        CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType.info,
                                                            text: "${members[i].firstName} ${members[i].lastName} will be deleted",
                                                            title: "Delete this Record?",
                                                            width: size.width * 0.4,
                                                            backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            showCancelBtn: true,
                                                            cancelBtnText: 'Cancel',
                                                            cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                            onConfirmBtnTap: () async {
                                                              Response res = await MembersFireCrud.deleteRecord(id: members[i].id!);
                                                              setMemberId();
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                        BoxDecoration(
                                                          color:
                                                          Color(0xfff44236),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                              Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                          EdgeInsets
                                                              .symmetric(
                                                              horizontal:
                                                              width/227.66),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceAround,
                                                              children: [
                                                                Icon(
                                                                  Icons
                                                                      .cancel_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: width/91.06,
                                                                ),
                                                                KText(
                                                                  text:
                                                                  "Delete",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                    width/136.6,
                                                                    fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                                    : ListView.builder(
                                  itemCount: temp == pagecount ? memberRemainder : members.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: height/10.85,
                                      width: double.infinity,
                                      decoration:  BoxDecoration(
                                        color: Colors.white,
                                        border: Border(
                                          top: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width: 0.5,
                                          ),
                                          bottom: BorderSide(
                                            color: Color(0xfff1f1f1),
                                            width: 0.5,
                                          ),
                                        ),
                                      ),
                                      child: Padding(
                                        padding:  EdgeInsets.symmetric(
                                          horizontal: width/273.2,
                                          vertical: height/130.2
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Container(
                                              width: width/30.075,
                                              child: KText(
                                                text: ((i + 1)+((temp-1)*10)).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            Container(
                                              width: width/9.66,
                                              child: Center(
                                                child: KText(
                                                  text: members[i].memberId!,
                                                  style: GoogleFonts.poppins(
                                                    fontSize: width/105.076,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/15.177,
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage: NetworkImage(members[i].imgUrl!),
                                                    child: Visibility(
                                                      visible: members[i].imgUrl == "",
                                                      // child: Image.asset(
                                                      //   members[i].gender!.toLowerCase() == "male" ? "assets/mavatar.png" : "assets/favatar.png",
                                                      //   height: 40,
                                                      //   width: 40,
                                                      // )
                                                      child: Icon(
                                                          Icons.person
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/8.035,
                                              child: KText(
                                                text:
                                                "${members[i].firstName!.toLowerCase() != 'null' ? members[i].firstName : ''} ${members[i].lastName!.toLowerCase() != 'null' ? members[i].lastName : ''}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/9.757,
                                              child: Row(
                                                children: [
                                                  FlutterSwitch(
                                                    width: 65,
                                                    height: 32,
                                                    valueFontSize: 11,
                                                    toggleSize: 0,
                                                    value: members[i].status!,
                                                    borderRadius: 30,
                                                    padding: 8.0,
                                                    showOnOff: true,
                                                    activeColor: Colors.green,
                                                    activeText: "Active",
                                                    inactiveColor: Colors.red,
                                                    inactiveText: "Inactive",
                                                    activeToggleColor: Colors.green,
                                                    inactiveToggleColor: Colors.red,
                                                    onToggle: (val) {
                                                      String statsu = !val ? "Inactive" : "Active";
                                                          CoolAlert.show(
                                                              context: context,
                                                              type: CoolAlertType.info,
                                                              text: "${members[i].firstName} ${members[i].lastName}'s status will be $statsu",
                                                              title: "Update this Record?",
                                                              width: size.width * 0.4,
                                                              backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                              showCancelBtn: true,
                                                              cancelBtnText: 'Cancel',
                                                              cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                              onConfirmBtnTap: () async {
                                                                await updateMemberStatus(members[i].id!, val);
                                                              }
                                                          );
                                                    },
                                                  ),
                                                  // Row(
                                                  //   children: [
                                                  //     Text(
                                                  //        !members[i].status! == true ? "Inactive" : "Active",
                                                  //     ),
                                                  //
                                                  //   ],
                                                  // ),
                                                  // Switch(
                                                  //   value: members[i].status!,
                                                  //   onChanged: (val) {
                                                  //     String statsu = !val ? "Inactive" : "Active";
                                                  //     CoolAlert.show(
                                                  //         context: context,
                                                  //         type: CoolAlertType.info,
                                                  //         text: "${members[i].firstName} ${members[i].lastName}'s status will be $statsu",
                                                  //         title: "Delete this Record?",
                                                  //         width: size.width * 0.4,
                                                  //         backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                  //         showCancelBtn: true,
                                                  //         cancelBtnText: 'Cancel',
                                                  //         cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                  //         onConfirmBtnTap: () async {
                                                  //           await updateMemberStatus(members[i].id!, val);
                                                  //         }
                                                  //     );
                                                  //   },
                                                  //   activeColor: Colors.green,
                                                  //   inactiveTrackColor: Colors.grey,
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/11.38,
                                              child: KText(
                                                text:  members[i].phone.toString().toLowerCase() != 'null' ? members[i].phone! : "",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/10.507,
                                              child: KText(
                                                text: members[i].pincode!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: width/7.588,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        viewPopup(members[i]);
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                             BoxDecoration(
                                                          color:
                                                              Color(0xff2baae4),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                               EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      6),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                 Icon(
                                                                  Icons
                                                                      .remove_red_eye,
                                                                  color: Colors
                                                                      .white,
                                                                  size: width/91.06,
                                                                ),
                                                                KText(
                                                                  text: "View",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize: width/136.6,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                     SizedBox(width: width/273.2),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          residentialAddressController.text = members[i].resistentialAddress!;
                                                          permanentAddressController.text = members[i].permanentAddress!;
                                                          houseTypeCon.text = members[i].houseType!;
                                                          genderController.text = members[i].gender!;
                                                          baptizeDateController.text = members[i].baptizeDate!;
                                                          bloodGroupController.text = members[i].bloodGroup!;
                                                          departmentController.text = members[i].department!;
                                                          dobController.text = members[i].dob!;
                                                          emailController.text = members[i].email!;
                                                          familyController.text = members[i].family!;
                                                          familyIDController.text = members[i].familyid!;
                                                          firstNameController.text = members[i].firstName!;
                                                          jobController.text = members[i].job!;
                                                          lastNameController.text = members[i].lastName!;
                                                          marriageDateController.text = members[i].marriageDate!;
                                                          nationalityController.text = members[i].nationality!;
                                                          phoneController.text = members[i].phone!;
                                                          positionController.text = members[i].position!;
                                                          socialStatusController.text = members[i].socialStatus!;
                                                          countryController.text = members[i].country!;
                                                          selectedImg = members[i].imgUrl;
                                                          pincodeController.text = members[i].pincode!;
                                                          memberIdController.text = members[i].memberId!;
                                                          aadharNoController.text = members[i].aadharNo!;
                                                          marriedController.text = members[i].maritalStatus!;
                                                          attendingTimeController.text = members[i].attendingTime!;
                                                          qualificationController.text = members[i].qualification!;
                                                          relationToFamilyController.text = members[i].relationToFamily!;
                                                          landMarkController.text = members[i].landMark!;
                                                          previousChurchController.text = members[i].previousChurch!;
                                                          serviceLanguageController.text = members[i].serviceLanguage!;
                                                          prefixController.text = members[i].prefix!;
                                                          middleNameController.text = members[i].middleName!;
                                                        });
                                                        editPopUp(members[i], size);
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                             BoxDecoration(
                                                          color:
                                                              Color(0xffff9700),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                               EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      width/227.66),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                 Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: width/91.06,
                                                                ),
                                                                KText(
                                                                  text: "Edit",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        width/136.6,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                     SizedBox(width: width/273.2),
                                                    InkWell(
                                                      onTap: () {
                                                        CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType.info,
                                                            text: "${members[i].firstName} ${members[i].lastName} will be deleted",
                                                            title: "Delete this Record?",
                                                            width: size.width * 0.4,
                                                            backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            showCancelBtn: true,
                                                            cancelBtnText: 'Cancel',
                                                            cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                            onConfirmBtnTap: () async {
                                                              Response res = await MembersFireCrud.deleteRecord(id: members[i].id!);
                                                              setMemberId();
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                             BoxDecoration(
                                                          color:
                                                              Color(0xfff44236),
                                                          boxShadow: [
                                                            BoxShadow(
                                                              color: Colors
                                                                  .black26,
                                                              offset:
                                                                  Offset(1, 2),
                                                              blurRadius: 3,
                                                            ),
                                                          ],
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                               EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      width/227.66),
                                                          child: Center(
                                                            child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceAround,
                                                              children: [
                                                                 Icon(
                                                                  Icons
                                                                      .cancel_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: width/91.06,
                                                                ),
                                                                KText(
                                                                  text:
                                                                      "Delete",
                                                                  style: GoogleFonts
                                                                      .openSans(
                                                                    color: Colors
                                                                        .white,
                                                                    fontSize:
                                                                        width/136.6,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.center,
                              //   //alignment: Alignment.centerRight,
                              //   children: [
                              //     Container(
                              //       width: width * 0.4,
                              //       height: 46,
                              //       child: ListView.builder(
                              //           shrinkWrap: true,
                              //           scrollDirection: Axis.horizontal,
                              //           itemCount: 10 + shift,
                              //           itemBuilder: (context,index){
                              //             return Padding(
                              //               padding: const EdgeInsets.all(8.0),
                              //               child: InkWell(
                              //                 onTap: (){
                              //                   setState(() {
                              //                     temp= list[index + shift];
                              //                     shift= index;
                              //                   });
                              //                 },
                              //                 child: Container(
                              //                   width: 30,
                              //                   height: 30,
                              //                   decoration: BoxDecoration(
                              //                     color: temp.toString() == list[index + shift].toString() ?  Constants().primaryAppColor : Colors.transparent,
                              //                     borderRadius: BorderRadius.circular(30),
                              //                     border: Border.all(color: Constants().primaryAppColor)
                              //                   ),
                              //                   child: Center(
                              //                     child: Text((list[index + (shift)]).toString(),
                              //                       style: TextStyle(
                              //                         color: temp.toString() == list[index + shift].toString() ? Colors.white : Colors.black,
                              //                       ),
                              //                     ),
                              //                   ),
                              //                 ),
                              //               ),
                              //             );
                              //           }
                              //       ),
                              //     ),
                              //     SizedBox(width: 5),
                              //     Text(
                              //       " .... ",
                              //       style: TextStyle(
                              //           color: Colors.black
                              //       ),
                              //     ),
                              //
                              //       Container(
                              //         width: 30,
                              //         height: 30,
                              //         decoration: BoxDecoration(
                              //             color:  Colors.transparent,
                              //             borderRadius: BorderRadius.circular(30),
                              //             border: Border.all(color: Constants().primaryAppColor)
                              //         ),
                              //       child: Center(
                              //         child: Text(
                              //           pagecount.toString(),
                              //           style: TextStyle(
                              //               color: Colors.black,
                              //             fontSize: 12
                              //           ),
                              //         ),
                              //       ),
                              //     ),
                              //     SizedBox(width: 20),
                              //     temp > 1 ?
                              //     ElevatedButton(
                              //         onPressed: (){
                              //           setState(() {
                              //             temp= temp-1;
                              //             shift= shift-1;
                              //           });
                              //         }, child: Text("Previous Page"))  : Container(),
                              //     SizedBox(width: 20),
                              //     Container(
                              //       child: temp < pagecount ?
                              //       ElevatedButton(onPressed: (){
                              //         setState(() {
                              //           temp= temp+1;
                              //           shift= shift+1;
                              //         });
                              //       }, child: Text("Next Page"))  : Container(),
                              //     )
                              //   ],
                              // ),
                              NumberPaginator(
                                config: NumberPaginatorUIConfig(
                                  buttonSelectedBackgroundColor: Constants().primaryAppColor,
                                  buttonSelectedForegroundColor: Constants().secondaryAppColor,
                                ),
                                numberPages: searchString != "" ? (members.length + 10) ~/ 10 : pagecount,// pagecount,
                                onPageChange: (int index) {
                                  documentList.addAll(snapshot.data!.docs);
                                  setState(() {
                                    temp = index+1;
                                  });
                                },
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ) : Container(),
            SizedBox(height: size.height * 0.04),
            const DeveloperCardWidget(),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }

  bool validateAadhaar(bool isAadhaarNotEmpty){
    bool isValid = false;
    if(isAadhaarNotEmpty){
      _keyAadhar.currentState!.validate();
      isValid = _keyAadhar.currentState!.validate();
    }else{
      isValid = true;
    }
    return isValid;
  }

  bool validateEmail(bool isEmailNotEmpty){
    bool isValid = false;
    if(isEmailNotEmpty){
      _key.currentState!.validate();
      isValid = _key.currentState!.validate();
    }else{
      isValid = true;
    }
    return isValid;
  }

  updateMemberStatus(String docId,bool status) async {
    cf.FirebaseFirestore.instance.collection('Members').doc(docId).update({
    "status" : status,
    });
  }

  viewPopup(MembersModel member) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: size.width * 0.5,
            margin:  EdgeInsets.symmetric(
                horizontal: width/68.3,
                vertical: height/32.55
            ),
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow:  [
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
                SizedBox(
                  height: size.height * 0.1,
                  width: double.infinity,
                  child: Padding(
                    padding:
                     EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          member.firstName!,
                          style: GoogleFonts.openSans(
                            fontSize: width/68.3,
                            fontWeight: FontWeight.bold,
                            color: Constants().subHeadingColor,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            height: height/16.275,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow:  [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding:
                               EdgeInsets.symmetric(horizontal: width/227.66),
                              child: Center(
                                child: KText(
                                  text: "CLOSE",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/85.375,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    decoration:  BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                      ),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Container(
                            width: size.width * 0.3,
                            height: size.height * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(member.imgUrl!),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding:  EdgeInsets.symmetric(
                                  horizontal: width/136.6, vertical: height/43.4),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                   SizedBox(height: height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Member ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      KText(
                                        text: member.memberId!,
                                        style:  TextStyle(
                                            fontSize: width/97.57
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child:  KText(
                                          text: "Baptism Certificate",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: width/85.375
                                          ),
                                        ),
                                      ),
                                       Text(":"),
                                       SizedBox(width: width/68.3),
                                      InkWell(
                                        onTap: () async {
                                          final Uri toLaunch =
                                          Uri.parse(member.baptizemCertificate!);
                                          if (!await launchUrl(toLaunch,
                                            mode: LaunchMode.externalApplication,
                                          )) {
                                            throw Exception('Could not launch $toLaunch');
                                          }
                                        },
                                        child: Container(
                                          height: height/18.6,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow:  [
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(1, 2),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding:
                                             EdgeInsets.symmetric(horizontal: width/227.66),
                                            child: Center(
                                              child: KText(
                                                text: "Download Document",
                                                style: GoogleFonts.openSans(
                                                  fontSize: width/91.066,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                   SizedBox(height: height/32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text:
                                        "${member.firstName!} ${member.middleName!} ${member.lastName!}",
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Blood Group",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.bloodGroup!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Date of Birth",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.dob!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Gender",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.gender!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Phone",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.phone!,
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Email",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.email!,
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Aadhaar Number",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      Text(
                                        mask(member.aadharNo!.toString()),
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Marital Status",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      Text(
                                        member.maritalStatus!.toString(),
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  Visibility(
                                    visible: member.maritalStatus!.toString().toLowerCase() == 'married',
                                    child: Column(
                                      children: [
                                        SizedBox(height: height / 32.55),
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: size.width * 0.15,
                                              child: KText(
                                                text: "Anniversary Date",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w800,
                                                    fontSize:width/85.375),
                                              ),
                                            ),
                                            Text(":"),
                                            SizedBox(width: width / 68.3),
                                            Text(
                                              member.marriageDate!.toString(),
                                              style: TextStyle(fontSize: width/97.571),
                                            )
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Profession",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.position!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "House Type",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.houseType!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Qualification",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.qualification!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Family Name",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.family!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Family ID",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.familyid!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Relation to Family",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.relationToFamily!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Landmark",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.landMark!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Nationality",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.nationality!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Pin Code",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.pincode!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Previous Church",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.previousChurch!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Service Language",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.serviceLanguage!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Attending Time",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.attendingTime!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Baptism Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.baptizeDate!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Qualification",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text: member.qualification!,
                                        style: TextStyle(fontSize: width/97.571),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Permanent Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      SizedBox(
                                        width: size.width*0.3,
                                        child: Text(
                                          member.permanentAddress!,
                                          style: TextStyle(fontSize: width/97.571),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Residential Address",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      SizedBox(
                                        width: size.width * 0.3,
                                        child: Text(
                                          member.resistentialAddress!,
                                          style: TextStyle(fontSize: width/97.571),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  editPopUp(MembersModel member, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setStat) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: size.height * 2,
                width: width/1.241,
                margin:  EdgeInsets.symmetric(
                    horizontal: width/68.3,
                    vertical: height/32.55
                ),
                decoration: BoxDecoration(
                  color: Constants().primaryAppColor,
                  boxShadow:  [
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
                        padding:  EdgeInsets.symmetric(
                            horizontal: width/68.3, vertical: height/217),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            KText(
                              text: "EDIT MEMBER",
                              style: GoogleFonts.openSans(
                                fontSize: width/68.3,
                                fontWeight: FontWeight.bold,
                                color: Constants().subHeadingColor,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                clearTextEditingControllers();
                                Navigator.pop(context);
                              },
                              child:  Icon(
                                Icons.cancel_outlined,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration:  BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        padding:  EdgeInsets.symmetric(
                          horizontal: width/68.3,
                          vertical: height/32.55
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                height: size.height * 0.1,
                                width: double.infinity,
                                child: Padding(
                                  padding:  EdgeInsets.symmetric(
                                      horizontal: width/68.3, vertical: height/81.375),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(
                                        text: "EDIT MEMBER",
                                        style: GoogleFonts.openSans(
                                          fontSize: width/68.3,
                                          fontWeight: FontWeight.bold,
                                          color: Constants().subHeadingColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                width: double.infinity,
                                decoration:  BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    )),
                                padding:  EdgeInsets.symmetric(
                                    vertical: height/32.55,
                                    horizontal: width/68.3
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Center(
                                      child: Container(
                                        height: height/3.8258,
                                        width: width/3.902,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Constants().primaryAppColor,
                                                width:width/683),
                                            image: uploadedImage != null
                                                ? DecorationImage(
                                              fit: BoxFit.fill,
                                              image: MemoryImage(
                                                Uint8List.fromList(
                                                  base64Decode(uploadedImage!
                                                      .split(',')
                                                      .last),
                                                ),
                                              ),
                                            ): selectedImg != null ? DecorationImage(
                                                fit: isCropped ? BoxFit.contain : BoxFit.cover,
                                                image: NetworkImage(selectedImg!))
                                                : null),
                                        child: (uploadedImage == null && selectedImg == null)
                                            ?  Center(
                                          child: Icon(
                                            Icons.cloud_upload,
                                            size: width/8.537,
                                            color: Colors.grey,
                                          ),
                                        )
                                            : null,
                                      ),
                                    ),
                                    SizedBox(height: height/32.55),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        InkWell(
                                          onTap: (){
                                            InputElement input = FileUploadInputElement() as InputElement
                                              ..accept = 'image/*';
                                            input.click();
                                            input.onChange.listen((event) async {
                                              final file = input.files!.first;
                                              FileReader reader = FileReader();
                                              reader.readAsDataUrl(file);
                                              reader.onLoadEnd.listen((event) {
                                                setStat(() {
                                                  profileImage = file;
                                                });
                                                setStat(() {
                                                  uploadedImage = reader.result;
                                                  selectedImg = null;
                                                });

                                              });
                                              setStat(() {});
                                            });
                                          },
                                          child: Container(
                                            height: height/18.6,
                                            width: size.width * 0.25,
                                            color: Constants().primaryAppColor,
                                            child:  Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.add_a_photo,
                                                  color: Constants().btnTextColor,),
                                                SizedBox(width: width/136.6),
                                                KText(
                                                  text: 'Select Profile Photo *',
                                                  style: TextStyle(color: Constants().btnTextColor,),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: (){
                                            if(isCropped){
                                              setState(() {
                                                isCropped = false;
                                              });
                                            }else{
                                              setState(() {
                                                isCropped = true;
                                              });
                                            }
                                          },
                                          child: Container(
                                            height: height/18.6,
                                            width: size.width * 0.25,
                                            color: Constants().primaryAppColor,
                                            child:  Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.crop,
                                                  color: Constants().btnTextColor,
                                                ),
                                                SizedBox(width: width/136.6),
                                                KText(
                                                  text: 'Disable Crop',
                                                  style: TextStyle(color: Constants().btnTextColor,),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          onTap: selectDocument,
                                          child: Container(
                                            height: height/18.6,
                                            width: size.width * 0.23,
                                            color: Constants().primaryAppColor,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.file_copy,
                                                  color: Constants().btnTextColor,),
                                                SizedBox(width: width/136.6),
                                                KText(
                                                  text: docname == "" ? 'Select Baptism Certificate' : docname,
                                                  style:  TextStyle(color: Constants().btnTextColor,),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Member ID *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                readOnly: true,
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: memberIdController,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Firstname *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                key: _keyFirstname,
                                                focusNode: firstNameFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(lastNameFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(lastNameFocusNode);
                                                },
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                onChanged: (val){
                                                  //_keyFirstname.currentState!.validate();
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                ),
                                                maxLength: 40,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                                ],
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: firstNameController,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Middle Name",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                onEditingComplete: (){

                                                },
                                                onFieldSubmitted: (val){

                                                },
                                                onChanged: (val){
                                                  //_keyFirstname.currentState!.validate();
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                ),
                                                maxLength: 40,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                                ],
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: middleNameController,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Lastname *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                key: _keyLastname,
                                                focusNode: lastNameFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(phoneFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(phoneFocusNode);
                                                },
                                                onChanged: (val){
                                                  //_keyLastname.currentState!.validate();
                                                },
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                ),
                                                maxLength: 40,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                                ],
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: lastNameController,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      children: [
                                        Container(
                                          width: width/4.553,
                                          decoration:  BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.grey,
                                                      width:width/910.66
                                                  )
                                              )
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Gender *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              DropdownButton(
                                                underline: Container(),
                                                isExpanded: true,
                                                value: genderController.text,
                                                icon:  const Icon(Icons.keyboard_arrow_down),
                                                items: [
                                                  "Select Gender",
                                                  "Male",
                                                  "Female",
                                                  "Transgender"
                                                ].map((items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setStat(() {
                                                    genderController.text = newValue!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Blood Group *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: height/65.1),
                                              DropdownButton(
                                                isExpanded: true,
                                                value: bloodGroupController.text,
                                                icon: const Icon(Icons.keyboard_arrow_down),
                                                items: [
                                                  "Select Blood Group",
                                                  "AB+",
                                                  "AB-",
                                                  "O+",
                                                  "O-",
                                                  "A+",
                                                  "A-",
                                                  "B+",
                                                  "B-"
                                                ].map((items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  if (newValue != "Select Role") {
                                                    setStat(() {
                                                      bloodGroupController.text =
                                                      newValue!;
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Date of Birth *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                key: _keyDob,
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                readOnly: true,
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: dobController,
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                  await Constants().datePicker(context);
                                                  // await showDatePicker(
                                                  //     context: context,
                                                  //     initialDate: DateTime.now(),
                                                  //     firstDate: DateTime(1900),
                                                  //     lastDate: DateTime.now());
                                                  if (pickedDate != null) {
                                                    setState(() {
                                                      setAge(pickedDate);
                                                    });
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Phone *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                key: _keyPhone,
                                                focusNode: phoneFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(emailNameFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(emailNameFocusNode);
                                                },
                                                validator: (val){
                                                  if(val!.isEmpty) {
                                                    return 'Field is required';
                                                  } else if(val.length != 10){
                                                    return 'number must be 10 digits';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                onChanged: (val){
                                                  // _keyPhone.currentState!.validate();
                                                },
                                                decoration: const InputDecoration(
                                                  counterText: "",
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(
                                                      RegExp(r'[0-9]')),
                                                ],
                                                maxLength: 10,
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: phoneController,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Email",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                key: _key,
                                                focusNode: emailNameFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  _key.currentState!.validate();
                                                  FocusScope.of(context).requestFocus(positionFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(positionFocusNode);
                                                },
                                                validator: (value) {
                                                  if (!isEmail(value!)) {
                                                    return 'Please enter a valid email.';
                                                  }
                                                  return null;
                                                },
                                                onChanged: (val){
                                                  //_key.currentState!.validate();
                                                },
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: emailController,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Aadhaar Number",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                key: _keyAadhar,
                                                focusNode: aadhaarFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(jobFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(jobFocusNode);
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                ),
                                                validator: (val){
                                                  if(val!.length != 12){
                                                    return 'Must be 12 digits';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                onChanged: (val){
                                                  //_keyAadhar.currentState!.validate();
                                                },
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(
                                                      RegExp(r'[0-9]')),
                                                ],
                                                maxLength: 12,
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: aadharNoController,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      children: [
                                        Container(
                                          width: width / 4.553,
                                          decoration:  BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                              )
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Marital status",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              DropdownButton(
                                                isExpanded: true,
                                                value: marriedController.text,
                                                icon: Icon(Icons.keyboard_arrow_down),
                                                underline: Container(),
                                                items: [
                                                  "Select Status",
                                                  "Single",
                                                  "Engaged",
                                                  "Married",
                                                  "Seperated",
                                                  "Divorced",
                                                  "Widow"
                                                ].map((items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setStat(() {
                                                    marriedController.text = newValue.toString();
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        Visibility(
                                          visible: marriedController.text.toUpperCase() == "MARRIED",
                                          child: Row(
                                            children: [
                                              SizedBox(width: width/68.3),
                                              SizedBox(
                                                width: width/4.553,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    KText(
                                                      text: "Anniversary Date",
                                                      style: GoogleFonts.openSans(
                                                        color: Colors.black,
                                                        fontSize: width/105.076,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    TextFormField(
                                                      readOnly: true,
                                                      style:  TextStyle(fontSize: width/113.83),
                                                      controller: marriageDateController,
                                                      onTap: () async {
                                                        DateTime? pickedDate =
                                                        await Constants().datePicker(context);
                                                        // await showDatePicker(
                                                        //     context: context,
                                                        //     initialDate: DateTime.now(),
                                                        //     firstDate: DateTime(1900),
                                                        //     lastDate: DateTime.now());
                                                        if (pickedDate != null) {
                                                          setState(() {
                                                            marriageDateController.text = formatter.format(pickedDate);
                                                          });
                                                        }
                                                      },
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Profession",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                focusNode: positionFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(aadhaarFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(aadhaarFocusNode);
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                ),
                                                maxLength: 100,
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                                ],
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: positionController,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width / 4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "House Type",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: height / 50.076),
                                              DropdownButton(
                                                isExpanded: true,
                                                value: houseTypeCon.text,
                                                icon: const Icon(Icons.keyboard_arrow_down),
                                                items: [
                                                  "Select Type",
                                                  "Own House",
                                                  "Rented House",
                                                ].map((items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  if (newValue != "Select Type") {
                                                    setStat(() {
                                                      houseTypeCon.text = newValue!;
                                                    });
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Qualification",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z ]")),
                                                ],
                                                focusNode: qualificationFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(prevChurchFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(prevChurchFocusNode);
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                ),
                                                maxLength: 100,
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: qualificationController,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      children: [
                                        Container(
                                          width: width/4.553,
                                          decoration:  BoxDecoration(
                                              border: Border(bottom: BorderSide(
                                                  width:width/910.66,color: Colors.grey
                                              ))
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Family Name *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              DropdownButton(
                                                value: familyController.text,
                                                isExpanded: true,
                                                underline: Container(),
                                                icon:  const Icon(Icons.keyboard_arrow_down),
                                                items: FamilyIdList.map((items) {
                                                  return DropdownMenuItem(
                                                    value: items.name,
                                                    child: Text(items.name),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setStat(() {
                                                    familyController.text = newValue!;
                                                    FamilyIdList.forEach((element) {
                                                      if(element.name == newValue){
                                                        familyIDController.text = element.id;
                                                        checkAvailableSlot(element.count, element.name);
                                                      }
                                                    });
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        Container(
                                          width: width/4.553,
                                          decoration:  BoxDecoration(
                                              border: Border(bottom: BorderSide(
                                                  width:width/910.66,
                                                  color: Colors.grey
                                              ))
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Family ID *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              DropdownButton(
                                                value: familyIDController.text,
                                                isExpanded: true,
                                                underline: Container(),
                                                icon:  const Icon(Icons.keyboard_arrow_down),
                                                items: FamilyIdList.map((items) {
                                                  return DropdownMenuItem(
                                                    value: items.id,
                                                    child: Text(items.id),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setStat(() {
                                                    familyIDController.text = newValue!;
                                                    FamilyIdList.forEach((element) {
                                                      if(element.id == newValue){
                                                        familyController.text = element.name;
                                                        checkAvailableSlot(element.count, element.name);
                                                      }
                                                    });
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Relationship to Family",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              DropdownButton(
                                                isExpanded: true,
                                                value: relationToFamilyController.text,
                                                icon:  const Icon(Icons.keyboard_arrow_down),
                                                items: [
                                                  "Select Relation",
                                                  "Father",
                                                  "Mother",
                                                  "Son",
                                                  "Daughter",
                                                  "Husband",
                                                  "Wife",
                                                  "Brother",
                                                  "Sister",
                                                  "Grand Father",
                                                  "Grand Mother",
                                                  "Grand Son",
                                                  "Grand Daughter",
                                                  "Uncle",
                                                  "Aunt",
                                                  "Nephew",
                                                  "Niece",
                                                  "Cousin",
                                                  "Father-in-law",
                                                  "Mother-in-law",
                                                  "Daughter-in-law",
                                                  "Son-in-law",
                                                  "Brother-in-law",
                                                  "Sister-in-law",
                                                ].map((items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setStat(() {
                                                    relationToFamilyController.text = newValue!;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Landmark",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                focusNode: landmarkFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(nationalityFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(nationalityFocusNode);
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                ),
                                                maxLength: 100,
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: landMarkController,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Nationality *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                key: _keyNationality,
                                                focusNode: nationalityFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(pincodeFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(pincodeFocusNode);
                                                },
                                                onChanged: (val){
                                                  //_keyNationality.currentState!.validate();
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                ),
                                                maxLength: 40,
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                                ],
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: nationalityController,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Pin code *",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                key:_keyPincode,
                                                focusNode: pincodeFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(addressFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(addressFocusNode);
                                                },
                                                validator: (val){
                                                  if(val!.length != 6){
                                                    return 'Must be 6 digits';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                onChanged: (val){
                                                  // _keyPincode.currentState!.validate();
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                ),
                                                inputFormatters: [
                                                  FilteringTextInputFormatter.allow(
                                                      RegExp(r'[0-9]')),
                                                ],
                                                maxLength: 6,
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: pincodeController,
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Previous Church",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                focusNode: prevChurchFocusNode,
                                                autofocus: true,
                                                onEditingComplete: (){
                                                  FocusScope.of(context).requestFocus(landmarkFocusNode);
                                                },
                                                onFieldSubmitted: (val){
                                                  FocusScope.of(context).requestFocus(landmarkFocusNode);
                                                },
                                                decoration: InputDecoration(
                                                  counterText: "",
                                                ),
                                                maxLength: 100,
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: previousChurchController,
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        Container(
                                          width: width/4.553,
                                          decoration:  BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                              )
                                          ),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Service Language",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),

                                              DropdownButton(
                                                isExpanded: true,
                                                value: serviceLanguageController.text,
                                                icon:  Icon(Icons.keyboard_arrow_down),
                                                underline: Container(),
                                                items: [
                                                  "Select",
                                                  "Tamil",
                                                  "English",
                                                  "Hindi",
                                                  "Telugu",
                                                  "Malayalam",
                                                  "Kannada",
                                                  "Marathi",
                                                  "Gujarathi",
                                                  "Odia",
                                                  "Bengali",
                                                  "Spanish",
                                                  "Portuguese",
                                                  "French",
                                                  "Dutch",
                                                  "German",
                                                  "Italian",
                                                  "Swedish",
                                                  "Luxembourish",
                                                ].map((items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setStat(() {
                                                    serviceLanguageController.text = newValue!;
                                                  });
                                                },
                                              ),

                                              // TextFormField(
                                              //   style:  TextStyle(fontSize: width/113.83),
                                              //   controller: socialStatusController,
                                              // )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            KText(
                                              text: "Attending Time",
                                              style: GoogleFonts.openSans(
                                                fontSize: width/97.571,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: height/43.4),
                                            SizedBox(
                                              height: height/16.275,
                                              width: width/9.106,
                                              child: DropdownButton(
                                                //underline: Container(),
                                                isExpanded: true,
                                                value: attendingTimeController.text,
                                                icon:  const Icon(Icons.keyboard_arrow_down),
                                                items: [
                                                  "Select Time",
                                                  "6:00 AM",
                                                  "8:00 AM",
                                                  "10:30 AM",
                                                  "7:00 PM",
                                                ].map((items) {
                                                  return DropdownMenuItem(
                                                    value: items,
                                                    child: Text(items),
                                                  );
                                                }).toList(),
                                                onChanged: (newValue) {
                                                  setStat(() {
                                                    attendingTimeController.text = newValue!;
                                                  });
                                                },
                                              ),
                                            ),

                                            // SizedBox(
                                            //   height: height/16.275,
                                            //   width: width/9.106,
                                            //   child: Padding(
                                            //     padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                            //     child: TextFormField(
                                            //       readOnly: true,
                                            //       onTap: (){
                                            //         _selectTime(context);
                                            //       },
                                            //       controller: attendingTimeController,
                                            //       decoration: InputDecoration(
                                            //         hintStyle: GoogleFonts.openSans(
                                            //           fontSize: width/97.571,
                                            //         ),
                                            //       ),
                                            //     ),
                                            //   ),
                                            // )
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: width/4.553,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              KText(
                                                text: "Baptism Date",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.black,
                                                  fontSize: width/105.076,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              TextFormField(
                                                readOnly: true,
                                                style:  TextStyle(fontSize: width/113.83),
                                                controller: baptizeDateController,
                                                onTap: () async {
                                                  DateTime? pickedDate =
                                                  await Constants().datePicker(context);
                                                  // await showDatePicker(
                                                  //     context: context,
                                                  //     initialDate: DateTime.now(),
                                                  //     firstDate: DateTime(1900),
                                                  //     lastDate: DateTime.now());
                                                  if (pickedDate != null) {
                                                    setStat(() {
                                                      baptizeDateController.text = formatter.format(pickedDate);
                                                    });
                                                  }
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(width: width/68.3),
                                      ],
                                    ),
                                    // Row(
                                    //   children: [
                                    //
                                    //      SizedBox(width: width/68.3),
                                    //     SizedBox(
                                    //       width: width/4.553,
                                    //       child: Column(
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           KText(
                                    //             text: "Employment/Job",
                                    //             style: GoogleFonts.openSans(
                                    //               color: Colors.black,
                                    //               fontSize: width/105.076,
                                    //               fontWeight: FontWeight.bold,
                                    //             ),
                                    //           ),
                                    //           TextFormField(
                                    //             focusNode: jobFocusNode,
                                    //             autofocus: true,
                                    //             onEditingComplete: (){
                                    //               FocusScope.of(context).requestFocus(departmentFocusNode);
                                    //             },
                                    //             onFieldSubmitted: (val){
                                    //               FocusScope.of(context).requestFocus(departmentFocusNode);
                                    //             },
                                    //             decoration: InputDecoration(
                                    //               counterText: "",
                                    //             ),
                                    //             maxLength: 100,
                                    //             style:  TextStyle(fontSize: width/113.83),
                                    //             controller: jobController,
                                    //           )
                                    //         ],
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    //  SizedBox(height: height/21.7),
                                    //  Row(
                                    //    children: [
                                    //      SizedBox(
                                    //        width: width/4.553,
                                    //        child: Column(
                                    //          crossAxisAlignment: CrossAxisAlignment.start,
                                    //          children: [
                                    //            KText(
                                    //              text: "Department",
                                    //              style: GoogleFonts.openSans(
                                    //                color: Colors.black,
                                    //                fontSize: width/105.076,
                                    //                fontWeight: FontWeight.bold,
                                    //              ),
                                    //            ),
                                    //            TextFormField(
                                    //              focusNode: departmentFocusNode,
                                    //              autofocus: true,
                                    //              onEditingComplete: (){
                                    //                FocusScope.of(context).requestFocus(qualificationFocusNode);
                                    //              },
                                    //              onFieldSubmitted: (val){
                                    //                FocusScope.of(context).requestFocus(qualificationFocusNode);
                                    //              },
                                    //              decoration: InputDecoration(
                                    //                counterText: "",
                                    //              ),
                                    //              maxLength: 100,
                                    //              style:  TextStyle(fontSize: width/113.83),
                                    //              controller: departmentController,
                                    //            )
                                    //          ],
                                    //        ),
                                    //      ),
                                    //      SizedBox(width: width/68.3),
                                    //    ],
                                    //  ),
                                    //  SizedBox(height: height/21.7),
                                    // Row(
                                    //   children: [
                                    //
                                    //     SizedBox(width: width/68.3),
                                    //     Container(
                                    //       width: width/4.553,
                                    //       decoration:  BoxDecoration(
                                    //           border: Border(
                                    //               bottom: BorderSide(width:width/910.66,color: Colors.grey)
                                    //           )
                                    //       ),
                                    //       child: Column(
                                    //         crossAxisAlignment: CrossAxisAlignment.start,
                                    //         children: [
                                    //           KText(
                                    //             text: "Social Status",
                                    //             style: GoogleFonts.openSans(
                                    //               color: Colors.black,
                                    //               fontSize: width/105.076,
                                    //               fontWeight: FontWeight.bold,
                                    //             ),
                                    //           ),
                                    //
                                    //           DropdownButton(
                                    //             isExpanded: true,
                                    //             value: socialStatusController.text,
                                    //             icon:  Icon(Icons.keyboard_arrow_down),
                                    //             underline: Container(),
                                    //             items: [
                                    //               "Select",
                                    //               "Politicians",
                                    //               "Social Service",
                                    //               "Others"
                                    //             ].map((items) {
                                    //               return DropdownMenuItem(
                                    //                 value: items,
                                    //                 child: Text(items),
                                    //               );
                                    //             }).toList(),
                                    //             onChanged: (newValue) {
                                    //               setState(() {
                                    //                 socialStatusController.text = newValue!;
                                    //               });
                                    //             },
                                    //           ),
                                    //
                                    //           // TextFormField(
                                    //           //   style:  TextStyle(fontSize: width/113.83),
                                    //           //   controller: socialStatusController,
                                    //           // )
                                    //         ],
                                    //       ),
                                    //     ),
                                    //
                                    //   ],
                                    // ),
                                    SizedBox(height: height/21.7),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Residential Address",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          height: size.height * 0.15,
                                          width: double.infinity,
                                          margin:  EdgeInsets.symmetric(
                                              horizontal: width/68.3,
                                              vertical: height/32.55
                                          ),
                                          decoration: BoxDecoration(
                                            color: Constants().primaryAppColor,
                                            boxShadow:  [
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(1, 2),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              SizedBox(
                                                height: height/32.55,
                                                width: double.infinity,
                                              ),
                                              Expanded(
                                                child: Container(
                                                    width: double.infinity,
                                                    decoration:  const BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    child: TextFormField(
                                                      focusNode: addressFocusNode,
                                                      autofocus: true,
                                                      maxLength: 255,
                                                      style:  TextStyle(
                                                          fontSize: width/113.83),
                                                      controller: residentialAddressController,
                                                      decoration:  InputDecoration(
                                                          counterText: '',
                                                          border: InputBorder.none,
                                                          contentPadding: EdgeInsets.only(left: width/91.06,
                                                              top: height/162.75,bottom: height/162.75)
                                                      ),
                                                      maxLines: null,
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Permanent Address",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Container(
                                          height: size.height * 0.15,
                                          width: double.infinity,
                                          margin:  EdgeInsets.symmetric(
                                              horizontal: width/68.3,
                                              vertical: height/32.55
                                          ),
                                          decoration: BoxDecoration(
                                            color: Constants().primaryAppColor,
                                            boxShadow:  [
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(1, 2),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .spaceEvenly,
                                            children: [
                                              SizedBox(
                                                height: height/32.55,
                                                width: double.infinity,
                                              ),
                                              Expanded(
                                                child: Container(
                                                    width: double.infinity,
                                                    decoration:  const BoxDecoration(
                                                      color: Colors.white,
                                                    ),
                                                    child: TextFormField(
                                                      maxLength: 255,
                                                      style:  TextStyle(
                                                          fontSize: width/113.83),
                                                      controller: permanentAddressController,
                                                      decoration:  InputDecoration(
                                                          counterText: '',
                                                          border: InputBorder.none,
                                                          contentPadding: EdgeInsets.only(left: width/91.06,
                                                              top: height/162.75,bottom: height/162.75)
                                                      ),
                                                      maxLines: null,
                                                    )
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: height/21.7),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            if(!isLoading){
                                              setState((){
                                                isLoading = true;
                                              });
                                              _keyFirstname.currentState!.validate();
                                              _keyLastname.currentState!.validate();
                                              _keyNationality.currentState!.validate();
                                              _keyPincode.currentState!.validate();
                                              _keyDob.currentState!.validate();
                                              _keyPhone.currentState!.validate();
                                              if (
                                                  firstNameController.text != "" &&
                                                  lastNameController.text != "" &&
                                                  dobController.text != "" &&
                                                  _keyPhone.currentState!.validate() &&
                                                  genderController.text != "Select Gender" &&
                                                  bloodGroupController.text != "Select Blood Group" &&
                                                  familyController.text != "Select" &&
                                                  familyIDController.text != "Select" &&
                                                  _keyPincode.currentState!.validate() &&
                                                  validateEmail(emailController.text.isNotEmpty) &&
                                                      validateAadhaar(aadharNoController.text.isNotEmpty) &&
                                                  nationalityController.text != ""
                                              )
                                              {
                                                Response response = await MembersFireCrud.updateRecord(
                                                  MembersModel(
                                                    id: member.id,
                                                    status: member.status,
                                                    baptizemCertificate: member.baptizemCertificate,
                                                    imgUrl: member.imgUrl,
                                                    memberId: member.memberId,
                                                    resistentialAddress: member.resistentialAddress,
                                                    timestamp: member.timestamp,
                                                    aadharNo: aadharNoController.text,
                                                    middleName: middleNameController.text,
                                                    prefix: prefixController.text,
                                                    serviceLanguage: serviceLanguageController.text,
                                                    permanentAddress: permanentAddressController.text,
                                                    houseType: houseTypeCon.text,
                                                    gender: genderController.text,
                                                    baptizeDate: baptizeDateController.text,
                                                    bloodGroup: bloodGroupController.text,
                                                    department: departmentController.text,
                                                    dob: dobController.text,
                                                    email: emailController.text,
                                                    family: familyController.text,
                                                    familyid: familyIDController.text,
                                                    firstName: firstNameController.text,
                                                    job: jobController.text,
                                                    lastName: lastNameController.text,
                                                    marriageDate: marriageDateController.text,
                                                    nationality: nationalityController.text,
                                                    phone: phoneController.text,
                                                    position: positionController.text,
                                                    socialStatus: socialStatusController.text,
                                                    country: countryController.text,
                                                    pincode: pincodeController.text,
                                                    relationToFamily: relationToFamilyController.text,
                                                    qualification: qualificationController.text,
                                                    maritalStatus: marriedController.text,
                                                    attendingTime: attendingTimeController.text,
                                                    previousChurch: previousChurchController.text,
                                                    landMark: landMarkController.text,
                                                  ),
                                                  profileImage,
                                                  member.imgUrl!,
                                                );
                                                if (response.code == 200) {
                                                  await CoolAlert.show(
                                                      context: context,
                                                      type: CoolAlertType.success,
                                                      text: "Member updated successfully!",
                                                      width: size.width * 0.4,
                                                      backgroundColor: Constants()
                                                          .primaryAppColor
                                                          .withOpacity(0.8));
                                                  setMemberId();
                                                  clearTextEditingControllers();
                                                  Navigator.pop(context);
                                                }
                                                else {
                                                  await CoolAlert.show(
                                                      context: context,
                                                      type: CoolAlertType.error,
                                                      text: "Failed to update Member!",
                                                      width: size.width * 0.4,
                                                      backgroundColor: Constants()
                                                          .primaryAppColor
                                                          .withOpacity(0.8));
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                }
                                              }
                                              else {
                                                setState(() {
                                                  isLoading = false;
                                                });
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              }
                                            }
                                          },
                                          child: Container(
                                            height: height/18.6,
                                            width: width*0.1,
                                            decoration: BoxDecoration(
                                              color: Constants().primaryAppColor,
                                              borderRadius: BorderRadius.circular(8),
                                              boxShadow:  [
                                                BoxShadow(
                                                  color: Colors.black26,
                                                  offset: Offset(1, 2),
                                                  blurRadius: 3,
                                                ),
                                              ],
                                            ),
                                            child: Padding(
                                              padding:  EdgeInsets.symmetric(horizontal: width/227.66),
                                              child: Center(
                                                child: KText(
                                                  text: "UPDATE NOW",
                                                  style: GoogleFonts.openSans(
                                                    color: Constants().btnTextColor,
                                                    fontSize: width/136.6,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
        );
      },
    );
  }

  convertToCsv(List<MembersModel> members) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Member ID");
    row.add("Name");
    row.add("Phone");
    row.add("Email");
    row.add("Gender");
    row.add("Profession");
    row.add("Baptism Date");
    row.add("Marital Status");
    row.add("Marriage Date");
    row.add("Social Status");
    row.add("Job");
    row.add("Family");
    row.add("Relationship to Family");
    row.add("Qualification");
    row.add("Attending Time");
    row.add("Department");
    row.add("Blood Group");
    row.add("Date of Birth");
    row.add("Nationality");
    row.add("Residential Address");
    row.add("Pin Code");
    rows.add(row);
    for (int i = 0; i < members.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(members[i].memberId);
      row.add("${members[i].firstName!} ${members[i].lastName!}");
      row.add(members[i].phone);
      row.add(members[i].email);
      row.add(members[i].gender);
      row.add(members[i].position);
      row.add(members[i].baptizeDate);
      row.add(members[i].maritalStatus);
      row.add(members[i].marriageDate);
      row.add(members[i].socialStatus);
      row.add(members[i].job);
      row.add(members[i].family);
      row.add(members[i].relationToFamily);
      row.add(members[i].qualification);
      row.add(members[i].attendingTime);
      row.add(members[i].department);
      row.add(members[i].bloodGroup);
      row.add(members[i].dob);
      row.add(members[i].nationality);
      row.add(members[i].resistentialAddress);
      row.add(members[i].pincode);
      rows.add(row);
    }
    String csv =  ListToCsvConverter().convert(rows);
    saveCsvToFile(csv);
  }

  void saveCsvToFile(csvString) async {
    final blob = Blob([Uint8List.fromList(csvString.codeUnits)]);
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "data.csv")
      ..click();
    Url.revokeObjectUrl(url);
  }

  void savePdfToFile(data) async {
    final blob = Blob([data],'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "members.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<MembersModel> members) async  {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Name");
    row.add("    ");
    row.add("Profession");
    row.add("    ");
    row.add("Phone");
    row.add("    ");
    row.add("Country");
    rows.add(row);
    for (int i = 0; i < members.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add("${members[i].firstName} ${members[i].lastName}");
      row.add("       ");
      row.add(members[i].position);
      row.add("       ");
      row.add(members[i].phone);
      row.add("       ");
      row.add(members[i].country);
      rows.add(row);
    }
    String csv =  ListToCsvConverter().convert(rows,fieldDelimiter: null,eol: null,textEndDelimiter: null,delimitAllFields: false,textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",","")));
  }

  String mask(String input) {
    String result = '';
    int maskLen = input.length  - 4;
    for(int i = 0; i < input.length; i++){
      if(i < maskLen){
        result += 'x';
      }else{
        result += input[i].toString();
      }
    }
    return result;
  }

  final snackBar = SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding:  EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width: 3),
          boxShadow:  [
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
             Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text('Please fill required fields !!',
                  style: TextStyle(color: Colors.black)),
            ),
             Spacer(),
            TextButton(
                onPressed: () => debugPrint("Undid"), child:  Text("Undo"))
          ],
        )),
  );

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime)
      setState(() {
        _selectedTime = picked;
        attendingTimeController.text = picked.toString();
      });
    _formatTime(picked!);
  }


  String _formatTime(TimeOfDay time) {
    int hour = time.hourOfPeriod;
    int minute = time.minute;
    String period = time.period == DayPeriod.am ? 'AM' : 'PM';
    setState(() {
      attendingTimeController.text ='${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
    });

    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }
}


class FamilyNameWithId{
  FamilyNameWithId({ required this.count,required this.id,required this.name});
  String name;
  String id;
  int count;
}
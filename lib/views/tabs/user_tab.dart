import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:age_calculator/age_calculator.dart';
import 'package:church_management_admin/models/user_model.dart';
import 'package:church_management_admin/services/user_firecrud.dart';
import 'package:cloud_firestore/cloud_firestore.dart' as cf;
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:number_paginator/number_paginator.dart';
import 'package:pdf/pdf.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as wb;
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';
import '../prints/user_print.dart';
import 'package:excel/excel.dart' as ex;
import 'package:intl/intl.dart';
import 'package:church_management_admin/SatusModel.dart' as StatusModel;


class UserTab extends StatefulWidget {
  UserTab({super.key});

  @override
  State<UserTab> createState() => _UserTabState();
}

class _UserTabState extends State<UserTab> {
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

  final DateFormat formatter = DateFormat('dd-MM-yyyy');
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController alphoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController alterNativeemailController = TextEditingController();
  TextEditingController professionController = TextEditingController();
  TextEditingController baptizeDateController = TextEditingController();
  TextEditingController confirmDateController = TextEditingController();
  TextEditingController anniversaryDateController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pincodeController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController(text: 'Select Blood Group');
  TextEditingController dobController = TextEditingController();
  TextEditingController localityController = TextEditingController(text:'Select City'); /// select city controller
  TextEditingController cityController = TextEditingController(text:'Select City'); /// select city controller
  TextEditingController countryController = TextEditingController(text:'India'); /// select Country controller
  TextEditingController stateController = TextEditingController(text:'Select State'); /// select State controller
  TextEditingController aadharController = TextEditingController();
  TextEditingController nationalityCon = TextEditingController(text: 'Indian');
  TextEditingController houseTypeCon = TextEditingController(text: 'Select Type');
  TextEditingController filterTextController = TextEditingController();
  TextEditingController qualificationController = TextEditingController();
  TextEditingController companynameController = TextEditingController();
  String filterText = "";
  String marriedController = "Select Status";
  String GenderController = "Select Gender";
  String prefixController = "Select Prefix";
  File? profileImage;
  var uploadedImage;
  var uploadedImage1;
  String? selectedImg;
  String currentTab = 'View';
  final Formkey=GlobalKey<FormState>();
  final Formkey2=GlobalKey<FormState>();
  bool isCropped = true;
  bool isLoading = false;

   DateTime dob= DateTime.now();

  var imageFile;
  ///select the city functions----------------------
  List <String> _cities = [
    'Select City',
  ];

  Blob? croppedImageFile;
  Blob? unCroppedImageFile;

  ImagePicker picker = ImagePicker();

  bool profileImageValidator = false;

  selectImage() async {

    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) async {
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

    // final pickedImage =
    // await ImagePicker().pickImage(source: ImageSource.gallery);
    //
    // if (pickedImage != null) {
    //   setState(() {
    //     imageFile = io.File(pickedImage.path);
    //   });
    // }
    //
    // cropImage();
    //
    // list = await pickedImage!.readAsBytes();
    // print(list);
    // final blob = Blob([list]);
    // unCroppedImageFile = blob;
    // FileReader reader = FileReader();
    // reader.readAsDataUrl(blob);
    // reader.onLoadEnd.listen((event) {
    //   setState(() {
    //     uploadedImage1 = reader.result;
    //   });
    // });

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

  uploadImg() async {
    var snapshot = await fs
        .ref()
        .child('dailyupdates')
        .child("${uploadedImage1.name}")
        .putBlob(unCroppedImageFile);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    print(downloadUrl);
  }


  cropImage() async {

    CroppedFile? croppedFile = await ImageCropper().cropImage(
      cropStyle: CropStyle.rectangle,
      sourcePath: imageFile!.path,// imageFile.path,
      aspectRatioPresets: [
        CropAspectRatioPreset.square,
        CropAspectRatioPreset.ratio3x2,
        CropAspectRatioPreset.original,
        CropAspectRatioPreset.ratio4x3,
        CropAspectRatioPreset.ratio16x9,
      ],
      uiSettings: [
        WebUiSettings(
          context: context,
          presentStyle: CropperPresentStyle.dialog,
          enableExif: true,
          customDialogBuilder: (cropper, crop, rotate) {
            return Dialog(
              child: Builder(
                builder: (context) {
                  return Container(
                    height: 300,
                    width: 400,
                    child: Column(
                        children: [
                          Container(
                            height: 200,
                            width: 400,
                              child: cropper,
                          ),
                          TextButton(
                            onPressed: () async {
                              final result = await crop();
                              Navigator.of(context).pop(result);
                            },
                            child: Text('Crop'),
                          )
                        ]
                    ),
                  );
                },
              ),
            );
          },

        ),
      ],
    );

    list = await croppedFile!.readAsBytes();
    final blob = Blob([list]);
    croppedImageFile = blob;
      FileReader reader = FileReader();
      reader.readAsDataUrl(blob);
      reader.onLoadEnd.listen((event) {
        setState(() {
          uploadedImage = reader.result;
          selectedImg = null;
        });
      });
  }


  downloadTemplateExcel() async {
    final wb.Workbook workbook = wb.Workbook();
    final wb.Worksheet sheet = workbook.worksheets[0];
    sheet.getRangeByName("A1").setText("No.");
    sheet.getRangeByName("B1").setText("Firstname");
    sheet.getRangeByName("C1").setText("Lastname");
    sheet.getRangeByName("D1").setText("Phone");
    sheet.getRangeByName("E1").setText("Email");
    sheet.getRangeByName("F1").setText("Profession");
    sheet.getRangeByName("G1").setText("Baptism Date");
    sheet.getRangeByName("H1").setText("Marital Status");
    sheet.getRangeByName("I1").setText("Gender");
    sheet.getRangeByName("J1").setText("Blood Group");
    sheet.getRangeByName("K1").setText("Date of birth");
    sheet.getRangeByName("L1").setText("Pin code");
    sheet.getRangeByName("M1").setText("Address");
    sheet.getRangeByName("N1").setText("About");
    sheet.getRangeByName("O1").setText("Annivarsary Date");
    sheet.getRangeByName("P1").setText("Aadhaar Number");
    sheet.getRangeByName("Q1").setText("Qualification");
    sheet.getRangeByName("R1").setText("Locality");
    sheet.getRangeByName("S1").setText("Nationality");
    sheet.getRangeByName("T1").setText("House Type");

    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    AnchorElement(
        href:
            'data:application/octet-stream;charset=utf-16le;base64,${base64.encode(bytes)}')
      ..setAttribute('download', 'UserTemplate.xlsx')
      ..click();
  }

  clearTextControllers(){
    setState(() {
      firstNameController.clear();
      middleNameController.clear();
      lastNameController.clear();
      phoneController.clear();
      emailController.clear();
      professionController.clear();
      baptizeDateController.clear();
      anniversaryDateController.clear();
      aboutController.clear();
      addressController.clear();
      pincodeController.clear();
      qualificationController.clear();
      bloodGroupController.text = 'Select Blood Group';
      dobController.clear();
      localityController.clear();
      aadharController.clear();
      filterTextController.clear();
      filterText = "";
      marriedController = "Select Status";
      GenderController = "Select Gender";
      houseTypeCon.text = "Select Type";
      prefixController = "Select Prefix";
      nationalityCon.text = "Indian";
      profileImage = null;
      uploadedImage = null;
      selectedImg = null;
      isLoading = false;
    });
  }

  bool isEmail(String input) => EmailValidator.validate(input);
  final _key = GlobalKey<FormFieldState>();
  final _keyAlterEmail = GlobalKey<FormFieldState>();
  final _keyLocality = GlobalKey<FormFieldState>();
  final _keyFirstname = GlobalKey<FormFieldState>();
  final _keyLastname = GlobalKey<FormFieldState>();
  final _keyPhone = GlobalKey<FormFieldState>();
  final _keyDob = GlobalKey<FormFieldState>();
  final _keyAadhar = GlobalKey<FormFieldState>();
  final _keyPincode = GlobalKey<FormFieldState>();
  //bool profileImageValidator = false;

  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final phoneFocusNode = FocusNode();
  final emailFocusNode = FocusNode();
  final alterNativeemailFocusNode = FocusNode();
  final professionFocusNode = FocusNode();
  final aadhaarFocusNode = FocusNode();
  final pincodeFocusNode = FocusNode();
  final localityFocusNode = FocusNode();
  final aboutFocusNode = FocusNode();
  final addressFocusNode = FocusNode();

  List totalUsersList = [];

  int documentlength =0 ;
  int pagecount =0 ;
  int totalUsersCount =0 ;
  int userRemainder =0 ;
  int temp =1;
  int shift =0;
  List list = new List<int>.generate(10000, (i) => i + 1);

  List<cf.DocumentSnapshot> documentList = [];
  List<UserModelWithDocId> usersListForPrint = [];
  cf.QuerySnapshot? userDocument;

  @override
  void initState() {
    getCity("Tamil Nadu");
    getTotalUsers();
    doclength();
    super.initState();
  }

  getTotalUsers() async {
    var userDoc = await cf.FirebaseFirestore.instance.collection('Users').get();
    //setState(() {
    userDocument = userDoc;
    pagecount = (userDoc.docs.length + 10) ~/ 10;
    totalUsersCount = userDoc.docs.length;
    userRemainder = (userDoc.docs.length) % 10;
    //});
  }

  showPopUpMenu(users) async {
    double height=MediaQuery.of(context).size.height;
    double width=MediaQuery.of(context).size.width;
    await showMenu(
        context: context,
        color: Colors.white,
        position:  const RelativeRect.fromLTRB(300, 195, 500, 500),
        items: [
          PopupMenuItem<String>(
            value: 'Print',
            child: Row(
              children: [
                Icon(Icons.print),
                SizedBox(width: width/136.6),
                const Text('Print'),
              ],
            ),
            onTap: () {
              if(filterText != ""){
                generateUserPdf(PdfPageFormat.standard, users, false);
              }else{
                generateUserPdf(PdfPageFormat.standard, usersListForPrint, false);
              }
            },
          ),
          PopupMenuItem<String>(
            value: 'Copy',
            child: Row(
              children: [
                Icon(Icons.copy),
                SizedBox(width: width/136.6),
                const Text('Copy'),
              ],
            ),
            onTap: () {
                if(filterText != ""){
                   copyToClipBoard(users);
                }else{
                   copyToClipBoard(usersListForPrint);
                }
            },
          ),
          PopupMenuItem<String>(
            value: 'PDF',
            child: Row(
              children: [
                Icon(Icons.picture_as_pdf),
                SizedBox(width: width/136.6),
                const Text('PDF'),
              ],
            ),
            onTap: ()  async {
                if(filterText != ""){
                  var data = await generateUserPdf(PdfPageFormat.letter, users, true);
                  savePdfToFile(data);
                }else{
                  var data = await generateUserPdf(PdfPageFormat.letter, usersListForPrint, true);
                  savePdfToFile(data);
                }
            },
          ),
          PopupMenuItem<String>(
            value: 'CSV',
            child: Row(
              children: [
                Icon(Icons.file_copy_rounded),
                SizedBox(width: width/136.6),
                const Text('CSV'),
              ],
            ),
            onTap: () {
                if(filterText != ""){
                  convertToCsv(users);
                }else{
                  convertToCsv(usersListForPrint);
                }
            },
          ),
        ],
        elevation: 8.0,
        useRootNavigator: true);
  }
   doclength() async {

     final cf.QuerySnapshot result = await cf.FirebaseFirestore.instance.collection('Users').get();
     final List < cf.DocumentSnapshot > documents = result.docs;
     setState(() {
       documentlength = documents.length;
       pagecount= documentlength.remainder(10) == 0 ? (documentlength~/10) : ((documentlength~/10) + 1) as int;

     });
     print("pagecount");
     print(pagecount);
   }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: EdgeInsets.symmetric(
          vertical: height / 81.375, horizontal: width / 170.75),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: height / 81.375, horizontal: width / 170.75),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "USERS",
                    style: GoogleFonts.openSans(
                        fontSize: width / 52.53,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                  InkWell(
                      onTap:(){
                        if(currentTab.toUpperCase() == "VIEW") {
                          setState(() {
                            currentTab = "Add";
                          });
                          clearTextControllers();
                        }else{
                          setState(() {
                            currentTab = 'View';
                          });
                          clearTextControllers();
                        }

                      },
                      child: Container(
                        height:height/18.6,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black26,
                              offset: Offset(1, 2),
                              blurRadius: 3,
                            ),
                          ],
                        ),
                        child: Padding(
                          padding:
                           EdgeInsets.symmetric(horizontal:width/227.66),
                          child: Center(
                            child: KText(
                              text: currentTab.toUpperCase() == "VIEW" ? "Add User" : "View Users",
                              style: GoogleFonts.openSans(
                                fontSize:width/105.07,
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
                      height: size.height * 3.4,
                      width: width,
                      margin: EdgeInsets.symmetric(horizontal: width / 68.3, vertical: height / 32.55),
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
                      child: Form(
                        key:Formkey,
                        child: Column(
                                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                            children: [
                        SizedBox(
                          height: size.height * 0.1,
                          width: double.infinity,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: width / 68.3, vertical: height / 81.375),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                KText(
                                  text: "Add User",
                                  style: GoogleFonts.openSans(
                                    fontSize: width / 68.3,
                                    fontWeight: FontWeight.bold,
                                    color: Constants().subHeadingColor,
                                  ),
                                ),
                                Row(
                                  children: [
                                    PopupMenuButton(
                                      itemBuilder: (BuildContext context) =>
                                          <PopupMenuEntry>[
                                        PopupMenuItem(
                                          child: Text('Download Template'),
                                          onTap: () {
                                            downloadTemplateExcel();
                                          },
                                        )
                                      ],
                                      child: Icon(
                                        Icons.remove_red_eye,
                                        color: Constants().btnTextColor
                                      ),
                                    ),
                                    SizedBox(width: width / 136.6),
                                    InkWell(
                                      onTap: () async {
                                        FilePickerResult? pickedFile =
                                            await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['xlsx'],
                                          allowMultiple: false,
                                        );
                                        var bytes = pickedFile!.files.single.bytes;
                                        var excel = ex.Excel.decodeBytes(bytes!);
                                        Response response =
                                            await UserFireCrud.bulkUploadUser(excel);
                                        if (response.code == 200) {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: "Users created successfully!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                        } else {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: "Failed to Create Users!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                        }
                                      },
                                      child: Container(
                                        height: height / 18.6,
                                        width: width / 9.106,
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: width / 227.66),
                                          child: Center(
                                            child: KText(
                                              text: "Bulk Upload",
                                              style: GoogleFonts.openSans(
                                                fontSize: width / 105.076,
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
                            decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                  bottomLeft: Radius.circular(10),
                                  bottomRight: Radius.circular(10),
                                ),
                            ),
                            padding: EdgeInsets.symmetric(vertical: height / 43.4, horizontal: width / 91.06),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Center(
                                  child: Container(
                                    height: height / 3.829,
                                    width: width / 3.902,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Constants().primaryAppColor,
                                            width: width/683),
                                        image: uploadedImage != null
                                            ? isCropped ? DecorationImage(
                                                fit: BoxFit.contain,
                                                image: MemoryImage(
                                                  Uint8List.fromList(
                                                    base64Decode(uploadedImage!
                                                        .split(',')
                                                        .last),
                                                  ),
                                                )
                                              ) : DecorationImage(
                                            fit: BoxFit.cover,
                                            image: MemoryImage(
                                              Uint8List.fromList(
                                                base64Decode(uploadedImage!
                                                    .split(',')
                                                    .last),
                                              ),
                                            )
                                        )
                                            : null,
                                    ),
                                    child: uploadedImage == null
                                        ? Center(
                                            child: Icon(
                                              Icons.cloud_upload,
                                              size: width / 8.537,
                                              color: Colors.grey,
                                            ),
                                          )
                                        : null,
                                  ),
                                ),
                                SizedBox(height: height / 32.55),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: selectImage,
                                      child: Container(
                                        height: height / 18.6,
                                        width: size.width * 0.25,
                                        color: Constants().primaryAppColor,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.add_a_photo, color: Constants().btnTextColor),
                                            SizedBox(width: width / 136.6),
                                            KText(
                                              text: 'Select Profile Photo *',
                                              style: TextStyle(color: Constants().btnTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: width / 27.32),
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
                                        height: height / 18.6,
                                        width: size.width * 0.25,
                                        color: Constants().primaryAppColor,
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.crop, color: Constants().btnTextColor),
                                            SizedBox(width: width / 136.6),
                                            KText(
                                              text: 'Disable Crop',
                                              style: TextStyle(color: Constants().btnTextColor),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: height / 21.7),

                                ///Personal Details
                                KText(
                                  text: "Personal Details",
                                  style: GoogleFonts.openSans(
                                    color: Colors.black,
                                    fontSize: width / 80.076,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const Divider(),

                                ///prefix contriner and TextField
                                Padding(
                                  padding:  EdgeInsets.only(top:height/81.375),
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
                                              text: "Prefix",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                fontSize: width / 105.076,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            DropdownButton(
                                              value: prefixController,
                                              isExpanded: true,
                                              underline: Container(),
                                              icon: Icon(Icons.keyboard_arrow_down),
                                              items: [
                                                "Select Prefix",
                                                "MR.",
                                                "MISS.",
                                                "MRS."
                                              ].map((items) {
                                                return DropdownMenuItem(
                                                  value: items,
                                                  child: Text(items),
                                                );
                                              }).toList(),
                                              onChanged: (newValue) {
                                                setState(() {
                                                  prefixController = newValue!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: height / 21.7),

                                ///first and last and middle and Container
                                Row(
                                  children: [
                                    SizedBox(
                                      width: width / 4.553,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Firstname *",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width / 105.076,
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
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                            ],
                                            style: TextStyle(fontSize: width / 113.83),
                                            controller: firstNameController,
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
                                            text: "Middle Name",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width / 105.076,
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
                                            style: TextStyle(fontSize: width / 113.83),
                                            controller: middleNameController,
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
                                            text: "Lastname *",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width / 105.076,
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
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Field is required';
                                              }else{
                                                return null;
                                              }
                                            },
                                            onChanged: (val){
                                             // _keyLastname.currentState!.validate();
                                            },
                                            decoration: InputDecoration(
                                              counterText: "",
                                            ),
                                            maxLength: 40,
                                            inputFormatters: [
                                              FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                            ],
                                            style: TextStyle(fontSize: width / 113.83),
                                            controller: lastNameController,
                                          )
                                        ],
                                      ),
                                    ),

                                  ],
                                ),
                                SizedBox(height: height / 21.7),

                                ///Gender and Blood group and date of birth container
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
                                              text: "Gender *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                fontSize: width / 105.076,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            DropdownButton(
                                              value: GenderController,
                                              isExpanded: true,
                                              underline: Container(),
                                              icon: Icon(Icons.keyboard_arrow_down),
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
                                                  GenderController = newValue!;
                                                });
                                              },
                                            ),
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
                                              text: "Blood Group *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                fontSize: width / 105.076,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            SizedBox(height: height / 50.076),
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
                                                    bloodGroupController.text = newValue!;
                                                  });
                                                }
                                              },
                                            ),
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
                                              text: "Date of Birth *",
                                              style: GoogleFonts.openSans(
                                                color: Colors.black,
                                                fontSize: width / 105.076,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            TextFormField(
                                              readOnly: true,
                                              key: _keyDob,
                                              style: TextStyle(fontSize: width / 113.83),
                                              controller: dobController,
                                              validator: (val){
                                                if(val!.isEmpty){
                                                  return 'Field is required';
                                                }else{
                                                  return null;
                                                }
                                              },
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                await Constants().datePicker(context);
                                                // await DatePicker.showSimpleDatePicker(
                                                //   context,
                                                //   initialDate: DateTime.now(),
                                                //   firstDate: DateTime(1900),
                                                //   lastDate: DateTime.now(),
                                                //   dateFormat: "dd-MM-yyyy",
                                                //   locale: DateTimePickerLocale.en_us,
                                                //   looping: true,
                                                // );
                                                // await showDatePicker(
                                                //   context: context,
                                                //   initialDate: DateTime.now(),
                                                //   firstDate: DateTime(1900),
                                                //   lastDate: DateTime.now(),
                                                //   initialEntryMode: DatePickerEntryMode.calendar,
                                                //   initialDatePickerMode: DatePickerMode.year,
                                                // );
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    //dobController.text = formatter.format(pickedDate);
                                                    setAge(pickedDate);
                                                    dob=pickedDate;
                                                    // dobController.text = formatter.format(pickedDate);
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
                                              DateTime? pickedDate = await Constants().datePicker(context);

                                              // await showDatePicker(
                                              // context: context,
                                              // initialDate: DateTime.now(),
                                              // firstDate: DateTime(1900),
                                              // lastDate: DateTime.now());

                                              if (pickedDate != null) {
                                                if(pickedDate!.compareTo(dob) < 0){
                                                  print("DT1 is before DT2");
                                                  CoolAlert.show(
                                                      context: context,
                                                      type: CoolAlertType.info,
                                                      text: "Invalid Baptism Date",
                                                      title: "Please select Baptism Date correctly!",
                                                      width: size.width * 0.4,
                                                      backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                      showCancelBtn: true,
                                                      cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                      confirmBtnText: 'OK',
                                                      onConfirmBtnTap: () async {

                                                      },
                                                      onCancelBtnTap: () async {

                                                      }
                                                  );
                                                }
                                                else {
                                                  setState(() {
                                                    baptizeDateController.text =
                                                        formatter.format(
                                                            pickedDate);
                                                  });
                                                }
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
                                            text: "Confirmation Date*",
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
                                                if (pickedDate != null) {
                                                  if(pickedDate!.compareTo(dob) < 0){
                                                    print("DT1 is before DT2");
                                                    CoolAlert.show(
                                                        context: context,
                                                        type: CoolAlertType.info,
                                                        text: "Invalid Confirmation Date",
                                                        title: "Please select Confirmation Date correctly!",
                                                        width: size.width * 0.4,
                                                        backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                        showCancelBtn: true,
                                                        cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                        confirmBtnText: 'OK',
                                                        onConfirmBtnTap: () async {

                                                        },
                                                        onCancelBtnTap: () async {

                                                        }
                                                    );
                                                  }
                                                  else {
                                                    setState(() {
                                                      confirmDateController.text = formatter.format(pickedDate);
                                                    });
                                                  }
                                                }

                                              }
                                            },
                                            validator: (val){
                                              if(val!.isEmpty){
                                                return 'Filed must be not empty';
                                              
                                              }else{
                                                return null;
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
                                            text: "Aadhaar Number*",
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
                                                return 'Filed must be not empty';
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
                                            controller: aadharController,
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
                                              value: marriedController,
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
                                                  marriedController = newValue!;
                                                });
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(width: width / 68.3),
                                      Visibility(
                                        visible: marriedController.toUpperCase() == "MARRIED",
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
                                                controller: anniversaryDateController,
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
                                                      anniversaryDateController.text = formatter.format(pickedDate);
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
                                SizedBox(height: height / 21.7),



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
                                              focusNode: professionFocusNode,
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
                                              controller: professionController,
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
                                            /*  inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z .]")),
                                              ],*/
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
                                                FocusScope.of(context).requestFocus(emailFocusNode);
                                              },
                                              onFieldSubmitted: (val){
                                                FocusScope.of(context).requestFocus(emailFocusNode);
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
                                              onEditingComplete: (){
                                                // _keyAlterEmail.currentState!.validate();
                                                FocusScope.of(context).requestFocus(professionFocusNode);
                                              },
                                              onFieldSubmitted: (val){
                                                FocusScope.of(context).requestFocus(professionFocusNode);
                                              },
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
                                              onEditingComplete: (){
                                                _key.currentState!.validate();
                                                FocusScope.of(context).requestFocus(professionFocusNode);
                                              },
                                              onFieldSubmitted: (val){
                                                FocusScope.of(context).requestFocus(professionFocusNode);
                                              },
                                              validator: (value) {
                                                if(value!.isNotEmpty) {
                                                  if (!isEmail(value!)) {
                                                    return 'Please enter a valid email.';
                                                  }
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
                                                    key: _keyAlterEmail,
                                                    focusNode: alterNativeemailFocusNode,
                                                    autofocus: true,
                                                    onEditingComplete: (){
                                                      // _keyAlterEmail.currentState!.validate();
                                                      FocusScope.of(context).requestFocus(professionFocusNode);
                                                    },
                                                    onFieldSubmitted: (val){
                                                      FocusScope.of(context).requestFocus(professionFocusNode);
                                                    },
                                                    validator: (value) {
                                                      if(value!.isNotEmpty) {
                                                        if (!isEmail(value!)) {
                                                          return 'Please enter a valid email.';
                                                        }
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
                                              "Owned",
                                              "Rented",
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
                                      text: "Residential Address *",
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
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Filed must be not empty';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  style: TextStyle(
                                                      fontSize: width / 113.83),
                                                  controller: addressController,
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
                                SizedBox(height: height / 21.7),

                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        print("Add Called");
                                        print(Formkey.currentState!.validate());
                                        if(!isLoading) {
                                          if (Formkey.currentState!.validate()) {
                                            print("Fields are fine");
                                            if (profileImage == null) {
                                              setState(() {
                                                profileImageValidator = true;
                                              });
                                            }
                                            else {
                                              setState(() {
                                                profileImageValidator = false;
                                              });
                                              print("profile img fine");
                                            }
                                            if (
                                            profileImage != null &&
                                                bloodGroupController.text !=
                                                    "Select Blood Group" &&
                                                firstNameController.text !=
                                                    "" &&
                                                lastNameController.text != "" &&
                                                dobController.text != "" &&
                                                validateEmail(
                                                    emailController.text
                                                        .isNotEmpty) &&
                                                _keyPhone.currentState!
                                                    .validate() &&
                                                validateAadhaar(
                                                    aadharController.text
                                                        .isNotEmpty) &&
                                                _keyPincode.currentState!
                                                    .validate() &&
                                                GenderController !=
                                                    "Select Gender" &&
                                                marriedController !=
                                                    "Select Status"
                                            )
                                            {
                                              setState(() {
                                                isLoading = true;
                                              });
                                              Response response = await UserFireCrud
                                                  .addUser(
                                                image: profileImage,
                                                prefix: prefixController,
                                                firstName: firstNameController
                                                    .text,
                                                middleName: middleNameController
                                                    .text,
                                                lastName: lastNameController
                                                    .text,
                                                gender: GenderController,
                                                bloodGroup: bloodGroupController
                                                    .text,
                                                dob: dobController.text,
                                                baptizeDate: baptizeDateController
                                                    .text,
                                                condate: confirmDateController
                                                    .text,
                                                //conformationdate
                                                aadharNo: aadharController.text,
                                                maritialStatus: marriedController,
                                                anniversaryDate: anniversaryDateController
                                                    .text,
                                                profession: professionController
                                                    .text,
                                                qualification: qualificationController
                                                    .text,
                                                companyname: companynameController
                                                    .text,
                                                //companyname
                                                phone: phoneController.text,
                                                alphone: alphoneController.text,
                                                //alphone
                                                email: emailController.text,
                                                alterNativeemail: alterNativeemailController
                                                    .text,
                                                state: stateController.text,
                                                locality: cityController.text,
                                                //city
                                                nationality: nationalityCon
                                                    .text,
                                                //contry
                                                contry: countryController.text,
                                                //contry
                                                pincode: pincodeController.text,
                                                houseType: houseTypeCon.text,
                                                resaddress: addressController
                                                    .text,
                                                //res adress
                                                preaddress: aboutController
                                                    .text,
                                                //preemenet adress
                                                about: aboutController
                                                    .text, //no needed
                                              );
                                              if (response.code == 200) {
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.success,
                                                    text: "User created successfully!",
                                                    width: size.width * 0.4,
                                                    backgroundColor: Constants()
                                                        .primaryAppColor
                                                        .withOpacity(0.8));
                                                clearTextControllers();
                                                setState(() {
                                                  currentTab = 'VIEW';
                                                });
                                              }
                                              else {
                                                await CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.error,
                                                    text: "Failed to Create User!",
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
                                        }
                                      },
                                      child: Container(
                                        height: height / 16.6,
                                        width: width*0.1,
                                        decoration: BoxDecoration(
                                          color: Constants().primaryAppColor,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: width / 190.66),
                                          child: Center(
                                            child: KText(
                                              text: "ADD NOW",
                                              style: GoogleFonts.openSans(
                                                color: Constants().btnTextColor,
                                                fontSize:width/136.6,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                     SizedBox(width: width/136.6),
                                    InkWell(
                                      onTap: (){
                                        setState(() {
                                          currentTab = 'View';
                                        });
                                        clearTextControllers();
                                      },
                                      child: Container(
                                        height: height / 16.6,
                                        width: width*0.1,
                                        decoration: BoxDecoration(
                                          color: Constants().primaryAppColor,
                                          borderRadius: BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black26,
                                              offset: Offset(1, 2),
                                              blurRadius: 3,
                                            ),
                                          ],
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(horizontal: width / 190.66),
                                          child: Center(
                                            child: KText(
                                              text: "Cancel",
                                              style: GoogleFonts.openSans(
                                                color: Constants().btnTextColor,
                                                fontSize:width/136.6,
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
                    stream: documentList.isNotEmpty
                        ? cf.FirebaseFirestore.instance.collection('Users').orderBy("timestamp", descending: true).snapshots()
                        : cf.FirebaseFirestore.instance.collection('Users').orderBy("timestamp", descending: true).snapshots(),
                    builder: (ctx, snapshot) {
                      if (snapshot.hasError) {
                        return Container();
                      } else if (snapshot.hasData) {
                        List<UserModelWithDocId> users = [];
                        usersListForPrint.clear();
                        //documentList.clear();
                        if(filterText != ""){
                          for (var element in userDocument!.docs) {
                            if(element.get("profession")!.toLowerCase().startsWith(filterText.toLowerCase())||
                                element.get("firstName")!.toLowerCase().startsWith(filterText.toLowerCase())||
                                      element.get("pincode")!.toLowerCase().startsWith(filterText.toLowerCase())||
                                  (element.get("firstName")!+element.get("lastName")!).toString().trim().toLowerCase().startsWith(filterText.toLowerCase()) ||
                                  element.get("lastName")!.toLowerCase().startsWith(filterText.toLowerCase())||
                                  element.get("phone")!.toLowerCase().startsWith(filterText.toLowerCase())){
                              users.add(UserModelWithDocId(element.id, UserModel.fromJson(element.data() as Map<String, dynamic>)));
                              usersListForPrint.add(UserModelWithDocId(element.id, UserModel.fromJson(element.data() as Map<String, dynamic>)));
                            }
                          }
                        }else{
                          if(userDocument != null){
                            for (var element in userDocument!.docs) {
                              usersListForPrint.add(UserModelWithDocId(element.id, UserModel.fromJson(element.data() as Map<String, dynamic>)));
                            }
                          }
                          for (var element in snapshot.data!.docs) {
                            users.add(UserModelWithDocId(element.id, UserModel.fromJson(element.data())));
                          }
                        }
                        // for (var element in snapshot.data!.docs) {
                        //   if(filterText != ""){
                        //     if(element.get("profession")!.toLowerCase().startsWith(filterText.toLowerCase())||
                        //         element.get("firstName")!.toLowerCase().startsWith(filterText.toLowerCase())||
                        //         element.get("pincode")!.toLowerCase().startsWith(filterText.toLowerCase())||
                        //         (element.get("firstName")!+element.get("lastName")!).toString().trim().toLowerCase().startsWith(filterText.toLowerCase()) ||
                        //         element.get("lastName")!.toLowerCase().startsWith(filterText.toLowerCase())||
                        //         element.get("phone")!.toLowerCase().startsWith(filterText.toLowerCase())){
                        //       users.add(
                        //         UserModelWithDocId(element.id, UserModel.fromJson(element.data()))
                        //       );
                        //     }
                        //   }else{
                        //     users.add(UserModelWithDocId(element.id, UserModel.fromJson(element.data())));
                        //   }
                        // }
                        return Container(
                          width: width,
                          margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
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
                                  padding:  EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      KText(
                                        text: "All Users ($totalUsersCount)",
                                        style: GoogleFonts.openSans(
                                          fontSize: width / 68.3,
                                          fontWeight: FontWeight.bold,
                                          color: Constants().subHeadingColor,
                                        ),
                                      ),
                                      Row(
                                        children: [
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
                                                  controller: filterTextController,
                                                  onChanged: (val) {
                                                    setState(() {
                                                      filterText = val;
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
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                height: size.height * 0.73,
                                width: double.infinity,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10),
                                    ),
                                ),
                                padding: EdgeInsets.symmetric(horizontal:width/170.75, vertical: height/65.1),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Row(
                                    //   children: [
                                    //     InkWell(
                                    //       onTap: () {
                                    //         if(filterText != ""){
                                    //           generateUserPdf(PdfPageFormat.standard, users, false);
                                    //         }else{
                                    //           generateUserPdf(PdfPageFormat.standard, usersListForPrint, false);
                                    //         }
                                    //       },
                                    //       child: Container(
                                    //         height: height / 18.6,
                                    //         decoration: BoxDecoration(
                                    //           color: Color(0xfffe5722),
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               color: Colors.black26,
                                    //               offset: Offset(1, 2),
                                    //               blurRadius: 3,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: Padding(
                                    //           padding: EdgeInsets.symmetric(
                                    //               horizontal: width / 227.66),
                                    //           child: Center(
                                    //             child: Row(
                                    //               children: [
                                    //                 Icon(Icons.print,
                                    //                     color: Colors.white),
                                    //                 KText(
                                    //                   text: "PRINT",
                                    //                   style:
                                    //                       GoogleFonts.openSans(
                                    //                     color: Colors.white,
                                    //                     fontSize:
                                    //                         width / 105.076,
                                    //                     fontWeight:
                                    //                         FontWeight.bold,
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     SizedBox(width: width / 136.6),
                                    //     InkWell(
                                    //       onTap: () {
                                    //         if(filterText != ""){
                                    //           copyToClipBoard(users);
                                    //         }else{
                                    //           copyToClipBoard(usersListForPrint);
                                    //         }
                                    //       },
                                    //       child: Container(
                                    //         height: height / 18.6,
                                    //         decoration: BoxDecoration(
                                    //           color: Color(0xffff9700),
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               color: Colors.black26,
                                    //               offset: Offset(1, 2),
                                    //               blurRadius: 3,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: Padding(
                                    //           padding: EdgeInsets.symmetric(
                                    //               horizontal: width / 227.66),
                                    //           child: Center(
                                    //             child: Row(
                                    //               children: [
                                    //                 Icon(Icons.copy,
                                    //                     color: Colors.white),
                                    //                 KText(
                                    //                   text: "COPY",
                                    //                   style:
                                    //                       GoogleFonts.openSans(
                                    //                     color: Colors.white,
                                    //                     fontSize:
                                    //                         width / 105.076,
                                    //                     fontWeight:
                                    //                         FontWeight.bold,
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     SizedBox(width: width / 136.6),
                                    //     InkWell(
                                    //       onTap: () async {
                                    //         if(filterText != ""){
                                    //           var data = await generateUserPdf(PdfPageFormat.letter, users, true);
                                    //           savePdfToFile(data);
                                    //         }else{
                                    //           var data = await generateUserPdf(PdfPageFormat.letter, usersListForPrint, true);
                                    //           savePdfToFile(data);
                                    //         }
                                    //       },
                                    //       child: Container(
                                    //         height: height / 18.6,
                                    //         decoration: BoxDecoration(
                                    //           color: Color(0xff9b28b0),
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               color: Colors.black26,
                                    //               offset: Offset(1, 2),
                                    //               blurRadius: 3,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: Padding(
                                    //           padding: EdgeInsets.symmetric(
                                    //               horizontal: width / 227.66),
                                    //           child: Center(
                                    //             child: Row(
                                    //               children: [
                                    //                 Icon(Icons.picture_as_pdf,
                                    //                     color: Colors.white),
                                    //                 KText(
                                    //                   text: "PDF",
                                    //                   style:
                                    //                       GoogleFonts.openSans(
                                    //                     color: Colors.white,
                                    //                     fontSize:
                                    //                         width / 105.076,
                                    //                     fontWeight:
                                    //                         FontWeight.bold,
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //     SizedBox(width: width / 136.6),
                                    //     InkWell(
                                    //       onTap: () {
                                    //         if(filterText != ""){
                                    //           convertToCsv(users);
                                    //         }else{
                                    //           convertToCsv(usersListForPrint);
                                    //         }
                                    //       },
                                    //       child: Container(
                                    //         height: height / 18.6,
                                    //         decoration: BoxDecoration(
                                    //           color: Color(0xff019688),
                                    //           boxShadow: [
                                    //             BoxShadow(
                                    //               color: Colors.black26,
                                    //               offset: Offset(1, 2),
                                    //               blurRadius: 3,
                                    //             ),
                                    //           ],
                                    //         ),
                                    //         child: Padding(
                                    //           padding: EdgeInsets.symmetric(
                                    //               horizontal: width / 227.66),
                                    //           child: Center(
                                    //             child: Row(
                                    //               children: [
                                    //                 Icon(
                                    //                     Icons.file_copy_rounded,
                                    //                     color: Colors.white),
                                    //                 KText(
                                    //                   text: "CSV",
                                    //                   style:
                                    //                       GoogleFonts.openSans(
                                    //                     color: Colors.white,
                                    //                     fontSize:
                                    //                         width / 105.076,
                                    //                     fontWeight:
                                    //                         FontWeight.bold,
                                    //                   ),
                                    //                 ),
                                    //               ],
                                    //             ),
                                    //           ),
                                    //         ),
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    InkWell(
                                        onTap:(){
                                          showPopUpMenu(users);
                                        },
                                        child: Container(
                                          height:height/18.6,
                                          width: 150,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(8),
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.black26,
                                                offset: Offset(1, 2),
                                                blurRadius: 3,
                                              ),
                                            ],
                                          ),
                                          child: Padding(
                                            padding:
                                            EdgeInsets.symmetric(horizontal:width/227.66),
                                            child: Center(
                                              child: KText(
                                                text: "Export Data",
                                                style: GoogleFonts.openSans(
                                                  fontSize:width/105.07,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                    ),
                                    SizedBox(height: height / 21.7),
                                    SizedBox(
                                      child: Padding(
                                        padding: EdgeInsets.symmetric( horizontal: width / 273.2,
                                            vertical: height / 130.2),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: width / 17.075,
                                              child: KText(
                                                text: "No.",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 13.660,
                                              child: KText(
                                                text: "Photo",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 8.035,
                                              child: KText(
                                                text: "Name",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 9.106,
                                              child: KText(
                                                text: "Status",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 8.035,
                                              child: KText(
                                                text: "Phone",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 9.106,
                                              child: KText(
                                                text: "Pin Code",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width / 7.588,
                                              child: KText(
                                                text: "Actions",
                                                style: GoogleFonts.poppins(
                                                  fontSize: width / 105.076,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: filterText != ""
                                          ? ListView.builder(
                                        itemCount: pagecount == temp ? users.length.remainder(10) == 0 ? 10 : users.length.remainder(10) : 10,

                                        itemBuilder: (ctx, i) {
                                          return Container(
                                            height: height / 10.55,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
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
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width / 273.2,
                                                  vertical: height / 130.2),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment
                                                    .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: width / 17.075,
                                                    child: KText(
                                                      text: ((i + 1)+((temp-1)*10)).toString(),
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize:
                                                        width / 105.076,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 13.660,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .start,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage: NetworkImage(users[(temp*10)-10+i].user.imgUrl!),
                                                          child: Visibility(
                                                            visible: users[(temp*10)-10+i].user.imgUrl == "",
                                                            // child: Image.asset(
                                                            //   users[(temp*10)-10+i].user.gender!.toLowerCase() == "male" ? "assets/mavatar.png" : "assets/favatar.png",
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
                                                    width: width / 8.035,
                                                    child: KText(
                                                      text:
                                                      "${users[(temp*10)-10+i].user.firstName.toLowerCase() != 'null' ? users[(temp*10)-10+i].user.firstName : ''} ${users[(temp*10)-10+i].user.lastName.toLowerCase() != 'null' ? users[(temp*10)-10+i].user.lastName : ''}",
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize:
                                                        width / 105.076,
                                                        fontWeight:
                                                        FontWeight.w600,
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
                                                          //value: users[(temp*10)-10+i].user.status!,
                                                          value: users[(temp*10)-10+i].user.status,
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
                                                                text: "${users[(temp*10)-10+i].user.firstName} ${users[(temp*10)-10+i].user.lastName}'s status will be $statsu",
                                                                title: "Update this Record?",
                                                                width: size.width * 0.4,
                                                                backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                                showCancelBtn: true,
                                                                cancelBtnText: 'Cancel',
                                                                cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                                onConfirmBtnTap: () async {
                                                                  await updateMemberStatus(users[(temp*10)-10+i].user.id, val);
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
                                                    width: width / 8.035,
                                                    child: KText(
                                                      text:  users[(temp*10)-10+i].user.phone.toLowerCase() != 'null' ? users[(temp*10)-10+i].user.phone! : "",
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize:
                                                        width / 105.076,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 9.106,
                                                    child: KText(
                                                      text: users[(temp*10)-10+i].user.pincode!,
                                                      style:
                                                      GoogleFonts.poppins(
                                                        fontSize:
                                                        width / 105.076,
                                                        fontWeight:
                                                        FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: width / 7.588,
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              viewPopup(users[(temp*10)-10+i].user);
                                                            },
                                                            child: Container(
                                                              height: height /
                                                                  26.04,
                                                              decoration:
                                                              BoxDecoration(
                                                                color: Color(
                                                                    0xff2baae4),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    offset:
                                                                    Offset(
                                                                        1,
                                                                        2),
                                                                    blurRadius:
                                                                    3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    width /
                                                                        227.66),
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
                                                                          size: width /
                                                                              91.066),
                                                                      KText(
                                                                        text:
                                                                        "View",
                                                                        style: GoogleFonts
                                                                            .openSans(
                                                                          color:
                                                                          Colors.white,
                                                                          fontSize:
                                                                          width / 136.6,
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: width /
                                                                  273.2),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                GenderController = users[(temp*10)-10+i].user.gender;
                                                                pincodeController.text = users[(temp*10)-10+i].user.pincode;
                                                                baptizeDateController.text = users[(temp*10)-10+i].user.baptizeDate;
                                                                bloodGroupController.text = users[(temp*10)-10+i].user.bloodGroup;
                                                                dobController.text = users[(temp*10)-10+i].user.dob;
                                                                qualificationController.text = users[(temp*10)-10+i].user.qualification;
                                                                emailController.text = users[(temp*10)-10+i].user.email;
                                                                firstNameController.text = users[(temp*10)-10+i].user.firstName;
                                                                aboutController.text = users[(temp*10)-10+i].user.preaddress;
                                                                addressController.text = users[(temp*10)-10+i].user.resaddress;
                                                                lastNameController.text = users[(temp*10)-10+i].user.lastName;
                                                                localityController.text = users[(temp*10)-10+i].user.locality;
                                                                stateController.text=users[(temp*10)-10+i].user.state;
                                                                countryController.text=users[(temp*10)-10+i].user.contry;
                                                                alterNativeemailController.text=users[(temp*10)-10+i].user.alterNativeemail;
                                                                phoneController.text = users[(temp*10)-10+i].user.phone;
                                                                professionController.text = users[(temp*10)-10+i].user.profession;
                                                                selectedImg = users[(temp*10)-10+i].user.imgUrl;
                                                                //uploadedImage = users[(temp*10)-10+i].user.imgUrl;
                                                                marriedController = users[(temp*10)-10+i].user.maritialStatus;
                                                                aadharController.text = users[(temp*10)-10+i].user.aadharNo;
                                                                anniversaryDateController.text = users[(temp*10)-10+i].user.anniversaryDate;
                                                                houseTypeCon.text = users[(temp*10)-10+i].user.houseType;
                                                                nationalityCon.text = users[(temp*10)-10+i].user.nationality;
                                                                prefixController = users[(temp*10)-10+i].user.prefix;
                                                                middleNameController.text = users[(temp*10)-10+i].user.middleName;
                                                                confirmDateController.text=users[(temp*10)-10+i].user.condate;
                                                                alphoneController.text=users[(temp*10)-10+i].user.alphone;



                                                              });
                                                              editPopUp(users[(temp*10)-10+i].user,users[(temp*10)-10+i].userDocId, size);
                                                            },
                                                            child: Container(
                                                              height: height /
                                                                  26.04,
                                                              decoration:
                                                              BoxDecoration(
                                                                color: Color(
                                                                    0xffff9700),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    offset:
                                                                    Offset(
                                                                        1,
                                                                        2),
                                                                    blurRadius:
                                                                    3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    width /
                                                                        227.66),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceAround,
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .add,
                                                                          color: Colors
                                                                              .white,
                                                                          size: width /
                                                                              91.066),
                                                                      KText(
                                                                        text:
                                                                        "Edit",
                                                                        style: GoogleFonts
                                                                            .openSans(
                                                                          color:
                                                                          Colors.white,
                                                                          fontSize:
                                                                          width / 136.6,
                                                                          fontWeight:
                                                                          FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: width /
                                                                  273.2),
                                                          InkWell(
                                                            onTap: () {
                                                              CoolAlert.show(
                                                                  context:
                                                                  context,
                                                                  type:
                                                                  CoolAlertType
                                                                      .info,
                                                                  text:
                                                                  "${users[(temp*10)-10+i].user.firstName} ${users[(temp*10)-10+i].user.lastName} will be deleted",
                                                                  title:
                                                                  "Delete this Record?",
                                                                  width: size
                                                                      .width *
                                                                      0.4,
                                                                  backgroundColor: Constants()
                                                                      .primaryAppColor
                                                                      .withOpacity(
                                                                      0.8),
                                                                  showCancelBtn:
                                                                  true,
                                                                  cancelBtnText:
                                                                  'Cancel',
                                                                  cancelBtnTextStyle:
                                                                  TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                  onConfirmBtnTap:
                                                                      () async {
                                                                    Response
                                                                    res = await UserFireCrud.deleteRecord(id: users[(temp*10)-10+i].userDocId);
                                                                  });
                                                            },
                                                            child: Container(
                                                              height: height /
                                                                  26.04,
                                                              decoration:
                                                              BoxDecoration(
                                                                color: Color(
                                                                    0xfff44236),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    offset:
                                                                    Offset(
                                                                        1,
                                                                        2),
                                                                    blurRadius:
                                                                    3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                    horizontal:
                                                                    width /
                                                                        227.66),
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
                                                                          size: width /
                                                                              91.066),
                                                                      KText(
                                                                        text:
                                                                        "Delete",
                                                                        style: GoogleFonts
                                                                            .openSans(
                                                                          color:
                                                                          Colors.white,
                                                                          fontSize:
                                                                          width / 136.6,
                                                                          fontWeight:
                                                                          FontWeight.bold,
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
                                        itemCount: pagecount == temp ? users.length.remainder(10) == 0 ? 10 : users.length.remainder(10) : 10,
                                        itemBuilder: (ctx, i) {
                                          return Container(
                                            height: height / 10.55,
                                            width: double.infinity,
                                            decoration: BoxDecoration(
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
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: width / 273.2,
                                                  vertical: height / 130.2),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  SizedBox(
                                                    width: width / 17.075,
                                                    child: KText(
                                                      text: ((i + 1)+((temp-1)*10)).toString(),
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight: FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 13.660,
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .start,
                                                      children: [
                                                        CircleAvatar(
                                                          backgroundImage: NetworkImage(users[(temp*10)-10+i].user.imgUrl!),
                                                          child: Visibility(
                                                            visible: users[(temp*10)-10+i].user.imgUrl == "",
                                                              // child: Image.asset(
                                                              //   users[(temp*10)-10+i].user.gender!.toLowerCase() == "male" ? "assets/mavatar.png" : "assets/favatar.png",
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
                                                    width: width / 8.035,
                                                    child: KText(
                                                      text:
                                                          "${users[(temp*10)-10+i].user.firstName.toLowerCase() != 'null' ? users[(temp*10)-10+i].user.firstName : ''} ${users[(temp*10)-10+i].user.lastName.toLowerCase() != 'null' ? users[(temp*10)-10+i].user.lastName : ''}",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.w600,
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
                                                          //value: users[(temp*10)-10+i].user.status!,
                                                          value: users[(temp*10)-10+i].user.status,
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
                                                                text: "${users[(temp*10)-10+i].user.firstName} ${users[(temp*10)-10+i].user.lastName}'s status will be $statsu",
                                                                title: "Update this Record?",
                                                                width: size.width * 0.4,
                                                                backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                                showCancelBtn: true,
                                                                cancelBtnText: 'Cancel',
                                                                cancelBtnTextStyle:  TextStyle(color: Colors.black),
                                                                onConfirmBtnTap: () async {
                                                                  await updateMemberStatus(users[(temp*10)-10+i].user.id, val);
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
                                                    width: width / 8.035,
                                                    child: KText(
                                                      text:  users[(temp*10)-10+i].user.phone.toLowerCase() != 'null' ? users[(temp*10)-10+i].user.phone! : "",
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: width / 9.106,
                                                    child: KText(
                                                      text: users[(temp*10)-10+i].user.pincode!,
                                                      style:
                                                          GoogleFonts.poppins(
                                                        fontSize:
                                                            width / 105.076,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      width: width / 7.588,
                                                      child: Row(
                                                        children: [
                                                          InkWell(
                                                            onTap: () {
                                                              viewPopup(users[(temp*10)-10+i].user);
                                                            },
                                                            child: Container(
                                                              height: height /
                                                                  26.04,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xff2baae4),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            2),
                                                                    blurRadius:
                                                                        3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            width /
                                                                                227.66),
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
                                                                          size: width /
                                                                              91.066),
                                                                      KText(
                                                                        text:
                                                                            "View",
                                                                        style: GoogleFonts
                                                                            .openSans(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              width / 136.6,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: width /
                                                                  273.2),
                                                          InkWell(
                                                            onTap: () {
                                                              setState(() {
                                                                GenderController = users[(temp*10)-10+i].user.gender;
                                                                pincodeController.text = users[(temp*10)-10+i].user.pincode;
                                                                baptizeDateController.text = users[(temp*10)-10+i].user.baptizeDate;
                                                                bloodGroupController.text = users[(temp*10)-10+i].user.bloodGroup;
                                                                dobController.text = users[(temp*10)-10+i].user.dob;
                                                                emailController.text = users[(temp*10)-10+i].user.email;
                                                                firstNameController.text = users[(temp*10)-10+i].user.firstName;
                                                                aboutController.text = users[(temp*10)-10+i].user.preaddress;
                                                                addressController.text = users[(temp*10)-10+i].user.resaddress;
                                                                lastNameController.text = users[(temp*10)-10+i].user.lastName;
                                                                localityController.text = users[(temp*10)-10+i].user.locality;
                                                                phoneController.text = users[(temp*10)-10+i].user.phone;
                                                                professionController.text = users[(temp*10)-10+i].user.profession;
                                                                selectedImg = users[(temp*10)-10+i].user.imgUrl;
                                                                // uploadedImage = users[(temp*10)-10+i].user.imgUrl;
                                                                marriedController = users[(temp*10)-10+i].user.maritialStatus;
                                                                aadharController.text = users[(temp*10)-10+i].user.aadharNo;
                                                                anniversaryDateController.text = users[(temp*10)-10+i].user.anniversaryDate;
                                                                houseTypeCon.text = users[(temp*10)-10+i].user.houseType;
                                                                nationalityCon.text = users[(temp*10)-10+i].user.nationality;
                                                                qualificationController.text = users[(temp*10)-10+i].user.qualification;
                                                                prefixController = users[(temp*10)-10+i].user.prefix;
                                                                middleNameController.text = users[(temp*10)-10+i].user.middleName;
                                                              });
                                                              editPopUp(users[(temp*10)-10+i].user,users[(temp*10)-10+i].userDocId, size);
                                                            },
                                                            child: Container(
                                                              height: height /
                                                                  26.04,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xffff9700),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            2),
                                                                    blurRadius:
                                                                        3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            width /
                                                                                227.66),
                                                                child: Center(
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      Icon(
                                                                          Icons
                                                                              .add,
                                                                          color: Colors
                                                                              .white,
                                                                          size: width /
                                                                              91.066),
                                                                      KText(
                                                                        text:
                                                                            "Edit",
                                                                        style: GoogleFonts
                                                                            .openSans(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              width / 136.6,
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(
                                                              width: width /
                                                                  273.2),
                                                          InkWell(
                                                            onTap: () {
                                                              CoolAlert.show(
                                                                  context:
                                                                      context,
                                                                  type:
                                                                      CoolAlertType
                                                                          .info,
                                                                  text:
                                                                      "${users[(temp*10)-10+i].user.firstName} ${users[(temp*10)-10+i].user.lastName} will be deleted",
                                                                  title:
                                                                      "Delete this Record?",
                                                                  width: size
                                                                          .width *
                                                                      0.4,
                                                                  backgroundColor: Constants()
                                                                      .primaryAppColor
                                                                      .withOpacity(
                                                                          0.8),
                                                                  showCancelBtn:
                                                                      true,
                                                                  cancelBtnText:
                                                                      'Cancel',
                                                                  cancelBtnTextStyle:
                                                                      TextStyle(
                                                                          color: Colors
                                                                              .black),
                                                                  onConfirmBtnTap:
                                                                      () async {
                                                                    Response
                                                                        res = await UserFireCrud.deleteRecord(id: users[(temp*10)-10+i].userDocId);
                                                                  });
                                                            },
                                                            child: Container(
                                                              height: height /
                                                                  26.04,
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Color(
                                                                    0xfff44236),
                                                                boxShadow: [
                                                                  BoxShadow(
                                                                    color: Colors
                                                                        .black26,
                                                                    offset:
                                                                        Offset(
                                                                            1,
                                                                            2),
                                                                    blurRadius:
                                                                        3,
                                                                  ),
                                                                ],
                                                              ),
                                                              child: Padding(
                                                                padding: EdgeInsets
                                                                    .symmetric(
                                                                        horizontal:
                                                                            width /
                                                                                227.66),
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
                                                                          size: width /
                                                                              91.066),
                                                                      KText(
                                                                        text:
                                                                            "Delete",
                                                                        style: GoogleFonts
                                                                            .openSans(
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              width / 136.6,
                                                                          fontWeight:
                                                                              FontWeight.bold,
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
                                    //                       color: temp.toString() == list[index + shift].toString() ?  Constants().primaryAppColor : Colors.transparent,
                                    //                       borderRadius: BorderRadius.circular(30),
                                    //                       border: Border.all(color: Constants().primaryAppColor)
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
                                    //     Container(
                                    //       width: 30,
                                    //       height: 30,
                                    //       decoration: BoxDecoration(
                                    //           color:  Colors.transparent,
                                    //           borderRadius: BorderRadius.circular(30),
                                    //           border: Border.all(color: Constants().primaryAppColor)
                                    //       ),
                                    //       child: Center(
                                    //         child: Text(
                                    //           pagecount.toString(),
                                    //           style: TextStyle(
                                    //               color: Colors.black,
                                    //               fontSize: 12
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
                                   /* NumberPaginator(
                                      config: NumberPaginatorUIConfig(
                                        buttonSelectedBackgroundColor: Constants().primaryAppColor,
                                        buttonSelectedForegroundColor: Constants().secondaryAppColor,
                                      ),
                                      numberPages: filterText != "" ? (users.length + 10) ~/ 10 : pagecount,
                                      onPageChange: (int index) {
                                        documentList.addAll(snapshot.data!.docs);
                                        setState(() {
                                          temp = index+1;
                                        });
                                      },
                                    )*/
                                    Stack(
                                      alignment: Alignment.centerRight,
                                      children: [
                                        SizedBox(
                                          width: double.infinity,
                                          height:height/13.02,
                                          child: ListView.builder(
                                              shrinkWrap: true,
                                              scrollDirection: Axis.horizontal,
                                              itemCount: pagecount,
                                              itemBuilder: (context,index){
                                                return InkWell(
                                                  onTap: (){
                                                    setState(() {
                                                      temp=list[index];
                                                    });
                                                    print(temp);
                                                  },
                                                  child: Container(
                                                      height:30,width:30,
                                                      margin: EdgeInsets.only(left:8,right:8,top:10,bottom:10),
                                                      decoration: BoxDecoration(
                                                          borderRadius: BorderRadius.circular(100),
                                                          color:temp.toString() == list[index].toString() ?  Constants().primaryAppColor : Colors.transparent
                                                      ),
                                                      child: Center(
                                                        child: Text(list[index].toString(),style: GoogleFonts.inter(
                                                            fontWeight: FontWeight.w700,
                                                            color: temp.toString() == list[index].toString() ?  Colors.white : Colors.black

                                                        ),),
                                                      )
                                                  ),
                                                );

                                              }),
                                        ),
                                        temp > 1 ?
                                        Padding(
                                          padding: const EdgeInsets.only(right: 150.0),
                                          child:
                                          InkWell(
                                            onTap:(){
                                              setState(() {
                                                temp= temp-1;
                                              });
                                            },
                                            child: Container(
                                                height:height/16.275,
                                                width:width/11.3833,
                                                decoration:BoxDecoration(
                                                    color:Constants().primaryAppColor,
                                                    borderRadius: BorderRadius.circular(80)
                                                ),
                                                child: Center(
                                                  child: Text("Previous Page",style: GoogleFonts.inter(
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.white,
                                                  ),),
                                                )),
                                          ),
                                        )  : Container(),
                                        Container(
                                          child: temp < pagecount ?
                                          Padding(
                                            padding: const EdgeInsets.only(right: 20.0),
                                            child: InkWell(
                                              onTap:(){
                                                setState(() {
                                                  temp= temp+1;
                                                });
                                              },
                                              child:
                                              Container(
                                                  height:height/16.275,
                                                  width:width/11.3833,
                                                  decoration:BoxDecoration(
                                                      color:Constants().primaryAppColor,
                                                      borderRadius: BorderRadius.circular(80)
                                                  ),
                                                  child: Center(
                                                    child: Text("Next Page",style: GoogleFonts.inter(
                                                      fontWeight: FontWeight.w700,
                                                      color: Colors.white,
                                                    ),),
                                                  )),
                                            ),
                                          )  : Container(),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        );
                      }
                      return Container();
                    },
                  ) :

            Container(),
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

  viewPopup(UserModel user) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          content: Container(
            width: size.width * 0.5,
            margin: EdgeInsets.symmetric(
                horizontal: width/68.3,
                vertical: height/32.55
            ),
            decoration: BoxDecoration(
              color: Constants().primaryAppColor,
              boxShadow: [
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
                    padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/81.375),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          user.firstName!,
                          style: GoogleFonts.openSans(
                            fontSize: width / 68.3,
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
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black26,
                                  offset: Offset(1, 2),
                                  blurRadius: 3,
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width / 227.66),
                              child: Center(
                                child: KText(
                                  text: "CLOSE",
                                  style: GoogleFonts.openSans(
                                    fontSize:width/85.375,
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
                    decoration: BoxDecoration(
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
                                image: NetworkImage(user.imgUrl!),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: width/136.6, vertical: height/43.4),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  SizedBox(height: height / 32.55),
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
                                            "${user.firstName!} ${user.middleName!} ${user.lastName!}",
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
                                        text: user.bloodGroup!,
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
                                        text: user.dob!,
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
                                        text: user.gender!,
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
                                        text: user.phone!,
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
                                        text: user.email!,
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
                                        mask(user.aadharNo!.toString()),
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
                                        user.maritialStatus!.toString(),
                                        style: TextStyle(fontSize: width/97.571),
                                      )
                                    ],
                                  ),
                                  Visibility(
                                    visible: user.maritialStatus!.toString().toLowerCase() == 'married',
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
                                              user.anniversaryDate!.toString(),
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
                                        text: user.profession!,
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
                                        text: user.houseType!,
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
                                        text: user.qualification!,
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
                                        text: user.locality!,
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
                                        text: user.nationality!,
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
                                        text: user.pincode!,
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
                                        text: user.baptizeDate!,
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
                                        text: user.qualification!,
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
                                          user.preaddress!,
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
                                          user.resaddress,
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

  String mask(String input) {
    String result = '';
    int maskLen = input.length - 4;
    for (int i = 0; i < input.length; i++) {
      if (i < maskLen) {
        result += 'x';
      } else {
        result += input[i].toString();
      }
    }
    return result;
  }

  updateMemberStatus(String docId,bool status) async {
    cf.FirebaseFirestore.instance.collection('Users').doc(docId).update({
      "status" : status,
    });
  }

  editPopUp(UserModel user,String userDocID, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setStat) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Container(
              height: size.height * 2,
              width: width / 1.2418,
              margin: EdgeInsets.symmetric(horizontal: width / 68.3, vertical: height / 32.55),
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
                      padding: EdgeInsets.symmetric(
                          horizontal: width / 68.3, vertical: height / 81.375),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: "Edit User",
                            style: GoogleFonts.openSans(
                              fontSize: width / 68.3,
                              fontWeight: FontWeight.bold,
                              color: Constants().subHeadingColor,
                            ),
                          ),
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
                        ),
                      ),
                      padding: EdgeInsets.symmetric(vertical: height / 43.4, horizontal: width / 91.06),
                      child: SingleChildScrollView(
                        child: Form(
                          key: Formkey2,
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
                              SizedBox(height: height / 32.55),
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
                                      height: height / 18.6,
                                      width: size.width * 0.25,
                                      color: Constants().primaryAppColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo, color: Constants().btnTextColor),
                                          SizedBox(width: width / 136.6),
                                          KText(
                                            text: 'Select Profile Photo',
                                            style: TextStyle(color: Constants().btnTextColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width / 27.32),
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
                                      height: height / 18.6,
                                      width: size.width * 0.25,
                                      color: Constants().primaryAppColor,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.crop, color: Constants().btnTextColor),
                                          SizedBox(width: width / 136.6),
                                          KText(
                                            text: 'Disable Crop',
                                            style: TextStyle(color: Constants().btnTextColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height / 21.7),
                              KText(
                                text: "Personal Details",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width / 80.076,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Divider(),

                              ///prefix contriner and TextField
                              Padding(
                                padding:  EdgeInsets.only(top:height/81.375),
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
                                            text: "Prefix",
                                            style: GoogleFonts.openSans(
                                              color: Colors.black,
                                              fontSize: width / 105.076,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          DropdownButton(
                                            value: prefixController,
                                            isExpanded: true,
                                            underline: Container(),
                                            icon: Icon(Icons.keyboard_arrow_down),
                                            items: [
                                              "Select Prefix",
                                              "MR.",
                                              "MISS.",
                                              "MRS."
                                            ].map((items) {
                                              return DropdownMenuItem(
                                                value: items,
                                                child: Text(items),
                                              );
                                            }).toList(),
                                            onChanged: (newValue) {
                                              setState(() {
                                                prefixController = newValue!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: height / 21.7),

                              ///first and last and middle and Container
                              Row(
                                children: [
                                  SizedBox(
                                    width: width / 4.553,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Firstname *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
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
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: firstNameController,
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
                                          text: "Middle Name",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
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
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: middleNameController,
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
                                          text: "Lastname *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
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
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return null;
                                            }
                                          },
                                          onChanged: (val){
                                            // _keyLastname.currentState!.validate();
                                          },
                                          decoration: InputDecoration(
                                            counterText: "",
                                          ),
                                          maxLength: 40,
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp("[a-zA-Z]")),
                                          ],
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: lastNameController,
                                        )
                                      ],
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: height / 21.7),

                              ///Gender and Blood group and date of birth container
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
                                          text: "Gender *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        DropdownButton(
                                          value: GenderController,
                                          isExpanded: true,
                                          underline: Container(),
                                          icon: Icon(Icons.keyboard_arrow_down),
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
                                              GenderController = newValue!;
                                            });
                                          },
                                        ),
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
                                          text: "Blood Group *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height / 50.076),
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
                                                bloodGroupController.text = newValue!;
                                              });
                                            }
                                          },
                                        ),
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
                                          text: "Date of Birth *",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width / 105.076,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          readOnly: true,
                                          key: _keyDob,
                                          style: TextStyle(fontSize: width / 113.83),
                                          controller: dobController,
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Field is required';
                                            }else{
                                              return null;
                                            }
                                          },
                                          onTap: () async {
                                            DateTime? pickedDate =
                                            await Constants().datePicker(context);
                                            // await DatePicker.showSimpleDatePicker(
                                            //   context,
                                            //   initialDate: DateTime.now(),
                                            //   firstDate: DateTime(1900),
                                            //   lastDate: DateTime.now(),
                                            //   dateFormat: "dd-MM-yyyy",
                                            //   locale: DateTimePickerLocale.en_us,
                                            //   looping: true,
                                            // );
                                            // await showDatePicker(
                                            //   context: context,
                                            //   initialDate: DateTime.now(),
                                            //   firstDate: DateTime(1900),
                                            //   lastDate: DateTime.now(),
                                            //   initialEntryMode: DatePickerEntryMode.calendar,
                                            //   initialDatePickerMode: DatePickerMode.year,
                                            // );
                                            if (pickedDate != null) {
                                              setState(() {
                                                //dobController.text = formatter.format(pickedDate);
                                                setAge(pickedDate);
                                                dob=pickedDate;
                                                // dobController.text = formatter.format(pickedDate);
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
                                            DateTime? pickedDate = await Constants().datePicker(context);

                                            // await showDatePicker(
                                            // context: context,
                                            // initialDate: DateTime.now(),
                                            // firstDate: DateTime(1900),
                                            // lastDate: DateTime.now());

                                            if (pickedDate != null) {
                                              if(pickedDate!.compareTo(dob) < 0){
                                                print("DT1 is before DT2");
                                                CoolAlert.show(
                                                    context: context,
                                                    type: CoolAlertType.info,
                                                    text: "Invalid Baptism Date",
                                                    title: "Please select Baptism Date correctly!",
                                                    width: size.width * 0.4,
                                                    backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                    showCancelBtn: true,
                                                    cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                    confirmBtnText: 'OK',
                                                    onConfirmBtnTap: () async {

                                                    },
                                                    onCancelBtnTap: () async {

                                                    }
                                                );
                                              }
                                              else {
                                                setState(() {
                                                  baptizeDateController.text =
                                                      formatter.format(
                                                          pickedDate);
                                                });
                                              }
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
                                          text: "Confirmation Date*",
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
                                              if (pickedDate != null) {
                                                if(pickedDate!.compareTo(dob) < 0){
                                                  print("DT1 is before DT2");
                                                  CoolAlert.show(
                                                      context: context,
                                                      type: CoolAlertType.info,
                                                      text: "Invalid Confirmation Date",
                                                      title: "Please select Confirmation Date correctly!",
                                                      width: size.width * 0.4,
                                                      backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                      showCancelBtn: true,
                                                      cancelBtnTextStyle: TextStyle(color: Colors.black),
                                                      confirmBtnText: 'OK',
                                                      onConfirmBtnTap: () async {

                                                      },
                                                      onCancelBtnTap: () async {

                                                      }
                                                  );
                                                }
                                                else {
                                                  setState(() {
                                                    confirmDateController.text = formatter.format(pickedDate);
                                                  });
                                                }
                                              }

                                            }
                                          },
                                          validator: (val){
                                            if(val!.isEmpty){
                                              return 'Filed must be not empty';

                                            }else{
                                              return null;
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
                                          text: "Aadhaar Number*",
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
                                              return 'Filed must be not empty';
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
                                          controller: aadharController,
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
                                            value: marriedController,
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
                                                marriedController = newValue!;
                                              });
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: width / 68.3),
                                    Visibility(
                                      visible: marriedController.toUpperCase() == "MARRIED",
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
                                              controller: anniversaryDateController,
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
                                                    anniversaryDateController.text = formatter.format(pickedDate);
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
                              SizedBox(height: height / 21.7),



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
                                            focusNode: professionFocusNode,
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
                                            controller: professionController,
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
                                            /*  inputFormatters: [
                                                FilteringTextInputFormatter.allow(RegExp("[a-zA-Z .]")),
                                              ],*/
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
                                              FocusScope.of(context).requestFocus(emailFocusNode);
                                            },
                                            onFieldSubmitted: (val){
                                              FocusScope.of(context).requestFocus(emailFocusNode);
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
                                            onEditingComplete: (){
                                              // _keyAlterEmail.currentState!.validate();
                                              FocusScope.of(context).requestFocus(professionFocusNode);
                                            },
                                            onFieldSubmitted: (val){
                                              FocusScope.of(context).requestFocus(professionFocusNode);
                                            },
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
                                            onEditingComplete: (){
                                              _key.currentState!.validate();
                                              FocusScope.of(context).requestFocus(professionFocusNode);
                                            },
                                            onFieldSubmitted: (val){
                                              FocusScope.of(context).requestFocus(professionFocusNode);
                                            },
                                            validator: (value) {
                                              if(value!.isNotEmpty) {
                                                if (!isEmail(value!)) {
                                                  return 'Please enter a valid email.';
                                                }
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
                                                  key: _keyAlterEmail,
                                                  focusNode: alterNativeemailFocusNode,
                                                  autofocus: true,
                                                  onEditingComplete: (){
                                                    // _keyAlterEmail.currentState!.validate();
                                                    FocusScope.of(context).requestFocus(professionFocusNode);
                                                  },
                                                  onFieldSubmitted: (val){
                                                    FocusScope.of(context).requestFocus(professionFocusNode);
                                                  },
                                                  validator: (value) {
                                                    if(value!.isNotEmpty) {
                                                      if (!isEmail(value!)) {
                                                        return 'Please enter a valid email.';
                                                      }
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
                                            "Owned",
                                            "Rented",
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
                                    text: "Residential Address *",
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
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Filed must be not empty';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                style: TextStyle(
                                                    fontSize: width / 113.83),
                                                controller: addressController,
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
                              SizedBox(height: height / 21.7),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if(!isLoading) {
                                        print("Filed result");
                                        print(Formkey2.currentState!.validate());
                                        if (Formkey2.currentState!.validate()) {
                                          print("Filed are fine");

                                          /*      _keyFirstname.currentState!.validate();
                                        _keyLastname.currentState!.validate();
                                        _keyLocality.currentState!.validate();
                                        _keyAadhar.currentState!.validate();
                                        _key.currentState!.validate();
                                        _keyDob.currentState!.validate();
                                        _keyPhone.currentState!.validate();*/
                                          if (profileImage == null && uploadedImage == null && selectedImg == null) {
                                            print("P Img are fine");
                                            setStat(() {
                                              profileImageValidator = true;
                                            });
                                          }
                                          else {
                                            setStat(() {
                                              profileImageValidator = false;
                                            });
                                          }
                                          if ( profileImage == null || uploadedImage == null || selectedImg == null &&
                                          bloodGroupController.text !=
                                              "Select Blood Group" &&
                                              firstNameController.text != "" &&
                                              lastNameController.text != "" &&
                                              dobController.text != "" &&
                                              _keyPhone.currentState!
                                                  .validate() &&
                                              _keyPincode.currentState!
                                                  .validate() &&
                                              validateAadhaar(
                                                  aadharController.text
                                                      .isNotEmpty) &&
                                              validateEmail(emailController.text
                                                  .isNotEmpty) &&
                                              GenderController !=
                                                  "Select Gender" &&
                                              marriedController != "Select Status"
                                          ) {
                                            setStat(() {
                                              isLoading = true;
                                            });
                                            Response response = await UserFireCrud
                                                .updateRecord(
                                              userDocID,
                                              UserModel(
                                                maritialStatus: marriedController,
                                                pincode: pincodeController.text,
                                                gender: GenderController,
                                                baptizeDate: baptizeDateController
                                                    .text,
                                                nationality: nationalityCon.text,
                                                houseType: houseTypeCon.text,
                                                prefix: prefixController,
                                                middleName: middleNameController
                                                    .text,
                                                anniversaryDate: anniversaryDateController
                                                    .text,
                                                aadharNo: aadharController.text,
                                                bloodGroup: bloodGroupController
                                                    .text,
                                                dob: dobController.text,
                                                qualification: qualificationController
                                                    .text,
                                                email: emailController.text,
                                                firstName: firstNameController
                                                    .text,
                                                lastName: lastNameController.text,
                                                locality: localityController.text,
                                                phone: phoneController.text,
                                                profession: professionController
                                                    .text,
                                                about: aboutController.text,
                                                preaddress: aboutController.text,
                                                resaddress: addressController
                                                    .text,
                                                id: userDocID,
                                                timestamp: user.timestamp,
                                                imgUrl: user.imgUrl,
                                                isPrivacyEnabled: user
                                                    .isPrivacyEnabled,
                                                status: user.status,
                                                fcmToken: user.fcmToken,
                                                alterNativeemail: user
                                                    .alterNativeemail,
                                                state: user.state,
                                                contry: user.contry,
                                                condate: confirmDateController
                                                    .text,
                                                //conformationdate
                                                companyname: companynameController
                                                    .text,
                                                alphone: alphoneController
                                                    .text, //alphone
                                              ),
                                              profileImage,
                                              user.imgUrl,
                                            );
                                            if (response.code == 200) {
                                              await CoolAlert.show(
                                                  context: context,
                                                  type: CoolAlertType.success,
                                                  text: "User updated successfully!",
                                                  width: size.width * 0.4,
                                                  backgroundColor: Constants()
                                                      .primaryAppColor
                                                      .withOpacity(0.8));
                                              clearTextControllers();
                                              Navigator.pop(context);
                                            } else {
                                              await CoolAlert.show(
                                                  context: context,
                                                  type: CoolAlertType.error,
                                                  text: "Failed to Create User!",
                                                  width: size.width * 0.4,
                                                  backgroundColor: Constants()
                                                      .primaryAppColor
                                                      .withOpacity(0.8));
                                              setState(() {
                                                isLoading = false;
                                              });
                                              Navigator.pop(context);
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
                                      }
                                    },
                                    child: Container(
                                      height: height / 16.6,
                                      width: width*0.1,
                                      decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: width / 190.66),
                                        child: Center(
                                          child: KText(
                                            text: "UPDATE NOW",
                                            style: GoogleFonts.openSans(
                                              color: Constants().btnTextColor,
                                              fontSize:width/136.6,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/136.6),
                                  InkWell(
                                    onTap: (){
                                      clearTextControllers();
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      height: height / 16.6,
                                      width: width*0.1,
                                      decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
                                        borderRadius: BorderRadius.circular(8),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black26,
                                            offset: Offset(1, 2),
                                            blurRadius: 3,
                                          ),
                                        ],
                                      ),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(horizontal: width / 190.66),
                                        child: Center(
                                          child: KText(
                                            text: "Cancel",
                                            style: GoogleFonts.openSans(
                                              color: Constants().btnTextColor,
                                              fontSize:width/136.6,
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
                    ),
                  ),
                ],
              ),
            ),
          );
        });
      },
    );
  }

  convertToCsv(List<UserModelWithDocId> users) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Name");
    row.add("Phone");
    row.add("Email");
    row.add("Profession");
    row.add("Baptism Date");
    row.add("Marital Status");
    row.add("Blood Group");
    row.add("Date of birth");
    row.add("Landmark");
    row.add("Pin Code");
    row.add("Address");
    row.add("About");
    rows.add(row);
    for (int i = 0; i < users.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("${users[(temp*10)-10+i].user.firstName!} ${users[(temp*10)-10+i].user.lastName!}");
      row.add(users[(temp*10)-10+i].user.phone);
      row.add(users[(temp*10)-10+i].user.email);
      row.add(users[(temp*10)-10+i].user.profession);
      row.add(users[(temp*10)-10+i].user.baptizeDate);
      row.add(users[(temp*10)-10+i].user.maritialStatus);
      row.add(users[(temp*10)-10+i].user.bloodGroup);
      row.add(users[(temp*10)-10+i].user.dob);
      row.add(users[(temp*10)-10+i].user.locality);
      row.add(users[(temp*10)-10+i].user.pincode);
      row.add(users[(temp*10)-10+i].user.resaddress);
      row.add(users[(temp*10)-10+i].user.about);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows);
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
    final blob = Blob([data], 'application/pdf');
    final url = Url.createObjectUrlFromBlob(blob);
    final anchor = AnchorElement(href: url)
      ..setAttribute("download", "Users.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<UserModelWithDocId> users) async {
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
    row.add("Landmark");
    rows.add(row);
    for (int i = 0; i < users.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add("${users[(temp*10)-10+i].user.firstName} ${users[(temp*10)-10+i].user.lastName}");
      row.add("       ");
      row.add(users[(temp*10)-10+i].user.profession);
      row.add("       ");
      row.add(users[(temp*10)-10+i].user.phone);
      row.add("       ");
      row.add(users[(temp*10)-10+i].user.locality);
      rows.add(row);
    }
    String csv = ListToCsvConverter().convert(rows,
        fieldDelimiter: null,
        eol: null,
        textEndDelimiter: null,
        delimitAllFields: false,
        textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",", "")));
  }

  final snackBar = SnackBar(

    backgroundColor: Colors.transparent,
    elevation: 0,
    content: Container(
        padding: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: Constants().primaryAppColor, width:3),
          boxShadow: [
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
                onPressed: () => debugPrint("Undid"), child: Text("Undo"))
          ],
        )),
  );

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

}



class UserModelWithDocId{
  UserModelWithDocId(this.userDocId, this.user);
  String userDocId;
  UserModel user;
}

class Location {
  String name;
  String district;
  String region;
  String state;

  Location(this.name, this.district, this.region, this.state);

  factory Location.fromJson(Map<String, dynamic> json) {
    return Location(
        json['Name'], json['District'], json['Region'], json['State']);
  }
}

import 'dart:convert';
import 'dart:html';
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:church_management_admin/models/product_model.dart';
import 'package:church_management_admin/services/products_firecrud.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import '../../constants.dart';
import '../../models/response.dart';
import '../../widgets/kText.dart';
import '../print_page.dart';
import '../prints/product_print.dart';

class ProductTab extends StatefulWidget {
  const ProductTab({super.key});

  @override
  State<ProductTab> createState() => _ProductTabState();
}

class _ProductTabState extends State<ProductTab> {

  TextEditingController titleController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController categoriesController = TextEditingController();
  TextEditingController tagsController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController saleController = TextEditingController();

  File? profileImage;
  var uploadedImage;
  String? selectedImg;

  String currentTab = 'View';
  String searchString = "";

  bool isCropped = false;

  selectImage() {
    InputElement input = FileUploadInputElement() as InputElement
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
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "PRODUCTS",
                    style: GoogleFonts.openSans(
                        fontSize: width/52.53846153846154,
                        fontWeight: FontWeight.w900,
                        color: Colors.black),
                  ),
                  InkWell(
                      onTap:(){
                        if(currentTab.toUpperCase() == "VIEW") {
                          setState(() {
                            currentTab = "Add";
                          });
                        }else{
                          setState(() {
                            currentTab = 'View';
                          });
                          //clearTextControllers();
                        }
                      },
                      child: Container(
                        height: height/18.6,
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
                          const EdgeInsets.symmetric(horizontal: 6),
                          child: Center(
                            child: KText(
                              text: currentTab.toUpperCase() == "VIEW" ? "Add New Product" : "View Products",
                              style: GoogleFonts.openSans(
                                fontSize: width/105.0769230769231,
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
                ? Container(
              height: size.height * 1.2,
              width: width/1.241818181818182,
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
                            text: "ADD NEW PRODUCT",
                            style: GoogleFonts.openSans(
                              fontSize: width/68.3,
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
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Container(
                              height: height/3.829411764705882,
                              width: width/3.902857142857143,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Constants().primaryAppColor,
                                      width: 2),
                                  image: uploadedImage != null
                                      ? DecorationImage(
                                    fit: isCropped ? BoxFit.contain : BoxFit.cover,
                                    image: MemoryImage(
                                      Uint8List.fromList(
                                        base64Decode(uploadedImage!
                                            .split(',')
                                            .last),
                                      ),
                                    ),
                                  )
                                      : null),
                              child: uploadedImage == null
                                  ? Center(
                                child: Icon(
                                  Icons.cloud_upload,
                                  size: width/8.5375,
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
                                onTap: selectImage,
                                child: Container(
                                  height: height/18.6,
                                  width: size.width * 0.25,
                                  color: Constants().primaryAppColor,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.add_a_photo,
                                          color: Colors.white),
                                      SizedBox(width: width/136.6),
                                      KText(
                                        text: 'Select Product Photo',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(width: width/27.32),
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
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.crop,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: width/136.6),
                                      KText(
                                        text: 'Disable Crop',
                                        style: TextStyle(color: Colors.white),
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
                                width: width/4.553333333333333,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Title *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize: width/113.8333333333333),
                                      controller: titleController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553333333333333,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Price *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      inputFormatters: [
                                        FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
                                      ],
                                      style: TextStyle(fontSize: width/113.8333333333333),
                                      controller: priceController,
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(width: width/68.3),
                              SizedBox(
                                width: width/4.553333333333333,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Categories *",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize: width/113.8333333333333),
                                      controller: categoriesController,
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
                                width: width/4.553333333333333,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    KText(
                                      text: "Tags",
                                      style: GoogleFonts.openSans(
                                        color: Colors.black,
                                        fontSize: width/105.0769230769231,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    TextFormField(
                                      style: TextStyle(fontSize: width/113.8333333333333),
                                      controller: tagsController,
                                    )
                                  ],
                                ),
                              ),
                              // SizedBox(width: width/68.3),
                              // SizedBox(
                              //   width: width/4.553333333333333,
                              //   child: Column(
                              //     crossAxisAlignment: CrossAxisAlignment.start,
                              //     children: [
                              //       KText(
                              //         text: "Sale",
                              //         style: GoogleFonts.openSans(
                              //           color: Colors.black,
                              //           fontSize: width/105.0769230769231,
                              //           fontWeight: FontWeight.bold,
                              //         ),
                              //       ),
                              //       TextFormField(
                              //         style: const TextStyle(fontSize: 12),
                              //         controller: saleController,
                              //       )
                              //     ],
                              //   ),
                              // ),
                            ],
                          ),
                          SizedBox(height: height/21.7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              KText(
                                text: "Description",
                                style: GoogleFonts.openSans(
                                  color: Colors.black,
                                  fontSize: width/105.0769230769231,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Container(
                                height: size.height * 0.15,
                                width: double.infinity,
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
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(
                                      height: height/32.55,
                                      width: double.infinity,
                                    ),
                                    Expanded(
                                      child: Container(
                                          width: double.infinity,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
                                          ),
                                          child: TextFormField(
                                            style:
                                            TextStyle(fontSize: width/113.8333333333333),
                                            controller: descriptionController,
                                            decoration: const InputDecoration(
                                              border: InputBorder.none,
                                                contentPadding: EdgeInsets.only(left: 15,top: 4,bottom: 4)
                                            ),
                                            maxLines: null,
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: height/21.7),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () async {
                                  if (profileImage != null &&
                                      titleController.text != "" &&
                                      priceController.text != "" &&
                                      categoriesController.text != "") {
                                    Response response =
                                    await ProductsFireCrud.addProduct(
                                      image: profileImage!,
                                      title: titleController.text,
                                      tags: tagsController.text,
                                      sale: saleController.text,
                                      price: double.parse(priceController.text),
                                      categories: categoriesController.text,
                                      description: descriptionController.text,
                                    );
                                    if (response.code == 200) {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.success,
                                          text: "Product created successfully!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                      setState(() {
                                        currentTab = 'View';
                                        uploadedImage = null;
                                        profileImage = null;
                                        titleController.text = "";
                                        priceController.text = "";
                                        categoriesController.text = "";
                                        saleController.text = "";
                                        tagsController.text = "";
                                        descriptionController.text = "";
                                      });
                                    } else {
                                      CoolAlert.show(
                                          context: context,
                                          type: CoolAlertType.error,
                                          text: "Failed to Create Product!",
                                          width: size.width * 0.4,
                                          backgroundColor: Constants()
                                              .primaryAppColor
                                              .withOpacity(0.8));
                                    }
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
                                  }
                                },
                                child: Container(
                                  height: height/18.6,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
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
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 6),
                                    child: Center(
                                      child: KText(
                                        text: "ADD NOW",
                                        style: GoogleFonts.openSans(
                                          color: Colors.white,
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
            )
                : currentTab.toUpperCase() == "VIEW" ? StreamBuilder(
              stream:searchString != "" ? ProductsFireCrud.fetchClansWithSearch(searchString):ProductsFireCrud.fetchProducts(),
              builder: (ctx, snapshot) {
                if (snapshot.hasError) {
                  return Container();
                } else if (snapshot.hasData) {
                  List<ProductModel> products = snapshot.data!;
                  return Container(
                    width: width/1.241818181818182,
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
                                  text: "All Products (${products.length})",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Material(
                                  borderRadius:
                                  BorderRadius.circular(5),
                                  color: Colors.white,
                                  elevation: 10,
                                  child: SizedBox(
                                    height: height / 18.6,
                                    width: width / 5.106,
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
                                          "Search by Title,Price",
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
                          height: size.height * 0.7 > height/5.007692307692308 + products.length * 60
                              ? height/5.007692307692308 + products.length * 60
                              : size.height * 0.7,
                          width: double.infinity,
                          decoration: const BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  InkWell(
                                    onTap: () {
                                      generateProductPdf(PdfPageFormat.letter, products,false);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.print,
                                                  color: Colors.white),
                                              KText(
                                                text: "PRINT",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.0769230769231,
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
                                      copyToClipBoard(products);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.copy,
                                                  color: Colors.white),
                                              KText(
                                                text: "COPY",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.0769230769231,
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
                                      var data = await generateProductPdf(PdfPageFormat.letter, products,true);
                                      savePdfToFile(data);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(Icons.picture_as_pdf,
                                                  color: Colors.white),
                                              KText(
                                                text: "PDF",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.0769230769231,
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
                                      convertToCsv(products);
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: Row(
                                            children: [
                                              const Icon(
                                                  Icons.file_copy_rounded,
                                                  color: Colors.white),
                                              KText(
                                                text: "CSV",
                                                style: GoogleFonts.openSans(
                                                  color: Colors.white,
                                                  fontSize: width/105.0769230769231,
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
                                  padding: const EdgeInsets.all(3.0),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(
                                        width: width/17.075,
                                        child: KText(
                                          text: "No.",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/13.66,
                                        child: KText(
                                          text: "Photo",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/8.035294117647059,
                                        child: KText(
                                          text: "Title",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/9.106666666666667,
                                        child: KText(
                                          text: "Price",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/8.035294117647059,
                                        child: KText(
                                          text: "Categories",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/9.106666666666667,
                                        child: KText(
                                          text: "Tags",
                                          style: GoogleFonts.poppins(
                                            fontSize:  width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                        width: width/7.588888888888889,
                                        child: KText(
                                          text: "Actions",
                                          style: GoogleFonts.poppins(
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: products.length,
                                  itemBuilder: (ctx, i) {
                                    return Container(
                                      height: height/10.85,
                                      width: double.infinity,
                                      decoration: const BoxDecoration(
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
                                        padding: const EdgeInsets.all(5.0),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                          children: [
                                            SizedBox(
                                              width: width/17.075,
                                              child: KText(
                                                text: (i + 1).toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/13.66,
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  CircleAvatar(
                                                    backgroundImage:
                                                    NetworkImage(products[i].imgUrl!),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/8.035294117647059,
                                              child: KText(
                                                text:
                                                products[i].title!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/9.106666666666667,
                                              child: KText(
                                                text: products[i].price!.toString(),
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/8.035294117647059,
                                              child: KText(
                                                text: products[i].categories!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: width/9.106666666666667,
                                              child: KText(
                                                text: products[i].tags!,
                                                style: GoogleFonts.poppins(
                                                  fontSize: width/105.0769230769231,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                width: width/7.588888888888889,
                                                child: Row(
                                                  children: [
                                                    InkWell(
                                                      onTap: () {
                                                        viewPopup(products[i]);
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                        const BoxDecoration(
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
                                                          const EdgeInsets
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
                                                                  size: width/91.06666666666667,
                                                                ),
                                                                KText(
                                                                  text: "View",
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
                                                    const SizedBox(width: 5),
                                                    InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          titleController.text = products[i].title!;
                                                          priceController.text = products[i].price!.toString();
                                                          tagsController.text = products[i].tags!;
                                                          saleController.text = products[i].sale!;
                                                          categoriesController.text = products[i].categories!;
                                                          descriptionController.text = products[i].description!;
                                                          selectedImg = products[i].imgUrl;
                                                        });
                                                        editPopUp(products[i], size);
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                        const BoxDecoration(
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
                                                          const EdgeInsets
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
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: width/91.06666666666667,
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
                                                    const SizedBox(width: 5),
                                                    InkWell(
                                                      onTap: () {
                                                        CoolAlert.show(
                                                            context: context,
                                                            type: CoolAlertType.info,
                                                            text: "${products[i].title} will be deleted",
                                                            title: "Delete this Record?",
                                                            width: size.width * 0.4,
                                                            backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                            showCancelBtn: true,
                                                            cancelBtnText: 'Cancel',
                                                            cancelBtnTextStyle: const TextStyle(color: Colors.black),
                                                            onConfirmBtnTap: () async {
                                                              Response res = await ProductsFireCrud.deleteRecord(id: products[i].id!);
                                                            }
                                                        );
                                                      },
                                                      child: Container(
                                                        height: height/26.04,
                                                        decoration:
                                                        const BoxDecoration(
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
                                                          const EdgeInsets
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
                                                                      .cancel_outlined,
                                                                  color: Colors
                                                                      .white,
                                                                  size: width/91.06666666666667,
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
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return Container();
              },
            ) : Container()
          ],
        ),
      ),
    );
  }

  viewPopup(ProductModel product) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context,setState) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                width: size.width * 0.5,
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
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                      width: double.infinity,
                      child: Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title!,
                              style: GoogleFonts.openSans(
                                fontSize: width/68.3,
                                fontWeight: FontWeight.bold,
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
                                  const EdgeInsets.symmetric(horizontal: 6),
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
                        decoration: const BoxDecoration(
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
                                    image: NetworkImage(product.imgUrl!),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: double.infinity,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      SizedBox(height: height/32.55),
                                      Row(
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.15,
                                            child: KText(
                                              text: "Title",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: width/85.375
                                              ),
                                            ),
                                          ),
                                          const Text(":"),
                                          SizedBox(width: width/68.3),
                                          KText(
                                            text: product.title!,
                                            style:  TextStyle(
                                                fontSize: width/97.57142857142857
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
                                              text: "Price",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: width/85.375
                                              ),
                                            ),
                                          ),
                                          const Text(":"),
                                          SizedBox(width: width/68.3),
                                          KText(
                                            text: product.price!.toString(),
                                            style:  TextStyle(
                                                fontSize: width/97.57142857142857
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
                                              text: "Categories",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: width/85.375
                                              ),
                                            ),
                                          ),
                                          const Text(":"),
                                          SizedBox(width: width/68.3),
                                          KText(
                                            text: product.categories!,
                                            style:  TextStyle(
                                                fontSize: width/97.57142857142857
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
                                              text: "Tags",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: width/85.375
                                              ),
                                            ),
                                          ),
                                          const Text(":"),
                                          SizedBox(width: width/68.3),
                                          KText(
                                            text: product.tags!,
                                            style:  TextStyle(
                                                fontSize: width/97.57142857142857
                                            ),
                                          )
                                        ],
                                      ),
                                      // SizedBox(height: height/32.55),
                                      // Row(
                                      //   children: [
                                      //     SizedBox(
                                      //       width: size.width * 0.15,
                                      //       child:  KText(
                                      //         text: "Sale",
                                      //         style: TextStyle(
                                      //             fontWeight: FontWeight.w800,
                                      //             fontSize: width/85.375
                                      //         ),
                                      //       ),
                                      //     ),
                                      //     const Text(":"),
                                      //     SizedBox(width: width/68.3),
                                      //     KText(
                                      //       text: product.sale!,
                                      //       style: TextStyle(
                                      //           fontSize: width/97.57142857142857
                                      //       ),
                                      //     )
                                      //   ],
                                      // ),
                                      SizedBox(height: height/32.55),
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.15,
                                            child: KText(
                                              text: "Description",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w800,
                                                  fontSize: width/85.375
                                              ),
                                            ),
                                          ),
                                          const Text(":"),
                                          SizedBox(width: width/68.3),
                                          SizedBox(
                                            width: size.width * 0.3,
                                            child: KText(
                                              text: product.description!,
                                              style: TextStyle(
                                                  fontSize: width/97.57142857142857
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      SizedBox(height: height/32.55),
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
          }
        );
      },
    );
  }

  editPopUp(ProductModel product, Size size) {
    double height = size.height;
    double width = size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context,setStat) {
            return AlertDialog(
              backgroundColor: Colors.transparent,
              content: Container(
                height: size.height * 1.2,
                width: width/1.241818181818182,
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
                              text: "EDIT PRODUCT",
                              style: GoogleFonts.openSans(
                                fontSize: width/68.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: (){
                                setState(() {
                                  uploadedImage = null;
                                  profileImage = null;
                                  titleController.text = "";
                                  priceController.text = "";
                                  categoriesController.text = "";
                                  saleController.text = "";
                                  tagsController.text = "";
                                  descriptionController.text = "";
                                });
                                Navigator.pop(context);
                              },
                              child: const Icon(
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
                        decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Container(
                                  height: height/3.829411764705882,
                                  width: width/3.902857142857143,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Constants().primaryAppColor,
                                          width: 2),
                                      image: selectedImg != null ? DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(selectedImg!)
                                      ) : uploadedImage != null
                                          ? DecorationImage(
                                        fit: isCropped ? BoxFit.contain : BoxFit.cover,
                                        image: MemoryImage(
                                          Uint8List.fromList(
                                            base64Decode(uploadedImage!
                                                .split(',')
                                                .last),
                                          ),
                                        ),
                                      )
                                          : null),
                                  child: selectedImg == null
                                      ?  Center(
                                    child: Icon(
                                      Icons.cloud_upload,
                                      size: width/8.5375,
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
                                      input.onChange.listen((event) {
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.add_a_photo,
                                              color: Colors.white),
                                          SizedBox(width: width/136.6),
                                          KText(
                                            text: 'Select Product Photo',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: width/27.32),
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
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.crop,
                                            color: Colors.white,
                                          ),
                                          SizedBox(width: width/136.6),
                                          KText(
                                            text: 'Disable Crop',
                                            style: TextStyle(color: Colors.white),
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
                                    width: width/4.553333333333333,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Title",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize: width/113.8333333333333),
                                          controller: titleController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  SizedBox(
                                    width: width/4.553333333333333,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Price",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          inputFormatters: [
                                            FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
                                          ],
                                          style: TextStyle(fontSize: width/113.8333333333333),
                                          controller: priceController,
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(width: width/68.3),
                                  SizedBox(
                                    width:width/4.553333333333333,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Categories",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize: width/113.8333333333333),
                                          controller: categoriesController,
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
                                    width: width/4.553333333333333,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Tags",
                                          style: GoogleFonts.openSans(
                                            color: Colors.black,
                                            fontSize: width/105.0769230769231,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        TextFormField(
                                          style: TextStyle(fontSize: width/113.8333333333333),
                                          controller: tagsController,
                                        )
                                      ],
                                    ),
                                  ),
                                  // SizedBox(width: width/68.3),
                                  // SizedBox(
                                  //   width: width/4.553333333333333,
                                  //   child: Column(
                                  //     crossAxisAlignment: CrossAxisAlignment.start,
                                  //     children: [
                                  //       KText(
                                  //         text: "Sale",
                                  //         style: GoogleFonts.openSans(
                                  //           color: Colors.black,
                                  //           fontSize:  width/105.0769230769231,
                                  //           fontWeight: FontWeight.bold,
                                  //         ),
                                  //       ),
                                  //       TextFormField(
                                  //         style: TextStyle(fontSize: width/113.8333333333333),
                                  //         controller: saleController,
                                  //       )
                                  //     ],
                                  //   ),
                                  // ),
                                ],
                              ),
                              SizedBox(height: height/21.7),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  KText(
                                    text: "Description",
                                    style: GoogleFonts.openSans(
                                      color: Colors.black,
                                      fontSize:  width/105.0769230769231,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container(
                                    height: size.height * 0.15,
                                    width: double.infinity,
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
                                    ),
                                    child: Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                      children: [
                                        SizedBox(
                                          height: height/32.55,
                                          width: double.infinity,
                                        ),
                                        Expanded(
                                          child: Container(
                                              width: double.infinity,
                                              decoration: const BoxDecoration(
                                                color: Colors.white,
                                              ),
                                              child: TextFormField(
                                                style:
                                                TextStyle(fontSize: width/113.8333333333333),
                                                controller: descriptionController,
                                                decoration: const InputDecoration(
                                                    border: InputBorder.none,
                                                    contentPadding: EdgeInsets.only(left: 15,top: 4,bottom: 4)
                                                ),
                                                maxLines: null,
                                              )),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: height/21.7),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    onTap: () async {
                                      if (titleController.text != "" &&
                                          priceController.text != "" &&
                                          categoriesController.text != "") {
                                        Response response =
                                        await ProductsFireCrud.updateRecord(
                                          ProductModel(
                                            id: product.id,
                                            productId: product.productId,
                                            imgUrl: product.imgUrl,
                                            timestamp: product.timestamp,
                                            title: titleController.text,
                                            tags: tagsController.text,
                                            sale: saleController.text,
                                            price: double.parse(priceController.text),
                                            categories: categoriesController.text,
                                            description: descriptionController.text,
                                          ),
                                          profileImage,
                                          product.imgUrl!
                                        );
                                        if (response.code == 200) {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: "Product updated successfully!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          setState(() {
                                            uploadedImage = null;
                                            profileImage = null;
                                            titleController.clear();
                                            priceController.clear();
                                            categoriesController.clear();
                                            saleController.clear();
                                            tagsController.clear();
                                            descriptionController.clear();
                                          });
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        } else {
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: "Failed to update Product!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          Navigator.pop(context);
                                        }
                                      } else {
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    },
                                    child: Container(
                                      height: height/18.6,
                                      decoration: BoxDecoration(
                                        color: Constants().primaryAppColor,
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
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 6),
                                        child: Center(
                                          child: KText(
                                            text: "Update",
                                            style: GoogleFonts.openSans(
                                              color: Colors.white,
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

  convertToCsv(List<ProductModel> products) async {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("Title");
    row.add("Price");
    row.add("Categories");
    row.add("Tags");
    row.add("Sale");
    row.add("Description");
    rows.add(row);
    for (int i = 0; i < products.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add(products[i].title);
      row.add(products[i].price);
      row.add(products[i].categories);
      row.add(products[i].tags);
      row.add(products[i].sale);
      row.add(products[i].description);
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows);
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
      ..setAttribute("download", "Products.pdf")
      ..click();
    Url.revokeObjectUrl(url);
  }

  copyToClipBoard(List<ProductModel> products) async  {
    List<List<dynamic>> rows = [];
    List<dynamic> row = [];
    row.add("No.");
    row.add("    ");
    row.add("Title");
    row.add("    ");
    row.add("Price");
    row.add("    ");
    row.add("Categories");
    row.add("    ");
    row.add("Tags");
    rows.add(row);
    for (int i = 0; i < products.length; i++) {
      List<dynamic> row = [];
      row.add(i + 1);
      row.add("       ");
      row.add(products[i].title);
      row.add("       ");
      row.add(products[i].price);
      row.add("       ");
      row.add(products[i].categories);
      row.add("       ");
      row.add(products[i].tags);
      rows.add(row);
    }
    String csv = const ListToCsvConverter().convert(rows,fieldDelimiter: null,eol: null,textEndDelimiter: null,delimitAllFields: false,textDelimiter: null);
    await Clipboard.setData(ClipboardData(text: csv.replaceAll(",","")));
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

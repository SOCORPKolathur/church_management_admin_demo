import 'dart:convert';
import 'dart:html';
import 'dart:html' as html;
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:church_management_admin/constants.dart';
import 'package:church_management_admin/models/gallery_image_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';
import '../../models/response.dart';
import '../../services/gallery_firecrud.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';
import 'package:path_provider/path_provider.dart';

class GalleryTab extends StatefulWidget {
  GalleryTab({super.key});

  @override
  State<GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab> with SingleTickerProviderStateMixin {

  bool isEditGI = false;
  bool isEditSI = false;
  bool isEditVG = false;
  late AnimationController lottieController;

  addImage(String collection,Size size) {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'image/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) async {
        Response res = await GalleryFireCrud.addImage(file, collection);
        if (res.code == 200) {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.success,
              text: "Event created successfully!",
              width: size.width * 0.4,
              backgroundColor: Constants().primaryAppColor.withOpacity(0.8)
          );
        } else {
          CoolAlert.show(
              context: context,
              type: CoolAlertType.error,
              text: "Failed to Create Event!",
              width: size.width * 0.4,
              backgroundColor: Constants().primaryAppColor.withOpacity(0.8)
          );
        }
      });
    });
  }


  @override
  void initState() {
    lottieController = AnimationController(vsync: this);
    lottieController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.pop(context);
        lottieController.reset();
      }
    });
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                child: KText(
                  text: 'GALLERY',
                  style: GoogleFonts.openSans(
                    fontSize: width/52.538,
                    fontWeight: FontWeight.w900,
                    color: Colors.black,
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.03),
              Container(
                height: size.height * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Constants().primaryAppColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width/68.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            KText(
                              text: "SLIDER IMAGES",
                              style: GoogleFonts.openSans(
                                fontSize: width/62.09,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            isEditSI
                                ? Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isEditSI = false;
                                          });
                                        },
                                        child: KText(
                                          text: "Apply",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/75.88,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          addImage('SI',size);
                                        },
                                        child: KText(
                                          text: "ADD",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/75.88,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.add_circle,
                                      ),
                                      SizedBox(width: width/91.06),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isEditSI = true;
                                          });
                                        },
                                        child: KText(
                                          text: "EDIT",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/75.88,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit_note,
                                      ),
                                      SizedBox(width: width/91.06),
                                      InkWell(
                                        onTap: () {
                                          showImageGidView(context, 'SI');
                                        },
                                        child: KText(
                                          text: "VIEW MORE",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/75.88,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      RotatedBox(
                                        quarterTurns: 3,
                                        child: Icon(
                                          Icons.expand_circle_down_outlined,
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: StreamBuilder(
                        stream: GalleryFireCrud.fetchSliderImages(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container();
                          } else if (snapshot.hasData) {
                            List<GalleryImageModel> allData = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: allData.length,
                              itemBuilder: (ctx, i) {
                                return InkWell(
                                  onTap: () {
                                    showImageModel(context, allData[i].imgUrl!);
                                  },
                                  child: isEditSI
                                      ? Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              height: height/5.007,
                                              width: width/13.66,
                                              margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    allData[i].imgUrl!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: width/136.6,
                                              top: height/65.1,
                                              child: InkWell(
                                                onTap: () {
                                                  GalleryFireCrud.deleteImage(
                                                      allData[i].id!, 'SI');
                                                },
                                                child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.red,
                                                  child: Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
      
                                          ],
                                        )
                                      : Container(
                                          height: height/5.007,
                                          width: width/13.66,
                                          margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                allData[i].imgUrl!,
                                              ),
                                            ),
                                          ),
                                        ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.08),
              Container(
                height: size.height * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Constants().primaryAppColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width/68.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            KText(
                              text: "PHOTO GALLERY",
                              style: GoogleFonts.openSans(
                                fontSize: width/62.09,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            isEditGI
                                ? Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isEditGI = false;
                                          });
                                        },
                                        child: KText(
                                          text: "Apply",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/75.88,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Row(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          addImage('GI',size);
                                        },
                                        child: KText(
                                          text: "ADD",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/75.88,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.add_circle,
                                      ),
                                      SizedBox(width: width/91.06),
                                      InkWell(
                                        onTap: () {
                                          setState(() {
                                            isEditGI = true;
                                          });
                                        },
                                        child: KText(
                                          text: "EDIT",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/75.88,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      Icon(
                                        Icons.edit_note,
                                      ),
                                      SizedBox(width: width/91.06),
                                      InkWell(
                                        onTap: () {
                                          showImageGidView(context, 'GI');
                                        },
                                        child: KText(
                                          text: "VIEW MORE",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/75.88,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      RotatedBox(
                                        quarterTurns: 3,
                                        child: Icon(
                                          Icons.expand_circle_down_outlined,
                                        ),
                                      ),
                                    ],
                                  )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: StreamBuilder(
                        stream: GalleryFireCrud.fetchGalleryImages(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container();
                          } else if (snapshot.hasData) {
                            List<GalleryImageModel> allData = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: allData.length,
                              itemBuilder: (ctx, i) {
                                return InkWell(
                                  onTap: () {
                                    showImageModel(context, allData[i].imgUrl!);
                                  },
                                  child: isEditGI
                                      ? Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            Container(
                                              height: height/5.007,
                                              width: width/13.66,
                                              margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                                image: DecorationImage(
                                                  fit: BoxFit.fill,
                                                  image: NetworkImage(
                                                    allData[i].imgUrl!,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              right: width/136.6,
                                              top: height/65.1,
                                              child: InkWell(
                                                onTap: () {
                                                  GalleryFireCrud.deleteImage(
                                                      allData[i].id!, 'GI');
                                                },
                                                child: CircleAvatar(
                                                  radius: 15,
                                                  backgroundColor: Colors.red,
                                                  child: Icon(
                                                    Icons.remove_circle_outline,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        )
                                      : Container(
                                          height: height/5.007,
                                          width: width/13.66,
                                          margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              fit: BoxFit.fill,
                                              image: NetworkImage(
                                                allData[i].imgUrl!,
                                              ),
                                            ),
                                          ),
                                        ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(height: size.height * 0.08),
              Container(
                height: size.height * 0.3,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Constants().primaryAppColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      offset: Offset(1, 2),
                      blurRadius: 3,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    SizedBox(
                      height: size.height * 0.1,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: width/68.3),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            KText(
                              text: "VIDEO CEREMONIES",
                              style: GoogleFonts.openSans(
                                fontSize: width/62.09,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            isEditVG
                                ? Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isEditVG = false;
                                    });
                                  },
                                  child: KText(
                                    text: "Apply",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/75.88,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            )
                                : Row(
                              children: [
                                InkWell(
                                  onTap: () {
                                    addVideoPopUp();
                                  },
                                  child: KText(
                                    text: "ADD",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/75.88,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.add_circle,
                                ),
                                SizedBox(width: width/91.06),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      isEditVG = true;
                                    });
                                  },
                                  child: KText(
                                    text: "EDIT",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/75.88,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.edit_note,
                                ),
                                SizedBox(width: width/91.06),
                                InkWell(
                                  onTap: () {
                                    //showImageGidView(context, 'GI');
                                  },
                                  child: KText(
                                    text: "VIEW MORE",
                                    style: GoogleFonts.openSans(
                                      fontSize: width/75.88,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                RotatedBox(
                                  quarterTurns: 3,
                                  child: Icon(
                                    Icons.expand_circle_down_outlined,
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: size.height * 0.2,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                      child: StreamBuilder(
                        stream: GalleryFireCrud.fetchVideoGallery(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return Container();
                          } else if (snapshot.hasData) {
                            List<GalleryVideoModel> allData = snapshot.data!;
                            return ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: allData.length,
                              itemBuilder: (ctx, i) {
                                return InkWell(
                                  onTap: () {
                                    _controller = VideoPlayerController.networkUrl(Uri.parse( allData[i].videoUrl!))
                                      ..initialize().then((_) {
                                        _controller.play();
                                        showVideoModel(context);
                                      });
                                  },
                                  child: isEditVG
                                      ? Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Container(
                                        height: height/5.007,
                                        width: width/13.66,
                                        margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                          //color: Colors.red,
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(
                                              allData[i].thumbUrl!,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        right: width/136.6,
                                        top: height/65.1,
                                        child: InkWell(
                                          onTap: () {
                                            GalleryFireCrud.deleteVideo(allData[i].id!);
                                          },
                                          child: CircleAvatar(
                                            radius: 15,
                                            backgroundColor: Colors.red,
                                            child: Icon(
                                              Icons.remove_circle_outline,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                      : Container(
                                    height: height/5.007,
                                    width: width/13.66,
                                    margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                            allData[i].thumbUrl!,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                        },
                      ),
                    )
                  ],
                ),
              ),
              //Expanded(child: Container()),
              SizedBox(height: size.height * 0.04),
              const DeveloperCardWidget(),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ),
    );
  }

  String thumbUrl = "";
  String videoUrl = "";

  addVideoPopUp() {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    Size size = MediaQuery.of(context).size;
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStat) {
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
                              "Add Video",
                              style: GoogleFonts.openSans(
                                fontSize: width / 68.3,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                setState(() {
                                  videoUrl = "";
                                  thumbUrl = "";
                                });
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
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () async {
                                    InputElement input = FileUploadInputElement() as InputElement
                                      ..accept = 'image/*';
                                    input.click();
                                    input.onChange.listen((event) {
                                      final file = input.files!.first;
                                      final reader = FileReader();
                                      reader.readAsDataUrl(file);
                                      reader.onLoadEnd.listen((event) async {
                                        thumbUrl = await GalleryFireCrud.uploadImageToStorage(file);
                                      });
                                    });
                                    setStat(() {});
                                    setState(() {});
                                },
                                child: Container(
                                  height: 100,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                    image: thumbUrl != "" ?  DecorationImage(
                                      fit: BoxFit.fill,
                                      image:NetworkImage(thumbUrl)
                                    ) : null,
                                  ),
                                  child: thumbUrl != "" ? null : Center(
                                    child: KText(
                                      text: "Add Thumbnail",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: () async {
                                  InputElement input = FileUploadInputElement() as InputElement
                                    ..accept = 'video/mp4';
                                  input.click();
                                  input.onChange.listen((event) {
                                    final file = input.files!.first;
                                    final reader = FileReader();
                                    reader.readAsDataUrl(file);
                                    reader.onLoadEnd.listen((event) async {
                                      videoUrl = await GalleryFireCrud.uploadVideoToStorage(file);
                                    });
                                  });
                                  setStat(() {});
                                  setState(() {});
                                },
                                child: Container(
                                  height: 100,
                                  width: 200,
                                  decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: videoUrl != "" ? KText(
                                    text: videoUrl,
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ) : Center(
                                    child: KText(
                                      text: "Add Video",
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 20),
                              InkWell(
                                onTap: () async {
                                  Response response = await GalleryFireCrud.addVideo(videoUrl, thumbUrl);
                                  if(response.code == 200){
                                    setStat(() {
                                      videoUrl = "";
                                      thumbUrl = "";
                                    });
                                    Navigator.pop(context);
                                  }else{
                                    setStat(() {
                                      videoUrl = "";
                                      thumbUrl = "";
                                    });
                                    Navigator.pop(context);
                                  }
                                  },
                                child: Container(
                                  height: 35,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    color: Constants().primaryAppColor,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text("Submit"),
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

  AwesomeDialog popup(context, bool isSuccess) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return AwesomeDialog(
      context: context,
      dialogType: isSuccess ? DialogType.success : DialogType.error,
      borderSide: BorderSide(
        color: isSuccess ? Colors.green : Colors.red,
        width: width/683,
      ),
      width: width/4.878,
      buttonsBorderRadius: BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      onDismissCallback: (type) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: KText(
              text: 'Dismissed by $type',
              style: TextStyle(),
            ),
          ),
        );
      },
      headerAnimationLoop: false,
      animType: AnimType.bottomSlide,
      title: isSuccess ? 'Done' : 'Failed',
      desc: isSuccess ? 'Event Created Successfully' : 'Failed to create event',
      showCloseIcon: true,
      btnCancelOnPress: () {},
      btnOkOnPress: () {},
    );
  }

  showImageModel(context, String imgUrl) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          insetPadding: EdgeInsets.all(12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(
                  vertical: height/217,
                  horizontal: width/455.33
                ),
                child: Container(
                  height: size.height * 0.8,
                  width: size.width * 0.6,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.fill,
                      image: NetworkImage(imgUrl),
                    )
                  ),
                )
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              Positioned(
                bottom: size.height * 0.04,
                right: size.width * 0.03,
                child: InkWell(
                  onTap: () async {
                    try {
                      final http.Response r = await http.get(
                        Uri.parse(imgUrl),
                      );
                      final data = r.bodyBytes;
                      final base64data = base64Encode(data);
                      final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');
                      a.download = 'image.jpg';
                      a.click();
                      a.remove();
                    } catch (e) {
                      print(e);
                    }
                    Navigator.pop(context);
                  },
                  child: Container(
                    height: height/16.275,
                    width: width/9.106666666666667,
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.download_rounded, color: Colors.white),
                        SizedBox(width: width/136.6),
                        Text(
                          "Download",
                          style: TextStyle(
                          color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }

  late VideoPlayerController _controller;

  showVideoModel(context) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          insetPadding: EdgeInsets.all(12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: height/217,
                      horizontal: width/455.33
                  ),
                  child: Container(
                    height: size.height * 0.8,
                    width: size.width * 0.6,
                    // decoration: BoxDecoration(
                    //     image: DecorationImage(
                    //       fit: BoxFit.fill,
                    //       image: NetworkImage(imgUrl),
                    //     )
                    // ),
                    child: _controller.value.isInitialized
                        ? AspectRatio(
                      aspectRatio: _controller.value.aspectRatio,
                      child: VideoPlayer(_controller),
                    ) : Container(),
                  )
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: CircleAvatar(
                  radius: 15,
                  backgroundColor: Colors.red,
                  child: Icon(
                    Icons.cancel_outlined,
                    color: Colors.white,
                  ),
                ),
              ),
              // Positioned(
              //   bottom: size.height * 0.04,
              //   right: size.width * 0.03,
              //   child: InkWell(
              //     onTap: () async {
              //       try {
              //         final http.Response r = await http.get(
              //           Uri.parse(imgUrl),
              //         );
              //         final data = r.bodyBytes;
              //         final base64data = base64Encode(data);
              //         final a = html.AnchorElement(href: 'data:image/jpeg;base64,$base64data');
              //         a.download = 'image.jpg';
              //         a.click();
              //         a.remove();
              //       } catch (e) {
              //         print(e);
              //       }
              //       Navigator.pop(context);
              //     },
              //     child: Container(
              //       height: height/16.275,
              //       width: width/9.106666666666667,
              //       decoration: BoxDecoration(
              //         color: Constants().primaryAppColor,
              //         borderRadius: BorderRadius.circular(10),
              //       ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.center,
              //         children: [
              //           Icon(Icons.download_rounded, color: Colors.white),
              //           SizedBox(width: width/136.6),
              //           Text(
              //             "Download",
              //             style: TextStyle(
              //               color: Colors.white,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // )
            ],
          ),
        );
      },
    );
  }

  showImageGidView(context, String collection) {
    Size size = MediaQuery.of(context).size;
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          insetPadding: EdgeInsets.all(12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StreamBuilder(
            stream: collection.toUpperCase() == 'GI'
                ? FirebaseFirestore.instance
                    .collection('GalleryImages')
                    .snapshots()
                : FirebaseFirestore.instance
                    .collection('SliderImages')
                    .snapshots(),
            builder: (ctx, snapshot) {
              if (snapshot.hasError) {
                return Container();
              }
              return Container(
                height: size.height * 0.7,
                width: size.width * 0.7,
                decoration: BoxDecoration(
                  color: Constants().primaryAppColor,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(color: Colors.black26,offset: Offset(2,3),blurRadius: 3)
                  ]
                ),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.1,
                      padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: collection.toUpperCase() == 'GI' ? 'Photo Gallery' : 'Slider Images',
                            style: GoogleFonts.openSans(
                              fontSize: width/75.88,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                            },
                            child: KText(
                              text: 'Close',
                              style: GoogleFonts.openSans(
                                fontSize: width/75.88,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              crossAxisCount: 3,
                              childAspectRatio: 12 / 9,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, i) {
                              var data = snapshot.data!.docs[i];
                              return Padding(
                                padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: DecorationImage(
                                      fit: BoxFit.fill,
                                      image: NetworkImage(
                                        data['imgUrl'],
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }




}

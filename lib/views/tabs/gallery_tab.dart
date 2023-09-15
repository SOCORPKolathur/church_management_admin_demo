import 'dart:html';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:church_management_admin/constants.dart';
import 'package:church_management_admin/models/gallery_image_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';
import '../../models/response.dart';
import '../../services/gallery_firecrud.dart';
import '../../widgets/kText.dart';

class GalleryTab extends StatefulWidget {
  const GalleryTab({super.key});

  @override
  State<GalleryTab> createState() => _GalleryTabState();
}

class _GalleryTabState extends State<GalleryTab> with SingleTickerProviderStateMixin {

  bool isEditGI = false;
  bool isEditSI = false;
  late AnimationController lottieController;

  static Future<XFile> getImageXFileByUrl(String url) async {
    var file = await DefaultCacheManager().getSingleFile(url);
    XFile result = await XFile(file.path);
    return result;
  }

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
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: KText(
              text: 'GALLERY',
              style: GoogleFonts.openSans(
                fontSize: 32,
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
              boxShadow: const [
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "SLIDER IMAGES",
                          style: GoogleFonts.openSans(
                            fontSize: 22,
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
                                        fontSize: 18,
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.add_circle,
                                  ),
                                  const SizedBox(width: 15),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isEditSI = true;
                                      });
                                    },
                                    child: KText(
                                      text: "EDIT",
                                      style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.edit_note,
                                  ),
                                  const SizedBox(width: 15),
                                  InkWell(
                                    onTap: () {
                                      showImageGidView(context, 'SI');
                                    },
                                    child: KText(
                                      text: "VIEW MORE",
                                      style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const RotatedBox(
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
                  decoration: const BoxDecoration(
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
                                          height: 130,
                                          width: 100,
                                          margin: const EdgeInsets.all(20),
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
                                          right: 10,
                                          top: 10,
                                          child: InkWell(
                                            onTap: () {
                                              GalleryFireCrud.deleteImage(
                                                  allData[i].id!, 'SI');
                                            },
                                            child: const CircleAvatar(
                                              radius: 15,
                                              backgroundColor: Colors.red,
                                              child: Icon(
                                                Icons.remove_circle_outline,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          right: 10,
                                          bottom: 10,
                                          child: InkWell(
                                            onTap: () {
                                              GalleryFireCrud.deleteImage(
                                                  allData[i].id!, 'SI');
                                            },
                                            child: const CircleAvatar(
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
                                      height: 130,
                                      width: 100,
                                      margin: const EdgeInsets.all(20),
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
                        return const Center(
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
              boxShadow: const [
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
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        KText(
                          text: "PHOTO GALLERY",
                          style: GoogleFonts.openSans(
                            fontSize: 22,
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
                                        fontSize: 18,
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
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.add_circle,
                                  ),
                                  const SizedBox(width: 15),
                                  InkWell(
                                    onTap: () {
                                      setState(() {
                                        isEditGI = true;
                                      });
                                    },
                                    child: KText(
                                      text: "EDIT",
                                      style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const Icon(
                                    Icons.edit_note,
                                  ),
                                  const SizedBox(width: 15),
                                  InkWell(
                                    onTap: () {
                                      showImageGidView(context, 'GI');
                                    },
                                    child: KText(
                                      text: "VIEW MORE",
                                      style: GoogleFonts.openSans(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ),
                                  const RotatedBox(
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
                  decoration: const BoxDecoration(
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
                                          height: 130,
                                          width: 100,
                                          margin: const EdgeInsets.all(20),
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
                                          right: 10,
                                          top: 10,
                                          child: InkWell(
                                            onTap: () {
                                              GalleryFireCrud.deleteImage(
                                                  allData[i].id!, 'GI');
                                            },
                                            child: const CircleAvatar(
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
                                      height: 130,
                                      width: 100,
                                      margin: const EdgeInsets.all(20),
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
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  AwesomeDialog popup(context, bool isSuccess) {
    return AwesomeDialog(
      context: context,
      dialogType: isSuccess ? DialogType.success : DialogType.error,
      borderSide: BorderSide(
        color: isSuccess ? Colors.green : Colors.red,
        width: 2,
      ),
      width: 280,
      buttonsBorderRadius: const BorderRadius.all(
        Radius.circular(2),
      ),
      dismissOnTouchOutside: true,
      dismissOnBackKeyPress: false,
      onDismissCallback: (type) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: KText(
              text: 'Dismissed by $type',
              style: const TextStyle(),
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
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              Padding(
                padding: const EdgeInsets.all(3.0),
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
                child: const CircleAvatar(
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
                    Share.share(Uri.parse(imgUrl).toString());
                  },
                  child: Container(
                    height: 35,
                    width: 80,
                    decoration: BoxDecoration(
                      color: Constants().primaryAppColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Center(
                      child: Text(
                        "Share",style: TextStyle(
                        color: Colors.white,
                      ),
                      ),
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

  showImageGidView(context, String collection) {
    Size size = MediaQuery.of(context).size;
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          surfaceTintColor: Colors.transparent,
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(12),
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
                  boxShadow: const [
                    BoxShadow(color: Colors.black26,offset: Offset(2,3),blurRadius: 3)
                  ]
                ),
                child: Column(
                  children: [
                    Container(
                      height: size.height * 0.1,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          KText(
                            text: collection.toUpperCase() == 'GI' ? 'Photo Gallery' : 'Slider Images',
                            style: GoogleFonts.openSans(
                              fontSize: 18,
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
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            bottomRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                          ),
                          color: Colors.white,
                        ),
                        child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 4.0,
                              mainAxisSpacing: 4.0,
                              crossAxisCount: 3,
                              childAspectRatio: 12 / 9,
                            ),
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (ctx, i) {
                              var data = snapshot.data!.docs[i];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
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

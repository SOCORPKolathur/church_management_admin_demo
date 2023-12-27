import 'dart:convert';
import 'dart:html';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:video_player/video_player.dart';
import '../../constants.dart';
import '../../widgets/developer_card_widget.dart';
import '../../widgets/kText.dart';

class AudioPodcastTab extends StatefulWidget {
  const AudioPodcastTab({super.key});

  @override
  State<AudioPodcastTab> createState() => _AudioPodcastTabState();
}

class _AudioPodcastTabState extends State<AudioPodcastTab> {


  TextEditingController episodeController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController volumeController = TextEditingController();
  TextEditingController vocalController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  File? profileImage;
  File? selectedAudio;
  var uploadedImage;
  String? selectedImg;
  String currentTab = 'View';

  clearTextControllers(){
    setState(() {
      episodeController.clear();
      titleController.clear();
      volumeController.clear();
      vocalController.clear();
      descriptionController.clear();
      profileImage = null;
      uploadedImage = null;
      selectedImg = null;
      selectedAudio = null;
    });
  }

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

  selectAudio() {
    InputElement input = FileUploadInputElement() as InputElement
      ..accept = 'audio/*';
    input.click();
    input.onChange.listen((event) {
      final file = input.files!.first;
      FileReader reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        setState(() {
          selectedAudio = file;
        });
      });
      setState(() {});
    });
  }

  final _keyEpisode = GlobalKey<FormFieldState>();
  final _keyTitle = GlobalKey<FormFieldState>();
  final _keyVolume = GlobalKey<FormFieldState>();
  final _keyVocal = GlobalKey<FormFieldState>();
  final _keyDescription = GlobalKey<FormFieldState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double height = size.height;
    double width = size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  KText(
                    text: "Audio Podcast",
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
                              text: currentTab.toUpperCase() == "VIEW" ? "Add Podcast" : "View Podcasts",
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
                                  width:width/1.2418,
                                  margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
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
                                  child : Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                              KText(
                                text: "ADD NEW PODCAST",
                                style: GoogleFonts.openSans(
                                  fontSize: width/68.3,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  if(!isLoading){
                                    setState(() {
                                      isLoading = true;
                                    });
                                    if (
                                    selectedAudio != null &&
                                        _keyEpisode.currentState!.validate() &&
                                        _keyVolume.currentState!.validate() &&
                                        _keyVocal.currentState!.validate() &&
                                        _keyTitle.currentState!.validate()
                                    ) {
                                      String thumbUrl = '';
                                      if(profileImage != null){
                                        thumbUrl = await uploadImageToStorage(profileImage);
                                      }
                                      String audioUrl = '';
                                      if(selectedAudio != null){
                                        audioUrl = await uploadAudioToStorage(selectedAudio);
                                      }
                                      FirebaseFirestore.instance.collection('AudioPodcasts').doc().set({
                                        "date" : DateFormat('dd-MM-yyyy').format(DateTime.now()),
                                        "time" : DateFormat('hh:mm aa').format(DateTime.now()),
                                        "title" : titleController.text,
                                        "description" : descriptionController.text,
                                        "vocal" : vocalController.text,
                                        "episode" : episodeController.text,
                                        "volume" : volumeController.text,
                                        "timestamp" : DateTime.now().millisecondsSinceEpoch,
                                        "audioUrl" : audioUrl,
                                        "thumbUrl" : thumbUrl,
                                      }).then((value) async {
                                        await CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.success,
                                            text: "Podcast added successfully!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                        clearTextControllers();
                                        setState(() {
                                          isLoading = false;
                                          currentTab = 'VIEW';
                                        });
                                      }).catchError((e){
                                        setState(() {
                                          isLoading = false;
                                        });
                                        CoolAlert.show(
                                            context: context,
                                            type: CoolAlertType.error,
                                            text: "Failed to add podcast!",
                                            width: size.width * 0.4,
                                            backgroundColor: Constants()
                                                .primaryAppColor
                                                .withOpacity(0.8));
                                      });
                                    } else {
                                      setState(() {
                                        isLoading = false;
                                      });
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(snackBar);
                                    }
                                  }
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
                                    padding:
                                    EdgeInsets.symmetric(horizontal:width/227.66),
                                    child: Center(
                                      child: KText(
                                        text: "ADD NOW",
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
                      Container(
                        height: size.height * 0.75,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: Color(0xffF7FAFC),
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(10),
                              bottomRight: Radius.circular(10),
                            )),
                        padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Episode *",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/97.571,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height/108.5),
                                        Material(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                          elevation: 10,
                                          child: SizedBox(
                                            height: height/13.02,
                                            width: width/9.106,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                              child: TextFormField(
                                                key: _keyEpisode,
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                onChanged: (val){
                                                  _keyEpisode.currentState!.validate();
                                                },
                                                decoration: InputDecoration(
                                                    border: InputBorder.none
                                                ),
                                                controller: episodeController,
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(width: width/68.3),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Volume *",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/97.571,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height/108.5),
                                        Material(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                          elevation: 10,
                                          child: SizedBox(
                                            height: height/13.02,
                                            width: width/9.106,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                              child: TextFormField(
                                                key: _keyVolume,
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                onChanged: (val){
                                                  _keyVolume.currentState!.validate();
                                                },
                                                controller: volumeController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: GoogleFonts.openSans(
                                                    fontSize: width/97.571,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                    SizedBox(width: width/68.3),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Vocal *",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/97.571,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height/108.5),
                                        Material(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                          elevation: 10,
                                          child: SizedBox(
                                            height: height/13.02,
                                            width: width/6.830,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                              child: TextFormField(
                                                key: _keyVocal,
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                onChanged: (val){
                                                  _keyVocal.currentState!.validate();
                                                },
                                                controller: vocalController,
                                                decoration: InputDecoration(
                                                  contentPadding: EdgeInsets.symmetric(vertical: 5),
                                                  border: InputBorder.none,
                                                  hintStyle: GoogleFonts.openSans(
                                                    fontSize: width/97.571,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: height/65.1),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Title *",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/97.571,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height/108.5),
                                        Material(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                          elevation: 10,
                                          child: SizedBox(
                                            height: height/10.850,
                                            width: size.width * 0.36,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                              child: TextFormField(
                                                key: _keyTitle,
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                onChanged: (val){
                                                  _keyTitle.currentState!.validate();
                                                },
                                                keyboardType: TextInputType.multiline,
                                                minLines: 1,
                                                maxLines: null,
                                                controller: titleController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: GoogleFonts.openSans(
                                                    fontSize: width/97.571,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(height: height/65.1),
                                Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        KText(
                                          text: "Description",
                                          style: GoogleFonts.openSans(
                                            fontSize: width/97.571,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        SizedBox(height: height/108.5),
                                        Material(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white,
                                          elevation: 10,
                                          child: SizedBox(
                                            height: height/6.510,
                                            width: size.width * 0.36,
                                            child: Padding(
                                              padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                              child: TextFormField(
                                                key: _keyDescription,
                                                validator: (val){
                                                  if(val!.isEmpty){
                                                    return 'Field is required';
                                                  }else{
                                                    return null;
                                                  }
                                                },
                                                keyboardType: TextInputType.multiline,
                                                minLines: 1,
                                                maxLines: 5,
                                                controller: descriptionController,
                                                decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintStyle: GoogleFonts.openSans(
                                                    fontSize: width/97.571,
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
                                SizedBox(height: height/65.1),
                                Row(
                                  children: [
                                    Container(
                                      height: size.height * 0.2,
                                      width: size.width * 0.10,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Icon(
                                        Icons.library_music_rounded,
                                        size: size.height * 0.2,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          selectedAudio != null ? selectedAudio!.name : "Please Select An Audio *",
                                          style: TextStyle(
                                            color: selectedAudio != null ? Colors.black : Colors.red,
                                          ),
                                        ),
                                        SizedBox(height: 10),
                                        InkWell(
                                          onTap: selectAudio,
                                          child: Container(
                                            height: 35,
                                            width: 100,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(10),
                                              color: Constants().primaryAppColor,
                                            ),
                                            child: Center(
                                              child: KText(
                                                text: selectedAudio == null ? "Select Audio" : 'Change Audio',
                                                style: TextStyle(
                                                  color: Constants().secondaryAppColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                )
                              ],
                            ),
                            InkWell(
                              onTap: selectImage,
                              child: Container(
                                height: size.height * 0.2,
                                width: size.width * 0.10,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    image: uploadedImage != null
                                        ? DecorationImage(
                                      fit: BoxFit.fill,
                                      image: MemoryImage(
                                        Uint8List.fromList(
                                          base64Decode(
                                              uploadedImage!.split(',').last),
                                        ),
                                      ),
                                    )
                                        : null),
                                child: uploadedImage != null
                                    ? null
                                    : Icon(
                                  Icons.add_photo_alternate,
                                  size: size.height * 0.2,
                                ),
                              ),
                            ),
                          ],
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
                                      color: Constants().secondaryAppColor,
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
                : SizedBox(
              height: size.height * 0.85,
              width: double.infinity,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('AudioPodcasts').orderBy("timestamp", descending: true).snapshots(),
                builder: (ctx, snap){
                  if(snap.hasData){
                    List<DocumentSnapshot> podcasts = [];
                    podcasts.addAll(snap.data!.docs);
                    return Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Material(
                        elevation: 3,
                        borderRadius: BorderRadius.circular(10),
                        child: Column(
                          children: [
                            Container(
                              height: height/13.02,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Constants().primaryAppColor,
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  topLeft: Radius.circular(10),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8.0,horizontal: 16),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Podcasts",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w700,
                                        fontSize: width/80.35294117647059,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(10),
                                  ),
                                ),
                                child: ListView.builder(
                                  itemCount: podcasts.length,
                                  itemBuilder: (ctx , i){
                                    var data = podcasts[i];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                      child: Container(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade100,
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(horizontal:10, vertical: 20),
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 100,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(10),
                                                  color: Colors.grey.shade100,
                                                  image: DecorationImage(
                                                    image: NetworkImage(data.get("thumbUrl"))
                                                  )
                                                ),
                                              ),
                                              SizedBox(width: 20),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  Text(
                                                    "Title : "+ data.get("title"),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    "Vocal : "+ data.get("vocal"),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    "Volume/Episode : "+ data.get("volume")+"/"+data.get("episode"),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                    "Date/Time : "+ data.get("date")+" "+ data.get("time"),
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.w400,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Expanded(child: Container()),
                                              Column(
                                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      viewPopup(data);
                                                    },
                                                    child: Container(
                                                      height: height /26.04,
                                                      width: width/19.51428571428571,
                                                      decoration:const BoxDecoration(
                                                        color: Color(0xff2baae4),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26,
                                                            offset:
                                                            Offset(1,2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets .symmetric(horizontal:width / 227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.remove_red_eye,
                                                                color: Colors.white,
                                                                size: width / 91.066,
                                                              ),
                                                              KText(
                                                                text: "View",
                                                                style: GoogleFonts.openSans(
                                                                  color: Colors.white,
                                                                  fontSize: width / 136.6,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      setState(() {
                                                        titleController.text = data.get("title");
                                                        descriptionController.text = data.get("description");
                                                        episodeController.text = data.get("episode");
                                                        volumeController.text = data.get("volume");
                                                        vocalController.text = data.get("vocal");
                                                        selectedImg = data.get("thumbUrl");
                                                        // dateController.text = data.get("date");
                                                        // date2Controller.text = data.get("toDate");
                                                        // timeController.text = data.get("fromTimeStr");
                                                        // timeController2.text = data.get("toTimeStr");
                                                        // titleController.text = data.get("title");
                                                        // locationController.text = data.get("location");
                                                        // reasonController.text = data.get("reason");
                                                        // phoneController.text = data.get("phone");
                                                        // addressController.text = data.get("address");
                                                        // fromTime = Timestamp.fromMillisecondsSinceEpoch(data.get("fromTime")).toDate();
                                                        // toTime = Timestamp.fromMillisecondsSinceEpoch(data.get("toTime")).toDate();
                                                        currentTab = 'View';
                                                      });
                                                      editPopUp(data,size);
                                                    },
                                                    child: Container(
                                                      height: height /26.04,
                                                      width: width/19.51428571428571,
                                                      decoration:const BoxDecoration(
                                                        color: Colors.orange,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26,
                                                            offset:
                                                            Offset(1,2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets .symmetric(horizontal:width / 227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.edit,
                                                                color: Colors.white,
                                                                size: width / 91.066,
                                                              ),
                                                              KText(
                                                                text: "Edit",
                                                                style: GoogleFonts.openSans(
                                                                  color: Colors.white,
                                                                  fontSize: width / 136.6,
                                                                  fontWeight: FontWeight.bold,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  InkWell(
                                                    onTap: () {
                                                      CoolAlert.show(
                                                          context:
                                                          context,
                                                          type: CoolAlertType.info,
                                                          text:
                                                          "${data.get("title")} will be deleted",
                                                          title:
                                                          "Delete this Record?",
                                                          width: size.width * 0.4,
                                                          backgroundColor: Constants().primaryAppColor.withOpacity(0.8),
                                                          showCancelBtn:true,
                                                          cancelBtnText:'Cancel',
                                                          cancelBtnTextStyle:
                                                          TextStyle( color: Colors.black),
                                                          onConfirmBtnTap: (){
                                                            FirebaseFirestore.instance.collection("AudioPodcasts").doc(data.id).delete();
                                                          });
                                                    },
                                                    child: Container(
                                                      height: height /26.04,
                                                      width: width/19.51428571428571,
                                                      decoration: const BoxDecoration(
                                                        color: Colors.red,
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.black26,
                                                            offset:
                                                            Offset(1,2),
                                                            blurRadius: 3,
                                                          ),
                                                        ],
                                                      ),
                                                      child: Padding(
                                                        padding: EdgeInsets .symmetric(horizontal:width / 227.66),
                                                        child: Center(
                                                          child: Row(
                                                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                            children: [
                                                              Icon(
                                                                Icons.cancel,
                                                                color: Colors.white,
                                                                size: width / 91.066,
                                                              ),
                                                              KText(
                                                                text: "Delete",
                                                                style: GoogleFonts.openSans(
                                                                  color: Colors.white,
                                                                  fontSize: width / 136.6,
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
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  }return Container();
                },
              ),
            ),
            SizedBox(height: size.height * 0.04),
            const DeveloperCardWidget(),
            SizedBox(height: size.height * 0.01),
          ],
        ),
      ),
    );
  }


  viewPopup(DocumentSnapshot snap) {
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
                          snap.get("title"),
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
                          SizedBox(height: 10),
                          Container(
                            width: size.width * 0.3,
                            height: size.height * 0.4,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.fill,
                                image: NetworkImage(snap.get("thumbUrl")),
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
                                          text: "Title",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text:
                                        "${snap.get("title")}",
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
                                          text: "Description",
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
                                          "${snap.get("description")}",
                                          style: TextStyle(fontSize: width/97.571),
                                        ),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: height / 32.55),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.15,
                                        child: KText(
                                          text: "Vocal",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text:
                                        "${snap.get("vocal")}",
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
                                          text: "Episode",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text:
                                        "${snap.get("episode")}",
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
                                          text: "Volume",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text:
                                        "${snap.get("volume")}",
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
                                          text: "Date",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text:
                                        "${snap.get("date")}",
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
                                          text: "Time",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize:width/85.375),
                                        ),
                                      ),
                                      Text(":"),
                                      SizedBox(width: width / 68.3),
                                      KText(
                                        text:
                                        "${snap.get("time")}",
                                        style: TextStyle(fontSize: width/97.571),
                                      )
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


  editPopUp(DocumentSnapshot snap, Size size) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(builder: (context, setStat) {
          return AlertDialog(
            backgroundColor: Colors.transparent,
            content: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width:width/1.2418,
                  margin: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
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
                  child : SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                KText(
                                  text: "EDIT PODCAST",
                                  style: GoogleFonts.openSans(
                                    fontSize: width/68.3,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                InkWell(
                                  onTap: () async {
                                    if(!isLoading){
                                      setStat(() {
                                        isLoading = true;
                                      });
                                      if (
                                          _keyEpisode.currentState!.validate() &&
                                          _keyVolume.currentState!.validate() &&
                                          _keyVocal.currentState!.validate() &&
                                          _keyTitle.currentState!.validate()
                                      ) {
                                        String thumbUrl = snap.get("thumbUrl");
                                        if(profileImage != null){
                                          thumbUrl = await uploadImageToStorage(profileImage);
                                        }
                                        String audioUrl = snap.get("audioUrl");
                                        if(selectedAudio != null){
                                          audioUrl = await uploadAudioToStorage(selectedAudio);
                                        }
                                        FirebaseFirestore.instance.collection('AudioPodcasts').doc(snap.id).update({
                                          "date" : snap.get("date"),
                                          "time" : snap.get("time"),
                                          "title" : titleController.text,
                                          "description" : descriptionController.text,
                                          "vocal" : vocalController.text,
                                          "episode" : episodeController.text,
                                          "volume" : volumeController.text,
                                          "timestamp" : snap.get("timestamp"),
                                          "audioUrl" : audioUrl,
                                          "thumbUrl" : thumbUrl,
                                        }).then((value) async {
                                          await CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.success,
                                              text: "Podcast updated successfully!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                          clearTextControllers();
                                          setStat(() {
                                            isLoading = false;
                                          });
                                          Navigator.pop(context);
                                        }).catchError((e){
                                          setStat(() {
                                            isLoading = false;
                                          });
                                          CoolAlert.show(
                                              context: context,
                                              type: CoolAlertType.error,
                                              text: "Failed to update podcast!",
                                              width: size.width * 0.4,
                                              backgroundColor: Constants()
                                                  .primaryAppColor
                                                  .withOpacity(0.8));
                                        });
                                      } else {
                                        setStat(() {
                                          isLoading = false;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(snackBar);
                                      }
                                    }
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
                                      padding:
                                      EdgeInsets.symmetric(horizontal:width/227.66),
                                      child: Center(
                                        child: KText(
                                          text: "UPDATE NOW",
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
                        Container(
                          height: size.height * 0.75,
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color: Color(0xffF7FAFC),
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(10),
                                bottomRight: Radius.circular(10),
                              )),
                          padding: EdgeInsets.symmetric(horizontal: width/68.3, vertical: height/32.55),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Episode *",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/97.571,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: height/108.5),
                                          Material(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white,
                                            elevation: 10,
                                            child: SizedBox(
                                              height: height/13.02,
                                              width: width/9.106,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                                child: TextFormField(
                                                  key: _keyEpisode,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  onChanged: (val){
                                                    _keyEpisode.currentState!.validate();
                                                  },
                                                  decoration: InputDecoration(
                                                      border: InputBorder.none
                                                  ),
                                                  controller: episodeController,
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: width/68.3),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Volume *",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/97.571,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: height/108.5),
                                          Material(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white,
                                            elevation: 10,
                                            child: SizedBox(
                                              height: height/13.02,
                                              width: width/9.106,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                                child: TextFormField(
                                                  key: _keyVolume,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  onChanged: (val){
                                                    _keyVolume.currentState!.validate();
                                                  },
                                                  controller: volumeController,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintStyle: GoogleFonts.openSans(
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                      SizedBox(width: width/68.3),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Vocal *",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/97.571,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: height/108.5),
                                          Material(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white,
                                            elevation: 10,
                                            child: SizedBox(
                                              height: height/13.02,
                                              width: width/6.830,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                                child: TextFormField(
                                                  key: _keyVocal,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  onChanged: (val){
                                                    _keyVocal.currentState!.validate();
                                                  },
                                                  controller: vocalController,
                                                  decoration: InputDecoration(
                                                    contentPadding: EdgeInsets.symmetric(vertical: 5),
                                                    border: InputBorder.none,
                                                    hintStyle: GoogleFonts.openSans(
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height/65.1),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Title *",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/97.571,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: height/108.5),
                                          Material(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white,
                                            elevation: 10,
                                            child: SizedBox(
                                              height: height/10.850,
                                              width: size.width * 0.36,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                                child: TextFormField(
                                                  key: _keyTitle,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  onChanged: (val){
                                                    _keyTitle.currentState!.validate();
                                                  },
                                                  keyboardType: TextInputType.multiline,
                                                  minLines: 1,
                                                  maxLines: null,
                                                  controller: titleController,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintStyle: GoogleFonts.openSans(
                                                      fontSize: width/97.571,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: height/65.1),
                                  Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          KText(
                                            text: "Description",
                                            style: GoogleFonts.openSans(
                                              fontSize: width/97.571,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: height/108.5),
                                          Material(
                                            borderRadius: BorderRadius.circular(5),
                                            color: Colors.white,
                                            elevation: 10,
                                            child: SizedBox(
                                              height: height/6.510,
                                              width: size.width * 0.36,
                                              child: Padding(
                                                padding: EdgeInsets.symmetric(vertical: height/81.375, horizontal: width/170.75),
                                                child: TextFormField(
                                                  key: _keyDescription,
                                                  validator: (val){
                                                    if(val!.isEmpty){
                                                      return 'Field is required';
                                                    }else{
                                                      return null;
                                                    }
                                                  },
                                                  keyboardType: TextInputType.multiline,
                                                  minLines: 1,
                                                  maxLines: 5,
                                                  controller: descriptionController,
                                                  decoration: InputDecoration(
                                                    border: InputBorder.none,
                                                    hintStyle: GoogleFonts.openSans(
                                                      fontSize: width/97.571,
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
                                  SizedBox(height: height/65.1),
                                  Row(
                                    children: [
                                      Container(
                                        height: size.height * 0.2,
                                        width: size.width * 0.10,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(
                                          Icons.library_music_rounded,
                                          size: size.height * 0.2,
                                        ),
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            width: 200,
                                            height: 30,
                                            child: Text(
                                              selectedAudio != null ? selectedAudio!.name : snap.get("audioUrl"),
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                          InkWell(
                                            onTap: (){
                                              InputElement input = FileUploadInputElement() as InputElement
                                                ..accept = 'audio/*';
                                              input.click();
                                              input.onChange.listen((event) {
                                                final file = input.files!.first;
                                                FileReader reader = FileReader();
                                                reader.readAsDataUrl(file);
                                                reader.onLoadEnd.listen((event) {
                                                  setStat(() {
                                                    selectedAudio = file;
                                                  });
                                                });
                                                setStat(() {});
                                              });
                                            },
                                            child: Container(
                                              height: 35,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(10),
                                                color: Constants().primaryAppColor,
                                              ),
                                              child: Center(
                                                child: KText(
                                                  text: selectedAudio == null ? "Select Audio" : 'Change Audio',
                                                  style: TextStyle(
                                                    color: Constants().secondaryAppColor,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  )
                                ],
                              ),
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
                                  height: size.height * 0.2,
                                  width: size.width * 0.10,
                                  decoration: BoxDecoration(
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
                                          fit: BoxFit.contain,
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
                            ],
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
                      width: size.width * 0.5,
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
                                  color: Constants().secondaryAppColor,
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
            ),
          );
        });
      },
    );
  }


  static Future<String> uploadImageToStorage(file) async {
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('dailyupdates')
        .child("${file.name}")
        .putBlob(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadAudioToStorage(file) async {
    var snapshot = await FirebaseStorage.instance
        .ref()
        .child('dailyupdates')
        .child("${file.name}")
        .putBlob(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
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

}

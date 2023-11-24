import 'package:church_management_admin/models/gallery_image_model.dart';
import 'package:church_management_admin/models/response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference SliderImageCollection = firestore.collection('SliderImages');
final CollectionReference GalleryImageCollection = firestore.collection('GalleryImages');
final CollectionReference VideoGalleryCollection = firestore.collection('VideoGallery');
final FirebaseStorage fs = FirebaseStorage.instance;

class GalleryFireCrud {

  static Stream<List<GalleryImageModel>> fetchSliderImages() => SliderImageCollection
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) =>
          GalleryImageModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList()
  );

  static Stream<List<GalleryImageModel>> fetchGalleryImages() => GalleryImageCollection
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) =>
          GalleryImageModel.fromJson(doc.data() as Map<String,dynamic>)).toList()
  );

  static Stream<List<GalleryVideoModel>> fetchVideoGallery() => VideoGalleryCollection
      .snapshots()
      .map((snapshot) =>
      snapshot.docs.map((doc) =>
          GalleryVideoModel.fromJson(doc.data() as Map<String,dynamic>)).toList()
  );

  static Future<Response> addImage(file,String colection) async {
    Response response = Response();
    String downloadUrl = await uploadImageToStorage(file);
    DocumentReference documentReferencer = colection.toUpperCase() == 'GI' ? GalleryImageCollection.doc() :  SliderImageCollection.doc();
    Map<String, dynamic> data = <String, dynamic>{"imgUrl": downloadUrl, "id" : documentReferencer.id};
    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = 'Success';
    }).catchError((e) {
      response.code = 500;
      response.message = 'Failed';
    });
    return response;
  }

  static Future<Response> addVideo(file) async {
    Response response = Response();
    String downloadUrl = await uploadVideoToStorage(file);
    DocumentReference documentReferencer = VideoGalleryCollection.doc();
    Map<String, dynamic> data = <String, dynamic>{"videoUrl": downloadUrl, "id" : documentReferencer.id};
    var result = await documentReferencer.set(data).whenComplete(() {
      response.code = 200;
      response.message = 'Success';
    }).catchError((e) {
      response.code = 500;
      response.message = 'Failed';
    });
    return response;
  }

  static Future<Response> deleteImage(String id, String collection) async {
    Response response = Response();
    DocumentReference documentReferencer = collection.toUpperCase() == 'GI' ? GalleryImageCollection.doc(id) :  SliderImageCollection.doc(id);
   var result = await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = 'Success';
    }).catchError((e) {
      response.code = 500;
      response.message = 'Failed';
    });
    return response;
  }

  static Future<Response> deleteVideo(String id) async {
    Response response = Response();
    DocumentReference documentReferencer = VideoGalleryCollection.doc(id);
    var result = await documentReferencer.delete().whenComplete(() {
      response.code = 200;
      response.message = 'Success';
    }).catchError((e) {
      response.code = 500;
      response.message = 'Failed';
    });
    return response;
  }

  static Future<String> uploadImageToStorage(file) async {
    var snapshot = await fs
        .ref()
        .child('dailyupdates')
        .child("${file.name}")
        .putBlob(file);
    String downloadUrl = await snapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  static Future<String> uploadVideoToStorage(file) async {
    String url = '';
    // var snapshot = await fs
    //     .ref()
    //     .child('dailyupdates')
    //     .child("${file.name}")
    //     .putBlob(file);
    // String downloadUrl = await snapshot.ref.getDownloadURL();
    // return downloadUrl;
    try{
      var snapshot = await fs
          .ref()
          .child('dailyupdates')
          .child("${file.name}")
          .putBlob(file);
      url = await snapshot.ref.getDownloadURL();
      print(url);
      return url;
    }catch (e){
      print(e);
      url = '';
    }
    return url;
  }


}
import 'dart:html';
import 'package:church_management_admin/models/blog_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';
import 'package:intl/intl.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference BlogCollection = firestore.collection('Blogs');
final FirebaseStorage fs = FirebaseStorage.instance;

class BlogFireCrud {
  static Stream<List<BlogModel>> fetchBlogs() =>
      BlogCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => BlogModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());


  static Stream<List<BlogModel>> fetchBlogsWithFilter(DateTime start,DateTime end) =>
      BlogCollection
          .orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .where((element) => element['timestamp'] < end.add(const Duration(days: 1)).millisecondsSinceEpoch && element['timestamp'] >= start.millisecondsSinceEpoch)
          .map((doc) => BlogModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addBlog(
      {required File? image,
      required String description,
      required String title,
      required String time,
      required String author,
      }) async {
    String downloadUrl = '';
    if(image != null){
      downloadUrl = await uploadImageToStorage(image);
    }
    Response response = Response();
    DocumentReference documentReferencer = BlogCollection.doc();
    DateTime tempDate = DateFormat("dd-MM-yyyy").parse("${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}");
    BlogModel blog = BlogModel(

        id: "",
        timestamp: tempDate.millisecondsSinceEpoch,
        description: description,
        author: author,
        likes: [],
        title: title,
        time: time,
        views: [],
        imgUrl: downloadUrl,
    );
    blog.id = documentReferencer.id;
    var json = blog.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
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

  static Future<Response> updateRecord(BlogModel blog,File? image,String imgUrl) async {
    Response res = Response();
    if(image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      blog.imgUrl = downloadUrl;
    }else{
      blog.imgUrl = imgUrl;
    }
    DocumentReference documentReferencer = BlogCollection.doc(blog.id);
    var result = await documentReferencer.update(blog.toJson()).whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Updated from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }

  static Future<Response> deleteRecord({required String id}) async {
    Response res = Response();
    DocumentReference documentReferencer = BlogCollection.doc(id);
    var result = await documentReferencer.delete().whenComplete((){
      res.code = 200;
      res.message = "Sucessfully Deleted from database";
    }).catchError((e){
      res.code = 500;
      res.message = e;
    });
    return res;
  }
}

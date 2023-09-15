import 'dart:html';
import 'package:church_management_admin/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference UserCollection = firestore.collection('Users');
final FirebaseStorage fs = FirebaseStorage.instance;

class UserFireCrud {

  static Stream<List<UserModel>> fetchUsers() =>
      UserCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());


  static Stream<List<UserModel>> fetchUsersWithFilter(String profession) =>
      UserCollection
          .where("profession", isEqualTo: profession.toUpperCase())
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addUser(
      {required File image,
        required String baptizeDate,
        required String anniversaryDate,
        required String maritialStatus,
        required String bloodGroup,
        required String dob,
        required String email,
        required String firstName,
        required String lastName,
        required String locality,
        required String phone,
        required String profession,
        //required String password,
        required String about,
        required String address,
      }) async {
    String downloadUrl = await uploadImageToStorage(image);
    Response response = Response();
    DocumentReference documentReferencer = UserCollection.doc();
    UserModel user = UserModel(
        id: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
        profession: profession.toUpperCase(),
        phone: phone,
        locality: locality,
        lastName: lastName,
        firstName: firstName,
        maritialStatus: maritialStatus,
        email: email,
        dob: dob,
        about: about,
        address: address,
        //password: password,
        bloodGroup: bloodGroup,
        baptizeDate: baptizeDate,
        anniversaryDate: anniversaryDate,
        imgUrl: downloadUrl);
    user.id = documentReferencer.id;
    var json = user.toJson();
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

  static Future<Response> updateRecord(UserModel user,File? image,String imgUrl) async {
    Response res = Response();
    if(image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      user.imgUrl = downloadUrl;
    }else{
      user.imgUrl = imgUrl;
    }
    DocumentReference documentReferencer = UserCollection.doc(user.id);
    var result = await documentReferencer.update(user.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = UserCollection.doc(id);
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

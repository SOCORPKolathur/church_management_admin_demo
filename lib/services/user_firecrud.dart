import 'dart:html';
import 'dart:math';
import 'package:church_management_admin/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference UserCollection = firestore.collection('Users');
final FirebaseStorage fs = FirebaseStorage.instance;

class UserFireCrud {

  static String generateRandomString(int len) {
    var r = Random();
    const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    return List.generate(len, (index) => _chars[r.nextInt(_chars.length)])
        .join();
  }

  static Stream<List<UserModel>> fetchUsers() =>
      UserCollection.orderBy("timestamp", descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());


  static Stream<List<UserModel>> fetchUsersWithFilter(String profession) =>
      UserCollection
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Stream<List<UserModel>> fetchUsersWithBlood(String type) =>
      UserCollection
          .where("bloodGroup", isEqualTo: type)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => UserModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addUser(
      {required File? image,
        required String baptizeDate,
        required String anniversaryDate,
        required String maritialStatus,
        required String gender,
        required String bloodGroup,
        required String dob,
        required String email,
        required String prefix,
        required String firstName,
        required String middleName,
        required String lastName,
        required String locality,
        required String phone,
        required String aadharNo,
        required String pincode,
        required String profession,
        required String qualification,
        required String about,
        required String address,
        required String nationality,
        required String houseType,
      }) async {
    String downloadUrl = '';
    if(image != null){
      downloadUrl =  await uploadImageToStorage(image);
    }
    Response response = Response();
    DocumentReference documentReferencer = UserCollection.doc();

    UserModel user = UserModel(
        id: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
        profession: profession.toUpperCase(),
        phone: phone,
        locality: locality,
        lastName: lastName,
        qualification: qualification,
        fcmToken: "",
        firstName: firstName,
        middleName: middleName,
        prefix: prefix,
        maritialStatus: maritialStatus,
        gender: gender,
        email: email,
        aadharNo: aadharNo,
        isPrivacyEnabled: false,
        status: true,
        nationality: nationality,
        houseType: houseType,
        dob: dob,
        about: about,
        address: address,
        bloodGroup: bloodGroup,
        baptizeDate: baptizeDate,
        pincode: pincode,
        anniversaryDate: anniversaryDate,
        imgUrl: downloadUrl);
    user.id = documentReferencer.id;
    var json = user.toJson();
    print(json);
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

  static Future<Response> updateRecord(String userDocId, UserModel user,File? image,String imgUrl) async {
    Response res = Response();
    if(image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      user.imgUrl = downloadUrl;
    }else{
      user.imgUrl = imgUrl;
    }
    DocumentReference documentReferencer = UserCollection.doc(userDocId);
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

  static Future<Response> bulkUploadUser(Excel excel) async {
    Response res = Response();
    final row = excel.tables[excel.tables.keys.first]!.rows
        .map((e) => e.map((e) => e!.value).toList()).toList();
    for (int i = 1; i < row.length; i++) {
      String documentID = generateRandomString(20);
      UserModel user = UserModel(
        prefix: "",
        firstName: row[i][1].toString(),
        middleName: "",
        lastName: row[i][2].toString(),
        phone: row[i][3].toString(),
        email: row[i][4].toString(),
        profession: row[i][5].toString(),
        baptizeDate: row[i][6].toString(),
        maritialStatus: row[i][7].toString(),
        gender: row[i][8].toString(),
        bloodGroup: row[i][9].toString(),
        dob: row[i][10].toString(),
        pincode: row[i][11].toString(),
        address: row[i][12].toString(),
        about: row[i][13].toString(),
        anniversaryDate: row[i][14].toString(),
        aadharNo: row[i][15].toString(),
        qualification: row[i][16].toString(),
        locality: row[i][17].toString(),
        nationality: row[i][18].toString(),
        houseType: row[i][19].toString(),

        id: documentID,
        timestamp: DateTime.now().millisecondsSinceEpoch,
        imgUrl: "",
        fcmToken: "",
        status: true,
        isPrivacyEnabled: false,
        //   id: documentID,
        //   firstName: row[i][1].toString(),
        //   lastName: row[i][2].toString(),
        //   timestamp: DateTime.now().millisecondsSinceEpoch,
        //   address: row[i][12].toString(),
        //   imgUrl: "",
        //   phone: row[i][3].toString(),
        //   email: row[i][4].toString(),
        //   about: row[i][13].toString(),
        //   dob: row[i][10].toString(),
        //   gender:row[i][8].toString(),
        //   status: true,
        //   bloodGroup: row[i][9].toString(),
        //   baptizeDate: row[i][6].toString(),
        //   anniversaryDate: row[i][14].toString(),
        //   pincode: row[i][11].toString(),
        //   maritialStatus: row[i][7].toString(),
        //   profession: row[i][5].toString(),
        //   aadharNo: row[i][15].toString(),
        //   fcmToken: "",
        //   locality: "",
        // qualification: "",
        // nationality: "",
        // houseType: "",
        // isPrivacyEnabled: false,
      );
      var json = user.toJson();
      await UserCollection.doc(documentID).set(
          json).whenComplete(() {
        res.code = 200;
        res.message = "Sucessfully Updated from database";
      }).catchError((e) {
        res.code = 500;
        res.message = e;
      });
    }
    return res;
  }


}

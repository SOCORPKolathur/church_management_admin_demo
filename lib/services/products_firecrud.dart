import 'dart:html';
import 'package:church_management_admin/models/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference ProductsCollection = firestore.collection('Products');
final FirebaseStorage fs = FirebaseStorage.instance;

class ProductsFireCrud {
  static Stream<List<ProductModel>> fetchProducts() =>
      ProductsCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => ProductModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());


  static Stream<List<ProductModel>> fetchClansWithSearch(String text) => ProductsCollection
      .orderBy("timestamp", descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .where((element) => (element['title'].toString().toLowerCase().startsWith(text)||
      element['price'].toString().toLowerCase().startsWith(text)||
      element['categories'].toString().toLowerCase().startsWith(text)))
      .map((doc) => ProductModel.fromJson(doc.data() as Map<String,dynamic>))
      .toList());


  static Future<Response> addProduct(
      {required File image,
      required String description,
      required String categories,
      required double price,
      required String sale,
      required String tags,
      required String title}) async {
    String downloadUrl = await uploadImageToStorage(image);
    Response response = Response();
    DocumentReference documentReferencer = ProductsCollection.doc();
    ProductModel product = ProductModel(
        id: "",
        timestamp: DateTime.now().millisecondsSinceEpoch,
        description: description,
        title: title,
        categories: categories,
        price: price,
        sale: sale,
        tags: tags,
        imgUrl: downloadUrl);
    product.id = documentReferencer.id;
    product.productId = documentReferencer.id;
    var json = product.toJson();
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

  static Future<Response> updateRecord(ProductModel product,File? image,String imgUrl) async {
    Response res = Response();
    if(image != null) {
      String downloadUrl = await uploadImageToStorage(image);
      product.imgUrl = downloadUrl;
    }else{
      product.imgUrl = imgUrl;
    }
    DocumentReference documentReferencer = ProductsCollection.doc(product.id);
    var result = await documentReferencer.update(product.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = ProductsCollection.doc(id);
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

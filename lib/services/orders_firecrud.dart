import 'package:church_management_admin/models/orders_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference OrdersCollection = firestore.collection('Orders');

class OrdersFireCrud {

  static Stream<List<OrdersModel>> fetchOrders() =>
      OrdersCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => OrdersModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Stream<List<OrdersModel>> fetchOrdersWithFilter(DateTime start,DateTime end) =>
      OrdersCollection
          .where("timestamp", isLessThanOrEqualTo: end.millisecondsSinceEpoch)
          .where("timestamp", isGreaterThanOrEqualTo: start.millisecondsSinceEpoch)
          .orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => OrdersModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> updateRecord(OrdersModel order) async {
    Response res = Response();
    DocumentReference documentReferencer = OrdersCollection.doc(order.id);
    var result = await documentReferencer.update(order.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = OrdersCollection.doc(id);
    var result = await documentReferencer.delete().whenComplete(() {
      res.code = 200;
      res.message = "Sucessfully Deleted from database";
    }).catchError((e) {
      res.code = 500;
      res.message = e;
    });
    return res;
  }
}

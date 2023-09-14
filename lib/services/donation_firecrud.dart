import 'package:church_management_admin/models/donation_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/response.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference DonationCollection = firestore.collection('Donations');

class DonationFireCrud {

  static Stream<List<DonationModel>> fetchDonations() =>
      DonationCollection.orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => DonationModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());

  static Stream<List<DonationModel>> fetchDonationsWithFilter(DateTime start,DateTime end) =>
      DonationCollection
          .where("timestamp", isLessThanOrEqualTo: end.millisecondsSinceEpoch)
          .where("timestamp", isGreaterThanOrEqualTo: start.millisecondsSinceEpoch)
          .orderBy("timestamp", descending: false)
          .snapshots()
          .map((snapshot) => snapshot.docs
          .map((doc) => DonationModel.fromJson(doc.data() as Map<String,dynamic>))
          .toList());

  static Future<Response> addDonation({
    required String description,
    required String date,
    required String amount,
    required String bank,
    required String source,
    required String verifier,
    required String via,
  }) async {
    Response response = Response();
    DocumentReference documentReferencer = DonationCollection.doc();
    DonationModel donation = DonationModel(
      id: "",
      timestamp: DateTime.now().millisecondsSinceEpoch,
      via: via,
      verifier: verifier,
      source: source,
      bank: bank,
      amount: amount,
      date: date,
      description: description,
    );
    donation.id = documentReferencer.id;
    var json = donation.toJson();
    var result = await documentReferencer.set(json).whenComplete(() {
      response.code = 200;
      response.message = "Sucessfully added to the database";
    }).catchError((e) {
      response.code = 500;
      response.message = e;
    });
    return response;
  }

  static Future<Response> updateRecord(DonationModel donation) async {
    Response res = Response();
    DocumentReference documentReferencer = DonationCollection.doc(donation.id);
    var result = await documentReferencer.update(donation.toJson()).whenComplete(() {
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
    DocumentReference documentReferencer = DonationCollection.doc(id);
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

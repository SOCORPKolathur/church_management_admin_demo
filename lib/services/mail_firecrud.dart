import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/mail_model.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference MailCollection = firestore.collection('mail');

class MailsFireCrud {
  static Stream<List<MailModel>> fetchMails() => MailCollection
      .orderBy("timestamp", descending: false)
      .snapshots()
      .map((snapshot) => snapshot.docs
      .map((doc) => MailModel.fromJson(doc.data() as Map<String,dynamic>))
      .toList());

}

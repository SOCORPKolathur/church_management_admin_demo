import 'package:church_management_admin/models/message_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final CollectionReference MessagesCollection = firestore.collection('Messages');

class MessagesFireCrud {

  static Stream<List<MessageModel>> fetchMessages() =>
      MessagesCollection
          .orderBy("timestamp",descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs
              .map((doc) => MessageModel.fromJson(doc.data() as Map<String,dynamic>))
              .toList());
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapple/models/chatMessageModel.dart';

class MessageService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> sendMessage(chatMessageModel newMsg, String chat_id) async {
    try {
      final docMsg =
          db.collection("chats").doc(chat_id).collection("messages").doc();
      String mid = docMsg.id;
      newMsg.id = mid;
      await docMsg.set(newMsg.toJson());
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  Stream<QuerySnapshot> getMessages(String chat_id) {
    try {
      return db
          .collection("chats")
          .doc(chat_id)
          .collection("messages")
          .orderBy("timeSent", descending: true)
          .snapshots();
    } catch (e) {
      print(e.toString());
      return Stream.empty();
    }
  }

  Future<bool> markAsSeen(String id, String senderID) async {
    try {
      final docMsg = db.collection("chats").doc(id).collection('messages').where('senderID', isNotEqualTo: senderID).get();
      for (var doc in (await docMsg).docs) {
        await doc.reference.update({'isRead': true});
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

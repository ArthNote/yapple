import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/chatModel.dart';

class ChatService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> startChat(chatModel newChat, BuildContext context) async {
    try {
      final docChat = db.collection("chats").doc();
      String cid = docChat.id;
      newChat.id = cid;
      await docChat.set(newChat.toJson());
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return false;
    }
  }

  Future<bool> checkChat(String uniqueID) async {
    try {
      final chatSnapshot = await db
        .collection("chats")
        .where("singleChatId", isEqualTo: uniqueID)
        .get();

      if (chatSnapshot.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getChats(String uid, BuildContext context) {
    try {
      return FirebaseFirestore.instance
          .collection("chats")
          .where('members', arrayContains: uid)
          .orderBy("timeSent", descending: true)
          .snapshots();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return Stream.empty();
    }
  }
}
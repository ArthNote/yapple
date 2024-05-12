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

  Future<String> getChatID(String uniqueID) async {
    try {
      final chatSnapshot = await db
          .collection("chats")
          .where("singleChatId", isEqualTo: uniqueID)
          .get();

      if (chatSnapshot.docs.isEmpty) {
        return "";
      } else {
        return chatSnapshot.docs[0].id;
      }
    } catch (e) {
      return '';
    }
  }

  Future<String> getChatName(String id) async {
    try {
      final chatSnapshot = await db.collection("chats").doc(id).get();
      return chatSnapshot.data()!['name'];
    } catch (e) {
      return '';
    }
  }

  Stream<QuerySnapshot> getTypedChats(
      String uid, BuildContext context, String type) {
    try {
      return FirebaseFirestore.instance
          .collection("chats")
          .where('type', isEqualTo: type)
          .where('membersId', arrayContains: uid)
          .orderBy("timeSent", descending: true)
          .snapshots();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return Stream.empty();
    }
  }

  Future<bool> updateChat(String id, String msg, Timestamp ts) async {
    try {
      final docChat = db.collection("chats").doc(id);
      await docChat.update({"lastMessage": msg, "timeSent": ts});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateChatInfo(chatModel chat) async {
    try {
      final docChat = db.collection("chats").doc(chat.id);
      await docChat.update({
        "name": chat.name,
        "members": chat.members.map((member) => member.toJson()).toList(),
        "membersId": chat.membersId
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

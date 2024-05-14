// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/chatMessageModel.dart';
import 'package:yapple/models/chatModel.dart';
import 'package:yapple/models/chatParticipantModel.dart';

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

  Future<void> updateChatProfile(
      String uid, String newPic, BuildContext context, String name) async {
    try {
      List<chatModel> chats = [];
      final documents = await db
          .collection("chats")
          .where('membersId', arrayContains: uid)
          .get();
      for (var element in documents.docs) {
        chats.add(chatModel.fromSnapshot(element));
      }
      for (chatModel chat in chats) {
        List<chatParticipantModel> oldMembers = chat.members;
        String chatID = chat.id;
        var oldMe = oldMembers.singleWhere((element) => element.id == uid);
        var newMe = chatParticipantModel(
          id: oldMe.id,
          name: name,
          email: oldMe.email,
          profilePicUrl: newPic,
          role: oldMe.role,
        );
        oldMembers.remove(oldMe);
        oldMembers.add(newMe);
        var docChat = db.collection("chats").doc(chatID);
        await docChat
            .update({"members": oldMembers.map((e) => e.toJson()).toList()});
        List<chatMessageModel> messages = [];
        final docMSGS = await db
            .collection("chats")
            .doc(chatID)
            .collection('messages')
            .where('senderID', isEqualTo: uid)
            .get();
        for (var element in docMSGS.docs) {
          messages.add(chatMessageModel.fromSnapshot(element));
        }
        for (chatMessageModel message in messages) {
          String messageID = message.id;
          var docMSG = db
              .collection("chats")
              .doc(chatID)
              .collection('messages')
              .doc(messageID);
          await docMSG.update({"sender": newMe.toJson()});
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("issue " + e.toString()),
      ));
      print(e.toString());
    }
  }

  Stream<QuerySnapshot> getTypedChats(
      String uid, BuildContext context, String type) {
    try {
      return db
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

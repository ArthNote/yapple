import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/feedbackModel.dart';

class FeedbackService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> sendFeedback(
      feedbackModel feedback, BuildContext context) async {
    try {
      final docFeedback = db.collection('feedback').doc();
      String fid = docFeedback.id;
      feedback.id = fid;
      await docFeedback.set(feedback.toJson());
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return false;
    }
  }

  Future<void> updateFeedbackSender(
      String uid, String newPic, BuildContext context, String name) async {
    try {
      List<feedbackModel> feedbacks = [];
      final documents = await db.collection("feedback").get();
      for (var element in documents.docs) {
        feedbacks.add(feedbackModel.fromSnapshot(element));
      }
      for (feedbackModel feedback in feedbacks) {
        String feedbackID = feedback.id;
        var sender = feedback.sender;
        if (sender.id == uid) {
          var newSender = feedbackSenderModel(
            id: sender.id,
            name: name,
            email: sender.email,
            profilePicUrl: newPic,
            role: sender.role,
          );
          var docFeedback = db.collection("feedback").doc(feedbackID);
          await docFeedback.update({"sender": newSender.toJson()});
        } else {
          print('not me');
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("issue " + e.toString()),
      ));
      print(e.toString());
    }
  }
}

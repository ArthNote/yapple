import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/feedbackModel.dart';

class FeedbackService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> sendFeedback(feedbackModel feedback, BuildContext context) async {
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
}
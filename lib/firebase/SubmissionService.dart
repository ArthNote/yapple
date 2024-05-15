import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/materialModel.dart';
import 'package:yapple/models/submissionModel.dart';

class SubmissionService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addSubmission(
      submissionModel submission,
      BuildContext context,
      String classID,
      String moduleID,
      String assignmentID) async {
    try {
      final docSub = db
          .collection("classes")
          .doc(classID)
          .collection("modules")
          .doc(moduleID)
          .collection("assignments")
          .doc(assignmentID)
          .collection('submissions')
          .doc();
      String aid = docSub.id;
      submission.id = aid;
      await docSub.set(submission.toJson());
      return {"success": true, "id": aid};
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return {"success": false, "id": ""};
    }
  }

  Future<bool> uploadSubmissionFiles(File file, String classID, String moduleID,
      materialModel material, String assignmentID, String submissionID) async {
    try {
      UploadTask? task;
      final ref = FirebaseStorage.instance
          .ref(
              'classes/$classID/modules/$moduleID/assignments/$assignmentID/submissions/$submissionID/')
          .child(material.id);
      task = ref.putFile(file);
      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      material.url = urlDownload;
      bool uploaded = await addSubmissionFiles(
          classID, moduleID, material, assignmentID, submissionID);
      if (uploaded) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addSubmissionFiles(String classID, String moduleID,
      materialModel material, String assignmentID, String submissionID) async {
    try {
      final docM = db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .collection('submissions')
          .doc(submissionID)
          .collection('files')
          .doc(material.id);
      await docM.set(material.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

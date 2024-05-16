// ignore_for_file: prefer_interpolation_to_compose_strings, avoid_print

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

  Future<List<submissionModel>> getAssignmentSubmissions(String classID, String moduleID, String assignmentID) async {
    try {
      final documents = await FirebaseFirestore.instance
          .collection("classes")
          .doc(classID)
          .collection('modules').doc(moduleID).collection('assignments').doc(assignmentID).collection('submissions').get();
      return documents.docs.map((e) => submissionModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> checkSubmission(
    String uid,
    String classID,
    String moduleID,
    String assignmentID,
  ) async {
    try {
      final subSnapshot = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .collection('submissions')
          .where("studentID", isEqualTo: uid)
          .get();

      if (subSnapshot.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> getSubmissionID(
    String uid,
    String classID,
    String moduleID,
    String assignmentID,
  ) async {
    try {
      final subSnapshot = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .collection('submissions')
          .where("studentID", isEqualTo: uid)
          .get();

      if (subSnapshot.docs.isEmpty) {
        return '';
      } else {
        return subSnapshot.docs[0].id;
      }
    } catch (e) {
      return '';
    }
  }

  Future<int> getSubmissionGrade(
    String submissionID,
    String classID,
    String moduleID,
    String assignmentID,
  ) async {
    try {
      final subSnapshot = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .collection('submissions')
          .doc(submissionID)
          .get();

      if (subSnapshot.exists) {
        print('db grade is ' + subSnapshot.get('grade').toString());
        return subSnapshot.get('grade');
      } else {
        return 0;
      }
    } catch (e) {
      return 0;
    }
  }

  Future<bool> getSubmissionGradeStatus(
    String submissionID,
    String classID,
    String moduleID,
    String assignmentID,
  ) async {
    try {
      final subSnapshot = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .collection('submissions')
          .doc(submissionID)
          .get();

      if (subSnapshot.exists) {
        return subSnapshot.get('isGraded');
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> getSubmissionComment(
    String submissionID,
    String classID,
    String moduleID,
    String assignmentID,
  ) async {
    try {
      final subSnapshot = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .collection('submissions')
          .doc(submissionID)
          .get();

      if (subSnapshot.exists) {
        return subSnapshot.get('comment');
      } else {
        return '';
      }
    } catch (e) {
      return '';
    }
  }

  Future<bool> gradeSubmission(
    String submissionID,
    String classID,
    String moduleID,
    String assignmentID,
    int grade,
  ) async {
    try {
      await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .collection('submissions')
          .doc(submissionID).update({'isGraded': true, 'grade': grade});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> commentSubmission(
    String submissionID,
    String classID,
    String moduleID,
    String assignmentID,
    String comment,
  ) async {
    try {
      await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .collection('submissions')
          .doc(submissionID)
          .update({'comment': comment});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<materialModel>> getSubmissionFiles(String uid, String classID,
      String moduleID, String assignmentID, String submissionID) async {
    try {
      final documents = await FirebaseFirestore.instance
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .collection('submissions')
          .doc(submissionID)
          .collection('files')
          .get();
      return documents.docs.map((e) => materialModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
}

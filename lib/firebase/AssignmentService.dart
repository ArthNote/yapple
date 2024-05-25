import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/assignmentModel.dart';
import 'package:yapple/models/materialModel.dart';

class AssignmentService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> addAssignment(assignmentModel assigment,
      BuildContext context, String classID, String moduleID) async {
    try {
      final docAss = db
          .collection("classes")
          .doc(classID)
          .collection("modules")
          .doc(moduleID)
          .collection("assignments")
          .doc();
      String aid = docAss.id;
      assigment.id = aid;
      await docAss.set(assigment.toJson());
      return {"success": true, "id": aid};
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return {"success": false, "id": ""};
    }
  }

  Future<List<assignmentModel>> getModuleAssignment(
      String classID, String moduleID) async {
    try {
      final documents = await FirebaseFirestore.instance
          .collection("classes")
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .get();
      return documents.docs
          .map((e) => assignmentModel.fromSnapshot(e))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<materialModel>> getAssignmentMaterials(
      String classID, String moduleID, String assigmentID) async {
    try {
      final documents = await db
          .collection("classes")
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assigmentID)
          .collection('materials')
          .get();
      return documents.docs.map((e) => materialModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> deleteModuleMaterial(String classID, String moduleID,
      String materialID, String assigmentID) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection("classes")
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assigmentID)
          .collection('materials')
          .doc(materialID);
      await document.delete();
      final ref = FirebaseStorage.instance
          .ref(
              'classes/$classID/modules/$moduleID/assignments/$assigmentID/materials/')
          .child(materialID);
      await ref.delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> editAssignmentAbout(
    String submissionID,
    String classID,
    String moduleID,
    String assignmentID,
    String about,
  ) async {
    try {
      await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .update({'description': about});
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateStudentInfo(
      String uid, BuildContext context, String name) async {
    try {
      final documents = await db.collection("classes").get();
      for (var Class in documents.docs) {
        var modulesDocs = await db
            .collection("classes")
            .doc(Class.id)
            .collection('modules')
            .get();
        for (var module in modulesDocs.docs) {
          var assignmentsDocs = await db
              .collection("classes")
              .doc(Class.id)
              .collection('modules')
              .doc(module.id)
              .collection('assignments')
              .get();
          if (assignmentsDocs.docs.isEmpty) {
            print('No assignments');
          } else {
            for (var assignment in assignmentsDocs.docs) {
              var submissionsDocs = await db
                  .collection("classes")
                  .doc(Class.id)
                  .collection('modules')
                  .doc(module.id)
                  .collection('assignments')
                  .doc(assignment.id)
                  .collection('submissions')
                  .where('studentID', isEqualTo: uid)
                  .get();
              if (submissionsDocs.docs.isEmpty) {
                print('No submissions');
              } else {
                for (var submission in submissionsDocs.docs) {
                  await db
                      .collection("classes")
                      .doc(Class.id)
                      .collection('modules')
                      .doc(module.id)
                      .collection('assignments')
                      .doc(assignment.id)
                      .collection('submissions')
                      .doc(submission.id)
                      .update({
                    'studentName': name,
                  });
                }
              }
            }
          }
        }
      }
    } catch (e) {
      print(e);
    }
  }
}

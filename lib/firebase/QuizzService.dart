import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/quizzModel.dart';
import 'package:yapple/models/quizzSubmission.dart';

class QuizzService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> createQuizz(quizzModel quizz, BuildContext context,
      String classID, String moduleID) async {
    try {
      final docQuizz = db
          .collection("classes")
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('quizzes')
          .doc();
      String cid = docQuizz.id;
      quizz.id = cid;
      await docQuizz.set(quizz.toJson());
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return false;
    }
  }


  Future<List<quizzModel>> getQuizzes(BuildContext context,
      String classID, String moduleID) async {
    try {
      final docQuizz = await db
          .collection("classes")
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('quizzes').get();
      return docQuizz.docs
          .map((doc) => quizzModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return [];
    }
  }

  Future<List<quizzSubmission>> getQuizzeSubmissions(
      BuildContext context, String classID, String moduleID, String quizzID) async {
    try {
      final docQuizz = await db
          .collection("classes")
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('quizzes').doc(quizzID).collection('submissions').get();
      return docQuizz.docs.map((doc) => quizzSubmission.fromSnapshot(doc)).toList();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return [];
    }
  }

  Future<bool> submitQuizz(quizzSubmission submission, BuildContext context,
      String classID, String moduleID, String quizzID) async {
    try {
      final docQuizz = db
          .collection("classes")
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('quizzes')
          .doc(quizzID).collection('submissions').doc();
      String cid = docQuizz.id;
      submission.id = cid;
      await docQuizz.set(submission.toJson());
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return false;
    }
  }

  Future<Map<String, dynamic>> checkSubmission(BuildContext context,
      String classID, String moduleID, String quizzID, String uid) async {
    try {
      final docQuizz = await db
          .collection("classes")
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('quizzes')
          .doc(quizzID)
          .collection('submissions').where('studentID', isEqualTo: uid).get();
      if (docQuizz.docs.isEmpty) {
        return {
          'exists': false,
          'grade': '',
        };
      } else {
        return {
          'exists': true,
          'grade': docQuizz.docs[0].data()['grade'],
        };
      } 
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return {
        'exists': false,
        'grade': '',
      };
    }
  }

  Future<void> updateStudentInfo(
      String uid, String name) async {
    try {
    
      final documents = await db.collection("classes").get();
      for (var Class in documents.docs) {
        var modulesDocs = await db
            .collection("classes")
            .doc(Class.id)
            .collection('modules')
            .get();
        for (var module in modulesDocs.docs) {
          var quizzesDocs = await db
              .collection("classes")
              .doc(Class.id)
              .collection('modules').doc(module.id).collection('quizzes').get();
          if (quizzesDocs.docs.isEmpty) {
            print('No quizzes');
          } else{
            for (var quiz in quizzesDocs.docs) {
              var submissionsDocs = await db
                  .collection("classes")
                  .doc(Class.id)
                  .collection('modules').doc(module.id).collection('quizzes').doc(quiz.id).collection('submissions').where('studentID', isEqualTo: uid).get();
              if (submissionsDocs.docs.isEmpty) {
                print('No submissions');
              } else {
                for (var submission in submissionsDocs.docs) {
                  await db
                      .collection("classes")
                      .doc(Class.id)
                      .collection('modules').doc(module.id).collection('quizzes').doc(quiz.id).collection('submissions').doc(submission.id).update({
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

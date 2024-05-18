// ignore_for_file: empty_catches

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapple/models/gradeModel.dart';

class GradeService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<gradeModel>> getGrades(
      String classID, String uid, String moduleID, String moduleName) async {
    try {
      List<gradeModel> grades = [];
      final assignments = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .get();
      if (assignments.docs.isEmpty) {
        print('No assignments');
      } else {
        for (var assignment in assignments.docs) {
          final submission = await db
              .collection('classes')
              .doc(classID)
              .collection('modules')
              .doc(moduleID)
              .collection('assignments')
              .doc(assignment.id)
              .collection('submissions')
              .where('studentID', isEqualTo: uid)
              .get();
          if (submission.docs.isEmpty) {
            print('No submission');
          } else {
            for (var sub in submission.docs) {
              grades.add(gradeModel(
                moduleID: moduleID,
                moduleName: moduleName,
                studentID: uid,
                title: assignment['title'] ?? 'idk',
                grade: sub['grade'].toString() ?? 'idk',
                type: 'assignment',
              ));
            }
          }
        }
      }

      final quizzes = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('quizzes')
          .get();
      if (quizzes.docs.isEmpty) {
        print('No quizzes');
      } else {
        for (var quizz in quizzes.docs) {
          final submission = await db
              .collection('classes')
              .doc(classID)
              .collection('modules')
              .doc(moduleID)
              .collection('quizzes')
              .doc(quizz.id)
              .collection('submissions')
              .where('studentID', isEqualTo: uid)
              .get();
          if (submission.docs.isEmpty) {
            print('No submission');
          } else {
            for (var sub in submission.docs) {
              grades.add(gradeModel(
                moduleID: moduleID,
                moduleName: moduleName,
                studentID: uid,
                title: quizz['title'] ?? 'idk',
                grade: sub['grade'] ?? 'idk',
                type: 'quizz',
              ));
            }
          }
        }
      }
      return grades;
    } catch (e) {
      print(e);
      return [];
    }
  }
}

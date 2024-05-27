import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapple/models/sessionAttendee.dart';
import 'package:yapple/models/sessionModel.dart';
import 'package:yapple/models/studentModel.dart';

class SessionService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> createSessions(
      List<sessionModel> sessions, String moduleID, String classID) async {
    try {
      for (var session in sessions) {
        var Doc = await db
            .collection('classes')
            .doc(classID)
            .collection('modules')
            .doc(moduleID)
            .collection('sessions')
            .doc();
        session.id = Doc.id;
        await Doc.set(session.toJson());
        var students = await db
            .collection('students')
            .where('classID', isEqualTo: classID)
            .get();
        for (var student in students.docs) {
          var sessionStudents = await db
              .collection('classes')
              .doc(classID)
              .collection('modules')
              .doc(moduleID)
              .collection('sessions')
              .doc(session.id)
              .collection('students')
              .doc(student.id);
          await sessionStudents.set(
            sessionAttendee(
              id: student.id,
              name: student.data()['name'],
              email: student.data()['email'],
              profilePicUrl: student.data()['profilePicUrl'],
              isPresent: false,
            ).toJson(),
          );
        }
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  //create session
  Future<bool> createSession(
      sessionModel session, String moduleID, String classID) async {
    try {
      var Doc = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('sessions')
          .doc();
      session.id = Doc.id;
      await Doc.set(session.toJson());
      var students = await db
          .collection('students')
          .where('classID', isEqualTo: classID)
          .get();
      for (var student in students.docs) {
        var sessionStudents = await db
            .collection('classes')
            .doc(classID)
            .collection('modules')
            .doc(moduleID)
            .collection('sessions')
            .doc(session.id)
            .collection('students')
            .doc(student.id);
        await sessionStudents.set(
          sessionAttendee(
            id: student.id,
            name: student.data()['name'],
            email: student.data()['email'],
            profilePicUrl: student.data()['profilePicUrl'],
            isPresent: false,
          ).toJson(),
        );
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<sessionModel>> getSessions(
      String moduleID, String classID) async {
    try {
      var sessions = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('sessions')
          .orderBy('date', descending: false)
          .get();
      return sessions.docs.map((e) => sessionModel.fromJson(e.data())).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<sessionAttendee>> getSessionAttendees(
      String moduleID, String classID, String sessionID) async {
    try {
      var sessions = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('sessions')
          .doc(sessionID)
          .collection('students')
          .get();
      return sessions.docs
          .map((e) => sessionAttendee.fromJson(e.data()))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<Map<String, dynamic>>> getStudentAttendance(
      String moduleID, String classID, String studentID) async {
    try {
      List<Map<String, dynamic>> s = [];
      var sessions = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('sessions')
          .where('date', isLessThan: DateTime.now())
          .get();
      for (var session in sessions.docs) {
        var sess = await db
            .collection('classes')
            .doc(classID)
            .collection('modules')
            .doc(moduleID)
            .collection('sessions')
            .doc(session.id)
            .collection('students')
            .where('id', isEqualTo: studentID)
            .get();
        if (sess.docs.isNotEmpty) {
          var f = sess.docs.first;
          var attendee = {
            'date': session.get('date').toDate() as DateTime,
            'startTime': session.get('startTime') as String,
            'endTime': session.get('endTime') as String,
            'isPresent': f['isPresent'] as bool,
          };
          s.add(attendee);
        } else {
          print('No attendance found');
        }
      }
      print(s);
      return s;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<sessionModel>> getStudentSessions(String classID) async {
    try {
      List<sessionModel> sessions = [];
      var modules = await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .get();
      for (var module in modules.docs) {
        var ss = await db
            .collection('classes')
            .doc(classID)
            .collection('modules')
            .doc(module.id)
            .collection('sessions')
            .orderBy('date', descending: false)
            .get();
        sessions.addAll(
            ss.docs.map((e) => sessionModel.fromJson(e.data())).toList());
      }
      return sessions;
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<sessionModel>> getTeacherSessions(String uid) async {
    try {
      List<sessionModel> sessions = [];
      var classes = await db.collection('classes').get();
      for (var Class in classes.docs) {
        var ss = await db
            .collection('classes')
            .doc(Class.id)
            .collection('modules')
            .where('teacherID', isEqualTo: uid)
            .get();
        for (var module in ss.docs) {
          var sss = await db
              .collection('classes')
              .doc(Class.id)
              .collection('modules')
              .doc(module.id)
              .collection('sessions')
              .orderBy('date', descending: false)
              .get();
          sessions.addAll(
              sss.docs.map((e) => sessionModel.fromJson(e.data())).toList());
        }
      }
      return sessions;
    } catch (e) {
      print(e);
      return [];
    }
  }

  //delete session
  Future<void> deleteSession(
      String moduleID, String classID, String sessionID) async {
    try {
      await db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('sessions')
          .doc(sessionID)
          .delete();
    } catch (e) {
      print(e);
    }
  }

  Future<bool> updateAttendance(String moduleID, String classID,
      String sessionID, List<sessionAttendee> students) async {
    try {
      for (var student in students) {
        await db
            .collection('classes')
            .doc(classID)
            .collection('modules')
            .doc(moduleID)
            .collection('sessions')
            .doc(sessionID)
            .collection('students')
            .doc(student.id)
            .update(student.toJson());
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<void> updateStudentInfo(String uid, String name, String url) async {
    try {
      final documents = await db.collection("classes").get();
      for (var Class in documents.docs) {
        var modulesDocs = await db
            .collection("classes")
            .doc(Class.id)
            .collection('modules')
            .get();
        for (var module in modulesDocs.docs) {
          var sessionsDocs = await db
              .collection("classes")
              .doc(Class.id)
              .collection('modules')
              .doc(module.id)
              .collection('sessions')
              .get();
          if (sessionsDocs.docs.isEmpty) {
            print('No sessions');
          } else {
            for (var session in sessionsDocs.docs) {
              var attendees = await db
                  .collection("classes")
                  .doc(Class.id)
                  .collection('modules')
                  .doc(module.id)
                  .collection('sessions')
                  .doc(session.id)
                  .collection('students')
                  .where('id', isEqualTo: uid)
                  .get();
              if (attendees.docs.isEmpty) {
                print('No attendes');
              } else {
                for (var attendee in attendees.docs) {
                  await db
                      .collection("classes")
                      .doc(Class.id)
                      .collection('modules')
                      .doc(module.id)
                      .collection('sessions')
                      .doc(session.id)
                      .collection('students')
                      .doc(attendee.id)
                      .update({
                    'name': name,
                    'profilePicUrl': url,
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

  Future<void> updateStudent(studentModel student) async {
    try {
      final documents = await db.collection("classes").get();
      for (var Class in documents.docs) {
        var modulesDocs = await db
            .collection("classes")
            .doc(Class.id)
            .collection('modules')
            .get();
        for (var module in modulesDocs.docs) {
          var sessionsDocs = await db
              .collection("classes")
              .doc(Class.id)
              .collection('modules')
              .doc(module.id)
              .collection('sessions')
              .get();
          if (sessionsDocs.docs.isEmpty) {
            print('No sessions');
          } else {
            for (var session in sessionsDocs.docs) {
              var attendees = await db
                  .collection("classes")
                  .doc(Class.id)
                  .collection('modules')
                  .doc(module.id)
                  .collection('sessions')
                  .doc(session.id)
                  .collection('students')
                  .where('id', isEqualTo: student.id)
                  .get();
              if (attendees.docs.isEmpty) {
                print('No attendes');
              } else {
                for (var attendee in attendees.docs) {
                  await db
                      .collection("classes")
                      .doc(Class.id)
                      .collection('modules')
                      .doc(module.id)
                      .collection('sessions')
                      .doc(session.id)
                      .collection('students')
                      .doc(attendee.id)
                      .update(sessionAttendee(
                        id: student.id,
                        name: student.name,
                        email: student.email,
                        profilePicUrl: student.profilePicUrl,
                        isPresent: attendee['isPresent'],
                      ).toJson());
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

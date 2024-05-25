// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:yapple/models/feedbackModel.dart';
import 'package:yapple/models/parentModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/models/teacherModel.dart';

class UserService {
  FirebaseFirestore db = FirebaseFirestore.instance;
  //FirebaseStorage storage = FirebaseStorage.instance;

  Future<bool> userExists(
      String email, String password, String coll, BuildContext context) async {
    try {
      final docUser = db
          .collection(coll)
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password);
      final snapShot = await docUser.get();
      if (snapShot.docs.isEmpty) {
        return false;
      } else {
        return true;
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return false;
    }
  }
  

  Future<String> getType(
      String email, String password, BuildContext context) async {
    try {
      final docUser = db
          .collection('temporary')
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password);
      final snapShot = await docUser.get();
      return snapShot.docs[0].get("role");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return 'null';
    }
  }

  Future<studentModel> getStudentData(String id, BuildContext context) async {
    try {
      final docUser = db.collection('students').doc(id);
      final snapshot = await docUser.get();
      final student = studentModel.fromJson(snapshot.data()!);
      student.id = id;
      return student;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    //return an empty user
    return studentModel(
      id: "",
      name: "",
      email: "",
      password: '',
      profilePicUrl: '',
      role: '',
      major: '',
      classID: '',
    );
  }

  Future<teacherModel> getTeacherData(String id, BuildContext context) async {
    try {
      final docUser = db.collection('teachers').doc(id);
      final snapshot = await docUser.get();
      final teacher = teacherModel.fromJson(snapshot.data()!);
      teacher.id = id;
      return teacher;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    //return an empty user
    return teacherModel(
      id: "",
      name: "",
      email: "",
      password: '',
      profilePicUrl: '',
      role: '',
    );
  }

  Future<feedbackSenderModel> getFeedbackSenderData(
      String id, BuildContext context) async {
    try {
      final docUser = db.collection('teachers').doc(id);
      final snapshot = await docUser.get();
      if (snapshot.exists) {
        final teacher = teacherModel.fromJson(snapshot.data()!);
        return feedbackSenderModel(
          id: id,
          name: teacher.name,
          email: teacher.email,
          profilePicUrl: teacher.profilePicUrl,
          role: teacher.role,
        );
      } else {
        final docUser1 = db.collection('students').doc(id);
        final snapshot1 = await docUser1.get();
        if (snapshot1.exists) {
          final student = studentModel.fromJson(snapshot1.data()!);
          return feedbackSenderModel(
            id: id,
            name: student.name,
            email: student.email,
            profilePicUrl: student.profilePicUrl,
            role: student.role,
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
    return feedbackSenderModel(
      id: "",
      name: "",
      email: "",
      profilePicUrl: '',
      role: '',
    );
  }

  Future<String> getUserType(String id, BuildContext context) async {
    try {
      final docUser = db.collection("students").doc(id);
      final snapShot = await docUser.get();
      if (snapShot.exists) {
        return 'students';
      } else {
        final docUser1 =
            FirebaseFirestore.instance.collection("teachers").doc(id);
        final snapShot1 = await docUser1.get();
        if (snapShot1.exists) {
          return 'teachers';
        } else {
          return 'null';
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return "";
    }
  }

  Future<List<studentModel>> getCircleStudents(String id) async {
    try {
      final documents =
          await db.collection("students").where("classID", isEqualTo: id).get();
      return documents.docs.map((e) => studentModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<studentModel>> getAllActiveStudents() async {
    try {
      final documents =
          await db.collection("students").get();
      return documents.docs.map((e) => studentModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<List<studentModel>> getInActiveStudents() async {
    try {
      final documents = await db.collection("temporary").where("role", isEqualTo: "Student").get();
      return documents.docs.map((e) => studentModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<List<teacherModel>> getInActiveTeachers() async {
    try {
      final documents = await db.collection("temporary")
          .where("role", isEqualTo: "Teacher")
          .get();
      return documents.docs.map((e) => teacherModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }
  Future<List<parentModel>> getInActiveParents() async {
    try {
      final documents = await db.collection("temporary")
          .where("role", isEqualTo: "Parent")
          .get();
      return documents.docs.map((e) => parentModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<teacherModel>> getAllActiveTeachers() async {
    try {
      final documents = await db.collection("teachers").get();
      return documents.docs.map((e) => teacherModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<parentModel>> getAllActiveParents() async {
    try {
      final documents = await db.collection("parents").get();
      return documents.docs.map((e) => parentModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<String> getStudentClass(String id, BuildContext context) async {
    try {
      final docUser = FirebaseFirestore.instance.collection("students").doc(id);
      final snapShot = await docUser.get();
      return snapShot.get("classID");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return "";
    }
  }

  Future<String> getStudentName(String id, BuildContext context) async {
    try {
      final docUser = FirebaseFirestore.instance.collection("students").doc(id);
      final snapShot = await docUser.get();
      return snapShot.get("name");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return "";
    }
  }

  Future<String> getStudentProfilePic(String id, BuildContext context) async {
    try {
      final docUser = FirebaseFirestore.instance.collection("students").doc(id);
      final snapShot = await docUser.get();
      return snapShot.get("profilePicUrl");
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return "";
    }
  }

  Future<bool> updateUserInfo(
      String id, String col, String name, String profilePicUrl) async {
    try {
      final docChat = db.collection(col).doc(id);
      await docChat.update({"name": name, "profilePicUrl": profilePicUrl});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateStudent(String col, studentModel student) async {
    try {
      final docChat = db.collection(col).doc(student.id);
      await docChat.update(student.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateParent(String col, parentModel parent) async {
    try {
      final docChat = db.collection(col).doc(parent.id);
      await docChat.update(parent.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> updateTeacher(String col, teacherModel teacher) async {
    try {
      final docChat = db.collection(col).doc(teacher.id);
      await docChat.update(teacher.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteUser(String col, String id) async {
    try {
      final docChat = db.collection(col).doc(id);
      await docChat.delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  // Future<String> uploadProfilePic(String uid, XFile image) async {
  //   try {
  //     final ref = storage.ref('profilePics/').child(uid);
  //     await ref.putFile(File(image.path));
  //     final url = await ref.getDownloadURL();
  //     return url;
  //   } catch (e) {
  //     print(e);
  //     return "";
  //   }
  // }

  Future<bool> updateUserProfilePic(
      String id, String col, String name, String profilePicUrl) async {
    try {
      final docChat = db.collection(col).doc(id);
      await docChat.update({"name": name, "profilePicUrl": profilePicUrl});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> createStudentRecord(studentModel student) async {
    try {
      final doc = await db.collection("temporary").doc();
      String sid = doc.id;
      student.id = sid;
      await doc.set(student.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> createParentRecord(parentModel parent) async {
    try {
      final doc = await db.collection("temporary").doc();
      String sid = doc.id;
      parent.id = sid;
      await doc.set(parent.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> createTeacherRecord(teacherModel teacher) async {
    try {
      final doc = await db.collection("temporary").doc();
      String sid = doc.id;
      teacher.id = sid;
      await doc.set(teacher.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }


  Future<void> updateParentStudent(BuildContext context, studentModel student) async {
    try {
      List<parentModel> parents = [];
      final documents = await db.collection("parents").where('studentId', isEqualTo: student.id).get();
      for (var element in documents.docs) {
        parents.add(parentModel.fromSnapshot(element));
      }
      for (parentModel parent in parents) {
        var newStudent = studentModel(
          id: student.id,
          name: student.name,
          email: student.email,
          password: student.password,
          profilePicUrl: student.profilePicUrl,
          role: student.role,
          major: student.major,
          classID: student.classID,
        );
        var docFeedback = db.collection("parents").doc(parent.id);
        await docFeedback.update({"student": newStudent.toJson()});
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("issue " + e.toString()),
      ));
      print(e.toString());
    }
  }
}

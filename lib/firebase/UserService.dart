// ignore_for_file: use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/models/teacherModel.dart';
import 'package:yapple/models/userModel.dart';

class UserService {
  FirebaseFirestore db = FirebaseFirestore.instance;

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

}

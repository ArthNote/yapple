import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/taskModel.dart';

class TaskService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<bool> createTask(taskModel newTask, BuildContext context, String col, String uid) async {
    try {
      final docTask = db.collection(col).doc(uid).collection('tasks').doc();
      String tid = docTask.id;
      newTask.id = tid;
      await docTask.set(newTask.toJson());
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return false;
    }
  }

  /*Future<List<taskModel>> getTasks(String id, String col) async {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
      final documents = await FirebaseFirestore.instance
          .collection(col)
          .doc(id)
          .collection('tasks')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
          .where('date', isLessThan: Timestamp.fromDate(tomorrow))
          .get();
      return documents.docs.map((e) => taskModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }*/

  Stream<QuerySnapshot> getTasks(String id, String col) {
    try {
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      DateTime tomorrow = DateTime(now.year, now.month, now.day + 1);
      return db
          .collection(col)
          .doc(id)
          .collection('tasks')
          .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(today))
          .where('date', isLessThan: Timestamp.fromDate(tomorrow))
          .snapshots();
    } catch (e) {
      print(e.toString());
      return Stream.empty();
    }
  }

  Future<bool> updateTaskStatus(String id, String col, String taskID, bool isCompleted) async {
    try {
      final docChat = db.collection(col).doc(id).collection('tasks').doc(taskID);
      await docChat.update({"isCompleted": isCompleted});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> deleteTask(
      String id, String col, String taskID) async {
    try {
      final docChat =
          db.collection(col).doc(id).collection('tasks').doc(taskID);
      await docChat.delete();
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
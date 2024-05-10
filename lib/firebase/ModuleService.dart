import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/starredModel.dart';

class ModuleService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<moduleModel>> getModules(String id) async {
    try {
      final documents = await FirebaseFirestore.instance
          .collection("classes")
          .doc(id)
          .collection('modules')
          .get();
      return documents.docs.map((e) => moduleModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<List<starredModel>> getStarredModules(
      String uid, String colName) async {
    try {
      final documents = await FirebaseFirestore.instance
          .collection(colName)
          .doc(uid)
          .collection('starred')
          .get();
      return documents.docs.map((e) => starredModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> checkStarred(
      String colName, String uid, String moduleId, BuildContext context) async {
    try {
      final docStar = await FirebaseFirestore.instance
          .collection(colName)
          .doc(uid)
          .collection('starred')
          .where('id', isEqualTo: moduleId)
          .get();
      if (docStar.docs.isEmpty) {
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

  Future<bool> starModule(starredModel star, String colName, String uid,
      BuildContext context, String moduleID) async {
    try {
      final docS =
          db.collection(colName).doc(uid).collection('starred').doc(moduleID);
      star.id = moduleID;
      await docS.set(star.toJson());
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return false;
    }
  }

  Future<bool> removeStar(
      String colName, String uid, String moduleId, BuildContext context) async {
    try {
      final docS = db
          .collection(colName)
          .doc(uid)
          .collection('starred')
          .doc(moduleId)
          .delete();
      return true;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
      return false;
    }
  }
}

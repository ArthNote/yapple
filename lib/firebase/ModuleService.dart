import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/classModel.dart';
import 'package:yapple/models/materialModel.dart';
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

  Future<List<materialModel>> getModuleMaterials(
      String classID, String moduleID) async {
    try {
      final documents = await FirebaseFirestore.instance
          .collection("classes")
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('materials')
          .get();
      return documents.docs.map((e) => materialModel.fromSnapshot(e)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<bool> deleteModuleMaterial(
      String classID, String moduleID, String materialID) async {
    try {
      final document = await FirebaseFirestore.instance
          .collection("classes")
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('materials')
          .doc(materialID);
      await document.delete();
      final ref = FirebaseStorage.instance
          .ref('classes/$classID/modules/$moduleID/materials/')
          .child(materialID);
      await ref.delete();

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<List<moduleModel>> getTeacherModules(String uid) async {
    try {
      List<moduleModel> modules = [];
      List<classModel> classes = [];
      final documents = await db.collection("classes").get();
      for (var element in documents.docs) {
        classes.add(classModel.fromSnapshot(element));
      }
      print(classes.map((e) => e.name).toList());
      for (var Class in classes) {
        var modulesDocs = await db
            .collection("classes")
            .doc(Class.id)
            .collection('modules')
            .where('teacherID', isEqualTo: uid)
            .get();
        modules.addAll(
            modulesDocs.docs.map((e) => moduleModel.fromSnapshot(e)).toList());
      }
      return modules;
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

  Future<bool> uploadModuleMaterial(File file, String classID, String moduleID,
      materialModel material) async {
    try {
      UploadTask? task;
      final ref = FirebaseStorage.instance
          .ref('classes/$classID/modules/$moduleID/materials/')
          .child(material.id);
      task = ref.putFile(file);
      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      material.url = urlDownload;
      bool uploaded = await addModuleMaterial(classID, moduleID, material);
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

  Future<bool> uploadAssignmentMaterial(File file, String classID,
      String moduleID, materialModel material, String assignmentID) async {
    try {
      UploadTask? task;
      final ref = FirebaseStorage.instance
          .ref('classes/$classID/modules/$moduleID/assignments/$assignmentID/materials/')
          .child(material.id);
      task = ref.putFile(file);
      final snapshot = await task.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      material.url = urlDownload;
      bool uploaded =
          await addAssigmentMaterial(classID, moduleID, material, assignmentID);
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

  Future<bool> addModuleMaterial(
      String classID, String moduleID, materialModel material) async {
    try {
      final docM = db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('materials')
          .doc(material.id);
      await docM.set(material.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<bool> addAssigmentMaterial(String classID, String moduleID,
      materialModel material, String assignmentID) async {
    try {
      final docM = db
          .collection('classes')
          .doc(classID)
          .collection('modules')
          .doc(moduleID)
          .collection('assignments')
          .doc(assignmentID)
          .collection('materials')
          .doc(material.id);
      await docM.set(material.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}

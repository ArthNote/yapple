import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapple/models/classModel.dart';

class ClassService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<classModel>> getClasses() async {
    try {
      final classes = await db.collection('classes').get();
      return classes.docs
          .map((doc) => classModel.fromSnapshot(doc))
          .toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  //delete class
  Future<void> deleteClass(String id) async {
    try {
      await db.collection('classes').doc(id).delete();
    } catch (e) {
      print(e);
    }
  }

  //add class
  Future<bool> addClass(classModel newClass) async {
    try {
      final doc = await db.collection('classes').doc();
      newClass.id = doc.id;
      await doc.set(newClass.toJson());
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  Future<int> getClassesCount() async {
    try {
      int count = 0;
      final snapshot = await db.collection('classes').get();
        if (snapshot.docs.isNotEmpty) {
          for (var doc in snapshot.docs) {
            count += 1;
          }
        } else {
          count = 0;
        }
    
      return count;
    } catch (e) {
      print(e);
      return 0;
    }
  }
}
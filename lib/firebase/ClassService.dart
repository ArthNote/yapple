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
}
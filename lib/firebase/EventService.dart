import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapple/models/eventModel.dart';

class EventService {
  FirebaseFirestore db = FirebaseFirestore.instance;

  Future<List<eventModel>> getEvents() async {
    try {
      final documents = await db.collection('events').get();
      return documents.docs.map((doc) => eventModel.fromSnapshot(doc)).toList();
    } catch (e) {
      print(e);
      return [];
    }
  }

  Future<void> deleteEvent(String id) async {
    try {
      await db.collection('events').doc(id).delete();
    } catch (e) {
      print(e);
    }
  }
}
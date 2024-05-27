import 'package:cloud_firestore/cloud_firestore.dart';

class eventModel {
  String id;
  String imageUrl;
  DateTime date;

  eventModel({
    required this.id,
    required this.imageUrl,
    required this.date,
  });

  factory eventModel.fromJson(Map<String, dynamic> json) {
    return eventModel(
      id: json['id'] ?? '',
      imageUrl: json['image'] ?? '',
      date: (json['uploadedDate'] as Timestamp).toDate(),
    );
  }

  //TimeOfDay.fromDateTime(DateTime.parse(timeString))

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'image': imageUrl,
      'uploadedDate': Timestamp.fromDate(date),
    };
  }

  factory eventModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return eventModel(
      id: document.id,
      imageUrl: data['image'] ?? '',
      date: (data['uploadedDate'] as Timestamp).toDate(),
    );
    //return something
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';

class eventModel {
  String id;
  String title;
  String note;
  String startTime;
  String endTime;
  String type;
  DateTime date;

  eventModel({
    required this.id,
    required this.title,
    required this.note,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.date,
  });

  factory eventModel.fromJson(Map<String, dynamic> json) {
    return eventModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      note: json['note'] ?? '',
      startTime: json['startTime'],
      endTime: json['endTime'],
      type: json['type'],
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  //TimeOfDay.fromDateTime(DateTime.parse(timeString))

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'startTime': startTime,
      'endTime': endTime,
      'type': type,
      'date': Timestamp.fromDate(date),
    };
  }

  factory eventModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return eventModel(
      id: document.id,
      title: data['title'] ?? '',
      note: data['note'] ?? '',
      startTime: data['startTime'],
      endTime: data['endTime'],
      type: data['type'],
      date: (data['date'] as Timestamp).toDate(),
    );
    //return something
  }
}

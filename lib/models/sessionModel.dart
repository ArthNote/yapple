import 'package:cloud_firestore/cloud_firestore.dart';

class sessionModel {
  String id;
  String moduleName;
  String teacherName;
  String startTime;
  String endTime;
  DateTime date;
  String moduleID;
  String classID;

  sessionModel({
    required this.id,
    required this.moduleName,
    required this.teacherName,
    required this.startTime,
    required this.endTime,
    required this.date,
    required this.moduleID,
    required this.classID,
  });

  factory sessionModel.fromJson(Map<String, dynamic> json) {
    return sessionModel(
      id: json['id'] ?? '',
      moduleName: json['moduleName'] ?? '',
      teacherName: json['teacherName'] ?? '',
      startTime: json['startTime'],
      endTime: json['endTime'],
      date: (json['date'] as Timestamp).toDate(),
      moduleID: json['moduleID'] ?? '',
      classID: json['classID'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'moduleName': moduleName,
      'teacherName': teacherName,
      'startTime': startTime,
      'endTime': endTime,
      'date': Timestamp.fromDate(date),
      'moduleID': moduleID,
      'classID': classID,
    };
  }

  factory sessionModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return sessionModel(
      id: document.id,
      moduleName: data['moduleName'] ?? '',
      teacherName: data['teacherName'] ?? '',
      startTime: data['startTime'],
      endTime: data['endTime'],
      date: (data['date'] as Timestamp).toDate(),
      moduleID: data['moduleID'] ?? '',
      classID: data['classID'] ?? '',
    );
  }
}

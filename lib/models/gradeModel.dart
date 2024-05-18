import 'package:cloud_firestore/cloud_firestore.dart';

class gradeModel{
  String moduleID;
  String moduleName;
  String studentID;
  String title;
  String grade;
  String type;

  gradeModel({
    required this.moduleID,
    required this.moduleName,
    required this.studentID,
    required this.title,
    required this.grade,
    required this.type,
  });

  factory gradeModel.fromJson(Map<String, dynamic> json) {
    return gradeModel(
      moduleID: json['moduleID'],
      moduleName: json['moduleName'],
      studentID: json['studentID'],
      title: json['title'],
      grade: json['grade'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'moduleID': moduleID,
      'moduleName': moduleName,
      'studentID': studentID,
      'title': title,
      'grade': grade,
      'type': type,
    };
  }

  factory gradeModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return gradeModel(
      moduleID: data['moduleID'] ?? '',
      moduleName: data['moduleName'] ?? '',
      studentID: data['studentID'] ?? '',
      title: data['title'] ?? '',
      grade: data['grade'] ?? '',
      type: data['type'] ?? '',
    );
  }
}
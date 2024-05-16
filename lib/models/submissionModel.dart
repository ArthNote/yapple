import 'package:cloud_firestore/cloud_firestore.dart';

class submissionModel {
  String id;
  String studentName;
  String studentID;
  bool isGraded;
  DateTime submissionDate;
  String comment;
  int grade;

  submissionModel({
    required this.id,
    required this.studentName,
    required this.studentID,
    required this.isGraded,
    required this.submissionDate,
    required this.comment,
    required this.grade,
  });

  factory submissionModel.fromJson(Map<String, dynamic> json) {
    return submissionModel(
      id: json['id'],
      studentName: json['studentName'],
      studentID: json['studentID'],
      isGraded: json['isGraded'],
      submissionDate: json['submissionDate'],
      comment: json['comment'],
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentName': studentName,
      'studentID': studentID,
      'isGraded': isGraded,
      'submissionDate': Timestamp.fromDate(submissionDate),
      'comment': comment,
      'grade': grade,
    };
  }

  factory submissionModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return submissionModel(
      id: document.id ?? '',
      studentName: data['studentName'] ?? '',
      studentID: data['studentID'] ?? '',
      isGraded: data['isGraded'] ?? false,
      submissionDate: (data['submissionDate'] as Timestamp).toDate(),
      comment: data['comment'] ?? '',
      grade: data['grade'] ?? 0,
    );
    //return something
  }
}
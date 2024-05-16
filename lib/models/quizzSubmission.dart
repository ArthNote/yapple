import 'package:cloud_firestore/cloud_firestore.dart';

class quizzSubmission {
  String id;
  String studentName;
  String studentID;
  String quizzName;
  String grade;

  quizzSubmission({
    required this.id,
    required this.studentName,
    required this.studentID,
    required this.quizzName,
    required this.grade,
  });

  factory quizzSubmission.fromJson(Map<String, dynamic> json) {
    return quizzSubmission(
      id: json['id'],
      studentName: json['studentName'],
      studentID: json['studentID'],
      quizzName: json['quizzName'],
      grade: json['grade'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'studentName': studentName,
      'studentID': studentID,
      'quizzName': quizzName,
      'grade': grade,
    };
  }

  factory quizzSubmission.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return quizzSubmission(
      id: document.id ?? '',
      studentName: data['studentName'] ?? '',
      studentID: data['studentID'] ?? '',
      quizzName: data['quizzName'] ?? '',
      grade: data['grade'] ?? '',
    );
  }
}
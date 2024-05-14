import 'package:cloud_firestore/cloud_firestore.dart';

class assignmentModel {
  String id;
  String title;
  String description;
  DateTime dueDate;

  assignmentModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
  });

  factory assignmentModel.fromJson(Map<String, dynamic> json) {
    return assignmentModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      dueDate: (json['dueDate'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': Timestamp.fromDate(dueDate),
    };
  }

  factory assignmentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return assignmentModel(
      id: document.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      dueDate: (data['dueDate'] as Timestamp).toDate(),
    );
  }
}
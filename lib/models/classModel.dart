import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/studentModel.dart';

class classModel {
  String id;
  String name;
  String major;
  int year;

  classModel({
    required this.id,
    required this.name,
    required this.major,
    required this.year,
  });

  factory classModel.fromJson(Map<String, dynamic> json) {

    return classModel(
      id: json['id'],
      name: json['name'],
      major: json['major'],
      year: json['year'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'major': major,
        'year': year,
      };

      factory classModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return classModel(
      id: document.id ?? '',
      name: data['name'] ?? '',
      major: data['major'] ?? '',
      year: data['year'] ?? '',
    );
    //return something
  }
}

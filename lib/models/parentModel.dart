import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/models/userModel.dart';

class parentModel extends userModel {
  String role;
  String studentId;
  studentModel student;
  parentModel({
    required super.id,
    required super.name,
    required super.email,
    required super.password,
    required super.profilePicUrl,
    required this.role,
    required this.studentId,
    required this.student,
  });

  factory parentModel.fromJson(Map<String, dynamic> json) {
    return parentModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profilePicUrl: json['profilePicUrl'],
      role: json['role'],
      studentId: json['studentId'],
      student: studentModel.fromJson(json['student']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'profilePicUrl': profilePicUrl,
      'role': role,
      'studentId': studentId,
      'student': student.toJson(),
    };
  }

  factory parentModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return parentModel(
      id: document.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      password: data['password'] ?? '',
      profilePicUrl: data['profilePicUrl'] ?? '',
      role: data['role'] ?? '',
      studentId: data['studentId'] ?? '',
      student: studentModel.fromJson(data['student']),
    );
    //return something
  }

}

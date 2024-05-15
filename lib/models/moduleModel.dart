import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/teacherModel.dart';

class moduleModel {
  String id;
  String name;
  String code;
  String category;
  IconData icon;
  Color color;
  teacherModel teacher;
  String about;
  String classID;
  String teacherID;

  moduleModel({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    required this.icon,
    required this.color,
    required this.teacher,
    required this.about,
    required this.classID,
    required this.teacherID,
  });

  factory moduleModel.fromJson(Map<String, dynamic> json) {
    return moduleModel(
      id: json['id'] ?? '',
      name: json['name'],
      code: json['code'],
      category: json['category'],
      icon: IconData(int.parse(json['icon']), fontFamily: 'MaterialIcons'),
      color: Color(int.parse(json['color'])),
      teacher: teacherModel.fromJson(json['teacher']),
      about: json['about'],
      classID: json['classID'],
      teacherID: json['teacherID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'category': category,
        'icon': icon.codePoint.toString(),
        'color': color.value.toString(),
        'teacher': teacher.toJson(),
        'about': about,
        'classID': classID,
        'teacherID': teacherID,
      };

  factory moduleModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return moduleModel(
      id: document.id ?? '',
      name: data['name'] ?? '',
      code: data['code'] ?? '',
      category: data['category'] ?? '',
      icon: IconData(int.parse(data['icon']), fontFamily: 'MaterialIcons') ??
          Icons.error,
      color: Color(int.parse(data['color'])) ?? Colors.red,
      teacher: teacherModel.fromJson(data['teacher']),
      about: data['about'] ?? '',
      classID: data['classID'] ?? '',
      teacherID: data['teacherID'] ?? '',
    );
    //return something
  }
}

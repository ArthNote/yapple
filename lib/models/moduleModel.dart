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
  });

  factory moduleModel.fromJson(Map<String, dynamic> json) {
    return moduleModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      category: json['category'],
      icon: json['icon'],
      color: json['color'],
      teacher: teacherModel.fromJson(json['teacher']),
      about: json['about'],
      classID: json['classID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'category': category,
        'icon': icon,
        'color': color,
        'teacher': teacher.toJson(),
        'about': about,
        'classID': classID,
      };
}
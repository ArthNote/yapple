import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/studentModel.dart';

class classModel {
  String id;
  String name;
  String major;
  String year;
  List<studentModel> students;
  List<moduleModel> modules;

  classModel({
    required this.id,
    required this.name,
    required this.major,
    required this.year,
    required this.students,
    required this.modules,
  });

  factory classModel.fromJson(Map<String, dynamic> json) {
    List<studentModel> students = [];
    List<moduleModel> modules = [];

    for (var student in json['students']) {
      students.add(studentModel.fromJson(student));
    }

    for (var module in json['modules']) {
      modules.add(moduleModel.fromJson(module));
    }

    return classModel(
      id: json['id'],
      name: json['name'],
      major: json['major'],
      year: json['year'],
      students: students,
      modules: modules,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'major': major,
        'year': year,
        'students': students.map((student) => student.toJson()).toList(),
        'modules': modules.map((module) => module.toJson()).toList(),
      };
}

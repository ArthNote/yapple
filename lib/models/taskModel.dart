import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class taskModel {
  String id;
  String title;
  String note;
  String startTime;
  String endTime;
  Color color;
  bool isCompleted;
  DateTime date;

  taskModel({
    required this.id,
    required this.title,
    required this.note,
    required this.startTime,
    required this.endTime,
    required this.color,
    required this.isCompleted,
    required this.date,
  });

  factory taskModel.fromJson(Map<String, dynamic> json) {
    return taskModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      note: json['note'] ?? '',
      startTime: json['startTime'],
      endTime: json['endTime'],
      color: Color(int.parse(json['color'])),
      isCompleted: json['isCompleted'],
      date: (json['date'] as Timestamp).toDate(),
    );
  }

  //TimeOfDay.fromDateTime(DateTime.parse(timeString))

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'startTime': startTime,
      'endTime': endTime,
      'color': color.value.toString(),
      'isCompleted': isCompleted,
      'date': Timestamp.fromDate(date),
    };
  }

  factory taskModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return taskModel(
      id: document.id,
      title: data['title'] ?? '',
      note: data['note'] ?? '',
      startTime: data['startTime'],
      endTime: data['endTime'],
      color: Color(int.parse(data['color'])) ?? Colors.red,
      isCompleted: data['isCompleted'],
      date: (data['date'] as Timestamp).toDate(),
    );
    //return something
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:yapple/models/teacherModel.dart';

class starredModel{
  String id;
  String name;
  String code;
  String category;
  IconData icon;
  Color color;

  starredModel({
    required this.id,
    required this.name,
    required this.code,
    required this.category,
    required this.icon,
    required this.color,
  });

  factory starredModel.fromJson(Map<String, dynamic> json) {
    return starredModel(
      id: json['id'] ?? '',
      name: json['name'],
      code: json['code'],
      category: json['category'],
      icon: IconData(int.parse(json['icon']), fontFamily: 'MaterialIcons'),
      color: Color(int.parse(json['color'])),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'code': code,
        'category': category,
        'icon': icon.codePoint.toString(),
        'color': color.value.toString(),
      };

  factory starredModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return starredModel(
      id: document.id ?? '',
      name: data['name'] ?? '',
      code: data['code'] ?? '',
      category: data['category'] ?? '',
      icon: IconData(int.parse(data['icon']), fontFamily: 'MaterialIcons') ??
          Icons.error,
      color: Color(int.parse(data['color'])) ?? Colors.red,
    );
    //return something
  }
}

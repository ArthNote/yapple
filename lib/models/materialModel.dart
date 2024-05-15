import 'package:cloud_firestore/cloud_firestore.dart';

class materialModel {
  String id;
  String name;
  String url;

  materialModel({
    required this.id,
    required this.name,
    required this.url,
  });

  factory materialModel.fromJson(Map<String, dynamic> json) {
    return materialModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '', 
      url: json['url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'url': url,
    };
  }

  factory materialModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
  
    return materialModel(
      id: document.id ?? '',
      name: data['name'] ?? '',
      url: data['url'] ?? '',
    );
    //return something
  }
}
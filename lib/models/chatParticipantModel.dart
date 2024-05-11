import 'package:cloud_firestore/cloud_firestore.dart';

class chatParticipantModel {
  String id;
  String name;
  String email;
  String profilePicUrl;
  String role;

  chatParticipantModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicUrl,
    required this.role,
  });

  factory chatParticipantModel.fromJson(Map<String, dynamic> json) {
    return chatParticipantModel(
      id: json['id'] ?? '',
      name: json['name'],
      email: json['email'],
      profilePicUrl: json['profilePicUrl'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'profilePicUrl': profilePicUrl,
        'role': role,
      };

  factory chatParticipantModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return chatParticipantModel(
      id: data['id'] ?? document.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePicUrl: data['profilePicUrl'] ?? '',
      role: data['role'] ?? '',
    );
    //return something
  }
}

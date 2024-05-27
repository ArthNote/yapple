import 'package:cloud_firestore/cloud_firestore.dart';

class sessionAttendee {
  String id;
  String name;
  String email;
  String profilePicUrl;
  bool isPresent;

  sessionAttendee(
      {required this.id,
      required this.name,
      required this.email,
      required this.profilePicUrl,
      required this.isPresent});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profilePicUrl': profilePicUrl,
      'isPresent': isPresent
    };
  }

  factory sessionAttendee.fromJson(Map<String, dynamic> json) {
    return sessionAttendee(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        profilePicUrl: json['profilePicUrl'],
        isPresent: json['isPresent']);
  }

 factory sessionAttendee.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return sessionAttendee(
      id: document.id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePicUrl: data['profilePicUrl'] ?? '',
      isPresent: data['isPresent'] ?? false,
    );
  }

}
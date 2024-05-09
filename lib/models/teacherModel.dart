import 'package:yapple/models/userModel.dart';

class teacherModel extends userModel {
  String role;

  teacherModel({required super.id, required super.name, required super.email, required super.password, required super.profilePicUrl, required this.role});

  factory teacherModel.fromJson(Map<String, dynamic> json) {
    return teacherModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profilePicUrl: json['profilePicUrl'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'profilePicUrl': profilePicUrl,
        'role': role,
      };

}
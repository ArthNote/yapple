
import 'package:yapple/models/userModel.dart';

class studentModel extends userModel {
  String role;
  String major;
  String classID;

  studentModel(
      {required super.id,
      required super.name,
      required super.email,
      required super.password,
      required super.profilePicUrl,
      required this.role,
      required this.major,
      required this.classID});

  factory studentModel.fromJson(Map<String, dynamic> json) {
    return studentModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      profilePicUrl: json['profilePicUrl'],
      role: json['role'],
      major: json['major'],
      classID: json['classID'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'password': password,
        'profilePicUrl': profilePicUrl,
        'role': role,
        'major': major,
        'classID': classID,
      };
}

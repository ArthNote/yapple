import 'package:cloud_firestore/cloud_firestore.dart';

class feedbackModel {
  String id;
  String title;
  String content;
  feedbackSenderModel sender;

  feedbackModel({
    required this.id,
    required this.title,
    required this.content,
    required this.sender,
  });

  factory feedbackModel.fromJson(Map<String, dynamic> json) {
    return feedbackModel(
      id: json['id'] ?? '',
      title: json['title'],
      content: json['content'],
      sender: feedbackSenderModel.fromJson(json['sender']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'content': content,
        'sender': sender.toJson(),
      };

      factory feedbackModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return feedbackModel(
      id: document.id ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      sender: feedbackSenderModel.fromSnapshot(document),
    );
    //return something
  }
}

class feedbackSenderModel {
  String id;
  String name;
  String email;
  String profilePicUrl;
  String role;

  feedbackSenderModel({
    required this.id,
    required this.name,
    required this.email,
    required this.profilePicUrl,
    required this.role,
  });

  factory feedbackSenderModel.fromJson(Map<String, dynamic> json) {
    return feedbackSenderModel(
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

  factory feedbackSenderModel.fromSnapshot(
    DocumentSnapshot<Map<String, dynamic>> document,
  ) {
    final data = document.data()!;
    return feedbackSenderModel(
      id: document.id ?? '',
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profilePicUrl: data['profilePicUrl'] ?? '',
      role: data['role'] ?? '',
    );
    //return something
  }
}

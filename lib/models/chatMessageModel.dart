import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapple/models/chatParticipantModel.dart';

class chatMessageModel {
  String id;
  String message;
  chatParticipantModel sender;
  String chatID;
  DateTime? timeSent;
  bool isRead;
  String senderID;

  chatMessageModel({
    required this.id,
    required this.message,
    required this.sender,
    required this.chatID,
    required this.timeSent,
    required this.isRead,
    required this.senderID,
  });

  factory chatMessageModel.fromJson(Map<String, dynamic> json) {
    return chatMessageModel(
      id: json['id'] ?? '',
      message: json['message'],
      sender: chatParticipantModel.fromJson(json['sender']),
      chatID: json['chatID'],
      timeSent: json['timeSent'],
      isRead: json['isRead'],
      senderID: json['senderID'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'message': message,
      'sender': sender.toJson(),
      'chatID': chatID,
      'timeSent': timeSent != null ? Timestamp.fromDate(timeSent!) : null,
      'isRead': isRead,
      'senderID': senderID,
    };
  }

  factory chatMessageModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return chatMessageModel(
      id: document.id ?? '',
      message: data['message'] ?? '',
      sender: chatParticipantModel.fromJson(data['sender']),
      chatID: data['chatID'],
      timeSent: data['timeSent'] != null
          ? (data['timeSent'] as Timestamp).toDate()
          : null,
      isRead: data['isRead'],
      senderID: data['senderID'],
    );
  }

  
}
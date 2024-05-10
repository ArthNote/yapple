import 'package:cloud_firestore/cloud_firestore.dart';

class chatModel {
  String id;
  String? name;
  String lastMessage;
  DateTime? timeSent;
  int unreadMessages;
  bool isGroup;
  List<String> members;
  String? singleChatId;

  chatModel({
    required this.id,
    this.name,
    required this.lastMessage,
    required this.timeSent,
    required this.unreadMessages,
    required this.isGroup,
    required this.members,
    this.singleChatId,
  });

  factory chatModel.fromJson(Map<String, dynamic> json) {
    return chatModel(
      id: json['id'] ?? '',
      name: json['name']?? '',
      lastMessage: json['lastMessage'],
      timeSent: json['timeSent'],
      unreadMessages: json['unreadMessages'],
      isGroup: json['isGroup'],
      members: json['members'],
      singleChatId: json['singleChatId'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'timeSent': timeSent != null ? Timestamp.fromDate(timeSent!) : null,
      'unreadMessages': unreadMessages,
      'isGroup': isGroup,
      'members': members,
      'singleChatId': singleChatId,
    };
  }

  factory chatModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return chatModel(
      id: document.id ?? '',
      name: data['name'] ?? '',
      lastMessage: data['lastMessage'] ?? '',
      timeSent: data['timeSent'] != null ? (data['timeSent'] as Timestamp).toDate() : null,
      unreadMessages: data['unreadMessages'] ?? 0,
      isGroup: data['isGroup'] ?? false,
      members: data['members'] ?? [],
      singleChatId: data['singleChatId'] ?? '',
    );
    //return something
  }
}
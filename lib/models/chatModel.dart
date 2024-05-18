import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:yapple/models/chatParticipantModel.dart';

class chatModel {
  String id;
  String? name;
  String lastMessage;
  DateTime? timeSent;
  int unreadMessages;
  String type;
  List<chatParticipantModel> members;
  String? singleChatId;
  List<dynamic> membersId = [];

  chatModel({
    required this.id,
    this.name,
    required this.lastMessage,
    required this.timeSent,
    required this.unreadMessages,
    required this.type,
    required this.members,
    this.singleChatId,
    required this.membersId,
  });

  factory chatModel.fromJson(Map<String, dynamic> json) {
    List<chatParticipantModel> members = [];
    for (var member in json['members']) {
      members.add(chatParticipantModel.fromJson(json));
    }
    return chatModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      lastMessage: json['lastMessage'],
      timeSent: json['timeSent'],
      unreadMessages: json['unreadMessages'],
      type: json['type'],
      members: members,
      singleChatId: json['singleChatId'] ?? '',
      membersId: json['membersId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'lastMessage': lastMessage,
      'timeSent': timeSent != null ? Timestamp.fromDate(timeSent!) : null,
      'unreadMessages': unreadMessages,
      'type': type,
      'members': members.map((member) => member.toJson()).toList(),
      'singleChatId': singleChatId,
      'membersId': membersId,
    };
  }

  factory chatModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    List<chatParticipantModel> members = [];
    for (Map<String, dynamic> member in data['members']) {
      members.add(chatParticipantModel.fromJson(member));
    }
    return chatModel(
      id: document.id ?? '',
      name: data['name'] ??'',
      lastMessage: data['lastMessage'] ?? '',
      timeSent: data['timeSent'] != null
          ? (data['timeSent'] as Timestamp).toDate()
          : null,
      unreadMessages: data['unreadMessages'] ?? 0,
      type: data['type'] ?? '',
      members: members,
      singleChatId: data['singleChatId'] ?? '',
      membersId: data['membersId'] ?? [],
    );
    //return something
  }
}

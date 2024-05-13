// ignore_for_file: must_be_immutable, prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/firebase/ChatService.dart';
import 'package:yapple/models/chatModel.dart';
import 'package:yapple/models/chatParticipantModel.dart';
import 'package:yapple/pages/global/chatPage.dart';
import 'package:yapple/widgets/ChatItem.dart';
import 'package:yapple/widgets/SearchField.dart';

class TeachersChatsPage extends StatelessWidget {
  TeachersChatsPage({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Column(
            children: [
              SizedBox(
                height: 10,
              ),
              Body(),
            ],
          ),
        ));
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String uid = "";
  final currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatService().getTypedChats(uid, context, "teacher"),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<chatModel> chats = [];
          chats = snapshot.data!.docs.map((e) {
            List<chatParticipantModel> members = [];
            for (var member in e.get('members')) {
              members.add(chatParticipantModel(
                id: member['id'],
                name: member['name'],
                email: member['email'],
                profilePicUrl: member['profilePicUrl'],
                role: member['role'],
              ));
            }
            print(members);
            return chatModel(
              id: e.get('id') ?? "",
              lastMessage: e.get('lastMessage') ?? "No messages yet",
              timeSent: e.get('timeSent') != null
                  ? (e.get('timeSent') as Timestamp).toDate()
                  : null,
              unreadMessages: e.get('unreadMessages') ?? 0,
              type: e.get('type') ?? "",
              members: members,
              membersId: List<String>.from(e.get('membersId')),
            );
          }).toList();
          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 8),
              children: List.generate(chats.length, (index) {
                var chat = chats[index];
                String chatName = chat.members[0].id == uid
                    ? chat.members[1].name
                    : chat.members[0].name;
                String profilePic = chat.members[0].id == uid
                    ? chat.members[1].profilePicUrl
                    : chat.members[0].profilePicUrl;
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatPage(
                          chatName: chatName,
                          isGroup: false,
                          chat: chat,
                          type: 'teacher',
                          profilePic: profilePic,
                        ),
                      ),
                    );
                  },
                  child: ChatItem(
                    chatName: chatName,
                    last_msg: chat.lastMessage.isEmpty
                        ? "No messages yet"
                        : chat.lastMessage,
                    time_sent: DateFormat.jm().format(chat.timeSent!),
                    runread_msg: chat.unreadMessages,
                    profilePicUrl: profilePic,
                  ),
                );
              }),
            ),
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          print(snapshot.error.toString());
          return Center(child: Text(snapshot.error.toString()));
        } else {
          return Text("Something went wrong");
        }
      },
    );
  }
}

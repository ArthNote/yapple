// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_const_constructors_in_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/firebase/ChatService.dart';
import 'package:yapple/firebase/MessageService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/chatMessageModel.dart';
import 'package:yapple/models/chatModel.dart';
import 'package:yapple/models/chatParticipantModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/models/teacherModel.dart';
import 'package:yapple/pages/students/editGroupMembers.dart';
import 'package:yapple/widgets/ChatInput.dart';
import 'package:yapple/widgets/ChatMessage.dart';
import 'package:yapple/widgets/GroupMessage.dart';
import 'package:yapple/widgets/ProfileDialog.dart';

class ChatPage extends StatefulWidget {
  ChatPage(
      {super.key,
      required this.chatName,
      required this.isGroup,
      this.chat,
      required this.type,
      required this.profilePic});
  final String chatName;
  final bool isGroup;
  final chatModel? chat;
  final String type;
  final String profilePic;

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  String chatN = 'Group';
  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    getName();
  }

  void getName() async {
    String r = await ChatService().getChatName(widget.chat!.id);
    setState(() {
      chatN = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        leadingWidth: 40,
        title: ListTile(
            onTap: () {
              int index =
                  widget.chat!.members[0].name == widget.chatName ? 0 : 1;
              widget.isGroup
                  ? null
                  : showDialog(
                      context: context,
                      builder: (context) => ProfileDialog(
                        name: widget.chatName,
                        email: widget.chat!.members[index].email,
                        role: widget.chat!.members[index].role,
                        showButton: false,
                        profilePicUrl:
                            widget.chat!.members[index].profilePicUrl,
                      ),
                    );
            },
            contentPadding: EdgeInsets.all(0),
            title: Text(
              widget.isGroup
                  ? chatN
                  : widget.chatName.substring(0, 1).toUpperCase() +
                      widget.chatName.substring(1),
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            leading: widget.profilePic == 'null'
                ? CircleAvatar(
                    radius: 20,
                    child: Text(
                      widget.isGroup
                          ? chatN.substring(0, 1).toUpperCase()
                          : widget.chatName.substring(0, 1).toUpperCase(),
                      style: TextStyle(fontSize: 18),
                    ),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  )
                : CircleAvatar(
                    radius: 20,
                    backgroundImage: NetworkImage(widget.profilePic),
                  )),
        actions: [
          widget.isGroup
              ? PopupMenuButton(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  surfaceTintColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        title: Text("Edit Group Details"),
                        leading: Icon(Icons.groups_2_outlined),
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return EditGroupMembers(
                              initialChat: widget.chat!,
                            );
                          }));
                        },
                      ),
                    ),
                  ],
                )
              : SizedBox()
        ],
      ),
      body: Body(
        isGroup: widget.isGroup,
        chat: widget.chat,
        type: widget.type,
      ),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key, required this.isGroup, this.chat, required this.type});
  final bool isGroup;
  final chatModel? chat;
  final String type;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController controller = TextEditingController();
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  studentModel user = studentModel(
    id: '',
    name: '',
    email: '',
    password: '',
    profilePicUrl: '',
    role: '',
    major: '',
    classID: '',
  );

  teacherModel teacher = teacherModel(
    id: '',
    name: '',
    email: '',
    password: '',
    profilePicUrl: '',
    role: '',
  );

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    MessageService().markAsSeen(widget.chat!.id, uid);
  }

  void sendMessage() async {
    if (controller.text.isNotEmpty) {
      String message = controller.text.trim();
      DateTime timeSent = DateTime.now();
      FieldValue timeSents = FieldValue.serverTimestamp();
      var msg = chatMessageModel(
        id: '',
        message: message,
        sender: chatParticipantModel(
          id: uid,
          name: widget.type == 'student' ? user.name : teacher.name,
          email: widget.type == 'student' ? user.email : teacher.email,
          role: widget.type == 'student' ? user.role : teacher.role,
          profilePicUrl: widget.type == 'student'
              ? user.profilePicUrl
              : teacher.profilePicUrl,
        ),
        chatID: widget.chat!.id,
        timeSent: timeSent,
        isRead: false,
        senderID: uid,
      );
      bool isSent = await MessageService().sendMessage(msg, widget.chat!.id);
      if (isSent) {
        bool isUpdated = await ChatService()
            .updateChat(widget.chat!.id, message, Timestamp.fromDate(timeSent));
        if (!isUpdated) {
          print('chat not updated');
        }
        controller.clear();
      } else {
        controller.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      widget.isGroup
          ? Expanded(
              child: StreamBuilder(
                  stream: MessageService().getMessages(widget.chat!.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<chatMessageModel> messages = [];
                      messages = snapshot.data!.docs.map((e) {
                        return chatMessageModel(
                          id: e.get('id'),
                          message: e.get('message'),
                          sender:
                              chatParticipantModel.fromJson(e.get('sender')),
                          chatID: e.get('chatID'),
                          timeSent: e.get('timeSent') != null
                              ? (e.get('timeSent') as Timestamp).toDate()
                              : null,
                          isRead: e.get('isRead'),
                          senderID: e.get('senderID'),
                        );
                      }).toList();
                      return ListView(
                        padding: EdgeInsets.only(bottom: 8, top: 10),
                        reverse: false,
                        children: List.generate(messages.length, (index) {
                          var message = messages[index];
                          bool show = index > 0
                              ? message.sender.id ==
                                      messages[index - 1].sender.id
                                  ? false
                                  : true
                              : true;
                          return GroupMessage(
                            sender: message.sender,
                            message: message.message + " index $index",
                            byMe: message.sender.id == uid,
                            time_sent:
                                DateFormat.jm().format(message.timeSent!),
                            isRead: message.isRead,
                            show: show,
                          );
                        }),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return Center(child: Text("Something went wrong"));
                    }
                  }),
            )
          : Expanded(
              child: StreamBuilder(
                  stream: MessageService().getMessages(widget.chat!.id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<chatMessageModel> messages = [];
                      messages = snapshot.data!.docs.map((e) {
                        return chatMessageModel(
                          id: e.get('id'),
                          message: e.get('message'),
                          sender:
                              chatParticipantModel.fromJson(e.get('sender')),
                          chatID: e.get('chatID'),
                          timeSent: e.get('timeSent') != null
                              ? (e.get('timeSent') as Timestamp).toDate()
                              : null,
                          isRead: e.get('isRead'),
                          senderID: e.get('senderID'),
                        );
                      }).toList();
                      return ListView(
                        padding: EdgeInsets.only(bottom: 8, top: 10),
                        reverse: false,
                        children: List.generate(messages.length, (index) {
                          MessageService().markAsSeen(widget.chat!.id, uid);
                          var message = messages[index];

                          return ChatMessage(
                            message: message.message,
                            byMe: message.sender.id == uid,
                            time_sent: message.timeSent != null
                                ? DateFormat.jm().format(message.timeSent!)
                                : 'Time not available',
                            isRead: message.isRead,
                          );
                        }),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return Center(child: Text("Something went wrong"));
                    }
                  }),
            ),
      FutureBuilder(
        future: widget.type == 'student'
            ? UserService().getStudentData(uid, context)
            : UserService().getTeacherData(uid, context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            widget.type == 'student'
                ? user = snapshot.data as studentModel
                : teacher = snapshot.data as teacherModel;
            return ChatInput(
              controller: controller,
              onPressed: () => sendMessage(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    ]);
  }
}

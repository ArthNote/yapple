// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_const_constructors_in_immutables


import 'package:flutter/material.dart';
import 'package:yapple/widgets/ChatInput.dart';
import 'package:yapple/widgets/ChatMessage.dart';
import 'package:yapple/widgets/GroupMessage.dart';
import 'package:yapple/widgets/ProfileDialog.dart';

class ChatPage extends StatelessWidget {
  ChatPage({super.key, required this.chatName, required this.isGroup});
  final String chatName;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leadingWidth: 40,
        title: ListTile(
            onTap: () {
              isGroup
                  ? null
                  : showDialog(
                      context: context,
                      builder: (context) => ProfileDialog(
                        name: chatName,
                        email: "name@email.com",
                        role: "Human",
                      ),
                    );
            },
            contentPadding: EdgeInsets.all(0),
            title: Text(
              chatName,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            leading: CircleAvatar(
              radius: 20,
              child: Text(
                chatName.substring(0, 1).toUpperCase(),
                style: TextStyle(fontSize: 18),
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            )),
        actions: [
          isGroup
              ? PopupMenuButton(
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  surfaceTintColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      child: ListTile(
                        title: Text("View Members"),
                        leading: Icon(Icons.groups_2_outlined),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: Text("Add Members"),
                        leading: Icon(Icons.person_add_alt_1_outlined),
                      ),
                    ),
                    PopupMenuItem(
                      child: ListTile(
                        title: Text("Remove Members"),
                        leading: Icon(Icons.person_remove_outlined),
                      ),
                    ),
                  ],
                )
              : SizedBox()
        ],
      ),
      body: Body(
        isGroup: isGroup,
      ),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key, required this.isGroup});
  final bool isGroup;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {


  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      widget.isGroup
          ? Expanded(
              child: ListView(
                children: [
                  GroupMessage(
                    message: "hey",
                    byMe: true,
                    time_sent: "12:00 pm",
                    isRead: true,
                  ),
                  GroupMessage(
                      message: "heey",
                      byMe: true,
                      time_sent: "12:00 pm",
                      isRead: true),
                  GroupMessage(
                      message:
                          "heey sssssssssss ssssssssssssssssssssssssssssssssss",
                      byMe: false,
                      time_sent: "12:00 pm",
                      isRead: false),
                  GroupMessage(
                      message: "hee sssssssssssssssssssssssyssssss",
                      byMe: true,
                      time_sent: "12:00 pm",
                      isRead: false),
                  GroupMessage(
                      message: "heey",
                      byMe: false,
                      time_sent: "12:00 pm",
                      isRead: false),
                  GroupMessage(
                      message: "heey",
                      byMe: false,
                      time_sent: "12:00 pm",
                      isRead: false),
                  GroupMessage(
                      message: "heey",
                      byMe: true,
                      time_sent: "12:00 pm",
                      isRead: false),
                ],
              ),
            )
          : Expanded(
              child: ListView(
                children: [
                  ChatMessage(
                    message: "heey",
                    byMe: true,
                    time_sent: "12:00 pm",
                    isRead: true,
                  ),
                  ChatMessage(
                      message: "heey",
                      byMe: true,
                      time_sent: "12:00 pm",
                      isRead: true),
                  ChatMessage(
                      message:
                          "heey sssssssssss ssssssssssssssssssssssssssssssssss",
                      byMe: false,
                      time_sent: "12:00 pm",
                      isRead: false),
                  ChatMessage(
                      message: "hee sssssssssssssssssssssssyssssss",
                      byMe: true,
                      time_sent: "12:00 pm",
                      isRead: false),
                  ChatMessage(
                      message: "heey",
                      byMe: false,
                      time_sent: "12:00 pm",
                      isRead: false),
                  ChatMessage(
                      message: "heey",
                      byMe: false,
                      time_sent: "12:00 pm",
                      isRead: false),
                  ChatMessage(
                      message: "heey",
                      byMe: true,
                      time_sent: "12:00 pm",
                      isRead: false),
                ],
              ),
            ),
      ChatInput(
        controller: controller,
        
      ),
    ]);
  }
}

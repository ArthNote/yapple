// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:yapple/widgets/ChatInput.dart';
import 'package:yapple/widgets/ChatMessage.dart';
import 'package:yapple/widgets/GroupMessage.dart';

class SingleChatPage extends StatelessWidget {
  SingleChatPage({super.key, required this.chatName, required this.isGroup});
  final String chatName;
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        leadingWidth: 40,
        title: ListTile(
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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
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

class Body extends StatelessWidget {
  Body({super.key, required this.isGroup});
  final bool isGroup;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      isGroup
          ? Expanded(
              child: ListView(
                children: [
                  GroupMessage(
                    message: "heey",
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
      ChatInput()
    ]);
  }
}

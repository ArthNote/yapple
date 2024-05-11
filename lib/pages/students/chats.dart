// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/firebase/ChatService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/chatModel.dart';
import 'package:yapple/models/chatParticipantModel.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/pages/global/chatPage.dart';
import 'package:yapple/pages/students/createGroupChat.dart';
import 'package:yapple/widgets/ChatItem.dart';
import 'package:yapple/widgets/SearchField.dart';

class StudentChatsPage extends StatefulWidget {
  StudentChatsPage({super.key});

  @override
  State<StudentChatsPage> createState() => _StudentChatsPageState();
}

class _StudentChatsPageState extends State<StudentChatsPage>
    with SingleTickerProviderStateMixin {
  TextEditingController searchController = TextEditingController();
  String uid = "";
  final currentUser = FirebaseAuth.instance.currentUser;
  TabController? _tabController;
  String classID = '';

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    _tabController = TabController(length: 3, vsync: this);
    _tabController!.addListener(_handleTabIndex);
    getDetails();
  }

  void _handleTabIndex() {
    setState(() {});
  }

  void getDetails() async {
    String classid = await UserService().getStudentClass(uid, context);
    setState(() {
      classID = classid;
    });
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
          floatingActionButton: _tabController!.index == 2
              ? FloatingActionButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return CreateGroupChatPage(
                        classID: classID,
                        uid: uid,
                      );
                    }));
                  },
                  child: Icon(
                    Icons.add,
                    color: Theme.of(context).appBarTheme.backgroundColor,
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                )
              : null,
          backgroundColor: Theme.of(context).colorScheme.background,
          body: SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SearchField(
                    onchanged: (value) {},
                    myController: searchController,
                    hintText: "Search",
                    icon: Icons.search,
                    bgColor: Theme.of(context).appBarTheme.backgroundColor!,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  height: 47,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Theme.of(context).colorScheme.secondary),
                  child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerHeight: 0,
                      labelColor: Theme.of(context).colorScheme.background,
                      unselectedLabelStyle:
                          TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                      indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                        shape: BoxShape.rectangle,
                      ),
                      tabs: [
                        Tab(
                          text: "Students",
                        ),
                        Tab(
                          text: "Teachers",
                        ),
                        Tab(
                          text: "Groups",
                        )
                      ]),
                ),
                Expanded(
                  child: TabBarView(controller: _tabController, children: [
                    //students tab
                    StudentSection(
                      uid: uid,
                    ),
                    //teachers tab
                    TeacherSection(uid: uid),

                    //groups tab
                    GroupSection(uid: uid),
                  ]),
                ),
              ],
            ),
          )),
    );
  }
}

class StudentSection extends StatefulWidget {
  final String uid;
  StudentSection({super.key, required this.uid});

  @override
  State<StudentSection> createState() => _StudentSectionState();
}

class _StudentSectionState extends State<StudentSection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatService().getTypedChats(widget.uid, context, "student"),
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
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: List.generate(chats.length, (index) {
                      var chat = chats[index];
                      String chatName = chat.members[0].id == widget.uid
                          ? chat.members[1].name
                          : chat.members[0].name;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                chatName: chatName,
                                isGroup: chat.type == "group" ? true : false,
                                chat: chat,
                                type: 'student',
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
                        ),
                      );
                    }),
                  ),
                )
              ],
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

class TeacherSection extends StatefulWidget {
  final String uid;
  TeacherSection({super.key, required this.uid});

  @override
  State<TeacherSection> createState() => _TeacherSectionState();
}

class _TeacherSectionState extends State<TeacherSection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatService().getTypedChats(widget.uid, context, "teacher"),
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
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: List.generate(chats.length, (index) {
                      var chat = chats[index];
                      String chatName = chat.members[0].id == widget.uid
                          ? chat.members[1].name
                          : chat.members[0].name;
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                chatName: chatName,
                                isGroup: chat.type == "group" ? true : false,
                                chat: chat,
                                type: 'student',
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
                        ),
                      );
                    }),
                  ),
                )
              ],
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

class GroupSection extends StatefulWidget {
  final String uid;
  GroupSection({super.key, required this.uid});

  @override
  State<GroupSection> createState() => _GroupSectionState();
}

class _GroupSectionState extends State<GroupSection> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: ChatService().getTypedChats(widget.uid, context, "group"),
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
            return chatModel(
              id: e.get('id') ?? "",
              lastMessage: e.get('lastMessage') ?? "No messages yet",
              timeSent: e.get('timeSent') != null
                  ? (e.get('timeSent') as Timestamp).toDate()
                  : null,
              unreadMessages: e.get('unreadMessages') ?? 0,
              type: e.get('type') ?? "",
              members: members,
              name: e.get('name'),
              membersId: List<String>.from(e.get('membersId')),
            );
          }).toList();
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    children: List.generate(chats.length, (index) {
                      var chat = chats[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ChatPage(
                                chatName: chat.name!,
                                isGroup: true,
                                chat: chat,
                                type: 'student',
                              ),
                            ),
                          );
                        },
                        child: ChatItem(
                          chatName: chat.name!,
                          last_msg: chat.lastMessage.isEmpty
                              ? "No messages yet"
                              : chat.lastMessage,
                          time_sent: DateFormat.jm().format(chat.timeSent!),
                          runread_msg: chat.unreadMessages,
                        ),
                      );
                    }),
                  ),
                )
              ],
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

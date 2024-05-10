// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:yapple/pages/global/chatPage.dart';
import 'package:yapple/widgets/ChatItem.dart';
import 'package:yapple/widgets/SearchField.dart';

class StudentChatsPage extends StatelessWidget {
  StudentChatsPage({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
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
                Body(),
              ],
            ),
          )),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TabBarView(children: [
        //students tab
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 8, top: 0),
                  itemCount: 12,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    chatName: "Student Name", isGroup: false)),
                          );
                        },
                        child: (ChatItem(
                            chatName: "Student Name",
                            last_msg: "did you check the email we got?",
                            time_sent: "2:12 pm",
                            runread_msg: 3,
                            senderId: "senderId",
                            receiverId: "receiverId")),
                      )),
            )
          ]),
        ),

        //teachers tab
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 8, top: 0),
                  itemCount: 12,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    chatName: "Professor Nader",
                                    isGroup: false)),
                          );
                        },
                        child: (ChatItem(
                            chatName: "Professor Nader",
                            last_msg: "i uploaded the slides",
                            time_sent: "12:00 am",
                            runread_msg: 22,
                            senderId: "senderId",
                            receiverId: "receiverId")),
                      )),
            )
          ]),
        ),

        //groups tab
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: Column(children: [
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.only(bottom: 8, top: 0),
                  itemCount: 12,
                  itemBuilder: (context, index) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChatPage(
                                    chatName: "Software Year 2",
                                    isGroup: true)),
                          );
                        },
                        child: (ChatItem(
                            chatName: "Software Year 2",
                            last_msg:
                                "i didnt understand the assignment either",
                            time_sent: "2:12 pm",
                            runread_msg: 1,
                            senderId: "senderId",
                            receiverId: "receiverId")),
                      )),
            )
          ]),
        ),
      ]),
    );
  }
}

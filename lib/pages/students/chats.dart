// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:yapple/pages/global/login.dart';
import 'package:yapple/pages/students/singleChat.dart';
import 'package:yapple/widgets/ChatItem.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          title: Text(
            'Chats',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
          ),
          centerTitle: false,
          elevation: 0,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(),
                  ),
                );
              },
              icon: Icon(Icons.logout),
              tooltip: "Logout",
            )
          ],
          bottom: TabBar(
              padding: EdgeInsets.symmetric(horizontal: 10),
              indicator: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(10),
                shape: BoxShape.rectangle,
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicatorColor: Theme.of(context).colorScheme.primary,
              labelColor: Theme.of(context).colorScheme.background,
              unselectedLabelStyle:
                  TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              labelStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              tabs: [
                Tab(
                  text: "Students",
                ),
                Tab(
                  text: "Teachers",
                ),
                Tab(
                  text: "Groups",
                ),
              ]),
        ),
        body: Body(),
      ),
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
    return TabBarView(children: [
      //students tab
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: Column(children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 8, top: 10),
                itemCount: 12,
                itemBuilder: (context, index) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SingleChatPage()),
                        );
                      },
                      child: (ChatItem(
                          chatName: "the weird bully",
                          last_msg: "i am gonna kick ur ass u nigga",
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
        padding: EdgeInsets.all(8),
        child: Column(children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 8, top: 10),
                itemCount: 12,
                itemBuilder: (context, index) => (ChatItem(
                    chatName: "spoofing",
                    last_msg: "are u familiar with ibm?",
                    time_sent: "12:00 am",
                    runread_msg: 22,
                    senderId: "senderId",
                    receiverId: "receiverId"))),
          )
        ]),
      ),

      //groups tab
      Padding(
        padding: EdgeInsets.all(8),
        child: Column(children: [
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.only(bottom: 8, top: 10),
                itemCount: 12,
                itemBuilder: (context, index) => (ChatItem(
                    chatName: "hamas",
                    last_msg: "planted the bomb for salwa",
                    time_sent: "2:12 pm",
                    runread_msg: 1,
                    senderId: "senderId",
                    receiverId: "receiverId"))),
          )
        ]),
      ),
    ]);
  }
}

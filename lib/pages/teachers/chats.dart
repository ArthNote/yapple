// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SearchField(
                  myController: searchController,
                  hintText: "Search",
                  icon: Icons.search,
                  bgColor: Theme.of(context).appBarTheme.backgroundColor!,
                  onchanged: (value) {},
                ),
              ),
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
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 8),
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
      ),
    );
  }
}

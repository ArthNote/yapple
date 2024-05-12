// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:yapple/firebase/ChatService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/chatModel.dart';
import 'package:yapple/models/chatParticipantModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/widgets/GroupChatStudentItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class EditGroupMembers extends StatelessWidget {
  EditGroupMembers({super.key, required this.initialChat});
  final chatModel initialChat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Create Group Chat",
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Body(
        initialChat: initialChat,
      ),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key, required this.initialChat});
  final chatModel initialChat;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String uid = "";
  final currentUser = FirebaseAuth.instance.currentUser;
  String classID = '';
  List<chatParticipantModel> participants = [];
  List<String> selectedStudents = [];
  TextEditingController groupNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<String> membersId = [];

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    getDetails();
    for (var participant in widget.initialChat.members) {
      participants.add(participant);
      selectedStudents.add(participant.name);
    }
    groupNameController.text = widget.initialChat.name!;
  }

  void studentToParticipant(studentModel student) {
    participants.add(chatParticipantModel(
      id: student.id,
      name: student.name,
      email: student.email,
      profilePicUrl: student.profilePicUrl,
      role: student.role,
    ));
  }

  void getDetails() async {
    String classid = await UserService().getStudentClass(uid, context);
    setState(() {
      classID = classid;
    });
  }

  void updateGroupChat() async {
    try {
      for (var participant in participants) {
        membersId.add(participant.id);
      }
      var groupChat = chatModel(
        id: widget.initialChat.id,
        lastMessage: widget.initialChat.lastMessage,
        timeSent: widget.initialChat.timeSent,
        unreadMessages: widget.initialChat.unreadMessages,
        type: widget.initialChat.type,
        name: groupNameController.text,
        members: participants,
        membersId: membersId,
      );
      bool isUpdated = await ChatService().updateChatInfo(groupChat);
      if (isUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Group Chat Updated", textAlign: TextAlign.center),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
        //Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Failed to update group chat", textAlign: TextAlign.center),
          backgroundColor: Theme.of(context).colorScheme.error,
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(error.toString()),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextField(
            myController: groupNameController,
            isPass: false,
            hintText: 'Enter Group Name',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 20),
          FutureBuilder<List<studentModel>>(
              future: UserService().getCircleStudents(classID),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<studentModel> students =
                        snapshot.data! as List<studentModel>;
                    return SearchField(
                      controller: searchController,
                      searchInputDecoration: InputDecoration(
                        hintText: 'Search for students',
                        filled: true,
                        hintStyle: TextStyle(
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5),
                        ),
                        fillColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1,
                          ),
                        ),
                      ),
                      itemHeight: 73,
                      maxSuggestionsInViewPort: 6,
                      onSuggestionTap: (p0) {
                        if (selectedStudents
                            .contains(p0.searchKey.toString())) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Student already added",
                              textAlign: TextAlign.center,
                            ),
                            backgroundColor:
                                Theme.of(context).colorScheme.error,
                          ));
                        } else {
                          setState(() {
                            selectedStudents.add(p0.searchKey.toString());
                            studentToParticipant(p0.item as studentModel);
                          });
                        }
                        setState(() {
                          searchController.clear();
                        });
                      },
                      suggestionsDecoration: SuggestionDecoration(
                        color: Theme.of(context).appBarTheme.backgroundColor,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Theme.of(context).colorScheme.secondary,
                          width: 1,
                        ),
                      ),
                      suggestions: List.generate(students.length, (index) {
                        var student = students[index];
                        return SearchFieldListItem(student.name,
                            item: student,
                            child: GroupChatStudentItem(
                              name: student.name,
                              icon: Icons.add,
                            ));
                      }),
                    );
                  } else if (snapshot.hasError) {
                    return Center(child: Text(snapshot.error.toString()));
                  } else {
                    return Center(child: Text("Something went wrong"));
                  }
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              }),
          SizedBox(height: 20),
          MyButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).appBarTheme.backgroundColor!,
            label: 'Update Group Chat',
            onPressed: () => updateGroupChat(),
          ),
          SizedBox(height: 20),
          Expanded(
              child: SingleChildScrollView(
            child: Wrap(
              spacing: 10,
              runSpacing: 20,
              children: List.generate(participants.length, (index) {
                var participant = participants[index];
                return Chip(
                  labelPadding: EdgeInsets.all(5),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1,
                  ),
                  onDeleted: participant.id == uid
                      ? null
                      : () {
                          setState(() {
                            participants.remove(participant);
                            selectedStudents.remove(participant.name);
                          });
                        },
                  deleteIconColor: Theme.of(context).colorScheme.tertiary,
                  deleteIcon: Icon(
                    Icons.delete,
                    size: 20,
                  ),
                  label: Text(
                    participant.name,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 14,
                    ),
                  ),
                );
              }),
            ),
          )),
        ],
      ),
    );
  }
}

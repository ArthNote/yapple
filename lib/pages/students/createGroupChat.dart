// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

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

class CreateGroupChatPage extends StatelessWidget {
  CreateGroupChatPage({
    super.key,
    required this.classID,
    required this.uid,
  });
  final String classID;
  final String uid;

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
        classID: classID,
        uid: uid,
      ),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key, required this.classID, required this.uid});
  final String classID;
  final String uid;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController groupNameController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  List<String> selectedStudents = [];
  List<chatParticipantModel> participants = [];
  List<String> membersId = [];
  var me = chatParticipantModel(
    id: '',
    name: '',
    email: '',
    profilePicUrl: '',
    role: '',
  );

  void studentToParticipant(studentModel student) {
    participants.add(chatParticipantModel(
      id: student.id,
      name: student.name,
      email: student.email,
      profilePicUrl: student.profilePicUrl,
      role: student.role,
    ));
  }

  @override
  void initState() {
    super.initState();
    getMe();
  }

  void getMe() async {
    var user = await UserService().getStudentData(widget.uid, context);
    setState(() {
      participants.add(chatParticipantModel(
        id: user.id,
        name: user.name,
        email: user.email,
        profilePicUrl: user.profilePicUrl,
        role: user.role,
      ));
      selectedStudents.add(user.name);
    });
  }

  void createGroupChat() async {
    try {
      for (var participant in participants) {
        membersId.add(participant.id);
      }
      var groupChat = chatModel(
        id: '',
        lastMessage: '',
        timeSent: DateTime.now(),
        unreadMessages: 0,
        type: 'group',
        name: groupNameController.text,
        members: participants,
        membersId: membersId,
      );
      bool isCreated = await ChatService().startChat(groupChat, context);
      if (isCreated) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Group Chat Created", textAlign: TextAlign.center),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content:
              Text("Failed to create group chat", textAlign: TextAlign.center),
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
              future: UserService().getCircleStudents(widget.classID),
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
            label: 'Create Group Chat',
            onPressed: () => createGroupChat(),
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
                  onDeleted: participant.id == widget.uid
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

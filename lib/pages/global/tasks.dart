// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/firebase/TaskService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/taskModel.dart';
import 'package:yapple/pages/global/addTask.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';
import 'package:yapple/widgets/TaskCard.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Tasks",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  String role = "";
  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    getRole();
  }

  void getRole() async {
    String r = await UserService().getUserType(uid, context);
    setState(() {
      role = r;
    });
  }

  void taskDone(taskModel task) async {
    bool isDone = await TaskService()
        .updateTaskStatus(uid, role, task.id, !task.isCompleted);
    if (isDone) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Task status updated",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Failed to update task status",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
  }

  void deleteTask(String id) async {
    bool isDeleted = await TaskService().deleteTask(uid, role, id);
    if (isDeleted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Task deleted",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to delete task"),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 100,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat.yMMMMd().format(DateTime.now()),
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5)),
                    ),
                    Text(
                      "Today",
                      style: TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).colorScheme.tertiary),
                    ),
                  ],
                ),
                SizedBox(
                  width: 150,
                  height: 50,
                  child: MyButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).appBarTheme.backgroundColor!,
                    label: "Add Task",
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddTaskPage(
                                  uid: uid,
                                  role: role,
                                )),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
        StreamBuilder(
            stream: TaskService().getTasks(uid, role),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<taskModel> tasks = [];
                tasks = snapshot.data!.docs.map((e) {
                  return taskModel(
                    id: e.get('id') ?? "",
                    title: e.get('title') ?? "",
                    note: e.get('note') ?? "",
                    startTime: e.get('startTime') ?? "",
                    endTime: e.get('endTime') ?? "",
                    color: Color(int.parse(e.get('color'))),
                    isCompleted: e.get('isCompleted') ?? false,
                    date: (e.get('date') as Timestamp).toDate(),
                  );
                }).toList();
                if (tasks.isEmpty) {
                  return Center(
                      child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.task,
                        size: 50,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      SizedBox(height: 6),
                      Text("No tasks yet"),
                      SizedBox(height: 10),
                      Text("Add tasks to see them here")
                    ],
                  ));
                }
                return Expanded(
                    child: ListView(
                  children: List.generate(tasks.length, (index) {
                    var task = tasks[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: TaskCard(
                        title: task.title,
                        startTime: task.startTime,
                        endTime: task.endTime,
                        note: task.note,
                        isCompleted: task.isCompleted,
                        color: task.color,
                        onDone: (context) => taskDone(task),
                        onDelete: (context) => deleteTask(task.id),
                      ),
                    );
                  }),
                ));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: Text(snapshot.error.toString()));
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return Center(child: CircularProgressIndicator());
              }
            }),
      ],
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/firebase/TaskService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/taskModel.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AddTaskPage extends StatelessWidget {
  AddTaskPage({super.key, required this.uid, required this.role});
  final String uid;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Add Task",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Body(
        uid: uid,
        role: role,
      ),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key, required this.uid, required this.role});
  final String uid;
  final String role;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController titleController = TextEditingController();

  TextEditingController noteController = TextEditingController();

  TextEditingController startTimeController = TextEditingController();

  TextEditingController endTimeController = TextEditingController();

  List<Color> colors = [
    Color(0xffffcf2f),
    Color(0xff6fe08d),
    Color(0xff61bdfd),
    Color(0xfffc7f7f),
    Color.fromARGB(255, 191, 109, 242),
  ];

  int selectedColor = 0;

  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  void createTask() async {
    if (titleController.text.isNotEmpty &&
        noteController.text.isNotEmpty &&
        startTimeController.text.isNotEmpty &&
        endTimeController.text.isNotEmpty) {
      var newTask = taskModel(
        title: titleController.text,
        note: noteController.text,
        startTime: startTime.format(context),
        endTime: endTime.format(context),
        color: colors[selectedColor],
        isCompleted: false,
        id: '',
        date: DateTime.now(),
      );
      bool isCreated = await TaskService()
          .createTask(newTask, context, widget.role, widget.uid);
      if (isCreated) {
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to create task"),
        ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please fill all the fields"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            MyTextField(
              myController: titleController,
              isPass: false,
              hintText: "Enter task title",
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 20,
            ),
            MyTextField(
              myController: noteController,
              isPass: false,
              hintText: "Enter task note",
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                      myController: startTimeController,
                      isPass: false,
                      hintText: "Start Time",
                      keyboardType: TextInputType.datetime,
                      suffixIcon: IconButton(
                        onPressed: () {
                          var startTimePicked = showTimePicker(
                            initialEntryMode: TimePickerEntryMode.input,
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          startTimePicked.then((selectedTime) {
                            if (selectedTime != null) {
                              String format = DateFormat.Hm().format(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                selectedTime.hour,
                                selectedTime.minute,
                              ));
                              setState(() {
                                startTimeController.text = format;
                                startTime = selectedTime;
                              });
                            }
                          });
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5),
                        ),
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: MyTextField(
                      myController: endTimeController,
                      isPass: false,
                      hintText: "End Time",
                      keyboardType: TextInputType.datetime,
                      suffixIcon: IconButton(
                        onPressed: () {
                          var endTimePicked = showTimePicker(
                            initialEntryMode: TimePickerEntryMode.input,
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          endTimePicked.then((selectedTime) {
                            if (selectedTime != null) {
                              String format = DateFormat.Hm().format(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                selectedTime.hour,
                                selectedTime.minute,
                              ));
                              setState(() {
                                endTimeController.text = format;
                                endTime = selectedTime;
                              });
                            }
                          });
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5),
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select a Color",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: List<Widget>.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: colors[index],
                          child: selectedColor == index
                              ? Icon(
                                  Icons.done,
                                  color: Colors.black,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(
              height: 23,
            ),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label: "Add Task",
              onPressed: () => createTask(),
            ),
          ],
        ),
      ),
    );
  }
}

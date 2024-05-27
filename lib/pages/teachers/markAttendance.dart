// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:yapple/firebase/SessionService.dart';
import 'package:yapple/models/sessionAttendee.dart';
import 'package:yapple/models/sessionModel.dart';
import 'package:yapple/widgets/StudentItem.dart';

class MarkAttendance extends StatefulWidget {
  const MarkAttendance({super.key, required this.session});
  final sessionModel session;

  @override
  State<MarkAttendance> createState() => _MarkAttendanceState();
}

class _MarkAttendanceState extends State<MarkAttendance> {
  List<sessionAttendee> students = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getStudents();
  }

  void getStudents() async {
    var ss = await SessionService().getSessionAttendees(
        widget.session.moduleID, widget.session.classID, widget.session.id);
    setState(() {
      students.addAll(ss);
    });
  }

  void submitAttendance() async {
    bool isSubmitted = await SessionService().updateAttendance(
        widget.session.moduleID,
        widget.session.classID,
        widget.session.id,
        students);
    if (isSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Attendance Submitted',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to submit attendance',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: false,
        title: Text(
          "Mark Attendance",
          style: TextStyle(fontSize: 18),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor!,
                        surfaceTintColor:
                            Theme.of(context).appBarTheme.backgroundColor!,
                        title: Text('Submit Attendance?'),
                        content: Text(
                            ' Are you sure you want to submit the attendance?'),
                        actions: [
                          TextButton(
                            child: Text('Cancel'),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                          TextButton(
                            child: Text('Submit'),
                            onPressed: () {
                              submitAttendance();
                              Navigator.of(context).pop();
                              setState(() {});
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
                child: Text('Submit'),
                style: TextButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).appBarTheme.backgroundColor,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                )),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Expanded(
          child: ListView(
            children: students
                .map((student) => StudentItem(
                      name: student.name,
                      email: student.email,
                      profilePicUrl: student.profilePicUrl,
                      showArrow: false,
                      btn: Checkbox(
                        value: student.isPresent,
                        onChanged: (value) {
                          setState(() {
                            student.isPresent = value!;
                          });
                        },
                      ),
                    ))
                .toList(),
          ),
        ),
      ),
    );
  }
}

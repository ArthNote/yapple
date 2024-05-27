// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/firebase/SessionService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/parentModel.dart';
import 'package:yapple/pages/students/gradesPage.dart';

class ViewAttendance extends StatelessWidget {
  const ViewAttendance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'View Attendance',
          style: TextStyle(fontSize: 17),
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
  parentModel? parent;
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  bool customIcon = false;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    getParent();
  }

  Future<void> getParent() async {
    var p = await UserService().getParent(uid, context);
    setState(() {
      parent = p;
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          getParent();
        });
      },
      child: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<moduleModel>>(
          future: parent != null
              ? ModuleService().getModules(parent!.student.classID)
              : null,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<moduleModel> modules = snapshot.data as List<moduleModel>;
              return ListView(
                children: List.generate(modules.length, (index) {
                  var module = modules[index];
                  return FutureBuilder<List<Map<String, dynamic>>>(
                    future: SessionService().getStudentAttendance(
                        module.id, module.classID, parent!.studentId),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Map<String, dynamic>> sessions =
                            snapshot.data as List<Map<String, dynamic>>;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: ExpansionTile(
                            title: Text(
                              module.name,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            childrenPadding: EdgeInsets.fromLTRB(20, 0, 12, 15),
                            expandedAlignment: Alignment.centerLeft,
                            backgroundColor:
                                Theme.of(context).appBarTheme.backgroundColor,
                            collapsedBackgroundColor:
                                Theme.of(context).appBarTheme.backgroundColor,
                            //add a collapsed shape
                            collapsedShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 1,
                                )),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: BorderSide(
                                  color:
                                      Theme.of(context).colorScheme.secondary,
                                  width: 1,
                                )),
                            children: List.generate(sessions.length, (index) {
                              var session = sessions[index];
                              return AttendanceItem(
                                  date: DateFormat('dd MMMM')
                                      .format(session['date'] as DateTime),
                                  presence: session['isPresent']
                                      ? 'Present'
                                      : 'Absent',
                                  time: session['startTime'] +
                                      ' - ' +
                                      session['endTime']);
                            }),
                            onExpansionChanged: (bool expanded) {
                              setState(() => customIcon = expanded);
                            },
                          ),
                        );
                      } else if (snapshot.hasError) {
                        return Center(child: Text("Error${snapshot.error}"));
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                }),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text("Error${snapshot.error}"));
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class AttendanceItem extends StatelessWidget {
  AttendanceItem(
      {super.key,
      required this.date,
      required this.presence,
      required this.time});
  final String date;
  final String presence;
  final String time;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.only(right: 10),
        leading: Icon(
          Icons.label,
          size: 28,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          date,
          style: TextStyle(
              fontSize: 17, color: Theme.of(context).colorScheme.tertiary),
        ),
        subtitle: Text(
          time,
          style: TextStyle(
              fontSize: 15, color: Theme.of(context).colorScheme.tertiary),
        ),
        trailing: Text(
          presence,
          style: TextStyle(
              fontSize: 15, color: Theme.of(context).colorScheme.tertiary),
        ));
  }
}

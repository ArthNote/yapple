// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yapple/firebase/GradeService.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/gradeModel.dart';
import 'package:yapple/models/moduleModel.dart';

class GradesPage extends StatelessWidget {
  const GradesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Grades',
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
  final currentUser = FirebaseAuth.instance.currentUser;
  String classID = '';
  String uid = "";
  bool customIcon = false;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    getStudentClass();
  }

  Future<void> getStudentClass() async {
    String id = await UserService().getStudentClass(uid, context);
    setState(() {
      classID = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: FutureBuilder<List<moduleModel>>(
        future: ModuleService().getModules(classID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            List<moduleModel> modules = snapshot.data as List<moduleModel>;
            return ListView(
              children: List.generate(modules.length, (index) {
                var module = modules[index];
                return FutureBuilder<List<gradeModel>>(
                  future: GradeService()
                      .getGrades(classID, uid, module.id, module.name),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<gradeModel> grades =
                          snapshot.data as List<gradeModel>;
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
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                              )),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                              )),
                          children: List.generate(grades.length, (index) {
                            var grade = grades[index];
                            return GradeItem(
                              name: grade.title,
                              grade: grade.grade,
                              type: grade.type,
                            );
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
    );
  }
}

class GradeItem extends StatelessWidget {
  GradeItem(
      {super.key, required this.name, required this.grade, required this.type});
  final String name;
  final String grade;
  final String type;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        contentPadding: EdgeInsets.only(right: 10),
        leading: Icon(
          type == 'assignment' ? Icons.assignment_rounded : Icons.quiz_rounded,
          size: 28,
          color: Theme.of(context).colorScheme.primary,
        ),
        title: Text(
          name,
          style: TextStyle(
              fontSize: 17, color: Theme.of(context).colorScheme.tertiary),
        ),
        trailing: Text(
          grade + '/100',
          style: TextStyle(
              fontSize: 15, color: Theme.of(context).colorScheme.tertiary),
        ));
  }
}

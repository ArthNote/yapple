// ignore_for_file: prefer_const_constructors

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yapple/firebase/GradeService.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/gradeModel.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/parentModel.dart';
import 'package:yapple/pages/students/gradesPage.dart';

class ViewGrades extends StatelessWidget {
  const ViewGrades({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'View Grades',
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

  bool customIcon = false;
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
                  return FutureBuilder<List<gradeModel>>(
                    future: GradeService().getGrades(module.classID,
                        parent!.studentId, module.id, module.name),
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
      ),
    );
  }
}

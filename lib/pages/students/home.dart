// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, use_build_context_synchronously

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/starredModel.dart';
import 'package:yapple/pages/global/feedbackPage.dart';
import 'package:yapple/pages/students/courseDetails.dart';
import 'package:yapple/pages/global/tasks.dart';
import 'package:yapple/widgets/ModuleCardSM.dart';

class StudentHomePage extends StatelessWidget {
  const StudentHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  List items = [
    {
      'title': 'Calendar',
      'icon': Icons.calendar_month_rounded,
      'color': Color(0xffffcf2f)
    },
    {
      'title': 'Tasks',
      'icon': Icons.task_rounded,
      'color': Color(0xff6fe08d),
      'page': TasksPage(),
    },
    {
      'title': 'Feedback',
      'icon': Icons.feedback_rounded,
      'color': Color(0xff61bdfd),
      'page': FeedbackPage(),
    },
    {
      'title': 'Grades',
      'icon': Icons.grading_rounded,
      'color': Color(0xfffc7f7f)
    }
  ];

  ModuleService moduleService = ModuleService();
  final currentUser = FirebaseAuth.instance.currentUser;
  String classID = '';
  String uid = "";
  Set<String> starredModulesIds = Set<String>();

  Future<void> loadStarredModules() async {
    List<starredModel> stares =
        await moduleService.getStarredModules(uid, 'students');
    setState(() {
      starredModulesIds = Set<String>.from(stares.map((star) => star.id));
    });
  }

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
      loadStarredModules();
    }
    getStudentClass();
  }

  Future<void> getStudentClass() async {
    String id = await UserService().getStudentClass(uid, context);
    setState(() {
      classID = id;
    });
  }

  void starModule(moduleModel module) async {
    var newStar = starredModel(
      id: "",
      name: module.name,
      category: module.category,
      code: module.code,
      color: module.color,
      icon: module.icon,
    );
    bool check =
        await moduleService.checkStarred('students', uid, module.id, context);
    if (check == true) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Remove Starred?",
              style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
            ),
            content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "This module is already starred.",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
                SizedBox(
                  height: 10,
                ),
                Text(
                  "Are you sure you want to remove it?",
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                },
                child: Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close the dialog
                  removeStarred(module.id);
                },
                child: Text("Remove"),
              ),
            ],
          );
        },
      );
    } else {
      bool r = await moduleService.starModule(
          newStar, 'students', uid, context, module.id);
      if (r == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Starred successfully"),
        ));
        setState(() {
          loadStarredModules();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Something went wrong while starring"),
        ));
      }
    }
  }

  void removeStarred(String moduleId) async {
    bool result =
        await moduleService.removeStar('students', uid, moduleId, context);
    if (result) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Starred removed successfully"),
      ));
      setState(() {
        loadStarredModules();
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Something went wrong while removing starred"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //news block
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Image.asset(
                          'assets/yapple.png',
                          color: Theme.of(context).appBarTheme.backgroundColor,
                        ),
                      ),
                      Icon(
                        Icons.notifications,
                        size: 30,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                      )
                    ]),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Hi, Student!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    wordSpacing: 2,
                    color: Theme.of(context).appBarTheme.backgroundColor,
                  ),
                )
              ],
            ),
          ),
        ),

        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: items
                .map((item) => Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (item['page'] != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          item['page'] as Widget));
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: item['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Icon(
                              item['icon'] as IconData,
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              size: 30,
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(item['title'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.tertiary,
                            ))
                      ],
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            "Starred Modules",
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
        ),
        SizedBox(
          height: 15,
        ),

        //courses list
        FutureBuilder<List<moduleModel>>(
            future: moduleService.getModules(classID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<moduleModel> modules =
                      snapshot.data! as List<moduleModel>;
                  List<moduleModel> starredModules = modules
                      .where((module) => starredModulesIds.contains(module.id))
                      .toList();
                  if (starredModulesIds.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.star_outline,
                          size: 50,
                          color: Colors.yellow.shade700,
                        ),
                        SizedBox(height: 6),
                        Text("No starred modules yet"),
                        SizedBox(height: 10),
                        Text("Star modules to see them here")
                      ],
                    ));
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: SizedBox(
                      height: 160,
                      child: ListView(
                        padding: EdgeInsets.all(10),
                        scrollDirection: Axis.horizontal,
                        children: List.generate(starredModules.length, (index) {
                          var module = starredModules[index];
                          bool isStarred =
                              starredModulesIds.contains(module.id);
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StudentCourseDetailsPage(
                                    module: module,
                                  ),
                                ),
                              );
                            },
                            child: ModuleCardSM(
                              moduleName: module.name,
                              moduleCode: module.code,
                              moduleCategory: module.category,
                              isStarred: isStarred,
                              color: module.color,
                              onPressed: () => starModule(module),
                            ),
                          );
                        }),
                      ),
                    ),
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
      ],
    ));
  }
}

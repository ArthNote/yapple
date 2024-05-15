// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, must_be_immutable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/starredModel.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/pages/students/courseDetails.dart';
import 'package:yapple/pages/teachers/courseDetails.dart';
import 'package:yapple/widgets/ModuleCardMD.dart';
import 'package:yapple/widgets/SearchField.dart';

class TeacherCoursesPage extends StatelessWidget {
  const TeacherCoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(child: Body()),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController searchController = TextEditingController();

  ModuleService moduleService = ModuleService();
  final currentUser = FirebaseAuth.instance.currentUser;
  List<moduleModel> foundModules = [];
  String searchTerm = "";
  String uid = "";

  Set<String> starredModulesIds = Set<String>();

  Future<void> loadStarredModules() async {
    List<starredModel> stares =
        await moduleService.getStarredModules(uid, 'teachers');
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
  }

  Future<List<moduleModel>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final modules = await moduleService.getTeacherModules(uid);
    List<moduleModel> results = [];
    if (enteredKeyword.isEmpty) {
      return results = modules;
    } else {
      results = modules
          .where((module) =>
              module.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              module.category
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              module.code.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    return foundModules = results;
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
        await moduleService.checkStarred('teachers', uid, module.id, context);
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
          newStar, 'teachers', uid, context, module.id);
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
        await moduleService.removeStar('teachers', uid, moduleId, context);
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
    //get size of screen

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchField(
            myController: searchController,
            hintText: "Search",
            icon: Icons.search,
            bgColor: Theme.of(context).appBarTheme.backgroundColor!,
            onchanged: (value) {
              setState(() {
                searchTerm = value;
              });
            },
          ),
        ),
        SizedBox(
          height: 10,
        ),
        //courses list
        FutureBuilder<List<moduleModel>>(
            future: runFilter(searchTerm),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<moduleModel> modules =
                      snapshot.data! as List<moduleModel>;
                  return Expanded(
                    child: GridView.count(
                      crossAxisCount: 2,
                      childAspectRatio: 0.78,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      children: List.generate(modules.length, (index) {
                        var module = modules[index];
                        bool isStarred = starredModulesIds.contains(module.id);
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeacherCourseDetailsPage(
                                  module: module,
                                ),
                              ),
                            );
                          },
                          child: ModuleCardMD(
                            isStarred: isStarred,
                            moduleName: module.name,
                            moduleCategory: module.category,
                            color: module.color,
                            icon: module.icon,
                            onPressed: () => starModule(module),
                          ),
                        );
                      }),
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
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/pages/admin/addModule.dart';
import 'package:yapple/pages/admin/adminModulePage.dart';
import 'package:yapple/pages/admin/editModule.dart';
import 'package:yapple/pages/students/courseDetails.dart';
import 'package:yapple/widgets/ModuleCardMD.dart';
import 'package:yapple/widgets/ProfileDialog.dart';
import 'package:yapple/widgets/SearchField.dart';
import 'package:yapple/widgets/StudentItem.dart';

class ClassModules extends StatefulWidget {
  const ClassModules({super.key, required this.classID});
  final String classID;

  @override
  State<ClassModules> createState() => _ClassModulesState();
}

class _ClassModulesState extends State<ClassModules>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabIndex);
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Modules',
            style: TextStyle(fontSize: 17),
          ),
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(
                text: "Modules",
              ),
              Tab(
                text: "Students",
              ),
            ],
          ),
        ),
        floatingActionButton: _tabController!.index == 0
            ? FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AddModule(
                        classID: widget.classID,
                      ),
                    ),
                  );
                },
                child: Icon(Icons.add),
                backgroundColor: Theme.of(context).colorScheme.primary,
              )
            : null,
        body: TabBarView(
          controller: _tabController,
          children: [
            Body(
              classID: widget.classID,
            ),
            BodyStudents(
              classID: widget.classID,
            )
          ],
        ));
  }
}

class Body extends StatefulWidget {
  const Body({super.key, required this.classID});
  final String classID;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController searchController = TextEditingController();
  List<moduleModel> foundModules = [];
  String searchTerm = "";

  Future<List<moduleModel>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final modules = await ModuleService().getModules(widget.classID);
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
              module.code
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              module.teacher.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    return foundModules = results;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: [
            MySearchField(
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
            SizedBox(
              height: 20,
            ),
            //courses list
            FutureBuilder<List<moduleModel>>(
                future: runFilter(searchTerm),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<moduleModel> modules =
                          snapshot.data! as List<moduleModel>;

                      if (modules.isEmpty) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 50),
                            Icon(
                              Icons.class_,
                              size: 50,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            SizedBox(height: 6),
                            Text("No modules yet"),
                            SizedBox(height: 10),
                            Text("Add modules to see them here")
                          ],
                        ));
                      }
                      return Expanded(
                        child: GridView.count(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78,
                          mainAxisSpacing: 20,
                          crossAxisSpacing: 20,
                          children: List.generate(modules.length, (index) {
                            var module = modules[index];
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => AdminModulePage(
                                      module: module,
                                    ),
                                  ),
                                );
                              },
                              child: ModuleCardMD(
                                isStarred: false,
                                moduleName: module.name,
                                moduleCategory: module.category,
                                color: module.color,
                                icon: module.icon,
                                btn: PopupMenuButton(
                                  icon: Icon(Icons.more_horiz),
                                  padding: EdgeInsets.zero,
                                  iconColor: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  color: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  surfaceTintColor: Theme.of(context)
                                      .appBarTheme
                                      .backgroundColor,
                                  itemBuilder: (context) => [
                                    PopupMenuItem(
                                      child: ListTile(
                                        title: Text("Edit Record"),
                                        leading: Icon(Icons.edit),
                                        onTap: () {
                                          Navigator.pop(context);
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditModule(
                                                        module: module,
                                                      )));
                                        },
                                      ),
                                    ),
                                    PopupMenuItem(
                                      child: ListTile(
                                        title: Text("Delete Module"),
                                        leading: Icon(Icons.delete),
                                        onTap: () {
                                          Navigator.pop(context);
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .appBarTheme
                                                        .backgroundColor!,
                                                surfaceTintColor:
                                                    Theme.of(context)
                                                        .appBarTheme
                                                        .backgroundColor!,
                                                title: Text('Delete Module'),
                                                content: Text(
                                                    'Are you sure you want to delete this module?'),
                                                actions: [
                                                  TextButton(
                                                    child: Text('Cancel'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Delete'),
                                                    onPressed: () async {
                                                      await ModuleService()
                                                          .deleteModule(
                                                              widget.classID,
                                                              module.id);
                                                      Navigator.of(context)
                                                          .pop();
                                                      setState(() {});
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                onPressed: () {},
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
        ),
      ),
    );
  }
}

class BodyStudents extends StatefulWidget {
  BodyStudents({super.key, required this.classID});
  final String classID;

  @override
  State<BodyStudents> createState() => _BodyStudentsState();
}

class _BodyStudentsState extends State<BodyStudents> {
  List<studentModel> foundStudents = [];

  String searchTerm = "";

  TextEditingController searchController = TextEditingController();

  UserService userService = UserService();

  Future<List<studentModel>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final students = await userService.getCircleStudents(widget.classID);
    List<studentModel> results = [];
    if (enteredKeyword.isEmpty) {
      return results = students;
    } else {
      results = students
          .where((student) =>
              student.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    return foundStudents = results;
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            MySearchField(
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
            SizedBox(
              height: 15,
            ),
            FutureBuilder<List<studentModel>>(
                future: runFilter(searchTerm),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<studentModel> students =
                          snapshot.data! as List<studentModel>;
                      if (students.isEmpty) {
                        return Center(
                            child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(height: 50),
                            Icon(
                              Icons.group,
                              size: 50,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            SizedBox(height: 6),
                            Text("No students yet"),
                            SizedBox(height: 10),
                            Text("Add students to see them here")
                          ],
                        ));
                      }
                      return Expanded(
                        child: ListView(
                          children: students
                              .map((student) => GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ProfileDialog(
                                          name: student.name,
                                          email: student.email,
                                          profilePicUrl: student.profilePicUrl,
                                          role: "Student",
                                          onPressed: () {},
                                        ),
                                      );
                                    },
                                    child: StudentItem(
                                      name: student.name,
                                      email: student.email,
                                      profilePicUrl: student.profilePicUrl,
                                    ),
                                  ))
                              .toList(),
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
        ),
      ),
    );
  }
}

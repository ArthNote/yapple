// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:yapple/firebase/AuthService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/parentModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/models/teacherModel.dart';
import 'package:yapple/pages/admin/addParent.dart';
import 'package:yapple/pages/admin/addTeacher.dart';
import 'package:yapple/pages/admin/createStudentExcel.dart';
import 'package:yapple/pages/admin/editParent.dart';
import 'package:yapple/pages/admin/editStudent.dart';
import 'package:yapple/pages/admin/editTeacher.dart';
import 'package:yapple/pages/admin/viewInActiveUsers.dart';
import 'package:yapple/widgets/ProfileDialog.dart';
import 'package:yapple/widgets/SearchField.dart';
import 'package:yapple/widgets/StudentItem.dart';

class AdminUsersPage extends StatelessWidget {
  const AdminUsersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            actions: [
              PopupMenuButton(
                color: Theme.of(context).appBarTheme.backgroundColor,
                surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    child: ListTile(
                      title: Text("View inActive Users"),
                      leading: Icon(Icons.group),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ViewInActiveUsers()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      title: Text("Add Student"),
                      leading: Icon(Icons.face),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CreateStudentsExcel()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      title: Text("Add Teacher"),
                      leading: Icon(Icons.badge),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddTeacher()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      title: Text("Add Parent"),
                      leading: Icon(Icons.family_restroom),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddParent()));
                      },
                    ),
                  ),
                  PopupMenuItem(
                    child: ListTile(
                      title: Text("Logout"),
                      leading: Icon(Icons.logout),
                      onTap: () => AuthService().logout(context),
                    ),
                  ),
                ],
              )
            ],
            automaticallyImplyLeading: false,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text('Users'),
            centerTitle: true,
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                  text: "Students",
                ),
                Tab(
                  text: "Teachers",
                ),
                Tab(
                  text: "Parents",
                ),
              ],
            )),
        body: Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return TabBarView(
      children: [
        StudentsSide(),
        TeachersSide(),
        ParentsSide(),
      ],
    );
  }
}

class StudentsSide extends StatefulWidget {
  const StudentsSide({super.key});

  @override
  State<StudentsSide> createState() => _StudentsSideState();
}

class _StudentsSideState extends State<StudentsSide> {
  TextEditingController searchController = TextEditingController();

  UserService userService = UserService();

  List<studentModel> foundStudents = [];
  String searchTerm = "";

  Future<List<studentModel>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final students = await userService.getAllActiveStudents();
    List<studentModel> results = [];
    if (enteredKeyword.isEmpty) {
      return results = students;
    } else {
      results = students
          .where((student) =>
              student.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              student.major
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
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
                                          role: student.major,
                                          showButton: false,
                                        ),
                                      );
                                    },
                                    child: StudentItem(
                                      name: student.name,
                                      email: student.email,
                                      profilePicUrl: student.profilePicUrl,
                                      showArrow: false,
                                      btn: PopupMenuButton(
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
                                                            EditStudent(
                                                              student: student,
                                                              col: 'students',
                                                            )));
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              title: Text("Delete Record"),
                                              leading: Icon(Icons.delete),
                                              onTap: () {
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .appBarTheme
                                                            .backgroundColor,
                                                    surfaceTintColor:
                                                        Theme.of(context)
                                                            .appBarTheme
                                                            .backgroundColor,
                                                    title:
                                                        Text("Delete Record"),
                                                    content: Text(
                                                        "Are you sure you want to delete this record?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await userService
                                                              .deleteUser(
                                                                  'students',
                                                                  student.id);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Delete"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
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

class TeachersSide extends StatefulWidget {
  const TeachersSide({super.key});

  @override
  State<TeachersSide> createState() => _TeachersSideState();
}

class _TeachersSideState extends State<TeachersSide> {
  TextEditingController searchController = TextEditingController();

  UserService userService = UserService();

  List<teacherModel> foundTeachers = [];
  String searchTerm = "";

  Future<List<teacherModel>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final teachers = await userService.getAllActiveTeachers();
    List<teacherModel> results = [];
    if (enteredKeyword.isEmpty) {
      return results = teachers;
    } else {
      results = teachers
          .where((teacher) =>
              teacher.name.toLowerCase().contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    return foundTeachers = results;
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
            FutureBuilder<List<teacherModel>>(
                future: runFilter(searchTerm),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<teacherModel> teachers =
                          snapshot.data! as List<teacherModel>;
                      return Expanded(
                        child: ListView(
                          children: teachers
                              .map((teacher) => GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ProfileDialog(
                                          name: teacher.name,
                                          email: teacher.email,
                                          profilePicUrl: teacher.profilePicUrl,
                                          role: teacher.role,
                                          showButton: false,
                                        ),
                                      );
                                    },
                                    child: StudentItem(
                                      name: teacher.name,
                                      email: teacher.email,
                                      profilePicUrl: teacher.profilePicUrl,
                                      showArrow: false,
                                      btn: PopupMenuButton(
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
                                                            EditTeacher(
                                                              teacher: teacher,
                                                              col: 'teachers',
                                                            )));
                                              },
                                            ),
                                          ),
                                          PopupMenuItem(
                                            child: ListTile(
                                              title: Text("Delete Record"),
                                              leading: Icon(Icons.delete),
                                              onTap: () {
                                                Navigator.pop(context);
                                                showDialog(
                                                  context: context,
                                                  builder: (context) =>
                                                      AlertDialog(
                                                    backgroundColor:
                                                        Theme.of(context)
                                                            .appBarTheme
                                                            .backgroundColor,
                                                    surfaceTintColor:
                                                        Theme.of(context)
                                                            .appBarTheme
                                                            .backgroundColor,
                                                    title:
                                                        Text("Delete Record"),
                                                    content: Text(
                                                        "Are you sure you want to delete this record?"),
                                                    actions: [
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Cancel"),
                                                      ),
                                                      TextButton(
                                                        onPressed: () async {
                                                          await userService
                                                              .deleteUser(
                                                                  'teachers',
                                                                  teacher.id);
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Delete"),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
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

class ParentsSide extends StatefulWidget {
  const ParentsSide({super.key});

  @override
  State<ParentsSide> createState() => _ParentsSideState();
}

class _ParentsSideState extends State<ParentsSide> {
  TextEditingController searchController = TextEditingController();

  UserService userService = UserService();

  List<parentModel> foundParents = [];
  String searchTerm = "";

  Future<List<parentModel>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final parents = await userService.getAllActiveParents();
    List<parentModel> results = [];
    if (enteredKeyword.isEmpty) {
      return results = parents;
    } else {
      results = parents
          .where((parent) =>
              parent.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              parent.student.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    return foundParents = results;
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
            FutureBuilder<List<parentModel>>(
                future: runFilter(searchTerm),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<parentModel> parents =
                          snapshot.data! as List<parentModel>;
                      return Expanded(
                        child: ListView(
                          children: parents
                              .map((parent) => GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ProfileDialog(
                                          name: parent.name,
                                          email: parent.email,
                                          profilePicUrl: parent.profilePicUrl,
                                          role: parent.student.name,
                                          showButton: false,
                                        ),
                                      );
                                    },
                                    child: StudentItem(
                                        name: parent.name,
                                        email: parent.email,
                                        profilePicUrl: parent.profilePicUrl,
                                        showArrow: false,
                                        btn: PopupMenuButton(
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
                                                              EditParent(
                                                                parent: parent,
                                                                col: 'parents',
                                                              )));
                                                },
                                              ),
                                            ),
                                            PopupMenuItem(
                                              child: ListTile(
                                                title: Text("Delete Record"),
                                                leading: Icon(Icons.delete),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  showDialog(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      backgroundColor:
                                                          Theme.of(context)
                                                              .appBarTheme
                                                              .backgroundColor,
                                                      surfaceTintColor:
                                                          Theme.of(context)
                                                              .appBarTheme
                                                              .backgroundColor,
                                                      title:
                                                          Text("Delete Record"),
                                                      content: Text(
                                                          "Are you sure you want to delete this record?"),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () {
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("Cancel"),
                                                        ),
                                                        TextButton(
                                                          onPressed: () async {
                                                            await userService
                                                                .deleteUser(
                                                                    'parents',
                                                                    parent.id);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Text("Delete"),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                },
                                              ),
                                            ),
                                          ],
                                        )),
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

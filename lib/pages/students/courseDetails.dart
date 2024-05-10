// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/pages/students/assigmentPage.dart';
import 'package:yapple/pages/students/quizzPage.dart';
import 'package:yapple/widgets/AssigmentItem.dart';
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/ProfileDialog.dart';
import 'package:yapple/widgets/QuizzItem.dart';
import 'package:yapple/widgets/SearchField.dart';
import 'package:yapple/widgets/StudentItem.dart';

class StudentCourseDetailsPage extends StatelessWidget {
  final moduleModel module;
  StudentCourseDetailsPage({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(
              module.name,
              style: TextStyle(fontSize: 17),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                  text: "Details",
                ),
                Tab(
                  text: "Resources",
                ),
                Tab(
                  text: "Circle",
                ),
              ],
            )),
        body: TabBarView(
          children: [
            SingleChildScrollView(
              child: BodyDetails(
                module: module,
              ),
            ),
            BodyResources(),
            BodyCircle(
              module: module,
            ),
          ],
        ),
      ),
    );
  }
}

class BodyDetails extends StatelessWidget {
  final moduleModel module;
  BodyDetails({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Icon(
              module.icon,
              size: 80,
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
            decoration: BoxDecoration(
              color: module.color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 30),
          Text(
            module.name,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            color: Theme.of(context).colorScheme.tertiary,
            height: 1,
          ),
          SizedBox(
            height: 15,
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ProfileDialog(
                  name: module.teacher.name,
                  email: module.teacher.email,
                  role: module.teacher.role,
                ),
              );
            },
            tileColor: Theme.of(context).colorScheme.secondary,
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: Text(
              module.teacher.name,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text("Teacher"),
            trailing: Icon(
              Icons.arrow_forward_rounded,
              color: Theme.of(context).colorScheme.tertiary,
              size: 30,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "About the module:",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            module.about,
            textAlign: TextAlign.justify,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          )
        ],
      ),
    );
  }
}

class BodyCircle extends StatefulWidget {
  final moduleModel module;
  BodyCircle({super.key, required this.module});

  @override
  State<BodyCircle> createState() => _BodyCircleState();
}

class _BodyCircleState extends State<BodyCircle> {
  TextEditingController searchController = TextEditingController();

  UserService userService = UserService();

  List<studentModel> foundStudents = [];
  String searchTerm = "";

  Future<List<studentModel>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final students = await userService.getCircleStudents(widget.module.classID);
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          SearchField(
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
                                        role: "Student",
                                      ),
                                    );
                                  },
                                  child: StudentItem(
                                    name: student.name,
                                    email: student.email,
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
    );
  }
}

class BodyResources extends StatefulWidget {
  const BodyResources({super.key});

  @override
  State<BodyResources> createState() => _BodyResourcesState();
}

class _BodyResourcesState extends State<BodyResources> {
  bool customIcon = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                "Content Material",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              childrenPadding: EdgeInsets.fromLTRB(20, 0, 12, 15),
              expandedAlignment: Alignment.centerLeft,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
              children: students
                  .map((student) => ContentMaterialItem(
                        name: "Introduction to Flutter",
                        icon: Icons.download_rounded,
                        onPressed: () {},
                      ))
                  .toList(),
              onExpansionChanged: (bool expanded) {
                setState(() => customIcon = expanded);
              },
            ),
            SizedBox(
              height: 30,
            ),
            ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "Assigments",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 15),
              expandedAlignment: Alignment.centerLeft,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
              children: students
                  .map(
                    (student) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StudentAssignmentPage(
                                      name: "PRAC1",
                                    )));
                      },
                      child: AssigmentItem(
                        name: "PRAC1",
                      ),
                    ),
                  )
                  .toList(),
              onExpansionChanged: (bool expanded) {
                setState(() => customIcon = expanded);
              },
            ),
            SizedBox(
              height: 30,
            ),
            ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "Quizzes",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
              childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 15),
              expandedAlignment: Alignment.centerLeft,
              backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
              children: students
                  .map(
                    (student) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => QuizzPage(
                                      name: "Simple quizz",
                                    )));
                      },
                      child: QuizzItem(
                        name: "Simple quizz",
                      ),
                    ),
                  )
                  .toList(),
              onExpansionChanged: (bool expanded) {
                setState(() => customIcon = expanded);
              },
            ),
          ],
        ),
      ),
    );
  }
}

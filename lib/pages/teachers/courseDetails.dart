// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last, must_be_immutable, prefer_const_constructors_in_immutables

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/pages/students/quizzPage.dart';
import 'package:yapple/pages/teachers/addAssignment.dart';
import 'package:yapple/pages/teachers/addQuizz.dart';
import 'package:yapple/pages/teachers/assignmentPage.dart';
import 'package:yapple/widgets/AssigmentItem.dart';
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/ProfileDialog.dart';
import 'package:yapple/widgets/QuizzItem.dart';
import 'package:yapple/widgets/SearchField.dart';
import 'package:yapple/widgets/StudentItem.dart';

class TeacherCourseDetailsPage extends StatefulWidget {
  TeacherCourseDetailsPage({super.key, required this.moduleName});
  final String moduleName;

  @override
  State<TeacherCourseDetailsPage> createState() =>
      _TeacherCourseDetailsPageState();
}

class _TeacherCourseDetailsPageState extends State<TeacherCourseDetailsPage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
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
          title: Text(
            widget.moduleName,
            style: TextStyle(fontSize: 17),
          ),
          bottom: TabBar(
            controller: _tabController,
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
                text: "Students",
              ),
            ],
          )),
      body: TabBarView(
        controller: _tabController,
        children: [
          BodyDetails(
            moduleName: widget.moduleName,
          ),
          BodyResources(),
          BodyCircle(),
        ],
      ),
      floatingActionButton: _tabController!.index == 1
          ? SpeedDial(
              foregroundColor: Colors.white,
              spacing: 20,
              spaceBetweenChildren: 10,
              animatedIcon: AnimatedIcons.menu_close,
              children: [
                SpeedDialChild(
                  shape: CircleBorder(),
                  child: Icon(Icons.file_present_rounded),
                  label: "Add content",
                  onTap: () async {
                    await FilePicker.platform.pickFiles(allowMultiple: true);
                  },
                ),
                SpeedDialChild(
                  shape: CircleBorder(),
                  child: Icon(Icons.assignment_rounded),
                  label: "Add assigment",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddAssignmentPage()));
                  },
                ),
                SpeedDialChild(
                  shape: CircleBorder(),
                  child: Icon(Icons.quiz_rounded),
                  label: "Add quiz",
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddQuizzPage()));
                  },
                ),
              ],
            )
          : null,
    );
  }
}

class BodyDetails extends StatelessWidget {
  BodyDetails({super.key, required this.moduleName});
  final String moduleName;

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
              Icons.code,
              size: 80,
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 30),
          Text(
            moduleName,
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
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nec semper quam. Integer suscipit efficitur est, ac consectetur diam blandit ut. In hac habitasse platea dictumst. Aliquam erat volutpat. Vestibulum vitae consectetur justo. Suspendisse potenti. Quisque ultricies rutrum bibendum.",
            textAlign: TextAlign.justify,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          )
        ],
      ),
    );
  }
}

class BodyCircle extends StatelessWidget {
  BodyCircle({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          SearchField(
            onchanged: (value) {},
            myController: searchController,
            hintText: "Search",
            icon: Icons.search,
            bgColor: Theme.of(context).appBarTheme.backgroundColor!,
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView(
              children: students
                  .map((student) => GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => ProfileDialog(
                              name: student['name'].toString(),
                              email: student['email'].toString(),
                              role: "Student",
                            ),
                          );
                        },
                        child: StudentItem(
                          name: student['name'].toString(),
                          email: student['email'].toString(),
                        ),
                      ))
                  .toList(),
            ),
          )
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
                        icon: Icons.delete_rounded,
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
                                builder: (context) => TeacherAssignmentPage(
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
                        iconButton: IconButton(
                          color: Theme.of(context).colorScheme.primary,
                          icon: Icon(
                            Icons.delete_rounded,
                          ),
                          onPressed: () {},
                        ),
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

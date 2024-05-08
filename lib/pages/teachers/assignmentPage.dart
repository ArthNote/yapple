// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:open_file/open_file.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/pages/teachers/submissionPage.dart';
import 'package:yapple/widgets/AssigmentAbout.dart';
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/UploadedAssigmentItem.dart';
import 'package:yapple/widgets/submissionItem.dart';

class TeacherAssignmentPage extends StatelessWidget {
  TeacherAssignmentPage({super.key, required this.name});
  final String name;
  TextEditingController aboutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          name,
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Body(),
      floatingActionButton: SpeedDial(
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
              var result =
                  await FilePicker.platform.pickFiles(allowMultiple: true);
            },
          ),
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.edit),
            label: "Edit About Section",
            onTap: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AssigmentAbout(
                    controller: aboutController,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool customIcon = false;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "About",
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
              children: [
                Text(
                  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nec semper quam. Integer suscipit efficitur est, ac consectetur diam blandit ut. In hac habitasse platea dictumst. Aliquam erat volutpat. Vestibulum vitae consectetur justo. Suspendisse potenti. Quisque ultricies rutrum bibendum. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nec semper quam. Integer suscipit efficitur est, ac consectetur diam blandit ut. In hac habitasse platea dictumst. Aliquam erat volutpat. Vestibulum vitae consectetur justo. Suspendisse potenti. Quisque ultricies rutrum bibendum.",
                  textAlign: TextAlign.justify,
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                ),
              ],
              onExpansionChanged: (bool expanded) {
                setState(() => customIcon = expanded);
              },
            ),
            SizedBox(
              height: 10,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Due date',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
              subtitle: Text(
                'Sun 21 april 2024, 04:00 PM',
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            SizedBox(
              height: 15,
            ),
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
              height: 15,
            ),
            submissions.isNotEmpty
                ? ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Submissions",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    children: submissions
                        .map((submission) => GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SubmissionPage(
                                            submission: submission,
                                          )),
                                );
                              },
                              child: SubmissionItem(
                                name: submission['name'] as String,
                                isGraded: submission['graded'] as bool,
                              ),
                            ))
                        .toList(),
                    onExpansionChanged: (bool expanded) {
                      setState(() => customIcon = expanded);
                    },
                  )
                : SizedBox(),
            SizedBox(
              height: 50,
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:yapple/firebase/AssignmentService.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/models/assignmentModel.dart';
import 'package:yapple/models/materialModel.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/pages/teachers/submissionPage.dart';
import 'package:yapple/widgets/AssigmentAbout.dart';
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/submissionItem.dart';

class TeacherAssignmentPage extends StatelessWidget {
  TeacherAssignmentPage(
      {super.key,
      required this.assignment,
      required this.classID,
      required this.moduleID});
  final assignmentModel assignment;
  final String classID;
  final String moduleID;
  TextEditingController aboutController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          assignment.title,
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Body(
        assignment: assignment,
        classID: classID,
        moduleID: moduleID,
      ),
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
  final assignmentModel assignment;
  final String classID;
  final String moduleID;
  const Body(
      {super.key,
      required this.assignment,
      required this.classID,
      required this.moduleID});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  void deleteMaterial(String materialID) async {
    bool deleted = await AssignmentService().deleteModuleMaterial(
        widget.classID, widget.moduleID, materialID, widget.assignment.id);
    if (deleted == true) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Material deleted successfully"),
      ));
      setState(() {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to delete material"),
      ));
    }
  }

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
                  widget.assignment.description,
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
                DateFormat('EEE d MMMM yyyy, hh:mm a')
                    .format(widget.assignment.dueDate),
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            FutureBuilder<List<materialModel>>(
              future: AssignmentService().getAssignmentMaterials(
                  widget.classID, widget.moduleID, widget.assignment.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<materialModel> materials =
                      snapshot.data as List<materialModel>;
                  return ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Content Material",
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
                    children: List.generate(materials.length, (index) {
                      var material = materials[index];
                      return ContentMaterialItem(
                        name: material.name,
                        icon: Icons.delete,
                        onPressed: () => deleteMaterial(material.id),
                      );
                    }),
                    onExpansionChanged: (bool expanded) {
                      setState(() => customIcon = expanded);
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error${snapshot.error}"));
                }
                return Center(child: CircularProgressIndicator());
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

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yapple/firebase/AssignmentService.dart';
import 'package:yapple/models/assignmentModel.dart';
import 'package:yapple/models/materialModel.dart';
import 'package:http/http.dart' as http;
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/SubmissionStatusBox.dart';
import 'package:yapple/widgets/UploadedAssigmentItem.dart';

class StudentAssignmentPage extends StatelessWidget {
  StudentAssignmentPage(
      {super.key,
      required this.assignment,
      required this.classID,
      required this.moduleID});
  final assignmentModel assignment;
  final String classID;
  final String moduleID;

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
  bool customIcon = false;
  List<PlatformFile> files = [];

  void downloadFile(materialModel material) async {
    final directory = await getApplicationDocumentsDirectory();
    String materialName = material.name;
    final File file = File('${directory.path}/$materialName');
    final response = await http.get(Uri.parse(material.url));

    if (response.statusCode == 200) {
      await file.writeAsBytes(response.bodyBytes);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("File downloaded"),
      ));
      print('file downloaded to ' + file.path);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to download file"),
      ));
    }
  }

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
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Status',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
              subtitle: Row(
                children: [
                  SubmissionStatusBox(
                    name: "Not Submitted",
                    color: Colors.red.shade400,
                    //Colors.green.shade400
                  ),
                  SizedBox(width: 10),
                  SubmissionStatusBox(
                    name: "Not Graded",
                    color: Colors.red.shade400,
                  ),
                ],
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
                        icon: Icons.download_rounded,
                        onPressed: () => downloadFile(material),
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
            files.isNotEmpty
                ? ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Uploaded Files",
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
                    children: files
                        .map((file) => UploadedAssigmentItem(
                              name: file.name,
                              onPressed: () {
                                setState(() {
                                  files.remove(file);
                                });
                              },
                            ))
                        .toList(),
                    onExpansionChanged: (bool expanded) {
                      setState(() => customIcon = expanded);
                    },
                  )
                : SizedBox(),
            SizedBox(
              height: 15,
            ),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label: files.isEmpty ? "Upload" : "Submit",
              onPressed: () async {
                if (files.isEmpty) {
                  var result =
                      await FilePicker.platform.pickFiles(allowMultiple: true);
                  if (result == null) return;
                  setState(() {
                    files = result.files.map((file) => file).toList();
                  });
                } else {
                  return;
                }
                //OpenFile.open(file.path);
              },
            ),
          ],
        ),
      ),
    );
  }
}

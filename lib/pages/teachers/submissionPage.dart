// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_cast

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yapple/firebase/SubmissionService.dart';
import 'package:http/http.dart' as http;
import 'package:yapple/models/materialModel.dart';
import 'package:yapple/models/submissionModel.dart';
import 'package:yapple/widgets/AssignmentComment.dart';
import 'package:yapple/widgets/AssignmentGrading.dart';
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/SubmissionStatusBox.dart';

class SubmissionPage extends StatefulWidget {
  SubmissionPage(
      {super.key,
      required this.submission,
      required this.classID,
      required this.moduleID,
      required this.assignmentID});
  final submissionModel submission;
  final String classID;
  final String moduleID;
  final String assignmentID;

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  TextEditingController markController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  int selectedValue = 0;

  bool customIcon = false;
  int grade = 0;
  bool isGraded = false;
  String comment = '';
  @override
  void initState() {
    super.initState();
    getSubmissionGrade();
    getSubmissionGradingStatus();
    getSubmissionComment();
  }

  void getSubmissionGrade() async {
    int g = await SubmissionService().getSubmissionGrade(widget.submission.id,
        widget.classID, widget.moduleID, widget.assignmentID);
    setState(() {
      grade = g;
      print('grade ' + grade.toString());
    });
  }

  void getSubmissionGradingStatus() async {
    bool g = await SubmissionService().getSubmissionGradeStatus(
        widget.submission.id,
        widget.classID,
        widget.moduleID,
        widget.assignmentID);
    setState(() {
      isGraded = g;
      print('is graded ' + isGraded.toString());
    });
  }

  void getSubmissionComment() async {
    String g = await SubmissionService().getSubmissionComment(
        widget.submission.id,
        widget.classID,
        widget.moduleID,
        widget.assignmentID);
    setState(() {
      comment = g;
      print('is graded ' + isGraded.toString());
    });
  }

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
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          widget.submission.studentName,
          style: TextStyle(fontSize: 17),
        ),
      ),
      floatingActionButton: SpeedDial(
        foregroundColor: Colors.white,
        spacing: 20,
        spaceBetweenChildren: 10,
        animatedIcon: AnimatedIcons.menu_close,
        children: [
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.check_outlined),
            label: "Grade Assignment",
            onTap: () {
              if (widget.submission.isGraded) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Assignment already graded',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.green.shade400,
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AssigmentGrading(
                      controller: markController,
                      onPressed: () async {
                        bool r = await SubmissionService().gradeSubmission(
                          widget.submission.id,
                          widget.classID,
                          widget.moduleID,
                          widget.assignmentID,
                          int.parse(markController.text.toString()),
                        );
                        if (r) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Assignment graded successfully',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.green.shade400,
                            ),
                          );
                          Navigator.pop(context);
                          setState(() {
                            getSubmissionGrade();
                            getSubmissionGradingStatus();
                            getSubmissionComment();
                          });
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Failed to grade assignment',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16),
                              ),
                              duration: Duration(seconds: 2),
                              backgroundColor: Colors.red.shade400,
                            ),
                          );
                        }
                      },
                    );
                  },
                );
              }
            },
          ),
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.comment),
            label: "Comment on Assignment",
            onTap: () {
              if ((widget.submission.comment).isNotEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Comment already added',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red.shade400,
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AssigmentComment(
                      controller: commentController,
                      isEdit: false,
                    );
                  },
                );
              }
            },
          ),
          SpeedDialChild(
            shape: CircleBorder(),
            child: Icon(Icons.edit),
            label: "Edit comment",
            onTap: () {
              if ((widget.submission.comment).isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'There is no comment to edit',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16),
                    ),
                    duration: Duration(seconds: 2),
                    backgroundColor: Colors.red.shade400,
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AssigmentComment(
                      controller: commentController,
                      isEdit: true,
                    );
                  },
                );
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  'Submitted date',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
                subtitle: Text(
                  DateFormat('EEE d MMMM yyyy, hh:mm a')
                      .format(widget.submission.submissionDate),
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
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
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: SubmissionStatusBox(
                        name: isGraded ? 'Graded' : 'Pending',
                        color: isGraded
                            ? Colors.green.shade400
                            : Colors.red.shade400,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              isGraded
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Grade: ',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).colorScheme.tertiary),
                        ),
                        SizedBox(width: 5),
                        Text(
                          (grade).toString() + "/100",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                  : SizedBox(),
              SizedBox(
                height: 15,
              ),
              ExpansionTile(
                initiallyExpanded: false,
                title: Text(
                  "Comment",
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
                children: [
                  Text(
                    (comment).isEmpty ? "No comment added" : (comment),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.tertiary,
                      fontSize: 16,
                    ),
                  ),
                ],
                onExpansionChanged: (bool expanded) {
                  setState(() => customIcon = expanded);
                },
              ),
              SizedBox(
                height: 15,
              ),
              FutureBuilder<List<materialModel>>(
                future: SubmissionService().getSubmissionFiles(
                    widget.submission.studentID,
                    widget.classID,
                    widget.moduleID,
                    widget.assignmentID,
                    widget.submission.id),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<materialModel> materials =
                        snapshot.data as List<materialModel>;
                    return ExpansionTile(
                      initiallyExpanded: true,
                      title: Text(
                        "Submission Files",
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
              )

              /* ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                "Submission files",
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
              children: List.generate(
                  (widget.submission['files'] as List).length, (index) {
                final name =
                    (widget.submission['files'] as List)[index].toString();
                return ContentMaterialItem(
                  name: name,
                  icon: Icons.download_rounded,
                  onPressed: () {},
                );
              }),
              onExpansionChanged: (bool expanded) {
                setState(() => customIcon = expanded);
              },
            )
          */
            ],
          ),
        ),
      ),
    );
  }
}

class Body extends StatefulWidget {
  Body(
      {super.key,
      required this.submission,
      required this.classID,
      required this.moduleID,
      required this.assignmentID});
  final submissionModel submission;
  final String classID;
  final String moduleID;
  final String assignmentID;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool customIcon = false;
  int grade = 0;
  bool isGraded = false;
  String comment = '';
  @override
  void initState() {
    super.initState();
    getSubmissionGrade();
    getSubmissionGradingStatus();
    getSubmissionComment();
  }

  void getSubmissionGrade() async {
    int g = await SubmissionService().getSubmissionGrade(widget.submission.id,
        widget.classID, widget.moduleID, widget.assignmentID);
    setState(() {
      grade = g;
      print('grade ' + grade.toString());
    });
  }

  void getSubmissionGradingStatus() async {
    bool g = await SubmissionService().getSubmissionGradeStatus(
        widget.submission.id,
        widget.classID,
        widget.moduleID,
        widget.assignmentID);
    setState(() {
      isGraded = g;
      print('is graded ' + isGraded.toString());
    });
  }

  void getSubmissionComment() async {
    String g = await SubmissionService().getSubmissionComment(
        widget.submission.id,
        widget.classID,
        widget.moduleID,
        widget.assignmentID);
    setState(() {
      comment = g;
      print('is graded ' + isGraded.toString());
    });
  }

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
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                'Submitted date',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
              subtitle: Text(
                DateFormat('EEE d MMMM yyyy, hh:mm a')
                    .format(widget.submission.submissionDate),
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
                  Padding(
                    padding: const EdgeInsets.only(top: 5),
                    child: SubmissionStatusBox(
                      name: isGraded ? 'Graded' : 'Pending',
                      color: isGraded
                          ? Colors.green.shade400
                          : Colors.red.shade400,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 15,
            ),
            widget.submission.isGraded
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Grade: ',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.tertiary),
                      ),
                      SizedBox(width: 5),
                      Text(
                        (grade).toString() + "/100",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.tertiary,
                          fontSize: 18,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  )
                : SizedBox(),
            SizedBox(
              height: 15,
            ),
            ExpansionTile(
              initiallyExpanded: false,
              title: Text(
                "Comment",
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
              children: [
                Text(
                  (comment).isEmpty ? "No comment added" : (comment),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16,
                  ),
                ),
              ],
              onExpansionChanged: (bool expanded) {
                setState(() => customIcon = expanded);
              },
            ),
            SizedBox(
              height: 15,
            ),
            FutureBuilder<List<materialModel>>(
              future: SubmissionService().getSubmissionFiles(
                  widget.submission.studentID,
                  widget.classID,
                  widget.moduleID,
                  widget.assignmentID,
                  widget.submission.id),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List<materialModel> materials =
                      snapshot.data as List<materialModel>;
                  return ExpansionTile(
                    initiallyExpanded: true,
                    title: Text(
                      "Submission Files",
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
            )

            /* ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                "Submission files",
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
              children: List.generate(
                  (widget.submission['files'] as List).length, (index) {
                final name =
                    (widget.submission['files'] as List)[index].toString();
                return ContentMaterialItem(
                  name: name,
                  icon: Icons.download_rounded,
                  onPressed: () {},
                );
              }),
              onExpansionChanged: (bool expanded) {
                setState(() => customIcon = expanded);
              },
            )
          */
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yapple/firebase/AssignmentService.dart';
import 'package:yapple/firebase/SubmissionService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/assignmentModel.dart';
import 'package:yapple/models/materialModel.dart';
import 'package:http/http.dart' as http;
import 'package:yapple/models/submissionModel.dart';
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
  List<File> files = [];

  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  String studentName = "";
  bool isSubmitted = false;
  String submissionID = "";
  int grade = 0;
  bool isGraded = false;

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    getStudentName();
    checkSubmission();
    getSubmissionID();
  }

  void getStudentName() async {
    String r = await UserService().getStudentName(uid, context);
    setState(() {
      studentName = r;
    });
  }

  void checkSubmission() async {
    bool submitted = await SubmissionService().checkSubmission(
        uid, widget.classID, widget.moduleID, widget.assignment.id);
    setState(() {
      isSubmitted = submitted;
    });
  }

  void getSubmissionID() async {
    String id = await SubmissionService().getSubmissionID(
        uid, widget.classID, widget.moduleID, widget.assignment.id);
    setState(() {
      submissionID = id;
      getSubmissionGrade();
      getSubmissionGradingStatus();
    });
  }

  void getSubmissionGrade() async {
    int g = await SubmissionService().getSubmissionGrade(
        submissionID, widget.classID, widget.moduleID, widget.assignment.id);
    setState(() {
      grade = g;
      print('grade ' + grade.toString());
    });
  }

  void getSubmissionGradingStatus() async {
    bool g = await SubmissionService().getSubmissionGradeStatus(
        submissionID, widget.classID, widget.moduleID, widget.assignment.id);
    setState(() {
      isGraded = g;
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

  void uploadFiles() async {
    await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'ppt',
        'pptx',
        'xls',
        'xlsx',
        'txt',
        'zip',
        'rar',
        '7z',
        'jpg',
        'jpeg',
        'png'
      ],
    ).then((value) async {
      if (value != null) {
        for (var file in value.files) {
          File mfile = File(file.path!);
          setState(() {
            files.add(mfile);
          });
        }
      }
    });
  }

  void submitAssignment() async {
    if (files.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Please upload a file"),
      ));
    } else {
      var submission = submissionModel(
        id: '',
        studentName: studentName,
        studentID: uid,
        isGraded: false,
        submissionDate: DateTime.now(),
        comment: '',
        grade: 0,
      );
      Map<String, dynamic> result = await SubmissionService().addSubmission(
          submission,
          context,
          widget.classID,
          widget.moduleID,
          widget.assignment.id);
      if (result['success']) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Assignment submitted"),
        ));
        for (var file in files) {
          String fileName = file.path!.split('/').last;
          String fileExtension = fileName.split('.').last;
          String uniqueName =
              '${DateTime.now().millisecondsSinceEpoch}.$fileExtension';

          var material = materialModel(
            id: uniqueName,
            name: fileName.split('.').first,
            url: "",
          );
          setState(() {});
          bool uploaded = await SubmissionService().uploadSubmissionFiles(
              file,
              widget.classID,
              widget.moduleID,
              material,
              widget.assignment.id,
              result['id'] as String);
          if (uploaded == true) {
            print("File uploaded");
            setState(() {
              checkSubmission();
              getSubmissionID();
              files.clear();
            });
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Failed to upload file"),
            ));
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Failed to submit assignment"),
        ));
      }
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
                    name: isSubmitted ? "Submitted" : "Not Submitted",
                    color: isSubmitted
                        ? Colors.green.shade400
                        : Colors.red.shade400,
                    //Colors.green.shade400
                  ),
                  SizedBox(width: 10),
                  SubmissionStatusBox(
                    name: isGraded ? "Graded" : "Not Graded",
                    color:
                        isGraded ? Colors.green.shade400 : Colors.red.shade400,
                  ),
                ],
              ),
            ),
            isSubmitted
                ? SizedBox(
                    height: 15,
                  )
                : SizedBox(),
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
                        grade.toString() + "/100",
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
                    children: List.generate(files.length, (index) {
                      return UploadedAssigmentItem(
                        name: files[index].path!.split('/').last,
                        onPressed: () {
                          setState(() {
                            files.removeAt(index);
                          });
                        },
                      );
                    }),
                    onExpansionChanged: (bool expanded) {
                      setState(() => customIcon = expanded);
                    },
                  )
                : SizedBox(),
            SizedBox(
              height: 15,
            ),
            isSubmitted
                ? FutureBuilder<List<materialModel>>(
                    future: SubmissionService().getSubmissionFiles(
                        uid,
                        widget.classID,
                        widget.moduleID,
                        widget.assignment.id,
                        submissionID),
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
                : SizedBox(),
            isSubmitted
                ? SizedBox(
                    height: 15,
                  )
                : SizedBox(),
            isSubmitted
                ? SizedBox()
                : MyButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).appBarTheme.backgroundColor!,
                    label: files.isEmpty ? "Upload" : "Submit",
                    onPressed: () async {
                      if (files.isEmpty) {
                        uploadFiles();
                        setState(() {});
                      } else {
                        submitAssignment();
                        setState(() {
                          checkSubmission();
                          getSubmissionID();
                          files.clear();
                        });
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

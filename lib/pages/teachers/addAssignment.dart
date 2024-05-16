// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/firebase/AssignmentService.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/models/assignmentModel.dart';
import 'package:yapple/models/materialModel.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AddAssignmentPage extends StatelessWidget {
  final moduleModel module;
  AddAssignmentPage({super.key, required this.module});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Create Assignment",
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: SingleChildScrollView(
          child: Body(
        module: module,
      )),
    );
  }
}

class Body extends StatefulWidget {
  final moduleModel module;
  Body({super.key, required this.module});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController titleController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  bool customIcon = false;

  DateTime date = DateTime.now();
  TimeOfDay time = TimeOfDay.now();

  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        dateController.text = _picked.toString().split(" ")[0];
        date = _picked;
      });
    }
  }

  List<File> files = [];

  void addAssignment() async {
    if (titleController.text.isEmpty ||
        aboutController.text.isEmpty ||
        timeController.text.isEmpty ||
        dateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all the fields',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      String title = titleController.text;
      String about = aboutController.text;
      DateTime dueDate = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
      var assignment = assignmentModel(
        id: '',
        title: title,
        description: about,
        dueDate: dueDate,
      );
      Map<String, dynamic> result = await AssignmentService().addAssignment(
          assignment, context, widget.module.classID, widget.module.id);
      if (result['success'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Assignment added successfully'),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
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
          bool uploaded = await ModuleService().uploadAssignmentMaterial(
              file,
              widget.module.classID,
              widget.module.id,
              material,
              result['id'] as String);
          if (!uploaded) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("Failed to upload file"),
            ));
          }
          Navigator.pop(context);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add assignment'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          MyTextField(
            myController: titleController,
            isPass: false,
            hintText: 'Enter assigment title',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 15),
          MyTextField(
            myController: aboutController,
            isPass: false,
            hintText: 'Enter assigment about',
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: 15),
          MyTextField(
            myController: timeController,
            isPass: false,
            hintText: "Select Submission Deadline Time",
            keyboardType: TextInputType.datetime,
            readOnly: true,
            suffixIcon: IconButton(
              onPressed: () {
                var startTime = showTimePicker(
                  initialEntryMode: TimePickerEntryMode.input,
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                startTime.then((selectedTime) {
                  if (selectedTime != null) {
                    String format = DateFormat.Hm().format(DateTime(
                      DateTime.now().year,
                      DateTime.now().month,
                      DateTime.now().day,
                      selectedTime.hour,
                      selectedTime.minute,
                    ));
                    setState(() {
                      timeController.text = format;
                      time = selectedTime;
                    });
                  }
                });
              },
              icon: Icon(
                Icons.access_time_rounded,
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(height: 15),
          MyTextField(
            myController: dateController,
            isPass: false,
            hintText: "Select Submission Deadline Date",
            keyboardType: TextInputType.datetime,
            readOnly: true,
            suffixIcon: IconButton(
              onPressed: selectDate,
              icon: Icon(
                Icons.calendar_today_rounded,
                color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
              ),
            ),
          ),
          SizedBox(height: 15),
          files.isNotEmpty
              ? ExpansionTile(
                  initiallyExpanded: true,
                  title: Text(
                    "Uploaded Files",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
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
                    return ContentMaterialItem(
                      name: files[index].path!.split('/').last,
                      icon: Icons.delete,
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
          SizedBox(height: 25),
          MyButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).appBarTheme.backgroundColor!,
            label: files.isNotEmpty ? 'Add assignment' : 'Upload',
            onPressed: () {
              if (files.isNotEmpty) {
                addAssignment();
              } else {
                uploadFiles();
              }
            },
          ),
        ],
      ),
    );
  }
}

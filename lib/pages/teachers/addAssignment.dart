// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';
import 'package:yapple/widgets/UploadedAssigmentItem.dart';

class AddAssignmentPage extends StatelessWidget {
  const AddAssignmentPage({super.key});

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
      body: SingleChildScrollView(child: Body()),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController titleController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController timeController = TextEditingController();
  TextEditingController dateController = TextEditingController();

  Future<void> selectDate() async {
    DateTime? _picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100));
    if (_picked != null) {
      setState(() {
        dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  static const files = [];
  bool customIcon = false;

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
                      name: files[index],
                      icon: Icons.delete,
                      onPressed: () {},
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
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Assignment added successfully'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Assignment uploaded successfully'),
                    backgroundColor: Theme.of(context).colorScheme.primary,
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}

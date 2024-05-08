// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/widgets/AssigmentItem.dart';
import 'package:yapple/widgets/AssignmentComment.dart';
import 'package:yapple/widgets/AssignmentGrading.dart';
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/SubmissionStatusBox.dart';

class SubmissionPage extends StatefulWidget {
  SubmissionPage({super.key, required this.submission});
  final Map<String, dynamic> submission;

  @override
  State<SubmissionPage> createState() => _SubmissionPageState();
}

class _SubmissionPageState extends State<SubmissionPage> {
  TextEditingController markController = TextEditingController();
  TextEditingController commentController = TextEditingController();
  int selectedValue = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          widget.submission['name'] as String,
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Body(
        submission: widget.submission,
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
              if (widget.submission['graded'] as bool) {
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
              if ((widget.submission['comment'] as String).isNotEmpty) {
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
              if ((widget.submission['comment'] as String).isEmpty) {
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
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key, required this.submission});
  final Map<String, dynamic> submission;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool customIcon = false;
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
                (widget.submission['date'] as String) +
                    ", " +
                    (widget.submission['time'] as String),
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
                      name: widget.submission['graded'] as bool
                          ? 'Graded'
                          : 'Pending',
                      color: widget.submission['graded'] as bool
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
            widget.submission['graded'] as bool
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
                        (widget.submission['grade'] as int).toString() + "/100",
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
                  (widget.submission['comment'] as String).isEmpty
                      ? "No comment added"
                      : (widget.submission['comment'] as String),
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
            ExpansionTile(
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
          ],
        ),
      ),
    );
  }
}

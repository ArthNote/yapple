// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/widgets/ContentMaterialItem.dart';
import 'package:yapple/widgets/MyButton.dart';

class AssignmentPage extends StatelessWidget {
  AssignmentPage({super.key, required this.name});
  final String name;

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
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.0),
          child: Divider(
            height: 1,
            thickness: 1,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      body: Body(),
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
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
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
                    name: "Submitted",
                    color: Colors.green.shade400,
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
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              children: students
                  .map((student) => ContentMaterialItem(
                        name: "Introduction to Flutter",
                      ))
                  .toList(),
              onExpansionChanged: (bool expanded) {
                setState(() => customIcon = expanded);
              },
            ),
            SizedBox(
              height: 15,
            ),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label: "Submit",
              onPressed: () {},
            )
          ],
        ),
      ),
    );
  }
}

class SubmissionStatusBox extends StatelessWidget {
  SubmissionStatusBox({super.key, required this.name, required this.color});
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        name,
        style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w500),
      ),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    );
  }
}

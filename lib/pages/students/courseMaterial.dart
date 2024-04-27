// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class CourseMaterialPage extends StatelessWidget {
  CourseMaterialPage({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
    return Padding(
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
                style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
              ),
            ],
            onExpansionChanged: (bool expanded) {
              setState(() => customIcon = expanded);
            },
          ),
          SizedBox(
            height: 25,
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
            subtitle: Text('Sun 21 april 2024, 04:00 PM'),
          ),
          SizedBox(
            height: 15,
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
            subtitle: Text('Sun 21 april 2024, 04:00 PM'),
          ),
        ],
      ),
    );
  }
}

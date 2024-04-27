// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/widgets/SearchField.dart';
import 'package:yapple/widgets/StudentItem.dart';

class CourseDetailsPage extends StatelessWidget {
  CourseDetailsPage({super.key, required this.moduleName});
  final String moduleName;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(
              moduleName,
              style: TextStyle(fontSize: 17),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                  text: "Details",
                ),
                Tab(
                  text: "Resources",
                ),
                Tab(
                  text: "Circle",
                ),
              ],
            )),
        body: TabBarView(
          children: [
            BodyDetails(
              moduleName: moduleName,
            ),
            Text("Resources"),
            BodyCircle(),
          ],
        ),
      ),
    );
  }
}

class BodyDetails extends StatelessWidget {
  BodyDetails({super.key, required this.moduleName});
  final String moduleName;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Icon(
              Icons.code,
              size: 80,
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 30),
          Text(
            moduleName,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            color: Theme.of(context).colorScheme.tertiary,
            height: 1,
          ),
          SizedBox(
            height: 15,
          ),
          ListTile(
            tileColor: Theme.of(context).colorScheme.secondary,
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            leading: Container(
              width: 55,
              height: 55,
              decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(5)),
              child: Icon(
                Icons.person,
                color: Colors.white,
              ),
            ),
            title: Text(
              "Yassine Laarbaoui",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text("Teacher"),
            trailing: Icon(
              Icons.arrow_forward_rounded,
              color: Theme.of(context).colorScheme.tertiary,
              size: 30,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "About the module:",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Phasellus nec semper quam. Integer suscipit efficitur est, ac consectetur diam blandit ut. In hac habitasse platea dictumst. Aliquam erat volutpat. Vestibulum vitae consectetur justo. Suspendisse potenti. Quisque ultricies rutrum bibendum.",
            textAlign: TextAlign.justify,
          )
        ],
      ),
    );
  }
}

class BodyCircle extends StatelessWidget {
  BodyCircle({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          SearchField(
            myController: searchController,
            hintText: "Search",
            icon: Icons.search,
            bgColor: Colors.white,
          ),
          SizedBox(
            height: 15,
          ),
          Expanded(
            child: ListView(
              children: students.map((student) => StudentItem()).toList(),
            ),
          )
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable, must_be_immutable

import 'package:flutter/material.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/pages/students/courseDetails.dart';
import 'package:yapple/widgets/ModuleCardMD.dart';
import 'package:yapple/widgets/SearchField.dart';

class CoursesPage extends StatefulWidget {
  const CoursesPage({super.key});

  @override
  State<CoursesPage> createState() => _CoursesPageState();
}

class _CoursesPageState extends State<CoursesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: SafeArea(child: Body()),
    );
  }
}

class Body extends StatelessWidget {
  Body({super.key});
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    //get size of screen

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchField(
            myController: searchController,
            hintText: "Search",
            icon: Icons.search,
            bgColor: Theme.of(context).appBarTheme.backgroundColor!,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        //courses list
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            childAspectRatio: 0.78,
            mainAxisSpacing: 20,
            crossAxisSpacing: 20,
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            children: modules
                .map((module) => GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CourseDetailsPage(
                                      moduleName:
                                          module['moduleName'].toString(),
                                    )));
                      },
                      child: ModuleCardMD(
                        isStarred: module['isStarred'] as bool,
                        moduleName: module['moduleName'].toString(),
                        moduleCategory: module['moduleCategory'].toString(),
                        color: module['color'] as Color,
                      ),
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }
}

// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/pages/navigation/hiba.dart';
import 'package:yapple/pages/students/tasks.dart';
import 'package:yapple/pages/teachers/courseDetails.dart';
import 'package:yapple/widgets/ModuleCardSM.dart';

class TeacherHomePage extends StatelessWidget {
  const TeacherHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  Body({super.key});

  List items = [
    {
      'title': 'Calendar',
      'icon': Icons.calendar_month_rounded,
      'color': Color(0xffffcf2f),
    },
    {
      'title': 'Tasks',
      'icon': Icons.task_rounded,
      'color': Color(0xff6fe08d),
      'page': TasksPage(),
    },
    {
      'title': 'Feedback',
      'icon': Icons.feedback_rounded,
      'color': Color(0xff61bdfd)
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //news block
        Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              )),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        height: 50,
                        child: Image.asset(
                          'assets/yapple.png',
                          color: Theme.of(context).appBarTheme.backgroundColor,
                        ),
                      ),
                      Icon(
                        Icons.notifications,
                        size: 30,
                        color: Theme.of(context).appBarTheme.backgroundColor,
                      )
                    ]),
                SizedBox(
                  height: 20,
                ),
                Text(
                  'Hi, Teacher!',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                    wordSpacing: 2,
                    color: Theme.of(context).appBarTheme.backgroundColor,
                  ),
                )
              ],
            ),
          ),
        ),

        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: items
                .map((item) => Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            if (item['page'] != null) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          item['page'] as Widget));
                            }
                          },
                          child: Container(
                            height: 60,
                            width: 60,
                            decoration: BoxDecoration(
                              color: item['color'] as Color,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                                child: Icon(
                              item['icon'] as IconData,
                              color:
                                  Theme.of(context).appBarTheme.backgroundColor,
                              size: 30,
                            )),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(item['title'] as String,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Theme.of(context).colorScheme.tertiary,
                            ))
                      ],
                    ))
                .toList(),
          ),
        ),
        SizedBox(
          height: 25,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Starred Modules",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Text(
                "See All",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SizedBox(
            height: 160,
            child: ListView(
              padding: EdgeInsets.all(10),
              scrollDirection: Axis.horizontal,
              children: modules
                  .map((module) => GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      TeacherCourseDetailsPage(
                                        moduleName:
                                            module['moduleName'].toString(),
                                      )));
                        },
                        child: ModuleCardSM(
                          moduleName: module['moduleName'].toString(),
                          moduleCode: module['moduleCode'].toString(),
                          moduleCategory: module['moduleCategory'].toString(),
                          isStarred: module['isStarred'] as bool,
                          onPressed: () {},
                          color: module['color'] as Color,
                        ),
                      ))
                  .toList(),
            ),
          ),
        ),
      ],
    ));
  }
}

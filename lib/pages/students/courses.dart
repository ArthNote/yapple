// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:flutter/material.dart';
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
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
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
            bgColor: Colors.white,
          ),
        ),
        SizedBox(
          height: 30,
        ),
        //courses list
        // Expanded(
        //   child: GridView.count(
        //     crossAxisCount: 2,
        //     children: modules
        //         .map((module) => ModuleCardSM(
        //               moduleName: module['moduleName'].toString(),
        //               moduleCode: module['moduleCode'].toString(),
        //               moduleCategory: module['moduleCategory'].toString(),
        //               isStarred: module['isStarred'] as bool,
        //             ))
        //         .toList(),
        //   ),
        // )

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ModuleCardMD(isStarred: false),
            ModuleCardMD(isStarred: false),
          ],
        ),
      ],
    );
  }
}

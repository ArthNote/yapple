// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:yapple/pages/students/chats.dart';
import 'package:yapple/pages/students/courses.dart';
import 'package:yapple/pages/students/home.dart';
import 'package:yapple/pages/students/profile.dart';

class StudentNavbar extends StatefulWidget {
  const StudentNavbar({super.key});

  @override
  State<StudentNavbar> createState() => _StudentNavbarState();
}

class _StudentNavbarState extends State<StudentNavbar> {
  int index = 0;
  List<Widget> pages = [
    HomePage(),
    CoursesPage(),
    ChatsPage(),
    StudentProfile(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages.elementAt(index),
      ),
      bottomNavigationBar: Container(
        height: 95,
        alignment: Alignment.topCenter,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
        ),
        child: GNav(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor!,
          activeColor: Colors.white,
          tabBackgroundColor: Theme.of(context).colorScheme.primary,
          gap: 8,
          onTabChange: (pageIndex) {
            setState(() {
              index = pageIndex;
            });
          },
          padding: EdgeInsets.all(12),
          tabs: [
            GButton(
              iconActiveColor: Colors.white,
              icon: index == 0 ? Icons.home : Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              iconActiveColor: Colors.white,
              icon: index == 1 ? Icons.school : Icons.school_outlined,
              text: 'Courses',
            ),
            GButton(
              iconActiveColor: Colors.white,
              icon: index == 2 ? Icons.chat : Icons.chat_outlined,
              text: "Chats",
            ),
            GButton(
              iconActiveColor: Colors.white,
              icon: index == 3 ? Icons.person : Icons.person_outline,
              text: 'Profile',
            )
          ],
        ),
      ),
    );
  }
}

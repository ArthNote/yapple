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
  late PageController pageController = new PageController(initialPage: index);
  late List<Widget> pages;

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: index);

    pages = [
      HomePage(),
      CoursesPage(),
      ChatsPage(),
      StudentProfile(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: pageController,
        children: pages,
        onPageChanged: (pageIndex) {
          setState(() {
            index = pageIndex;
          });
        },
      ),
      bottomNavigationBar: Container(
        height: 80,
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).appBarTheme.backgroundColor,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: GNav(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor!,
          activeColor: Theme.of(context).colorScheme.background,
          tabBackgroundColor: Theme.of(context).colorScheme.primary,
          gap: 8,
          onTabChange: (pageIndex) {
            pageController.jumpToPage(pageIndex);
          },
          padding: EdgeInsets.all(12),
          tabs: [
            GButton(
              icon: index == 0 ? Icons.home : Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              icon: index == 1 ? Icons.school : Icons.school_outlined,
              text: 'Courses',
            ),
            GButton(
              icon: index == 2 ? Icons.chat : Icons.chat_outlined,
              text: "Chats",
            ),
            GButton(
              icon: index == 3 ? Icons.person : Icons.person_outline,
              text: 'Profile',
            )
          ],
        ),
      ),
    );
  }
}
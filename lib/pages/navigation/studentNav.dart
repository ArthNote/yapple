// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:yapple/pages/students/chats.dart';
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
      ChatsPage(),
      StudentProfile(),
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
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).appBarTheme.backgroundColor,
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
              icon: Icons.home_outlined,
              text: 'Home',
            ),
            GButton(
              icon: Icons.school_outlined,
              text: 'Courses',
            ),
            GButton(
              icon: Icons.chat_outlined,
              text: "Chats",
            ),
            GButton(
              icon: Icons.person_outline,
              text: 'Profile',
            )
          ],
        ),
      ),
    );
  }
}

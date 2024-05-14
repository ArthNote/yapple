// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:yapple/pages/admin/classes.dart';
import 'package:yapple/pages/admin/dashboard.dart';
import 'package:yapple/pages/admin/events.dart';
import 'package:yapple/pages/admin/users.dart';

class AdminNavbar extends StatefulWidget {
  const AdminNavbar({super.key});

  @override
  State<AdminNavbar> createState() => _AdminNavbarState();
}

class _AdminNavbarState extends State<AdminNavbar> {
  int index = 0;
  List<Widget> pages = [
    AdminDashboardPage(),
    AdminClassesPage(),
    AdminUsersPage(),
    AdminEventsPage(),
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
              icon: index == 0 ? Icons.dashboard : Icons.dashboard_outlined,
              text: 'Dashboard',
            ),
            GButton(
              iconActiveColor: Colors.white,
              icon: index == 1 ? Icons.school : Icons.school_outlined,
              text: 'Classes',
            ),
            GButton(
              iconActiveColor: Colors.white,
              icon: index == 2 ? Icons.group : Icons.group_outlined,
              text: "Users",
            ),
            GButton(
              iconActiveColor: Colors.white,
              icon: index == 3 ? Icons.event : Icons.event_outlined,
              text: 'Events',
            )
          ],
        ),
      ),
    );
  }
}

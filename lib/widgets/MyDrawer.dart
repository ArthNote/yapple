// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:yapple/pages/global/login.dart';
import 'package:yapple/pages/students/chats.dart';
import 'package:yapple/pages/students/courses.dart';
import 'package:yapple/pages/students/home.dart';
import 'package:yapple/pages/students/profile.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: ListView(
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                "Adolf Hitler",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                "hitler@gmail.com",
                style: TextStyle(
                  fontSize: 14,
                ),
              ),
              leading: CircleAvatar(
                radius: 28,
                child: Text("AH"),
                backgroundColor: Colors.blue,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              runSpacing: 20,
              children: [
                DrawerItem(
                    title: "Home", icon: Icons.home_rounded, page: HomePage()),
                DrawerItem(
                    title: "Courses",
                    icon: Icons.school_rounded,
                    page: CoursesPage()),
                DrawerItem(
                    title: "Chats",
                    icon: Icons.chat_rounded,
                    page: ChatsPage()),
                DrawerItem(
                    title: "Profile",
                    icon: Icons.person_rounded,
                    page: StudentProfile()),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Divider(
              thickness: 1,
              color: Theme.of(context).colorScheme.primary,
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              runSpacing: 20,
              children: [
                DrawerItem(
                    title: "Settings",
                    icon: Icons.settings_rounded,
                    page: HomePage()),
                DrawerItem(
                    title: "Log out",
                    icon: Icons.logout_rounded,
                    page: LoginPage()),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerItem extends StatelessWidget {
  DrawerItem(
      {super.key, required this.title, required this.icon, required this.page});
  final String title;
  final IconData icon;
  final Widget page;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
        Navigator.push(context, MaterialPageRoute(builder: (context) => page));
      },
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: Theme.of(context).colorScheme.tertiary,
            ),
            SizedBox(
              width: 40,
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                color: Theme.of(context).colorScheme.tertiary,
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:yapple/widgets/MenuItem.dart';
import 'package:yapple/widgets/MyButton.dart';

import '../../widgets/MyDrawer.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        drawer: MyDrawer(),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //profile image
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 0),
              child: SizedBox(
                height: 170,
                width: 170,
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                    child: CircleAvatar(
                      radius: 100,
                      child: Icon(Icons.person),
                      backgroundColor: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),

            //full name + email
            Center(
                child: Padding(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 10),
              child: Column(children: [
                Text(
                  // make the first letter of the word capital
                  "Adolf Hitler",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 22,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "hitler@gmail.com",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 16,
                  ),
                )
              ]),
            )),
          ],
        ),

        //column of btns
        Container(
          padding: EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
              //give it a box shadow
              boxShadow: [
                BoxShadow(
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                )
              ],
              color: Theme.of(context).appBarTheme.backgroundColor,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40), topRight: Radius.circular(40))),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(17, 24, 13, 0),
            child: Column(children: [
              MenuItem(
                  title: "Edit Details",
                  onTap: () => {},
                  icon: Icons.person_outline),
              SizedBox(height: 10),
              MenuItem(
                  title: "Settings",
                  onTap: () {},
                  icon: Icons.settings_outlined),
              SizedBox(height: 10),
              MenuItem(
                  title: "Change Password",
                  onTap: () => {},
                  icon: Icons.lock_outline),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.fromLTRB(17, 24, 13, 0),
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    side: BorderSide(
                      width: 1.0,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  child: Text("Log out"),
                ),
              )
              //edit personal details
            ]),
          ),
        )
      ],
    );
  }
}

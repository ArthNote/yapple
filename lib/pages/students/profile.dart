// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:yapple/widgets/MenuItem.dart';
import 'package:yapple/widgets/MyButton.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Profile',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
          ),
          centerTitle: false,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
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
      children: [
        //profile image
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
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            SizedBox(height: 5),
            Text(
              "hitler@gmail.com",
              style: TextStyle(color: Colors.black, fontSize: 16),
            )
          ]),
        )),

        //column of btns
        Expanded(
          child: Container(
            decoration: BoxDecoration(
                //give it a box shadow
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 7,
                  )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))),
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
                // MyButton(
                //   backgroundColor: backgroundColor,
                //   textColor: textColor,
                //   label: label,
                //   onPressed: onPressed,
                // )
                //edit personal details
              ]),
            ),
          ),
        )
      ],
    );
  }
}

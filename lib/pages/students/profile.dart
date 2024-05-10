// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yapple/firebase/AuthService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/models/userModel.dart';
import 'package:yapple/pages/global/login.dart';
import 'package:yapple/widgets/MenuItem.dart';

class StudentProfile extends StatelessWidget {
  const StudentProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.background,
          elevation: 0,
          automaticallyImplyLeading: false,
        ),
        body: Body(),
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  final currentUser = FirebaseAuth.instance.currentUser;
  UserService userService = UserService();
  String uid = "";

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        //profile image
        FutureBuilder(
            future: userService.getStudentData(uid, context),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                studentModel user = snapshot.data as studentModel;
                return Column(
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
                          user.name,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 22,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          user.email,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.tertiary,
                            fontSize: 16,
                          ),
                        )
                      ]),
                    )),
                  ],
                );
              } else if (snapshot.hasError) {
                return Center(child: Text("Error${snapshot.error}"));
              }
              return Center(child: CircularProgressIndicator());
            }),

        //column of btns
        Container(
          padding: EdgeInsets.only(bottom: 30),
          decoration: BoxDecoration(
              //give it a box shadow
              boxShadow: [
                BoxShadow(color: Colors.black12, blurRadius: 5),
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
                  onPressed: () {
                    AuthService().logout(context);
                  },
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

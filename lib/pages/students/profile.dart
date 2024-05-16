// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:yapple/firebase/AuthService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/pages/global/editProfilePage.dart';
import 'package:pdf/pdf.dart';
import 'package:flutter_file_saver/flutter_file_saver.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:yapple/pages/global/resetPassword.dart';
import 'package:yapple/utils/pdf_api.dart';
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
    return FutureBuilder(
        future: userService.getStudentData(uid, context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            studentModel user = snapshot.data as studentModel;
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                            child: user.profilePicUrl == 'null'
                                ? CircleAvatar(
                                    radius: 100,
                                    child: Icon(Icons.person),
                                    backgroundColor: Colors.blue,
                                  )
                                : CircleAvatar(
                                    radius: 100,
                                    backgroundImage:
                                        NetworkImage(user.profilePicUrl),
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
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 30),
                  decoration: BoxDecoration(
                      //give it a box shadow
                      boxShadow: [
                        BoxShadow(color: Colors.black12, blurRadius: 5),
                      ],
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(40),
                          topRight: Radius.circular(40))),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(17, 24, 13, 0),
                    child: Column(children: [
                      MenuItem(
                          title: "Edit Details",
                          onTap: () => {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return EditProfilePage(
                                    uid: uid,
                                    name: user.name,
                                    profilePicUrl: user.profilePicUrl,
                                    role: 'students',
                                  );
                                }))
                              },
                          icon: Icons.person_outline),
                      SizedBox(height: 10),
                      MenuItem(
                          title: "Change Password",
                          onTap: () => {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ResetPasswordPage(
                                    title: 'Change Password',
                                  );
                                }))
                              },
                          icon: Icons.lock_outline),
                      SizedBox(height: 10),
                      MenuItem(
                          title: "Coming soon",
                          onTap: () {},
                          icon: Icons.watch_later_outlined),
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
                ),
              ],
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        });
  }
}

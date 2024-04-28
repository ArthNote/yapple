// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:yapple/widgets/MyButton.dart';

class ProfileDialog extends StatelessWidget {
  ProfileDialog(
      {super.key, required this.name, required this.email, required this.role});
  final String name;
  final String email;
  final String role;
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: SizedBox(
                height: 130,
                width: 130,
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
            Center(
                child: Column(children: [
              Text(
                // make the first letter of the word capital
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 22,
                ),
              ),
              SizedBox(height: 5),
              Text(
                email,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 5),
              Text(
                role,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.tertiary,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              MyButton(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  textColor: Theme.of(context).appBarTheme.backgroundColor!,
                  label: "Message",
                  onPressed: () {})
            ])),
          ],
        ),
      ),
    );
  }
}

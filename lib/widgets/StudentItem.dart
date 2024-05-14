// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class StudentItem extends StatelessWidget {
  StudentItem({super.key, required this.name, required this.email, required this.profilePicUrl});
  final String name;
  final String email;
  final String profilePicUrl;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading:profilePicUrl=='null' ? CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
      ) : CircleAvatar(
        radius: 30,
        backgroundImage: NetworkImage(profilePicUrl),
      ),
      title: Text(
        name,
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.tertiary),
      ),
      subtitle: Text(
        email,
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
      ),
      trailing: Icon(
        Icons.arrow_forward_ios_rounded,
        color: Theme.of(context).colorScheme.tertiary,
        size: 20,
      ),
    );
  }
}

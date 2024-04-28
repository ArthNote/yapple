// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class StudentItem extends StatelessWidget {
  StudentItem({super.key, required this.name, required this.email});
  final String name;
  final String email;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.person,
          color: Colors.white,
        ),
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

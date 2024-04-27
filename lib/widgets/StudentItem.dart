// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class StudentItem extends StatelessWidget {
  const StudentItem({super.key});

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
        "Karim affa",
        style: TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w500,
            color: Theme.of(context).colorScheme.tertiary),
      ),
      subtitle: Text(
        'karimaffa@gmail.com',
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

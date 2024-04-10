// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MenuItem extends StatelessWidget {
  const MenuItem({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(10)),
        child: Icon(
          icon,
          color: Colors.white,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
            fontSize: 14,
            color: Theme.of(context).colorScheme.tertiary,
            fontWeight: FontWeight.w500),
      ),
      trailing: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            //color: Colors.grey
            ),
        child: Icon(
          Icons.arrow_forward_ios,
          color: Theme.of(context).colorScheme.tertiary,
          size: 14,
        ),
      ),
    );
  }
}

// ignore_for_file: unnecessary_null_in_if_null_operators

import 'package:flutter/material.dart';

class QuizzItem extends StatelessWidget {
  QuizzItem({super.key, required this.name, this.iconButton});
  final String name;
  final IconButton? iconButton;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.quiz_rounded,
        size: 28,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        name,
        style: TextStyle(
            fontSize: 17, color: Theme.of(context).colorScheme.tertiary),
      ),
      trailing: iconButton ?? null,
    );
  }
}

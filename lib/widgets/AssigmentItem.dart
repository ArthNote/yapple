import 'package:flutter/material.dart';

class AssigmentItem extends StatelessWidget {
  AssigmentItem({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.assignment_rounded,
        size: 28,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        name,
        style: TextStyle(
            fontSize: 17, color: Theme.of(context).colorScheme.tertiary),
      ),
    );
  }
}

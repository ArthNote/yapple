import 'package:flutter/material.dart';
import 'package:yapple/widgets/SubmissionStatusBox.dart';

class SubmissionItem extends StatelessWidget {
  SubmissionItem({super.key, required this.name, required this.isGraded});
  final String name;
  final bool isGraded;

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
      trailing: SubmissionStatusBox(
        name: isGraded ? "Graded" : "Not Graded",
        color: isGraded ? Colors.green.shade400 : Colors.red.shade400,
      ),
    );
  }
}

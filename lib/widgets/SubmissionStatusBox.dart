// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';

class SubmissionStatusBox extends StatelessWidget {
  SubmissionStatusBox({super.key, required this.name, required this.color});
  final String name;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      child: Text(
        name,
        style: TextStyle(
            color: Theme.of(context).appBarTheme.backgroundColor,
            fontWeight: FontWeight.w500),
      ),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    );
  }
}

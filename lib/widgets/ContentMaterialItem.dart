// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ContentMaterialItem extends StatelessWidget {
  ContentMaterialItem({super.key, required this.name});
  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.file_present_rounded,
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

import 'package:flutter/material.dart';

class UploadedAssigmentItem extends StatelessWidget {
  UploadedAssigmentItem({super.key, required this.name, required this.onPressed});
  final String name;
  final Function() onPressed;
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
      trailing: IconButton(
        onPressed: onPressed,
        icon: Icon(Icons.delete),
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}

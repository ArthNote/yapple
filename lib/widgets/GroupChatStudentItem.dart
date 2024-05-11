import 'package:flutter/material.dart';

class GroupChatStudentItem extends StatelessWidget {
  GroupChatStudentItem(
      {super.key,
      required this.name,
      required this.icon});
  final String name;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(
        Icons.person_rounded,
        size: 28,
        color: Theme.of(context).colorScheme.primary,
      ),
      title: Text(
        name,
        style: TextStyle(
            fontSize: 17, color: Theme.of(context).colorScheme.tertiary),
      ),
      trailing: Icon(icon, color: Theme.of(context).colorScheme.primary,),
    );
  }
}

class GroupChatSelectedItem extends StatelessWidget {
  GroupChatSelectedItem(
      {super.key,
      required this.name,
      required this.icon,
      required this.onPressed});
  final String name;
  final IconData icon;
  final void Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            name,
            style:
                TextStyle(color: Theme.of(context).appBarTheme.backgroundColor),
          ),
          IconButton(
            onPressed: onPressed,
            icon: Icon(icon),
            color: Theme.of(context).appBarTheme.backgroundColor,
          ),
        ],
      ),
    );
  }
}

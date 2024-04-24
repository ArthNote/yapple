// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ModuleCardMD extends StatefulWidget {
  ModuleCardMD(
      {super.key,
      required this.isStarred,
      required this.moduleCategory,
      required this.moduleName,
      required this.color});
  bool isStarred;
  final Color color;
  final String moduleCategory;
  final String moduleName;

  @override
  State<ModuleCardMD> createState() => _ModuleCardMDState();
}

class _ModuleCardMDState extends State<ModuleCardMD> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 200,
      width: size.width * 0.4,
      decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
              blurRadius: 3,
            )
          ]),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Icon(
                  Icons.code,
                  color: Theme.of(context).appBarTheme.backgroundColor,
                  size: 35,
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.isStarred = !widget.isStarred;
                    });
                  },
                  child: Icon(
                    widget.isStarred ? Icons.star : Icons.star_outline,
                    color: Colors.yellow.shade700,
                    size: 30,
                    shadows: [
                      Shadow(
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5),
                          blurRadius: 10)
                    ],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.moduleName,
                  style: TextStyle(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 8,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                      color: Theme.of(context).appBarTheme.backgroundColor,
                      borderRadius: BorderRadius.circular(50)),
                  child: Text(
                    widget.moduleCategory,
                    style: TextStyle(color: widget.color),
                  ),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

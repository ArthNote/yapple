// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';

class ModuleCardSM extends StatefulWidget {
  ModuleCardSM({
    super.key,
    required this.moduleName,
    required this.moduleCode,
    required this.moduleCategory,
    required this.isStarred,
  });

  final String moduleName;
  final String moduleCode;
  final String moduleCategory;
  bool isStarred;

  @override
  State<ModuleCardSM> createState() => _ModuleCardSMState();
}

class _ModuleCardSMState extends State<ModuleCardSM> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      margin: EdgeInsets.only(right: 15),
      width: 250,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Text(
                  widget.moduleName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w400,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
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
                ),
              ),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                widget.moduleCode,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(50)),
                child: Text(widget.moduleCategory),
              )
            ],
          ),
        ],
      ),
    );
  }
}

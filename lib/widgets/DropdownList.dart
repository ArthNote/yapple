// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';

class DropdownList extends StatefulWidget {
  DropdownList(
      {super.key,
      required this.selectedItem,
      required this.title,
      required this.items,
      required String selectedType,
      required this.onPressed});
  String selectedItem;
  final String title;
  final List<DropdownMenuItem<String>> items;
  final void Function(String) onPressed;

  @override
  State<DropdownList> createState() => _DropdownListState();
}

class _DropdownListState extends State<DropdownList> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
      decoration: BoxDecoration(
        color: Theme.of(context).appBarTheme.backgroundColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary,
          width: 1,
        ),
      ),
      child: DropdownButton<String>(
        //remove the underline
        underline: Container(),
        iconDisabledColor:
            Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
        //H20A1654779JBMD
        hint: Text(
          widget.title,
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          ),
        ),
        dropdownColor: Theme.of(context).appBarTheme.backgroundColor,
        value: widget.selectedItem,
        isExpanded: true,
        icon: Icon(
          Icons.arrow_drop_down,
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
        ),
        borderRadius: BorderRadius.circular(10),
        onChanged: (String? newValue) => widget.onPressed(newValue!),
        items: widget.items,
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SearchField extends StatefulWidget {
  SearchField(
      {super.key,
      required this.myController,
      required this.hintText,
      required this.icon,
      required this.bgColor});
  final TextEditingController myController;
  final String hintText;
  final IconData icon;
  final Color bgColor;

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: TextField(
        controller: widget.myController,
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        onChanged: (value) {
          if (value.isNotEmpty || value != "") {
            setState(() {
              isTyping = true;
            });
          } else {
            setState(() {
              isTyping = false;
            });
          }
        },
        decoration: InputDecoration(
            prefixIcon: Icon(
              widget.icon,
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
            ),
            suffixIcon: isTyping
                ? IconButton(
                    onPressed: () {
                      widget.myController.clear();
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isTyping = false;
                      });
                    },
                    icon: Icon(Icons.clear),
                  )
                : null,
            hintText: widget.hintText,
            filled: true,
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
            ),
            fillColor: widget.bgColor,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            )),
      ),
    );
  }
}

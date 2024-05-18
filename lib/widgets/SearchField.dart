// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class MySearchField extends StatefulWidget {
  MySearchField(
      {super.key,
      required this.myController,
      required this.hintText,
      required this.icon,
      required this.bgColor, required this.onchanged, this.onCancelled
      });
  final TextEditingController myController;
  final String hintText;
  final IconData icon;
  final Color bgColor;
  final Function(String) onchanged;
  final void Function()? onCancelled;

  @override
  State<MySearchField> createState() => _MySearchFieldState();
}

class _MySearchFieldState extends State<MySearchField> {
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(),
      child: TextField(
        controller: widget.myController,
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        onChanged: (value) {
          widget.onchanged(value);
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
                      widget.onCancelled != null ? widget.onCancelled!() : () {};
                      widget.myController.clear();
                      FocusScope.of(context).unfocus();
                      setState(() {
                        isTyping = false;
                      });
                    },
                    icon: Icon(Icons.clear),
                    color:
                        Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
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
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.secondary, width: 1),
            )),
      ),
    );
  }
}

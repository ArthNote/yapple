// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class MyTextField extends StatefulWidget {
  MyTextField(
      {super.key,
      required this.myController,
      required this.isPass,
      required this.hintText,
      required this.icon});

  final TextEditingController myController;
  final bool isPass;
  final String hintText;
  final IconData icon;

  @override
  State<MyTextField> createState() => _MyTextFieldState();
}

class _MyTextFieldState extends State<MyTextField> {
  bool isHidden = true;
  void toggleVisibility() {
    setState(() {
      isHidden = !isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.myController,
      obscureText: widget.isPass ? isHidden : false,
      style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
      decoration: InputDecoration(
          prefixIcon: Icon(
            widget.icon,
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          ),
          suffixIcon: widget.isPass
              ? IconButton(
                  onPressed: toggleVisibility,
                  icon: isHidden
                      ? Icon(
                          Icons.visibility_off_outlined,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5),
                        )
                      : Icon(
                          Icons.visibility_outlined,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5),
                        ),
                )
              : null,
          hintText: widget.hintText,
          filled: true,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          ),
          fillColor: Theme.of(context).colorScheme.secondary,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          )),
    );
  }
}

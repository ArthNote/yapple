// ignore_for_file: prefer_const_constructors, prefer_if_null_operators

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyTextField extends StatefulWidget {
  MyTextField(
      {super.key,
      required this.myController,
      required this.isPass,
      required this.hintText,
      this.icon,
      this.bgColor,
      required this.keyboardType,
      this.suffixIcon,
      this.formatters,
      this.readOnly});

  final TextEditingController myController;
  final bool isPass;
  final String hintText;
  final IconData? icon;
  final Color? bgColor;
  final TextInputType keyboardType;
  final IconButton? suffixIcon;
  final List<TextInputFormatter>? formatters;
  final bool? readOnly;

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
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: 250),
      child: TextField(
        controller: widget.myController,
        keyboardType: widget.keyboardType,
        obscureText: widget.isPass ? isHidden : false,
        style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
        inputFormatters: widget.formatters,
        minLines: 1,
        readOnly: widget.readOnly ?? false,
        maxLines: widget.keyboardType == TextInputType.multiline ? 200 : 1,
        decoration: InputDecoration(
          prefixIcon: widget.icon != null
              ? Icon(
                  widget.icon,
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                )
              : null,
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
              : widget.suffixIcon != null
                  ? widget.suffixIcon
                  : null,
          hintText: widget.hintText,
          filled: true,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
          ),
          fillColor: Theme.of(context).appBarTheme.backgroundColor,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.secondary,
              width: 1,
            ),
          ),
        ),
      ),
    );
  }
}

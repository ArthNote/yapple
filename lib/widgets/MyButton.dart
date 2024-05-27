// ignore_for_file: sort_child_properties_last, sized_box_for_whitespace, prefer_const_constructors

import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  MyButton({
    super.key,
    required this.backgroundColor,
    required this.textColor,
    required this.label,
    required this.onPressed,
    this.isOutlined,
    this.loading,
  });

  final Color backgroundColor;
  final Color textColor;
  final String label;
  final Function() onPressed;
  final bool? isOutlined;
  final Widget? loading;

  @override
  Widget build(BuildContext context) {
    return isOutlined == true
        ? Container(
            width: double.infinity,
            height: 60,
            child: OutlinedButton(
              onPressed: onPressed,
              child: loading != null
                  ? loading!
                  : Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
              style: ButtonStyle(
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                side: MaterialStateProperty.all(
                  BorderSide(color: backgroundColor),
                ),
              ),
            ),
          )
        : Container(
            width: double.infinity,
            height: 60,
            child: ElevatedButton(
              onPressed: onPressed,
              child: loading != null
                  ? loading!
                  : Text(
                      label,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(backgroundColor),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          );
  }
}

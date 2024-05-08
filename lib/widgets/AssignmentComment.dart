// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AssigmentComment extends StatelessWidget {
  AssigmentComment({super.key, required this.controller, required this.isEdit});
  final TextEditingController controller;
  final bool isEdit;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Comment',
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.tertiary,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 15),
            MyTextField(
              myController: controller,
              isPass: false,
              hintText: 'Enter your comment here',
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(height: 15),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label:'Submit Comment',
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

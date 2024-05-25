// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:yapple/firebase/ChatService.dart';
import 'package:yapple/firebase/FeedbackService.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/parentModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/models/teacherModel.dart';
import 'package:yapple/widgets/GroupChatStudentItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class EditTeacher extends StatelessWidget {
  const EditTeacher({super.key, required this.col, required this.teacher});
  final String col;
  final teacherModel teacher;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Edit Teacher',
            style: TextStyle(fontSize: 17),
          ),
        ),
        body: Body(
          teacher: teacher,
          col: col,
        ));
  }
}

class Body extends StatefulWidget {
  const Body({super.key, required this.col, required this.teacher});
  final String col;
  final teacherModel teacher;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  void EditTeacherRecord() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please fill all fields',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      var teacher = teacherModel(
        id: widget.teacher.id,
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        profilePicUrl: widget.teacher.profilePicUrl,
        role: 'Teacher',
      );

      bool isUpdated = await UserService().updateTeacher(widget.col, teacher);
      if (isUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Teacher updated successfully',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        if (widget.col != 'temporary') {
          await FeedbackService().updateFeedbackSenderInfo(widget.teacher.id,
              context, nameController.text, emailController.text);
          await ChatService().updateChatProfileInfo(widget.teacher.id,
              emailController.text, context, nameController.text);
          await ModuleService().updateTeacher(teacher, context);
        } else {
          print('object');
        }
        setState(() {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to create teacher',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    nameController.text = widget.teacher.name;
    emailController.text = widget.teacher.email;
    passwordController.text = widget.teacher.password;
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            MyTextField(
              myController: nameController,
              isPass: false,
              hintText: 'Enter teacher name',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            MyTextField(
              myController: emailController,
              isPass: false,
              hintText: 'Enter teacher email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            MyTextField(
              myController: passwordController,
              isPass: true,
              hintText: 'Enter teacher password',
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 20),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label: 'Edit Teacher',
              onPressed: () => EditTeacherRecord(),
            ),
          ],
        ),
      ),
    );
  }
}

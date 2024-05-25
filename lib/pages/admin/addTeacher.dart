// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/parentModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/models/teacherModel.dart';
import 'package:yapple/widgets/GroupChatStudentItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AddTeacher extends StatelessWidget {
  const AddTeacher({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Add Teacher',
            style: TextStyle(fontSize: 17),
          ),
        ),
        body: Body());
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();

  void createTeacherRecord() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ) {
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
        id: '',
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        profilePicUrl: 'null',
        role: 'Teacher',
      );

      bool isCreated = await UserService().createTeacherRecord(teacher);
      if (isCreated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Teacher created successfully',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        setState(() {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          searchController.clear();
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
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    searchController.dispose();
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
              label: 'Create Teacher',
              onPressed: () => createTeacherRecord(),
            ),
          ],
        ),
      ),
    );
  }
}

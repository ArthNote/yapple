// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sort_child_properties_last, must_be_immutable, use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yapple/firebase/AuthService.dart';
import 'package:yapple/pages/navigation/studentNav.dart';
import 'package:yapple/pages/navigation/teacherNav.dart';
import 'package:yapple/widgets/DropdownList.dart';
import 'package:yapple/widgets/MyTextField.dart';

import '../../widgets/MyButton.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  String selectedType = "Select account type";
  AuthService auth = AuthService();

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill in all fields",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    } else if (selectedType == "Select account type") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select an account type",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return;
    }

    Map<String, dynamic> signInResult = await auth.signInWithEmailPassword(
        emailController.text, passwordController.text, context);

    if (signInResult['success']) {
      if (selectedType == "Student") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentNavbar(),
          ),
        );
      } else if (selectedType == "Teacher") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TeacherNavBar(),
          ),
        );
      } else if (selectedType == "Administrator") {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentNavbar(),
          ),
        );
      }
    } else if (signInResult['error'] == 'user-not-found' ||
        signInResult['error'] == 'invalid-credential') {
      Map<String, dynamic> isFound = await auth.findRecordWithEmailAndPassword(
          emailController.text, passwordController.text);
      if (isFound['success'] as bool) {
        Map<String, dynamic> result = await auth.signUpWithEmailPassword(
            emailController.text, passwordController.text, context);
        if (result['success']) {
          bool changeDoc = await auth.changeDocumentId(
              isFound['recordID'] as String,
              result['user'] as String,
              selectedType);
          if (selectedType == "Student") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentNavbar(),
              ),
            );
          } else if (selectedType == "Teacher") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherNavBar(),
              ),
            );
          } else if (selectedType == "Administrator") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentNavbar(),
              ),
            );
          } else if (selectedType == "Parent") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentNavbar(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "Please select a valid account type",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "An error occurred: ${result['error']}",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No user found with the provided email and password",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    bool isDarkTheme = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 80,
                      child: Image.asset(
                        'assets/yapple.png',
                        color: isDarkTheme
                            ? Theme.of(context).colorScheme.tertiary
                            : null,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text(
                      "Log in to your account",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      "Welcome back! Please enter your details.",
                      style: TextStyle(
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.5),
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    MyTextField(
                      myController: emailController,
                      isPass: false,
                      hintText: "Enter your email",
                      icon: Icons.email_outlined,
                      bgColor: Theme.of(context).colorScheme.secondary,
                      keyboardType: TextInputType.emailAddress,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    MyTextField(
                      myController: passwordController,
                      isPass: true,
                      hintText: "Enter your password",
                      icon: Icons.lock_outline,
                      bgColor: Theme.of(context).colorScheme.secondary,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    DropdownList(
                      selectedType: selectedType,
                      selectedItem: selectedType,
                      onPressed: (String newValue) {
                        setState(() {
                          selectedType = newValue;
                        });
                      },
                      title: 'Select account type',
                      items: [
                        DropdownMenuItem(
                          value: "Select account type",
                          child: Text(
                            "Select account type",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Student",
                          child: Text("Student"),
                        ),
                        DropdownMenuItem(
                          value: "Teacher",
                          child: Text("Teacher"),
                        ),
                        DropdownMenuItem(
                          value: "Administrator",
                          child: Text("Administrator"),
                        ),
                        DropdownMenuItem(
                          value: "Parent",
                          child: Text("Parent"),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          child: Text(
                            "Forgot password",
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    MyButton(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).colorScheme.tertiary,
                      label: "Log in",
                      onPressed: () => login(),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}

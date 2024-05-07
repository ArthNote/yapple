// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sort_child_properties_last, must_be_immutable

import 'package:flutter/material.dart';
import 'package:yapple/pages/navigation/studentNav.dart';
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
                      height: 25,
                    ),
                    DropdownList(
                      selectedType: selectedType,
                      selectedItem: selectedType,
                      title: 'Select account type',
                      items: [
                        DropdownMenuItem(
                          value: "Select account type",
                          child: Text(
                            "Select a Type",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                        DropdownMenuItem(
                          value: "Hybrid",
                          child: Text("Hybrid"),
                        ),
                        DropdownMenuItem(
                          value: "On-Site",
                          child: Text("On-Site"),
                        ),
                        DropdownMenuItem(
                          value: "Remote",
                          child: Text("Remote"),
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StudentNavbar(),
                          ),
                        );
                      },
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

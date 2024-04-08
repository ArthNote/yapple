// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import 'pages/global/login.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'YAPPLE',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          background: Color.fromRGBO(21, 21, 21, 1),
          primary: Color.fromRGBO(118, 171, 174, 1),
          secondary: Color.fromRGBO(39, 39, 40, 1),
          tertiary: Color.fromRGBO(238, 238, 238, 1),
        ),
      ),
      home: LoginPage(),
    );
  }
}

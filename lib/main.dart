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
      //toggle between light and dark to switch the theme
      themeMode: ThemeMode.light,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          background: Color.fromRGBO(21, 21, 21, 1),
          primary: Color.fromRGBO(201, 68, 68, 1),
          secondary: Color.fromRGBO(66, 66, 66, 1),
          tertiary: Color.fromRGBO(221, 221, 221, 1),
        ),
      ),
      theme: ThemeData(
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(255, 252, 252, 1),
        ),
        colorScheme: ColorScheme.light(
          background: Color.fromRGBO(255, 252, 252, 1),
          primary: Color.fromRGBO(250, 112, 112, 1),
          secondary: Color.fromRGBO(206, 206, 206, 1),
          tertiary: Color.fromRGBO(21, 21, 21, 1),
        ),
      ),
      home: LoginPage(),
    );
  }
}

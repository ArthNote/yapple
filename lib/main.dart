// ignore_for_file: prefer_const_constructors

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:yapple/pages/global/login.dart';
import 'package:yapple/pages/global/starterScreen.dart';
import 'package:yapple/utils/UserSecureStorage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyCgz5Tvjy5MITCuDMWzP9QckIT_CItW7XQ",
        appId: "1:212222952999:android:a98dcdef7975a849353002",
        messagingSenderId: "212222952999",
        projectId: "yapple-1bc28",
        storageBucket: "gs://yapple-1bc28.appspot.com"),
  );



  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        statusBarColor: Colors.transparent),
  );
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String secureEmail = '';
  String securePassword = '';
  String secureType = '';

  @override
  void initState() {
    super.initState();
    getCredentials();
  }

  void getCredentials() async {
    final email = await UserSecureStorage.getEmail();
    final password = await UserSecureStorage.getPassword();
    final type = await UserSecureStorage.getType();
    if (email != null && password != null) {
      setState(() {
        secureEmail = email;
        securePassword = password;
        secureType = type!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'yapple',
      themeMode: ThemeMode.system,
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        appBarTheme: AppBarTheme(
          backgroundColor: Color.fromRGBO(36, 36, 36, 1),
        ),
        cardColor: Color.fromRGBO(66, 66, 66, 1),
        primaryColor: Color.fromRGBO(36, 36, 36, 1),
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
        timePickerTheme: TimePickerThemeData(
          backgroundColor: Color.fromRGBO(255, 252, 252, 1),
        ),
        cardColor: Color.fromRGBO(66, 66, 66, 1),
        primaryColor: Color.fromRGBO(238, 238, 238, 1),
        colorScheme: ColorScheme.light(
          background: Color.fromRGBO(255, 252, 252, 1),
          primary: Color.fromRGBO(250, 112, 112, 1),
          secondary: Color.fromRGBO(206, 206, 206, 1),
          tertiary: Color.fromRGBO(21, 21, 21, 1),
        ),
      ),
      home: secureEmail.isNotEmpty ? LoginPage() : StarterScreen(),
    );
  }
}

// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, prefer_const_literals_to_create_immutables, sort_child_properties_last, must_be_immutable, use_build_context_synchronously, empty_catches

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_iconpicker/extensions/string_extensions.dart';
import 'package:yapple/firebase/AuthService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/pages/global/resetPassword.dart';
import 'package:yapple/pages/navigation/adminNav.dart';
import 'package:yapple/pages/navigation/studentNav.dart';
import 'package:yapple/pages/navigation/teacherNav.dart';
import 'package:yapple/utils/UserSecureStorage.dart';
import 'package:yapple/widgets/DropdownList.dart';
import 'package:yapple/widgets/MyTextField.dart';
import 'package:local_auth/local_auth.dart';

import '../../widgets/MyButton.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailController = TextEditingController();

  TextEditingController passwordController = TextEditingController();
  String accountType = "";
  AuthService auth = AuthService();
  bool rememberAccount = false;
  late final LocalAuthentication authlocal;
  bool isSupported = false;

  String secureEmail = '';
  String securePassword = '';
  String secureType = '';

  @override
  void initState() {
    super.initState();
    getCredentials();
    authlocal = LocalAuthentication();
    checkisSupported();
  }

  void checkisSupported() async {
    bool s = await authlocal.isDeviceSupported();
    if (s) {
      print("Supported");
      setState(() {
        isSupported = true;
      });
    } else {
      print("Not supported");
    }
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

  Future<void> authenticate() async {
    try {
      bool isAuthenticated = await authlocal.authenticate(
        localizedReason:
            'Please authenticate to log in using your saved credentials',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );
      if (isAuthenticated) {
        Map<String, dynamic> signInResult = await auth.signInWithEmailPassword(
            secureEmail, securePassword, context);
        if (signInResult['success'] as bool) {
          if (secureType == "Student") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentNavbar(),
              ),
            );
          } else if (secureType == "Teacher") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherNavBar(),
              ),
            );
          } else if (secureType == "Admin") {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminNavbar(),
              ),
            );
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  "No user found",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
                backgroundColor: Theme.of(context).colorScheme.error,
              ),
            );
          }
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Authentication failed",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    } on PlatformException catch (e) {
      print(e.toString());
    }
  }

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
    }

    if (rememberAccount) {
      await UserSecureStorage.setEmail(emailController.text);
      await UserSecureStorage.setPassword(passwordController.text);
      await ifYes();
    } else {
      await ifNo();
    }
  }

  Future<void> ifYes() async {
    Map<String, dynamic> signInResult = await auth.signInWithEmailPassword(
        emailController.text, passwordController.text, context);

    if (signInResult['success'] as bool) {
      bool studentExists = await UserService().userExists(
          emailController.text, passwordController.text, 'students', context);
      if (studentExists) {
        await UserSecureStorage.setType('Student');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentNavbar(),
          ),
        );
      } else {
        bool teacherExists = await UserService().userExists(
            emailController.text, passwordController.text, 'teachers', context);
        if (teacherExists) {
          await UserSecureStorage.setType('Teacher');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherNavBar(),
            ),
          );
        } else {
          bool adminExists = await UserService().userExists(
              emailController.text, passwordController.text, 'admin', context);
          if (adminExists) {
            await UserSecureStorage.setType('Admin');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminNavbar(),
              ),
            );
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
    } else if (signInResult['error'] as String == 'user-not-found' ||
        signInResult['error'] as String == 'invalid-credential') {
      Map<String, dynamic> isFound = await auth.findRecordWithEmailAndPassword(
          emailController.text, passwordController.text);
      if (isFound['success'] as bool) {
        Map<String, dynamic> result = await auth.signUpWithEmailPassword(
            emailController.text, passwordController.text, context);
        if (result['success'] as bool) {
          String selectedType = await UserService()
              .getType(emailController.text, passwordController.text, context);
          String selectedTypeLowerCase = selectedType.toLowerCase() + 's';
          bool changeDoc = await auth.changeDocumentId(
              isFound['recordID'] as String,
              result['user'] as String,
              selectedTypeLowerCase);
          if (selectedType == "Student") {
            await UserSecureStorage.setType('Student');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentNavbar(),
              ),
            );
          } else if (selectedType == "Teacher") {
            await UserSecureStorage.setType('Teacher');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TeacherNavBar(),
              ),
            );
          } else if (selectedType == "Administrator") {
            await UserSecureStorage.setType('Admin');
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentNavbar(),
              ),
            );
          } else if (selectedType == "Parent") {
            await UserSecureStorage.setType('Parent');
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
  //130 lines of code

  Future<void> ifNo() async {
    Map<String, dynamic> signInResult = await auth.signInWithEmailPassword(
        emailController.text, passwordController.text, context);

    if (signInResult['success'] as bool) {
      bool studentExists = await UserService().userExists(
          emailController.text, passwordController.text, 'students', context);
      if (studentExists) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StudentNavbar(),
          ),
        );
      } else {
        bool teacherExists = await UserService().userExists(
            emailController.text, passwordController.text, 'teachers', context);
        if (teacherExists) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TeacherNavBar(),
            ),
          );
        } else {
          bool adminExists = await UserService().userExists(
              emailController.text, passwordController.text, 'admin', context);
          if (adminExists) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AdminNavbar(),
              ),
            );
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
    } else if (signInResult['error'] as String == 'user-not-found' ||
        signInResult['error'] as String == 'invalid-credential') {
      Map<String, dynamic> isFound = await auth.findRecordWithEmailAndPassword(
          emailController.text, passwordController.text);
      if (isFound['success'] as bool) {
        Map<String, dynamic> result = await auth.signUpWithEmailPassword(
            emailController.text, passwordController.text, context);
        if (result['success'] as bool) {
          String selectedType = await UserService()
              .getType(emailController.text, passwordController.text, context);
          String selectedTypeLowerCase = selectedType.toLowerCase() + 's';
          bool changeDoc = await auth.changeDocumentId(
              isFound['recordID'] as String,
              result['user'] as String,
              selectedTypeLowerCase);
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
  //130 lines of code

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
                    /*DropdownList(
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
                    */
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: VisualDensity.compact,
                              value: rememberAccount,
                              onChanged: (newValue) {
                                setState(() {
                                  rememberAccount = newValue!;
                                });
                              },
                            ),
                            Text(
                              "Remember this account",
                              style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return ResetPasswordPage(
                                title: 'Forgot Password',
                              );
                            }));
                          },
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
                      textColor: Theme.of(context).appBarTheme.backgroundColor!,
                      label: "Log in",
                      onPressed: () => login(),
                    ),
                    isSupported
                        ? SizedBox(
                            height: 15,
                          )
                        : SizedBox(),
                    isSupported
                        ? secureEmail.isNotEmpty
                            ? SizedBox(
                                width: double.infinity,
                                height: 60,
                                child: OutlinedButton(
                                  onPressed: () => authenticate(),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.fingerprint,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                        size: 30,
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      Text(
                                        "Log in with fingerprint",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    side: MaterialStateProperty.all(
                                      BorderSide(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary),
                                    ),
                                  ),
                                ),
                              )
                            : SizedBox()
                        : SizedBox(),
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

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/parentModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/widgets/GroupChatStudentItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AddParent extends StatelessWidget {
  const AddParent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Add Parent',
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
  studentModel? selectedStudent;
  bool isSelected = true;

  void createParentRecord() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        selectedStudent == null) {
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
      var parent = parentModel(
        id: '',
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        profilePicUrl: 'null',
        role: 'Parent',
        studentId: selectedStudent!.id,
        student: selectedStudent!,
      );

      bool isCreated = await UserService().createParentRecord(parent);
      if (isCreated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Parent created successfully',
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
          selectedStudent = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to create parent',
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
              hintText: 'Enter parent name',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            MyTextField(
              myController: emailController,
              isPass: false,
              hintText: 'Enter parent email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            MyTextField(
              myController: passwordController,
              isPass: true,
              hintText: 'Enter parent password',
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 20),
            FutureBuilder<List<studentModel>>(
                future: UserService().getAllActiveStudents(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<studentModel> students =
                          snapshot.data! as List<studentModel>;
                      return SearchField(
                        enabled: isSelected,
                        controller: searchController,
                        searchInputDecoration: InputDecoration(
                          hintText: 'Search for students',
                          filled: true,
                          hintStyle: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.5),
                          ),
                          fillColor:
                              Theme.of(context).appBarTheme.backgroundColor,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(
                              color: Theme.of(context).colorScheme.secondary,
                              width: 1,
                            ),
                          ),
                        ),
                        itemHeight: 73,
                        maxSuggestionsInViewPort: 6,
                        onSuggestionTap: (p0) {
                          setState(() {
                            selectedStudent = p0.item as studentModel;
                            isSelected = false;
                          });
                        },
                        suggestionsDecoration: SuggestionDecoration(
                          color: Theme.of(context).appBarTheme.backgroundColor,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: Theme.of(context).colorScheme.secondary,
                            width: 1,
                          ),
                        ),
                        suggestions: List.generate(students.length, (index) {
                          var student = students[index];
                          return SearchFieldListItem(student.name,
                              item: student,
                              child: SearchClassItem(
                                name: student.name,
                                icon: Icons.add,
                              ));
                        }),
                      );
                    } else if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error.toString()));
                    } else {
                      return Center(child: Text("Something went wrong"));
                    }
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                }),
            SizedBox(height: 20),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label: 'Create Parent',
              onPressed: () => createParentRecord(),
            ),
          ],
        ),
      ),
    );
  }
}

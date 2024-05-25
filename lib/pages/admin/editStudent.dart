// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, unnecessary_cast, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:yapple/firebase/AssignmentService.dart';
import 'package:yapple/firebase/ChatService.dart';
import 'package:yapple/firebase/ClassService.dart';
import 'package:yapple/firebase/FeedbackService.dart';
import 'package:yapple/firebase/QuizzService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/classModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/widgets/GroupChatStudentItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class EditStudent extends StatelessWidget {
  const EditStudent({super.key, required this.student, required this.col});
  final studentModel student;
  final String col;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Edit Student',
            style: TextStyle(fontSize: 17),
          ),
        ),
        body: Body(
          student: student,
          col: col,
        ));
  }
}

class Body extends StatefulWidget {
  const Body({super.key, required this.student, required this.col});
  final studentModel student;
  final String col;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String selectedMajor = "";
  classModel? selectedClass;
  bool isSelected = true;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.student.name;
    emailController.text = widget.student.email;
    passwordController.text = widget.student.password;
    selectedMajor = widget.student.major;
    searchController.text = widget.student.major;
  }

  void editStudentRecord() async {
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
      var student = studentModel(
        id: widget.student.id,
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        profilePicUrl: widget.student.profilePicUrl,
        role: 'Student',
        major:
            selectedClass != null ? selectedClass!.major : widget.student.major,
        classID:
            selectedClass != null ? selectedClass!.id : widget.student.classID,
      );
      bool isUpdated = await UserService().updateStudent(widget.col, student);
      if (isUpdated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Student updated successfully',
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        if (widget.col != 'temporary') {
          await QuizzService()
            .updateStudentInfo(widget.student.id, context, nameController.text);
        await AssignmentService()
            .updateStudentInfo(widget.student.id, context, nameController.text);
        await FeedbackService().updateFeedbackSenderInfo(widget.student.id,
            context, nameController.text, emailController.text);
        await ChatService().updateChatProfileInfo(widget.student.id,
            emailController.text, context, nameController.text);
            await UserService().updateParentStudent(context, student);
        } else {
          print('object');
        }
        setState(() {
          nameController.clear();
          emailController.clear();
          passwordController.clear();
          searchController.clear();
          selectedMajor = "";
        });
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to update student',
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
              hintText: 'Enter student name',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            MyTextField(
              myController: emailController,
              isPass: false,
              hintText: 'Enter student email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            MyTextField(
              myController: passwordController,
              isPass: true,
              hintText: 'Enter student password',
              keyboardType: TextInputType.visiblePassword,
            ),
            SizedBox(height: 20),
            FutureBuilder<List<classModel>>(
                future: ClassService().getClasses(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<classModel> classes =
                          snapshot.data! as List<classModel>;
                      return SearchField(
                        enabled: isSelected,
                        controller: searchController,
                        searchInputDecoration: InputDecoration(
                          hintText: 'Search for classes',
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
                            selectedClass = p0.item as classModel;
                            isSelected = false;
                            selectedMajor = selectedClass!.major;
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
                        suggestions: List.generate(classes.length, (index) {
                          var Class = classes[index];
                          return SearchFieldListItem(
                              Class.major + " year " + Class.year.toString(),
                              item: Class,
                              child: SearchClassItem(
                                name: Class.major +
                                    " year " +
                                    Class.year.toString(),
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
              label: 'Update Student',
              onPressed: () => editStudentRecord(),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_const_constructors_in_immutables, sort_child_properties_last, prefer_interpolation_to_compose_strings, use_build_context_synchronously, empty_catches

import 'dart:convert';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:yapple/firebase/ClassService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/classModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/widgets/GroupChatStudentItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';
import 'package:yapple/widgets/SearchField.dart';

class CreateStudentsExcel extends StatelessWidget {
  CreateStudentsExcel({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
            title: Text(
              'Create Students',
              style: TextStyle(fontSize: 17),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                  text: "Manually",
                ),
                Tab(
                  text: "From Excel",
                ),
              ],
            )),
        body: TabBarView(
          children: [
            Manually(),
            FromExcel(),
          ],
        ),
      ),
    );
  }
}

class Manually extends StatefulWidget {
  Manually({super.key});

  @override
  State<Manually> createState() => _ManuallyState();
}

class _ManuallyState extends State<Manually> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  String selectedMajor = "";
  classModel? selectedClass;
  bool isSelected = true;

  void createStudentRecord() async {
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
        id: '',
        name: nameController.text,
        email: emailController.text,
        password: passwordController.text,
        profilePicUrl: 'null',
        role: 'Student',
        major: selectedClass != null ? selectedClass!.major : '',
        classID: selectedClass != null ? selectedClass!.id : '',
      );

      bool isCreated = await UserService().createStudentRecord(student);
      if (isCreated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Student created successfully',
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
          selectedMajor = "";
          isSelected = true;
          selectedClass = null;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Failed to create student',
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
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label: 'Create Student',
              onPressed: () => createStudentRecord(),
            ),
          ],
        ),
      ),
    );
  }
}

class FromExcel extends StatefulWidget {
  const FromExcel({super.key});

  @override
  State<FromExcel> createState() => _BodyState();
}

class _BodyState extends State<FromExcel> {
  String? filePath;
  List<List<dynamic>> data = [];
  List<studentModel> students = [];
  List<studentModel> foundStudents = [];

  void pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowMultiple: false,
      allowedExtensions: ['csv'],
    );

    if (result == null) return;

    filePath = result.files.single.path!;
    final input = File(filePath!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(CsvToListConverter())
        .toList();

    for (var i = 1; i < fields.length; i++) {
      var student = studentModel(
        id: '',
        name: fields[i][0].toString(),
        email: fields[i][1].toString(),
        password: fields[i][2].toString(),
        profilePicUrl: 'null',
        role: 'Student',
        major: fields[i][3].toString().isEmpty ? '' : fields[i][3].toString(),
        classID: '',
      );
      setState(() {
        students.add(student);
      });
    }
    setState(() {
      foundStudents = students;
    });
  }

  void createStudents() async {
    try {
      for (var student in students) {
        await UserService().createStudentRecord(student);
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Students created successfully',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
      );
      setState(() {
        students.clear();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Failed to create students',
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }

  TextEditingController myController = TextEditingController();

  void runFilter(String enteredKeyword) async {
    List<studentModel> results = [];
    if (enteredKeyword.isEmpty) {
      setState(() {
        foundStudents = students;
      });
    } else {
      setState(() {
        results = students
            .where((student) =>
                student.name
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()) ||
                student.email
                    .toLowerCase()
                    .contains(enteredKeyword.toLowerCase()))
            .toList();
        foundStudents = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          students.isEmpty
              ? Text(
                  'Upload a .CSV file with the following format:',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 15,
                  ),
                )
              : SizedBox(),
          students.isEmpty ? SizedBox(height: 10) : SizedBox(),
          students.isEmpty
              ? Text(
                  'full name, email, password, major',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 15,
                  ),
                )
              : SizedBox(),
          students.isEmpty ? SizedBox(height: 20) : SizedBox(),
          MyButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).appBarTheme.backgroundColor!,
            label: students.isEmpty ? 'Pick .CSV File' : 'Create Students',
            onPressed:
                students.isEmpty ? () => pickFile() : () => createStudents(),
          ),
          SizedBox(height: 20),
          students.isNotEmpty
              ? MySearchField(
                  myController: myController,
                  hintText: 'Search for students',
                  icon: Icons.search,
                  bgColor: Theme.of(context).appBarTheme.backgroundColor!,
                  onchanged: (value) {
                    setState(() {
                      runFilter(value);
                    });
                  },
                  onCancelled: () {
                    setState(() {
                      myController.clear();
                      runFilter('');
                    });
                  },
                )
              : SizedBox(),
          SizedBox(height: 30),
          Expanded(
            child: ListView.builder(
                itemCount: foundStudents.length,
                scrollDirection: Axis.vertical,
                shrinkWrap: false,
                itemBuilder: (context, index) {
                  var student = foundStudents[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 15),
                    color: Theme.of(context).appBarTheme.backgroundColor!,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                      side: BorderSide(
                        color: Theme.of(context).colorScheme.secondary,
                        width: 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.only(left: 16),
                      tileColor: Theme.of(context).appBarTheme.backgroundColor!,
                      leading: Icon(
                        Icons.person,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      title: Text(
                        student.name.isEmpty ? 'No Name' : student.name,
                      ),
                      subtitle: Text(
                        student.email.isEmpty ? 'No Email' : student.email,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: () {
                              TextEditingController nameController =
                                  TextEditingController();

                              TextEditingController emailController =
                                  TextEditingController();

                              TextEditingController passwordController =
                                  TextEditingController();

                              TextEditingController searchController =
                                  TextEditingController();

                              String selectedMajor = "";

                              classModel? selectedClass;

                              bool isSelected = true;

                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return StudentItemDialog(
                                      student: student,
                                      nameController: nameController,
                                      emailController: emailController,
                                      passwordController: passwordController,
                                      searchController: searchController,
                                      selectedMajor: selectedMajor,
                                      selectedClass: selectedClass,
                                      isSelected: isSelected,
                                      onPressed1:
                                          (selectedMajor1, selectedClass1) {
                                        setState(() {
                                          selectedMajor = selectedMajor1;
                                          selectedClass = selectedClass1;
                                        });
                                      },
                                      onPressed: () {
                                        var updatedStudent = studentModel(
                                          id: student.id,
                                          name: nameController.text,
                                          email: emailController.text,
                                          password: passwordController.text,
                                          profilePicUrl: student.profilePicUrl,
                                          role: student.role,
                                          major: selectedClass != null
                                              ? selectedClass!.major
                                              : 's',
                                          classID: selectedClass != null
                                              ? selectedClass!.id
                                              : 's',
                                        );
                                        setState(() {
                                          students[index] = updatedStudent;
                                        });
                                        Navigator.pop(context);
                                      },
                                    );
                                  });
                            },
                            icon: Icon(Icons.edit),
                          ),
                          IconButton(
                            color: Theme.of(context).colorScheme.primary,
                            onPressed: () {
                              setState(() {
                                students.removeAt(index);
                              });
                            },
                            icon: Icon(Icons.delete),
                          ),
                        ],
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}

class StudentItemDialog extends StatefulWidget {
  StudentItemDialog(
      {super.key,
      required this.student,
      this.onPressed,
      this.showButton,
      required this.nameController,
      required this.emailController,
      required this.passwordController,
      required this.searchController,
      required this.selectedMajor,
      this.selectedClass,
      required this.isSelected,
      this.onPressed1});
  final studentModel student;
  final void Function()? onPressed;
  final void Function(String selectedMajor, classModel? selectedClass)?
      onPressed1;
  final bool? showButton;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController searchController;
  String selectedMajor;
  classModel? selectedClass;
  bool isSelected;

  @override
  State<StudentItemDialog> createState() => _StudentItemDialogState();
}

class _StudentItemDialogState extends State<StudentItemDialog> {
  @override
  void initState() {
    widget.nameController.text = widget.student.name;
    widget.emailController.text = widget.student.email;
    widget.passwordController.text = widget.student.password;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).appBarTheme.backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            MyTextField(
              myController: widget.nameController,
              isPass: false,
              hintText: 'Enter student name',
              keyboardType: TextInputType.text,
            ),
            SizedBox(height: 20),
            MyTextField(
              myController: widget.emailController,
              isPass: false,
              hintText: 'Enter student email',
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            MyTextField(
              myController: widget.passwordController,
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
                        enabled: widget.isSelected,
                        controller: widget.searchController,
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
                          widget.onPressed1!(
                              p0.item != null
                                  ? (p0.item as classModel).major
                                  : widget.selectedMajor,
                              p0.item as classModel);
                          setState(() {
                            widget.isSelected = false;
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
              onPressed: () => widget.onPressed!(),
            ),
          ],
        ),
      ),
    );
  }
}

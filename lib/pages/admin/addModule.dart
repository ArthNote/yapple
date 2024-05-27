// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/teacherModel.dart';
import 'package:yapple/widgets/GroupChatStudentItem.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AddModule extends StatelessWidget {
  const AddModule({super.key, required this.classID});
  final String classID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Add Module',
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Body(
        classID: classID,
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key, required this.classID});
  final String classID;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController nameController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  TextEditingController categoryController = TextEditingController();
  TextEditingController aboutController = TextEditingController();
  TextEditingController searchController = TextEditingController();
  bool isSelected = true;
  teacherModel? selectedTeacher;

  List<Color> colors = [
    Color(0xffffcf2f),
    Colors.blue,
    Color.fromARGB(255, 249, 112, 110),
    Color.fromARGB(255, 84, 209, 89),
    Color.fromARGB(255, 167, 88, 216),
  ];

  List<IconData> icons = [
    Icons.code,
    Icons.business,
    Icons.monetization_on,
    Icons.computer,
    Icons.book,
    Icons.business_center,
    Icons.developer_mode,
    Icons.design_services,
    Icons.engineering,
    Icons.person,
    Icons.markunread_outlined,
    Icons.school
  ];

  int selectedColor = 0;
  int selectedIcon = 0;

  void addModule() async {
    if (nameController.text.isEmpty ||
        codeController.text.isEmpty ||
        categoryController.text.isEmpty ||
        aboutController.text.isEmpty ||
        selectedTeacher == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please fill all the fields"),
        ),
      );
    } else {
      var newModule = moduleModel(
        name: nameController.text,
        code: codeController.text,
        category: categoryController.text,
        about: aboutController.text,
        color: colors[selectedColor],
        icon: icons[selectedIcon],
        teacher: selectedTeacher!,
        id: '',
        classID: widget.classID,
        teacherID: selectedTeacher!.id,
      );
      bool isCreated = await ModuleService().addModule(newModule);
      if (isCreated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Module added successfully",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).colorScheme.primary,
          ),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Failed to add module",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            MyTextField(
              myController: nameController,
              isPass: false,
              hintText: 'Module Name',
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 20,
            ),
            FutureBuilder<List<teacherModel>>(
                future: UserService().getAllActiveTeachers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    if (snapshot.hasData) {
                      List<teacherModel> teachers =
                          snapshot.data! as List<teacherModel>;
                      return SearchField(
                        enabled: isSelected,
                        controller: searchController,
                        searchInputDecoration: InputDecoration(
                          hintText: 'Search for a teacher',
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
                            selectedTeacher = p0.item as teacherModel;
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
                        suggestions: List.generate(teachers.length, (index) {
                          var teacher = teachers[index];
                          return SearchFieldListItem(teacher.name,
                              item: teacher,
                              child: SearchClassItem(
                                name: teacher.name,
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
            SizedBox(
              height: 20,
            ),
            MyTextField(
              myController: codeController,
              isPass: false,
              hintText: 'Module Code',
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 20,
            ),
            MyTextField(
              myController: categoryController,
              isPass: false,
              hintText: 'Module Category',
              keyboardType: TextInputType.text,
            ),
            SizedBox(
              height: 20,
            ),
            MyTextField(
              myController: aboutController,
              isPass: false,
              hintText: 'Module About',
              keyboardType: TextInputType.multiline,
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select a Color",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  alignment: WrapAlignment.center,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: List<Widget>.generate(5, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedColor = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: colors[index],
                          child: selectedColor == index
                              ? Icon(
                                  Icons.done,
                                  color: Colors.black,
                                  size: 16,
                                )
                              : null,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Select an Icon",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.tertiary),
                ),
                SizedBox(
                  height: 8,
                ),
                Wrap(
                  alignment: WrapAlignment.start,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: List<Widget>.generate(icons.length, (index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedIcon = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 8.0, bottom: 8),
                        child: CircleAvatar(
                          radius: 15,
                          backgroundColor: selectedIcon == index
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.secondary,
                          child: Icon(
                            icons[index],
                            color: Colors.black,
                            size: 16,
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
            SizedBox(
              height: 23,
            ),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label: "Add Module",
              onPressed: () => addModule(),
            ),
          ],
        ),
      ),
    );
  }
}

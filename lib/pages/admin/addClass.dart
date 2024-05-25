// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yapple/firebase/ClassService.dart';
import 'package:yapple/models/classModel.dart';
import 'package:yapple/widgets/DropdownList.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AddClass extends StatelessWidget {
  const AddClass({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Add Class',
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController nameController = TextEditingController();

  TextEditingController yearController = TextEditingController();

  String selectedMajor = "Select major";

  void addClass() async {
    if (nameController.text.isEmpty ||
        yearController.text.isEmpty ||
        selectedMajor == "Select major") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please fill all fields",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      if (int.parse(yearController.text) > 3 ||
          int.parse(yearController.text) < 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Year must be between 1 and 3",
              textAlign: TextAlign.center,
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      } else {
        var newClass = classModel(
          id: '',
          name: nameController.text,
          major: selectedMajor,
          year: int.parse(yearController.text),
        );
        bool added = await ClassService().addClass(newClass);
        if (added) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Class added successfully",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Theme.of(context).colorScheme.primary,
            ),
          );
          setState(() {
            nameController.clear();
            yearController.clear();
            selectedMajor = "Select major";
          });
          Navigator.pop(context);
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                "Failed to add class",
                textAlign: TextAlign.center,
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
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
                hintText: 'Class Name',
                keyboardType: TextInputType.text,
              ),
              SizedBox(
                height: 20,
              ),
              DropdownList(
                selectedType: selectedMajor,
                selectedItem: selectedMajor,
                onPressed: (String newValue) {
                  setState(() {
                    selectedMajor = newValue;
                  });
                },
                title: 'Select major',
                items: [
                  DropdownMenuItem(
                    enabled: false,
                    value: "Select major",
                    child: Text(
                      "Select major",
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                  DropdownMenuItem(
                    value: "Software Engineering",
                    child: Text("Software Engineering"),
                  ),
                  DropdownMenuItem(
                    value: "Data Security",
                    child: Text("Data Security"),
                  ),
                  DropdownMenuItem(
                    value: "Business Administrator",
                    child: Text("Business Administrator"),
                  ),
                  DropdownMenuItem(
                    value: "Finance",
                    child: Text("Finance"),
                  ),
                ],
              ),
              SizedBox(
                height: 20,
              ),
              MyTextField(
                myController: yearController,
                isPass: false,
                hintText: 'Class year (between 1 and 3)',
                keyboardType: TextInputType.number,
                formatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              SizedBox(
                height: 20,
              ),
              MyButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).appBarTheme.backgroundColor!,
                label: "Add Class",
                onPressed: () => addClass(),
              ),
            ],
          )),
    );
  }
}

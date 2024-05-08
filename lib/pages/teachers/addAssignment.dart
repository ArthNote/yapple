// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AddAssignmentPage extends StatelessWidget {
  const AddAssignmentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          "Create Assignment",
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
  TextEditingController titleController = TextEditingController();

  TextEditingController aboutController = TextEditingController();
  TextEditingController timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          MyTextField(
            myController: titleController,
            isPass: false,
            hintText: 'Enter assigment title',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 15),
          MyTextField(
            myController: aboutController,
            isPass: false,
            hintText: 'Enter assigment about',
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: 15),
          MyTextField(
              myController: timeController,
              isPass: false,
              hintText: "Select Submission Deadline Time",
              keyboardType: TextInputType.datetime,
              suffixIcon: IconButton(
                onPressed: () {
                  var startTime = showTimePicker(
                    initialEntryMode: TimePickerEntryMode.input,
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  startTime.then((selectedTime) {
                    if (selectedTime != null) {
                      String format = DateFormat.Hm().format(DateTime(
                        DateTime.now().year,
                        DateTime.now().month,
                        DateTime.now().day,
                        selectedTime.hour,
                        selectedTime.minute,
                      ));
                      setState(() {
                        timeController.text = format;
                      });
                    }
                  });
                },
                icon: Icon(
                  Icons.access_time_rounded,
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                ),
              )),
        ],
      ),
    );
  }
}

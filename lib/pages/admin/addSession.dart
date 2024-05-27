// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/firebase/SessionService.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/sessionModel.dart';
import 'package:yapple/widgets/DropdownList.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AddSession extends StatelessWidget {
  const AddSession({super.key, required this.module});
  final moduleModel module;

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
              'Add Session',
              style: TextStyle(fontSize: 17),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                  text: "One session",
                ),
                Tab(
                  text: "Multiple sessions",
                ),
              ],
            )),
        body: TabBarView(
          children: [
            OneBody(
              module: module,
            ),
            MultipleBody(
              module: module,
            ),
          ],
        ),
      ),
    );
  }
}

class MultipleBody extends StatefulWidget {
  const MultipleBody({super.key, required this.module});
  final moduleModel module;

  @override
  State<MultipleBody> createState() => _BodyState();
}

class _BodyState extends State<MultipleBody> {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();

  DateTimeRange selectedDate = DateTimeRange(
    start: DateTime.now(),
    end: DateTime.now(),
  );

  String daySelected = 'Select a day';
  String repeatSelected = 'None';
  bool isLoading = false;

  void addSessions() async {
    if (startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty ||
        daySelected == 'Select a day' ||
        dateController.text.isEmpty ||
        repeatSelected == 'None') {
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
      List<sessionModel> sessions = [];
      for (DateTime date = selectedDate.start;
          date.isBefore(selectedDate.end);
          date = date.add(Duration(days: 1))) {
        String dayName = DateFormat('EEEE').format(date);
        if (repeatSelected == 'Daily') {
          sessions.add(
            sessionModel(
              id: '',
              moduleName: widget.module.name,
              teacherName: widget.module.teacher.name,
              startTime: startTime.format(context),
              endTime: endTime.format(context),
              date: date,
              classID: widget.module.classID,
              moduleID: widget.module.id,
            ),
          );
        } else if (repeatSelected == 'Weekly') {
          if (dayName == daySelected) {
            sessions.add(
              sessionModel(
                id: '',
                moduleName: widget.module.name,
                teacherName: widget.module.teacher.name,
                startTime: startTime.format(context),
                endTime: endTime.format(context),
                date: date,
                classID: widget.module.classID,
                moduleID: widget.module.id,
              ),
            );
          } else {
            print('day not matched');
          }
        } else {
          print('repeat not matched');
        }
      }
      print(sessions.map((e) => e.toJson()).toList());
      setState(() {
        isLoading = true;
      });
      bool isCreated = await SessionService().createSessions(
        sessions,
        widget.module.id,
        widget.module.classID,
      );
      setState(() {
        isLoading = false;
      });
      if (isCreated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Sessions created successfully",
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
              "Failed to create session",
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: isLoading
            ? Center(
                child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text('Creating sessions...'),
                ],
              ))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                            myController: startTimeController,
                            isPass: false,
                            hintText: "Start Time",
                            keyboardType: TextInputType.datetime,
                            suffixIcon: IconButton(
                              onPressed: () {
                                var startTimePicked = showTimePicker(
                                  initialEntryMode: TimePickerEntryMode.input,
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                startTimePicked.then((selectedTime) {
                                  if (selectedTime != null) {
                                    String format =
                                        DateFormat.Hm().format(DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    ));
                                    setState(() {
                                      startTimeController.text = format;
                                      startTime = selectedTime;
                                    });
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.access_time_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.5),
                              ),
                            )),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: MyTextField(
                            myController: endTimeController,
                            isPass: false,
                            hintText: "End Time",
                            keyboardType: TextInputType.datetime,
                            suffixIcon: IconButton(
                              onPressed: () {
                                var endTimePicked = showTimePicker(
                                  initialEntryMode: TimePickerEntryMode.input,
                                  context: context,
                                  initialTime: TimeOfDay.now(),
                                );
                                endTimePicked.then((selectedTime) {
                                  if (selectedTime != null) {
                                    String format =
                                        DateFormat.Hm().format(DateTime(
                                      DateTime.now().year,
                                      DateTime.now().month,
                                      DateTime.now().day,
                                      selectedTime.hour,
                                      selectedTime.minute,
                                    ));
                                    setState(() {
                                      endTimeController.text = format;
                                      endTime = selectedTime;
                                    });
                                  }
                                });
                              },
                              icon: Icon(
                                Icons.access_time_rounded,
                                color: Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.5),
                              ),
                            )),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownList(
                    selectedItem: daySelected,
                    title: 'Select a day',
                    items: [
                      DropdownMenuItem(
                        enabled: false,
                        value: 'Select a day',
                        child: Text(
                          'Select a day',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Monday',
                        child: Text('Monday'),
                      ),
                      DropdownMenuItem(
                        value: 'Tuesday',
                        child: Text('Tuesday'),
                      ),
                      DropdownMenuItem(
                        value: 'Wednesday',
                        child: Text('Wednesday'),
                      ),
                      DropdownMenuItem(
                        value: 'Thursday',
                        child: Text('Thursday'),
                      ),
                      DropdownMenuItem(
                        value: 'Friday',
                        child: Text('Friday'),
                      ),
                      DropdownMenuItem(
                        value: 'Saturday',
                        child: Text('Saturday'),
                      ),
                      DropdownMenuItem(
                        value: 'Sunday',
                        child: Text('Sunday'),
                      ),
                    ],
                    selectedType: daySelected,
                    onPressed: (value) {
                      setState(() {
                        daySelected = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  MyTextField(
                    myController: dateController,
                    isPass: false,
                    hintText: "Date Range",
                    keyboardType: TextInputType.text,
                    readOnly: true,
                    suffixIcon: IconButton(
                      onPressed: () async {
                        showDateRangePicker(
                          context: context,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(3000),
                          initialDateRange: selectedDate,
                        ).then((value) {
                          if (value != null) {
                            setState(() {
                              selectedDate = value;
                              dateController.text =
                                  "${DateFormat.yMMMd().format(selectedDate.start)} - ${DateFormat.yMMMd().format(selectedDate.end)}";
                            });
                          }
                        });
                      },
                      icon: Icon(
                        Icons.calendar_today_rounded,
                        color: Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withOpacity(0.5),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  DropdownList(
                    selectedItem: repeatSelected,
                    title: 'Repeat',
                    items: [
                      DropdownMenuItem(
                        value: 'None',
                        child: Text(
                          'Repeat',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'Daily',
                        child: Text('Daily'),
                      ),
                      DropdownMenuItem(
                        value: 'Weekly',
                        child: Text('Weekly'),
                      ),
                    ],
                    selectedType: repeatSelected,
                    onPressed: (value) {
                      setState(() {
                        repeatSelected = value;
                      });
                    },
                  ),
                  SizedBox(
                    height: 23,
                  ),
                  MyButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).appBarTheme.backgroundColor!,
                    label: "Add Sessions",
                    onPressed: () => addSessions(),
                  ),
                ],
              ),
      ),
    );
  }
}

class OneBody extends StatefulWidget {
  const OneBody({super.key, required this.module});
  final moduleModel module;

  @override
  State<OneBody> createState() => _OneBodyState();
}

class _OneBodyState extends State<OneBody> {
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TimeOfDay startTime = TimeOfDay.now();
  TimeOfDay endTime = TimeOfDay.now();
  DateTime selectedDate = DateTime.now();

  void addSession() async {
    if (startTimeController.text.isEmpty ||
        endTimeController.text.isEmpty ||
        dateController.text.isEmpty) {
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
      var session = sessionModel(
        id: '',
        moduleName: widget.module.name,
        teacherName: widget.module.teacher.name,
        startTime: startTime.format(context),
        endTime: endTime.format(context),
        date: selectedDate,
        classID: widget.module.classID,
        moduleID: widget.module.id,
      );

      bool isCreated = await SessionService().createSession(
        session,
        widget.module.id,
        widget.module.classID,
      );
      if (isCreated) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Session created successfully",
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
              "Failed to create session",
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
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Row(
              children: [
                Expanded(
                  child: MyTextField(
                      myController: startTimeController,
                      isPass: false,
                      hintText: "Start Time",
                      keyboardType: TextInputType.datetime,
                      suffixIcon: IconButton(
                        onPressed: () {
                          var startTimePicked = showTimePicker(
                            initialEntryMode: TimePickerEntryMode.input,
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          startTimePicked.then((selectedTime) {
                            if (selectedTime != null) {
                              String format = DateFormat.Hm().format(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                selectedTime.hour,
                                selectedTime.minute,
                              ));
                              setState(() {
                                startTimeController.text = format;
                                startTime = selectedTime;
                              });
                            }
                          });
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5),
                        ),
                      )),
                ),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: MyTextField(
                      myController: endTimeController,
                      isPass: false,
                      hintText: "End Time",
                      keyboardType: TextInputType.datetime,
                      suffixIcon: IconButton(
                        onPressed: () {
                          var endTimePicked = showTimePicker(
                            initialEntryMode: TimePickerEntryMode.input,
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          endTimePicked.then((selectedTime) {
                            if (selectedTime != null) {
                              String format = DateFormat.Hm().format(DateTime(
                                DateTime.now().year,
                                DateTime.now().month,
                                DateTime.now().day,
                                selectedTime.hour,
                                selectedTime.minute,
                              ));
                              setState(() {
                                endTimeController.text = format;
                                endTime = selectedTime;
                              });
                            }
                          });
                        },
                        icon: Icon(
                          Icons.access_time_rounded,
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.5),
                        ),
                      )),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            MyTextField(
              myController: dateController,
              isPass: false,
              hintText: "Select a date",
              keyboardType: TextInputType.text,
              readOnly: true,
              suffixIcon: IconButton(
                onPressed: () async {
                  showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime(3000),
                  ).then((value) {
                    if (value != null) {
                      setState(() {
                        selectedDate = value;
                        dateController.text = DateFormat.yMMMd().format(value);
                      });
                    }
                  });
                },
                icon: Icon(
                  Icons.calendar_today_rounded,
                  color:
                      Theme.of(context).colorScheme.tertiary.withOpacity(0.5),
                ),
              ),
            ),
            SizedBox(
              height: 23,
            ),
            MyButton(
              backgroundColor: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).appBarTheme.backgroundColor!,
              label: "Add Session",
              onPressed: () => addSession(),
            ),
          ],
        ),
      ),
    );
  }
}

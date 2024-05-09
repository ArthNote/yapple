// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class AddQuizzPage extends StatelessWidget {
  const AddQuizzPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          'Add Quizz',
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
  bool customIcon = false;
  List<Widget> questionsWidgets = [];
  List<Map<String, Object>> questions = [];
  List<int> isInside = [];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MyTextField(
            myController: titleController,
            isPass: false,
            hintText: 'Enter Quizz Title',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 15),
          MyButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.tertiary,
            label: 'Add a Question',
            onPressed: () {
              setState(() {
                questionsWidgets.add(
                  QuizzQuestionList(
                    index: questionsWidgets.length,
                    titleController: TextEditingController(),
                    Controller1: TextEditingController(),
                    Controller2: TextEditingController(),
                    Controller3: TextEditingController(),
                    Controller4: TextEditingController(),
                    correctIndexController: TextEditingController(),
                  ),
                );
              });
            },
            isOutlined: true,
          ),
          SizedBox(height: 15),
          MyButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).appBarTheme.backgroundColor!,
            label: 'Add Quizz',
            onPressed: () {},
          ),
          SizedBox(height: 30),
          Expanded(
            child: ListView(
              children: List.generate(
                questionsWidgets.length,
                (index) {
                  final TextEditingController titleController =
                      TextEditingController();
                  final TextEditingController Controller1 =
                      TextEditingController();
                  final TextEditingController Controller2 =
                      TextEditingController();
                  final TextEditingController Controller3 =
                      TextEditingController();
                  final TextEditingController Controller4 =
                      TextEditingController();
                  final TextEditingController correctAnswerIndex =
                      TextEditingController();
                  if (questions.isEmpty || questions.length <= index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: QuizzQuestionList(
                        index: index,
                        titleController: titleController,
                        Controller1: Controller1,
                        Controller2: Controller2,
                        Controller3: Controller3,
                        Controller4: Controller4,
                        readOnly: false,
                        correctIndexController: correctAnswerIndex,
                        onPressed: () {
                          if (int.parse(correctAnswerIndex.text) > 4) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                    'Correct answer index should be between 1 and 4',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor!,
                                    )),
                                backgroundColor:
                                    Theme.of(context).colorScheme.error,
                              ),
                            );
                          }
                          var question = {
                            'question': titleController.text,
                            'correctAnswerIndex':
                                int.parse(correctAnswerIndex.text) - 1,
                            'options': [
                              Controller1.text.isNotEmpty
                                  ? Controller1.text
                                  : '',
                              Controller2.text.isNotEmpty
                                  ? Controller2.text
                                  : '',
                              Controller3.text.isNotEmpty
                                  ? Controller3.text
                                  : '',
                              Controller4.text.isNotEmpty
                                  ? Controller4.text
                                  : '',
                            ],
                          };
                          questions.add(question);
                          setState(() {});
                          isInside.add(index);
                          print(questions);
                        },
                      ),
                    );
                  } else {
                    var question = questions[index];
                    titleController.text =
                        question['question'].toString() ?? '';
                    Controller1.text =
                        (question['options'] as List<String?>)[0].toString() ??
                            '';
                    Controller2.text =
                        (question['options'] as List<String?>)[1].toString() ??
                            '';
                    Controller3.text =
                        (question['options'] as List<String?>)[2].toString() ??
                            '';
                    Controller4.text =
                        (question['options'] as List<String?>)[3].toString() ??
                            '';
                    correctAnswerIndex.text =
                        ((question['correctAnswerIndex'] as int) + 1)
                                .toString() ??
                            '';
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: QuizzQuestionList(
                        index: index,
                        titleController: titleController,
                        Controller1: Controller1,
                        Controller2: Controller2,
                        Controller3: Controller3,
                        Controller4: Controller4,
                        correctIndexController: correctAnswerIndex,
                        readOnly: true,
                        onPressed: () {
                          var question = {
                            'question': titleController.text,
                            'correctAnswerIndex':
                                int.parse(correctAnswerIndex.text) - 1,
                            'options': [
                              Controller1.text.isNotEmpty
                                  ? Controller1.text
                                  : null,
                              Controller2.text.isNotEmpty
                                  ? Controller2.text
                                  : null,
                              Controller3.text.isNotEmpty
                                  ? Controller3.text
                                  : null,
                              Controller4.text.isNotEmpty
                                  ? Controller4.text
                                  : null,
                            ],
                          };
                          questions.add(question);
                          print(questions);
                          isInside.add(index);
                          setState(() {});
                        },
                      ),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class QuizzQuestionList extends StatefulWidget {
  QuizzQuestionList(
      {super.key,
      required this.index,
      required this.titleController,
      required this.Controller1,
      required this.Controller2,
      required this.Controller3,
      required this.Controller4,
      this.onPressed,
      required this.correctIndexController,
      this.readOnly});
  final int index;
  final TextEditingController titleController;
  final TextEditingController Controller1;
  final TextEditingController Controller2;
  final TextEditingController Controller3;
  final TextEditingController Controller4;
  final TextEditingController correctIndexController;
  final void Function()? onPressed;
  final bool? readOnly;

  @override
  State<QuizzQuestionList> createState() => _QuizzQuestionListState();
}

class _QuizzQuestionListState extends State<QuizzQuestionList> {
  bool customIcon = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionTile(
      initiallyExpanded: false,
      title: Text(
        "Question " + (widget.index + 1).toString(),
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
      ),
      childrenPadding: EdgeInsets.fromLTRB(20, 0, 20, 15),
      expandedAlignment: Alignment.centerLeft,
      backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      collapsedBackgroundColor: Theme.of(context).appBarTheme.backgroundColor,
      //add a collapsed shape
      collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1,
          )),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: Theme.of(context).colorScheme.secondary,
            width: 1,
          )),
      children: [
        MyTextField(
          myController: widget.titleController,
          isPass: false,
          hintText: 'Enter Question',
          keyboardType: TextInputType.text,
          readOnly: widget.readOnly,
        ),
        SizedBox(height: 15),
        MyTextField(
          myController: widget.Controller1,
          isPass: false,
          hintText: 'Enter option 1',
          keyboardType: TextInputType.multiline,
          readOnly: widget.readOnly,
        ),
        SizedBox(height: 15),
        MyTextField(
          myController: widget.Controller2,
          isPass: false,
          hintText: 'Enter option 2',
          keyboardType: TextInputType.multiline,
          readOnly: widget.readOnly,
        ),
        SizedBox(height: 15),
        MyTextField(
          myController: widget.Controller3,
          isPass: false,
          hintText: 'Enter option 3',
          keyboardType: TextInputType.multiline,
          readOnly: widget.readOnly,
        ),
        SizedBox(height: 15),
        MyTextField(
          myController: widget.Controller4,
          isPass: false,
          hintText: 'Enter option 4',
          keyboardType: TextInputType.multiline,
          readOnly: widget.readOnly,
        ),
        SizedBox(height: 15),
        MyTextField(
          myController: widget.correctIndexController,
          isPass: false,
          hintText: 'Enter the correct option index (1-4)',
          keyboardType: TextInputType.number,
          readOnly: widget.readOnly,
          formatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
        ),
        SizedBox(height: 15),
        !widget.readOnly!
            ? MyButton(
                backgroundColor: Theme.of(context).colorScheme.primary,
                textColor: Theme.of(context).appBarTheme.backgroundColor!,
                label: 'Add Question',
                onPressed: widget.onPressed ?? () {},
              )
            : SizedBox(),
      ],
      onExpansionChanged: (bool expanded) {
        setState(() => customIcon = expanded);
      },
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_cast

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yapple/firebase/QuizzService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/quizzModel.dart';
import 'package:yapple/models/quizzSubmission.dart';
import 'package:yapple/pages/students/quizzResultScreen.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/QuizzAnswerCard.dart';

class QuizzPage extends StatefulWidget {
  QuizzPage(
      {super.key,
      required this.quizz,
      required this.classID,
      required this.moduleID});
  final quizzModel quizz;
  final String classID;
  final String moduleID;

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  bool startQuizz = false;
  String studentName = '';
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  bool isSubmitted = false;
  String grade = '';

  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
    getStudentName();
    checkSubmission();
  }

  void getStudentName() async {
    String n = await UserService().getStudentName(uid, context);
    setState(() {
      studentName = n;
    });
  }

  void checkSubmission() async {
    Map<String, dynamic> r = await QuizzService().checkSubmission(
        context, widget.classID, widget.moduleID, widget.quizz.id, uid);
    setState(() {
      isSubmitted = r['exists'];
      grade = r['grade'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        title: Text(
          widget.quizz.title,
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: isSubmitted
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  "You already submitted this quizz and got $grade/100.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 25,
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
            )
          : startQuizz
              ? Body(
                  quizz: widget.quizz,
                  classID: widget.classID,
                  moduleID: widget.moduleID,
                  studentName: studentName,
                  uid: uid,
                )
              : Center(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Ready to start the quizz?",
                          style: TextStyle(
                            fontSize: 25,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        MyButton(
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                          textColor:
                              Theme.of(context).appBarTheme.backgroundColor!,
                          label: "Start the quizz",
                          onPressed: () {
                            setState(() {
                              startQuizz = true;
                            });
                          },
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}

class Body extends StatefulWidget {
  final quizzModel quizz;
  final String classID;
  final String moduleID;
  final String studentName;
  final String uid;
  Body(
      {super.key,
      required this.quizz,
      required this.classID,
      required this.moduleID,
      required this.studentName,
      required this.uid});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int? selectedAnswerIndex;
  int questionIndex = 0;
  int score = 0;

  void pickAnswer(int value) {
    selectedAnswerIndex = value;
    final question = widget.quizz.questions[questionIndex];
    if (selectedAnswerIndex == question.correctAnswerIndex) {
      score++;
    }
    setState(() {});
  }

  void goToNextQuestion() {
    if (questionIndex < widget.quizz.questions.length - 1) {
      questionIndex++;
      selectedAnswerIndex = null;
    }
    setState(() {});
  }

  void submitQuizz() async {
    var submission = quizzSubmission(
      id: '',
      studentName: widget.studentName,
      studentID: widget.uid,
      quizzName: widget.quizz.title,
      grade: (score / widget.quizz.questions.length * 100).round().toString(),
    );
    bool isSubmitted = await QuizzService().submitQuizz(
        submission, context, widget.classID, widget.moduleID, widget.quizz.id);
    if (isSubmitted) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => QuizzResultScreen(
            length: widget.quizz.questions.length,
            score: score,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Failed to submit the quizz"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final question = widget.quizz.questions[questionIndex];
    bool isLastQuestion = questionIndex == widget.quizz.questions.length - 1;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              question.question,
              style: const TextStyle(
                fontSize: 21,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(
                (question.answers as List).length,
                (index) {
                  final option = (question.answers as List)[index].toString();
                  if (option.isEmpty) {
                    return SizedBox.shrink();
                  }
                  return GestureDetector(
                    onTap: selectedAnswerIndex == null
                        ? () => pickAnswer(index)
                        : null,
                    child: QuizzAnswerCard(
                      currentIndex: index,
                      question: option,
                      isSelected: selectedAnswerIndex == index,
                      selectedAnswerIndex: selectedAnswerIndex,
                      correctAnswerIndex: question.correctAnswerIndex,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 20),
            // Next Button
            isLastQuestion
                ? MyButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).appBarTheme.backgroundColor!,
                    label: 'Finish',
                    onPressed: () => submitQuizz(),
                  )
                : MyButton(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    textColor: Theme.of(context).appBarTheme.backgroundColor!,
                    label: 'Next',
                    onPressed: () {
                      selectedAnswerIndex != null ? goToNextQuestion() : null;
                    },
                  ),
          ],
        ),
      ),
    );
  }
}

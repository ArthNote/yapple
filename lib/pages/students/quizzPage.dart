// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_cast

import 'package:flutter/material.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/pages/students/quizzResultScreen.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/QuizzAnswerCard.dart';

class QuizzPage extends StatefulWidget {
  QuizzPage({super.key, required this.name});
  final String name;

  @override
  State<QuizzPage> createState() => _QuizzPageState();
}

class _QuizzPageState extends State<QuizzPage> {
  bool startQuizz = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        centerTitle: true,
        title: Text(
          widget.name,
          style: TextStyle(fontSize: 17),
        ),
      ),
      body: startQuizz
          ? Body()
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
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).appBarTheme.backgroundColor!,
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
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  int? selectedAnswerIndex;
  int questionIndex = 0;
  int score = 0;

  void pickAnswer(int value) {
    selectedAnswerIndex = value;
    final question = questions[questionIndex];
    if (selectedAnswerIndex == question['correctAnswerIndex'] as int) {
      score++;
    }
    setState(() {});
  }

  void goToNextQuestion() {
    if (questionIndex < questions.length - 1) {
      questionIndex++;
      selectedAnswerIndex = null;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final question = questions[questionIndex];
    bool isLastQuestion = questionIndex == questions.length - 1;
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              question['question'].toString(),
              style: const TextStyle(
                fontSize: 21,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Column(
              children: List.generate(
                (question['options'] as List).length,
                (index) {
                  final option =
                      (question['options'] as List)[index].toString();
                  return GestureDetector(
                    onTap: selectedAnswerIndex == null
                        ? () => pickAnswer(index)
                        : null,
                    child: QuizzAnswerCard(
                      currentIndex: index,
                      question: option,
                      isSelected: selectedAnswerIndex == index,
                      selectedAnswerIndex: selectedAnswerIndex,
                      correctAnswerIndex: question['correctAnswerIndex'] as int,
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
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => QuizzResultScreen(
                            score: score,
                          ),
                        ),
                      );
                    },
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

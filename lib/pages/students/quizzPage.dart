// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:yapple/models/staticData.dart';
import 'package:yapple/widgets/MyButton.dart';

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
  int score = 0;
  int currentQs = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: (this.currentQs >= quizz.length)
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Score ${(100 * score / quizz.length).round()}%",
                      style: TextStyle(
                        fontSize: 25,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    ElevatedButton(
                      child: Icon(Icons.replay),
                      onPressed: () {
                        setState(() {
                          currentQs = 0;
                          score = 0;
                        });
                      },
                    )
                  ],
                ),
              )
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ListTile(
                      title: Center(
                        child: Text(
                          quizz[currentQs]['title'].toString() + " ?",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            color: Theme.of(context).colorScheme.tertiary,
                          ),
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Center(
                          child: Text(
                            'Question ${currentQs + 1}/${quizz.length}',
                            style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Column(
                      children: (quizz[currentQs]['answers']
                              as List<Map<String, Object>>)
                          .map<Widget>((answer) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(0, 15, 0, 0),
                          child: ListTile(
                            tileColor:
                                Theme.of(context).appBarTheme.backgroundColor,
                            title: Text(answer['answer'].toString()),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Theme.of(context).colorScheme.secondary,
                                width: 1,
                              ),
                            ),
                            onTap: () {
                              setState(() {
                                if (answer['correct'] as bool) {
                                  ++score;
                                }
                              });
                            },
                          ),
                        );
                      }).toList(),
                    ),
                    SizedBox(
                      height: 35,
                    ),
                    MyButton(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      textColor: Theme.of(context).appBarTheme.backgroundColor!,
                      label: 'Next',
                      onPressed: () {
                        setState(() {
                          ++currentQs;
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

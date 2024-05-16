// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:yapple/firebase/QuizzService.dart';
import 'package:yapple/models/quizzModel.dart';
import 'package:yapple/models/quizzSubmission.dart';
import 'package:yapple/pages/teachers/addQuizz.dart';
import 'package:yapple/widgets/MyTextField.dart';

class TeacherQuizzResults extends StatelessWidget {
  TeacherQuizzResults(
      {super.key,
      required this.quizz,
      required this.classID,
      required this.moduleID});
  final quizzModel quizz;
  final String classID;
  final String moduleID;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
            centerTitle: true,
            title: Text(
              quizz.title,
              style: TextStyle(fontSize: 17),
            ),
            bottom: TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                  text: "Quizz Details",
                ),
                Tab(
                  text: "Submissions",
                ),
              ],
            )),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: TabBarView(
            children: [
              DetailsTab(
                quizz: quizz,
                classID: classID,
                moduleID: moduleID,
              ),
              SubmissionsTab(
                quizz: quizz,
                classID: classID,
                moduleID: moduleID,
              )
            ],
          ),
        ),
      ),
    );
  }
}

class SubmissionsTab extends StatefulWidget {
  final quizzModel quizz;
  final String classID;
  final String moduleID;
  SubmissionsTab(
      {super.key,
      required this.quizz,
      required this.classID,
      required this.moduleID});

  @override
  State<SubmissionsTab> createState() => _BodyState();
}

class _BodyState extends State<SubmissionsTab> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<quizzSubmission>>(
      future: QuizzService().getQuizzeSubmissions(
          context, widget.classID, widget.moduleID, widget.quizz.id),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          List<quizzSubmission> submissions =
              snapshot.data as List<quizzSubmission>;
          return ListView(
            children: List.generate(submissions.length, (index) {
              var submission = submissions[index];
              return ListTile(
                tileColor: Theme.of(context).appBarTheme.backgroundColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                  side: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 1,
                  ),
                ),
                leading: CircleAvatar(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Text(
                    submission.studentName[0].toUpperCase(),
                    style: TextStyle(
                        color: Theme.of(context).appBarTheme.backgroundColor),
                  ),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 20),
                title: Text(
                  submission.studentName,
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
                subtitle: Text('Grade: ' + submission.grade + "/100"),
              );
            }),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text("Error${snapshot.error}"));
        }
        return Center(child: CircularProgressIndicator());
      },
    );
  }
}

class DetailsTab extends StatefulWidget {
  final quizzModel quizz;
  final String classID;
  final String moduleID;
  DetailsTab(
      {super.key,
      required this.quizz,
      required this.classID,
      required this.moduleID});

  @override
  State<DetailsTab> createState() => _DetailsTabState();
}

class _DetailsTabState extends State<DetailsTab> {
  TextEditingController titleController = TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = ('Title: ' + widget.quizz.title);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        MyTextField(
          myController: titleController,
          isPass: false,
          hintText: 'Enter Quizz Title',
          keyboardType: TextInputType.text,
          readOnly: true,
        ),
        SizedBox(height: 15),
        Expanded(
            child: ListView(
          children: List.generate(widget.quizz.questions.length, (index) {
            quizzQuestion question = widget.quizz.questions[index];
            final TextEditingController titleController =
                TextEditingController();
            final TextEditingController Controller1 = TextEditingController();
            final TextEditingController Controller2 = TextEditingController();
            final TextEditingController Controller3 = TextEditingController();
            final TextEditingController Controller4 = TextEditingController();
            final TextEditingController correctAnswerIndex =
                TextEditingController();
            titleController.text = ("Question: " + question.question) ?? '';
            Controller1.text =
                ('1- ' + (question.answers as List<dynamic>)[0].toString()) ??
                    '';
            Controller2.text =
                ('2- ' + (question.answers as List<dynamic>)[1].toString()) ??
                    '';
            Controller3.text =
                ('3- ' + (question.answers as List<dynamic>)[2].toString()) ??
                    '';
            Controller4.text =
                ('4- ' + (question.answers as List<dynamic>)[3].toString()) ??
                    '';
            correctAnswerIndex.text = ('Correct Answer Index: ' +
                    ((question.correctAnswerIndex) + 1).toString()) ??
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
                readOnly: true,
                correctIndexController: correctAnswerIndex,
              ),
            );
          }),
        )),
      ],
    );
  }
}

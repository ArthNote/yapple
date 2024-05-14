// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:yapple/firebase/FeedbackService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/feedbackModel.dart';
import 'package:yapple/widgets/MyButton.dart';
import 'package:yapple/widgets/MyTextField.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final currentUser = FirebaseAuth.instance.currentUser;
  String uid = "";
  @override
  void initState() {
    super.initState();
    if (currentUser != null) {
      uid = currentUser!.uid;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Send Feedback",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: FutureBuilder<feedbackSenderModel>(
        future: UserService().getFeedbackSenderData(uid, context),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            feedbackSenderModel user = snapshot.data as feedbackSenderModel;
            return SingleChildScrollView(
              child: Body(
                user: user,
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error${snapshot.error}"));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class Body extends StatelessWidget {
  Body({super.key, required this.user});
  final feedbackSenderModel user;

  TextEditingController titleController = TextEditingController();

  TextEditingController contentController = TextEditingController();

  void sendFeedback(BuildContext context) async {
    if (titleController.text.isNotEmpty && contentController.text.isNotEmpty) {
      feedbackModel feedback = feedbackModel(
          id: "",
          title: titleController.text,
          content: contentController.text,
          sender: user);
      bool isSent = await FeedbackService().sendFeedback(feedback, context);
      if (isSent) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Feedback sent successfully",
            textAlign: TextAlign.center,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ));
        titleController.clear();
        contentController.clear();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Please fill all fields",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          MyTextField(
            myController: titleController,
            isPass: false,
            hintText: 'Enter feedback title',
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 20),
          MyTextField(
            myController: contentController,
            isPass: false,
            hintText: 'Enter feedback content',
            keyboardType: TextInputType.multiline,
          ),
          SizedBox(height: 20),
          MyButton(
            backgroundColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).appBarTheme.backgroundColor!,
            label: 'Send Feedback',
            onPressed: () => sendFeedback(context),
          ),
        ],
      ),
    );
  }
}

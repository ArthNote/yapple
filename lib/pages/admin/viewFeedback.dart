// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:yapple/firebase/FeedbackService.dart';
import 'package:yapple/models/feedbackModel.dart';

class ViewFeedback extends StatelessWidget {
  const ViewFeedback({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        title: const Text(
          'View Feedbacks',
          style: TextStyle(fontSize: 17),
        ),
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  bool customIcon = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: FutureBuilder<List<feedbackModel>>(
          future: FeedbackService().getAllFeedback(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<feedbackModel> feedbacks =
                  snapshot.data! as List<feedbackModel>;
              if (feedbacks.isEmpty) {
                return Center(
                  child: Text('No feedbacks received'),
                );
              }
              return Expanded(
                child: ListView(
                  children: List.generate(feedbacks.length, (index) {
                    var feedback = feedbacks[index];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: ExpansionTile(
                        expandedCrossAxisAlignment: CrossAxisAlignment.start,
                        title: Text(
                          feedback.title,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w500),
                        ),
                        childrenPadding: EdgeInsets.fromLTRB(20, 0, 12, 15),
                        expandedAlignment: Alignment.centerLeft,
                        backgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
                        collapsedBackgroundColor:
                            Theme.of(context).appBarTheme.backgroundColor,
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
                          Text(
                            feedback.content,
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.tertiary),
                          ),
                          SizedBox(height: 20),
                          ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              feedback.sender.name,
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.tertiary),
                            ),
                            leading: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(feedback.sender.profilePicUrl),
                            ),
                          ),
                        ],
                        onExpansionChanged: (bool expanded) {
                          setState(() => customIcon = expanded);
                        },
                      ),
                    );
                  }),
                ),
              );
            } else if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

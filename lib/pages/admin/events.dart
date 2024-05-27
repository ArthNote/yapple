// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:yapple/firebase/AuthService.dart';
import 'package:yapple/firebase/EventService.dart';
import 'package:yapple/models/eventModel.dart';
import 'package:yapple/pages/admin/createEvent.dart';

class AdminEventsPage extends StatelessWidget {
  const AdminEventsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => AuthService().logout(context),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text('Events'),
      ),
      body: Body(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => CreateEvent()));
          },
          child: Icon(Icons.add)),
    );
  }
}

class Body extends StatefulWidget {
  const Body({super.key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: FutureBuilder<List<eventModel>>(
          future: EventService().getEvents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                List<eventModel> events = snapshot.data! as List<eventModel>;
                return Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10.0, horizontal: 20.0),
                    scrollDirection: Axis.vertical,
                    children: events
                        .map((event) => Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 20.0),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 200.0,
                                    child:ClipRRect(
                                    borderRadius: BorderRadius.circular(10.0),
                                    child: Image.network(
                                      event.imageUrl,
                                      fit: BoxFit.fill,
                                    ),
                                  ),
                                  ),
                                ),
                                Positioned(
                                  top: 10,
                                  right: 10,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.9),
                                      borderRadius: BorderRadius.circular(5.0),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.5),
                                          spreadRadius: 1,
                                          blurRadius: 2,
                                        ),
                                      ],
                                    ),
                                    child: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Theme.of(context)
                                          .appBarTheme
                                          .backgroundColor,
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor: Theme.of(context)
                                                  .appBarTheme
                                                  .backgroundColor!,
                                              surfaceTintColor:
                                                  Theme.of(context)
                                                      .appBarTheme
                                                      .backgroundColor!,
                                              title: Text('Delete Event'),
                                              content: Text(
                                                  'Are you sure you want to delete this event?'),
                                              actions: [
                                                TextButton(
                                                  child: Text('Cancel'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                TextButton(
                                                  child: Text('Delete'),
                                                  onPressed: () async {
                                                    EventService()
                                                        .deleteEvent(event.id);
                                                    setState(() {});
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ))
                        .toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Center(child: Text(snapshot.error.toString()));
              } else {
                return Center(child: Text("Something went wrong"));
              }
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

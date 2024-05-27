// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:yapple/firebase/SessionService.dart';
import 'package:yapple/firebase/UserService.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/models/sessionModel.dart';
import 'package:yapple/models/studentModel.dart';
import 'package:yapple/pages/admin/addSession.dart';
import 'package:yapple/pages/students/calendar.dart';
import 'package:yapple/pages/teachers/calendar.dart';
import 'package:yapple/widgets/ProfileDialog.dart';
import 'package:yapple/widgets/SearchField.dart';
import 'package:yapple/widgets/SessionCard.dart';
import 'package:yapple/widgets/StudentItem.dart';

class AdminModulePage extends StatefulWidget {
  const AdminModulePage({super.key, required this.module});
  final moduleModel module;

  @override
  State<AdminModulePage> createState() => _AdminModulePageState();
}

class _AdminModulePageState extends State<AdminModulePage>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(_handleTabIndex);
  }

  void _handleTabIndex() {
    setState(() {});
  }

  @override
  void dispose() {
    _tabController!.removeListener(_handleTabIndex);
    _tabController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            widget.module.name,
            style: TextStyle(fontSize: 17),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorSize: TabBarIndicatorSize.label,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: [
              Tab(
                text: "Details",
              ),
              Tab(
                text: "Sessions",
              ),
            ],
          )),
      floatingActionButton: _tabController!.index == 1
          ? FloatingActionButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return AddSession(module: widget.module);
                }));
              },
              child: Icon(Icons.add),
            )
          : null,
      body: TabBarView(
        controller: _tabController,
        children: [
          BodyDetails(
            module: widget.module,
          ),
          BodySessions(
            module: widget.module,
          ),
        ],
      ),
    );
  }
}

class BodyDetails extends StatelessWidget {
  const BodyDetails({super.key, required this.module});
  final moduleModel module;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            height: 200,
            child: Icon(
              module.icon,
              size: 80,
              color: Theme.of(context).appBarTheme.backgroundColor,
            ),
            decoration: BoxDecoration(
              color: module.color,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          SizedBox(height: 30),
          Text(
            module.name,
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Divider(
            color: Theme.of(context).colorScheme.tertiary,
            height: 1,
          ),
          SizedBox(
            height: 15,
          ),
          ListTile(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => ProfileDialog(
                  name: module.teacher.name,
                  email: module.teacher.email,
                  role: module.teacher.role,
                  profilePicUrl: module.teacher.profilePicUrl,
                  showButton: false,
                ),
              );
            },
            tileColor: Theme.of(context).colorScheme.secondary,
            contentPadding: EdgeInsets.symmetric(horizontal: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            leading: Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                color: Colors.blue,
                // Add this to make the container rectangular
                borderRadius: BorderRadius.all(Radius.circular(8)),
              ),
              child: module.teacher.profilePicUrl != 'null'
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        module.teacher.profilePicUrl,
                        fit: BoxFit.cover,
                      ),
                    )
                  : Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
            ),
            title: Text(
              module.teacher.name,
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
            ),
            subtitle: Text("Teacher"),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "About the module:",
            style: TextStyle(
              fontSize: 21,
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            module.about,
            textAlign: TextAlign.justify,
            style: TextStyle(color: Theme.of(context).colorScheme.tertiary),
          )
        ],
      ),
    );
  }
}

class BodySessions extends StatefulWidget {
  const BodySessions({super.key, required this.module});
  final moduleModel module;

  @override
  State<BodySessions> createState() => _BodySessionsState();
}

class _BodySessionsState extends State<BodySessions> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Padding(
        padding: EdgeInsets.all(20),
        child: FutureBuilder<List<sessionModel>>(
            future: SessionService()
                .getSessions(widget.module.id, widget.module.classID),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  List<sessionModel> sessions =
                      snapshot.data! as List<sessionModel>;
                  if (sessions.isEmpty) {
                    return Center(
                        child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.timelapse_sharp,
                          size: 50,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        SizedBox(height: 6),
                        Text("No sessions yet"),
                        SizedBox(height: 10),
                        Text("Add sessions to see them here")
                      ],
                    ));
                  }
                  return Expanded(
                    child: ListView(
                      children: sessions
                          .map((session) => GestureDetector(
                                onDoubleTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        backgroundColor: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor!,
                                        surfaceTintColor: Theme.of(context)
                                            .appBarTheme
                                            .backgroundColor!,
                                        title: Text('Delete Session'),
                                        content: Text(
                                            'Are you sure you want to delete this session?'),
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
                                              await SessionService()
                                                  .deleteSession(
                                                      widget.module.id,
                                                      widget.module.classID,
                                                      session.id);
                                              Navigator.of(context).pop();
                                              setState(() {});
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                                child: SessionCard(
                                  session: session,
                                  showDate: true,
                                ),
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
      ),
    );
  }
}

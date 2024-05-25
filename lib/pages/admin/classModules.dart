// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:yapple/firebase/ModuleService.dart';
import 'package:yapple/models/moduleModel.dart';
import 'package:yapple/pages/admin/addModule.dart';
import 'package:yapple/pages/students/courseDetails.dart';
import 'package:yapple/widgets/ModuleCardMD.dart';
import 'package:yapple/widgets/SearchField.dart';

class ClassModules extends StatelessWidget {
  const ClassModules({super.key, required this.classID});
  final String classID;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        appBar: AppBar(
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
          title: Text(
            'Modules',
            style: TextStyle(fontSize: 17),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AddModule(
                  classID: classID,
                ),
              ),
            );
          },
          child: Icon(Icons.add),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: Body(
          classID: classID,
        ));
  }
}

class Body extends StatefulWidget {
  const Body({super.key, required this.classID});
  final String classID;
  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController searchController = TextEditingController();
  List<moduleModel> foundModules = [];
  String searchTerm = "";

  Future<List<moduleModel>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final modules = await ModuleService().getModules(widget.classID);
    List<moduleModel> results = [];
    if (enteredKeyword.isEmpty) {
      return results = modules;
    } else {
      results = modules
          .where((module) =>
              module.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              module.category
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              module.code
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              module.teacher.name
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()))
          .toList();
    }
    return foundModules = results;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20.0),
      child: Column(
        children: [
          MySearchField(
            myController: searchController,
            hintText: "Search",
            icon: Icons.search,
            bgColor: Theme.of(context).appBarTheme.backgroundColor!,
            onchanged: (value) {
              setState(() {
                searchTerm = value;
              });
            },
          ),
          SizedBox(
            height: 20,
          ),
          //courses list
          FutureBuilder<List<moduleModel>>(
              future: runFilter(searchTerm),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<moduleModel> modules =
                        snapshot.data! as List<moduleModel>;

                    if (modules.isEmpty) {
                      return Center(
                          child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(height: 50),
                          Icon(
                            Icons.class_,
                            size: 50,
                            color: Theme.of(context).colorScheme.error,
                          ),
                          SizedBox(height: 6),
                          Text("No modules yet"),
                          SizedBox(height: 10),
                          Text("Add modules to see them here")
                        ],
                      ));
                    }
                    return Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        childAspectRatio: 0.78,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: 20,
                        children: List.generate(modules.length, (index) {
                          var module = modules[index];
                          return ModuleCardMD(
                            isStarred: false,
                            moduleName: module.name,
                            moduleCategory: module.category,
                            color: module.color,
                            icon: module.icon,
                            deleteIcon: Icons.delete,
                            onPressed: () {
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
                                    title: Text('Delete Module'),
                                    content: Text(
                                        'Are you sure you want to delete this module?'),
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
                                          await ModuleService().deleteModule(
                                              widget.classID, module.id);
                                          Navigator.of(context).pop();
                                          setState(() {});
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          );
                        }),
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
        ],
      ),
    );
  }
}

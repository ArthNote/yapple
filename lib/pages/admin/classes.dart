// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:yapple/firebase/AuthService.dart';
import 'package:yapple/firebase/ClassService.dart';
import 'package:yapple/models/classModel.dart';
import 'package:yapple/pages/admin/addClass.dart';
import 'package:yapple/pages/admin/classModules.dart';
import 'package:yapple/widgets/ClassCard.dart';
import 'package:yapple/widgets/ModuleCardSM.dart';
import 'package:yapple/widgets/SearchField.dart';

class AdminClassesPage extends StatelessWidget {
  const AdminClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => AuthService().logout(context),
          ),
        ],
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text('Classes'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddClass(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
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
  TextEditingController searchController = TextEditingController();
  String searchTerm = "";
  List<classModel> foundClasses = [];

  Future<List<classModel>> runFilter(String enteredKeyword) async {
    this.searchTerm = enteredKeyword;
    final classes = await ClassService().getClasses();
    List<classModel> results = [];
    if (enteredKeyword.isEmpty) {
      return results = classes;
    } else {
      results = classes
          .where((Class) =>
              Class.name.toLowerCase().contains(enteredKeyword.toLowerCase()) ||
              Class.major
                  .toLowerCase()
                  .contains(enteredKeyword.toLowerCase()) ||
              Class.year.toString().contains(enteredKeyword))
          .toList();
    }
    return foundClasses = results;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
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
          FutureBuilder<List<classModel>>(
              future: runFilter(searchTerm),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasData) {
                    List<classModel> classes =
                        snapshot.data! as List<classModel>;
                    return Expanded(
                      child: ListView(
                        children: List.generate(classes.length, (index) {
                          var Class = classes[index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ClassModules(classID: Class.id);
                              }));
                            },
                            child: ClassCard(
                                className: Class.name,
                                classMajor: Class.major,
                                classYear: Class.year,
                                onDelete: () async {
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
                                        title: Text('Delete Class'),
                                        content: Text(
                                            'Are you sure you want to delete this class?'),
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
                                              await ClassService()
                                                  .deleteClass(Class.id);
                                              setState(() {});
                                              Navigator.of(context).pop();
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                }),
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

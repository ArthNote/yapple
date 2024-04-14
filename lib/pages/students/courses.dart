import 'package:flutter/material.dart';
import 'package:yapple/widgets/MyDrawer.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        drawer: MyDrawer(),
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        appBar: AppBar(
          title: Text(
            'Courses',
            style: TextStyle(
              color: Theme.of(context).colorScheme.tertiary,
              fontWeight: FontWeight.w500,
              fontSize: 25,
            ),
          ),
          centerTitle: false,
          backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
          elevation: 0,
          automaticallyImplyLeading: true,
        ),
        body: Body(),
      ),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

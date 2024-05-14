// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:yapple/firebase/AuthService.dart';

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
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Events');
  }
}

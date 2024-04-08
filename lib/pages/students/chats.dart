// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Chats',
          style: TextStyle(
            color: Theme.of(context).colorScheme.tertiary,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.background,
        leading: Padding(
          padding: EdgeInsets.only(left: 10),
          child: Icon(
            Icons.star_half_sharp,
            color: Theme.of(context).colorScheme.tertiary,
            size: 35,
          ),
        ),
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
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(children: [
        Expanded(
          child: ListView.builder(
              padding: EdgeInsets.only(bottom: 8, top: 10),
              itemCount: 5,
              itemBuilder: (context, index) => (Container(
                    height: 50,
                    child: Text("data"),
                  ))),
        )
      ]),
    );
  }
}

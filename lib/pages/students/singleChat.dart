// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

class SingleChatPage extends StatelessWidget {
  const SingleChatPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        elevation: 0,
        bottom: PreferredSize(
            preferredSize: Size.fromHeight(1),
            child: Container(
              height: 1,
              color: Theme.of(context).colorScheme.primary,
            )),
        title: Text(
          'Spoofing',
        ),
        centerTitle: true,
      ),
      body: Body(),
    );
  }
}

class Body extends StatelessWidget {
  const Body({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(
        child: ListView.builder(
            itemCount: 20,
            itemBuilder: (context, index) => (Text('data $index'))),
      ),
      Padding(
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 20),
        child: Row(children: [
          Expanded(
            child: TextField(
              keyboardType: TextInputType.multiline,
              minLines: 1,
              maxLines: 100,
              controller: null,
              decoration: InputDecoration(
                labelStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 17,
                ),
                suffixIcon: IconButton(
                  onPressed: () => {},
                  icon: Icon(
                    Icons.send_rounded,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  iconSize: 30,
                  splashColor: Colors.blue,
                ),
                floatingLabelStyle: TextStyle(
                    color: Colors.blue,
                    fontSize: 22,
                    fontWeight: FontWeight.w400),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white, width: 1.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.blue,
                    width: 1.0,
                    style: BorderStyle.solid,
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                fillColor: Colors.white,
                filled: true,
                hintText: "Type your message",
              ),
            ),
          ),
        ]),
      )
    ]);
  }
}

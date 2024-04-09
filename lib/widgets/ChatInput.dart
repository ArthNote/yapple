// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class ChatInput extends StatelessWidget {
  const ChatInput({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
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
              ),
              floatingLabelStyle:
                  TextStyle(fontSize: 22, fontWeight: FontWeight.w400),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.white, width: 1.5),
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  width: 1.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              fillColor: Theme.of(context).appBarTheme.backgroundColor,
              filled: true,
              hintText: "Type your message...",
            ),
          ),
        ),
      ]),
    );
  }
}

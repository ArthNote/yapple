// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, sort_child_properties_last

import 'package:flutter/material.dart';

class ChatInput extends StatefulWidget {
  ChatInput({
    super.key,
    required this.controller,
  });

  TextEditingController controller;

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  bool isTyping = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, right: 10, left: 10),
      child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
                child: ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 100),
              child: Container(
                margin: EdgeInsets.only(bottom: 20),
                alignment: Alignment.center,
                height: 60,
                decoration: BoxDecoration(
                    color: Theme.of(context).appBarTheme.backgroundColor,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.secondary,
                      width: 1,
                    )),
                child: TextField(
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 100,
                  controller: widget.controller,
                  onChanged: (value) {
                    if (value.isNotEmpty || value != "") {
                      setState(() {
                        isTyping = true;
                      });
                    } else {
                      setState(() {
                        isTyping = false;
                      });
                    }
                  },
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.tertiary),
                  decoration: InputDecoration(
                    hintText: "Type your message",
                    hintStyle: TextStyle(
                        color: Theme.of(context).colorScheme.secondary),
                    border: InputBorder.none,
                    prefixIcon: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.emoji_emotions,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    suffixIcon: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        isTyping
                            ? SizedBox()
                            : Row(
                                children: [
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.camera_alt,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () {},
                                    icon: Icon(
                                      Icons.mic,
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                    ),
                                  ),
                                ],
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
            isTyping
                ? GestureDetector(
                    onTap: () {},
                    child: Container(
                      height: 60,
                      margin: EdgeInsets.only(bottom: 20, left: 8),
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(
                        Icons.send_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),
                  )
                : SizedBox()
          ]),
    );
  }
}

// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';

class ChatItem extends StatefulWidget {
  ChatItem(
      {super.key,
      required this.chatName,
      required this.last_msg,
      required this.time_sent,
      required this.runread_msg,
      required this.senderId,
      required this.receiverId});

  final String chatName;
  final String last_msg;
  final String time_sent;
  final int runread_msg;
  final String senderId;
  final String receiverId;

  @override
  State<ChatItem> createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            border: Border(
          bottom: BorderSide(
            width: 1,
            color: Colors.grey.shade300,
          ),
        )),
        padding: EdgeInsets.fromLTRB(15, 20, 15, 20),
        child: Row(children: [
          CircleAvatar(
            radius: 30,
            child: Icon(Icons.person),
            backgroundColor: Theme.of(context).colorScheme.secondary,
          ),
          SizedBox(
            width: 20,
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: EdgeInsets.all(5),
              child: Text(
                widget.chatName,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5),
              child: Row(
                children: [
                  //add the message delivered icon
                  Text(
                    widget.last_msg.length > 28
                        ? widget.last_msg.substring(0, 28) + "..."
                        : widget.last_msg,
                    style: TextStyle(
                      fontSize: 14,
                      color: Theme.of(context)
                          .colorScheme
                          .tertiary
                          .withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            )
          ]),
          Spacer(),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            SizedBox(
              height: 4,
            ),
            Text(widget.time_sent, style: TextStyle(fontSize: 14)),
            SizedBox(
              height: 8,
            ),
            widget.runread_msg > 0
                ? Container(
                    height: 24,
                    width: widget.runread_msg.toString().length > 2
                        ? widget.runread_msg.toString().length * 10
                        : 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Theme.of(context).colorScheme.primary),
                    child: Text(widget.runread_msg.toString(),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold)),
                  )
                : SizedBox()
          ])
        ]),
      ),
    );
  }
}

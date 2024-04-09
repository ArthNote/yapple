// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  ChatMessage(
      {super.key,
      required this.message,
      required this.byMe,
      required this.time_sent,
      required this.isRead,
      this.isGroup});
  final String message;
  final bool byMe;
  final String time_sent;
  final bool isRead;
  final bool? isGroup;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment:
            byMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
              child: Column(
            crossAxisAlignment:
                byMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      bottomRight:
                          byMe ? Radius.circular(0) : Radius.circular(24),
                      bottomLeft:
                          byMe ? Radius.circular(24) : Radius.circular(0),
                      topRight: Radius.circular(24)),
                  color: byMe
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).cardColor,
                ),
                child: Text(
                  message,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w500),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment:
                      byMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      time_sent,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.tertiary,
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    byMe
                        ? Icon(
                            Icons.done_all,
                            color: isRead
                                ? Colors.blue
                                : Theme.of(context)
                                    .colorScheme
                                    .tertiary
                                    .withOpacity(0.6),
                            size: 17,
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
}

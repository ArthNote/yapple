// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:yapple/models/chatParticipantModel.dart';
import 'package:yapple/widgets/ProfileDialog.dart';

class GroupMessage extends StatelessWidget {
  GroupMessage(
      {super.key,
      required this.message,
      required this.byMe,
      required this.time_sent,
      required this.isRead,
      required this.sender,
      required this.show});
  final String message;
  final chatParticipantModel sender;
  final bool byMe;
  final String time_sent;
  final bool isRead;
  final bool show;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        mainAxisAlignment:
            byMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          byMe
              ? SizedBox()
              : show
                  ? GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) => ProfileDialog(
                            name: sender.name,
                            email: sender.email,
                            role: sender.role,
                            profilePicUrl: sender.profilePicUrl,
                            showButton: false,
                          ),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: sender.profilePicUrl== 'null' ? CircleAvatar(
                          radius: 17,
                          child: Text(
                            sender.name.substring(0, 1).toUpperCase(),
                            style: TextStyle(fontSize: 16),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary,
                        ) : CircleAvatar(
                          radius: 17,
                          backgroundImage: NetworkImage(sender.profilePicUrl),
                        )
                      ),
                    )
                  : SizedBox(),
          Flexible(
              child: Column(
            crossAxisAlignment:
                byMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              byMe
                  ? SizedBox(
                      height: 0,
                    )
                  : show
                      ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: Row(
                            mainAxisAlignment: byMe
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                sender.name,
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.tertiary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        )
                      : SizedBox(),
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.65,
                ),
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.symmetric(
                  horizontal: byMe
                      ? 16
                      : show
                          ? 5
                          : 50,
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
                padding: EdgeInsets.symmetric(horizontal: show ? 5 : 50),
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

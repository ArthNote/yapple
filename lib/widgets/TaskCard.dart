// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

// ignore: must_be_immutable
class TaskCard extends StatefulWidget {
  TaskCard(
      {super.key,
      required this.title,
      required this.note,
      required this.startTime,
      required this.endTime,
      required this.isCompleted,
      required this.color,
      required this.onDone,
      required this.onDelete});
  final String title;
  final String note;
  final String startTime;
  final String endTime;
  bool isCompleted;
  final Color color;
  final void Function(BuildContext context) onDone;
  final void Function(BuildContext context) onDelete;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Slidable(
        startActionPane: ActionPane(
          motion: StretchMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => widget.onDelete(context),
              icon: Icons.delete,
              label: "Delete",
              foregroundColor: Colors.white,
              backgroundColor: Colors.red.shade400,
              borderRadius: BorderRadius.circular(16),
            )
          ],
        ),
        endActionPane: ActionPane(motion: BehindMotion(), children: [
          SlidableAction(
            onPressed: (context) => widget.onDone(context),
            icon: !widget.isCompleted
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            backgroundColor: Colors.green.shade400,
            label: widget.isCompleted ? "Mark as not Done" : "Done",
            foregroundColor: Colors.white,
            borderRadius: BorderRadius.circular(16),
          )
        ]),
        child: Container(
          padding: EdgeInsets.all(16),
          //  width: SizeConfig.screenWidth * 0.78,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: widget.color,
          ),
          child: Row(children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.title,
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(36, 36, 36, 1)),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        color: Color.fromRGBO(36, 36, 36, 1),
                        size: 18,
                      ),
                      SizedBox(width: 4),
                      Text(
                        widget.startTime + " - " + widget.endTime,
                        style: TextStyle(
                            fontSize: 13, color: Color.fromRGBO(36, 36, 36, 1)),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.note,
                    style: TextStyle(
                        fontSize: 15, color: Color.fromRGBO(36, 36, 36, 1)),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              height: 60,
              width: 1,
              color: Colors.grey[200]!.withOpacity(0.7),
            ),
            RotatedBox(
              quarterTurns: 3,
              child: Text(
                widget.isCompleted ? "COMPLETED" : "TODO",
                style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color.fromRGBO(23, 23, 23, 1)),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:yapple/models/sessionModel.dart';

class SessionCard extends StatelessWidget {
  const SessionCard({Key? key, this.session, this.showDate}) : super(key: key);
  final sessionModel? session;
  final bool? showDate;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      margin: EdgeInsets.only(bottom: 12),
      //  width: SizeConfig.screenWidth * 0.78,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Theme.of(context).colorScheme.secondary,
      ),
      child: Row(children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                session?.moduleName ?? 'Module Name',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.tertiary),
              ),
              SizedBox(
                height: 12,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.access_time_rounded,
                    color: Theme.of(context).colorScheme.tertiary,
                    size: 18,
                  ),
                  SizedBox(width: 4),
                  Text(
                    (session?.startTime ?? 'Time') +
                        ' - ' +
                        (session?.endTime ?? 'Time'),
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                showDate != null
                    ? showDate!
                        ? (DateFormat('EEEE dd MMMM yyyy')
                                .format(session?.date ?? DateTime.now()) ??
                            'session date')
                        : session?.teacherName ?? 'teacher name'
                    : 'teacher name',
                style: TextStyle(
                    fontSize: 15,
                    color: Theme.of(context).colorScheme.tertiary),
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
            'SESSION',
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.tertiary),
          ),
        ),
      ]),
    );
  }
}

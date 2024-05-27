// ignore_for_file: prefer_const_constructors, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:yapple/firebase/SessionService.dart';
import 'package:yapple/models/sessionModel.dart';
import 'package:yapple/pages/teachers/markAttendance.dart';
import 'package:yapple/widgets/SessionCard.dart';

class calendarPage extends StatelessWidget {
  const calendarPage({Key? key, required this.uid});
  final String uid;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        surfaceTintColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          "Calendar",
          style: TextStyle(fontSize: 18),
        ),
      ),
      body: Body(
        uid: uid,
      ),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key, required this.uid});
  final String uid;

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<sessionModel> _selectedSessions = [];

  Map<DateTime, List<sessionModel>> sessions = {};

  void getSessions() async {
    var ss = await SessionService().getTeacherSessions(widget.uid);
    for (var session in ss) {
      DateTime sessionDate = session.date;
      if (sessions[DateTime.utc(
              sessionDate.year, sessionDate.month, sessionDate.day)] ==
          null) {
        setState(() {
          sessions[DateTime.utc(
              sessionDate.year, sessionDate.month, sessionDate.day)] = [];
          sessions[DateTime.utc(
                  sessionDate.year, sessionDate.month, sessionDate.day)]!
              .add(session);
        });
      } else {
        setState(() {
          sessions[DateTime.utc(
                  sessionDate.year, sessionDate.month, sessionDate.day)]!
              .add(session);
        });
      }
    }
    print(sessions.entries
        .map((e) => e.value.map((e) => e.toJson()).toList())
        .toList());
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getSessions();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {
          getSessions();
        });
      },
      child: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: _onDaySelected,
            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() {
                _calendarFormat = format;
              });
            },
            eventLoader: _getSessionsForDay,
            calendarStyle: CalendarStyle(
              markersMaxCount: 1,
              markerDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.tertiary,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(
                color: Theme.of(context).colorScheme.tertiary,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: HeaderStyle(
              titleCentered: false,
              formatButtonVisible: true,
              formatButtonShowsNext: false,
              formatButtonDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                borderRadius: BorderRadius.circular(16),
              ),
              headerMargin: EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).appBarTheme.backgroundColor,
              ),
            ),
          ),
          if (_selectedSessions.isNotEmpty) ...[
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: _selectedSessions
                    .map((session) => GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        MarkAttendance(session: session)));
                          },
                          child: SessionCard(
                            session: session,
                            showDate: false,
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedSessions =
            _getSessionsForDay(selectedDay); // Update selected events
      });
    }
  }

  List<sessionModel> _getSessionsForDay(DateTime day) {
    return sessions[day] ?? [];
  }
}

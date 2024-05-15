// ignore_for_file: prefer_const_constructors, prefer_adjacent_string_concatenation, prefer_interpolation_to_compose_strings, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class calendarPage extends StatelessWidget {
  const calendarPage({Key? key});

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
      body: Body(),
    );
  }
}

class Body extends StatefulWidget {
  const Body({Key? key});

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.week;
  List<Event> _selectedEvents = []; // Initialize selected events list

  // Define events map
  final Map<DateTime, List<Event>> events = {
    DateTime.utc(2024, 5, 15): [
      Event('Meeting with John'),
      Event('Lunch with Sarah'),
    ],
    DateTime.utc(2022, 5, 15): [
      Event('Project deadline'),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16), // FORMAT: YYYY/MM/DD
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
          eventLoader: _getEventsForDay,
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
        if (_selectedEvents.isNotEmpty) ...[
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: _selectedEvents.map((event) => EventCard()).toList(),
            ),
          ),
        ],
      ],
    );
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _focusedDay = focusedDay;
        _selectedDay = selectedDay;
        _selectedEvents =
            _getEventsForDay(selectedDay); // Update selected events
      });
    }
  }

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }
}

class Event {
  final String title;

  Event(this.title);
}

class EventCard extends StatelessWidget {
  const EventCard({Key? key}) : super(key: key);

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
                'Event Title',
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
                    '11:26 AM' + " - " + '12:26 PM',
                    style: TextStyle(
                        fontSize: 13,
                        color: Theme.of(context).colorScheme.tertiary),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Text(
                'Event Note',
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

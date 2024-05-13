import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class calendarPage extends StatelessWidget {
  const calendarPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
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
  CalendarFormat _calendarFormat = CalendarFormat.month;
  List<Event> _selectedEvents = []; // Initialize selected events list

  // Define events map
  final Map<DateTime, List<Event>> events = {
    DateTime.utc(2024, 5, 12): [
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
            titleCentered: true,
            formatButtonVisible: false, // Disable the default format button
          ),
        ),
        if (_selectedEvents.isNotEmpty) ...[
          SizedBox(height: 20),
          Column(
            children: _selectedEvents.map((event) => EventCard(event: event)).toList(),
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
        _selectedEvents = _getEventsForDay(selectedDay); // Update selected events
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
  final Event event;

  const EventCard({Key? key, required this.event}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      child: Card(
        color: Theme.of(context).colorScheme.primary,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          title: Text(
            event.title,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          onTap: () {
            // Handle event tap
          },
        ),
      ),
    );
  }
}
// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unused_local_variable

import 'package:carbon_footprint/NavigationSidebar.dart';
import 'package:carbon_footprint/constants.dart';
import 'package:carbon_footprint/pages/ExampleStrucutre/widgets/useful_tile.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class MobileCalanderPage extends StatefulWidget {
  const MobileCalanderPage({Key? key}) : super(key: key);

  @override
  State<MobileCalanderPage> createState() => _MobileScaffCalander();
}

class Event extends Appointment {
  Event({
    required DateTime startTime,
    required DateTime endTime,
    required String subject,
    required Color color,
  }) : super(
          startTime: startTime,
          endTime: endTime,
          subject: subject,
          color: color,
        );
}

class EventDataSource extends CalendarDataSource {
  EventDataSource(List<Event> source) {
    appointments = source;
  }
}

class _MobileScaffCalander extends State<MobileCalanderPage> {
  List<Event> weeklyEvents = [
    Event(
      startTime: DateTime.now(),
      endTime: DateTime.now().add(Duration(hours: 2)),
      subject: 'Meeting',
      color: Colors.blue,
    ),
    Event(
      startTime: DateTime.now().add(Duration(days: 1)),
      endTime: DateTime.now().add(Duration(days: 1, hours: 2)),
      subject: 'Workshop',
      color: Colors.red,
    ),
    Event(
      startTime: DateTime.now().add(Duration(days: 2)),
      endTime: DateTime.now().add(Duration(days: 2, hours: 1)),
      subject: 'Team Lunch',
      color: Colors.green,
    ),
    Event(
      startTime: DateTime.now().add(Duration(days: 3)),
      endTime: DateTime.now().add(Duration(days: 3, hours: 3)),
      subject: 'Project Review',
      color: Colors.purple,
    ),
    Event(
      startTime: DateTime.now().add(Duration(days: 4)),
      endTime: DateTime.now().add(Duration(days: 4, hours: 2)),
      subject: 'Client Meeting',
      color: Colors.orange,
    ),
    Event(
      startTime: DateTime.now().add(Duration(days: 5)),
      endTime: DateTime.now().add(Duration(days: 5, hours: 2)),
      subject: 'Brainstorming Session',
      color: Colors.pink,
    ),
    Event(
      startTime: DateTime.now().add(Duration(days: 6)),
      endTime: DateTime.now().add(Duration(days: 6, hours: 2)),
      subject: 'Weekly Wrap-up',
      color: Colors.teal,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final EventDataSource eventDataSource = EventDataSource(weeklyEvents);

    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: rootAppbar,
      drawer: CustomDrawer(),
      body: Container(
        height: 600,
        child: Column(children: [
          Expanded(
            child: SfCalendar(
              view: CalendarView.week,
              dataSource: eventDataSource,
            ),
          ),
        ]),
      ),
    );
  }
}

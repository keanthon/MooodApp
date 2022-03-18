import 'dart:collection';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../components/post_card.dart';

class CalendarScreen extends StatefulWidget {
  final String uid;

  const CalendarScreen({Key? key, required this.uid}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late LinkedHashMap<DateTime, List<Widget>> events;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  late DateTime _selectedDay;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    events = LinkedHashMap(equals: isSameDay, hashCode: getHashCode);
    getlist();

    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  Future<void> getlist() async {
    QuerySnapshot snapshots = await FirebaseFirestore.instance
        .collection('userfeed')
        .doc(widget.uid)
        .collection('posts')
        .get();

    for (var doc in snapshots.docs) {
      var snap = doc.data() as Map<String, dynamic>;
      // print(snap);
      if (!events.containsKey(snap["date"].toDate())) {
        events[snap["date"].toDate()] = [PostCard(snap: snap)];
      } else {
        events[snap["date"].toDate()]?.add(PostCard(snap: snap));
      }
    }

  }

  List<Widget> _getEventsForDay(DateTime day) {
    if (events[day] == null) {
      return [Text("No posts on this day")];
    }
    return events[day]!;
  }

  int getHashCode(DateTime key) {
    return key.day * 1000000 + key.month * 10000 + key.year;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          firstDay: DateTime.utc(2010, 10, 16),
          lastDay: DateTime.now(),
          focusedDay: _focusedDay,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay; // update `_focusedDay` here as well
            });
          },
          calendarFormat: _calendarFormat,
          startingDayOfWeek: StartingDayOfWeek.monday,
          calendarStyle: CalendarStyle(
            // Use `CalendarStyle` to customize the UI
            outsideDaysVisible: false,
          ),
          onFormatChanged: (format) {
            // if (_calendarFormat != format) {
            //   setState(() {
            //     _calendarFormat = format;
            //   });
            // }
          },
          onPageChanged: (focusedDay) {
            _focusedDay = focusedDay;
          },
        ),
        const SizedBox(height: 8.0),
        SingleChildScrollView(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: _getEventsForDay(_selectedDay).length,
            itemBuilder: (BuildContext context, int index) {
              return  _getEventsForDay(_selectedDay)[index];
            },
          ),
        ),
      ],
    );
  }
}

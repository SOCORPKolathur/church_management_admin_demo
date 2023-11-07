import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter/material.dart';

class EventCal extends StatefulWidget {
  const EventCal({super.key});

  @override
  State<EventCal> createState() => _EventCalState();
}

class _EventCalState extends State<EventCal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          width: 500,
          height: 500,
          child: SfCalendar(
            view: CalendarView.month,
            allowDragAndDrop: true,
            dataSource: MeetingDataSource(_getDataSource()),
            monthViewSettings: MonthViewSettings(showAgenda: true),
          ),
        ));
  }
  List<Meeting> _getDataSource() {
    final List<Meeting> meetings = <Meeting>[];
    final DateTime today = DateTime.now();
    final DateTime startTime = DateTime(today.year, today.month, today.day, 9);
    final DateTime startTime2 = today.add(const Duration(days: 5));
    final DateTime endTime = startTime.add(const Duration(hours: 2));
    final DateTime endTime2 = today.add( Duration(days: 5,hours: 8));
    meetings.add(Meeting(
        'Holiday', startTime, endTime, const Color(0xFF0F8644), false));
    meetings.add(Meeting(
        'Debavali', startTime2, endTime2, const Color(0xFF0F8644), false));

    print(meetings);
    return meetings;
  }
}
class MeetingDataSource extends CalendarDataSource {
  /// Creates a meeting data source, which used to set the appointment
  /// collection to the calendar
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return _getMeetingData(index).from;
  }

  @override
  DateTime getEndTime(int index) {
    return _getMeetingData(index).to;
  }

  @override
  String getSubject(int index) {
    return _getMeetingData(index).eventName;
  }

  @override
  Color getColor(int index) {
    return _getMeetingData(index).background;
  }

  @override
  bool isAllDay(int index) {
    return _getMeetingData(index).isAllDay;
  }

  Meeting _getMeetingData(int index) {
    final dynamic meeting = appointments![index];
    late final Meeting meetingData;
    if (meeting is Meeting) {
      meetingData = meeting;
    }

    return meetingData;
  }
}

/// Custom business object class which contains properties to hold the detailed
/// information about the event data which will be rendered in calendar.
class Meeting {
  /// Creates a meeting class with required details.
  Meeting(this.eventName, this.from, this.to, this.background, this.isAllDay);

  /// Event name which is equivalent to subject property of [Appointment].
  String eventName;

  /// From which is equivalent to start time property of [Appointment].
  DateTime from;

  /// To which is equivalent to end time property of [Appointment].
  DateTime to;

  /// Background which is equivalent to color property of [Appointment].
  Color background;

  /// IsAllDay which is equivalent to isAllDay property of [Appointment].
  bool isAllDay;
}
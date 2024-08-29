import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:calenderapp/database/hive_database.dart';
import 'package:calenderapp/model/event_model.dart';

class HomeController with ChangeNotifier {
  final HiveDatabase hiveDatabase = HiveDatabase();
  List<EventModel> _events = [];
  
  List<EventModel> get events => _events;

  Future<void> loadEvents() async {
    final eventModel = await hiveDatabase.getAllEvents();
    _events = eventModel;
    notifyListeners();
  }

  Future<void> addEvent(
    String title, DateTime startTime, DateTime endTime, String repeatOption) async {
    
    const Color dayColor = Colors.blue;
    const Color weekColor = Colors.orange;
    const Color biweekColor = Colors.pink;
    const Color monthColor = Colors.red;

    List<EventModel> newEvents = [];

    switch (repeatOption) {
      case 'Daily':
        for (int i = 0; i < 365; i++) {
          final DateTime eventDate = startTime.add(Duration(days: i));
          newEvents.add(EventModel(
              eventName: title,
              from: eventDate,
              to: eventDate.add(Duration(hours: endTime.hour - startTime.hour)),
              background: dayColor,
              isAllDay: false,
              repeatOption: repeatOption));
        }
        break;

      case 'Weekly':
        for (int i = 0; i < 52; i++) {
          final DateTime eventDate = startTime.add(Duration(days: 7 * i));
          newEvents.add(EventModel(
              eventName: title,
              from: eventDate,
              to: eventDate.add(Duration(hours: endTime.hour - startTime.hour)),
              background: weekColor,
              isAllDay: false,
              repeatOption: repeatOption));
        }
        break;

      case 'Bi-Weekly':
        for (int i = 0; i < 26; i++) {
          final DateTime eventDate = startTime.add(Duration(days: 14 * i));
          newEvents.add(EventModel(
              eventName: title,
              from: eventDate,
              to: eventDate.add(Duration(hours: endTime.hour - startTime.hour)),
              background: biweekColor,
              isAllDay: false,
              repeatOption: repeatOption));
        }
        break;

      case 'Monthly':
        for (int i = 0; i < 12; i++) {
          final DateTime eventDate =
              DateTime(startTime.year, startTime.month + i, startTime.day);
          newEvents.add(EventModel(
              eventName: title,
              from: eventDate,
              to: eventDate.add(Duration(hours: endTime.hour - startTime.hour)),
              background: monthColor,
              isAllDay: false,
              repeatOption: repeatOption));
        }
        break;
    }

    _events.addAll(newEvents);
    notifyListeners();
    for (var event in newEvents) {
      await hiveDatabase.addEvent(event);
    }
  }
    Future<void> deleteAllEvents() async {
    try {
      await hiveDatabase.deleteAllEvents();
      _events.clear();
      notifyListeners();
      log('All events deleted successfully');
    } catch (e) {
      log('Error deleting events: $e');
    }
  }
}

import 'dart:developer';

import 'package:calenderapp/model/event_model.dart';
import 'package:hive_flutter/adapters.dart';

class HiveDatabase {
  Future<void> addEvent(EventModel value) async {
    try {
      final eventDb = await Hive.openBox<EventModel>('event_db');
      await eventDb.add(value);
    } catch (e) {
      log('Error adding event: $e');
    }
  }

  Future<List<EventModel>> getAllEvents() async {
    try {
      final eventDb = await Hive.openBox<EventModel>('event_db');
      final events = eventDb.values.toList();
      return events.cast<EventModel>();
    } catch (e) {
      return [];
    }
  }
    Future<void> deleteAllEvents() async {
    try {
      final eventDb = await Hive.openBox<EventModel>('event_db');
      await eventDb.clear();
      await eventDb.close();
    } catch (e) {
      log('Error deleting event: $e');
    }
  }
}


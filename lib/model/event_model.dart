import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'event_model.g.dart'; 

@HiveType(typeId: 0)
class EventModel extends HiveObject {
  @HiveField(0)
  final String eventName;

  @HiveField(1)
  final DateTime from;

  @HiveField(2)
  final DateTime to;

  @HiveField(3)
  final Color background;

  @HiveField(4)
  final bool isAllDay;

  @HiveField(5)
  final String repeatOption;

  EventModel({
    required this.eventName,
    required this.from,
    required this.to,
    required this.background,
    required this.isAllDay,
    required this.repeatOption,
  });
}


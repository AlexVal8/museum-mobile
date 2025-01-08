import 'dart:io';

class EventManager {
  static final EventManager _instance = EventManager._internal();

  factory EventManager() => _instance;

  EventManager._internal();

  final List<Map<String, dynamic>> events = [];
}

final eventManager = EventManager();

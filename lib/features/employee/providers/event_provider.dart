import 'package:flutter/foundation.dart';
import '../services/event_service.dart';
import '../../../data/models/event.dart';

class EventProvider with ChangeNotifier {
  final EventService _service = EventService();
  Map<DateTime, List<Event>> _events = {};
  bool _loading = false;

  Map<DateTime, List<Event>> get events => _events;
  bool get loading => _loading;

  Future<void> loadEvents({DateTime? start, DateTime? end}) async {
    _loading = true;
    notifyListeners();

    try {
      final events = await _service.getEvents(start: start, end: end);
      _events = _groupEventsByDate(events);
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> createEvent(Map<String, dynamic> data) async {
    try {
      final event = await _service.createEvent(data);
      final date = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      _events[date] = [...(_events[date] ?? []), event];
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateEvent(int id, Map<String, dynamic> data) async {
    try {
      await _service.updateEvent(id, data);
      await loadEvents(); // Reload to get updated data
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteEvent(int id) async {
    try {
      await _service.deleteEvent(id);
      // Remove event from local state
      _events.forEach((date, events) {
        events.removeWhere((e) => e.id == id);
        if (events.isEmpty) {
          _events.remove(date);
        }
      });
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Map<DateTime, List<Event>> _groupEventsByDate(List<Event> events) {
    final grouped = <DateTime, List<Event>>{};
    for (final event in events) {
      final date = DateTime(
        event.startTime.year,
        event.startTime.month,
        event.startTime.day,
      );
      grouped[date] = [...(grouped[date] ?? []), event];
    }
    return grouped;
  }
}
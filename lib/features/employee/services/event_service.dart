import '../../../core/services/api_service.dart';
import '../../../data/models/event.dart';

class EventService {
  final ApiService _api = ApiService();

  Future<List<Event>> getEvents({DateTime? start, DateTime? end}) async {
    try {
      final queryParams = {
        if (start != null) 'startDate': start.toIso8601String(),
        if (end != null) 'endDate': end.toIso8601String(),
      };
      
      final response = await _api.get(
        '/events',
        queryParameters: queryParams,
      );
      return (response.data as List)
          .map((json) => Event.fromJson(json))
          .toList();
    } catch (e) {
      throw 'Failed to fetch events';
    }
  }

  Future<Event> createEvent(Map<String, dynamic> data) async {
    try {
      final response = await _api.post('/events', data);
      return Event.fromJson(response.data);
    } catch (e) {
      throw 'Failed to create event';
    }
  }

  Future<void> updateEvent(int id, Map<String, dynamic> data) async {
    try {
      await _api.put('/events/$id', data);
    } catch (e) {
      throw 'Failed to update event';
    }
  }

  Future<void> deleteEvent(int id) async {
    try {
      await _api.delete('/events/$id');
    } catch (e) {
      throw 'Failed to delete event';
    }
  }
}
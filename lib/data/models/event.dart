import 'user.dart';

class Event {
  final int id;
  final String title;
  final String description;
  final DateTime startTime;
  final DateTime endTime;
  final String type;
  final String location;
  final User organizer;
  final List<User> participants;
  final bool isAllDay;

  Event({
    required this.id,
    required this.title,
    required this.description,
    required this.startTime,
    required this.endTime,
    required this.type,
    required this.location,
    required this.organizer,
    required this.participants,
    required this.isAllDay,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      startTime: DateTime.parse(json['startTime']),
      endTime: DateTime.parse(json['endTime']),
      type: json['type'],
      location: json['location'],
      organizer: User.fromJson(json['organizer']),
      participants: (json['participants'] as List?)
          ?.map((p) => User.fromJson(p))
          .toList() ?? [],
      isAllDay: json['isAllDay'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime.toIso8601String(),
      'type': type,
      'location': location,
      'organizerId': organizer.id,
      'participantIds': participants.map((p) => p.id).toList(),
      'isAllDay': isAllDay,
    };
  }
}
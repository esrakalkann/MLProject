import 'package:uuid/uuid.dart';

class Task {
  final String id;
  String title;
  DateTime? dueDate;
  DateTime? reminderTime;
  bool isCompleted;  // Removed final to make it mutable
  String? location;
  double? locationLat;
  double? locationLng;
  String? notes;
  List<String> tags;
  Priority priority;

  Task({
    String? id,
    required this.title,
    this.dueDate,
    this.reminderTime,
    this.isCompleted = false,
    this.location,
    this.locationLat,
    this.locationLng,
    this.notes,
    List<String>? tags,
    this.priority = Priority.medium,
  }) : id = id ?? const Uuid().v4(),
       tags = tags ?? [];

  // Convert task to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'dueDate': dueDate?.toIso8601String(),
      'reminderTime': reminderTime?.toIso8601String(),
      'isCompleted': isCompleted,
      'location': location,
      'locationLat': locationLat,
      'locationLng': locationLng,
      'notes': notes,
      'tags': tags,
      'priority': priority.toString(),
    };
  }

  // Create task from JSON
  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      reminderTime: json['reminderTime'] != null ? DateTime.parse(json['reminderTime']) : null,
      isCompleted: json['isCompleted'] ?? false,
      location: json['location'],
      locationLat: json['locationLat'],
      locationLng: json['locationLng'],
      notes: json['notes'],
      tags: List<String>.from(json['tags'] ?? []),
      priority: Priority.values.firstWhere(
        (e) => e.toString() == json['priority'],
        orElse: () => Priority.medium,
      ),
    );
  }

  get proximityThreshold => null;
}

enum Priority { low, medium, high }
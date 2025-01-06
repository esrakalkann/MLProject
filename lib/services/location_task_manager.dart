import 'package:geolocator/geolocator.dart';
import '../services/notification_service.dart';
import '../models/task_model.dart';

class LocationTaskManager {
  static const double defaultProximityThreshold = 500; // Default radius in meters
  static Stream<Position>? _positionStream;

  /// Checks all tasks and triggers notifications for nearby tasks
  static void checkLocationBasedTasks(
    Position position,
    List<Task> tasks, {
    bool debug = false,
  }) {
    for (final task in tasks) {
      if (!task.isCompleted &&
          task.locationLat != null &&
          task.locationLng != null) {
        // Calculate distance
        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          task.locationLat!,
          task.locationLng!,
        );

        // Proximity threshold
        final proximityThreshold = task.proximityThreshold ?? defaultProximityThreshold;

        if (debug) {
          print("Task: ${task.title}, Distance: $distance meters");
        }

        // Trigger notification if within proximity
        if (distance <= proximityThreshold) {
          NotificationService.showLocationBasedNotification(
            title: 'Nearby Task Reminder',
            body: 'You\'re near the location for: ${task.title}',
          );
        }
      }
    }
  }

  /// Starts location tracking to monitor tasks
  static Future<void> startLocationTracking(
    List<Task> tasks, {
    bool debug = false,
  }) async {
    // Define location settings
    final LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 100, // Update location every 100 meters
    );

    // Initialize stream
    _positionStream = Geolocator.getPositionStream(locationSettings: locationSettings);

    if (debug) {
      print("Location tracking started...");
    }

    // Listen to position updates
    _positionStream?.listen(
      (Position position) {
        if (debug) {
          print("Current Position: ${position.latitude}, ${position.longitude}");
        }
        checkLocationBasedTasks(position, tasks, debug: debug);
      },
      onError: (error) {
        if (debug) {
          print("Error in location stream: $error");
        }
      },
    );
  }

  /// Stops location tracking
  static void stopLocationTracking({bool debug = false}) {
    if (_positionStream != null) {
      if (debug) {
        print("Location tracking stopped.");
      }
      _positionStream = null;
    }
  }
}
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService with ChangeNotifier {
  Position? _currentPosition;

  /// Public method to get the current location
  Future<Position> getCurrentLocation() async {
    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception("Location services are disabled.");
    }

    // Check and request location permissions
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception("Location permissions are denied.");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        "Location permissions are permanently denied. Please enable them in settings.",
      );
    }
    if (permission == LocationPermission.whileInUse || 
      permission == LocationPermission.always) {
      print("Location permission granted.");
    }

    // Get the current location
    try {
      _currentPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      notifyListeners(); // Notify listeners if using ChangeNotifier
      return _currentPosition!;
    } catch (e) {
      throw Exception("Error retrieving location: $e");
    }
  }
}
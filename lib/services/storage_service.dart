import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class StorageService {
  static const String _tasksKey = 'tasks';
  static const String _settingsKey = 'settings';

  /// Save a list of tasks to local storage
  Future<void> saveTasks(List<Map<String, dynamic>> tasks) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTasks = json.encode(tasks);
    print('Saving tasks: $encodedTasks');
    await prefs.setString(_tasksKey, encodedTasks);
  }

  /// Retrieve a list of tasks from local storage
  Future<List<Map<String, dynamic>>> loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final tasksString = prefs.getString(_tasksKey);
    print('Loaded tasks string: $tasksString'); // Debug
    if (tasksString != null) {
      final List<dynamic> decodedTasks = json.decode(tasksString);
      return List<Map<String, dynamic>>.from(decodedTasks);
    }
    return [];
  }

  /// Save user settings to local storage
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    final prefs = await SharedPreferences.getInstance();
    final encodedSettings = json.encode(settings);
    await prefs.setString(_settingsKey, encodedSettings);
  }

  /// Retrieve user settings from local storage
  Future<Map<String, dynamic>> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsString = prefs.getString(_settingsKey);
    if (settingsString != null) {
      return Map<String, dynamic>.from(json.decode(settingsString));
    }
    return {};
  }

  /// Clear all saved data
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/task_model.dart';

class TaskProvider with ChangeNotifier {
  List<Task> _tasks = [];
  final SharedPreferences _prefs;

  TaskProvider(this._prefs) {
    _loadTasks();
  }

  List<Task> get tasks => _tasks;
  
  List<Task> get incompleteTasks => _tasks.where((task) => !task.isCompleted).toList();
  
  List<Task> get completedTasks => _tasks.where((task) => task.isCompleted).toList();

  List<Task> getTasksForDate(DateTime date) {
    return _tasks.where((task) => 
      task.dueDate != null && 
      task.dueDate!.year == date.year &&
      task.dueDate!.month == date.month &&
      task.dueDate!.day == date.day
    ).toList();
  }

  Future<void> addTask(Task task) async {
    _tasks.add(task);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> updateTask(Task task) async {
    final index = _tasks.indexWhere((t) => t.id == task.id);
    if (index != -1) {
      _tasks[index] = task;
      await _saveTasks();
      notifyListeners();
    }
  }

  Future<void> deleteTask(String id) async {
    _tasks.removeWhere((task) => task.id == id);
    await _saveTasks();
    notifyListeners();
  }

  Future<void> toggleTaskCompletion(String id) async {
    final index = _tasks.indexWhere((task) => task.id == id);
    if (index != -1) {
      _tasks[index].isCompleted = !_tasks[index].isCompleted;
      await _saveTasks();
      notifyListeners();
    }
  }

  Future<void> _loadTasks() async {
    final tasksJson = _prefs.getString('tasks');
    if (tasksJson != null) {
      final tasksList = json.decode(tasksJson) as List;
      _tasks = tasksList.map((task) => Task.fromJson(task)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveTasks() async {
    final tasksJson = json.encode(_tasks.map((task) => task.toJson()).toList());
    await _prefs.setString('tasks', tasksJson);
  }
}
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  final Map<DateTime, List<String>> _tasks = {}; // Map to store tasks by date


  @override
  void initState() {
    super.initState();
    _loadTasks();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendar with Tasks'),
      ),
      body: Column(
        children: [
          // Calendar Widget
          TableCalendar(
            focusedDay: _focusedDay,
            firstDay: DateTime(2000),
            lastDay: DateTime(2100),
            calendarFormat: CalendarFormat.month,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: const CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Colors.blueAccent,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
              weekendTextStyle: TextStyle(color: Colors.red),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
          ),
          const SizedBox(height: 20),

          // Display Tasks for Selected Date
          Expanded(
            child: _selectedDay != null
                ? _buildTaskList()
                : const Center(
                    child: Text('Select a date to view tasks'),
                  ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _selectedDay != null
            ? () => _showAddTaskDialog(context)
            : null, // Disable button if no date is selected
        child: const Icon(Icons.add),
      ),
    );
  }

  // Build Task List
  Widget _buildTaskList() {
    final tasks = _tasks[_selectedDay] ?? [];
    return tasks.isEmpty
        ? const Center(
            child: Text('No tasks for this date'),
          )
        : ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(tasks[index]),
                trailing: IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteTask(index),
                ),
              );
            },
          );
  }

  // Show Add Task Dialog
  void _showAddTaskDialog(BuildContext context) {
    final TextEditingController _taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Task'),
        content: TextField(
          controller: _taskController,
          decoration: const InputDecoration(hintText: 'Enter task details'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Close dialog
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              final task = _taskController.text.trim();
              if (task.isNotEmpty) {
                _addTask(task);
                Navigator.pop(context); // Close dialog
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  // Add Task
  void _addTask(String task) {
    setState(() {
      if (_tasks[_selectedDay] == null) {
        _tasks[_selectedDay!] = [];
      }
      _tasks[_selectedDay]!.add(task);
    });
  }

  // Delete Task
  void _deleteTask(int index) {
    setState(() {
      _tasks[_selectedDay]!.removeAt(index);
      if (_tasks[_selectedDay]!.isEmpty) {
        _tasks.remove(_selectedDay); // Remove date if no tasks remain
      }
    });
  }

  // Load Tasks from Local Storage
  Future<void> _loadTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final storedTasks = prefs.getString('tasks');
    if (storedTasks != null) {
      final decodedTasks = (json.decode(storedTasks) as Map<String, dynamic>)
          .map((key, value) => MapEntry(DateTime.parse(key), List<String>.from(value)));
      setState(() {
        _tasks.addAll(decodedTasks);
      });
    }
  }

  // Save Tasks to Local Storage
  Future<void> _saveTasks() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedTasks = json.encode(
      _tasks.map((key, value) => MapEntry(key.toIso8601String(), value)),
    );
    await prefs.setString('tasks', encodedTasks);
  }
}

//}
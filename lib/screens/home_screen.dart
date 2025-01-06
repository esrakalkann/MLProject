import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('To-Do List'),
      ),
      body: const Center(
        child: Text('No tasks yet! Add some.'), // Replace with dynamic task data
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addTaskButton',
            onPressed: () {
              Navigator.pushNamed(context, '/add-task'); // Navigate to Add Task Screen
            },
            child: const Icon(Icons.add),
            tooltip: 'Add Task',
          ),
          const SizedBox(height: 10),
          FloatingActionButton(
            heroTag: 'calendarButton',
            onPressed: () {
              Navigator.pushNamed(context, '/calendar'); // Navigate to Calendar Screen
            },
            child: const Icon(Icons.calendar_today),
            tooltip: 'View Calendar',
          ),
        ],
      ),
    );
  }
}

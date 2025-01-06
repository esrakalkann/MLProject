import 'package:flutter/material.dart';
import '../services/storage_service.dart';
import 'add_task_screen.dart';

class TaskScreen extends StatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  State<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends State<TaskScreen> {
  final StorageService _storageService = StorageService();
  List<Map<String, dynamic>> _tasks = [];

  @override
  void initState() {
    super.initState();
    _loadTasks();
  }



  void _addTask(Map<String, dynamic> newTask) {
    setState(() {
      _tasks.add(newTask);
    });
    print('Tasks after adding: $_tasks');
    _storageService.saveTasks(_tasks); // Save updated task list
  }

  Future<void> _loadTasks() async {
  final tasks = await _storageService.loadTasks();
  setState(() {
    _tasks = tasks;
  });
  print('Tasks loaded: $_tasks'); // Debug: Check loaded tasks
}

  void _deleteTask(int index) {
    setState(() {
      _tasks.removeAt(index);
    });
    print('Tasks after deletion: $_tasks');
    _storageService.saveTasks(_tasks); // Save updated task list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tasks"),
      ),
      body: _tasks.isEmpty
          ? const Center(
              child: Text("No tasks added yet."),
            )
          : ListView.builder(
              itemCount: _tasks.length,
              itemBuilder: (context, index) {
                final task = _tasks[index];
                return ListTile(
                  title: Text(task["title"]?? "Untitled Task"),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (task["priority"] != null)
                        Text("Priority: ${task["priority"]}"),
                      if (task["reminderDateTime"] != null)
                        Text("Reminder: ${task["reminderDateTime"]}"),
                      if (task["notes"] != null && task["notes"]!.isNotEmpty)
                        Text("Notes: ${task["notes"]}"),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteTask(index),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );

          if (result != null && result is Map<String, dynamic>) {
            _addTask(result);
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
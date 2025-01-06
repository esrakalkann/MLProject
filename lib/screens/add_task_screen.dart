import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '/services/notification_service.dart';
import '/services/location_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({Key? key}) : super(key: key);

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  DateTime? _reminderDateTime;
  Position? _selectedLocation;

  void _selectDateTime(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _reminderDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  void _selectLocation() async {
    try {
      Position position = await LocationService().getCurrentLocation();
      setState(() {
        _selectedLocation = position;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error fetching location: $e")),
      );
    }
  }

  void _scheduleTaskNotification() async {
    if (_reminderDateTime != null) {
      await NotificationService.scheduleNotification(
        title: _titleController.text,
        body: "Task reminder: ${_titleController.text}",
        scheduledDate: _reminderDateTime!,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add New Task"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Task Title
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: "Task Title",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Task Notes
            TextField(
              controller: _notesController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Task Notes (Optional)",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),

            // Reminder Selection
            ListTile(
              title: Text(
                _reminderDateTime != null
                    ? "Reminder: ${_reminderDateTime.toString()}"
                    : "No Reminder Set",
              ),
              trailing: const Icon(Icons.calendar_today),
              onTap: () => _selectDateTime(context),
            ),
            const SizedBox(height: 16),

            // Location Selection
            ListTile(
              title: Text(
                _selectedLocation != null
                    ? "Lat: ${_selectedLocation!.latitude}, Lon: ${_selectedLocation!.longitude}"
                    : "No Location Selected",
              ),
              trailing: const Icon(Icons.location_on),
              onTap: _selectLocation,
            ),
            const SizedBox(height: 16),

            // Save Task Button
            ElevatedButton(
              onPressed: () {
                final String title = _titleController.text;

                if (title.isNotEmpty) {
                  _scheduleTaskNotification();
                  Navigator.pop(context, {
                    "title": title,
                    "notes": _notesController.text,
                    "reminderDateTime": _reminderDateTime?.toString(),
                    "location": _selectedLocation != null
                        ? {
                            "latitude": _selectedLocation!.latitude,
                            "longitude": _selectedLocation!.longitude,
                          }
                        : null,
                  });
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please enter a task title")),
                  );
                }
              },
              child: const Text("Save Task"),
            ),
          ],
        ),
      ),
    );
  }
}
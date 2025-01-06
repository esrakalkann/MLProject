import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'screens/task_screen.dart'; // Ensure these imports are correct
import 'screens/calendar_screen.dart';
import 'screens/add_task_screen.dart';
import 'services/notification_service.dart';
import 'services/location_service.dart';
import 'services/location_task_manager.dart';
import 'services/storage_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize();
  await NotificationService.requestIOSPermissions(); // Ensure this is correctly implemented
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        Provider(create: (_) => StorageService()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Smart ToDo List',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
          ),
        ),
        initialRoute: '/tasks', // Define the initial route
        routes: {
          '/tasks': (context) => const TaskScreen(), // Main Task Screen
          '/calendar': (context) => const CalendarScreen(), // Calendar Screen
          '/add-task': (context) => const AddTaskScreen(), // Add Task Screen
        },
      ),
    );
  }
}

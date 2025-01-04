import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_application_1/screens/home_screen.dart';
import 'services/notification_service.dart';
import "services/location_service.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initialize(); // Initialize notification service
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationService()),
        // Add other providers here if needed
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false, // Disables the debug banner
        title: 'Smart ToDo List', // Set your app title
        theme: ThemeData(primarySwatch: Colors.blue), // Set theme color
        home: const HomeScreen(), // Set the home screen widget
      ),
    );
  }
}


import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> initialize() async {
    // Initialize Android-specific settings
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    // Initialize iOS-specific settings
    IOSInitializationSettings iosSettings = IOSInitializationSettings();

    // Combine the settings
    InitializationSettings settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,  // iOS settings added
    );

    // Initialize the notification plugin with the settings
    await _notificationsPlugin.initialize(settings);
  }

  static Future<void> showNotification(
      {required String title, required String body}) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails('main_channel', 'Main Channel',
            importance: Importance.high, priority: Priority.high);

    const IOSNotificationDetails iosDetails = IOSNotificationDetails();

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails, // Add iOS notification details
    );

    await _notificationsPlugin.show(0, title, body, details);
  }
}

class IOSInitializationSettings {

}
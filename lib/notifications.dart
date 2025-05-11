import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'alarm.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  // Initialize the local notifications plugin
  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: _onNotificationSelected,
  );

  // Check if the platform is Android and if it's Android 13 or above, request permission
  if (Platform.isAndroid && await _isAndroid13OrAbove()) {
    final androidImplementation =
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >();
    await androidImplementation?.requestNotificationsPermission();
  }
}

// Check Android Version
Future<bool> _isAndroid13OrAbove() async {
  final androidInfo = await DeviceInfoPlugin().androidInfo;
  return androidInfo.version.sdkInt >= 33;
}

// Handle notification interactions
Future<void> _onNotificationSelected(NotificationResponse response) async {
  if (response.actionId == 'stop_alarm') {
    stopAlarm(); // Stop the alarm if the 'stop_alarm' button is pressed
  }
}

// Show notification
Future<void> showNotification(double angin, double arus) async {
  const androidDetails = AndroidNotificationDetails(
    'sensor_alerts',
    'Sensor Alerts',
    importance: Importance.max,
    priority: Priority.high,
    actions: [
      AndroidNotificationAction(
        'stop_alarm',
        'Hentikan Alarm',
        showsUserInterface: true,
      ),
    ],
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    '🚨 Peringatan Sensor',
    'Angin: $angin | Arus: $arus telah melebihi batas aman!',
    notificationDetails,
    payload: 'stop_alarm',
  );
}

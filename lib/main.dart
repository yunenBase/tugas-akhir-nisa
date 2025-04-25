import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir_nisa/send.dart';
import 'package:collection/collection.dart';
import 'package:audioplayers/audioplayers.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

int _lastNotifiedTimestamp = 0; // Timestamp untuk notifikasi terakhir
final AudioPlayer _audioPlayer = AudioPlayer();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Initialize Notifications
  await _initializeNotifications();

  // Mulai mendengarkan Firestore secara realtime
  listenToFirestore();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  MyApp() {}

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Data',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirestoreTestScreen(),
    );
  }
}

// Fungsi inisialisasi notifikasi
Future<void> _initializeNotifications() async {
  const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
  const initSettings = InitializationSettings(android: androidSettings);

  // Initialize the local notifications plugin
  await flutterLocalNotificationsPlugin.initialize(initSettings);

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

// Fungsi untuk mendengarkan perubahan data realtime dari Firestore
void listenToFirestore() {
  FirebaseFirestore.instance.collection("wavex").snapshots().listen((snapshot) {
    final todayDocId = DateFormat('yyyy-MM-dd').format(DateTime.now());
    final todayDoc = snapshot.docs.firstWhereOrNull(
      (doc) => doc.id == todayDocId,
    );

    if (todayDoc != null) {
      // No need to cast todayDoc.data(), it's already Map<String, dynamic>
      final data = todayDoc.data();

      final latestEntry = _getLatestEntry(data);
      if (latestEntry == null) return;

      final double angin = latestEntry["Angin"];
      final double arus = latestEntry["Arus"];

      final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      // Always send notification if values exceed the threshold
      if (angin > 5 || arus > 5) {
        // If enough time has passed since the last notification, send a new one
        if (now - _lastNotifiedTimestamp > 5) {
          // Adjusted interval (1 minute for testing)
          _showNotification(angin, arus);
          _lastNotifiedTimestamp =
              now; // Update timestamp after sending notification
        }
      }
      // Trigger Alarm if Arus > 7 and Angin > 7
      if (angin > 7 && arus > 7) {
        print("Triggering Alarm...");
        _playAlarm(); // Play the alarm sound
      }
    }
  });
}

// Fungsi pembantu untuk mengambil data terbaru
Map<String, dynamic>? _getLatestEntry(Map<String, dynamic> data) {
  if (data.isEmpty) return null;

  final keys = data.keys.toList();
  keys.sort(); // ascending
  final latestKey = keys.last;

  final latestData = data[latestKey];
  if (latestData is Map<String, dynamic>) {
    return {
      "Angin": latestData["Angin"],
      "Arus": latestData["Arus"],
      "timestampKey": latestKey,
    };
  }
  return null;
}

// Fungsi untuk menampilkan notifikasi
void _showNotification(double angin, double arus) async {
  const androidDetails = AndroidNotificationDetails(
    'sensor_alerts',
    'Sensor Alerts',
    importance: Importance.max,
    priority: Priority.high,
  );

  const notificationDetails = NotificationDetails(android: androidDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    '🚨 Peringatan Sensor',
    'Angin: $angin | Arus: $arus telah melebihi batas aman!',
    notificationDetails,
  );
}

void _playAlarm() async {
  try {
    await _audioPlayer.play(
      AssetSource('sounds/alarm.wav'),
    ); // Play the alarm sound
    print("Alarm sound played.");
  } catch (e) {
    print("Error playing alarm: $e");
  }
}

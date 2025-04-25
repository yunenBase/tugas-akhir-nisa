import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:audioplayers/audioplayers.dart';

void onBackgroundNotificationResponse(NotificationResponse response) {
  SensorMonitor.instance._stopAlarm();
}

class SensorMonitor {
  static final SensorMonitor instance = SensorMonitor._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AudioPlayer _player = AudioPlayer();

  SensorMonitor._internal();

  bool _isAlarmPlaying = false;
  bool _isAlertActive = false;
  String? _lastDocumentID;

  void initialize() {
    _initializeNotifications();
    _listenToFirestore();
  }

  void _initializeNotifications() async {
    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    await _notificationsPlugin.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (response) {
        if (response.actionId == 'STOP_ALARM') _stopAlarm();
      },
      onDidReceiveBackgroundNotificationResponse:
          onBackgroundNotificationResponse,
    );

    // Android 13+ permission
    if (Platform.isAndroid) {
      final androidImplementation =
          _notificationsPlugin
              .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin
              >();
      await androidImplementation?.requestNotificationsPermission();
    }
  }

  void _showNotification(
    String title,
    String message, {
    bool withAlarm = false,
    int id = 0,
  }) async {
    var androidDetails = AndroidNotificationDetails(
      'sensor_alert_channel',
      'Sensor Alerts',
      importance: Importance.max,
      priority: Priority.high,
      fullScreenIntent: withAlarm,
      actions:
          withAlarm
              ? [
                const AndroidNotificationAction(
                  'STOP_ALARM',
                  'Matikan Alarm',
                  showsUserInterface: true,
                ),
              ]
              : [],
      autoCancel: !withAlarm,
      ongoing: withAlarm,
    );

    await _notificationsPlugin.show(
      id,
      title,
      message,
      NotificationDetails(android: androidDetails),
    );

    if (withAlarm) _playAlarm();
  }

  void _playAlarm() async {
    if (_isAlarmPlaying) return;
    _isAlarmPlaying = true;
    await _player.play(AssetSource('sounds/alarm.wav'));
    Future.delayed(Duration(seconds: 10), _stopAlarm);
  }

  void _stopAlarm() async {
    await _player.stop();
    _isAlarmPlaying = false;
    _isAlertActive = false;
    await _notificationsPlugin.cancelAll();
  }

  void _listenToFirestore() {
    final today = _getCurrentDate();

    FirebaseFirestore.instance
        .collection('wavex')
        .doc(today)
        .collection(today)
        .orderBy(FieldPath.documentId, descending: true)
        .limit(1)
        .snapshots()
        .listen((snapshot) {
          if (snapshot.docs.isEmpty) return;

          var doc = snapshot.docs.first;
          if (_lastDocumentID == doc.id) return;
          _lastDocumentID = doc.id;

          double angin = (doc['Angin'] as num).toDouble();
          double arus = (doc['Arus'] as num).toDouble();

          if ((angin > 5 || arus > 5) && !_isAlertActive) {
            _isAlertActive = true;
            _showNotification(
              "Peringatan Kondisi Air",
              "Angin: $angin m/s, Arus: $arus m/s melebihi ambang batas!",
              withAlarm: true,
              id: 1,
            );
          } else if (angin <= 5 && arus <= 5) {
            _stopAlarm(); // Reset jika data aman
          }
        }, onError: (error) => print("❌ ERROR Firestore: $error"));
  }

  String _getCurrentDate() {
    final now = DateTime.now();
    return "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
  }
}

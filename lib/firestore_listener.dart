import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import 'notifications.dart';
import 'alarm.dart';

int _lastNotifiedTimestamp = 0; // Timestamp for the last notification

void listenToFirestore([
  void Function(double, double)? onLatestData,
  void Function(List<Map<String, dynamic>>)? onAllData,
]) {
  FirebaseFirestore.instance
      .collection("wavex")
      .snapshots()
      .listen(
        (snapshot) {
          print(
            "Firestore snapshot received: ${snapshot.docs.length} documents",
          );
          final todayDocId = DateFormat('yyyy-MM-dd').format(DateTime.now());
          print("Looking for document with ID: $todayDocId");
          final todayDoc = snapshot.docs.firstWhereOrNull(
            (doc) => doc.id == todayDocId,
          );

          if (todayDoc != null) {
            final data = todayDoc.data();
            print("Document data: $data");

            // Ambil data terbaru
            final latestEntry = _getLatestEntry(data);
            if (latestEntry == null) {
              print("No latest entry found");
              return;
            }
            print("Latest entry: $latestEntry");
            final double angin = (latestEntry["Angin"] as num).toDouble();
            final double arus = (latestEntry["Arus"] as num).toDouble();

            // Notifikasi & alarm tetap seperti semula
            final now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
            if (angin > 5 || arus > 5) {
              if (now - _lastNotifiedTimestamp > 5) {
                showNotification(angin, arus);
                _lastNotifiedTimestamp = now;
                print("Notification triggered: Angin=$angin, Arus=$arus");
              }
            }
            if (angin > 7 && arus > 7) {
              print("Triggering Alarm...");
              playAlarm();
            }

            // Callback untuk satu data terbaru (lama)
            if (onLatestData != null) {
              onLatestData(angin, arus);
            }

            // ✅ Callback untuk semua data (baru)
            if (onAllData != null) {
              final allEntries = _getAllEntries(data);
              onAllData(allEntries);
            }
          } else {
            print("No document found for $todayDocId");
          }
        },
        onError: (error) {
          print("Firestore error: $error");
        },
      );
}

// Helper function to get the latest entry, adjusted for ts_ prefix
Map<String, dynamic>? _getLatestEntry(Map<String, dynamic> data) {
  if (data.isEmpty) {
    print("Data is empty");
    return null;
  }

  final keys =
      data.keys
          .toList()
          .where((key) => key.startsWith('ts_'))
          .map((key) => int.parse(key.replaceFirst('ts_', '')))
          .toList();
  print("Keys after filtering: $keys");
  if (keys.isEmpty) {
    print("No keys with 'ts_' prefix found");
    return null;
  }
  keys.sort((a, b) => b.compareTo(a)); // Sort descending to get the latest
  final latestKey = 'ts_${keys.first}';
  print("Latest key: $latestKey");

  final latestData = data[latestKey];
  print("Latest data: $latestData");
  if (latestData is Map<String, dynamic>) {
    return {
      "Angin": latestData["Angin"] ?? 0.0,
      "Arus": latestData["Arus"] ?? 0.0,
      "timestampKey": latestKey,
    };
  }
  print("Latest data is not a Map<String, dynamic>");
  return null;
}

List<Map<String, dynamic>> _getAllEntries(Map<String, dynamic> data) {
  final entries = <Map<String, dynamic>>[];

  final keys =
      data.keys
          .where((key) => key.startsWith('ts_'))
          .map((key) => int.parse(key.replaceFirst('ts_', '')))
          .toList()
        ..sort();

  for (final ts in keys) {
    final key = 'ts_$ts';
    final entry = data[key];
    if (entry is Map<String, dynamic>) {
      final time = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
      entries.add({
        'time': time,
        'angin': (entry['Angin'] ?? 0).toDouble(),
        'arus': (entry['Arus'] ?? 0).toDouble(),
      });
    }
  }

  return entries;
}

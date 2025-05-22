import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class DummyDataPage extends StatelessWidget {
  // Fungsi untuk menghasilkan angka acak antara 1 dan 10
  int _generateRandomValue() {
    return Random().nextInt(10) + 1;
  }

  // Fungsi untuk mengirim dummy data ke Firestore
  Future<void> _sendDummyData() async {
    final firestore = FirebaseFirestore.instance;
    const date = "2025-05-20";

    // Loop untuk membuat data dari jam 01:00 sampai 23:00
    for (int hour = 1; hour <= 23; hour++) {
      final formattedHour = hour.toString().padLeft(2, '0');
      final timestamp = "ts_174777082${hour + 294}"; // Timestamp palsu berdasarkan pola
      final docId = "$date $formattedHour:00";

      await firestore.collection('wavex').doc(docId).set({
        'Angin': _generateRandomValue(),
        'Arus': _generateRandomValue(),
        'timestamp': timestamp,
      });

      print("Data untuk $docId telah dikirim.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirim Dummy Data ke Firestore'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _sendDummyData();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Dummy data telah dikirim!')),
            );
          },
          child: const Text('Kirim Dummy Data'),
        ),
      ),
    );
  }
}
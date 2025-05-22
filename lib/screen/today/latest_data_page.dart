import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:math';

class AddCurrentDateDataPage extends StatelessWidget {
  // Fungsi untuk menghasilkan angka acak antara 1 dan 10
  int _generateRandomValue() {
    return Random().nextInt(10) + 1;
  }

  // Fungsi untuk mengirim data ke Firestore
  Future<void> _sendDataForToday() async {
    final firestore = FirebaseFirestore.instance;
    const date = "2025-05-21"; // Tanggal hari ini

    // Loop untuk membuat data dari jam 01:00 sampai 23:00
    for (int hour = 1; hour <= 23; hour++) {
      final formattedHour = hour.toString().padLeft(2, '0');
      final docId = "$date $formattedHour:00";

      // Membuat timestamp Unix untuk tanggal 2025-05-21 pada jam tertentu
      final timestamp = DateTime(2025, 5, 21, hour).millisecondsSinceEpoch;

      await firestore.collection('wavex').doc(docId).set({
        'ts_timestamp': timestamp,
        'Angin': _generateRandomValue(),
        'Arus': _generateRandomValue(), // Perbaikan typo dari 'Random' ke 'Arus'
      });

      print("Data untuk $docId telah dikirim.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kirim Data Hari Ini ke Firestore'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await _sendDataForToday();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Data hari ini telah dikirim!')),
            );
          },
          child: const Text('Kirim Data'),
        ),
      ),
    );
  }
}
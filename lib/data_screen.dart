// lib/data_screen.dart

import 'package:flutter/material.dart';

class DataScreen extends StatelessWidget {
  final String formattedDate;
  final double angin;
  final double arus;
  final int timestamp;

  DataScreen({
    required this.formattedDate,
    required this.angin,
    required this.arus,
    required this.timestamp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Data')),
      body:
          formattedDate.isEmpty
              ? CircularProgressIndicator()
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Waktu: $formattedDate',
                      style: TextStyle(fontSize: 18),
                    ),
                    SizedBox(height: 10),
                    Text('Angin: $angin m/s', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Arus: $arus m/s', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text(
                      'Timestamp: $timestamp',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
    );
  }
}

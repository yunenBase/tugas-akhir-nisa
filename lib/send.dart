import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreTestScreen extends StatelessWidget {
  const FirestoreTestScreen({super.key});

  Future<void> _sendDummyData() async {
    final firestore = FirebaseFirestore.instance;
    final double angin = 4.2;
    final double arus = 1.7;

    // Format the current date to yyyy-MM-dd for document ID
    final String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());

    // Get the current UNIX timestamp (in seconds)
    final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final data = {"Angin": angin, "Arus": arus, "Timestamp": timestamp};

    try {
      // Create the document with the formatted date as document ID
      await firestore.collection("wavex").doc(formattedDate).set(data);
      debugPrint("✔ Data terkirim ke Firestore! $data");
    } catch (e) {
      debugPrint("❌ Gagal kirim data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Kirim Dummy ke Firestore")),
      body: Center(
        child: ElevatedButton(
          onPressed: _sendDummyData,
          child: const Text("Kirim Data Dummy"),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FirestoreTestScreen()),
          );
        },
        child: const Icon(Icons.arrow_back),
      ),
    );
  }
}

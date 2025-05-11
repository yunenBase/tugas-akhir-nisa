import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class FirestoreTestScreen extends StatelessWidget {
  const FirestoreTestScreen({super.key});

  Future<void> _sendDummyData() async {
    final firestore = FirebaseFirestore.instance;
    final double angin = 8;
    final double arus = 8;

    // Format date untuk ID dokumen
    final String formattedDate = DateFormat(
      'yyyy-MM-dd',
    ).format(DateTime.now());

    // Unix timestamp sebagai field name
    final int timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    // Data yang akan dimasukkan
    final Map<String, dynamic> data = {
      "$timestamp": {"Angin": angin, "Arus": arus},
    };

    try {
      // Gunakan merge agar tidak menimpa data sebelumnya
      await firestore
          .collection("wavex")
          .doc(formattedDate)
          .set(data, SetOptions(merge: true));
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

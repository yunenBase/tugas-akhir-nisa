import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Firestore Data',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: FirestoreTestScreen(),
    );
  }
}

class FirestoreTestScreen extends StatefulWidget {
  @override
  _FirestoreTestScreenState createState() => _FirestoreTestScreenState();
}

class _FirestoreTestScreenState extends State<FirestoreTestScreen> {
  // Data fields to hold fetched data
  String formattedDate = '';
  double angin = 0.0;
  double arus = 0.0;
  int timestamp = 0;

  @override
  void initState() {
    super.initState();
    _fetchDataFromFirestore();
  }

  Future<void> _fetchDataFromFirestore() async {
    try {
      // Fetch the latest document in the 'wavex' collection
      var snapshot =
          await FirebaseFirestore.instance
              .collection('wavex')
              .orderBy('Timestamp', descending: true)
              .limit(1)
              .get();

      if (snapshot.docs.isNotEmpty) {
        var doc = snapshot.docs.first;
        setState(() {
          // Set data from Firestore
          formattedDate = doc.id; // This is the 'yyyy-MM-dd' formatted date
          angin = doc['Angin'];
          arus = doc['Arus'];
          timestamp = doc['Timestamp'];
        });
      }
    } catch (e) {
      debugPrint("❌ Gagal mengambil data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Data')),
      body: Center(
        child:
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
      ),
    );
  }
}

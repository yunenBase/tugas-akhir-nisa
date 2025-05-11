import 'package:flutter/material.dart';
import 'firestore_listener.dart';
import 'package:intl/intl.dart';

class DataScreen extends StatefulWidget {
  const DataScreen({super.key});

  @override
  _DataScreenState createState() => _DataScreenState();
}

class _DataScreenState extends State<DataScreen> {
  final List<Map<String, dynamic>> _dataLog = [];

  @override
  void initState() {
    super.initState();
    print("DataScreen initState: Starting Firestore listener");

    listenToFirestore(
      (angin, arus) {
        // Optional: masih bisa digunakan kalau mau
      },
      (allEntries) {
        if (mounted) {
          setState(() {
            _dataLog
              ..clear()
              ..addAll(
                allEntries.reversed.map((entry) {
                  return {
                    'time': DateFormat('HH:mm:ss').format(entry['time']),
                    'angin': entry['angin'],
                    'arus': entry['arus'],
                  };
                }),
              );
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final displayDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
    return Scaffold(
      appBar: AppBar(title: Text('Firestore Data for $displayDate')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child:
            _dataLog.isEmpty
                ? const Center(child: Text("Belum ada data"))
                : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Waktu')),
                      DataColumn(label: Text('Angin')),
                      DataColumn(label: Text('Arus')),
                    ],
                    rows:
                        _dataLog.map((entry) {
                          return DataRow(
                            cells: [
                              DataCell(Text(entry['time'])),
                              DataCell(Text(entry['angin'].toStringAsFixed(2))),
                              DataCell(Text(entry['arus'].toStringAsFixed(2))),
                            ],
                          );
                        }).toList(),
                  ),
                ),
      ),
    );
  }
}

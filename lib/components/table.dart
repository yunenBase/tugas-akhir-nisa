import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir_nisa/services/firestore_listener.dart';

class WindCurrentTable extends StatefulWidget {
  const WindCurrentTable({super.key});

  @override
  WindCurrentTableState createState() => WindCurrentTableState();
}

class WindCurrentTableState extends State<WindCurrentTable> {
  List<Map<String, dynamic>> tableData = [];

  @override
  void initState() {
    super.initState();
    _startListening();
  }

  void _startListening() {
    listenToFirestore(
      onAllData: (allEntries) {
        setState(() {
          tableData =
              allEntries.map((entry) {
                final double angin = entry['angin'];
                final double arus = entry['arus'];
                final String time = DateFormat(
                  'dd MMMM yyyy\nHH.mm',
                ).format(entry['time']);
                final String condition = _getCondition(angin, arus);

                return {
                  'time': time,
                  'condition': condition,
                  'arus': arus,
                  'angin': angin,
                };
              }).toList();
        });
      },
    );
  }

  String _getCondition(double angin, double arus) {
    if (angin <= 8.05) {
      if (arus <= 1.00) {
        if (angin <= 5.07) {
          return "Aman";
        } else {
          return "Waspada";
        }
      } else {
        return "Waspada";
      }
    } else {
      if (arus <= 1.00) {
        if (arus <= 0.34) {
          return "Waspada";
        } else {
          return "Waspada";
        }
      } else {
        return "Bahaya";
      }
    }
  }

  Color _getConditionColor(String condition) {
    switch (condition) {
      case "Aman":
        return Colors.green;
      case "Waspada":
        return Colors.orange;
      case "Bahaya":
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Header
          Container(
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 212, 222, 254),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
            child: Row(
              children: const [
                Expanded(
                  flex: 2,
                  child: Text(
                    'Waktu',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Kondisi',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Arus',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    'Angin',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Rows
          ...tableData.map((data) {
            return Container(
              margin: const EdgeInsets.symmetric(vertical: 6),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 238, 242, 254),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(flex: 2, child: Text(data['time'])),
                  Expanded(
                    flex: 1,
                    child: Text(
                      data['condition'],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: _getConditionColor(data['condition']),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('${data['arus'].toStringAsFixed(0)} m/s'),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text('${data['angin'].toStringAsFixed(0)} m/s'),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

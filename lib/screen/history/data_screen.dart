import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugas_akhir_nisa/components/chart.dart';
import 'package:tugas_akhir_nisa/components/table.dart';
import 'package:tugas_akhir_nisa/services/firestore_listener.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late List<ChartData> windData = [];
  late List<ChartData> currentData = [];
  Widget displayedWidget = SizedBox();
  int activeButton = 0;

  @override
  void initState() {
    super.initState();
    _startListening();
    _showChartAngin(); // Default menampilkan Chart Angin
  }

  Future<void> _onRefresh() async {
    // Ini akan memanggil ulang Firestore listener
    _startListening();
    // Tambahkan delay opsional untuk animasi refresh
    await Future.delayed(const Duration(seconds: 1));
  }

  void _startListening() {
    listenToFirestore(
      onAllData: (allEntries) {
        setState(() {
          windData =
              allEntries
                  .map(
                    (entry) => ChartData(
                      DateFormat('HH:mm').format(entry['time']),
                      entry['angin'],
                    ),
                  )
                  .toList();
          currentData =
              allEntries
                  .map(
                    (entry) => ChartData(
                      DateFormat('HH:mm').format(entry['time']),
                      entry['arus'],
                    ),
                  )
                  .toList();
        });
      },
    );
  }

  void _showChartAngin() {
    setState(() {
      activeButton = 0;
      displayedWidget = ChartAngin(windData: windData);
    });
  }

  void _showChartArus() {
    setState(() {
      activeButton = 1;
      displayedWidget = ChartArus(currentData: currentData);
    });
  }

  ButtonStyle _buttonStyle(int buttonNumber) {
    final bool isActive = activeButton == buttonNumber;
    return ElevatedButton.styleFrom(
      backgroundColor:
          isActive ? const Color.fromARGB(255, 12, 123, 213) : Colors.grey[300],
      foregroundColor: isActive ? Colors.white : Colors.black,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: const Color.fromARGB(255, 117, 203, 252),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Statistic\nMonitor",
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(
                          Icons.notifications,
                          color: Colors.white,
                          size: 41,
                        ),
                      ],
                    ),
                    const SizedBox(height: 15.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton(
                          style: _buttonStyle(0),
                          onPressed: _showChartAngin,
                          child: const Text("Angin"),
                        ),
                        ElevatedButton(
                          style: _buttonStyle(1),
                          onPressed: _showChartArus,
                          child: const Text("Arus"),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      child: displayedWidget,
                    ),
                    WindCurrentTable(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

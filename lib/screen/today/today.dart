import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugas_akhir_nisa/screen/today/status_card.dart';
import 'package:tugas_akhir_nisa/services/firestore_listener.dart';

class Today extends StatefulWidget {
  const Today({super.key});

  @override
  State<Today> createState() => _TodayState();
}

class _TodayState extends State<Today> {
  double _latestAngin = 0.0;
  double _latestArus = 0.0;

  @override
  void initState() {
    super.initState();
    print("LatestDataPage initState: Starting Firestore listener");
    _startListening();
  }

  Future<void> _startListening() async {
    listenToFirestore(
      onLatestData: (angin, arus) {
        print("LatestDataPage received latest data: Angin=$angin, Arus=$arus");
        if (mounted) {
          setState(() {
            _latestAngin = angin;
            _latestArus = arus;
          });
        }
      },
    );
  }

  Future<void> _refreshData() async {
    // Simulasikan proses refresh dengan memanggil ulang listener
    await _startListening();
  }

  Color _getStatusColor() {
    if (_latestAngin > 8 && _latestArus > 1) {
      return Colors.red; // Danger
    } else if (_latestAngin > 5.5 || _latestArus > 0.1) {
      return Colors.orange; // Warning
    } else {
      return Colors.lightGreen; // Safe
    }
  }

  String _getStatus() {
    if (_latestAngin > 8 && _latestArus > 1) {
      return "Bahaya";
    } else if (_latestAngin > 5.5 || _latestArus > 0.1) {
      return "Waspada";
    } else {
      return "Aman";
    }
  }

  String _getSuggestion() {
    if (_latestAngin > 8 && _latestArus > 1) {
      return "Arus kuat dan angin kencang, hindari aktivitas di laut";
    } else if (_latestAngin > 5.5 || _latestArus > 0.1) {
      return "Berhati-hati jika disekitar pesisir pantai";
    } else {
      return "Kondisi gelombang aman, anda bisa beraktivitas di laut";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
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
            ],
          ),
          RefreshIndicator(
            onRefresh: _refreshData,
            child: Container(
              padding: const EdgeInsets.only(top: 50, left: 30, right: 30),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Ocean Wave\nMonitor",
                          style: GoogleFonts.inter(
                            textStyle: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 30.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const Icon(Icons.notifications, color: Colors.white, size: 41),
                      ],
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Wave Status",
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.0,
                                color: Color.fromARGB(255, 104, 104, 104),
                              ),
                            ),
                          ),
                          Divider(color: Colors.grey[300], thickness: 2),
                          Row(
                            children: [
                              Icon(
                                Icons.warning,
                                color: _getStatusColor(),
                                size: 20,
                              ),
                              const SizedBox(width: 10.0),
                              Text(
                                _getStatus(),
                                style: GoogleFonts.inter(
                                  textStyle: TextStyle(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.bold,
                                    color: _getStatusColor(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text(
                            _getSuggestion(),
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontSize: 11.0,
                                color: Color.fromARGB(255, 104, 104, 104),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width * 0.41,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 138, 218, 255),
                                Color.fromARGB(255, 61, 163, 243),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '${_latestAngin.toStringAsFixed(2)} m/s\nAngin',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.41,
                          height: 140,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Color.fromARGB(255, 255, 213, 88),
                                Color.fromARGB(255, 251, 188, 5),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Center(
                            child: Text(
                              '${_latestArus.toStringAsFixed(2)} m/s\nArus',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(
                                textStyle: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            "Recomendations For You!",
                            style: GoogleFonts.inter(
                              textStyle: const TextStyle(
                                fontWeight: FontWeight.w500,
                                color: Color.fromARGB(255, 53, 53, 53),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    WaveStatusCard(angin: _latestAngin, arus: _latestArus),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
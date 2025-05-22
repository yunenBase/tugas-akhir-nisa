import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class WaveStatusCard extends StatelessWidget {
  final double angin;
  final double arus;

  const WaveStatusCard({super.key, required this.angin, required this.arus});

  @override
  Widget build(BuildContext context) {
    // Determine status based on conditions
    if (angin > 8 && arus > 1) {
      return Column(
        children: [
          _buildStatusCard(
            'Hindari Aktivitas di Pantai',
            'Kondisi sangat beresiko',
            Colors.red[100]!,
          ),
          _buildStatusCard(
            'Segera cari tempat aman',
            'Usahakan pergi ke tempat yang lebih tinggi',
            Colors.red[100]!,
          ),
          _buildStatusCard(
            'Pantau aplikasi secara berkala',
            'Aplikasi akan membantu untuk monitor gelombang',
            Colors.red[100]!,
          ),
          _buildStatusCard(
            'Hubungi petugas jika butuh bantuan',
            'Jika membahayakan segera hubungi petugas setempat',
            Colors.red[100]!,
          ),
        ],
      );
    } else if (angin > 5.5 && arus > 0.1) {
      return
      Column(children: [
        _buildStatusCard(
            'Batasi aktivitas di pantai',
            'Kurangi aktivitas terlalu dekat dengan laut',
            Colors.yellow[100]!
          ),
        _buildStatusCard(
            'Waspadai perubahan cuaca',
            'Angin kencang dan arus kuat bisa muncul tiba-tibayan',
           Colors.yellow[100]!
          ),
        _buildStatusCard(
            'Pantau aplikasi secara berkala',
            'Aplikasi akan membantu untuk monitor gelombang',
            Colors.yellow[100]!
          ),
        _buildStatusCard(
            'Hubungi petugas jika butuh bantuan',
            'Jika membahayakan segera hubungi petugas setempat',
            Colors.yellow[100]!
          ),
      ],);

    } else {
      return Column(
        children: [
          _buildStatusCard(
            'Nikmati Keindahan di Pantai',
            'Tetap waspada dan patuhi rambu keselamatan',
            Colors.blue[100]!,
          ),
          _buildStatusCard(
            'Periksa Aplikasi secara Berkala',
            'Pantau kondisi terbaru untuk antisipasi perubahan cuaca',
            Colors.blue[100]!,
          ),
          _buildStatusCard(
            'Hubungi Petugas Jika Butuh Bantuan',
            'Jika membahayakan segera hubungi petugas setempat',
            Colors.blue[100]!,
          ),
        ],
      );
    }
  }

  Widget _buildStatusCard(String title, String description, Color backgroundColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              description,
              style: GoogleFonts.inter(
                textStyle: const TextStyle(
                  fontSize: 12.0,
                  color: Colors.black54,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
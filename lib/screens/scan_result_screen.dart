// lib/screens/scan_result_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fp_pemrograman/colors.dart';

class ScanResultScreen extends StatelessWidget {
  final String imagePath;
  final Map<String, dynamic> analysisResult;
  final String detectedEczemaType; // Tambahkan ini

  const ScanResultScreen({
    super.key,
    required this.imagePath,
    required this.analysisResult,
    required this.detectedEczemaType, // Tambahkan ini ke required parameters
  });

  @override
  Widget build(BuildContext context) {
    // Ekstrak data dari hasil analisis
    final String detectedType = analysisResult['label'] ?? 'Unknown';
    final double confidence = (analysisResult['confidence'] ?? 0.0) * 100;

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.backgroundLighter, AppColors.mediumBrownish],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text(
            'Hasil Scan', // Ubah teks judul
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold, color: AppColors.darkTeal),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios,
                color: AppColors.primaryOrange),
            onPressed: () => Navigator.of(context).pop(),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ini adalah hasil scan Anda:", // Ubah teks pengantar
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryOrange,
                ),
              ),
              const SizedBox(height: 20),
              ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: Image.file(
                  File(imagePath),
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 24),
              _buildResultCard(
                title: 'Tipe Terdeteksi', // Ubah teks judul kartu
                value: detectedType,
                icon: Icons.biotech_outlined,
                iconColor: AppColors.secondaryTeal,
              ),
              const SizedBox(height: 16),
              _buildResultCard(
                title: 'Tingkat Keyakinan', // Ubah teks judul kartu
                value: '${confidence.toStringAsFixed(1)}%',
                icon: Icons.verified_user_outlined,
                iconColor: AppColors.primaryOrange,
              ),
              const SizedBox(height: 24),
              _buildDisclaimer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultCard({
    required String title,
    required String value,
    required IconData icon,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      decoration: BoxDecoration(
        color: AppColors.backgroundLightest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            spreadRadius: 1,
            blurRadius: 10,
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.primaryOrange,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkTeal,
                  ),
                  softWrap: true,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisclaimer() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.backgroundLightest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Disclaimer:',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: AppColors.darkTeal,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hasil ini dibuat oleh model AI dan bukan pengganti nasihat medis profesional. Silakan konsultasikan dengan dokter kulit untuk diagnosis yang akurat.', // Ubah teks disclaimer
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.darkTeal,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}

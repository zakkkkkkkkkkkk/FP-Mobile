import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fp_pemrograman/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Article1Screen extends StatelessWidget {
  const Article1Screen({super.key});

  // Fungsi untuk meluncurkan URL
  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      // Tidak bisa meluncurkan URL
      print('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon:
              const Icon(Icons.arrow_back_ios, color: AppColors.primaryOrange),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Artikel Kesehatan',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.darkTeal,
          ),
        ),
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundLighter.withOpacity(0.8),
              AppColors.accentBrown.withOpacity(0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle('Cara Mengatasi Eksim'),
              _buildParagraph(
                'Eksim atau dermatitis atopik adalah kondisi kulit yang menyebabkan kulit menjadi kering, merah, gatal, dan meradang. Meskipun tidak menular, eksim dapat sangat mengganggu kenyamanan. Berikut adalah beberapa cara efektif untuk meredakan gejalanya.',
              ),
              const SizedBox(height: 16),
              _buildSubTitle('1. Gunakan Pelembap Secara Teratur'),
              _buildParagraph(
                'Kulit penderita eksim cenderung sangat kering. Menggunakan pelembap (emolien) setidaknya dua kali sehari sangat penting untuk menjaga kelembapan kulit, mengurangi kekeringan, dan melindungi kulit dari iritan.',
              ),
              const SizedBox(height: 16),
              _buildSubTitle('2. Hindari Pemicu Alergi'),
              _buildParagraph(
                'Identifikasi dan hindari faktor yang dapat memicu atau memperburuk eksim Anda. Pemicu umum termasuk sabun atau deterjen yang keras, kain wol, keringat berlebih, stres, serta alergen seperti debu, bulu hewan, atau serbuk sari.',
              ),
              const SizedBox(height: 16),
              _buildSubTitle('3. Mandi dengan Air Hangat'),
              _buildParagraph(
                'Hindari mandi dengan air yang terlalu panas karena dapat menghilangkan minyak alami kulit. Gunakan air hangat dan batasi waktu mandi sekitar 10-15 menit. Setelah mandi, keringkan kulit dengan menepuk-nepuknya secara lembut dan segera oleskan pelembap.',
              ),
              const SizedBox(height: 16),
              _buildSubTitle('4. Gunakan Salep atau Krim Kortikosteroid'),
              _buildParagraph(
                'Untuk meredakan peradangan dan gatal, dokter mungkin meresepkan krim atau salep kortikosteroid. Gunakan sesuai petunjuk dokter pada area kulit yang terkena eksim.',
              ),
              const SizedBox(height: 16),
              _buildSubTitle('5. Jangan Menggaruk'),
              _buildParagraph(
                'Menggaruk dapat merusak kulit dan menyebabkan infeksi. Untuk mengurangi gatal, coba kompres dingin atau gunakan losion kalamin. Pastikan kuku tetap pendek untuk meminimalkan kerusakan jika Anda tidak sengaja menggaruk saat tidur.',
              ),
              const SizedBox(height: 32),
              const Divider(),
              const SizedBox(height: 16),
              _buildSourceLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 26,
        fontWeight: FontWeight.bold,
        color: AppColors.darkTeal,
      ),
    );
  }

  Widget _buildSubTitle(String text) {
    return Text(
      text,
      style: GoogleFonts.poppins(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryOrange,
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 15,
          color: Colors.black87,
          height: 1.6,
        ),
      ),
    );
  }

  Widget _buildSourceLink() {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: GoogleFonts.poppins(fontSize: 14, color: Colors.black54),
          children: [
            const TextSpan(text: 'Sumber artikel asli:\n'),
            TextSpan(
              text: 'https://www.apotek-k24.com',
              style: const TextStyle(
                color: AppColors.secondaryTeal,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(
                      'https://www.apotek-k24.com/tips-sehat/2391/Terkena-Penyakit-Kulit-Eksim?-Ini-5-Cara-untuk-Meredakan-Gejalanya-');
                },
            ),
          ],
        ),
      ),
    );
  }
}

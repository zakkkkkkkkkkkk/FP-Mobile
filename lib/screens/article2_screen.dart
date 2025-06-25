import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fp_pemrograman/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class Article2Screen extends StatelessWidget {
  const Article2Screen({super.key});

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
              _buildTitle('Makanan Baik untuk Penderita Eksim'),
              _buildParagraph(
                'Selain pengobatan, pemilihan makanan yang tepat dapat membantu meredakan gejala eksim. Beberapa makanan diketahui memiliki sifat antiinflamasi yang baik untuk kulit.',
              ),
              const SizedBox(height: 16),
              _buildSubTitle('1. Makanan Mengandung Probiotik'),
              _buildParagraph(
                'Probiotik adalah bakteri baik yang dapat membantu menyeimbangkan sistem kekebalan tubuh dan mengurangi peradangan. Makanan seperti yogurt (pilih yang tanpa tambahan gula), kefir, atau tempe bisa menjadi pilihan yang baik.',
              ),
              const SizedBox(height: 16),
              _buildSubTitle('2. Makanan Kaya Asam Lemak Omega-3'),
              _buildParagraph(
                'Omega-3 terkenal dengan kemampuannya melawan peradangan. Anda bisa menemukannya pada ikan berlemak seperti salmon, sarden, dan makarel. Konsumsi secara teratur dapat membantu mengurangi gejala eksim.',
              ),
              const SizedBox(height: 16),
              _buildSubTitle('3. Makanan yang Mengandung Flavonoid'),
              _buildParagraph(
                'Flavonoid adalah antioksidan kuat yang dapat membantu melindungi sel-sel tubuh dari kerusakan dan peradangan. Buah-buahan dan sayuran berwarna seperti apel, brokoli, bayam, dan ceri kaya akan flavonoid.',
              ),
              const SizedBox(height: 16),
              _buildParagraph(
                  'Penting juga untuk memperhatikan makanan pemicu yang mungkin memperburuk eksim bagi sebagian orang, seperti susu sapi, telur, kedelai, dan gandum. Konsultasikan dengan dokter untuk diet yang paling sesuai.'),
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
              text: 'https://www.alodokter.com',
              style: const TextStyle(
                color: AppColors.secondaryTeal,
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  _launchURL(
                      'https://www.alodokter.com/daftar-makanan-untuk-penderita-eksim');
                },
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fp_pemrograman/colors.dart';
import 'package:fp_pemrograman/screens/article1_screen.dart'; // Import artikel 1
import 'package:fp_pemrograman/screens/article2_screen.dart'; // Import artikel 2
import 'package:fp_pemrograman/screens/nearbyscreen.dart';
import 'package:fp_pemrograman/screens/profile_screen.dart';
import 'package:fp_pemrograman/screens/historyscreen.dart';
import 'package:fp_pemrograman/screens/scan_screen.dart';

// Widget for the main content of the Home page
class HomePageContent extends StatelessWidget {
  const HomePageContent({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final String displayName =
        user?.displayName?.isNotEmpty == true ? user!.displayName! : 'User';

    return ListView(
      padding: const EdgeInsets.fromLTRB(
          24.0, 20.0, 24.0, 120.0), // Padding bawah untuk nav bar
      children: [
        const SizedBox(height: 40), // Spasi dari atas
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.secondaryTeal,
                AppColors.darkTeal.withOpacity(0.8)
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.darkTeal.withOpacity(0.3),
                blurRadius: 15,
                offset: const Offset(0, 8),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Welcome back,',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  color: Colors.white.withOpacity(0.9),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                displayName,
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "How's your skin",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryOrange,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 5,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const ScanHistoryScreen()),
              );
            },
            icon: const Icon(Icons.history, color: Colors.white),
            label: Text(
              'Scan History',
              style: GoogleFonts.poppins(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Text(
          "Tips & Articles",
          style: GoogleFonts.poppins(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 16),
        _buildArticleCard(
          title: "Cara Mengatasi Eksim",
          icon: Icons.article_outlined, // Menggunakan ikon
          onTap: () {
            // Navigasi ke Article1Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Article1Screen()),
            );
          },
        ),
        const SizedBox(height: 12),
        _buildArticleCard(
          title: "Makanan Baik untuk Penderita Eksim",
          icon: Icons.restaurant_menu_outlined, // Menggunakan ikon
          onTap: () {
            // Navigasi ke Article2Screen
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Article2Screen()),
            );
          },
        ),
      ],
    );
  }

  // Widget untuk membuat kartu artikel
  Widget _buildArticleCard({
    required String title,
    required VoidCallback onTap,
    IconData? icon,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
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
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.backgroundLighter,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 40, color: AppColors.darkTeal),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.darkTeal,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Widget utama untuk HomeScreen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const HomePageContent(),
    const ScanScreen(),
    const NearbyScreen(),
  ];

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const ScanScreen()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              width: 32,
              height: 32,
            ),
            const SizedBox(width: 8),
            Text(
              'DermAI',
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: const Color(0xFF093648),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outline,
                color: Color(0xFF093648), size: 30),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const ProfileScreen()),
              );
            },
          ),
          const SizedBox(width: 10),
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColors.backgroundLighter.withOpacity(0.8),
              AppColors.accentBrown.withOpacity(0.6)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            IndexedStack(
              index: _selectedIndex,
              children: [
                SafeArea(child: _widgetOptions[0]),
                _widgetOptions[1],
                _widgetOptions[2],
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _buildCustomNavBar(),
            ),
          ],
        ),
      ),
    );
  }

  // Widget untuk bilah navigasi bawah kustom
  Widget _buildCustomNavBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 20),
      height: 70,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(35),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(Icons.home_outlined, "Home", 0),
          _buildScanButton(),
          _buildNavItem(Icons.place_outlined, "Places", 2),
        ],
      ),
    );
  }

  // Widget untuk item navigasi
  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected ? AppColors.primaryOrange : Colors.grey.shade500,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color:
                  isSelected ? AppColors.primaryOrange : Colors.grey.shade500,
            ),
          )
        ],
      ),
    );
  }

  // Widget untuk tombol pindai
  Widget _buildScanButton() {
    return GestureDetector(
      onTap: () => _onItemTapped(1),
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [AppColors.secondaryTeal, AppColors.darkTeal],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondaryTeal.withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
            ),
          ],
        ),
        child: const Icon(
          Icons.camera_alt_outlined,
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}

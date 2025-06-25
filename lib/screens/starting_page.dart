import 'package:flutter/material.dart';
import 'package:fp_pemrograman/screens/login_screen.dart';
import 'package:fp_pemrograman/screens/register_screen.dart';
import 'package:fp_pemrograman/colors.dart'; // Import your custom colors
import 'package:google_fonts/google_fonts.dart';

class StartingPage extends StatelessWidget {
  const StartingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Remove backgroundColor here as it will be handled by the gradient
      // backgroundColor: AppColors.backgroundLightest,

      // This allows the body content (including the gradient) to extend behind the AppBar
      // if you were to have a transparent AppBar. For StartingPage, it might not be strictly needed,
      // but it's good practice for gradient backgrounds.
      extendBodyBehindAppBar: true,

      body: Stack( // Use Stack to layer widgets
        children: [
          // 1. Gradient Background Layer
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft, // Start of the gradient
                end: Alignment.bottomRight, // End of the gradient
                colors: [
                  AppColors.backgroundLightest, // FFF7E8 (Very light)
                  AppColors.mediumBrownish,    // EDD0BB - or choose another color from your palette
                ],
              ),
            ),
          ),

          // 2. Your existing content (layered on top of the gradient)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo besar
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/logo.png', height: 160),
                        const SizedBox(height: 24),
                        Text(
                          'DermAI',
                          style: GoogleFonts.poppins(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: AppColors.darkTeal,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Your personal eczema\nskin health assistant',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryOrange,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Tombol login
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryOrange,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 5,
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen())),
                      child: Text(
                        'Log In',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.white,
                          fontWeight: FontWeight.w600, // SemiBold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Tombol register
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryOrange,
                        side: BorderSide(color: AppColors.primaryOrange, width: 2),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => RegisterScreen())),
                      child: Text(
                        'Register',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600, // SemiBold
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
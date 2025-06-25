import 'package:flutter/material.dart';

class AppColors {
  // Light to Dark Warm/Neutral Tones (based on the first set of hex codes)
  static const Color backgroundLightest = Color(0xFFFFF7E8); // Very light, almost white
  static const Color backgroundLighter = Color(0xFFF9EADA);  // Light background/accent
  static const Color lightBrownish = Color(0xFFEDD0BB);     // Slightly more saturated light tone
  static const Color mediumBrownish = Color(0xFFDCAC93);    // Medium tone, maybe for accents
  static const Color accentBrown = Color(0xFFC47D5F);      // Stronger accent brown
  static const Color primaryOrange = Color(0xFFB7603C);    // Your main primary orange/brown color

  // Teal/Dark Greenish Tones (based on the second set of hex codes)
  static const Color secondaryTeal = Color(0xFF597879);     // A muted teal/grey-green
  static const Color darkTeal = Color(0xFF224B4C);

  static var inputFill;

  static var primary;         // Very dark teal/green, possibly for text or deep accents

  // Add more specific names if you know their purpose (e.g., 'textColorPrimary', 'buttonColorSecondary')
  // static const Color buttonPrimary = Color(0xFFB7603C);
  // static const Color headlineColor = Color(0xFF224B4C);
}
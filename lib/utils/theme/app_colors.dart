import 'package:flutter/material.dart';

class AppColors {
  // Primary seed color - everything else is derived from here
  static const Color primarySeed = Color(0xFF367D65);

  // Unique colors that don't necessarily depend on the primary seed
  static const Color urgent = Color(0xFFD32F2F);
  static const Color warning = Color(0xFFFFA000);
  static const Color success = Color(0xFF388E3C);
  static const Color info = Color(0xFF1976D2);

  // Specific colors for priority levels or special UI elements
  static const Color priorityHigh = Color(0xFFD38670);
  static const Color priorityMedium = Color(0xFFFBC02D);
  static const Color priorityLow = Color(0xFF81C784);
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MyTextStyle extends TextStyle {
  MyTextStyle({
    super.fontSize,
    super.fontWeight,
    super.color,
    super.letterSpacing,
  }) : super(
          fontFamily: GoogleFonts.plusJakartaSans().fontFamily,
        );
}
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../constants/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      primaryColor: AppColors.mainBlue,
      scaffoldBackgroundColor: AppColors.mainWhite,
      fontFamily: GoogleFonts.lato().fontFamily,
      
      colorScheme: const ColorScheme.light(
        primary: AppColors.mainBlue,
        secondary: AppColors.mainWhite,
        onSurface: AppColors.mainBlue,
      ),
    );
  }
}
import 'package:flutter/material.dart';

import 'app_color.dart';

ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  scaffoldBackgroundColor: AppColors.darkBackground,

  primaryColor: AppColors.primaryBlue,
  fontFamily: "Outfit-Regular",

  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.darkText),
    titleTextStyle: TextStyle(color: AppColors.darkText, fontSize: 20, fontWeight: FontWeight.w600),
  ),

  cardColor: AppColors.darkCard,

  textTheme: const TextTheme(
    bodyLarge: TextStyle(color: AppColors.darkText, fontSize: 20, fontWeight: FontWeight.w600),
    bodyMedium: TextStyle(color: AppColors.darkText, fontSize: 14, fontWeight: FontWeight.w400),
    bodySmall: TextStyle(color: AppColors.darkSubText, fontSize: 12, fontWeight: FontWeight.w400),
    headlineLarge: TextStyle(color: AppColors.darkText, fontSize: 34, fontWeight: FontWeight.w600),
    headlineMedium: TextStyle(color: AppColors.darkText, fontSize: 24, fontWeight: FontWeight.w600),
    headlineSmall: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.w600),
    titleLarge: TextStyle(color: AppColors.darkText, fontSize: 20, fontWeight: FontWeight.w600),
    titleMedium: TextStyle(color: AppColors.darkText, fontSize: 18, fontWeight: FontWeight.w600),
    titleSmall: TextStyle(color: AppColors.darkText, fontSize: 16, fontWeight: FontWeight.w600),
    labelLarge: TextStyle(color: AppColors.darkText, fontSize: 16, fontWeight: FontWeight.w400),
    labelMedium: TextStyle(color: AppColors.darkText, fontSize: 14, fontWeight: FontWeight.w400),
    labelSmall: TextStyle(color: AppColors.darkSubText, fontSize: 12, fontWeight: FontWeight.w400),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.darkCard,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
    hintStyle: const TextStyle(color: AppColors.darkSubText),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),
);

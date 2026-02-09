import 'package:flutter/material.dart';

import 'app_color.dart';

ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.lightBackground,

  primaryColor: AppColors.primaryBlue,
  fontFamily: "Outfit-Regular",
  disabledColor: AppColors.lightGrey100,
  hintColor: AppColors.lightSubText,
  
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.transparent,
    elevation: 0,
    iconTheme: IconThemeData(color: AppColors.lightText),
    titleTextStyle: TextStyle(
      color: AppColors.lightText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
  ),

  colorScheme: ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primaryBlue,
    onPrimary: AppColors.darkBackground,
    secondary: AppColors.lightBackground,
    onSecondary: AppColors.darkSubText,
    error: Colors.red,
    onError: Colors.red,
    surface: AppColors.lightBackground,
    onSurface: AppColors.lightBackground,
  ),
  cardColor: AppColors.lightCard,

  textTheme: const TextTheme(
    bodyLarge: TextStyle(
      color: AppColors.lightText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    bodyMedium: TextStyle(
      color: AppColors.lightText,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    bodySmall: TextStyle(
      color: AppColors.lightSubText,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
    headlineLarge: TextStyle(
      color: AppColors.lightText,
      fontSize: 34,
      fontWeight: FontWeight.w600,
    ),
    headlineMedium: TextStyle(
      color: AppColors.lightText,
      fontSize: 24,
      fontWeight: FontWeight.w600,
    ),
    headlineSmall: TextStyle(
      color: AppColors.lightText,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleLarge: TextStyle(
      color: AppColors.lightText,
      fontSize: 20,
      fontWeight: FontWeight.w600,
    ),
    titleMedium: TextStyle(
      color: AppColors.lightText,
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
    titleSmall: TextStyle(
      color: AppColors.lightText,
      fontSize: 16,
      fontWeight: FontWeight.w600,
    ),
    labelLarge: TextStyle(
      color: AppColors.lightText,
      fontSize: 16,
      fontWeight: FontWeight.w400,
    ),
    labelMedium: TextStyle(
      color: AppColors.lightText,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
    labelSmall: TextStyle(
      color: AppColors.lightSubText,
      fontSize: 12,
      fontWeight: FontWeight.w400,
    ),
  ),

  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: AppColors.lightCard,
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    hintStyle: const TextStyle(color: AppColors.lightSubText),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primaryBlue,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 14),
    ),
  ),
  tabBarTheme: TabBarThemeData(
    indicatorColor: AppColors.lightBackground,
    // selected/unselected styling
    labelColor: AppColors.darkTextColor,
    labelPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
    labelStyle: TextStyle(),
    unselectedLabelColor: AppColors.lightSubText,
    unselectedLabelStyle: TextStyle(),
    dividerColor: Colors.transparent,
    dividerHeight: 0,
  ),
);

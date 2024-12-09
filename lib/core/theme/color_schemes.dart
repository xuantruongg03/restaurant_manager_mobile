import 'package:flutter/material.dart';

class AppColors {
  // Prevent instantiation
  const AppColors._();

  // Brand Colors
  static const Color primary = Color(0xFFF29121);  // Orange brand color
  static const Color secondary = Color(0xFF2B2D42);
  static const Color background = Color(0xFFF2F4F7);
  
  // Semantic Colors
  static const Color error = Color(0xFFDC3545);
  static const Color success = Color(0xFF28A745);
  static const Color warning = Color(0xFFFFC107);
  static const Color info = Color(0xFF17A2B8);
  
  // Neutral Colors
  static const Color outline = Color(0xFF7C8EA9);
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color disableButton = Color.fromARGB(255, 102, 94, 94);
  static const Color link = Color(0xFF7C8EA9);

  // Light Color Scheme
  static const ColorScheme lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: primary,
    secondary: secondary,
    error: error,
    surface: lightSurface,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onError: Colors.white,
    onSurface: secondary,
  );

  // Dark Color Scheme
  static const ColorScheme darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: primary,
    secondary: secondary,
    error: error,
    surface: darkSurface,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onError: Colors.white,
    onSurface: Colors.white,
  );
}
import 'package:flutter/material.dart';

class AppTheme {
  // Colors
  static const Color black = Color(0xFF0A0A0A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color cardGrey = Color(0xFFEEEEEE);
  static const Color textGrey = Color(0xFF666666);
  static const Color yellow = Color(0xFFFFE234);

  // Text Styles
  static const TextStyle heroTitle = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.bold,
    color: white,
    height: 1.2,
  );

  static const TextStyle heroSubtitle = TextStyle(
    fontSize: 13,
    color: Color(0xFFAAAAAA),
    height: 1.5,
  );

  static const TextStyle sectionTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: black,
  );

  static const TextStyle featureTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: black,
    height: 1.3,
  );

  static const TextStyle featureBody = TextStyle(
    fontSize: 12,
    color: textGrey,
    height: 1.5,
  );

  static const TextStyle bookTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.bold,
    color: black,
  );

  static const TextStyle bookAuthor = TextStyle(fontSize: 12, color: textGrey);

  static const TextStyle navBrand = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: white,
  );

  static const TextStyle footerBrand = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: white,
  );

  static const TextStyle footerLink = TextStyle(
    fontSize: 12,
    color: Color(0xFFAAAAAA),
  );

  static ThemeData get theme => ThemeData(
    scaffoldBackgroundColor: white,
    fontFamily: 'Georgia',
    colorScheme: ColorScheme.fromSeed(seedColor: black),
    useMaterial3: true,
  );
}

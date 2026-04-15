import 'package:flutter/material.dart';

class AppFeature {
  final int number;
  final String title;
  final String description;
  final IconData icon;
  final Color iconColor;

  const AppFeature({
    required this.number,
    required this.title,
    required this.description,
    required this.icon,
    this.iconColor = Colors.black,
  });
}

import 'package:flutter/material.dart';
import '../models/feature.dart';
import '../core/theme.dart';

class FeatureCard extends StatelessWidget {
  final AppFeature feature;

  const FeatureCard({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E0E0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _BookIconWithOverlay(feature: feature),
          const SizedBox(height: 10),
          _NumberBadge(number: feature.number),
          const SizedBox(height: 6),
          Text(feature.title, style: AppTheme.featureTitle),
          const SizedBox(height: 4),
          Text(feature.description, style: AppTheme.featureBody),
        ],
      ),
    );
  }
}

class _BookIconWithOverlay extends StatelessWidget {
  final AppFeature feature;

  const _BookIconWithOverlay({required this.feature});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            child: Container(
              width: 65,
              height: 85,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF888888), Color(0xFF333333)],
                ),
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          Positioned(
            right: 10,
            bottom: 0,
            child: Icon(feature.icon, size: 32, color: feature.iconColor),
          ),
        ],
      ),
    );
  }
}

class _NumberBadge extends StatelessWidget {
  final int number;

  const _NumberBadge({required this.number});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(4),
      ),
      alignment: Alignment.center,
      child: Text(
        '$number',
        style: const TextStyle(
          color: AppTheme.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

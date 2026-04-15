import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onGetStarted;

  const HeroSection({super.key, this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.black,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'A Comprehensive Books Website',
            style: AppTheme.heroTitle,
          ),
          const SizedBox(height: 12),
          const Text(
            'Catalogs is a book library website that provides you with all the features any reader would need.',
            style: AppTheme.heroSubtitle,
          ),
          const SizedBox(height: 24),
          _GetStartedButton(onTap: onGetStarted),
          const SizedBox(height: 40),
          _HeroIllustration(),
        ],
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final VoidCallback? onTap;

  const _GetStartedButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Text(
          'Get Started',
          style: TextStyle(
            color: AppTheme.black,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

class _HeroIllustration extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _IllustrationItem(icon: Icons.menu_book, label: 'Book', size: 80),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Icon(Icons.arrow_forward, color: Color(0xFF888888), size: 32),
        ),
        _IllustrationItem(icon: Icons.smartphone, label: 'Phone', size: 60),
        const SizedBox(width: 12),
        _BadgeSticker(),
      ],
    );
  }
}

class _IllustrationItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double size;

  const _IllustrationItem({
    required this.icon,
    required this.label,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFF555555), width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.white, size: size * 0.5),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: const TextStyle(color: Color(0xFFAAAAAA), fontSize: 12),
        ),
      ],
    );
  }
}

class _BadgeSticker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -0.2,
      child: Container(
        width: 70,
        height: 70,
        decoration: const BoxDecoration(
          color: AppTheme.yellow,
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: const Text(
          'Best\nBooks\nApp\nEver!',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 9,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
      ),
    );
  }
}

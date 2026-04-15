import 'package:flutter/material.dart';
import '../core/theme.dart';

class AppFooter extends StatelessWidget {
  const AppFooter({super.key});

  static const List<String> _links = ['About', 'Contact', 'Privacy', 'Terms'];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.black,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Catalogs', style: AppTheme.footerBrand),
              Wrap(
                spacing: 16,
                children: _links
                    .map(
                      (l) => GestureDetector(
                        onTap: () {},
                        child: Text(l, style: AppTheme.footerLink),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Align(
            alignment: Alignment.centerRight,
            child: Text('© 2026 Catalogs', style: AppTheme.footerLink),
          ),
        ],
      ),
    );
  }
}

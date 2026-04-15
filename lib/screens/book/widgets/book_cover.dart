import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class BookCover extends StatelessWidget {
  final String? coverUrl;
  final bool isSeries;

  const BookCover({super.key, this.coverUrl, this.isSeries = false});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 180,
        height: 260,
        decoration: BoxDecoration(
          color: AppTheme.cardGrey,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: coverUrl != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  coverUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => _placeholder(),
                ),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Center(
      child: Text(
        isSeries ? 'Series Cover' : 'Book Cover',
        style: const TextStyle(color: AppTheme.textGrey, fontSize: 13),
      ),
    );
  }
}

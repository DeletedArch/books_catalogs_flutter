import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/book.dart';
import '../../../widgets/book_card.dart';

class BestSellersSection extends StatelessWidget {
  final List<Book> books;
  final void Function(Book book)? onBookTap;

  const BestSellersSection({super.key, required this.books, this.onBookTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Best-Selling Books on Our Website:',
            style: AppTheme.sectionTitle,
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 220, // increased from 210 to give text breathing room
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, index) => BookCard(
                book: books[index],
                onTap: onBookTap != null
                    ? () => onBookTap!(books[index])
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

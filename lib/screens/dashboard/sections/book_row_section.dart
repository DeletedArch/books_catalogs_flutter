import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/book.dart';
import '../../../widgets/book_card.dart';

class BookRowSection extends StatelessWidget {
  final String title;
  final List<Book> books;
  final void Function(Book)? onBookTap;

  const BookRowSection({
    super.key,
    required this.title,
    required this.books,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.sectionTitle),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
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

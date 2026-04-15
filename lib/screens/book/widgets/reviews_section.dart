import 'package:flutter/material.dart';
import '../../../models/review.dart';
import 'review_card.dart';

class ReviewsSection extends StatelessWidget {
  final List<Review> reviews;
  final bool isAuthor;
  final void Function(Review)? onDeleteReview;

  const ReviewsSection({
    super.key,
    required this.reviews,
    this.isAuthor = false,
    this.onDeleteReview,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Reviews',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        if (reviews.isEmpty)
          const Text(
            'No reviews yet. Be the first!',
            style: TextStyle(color: Color(0xFF888888), fontSize: 13),
          )
        else
          ...reviews.map(
            (r) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ReviewCard(
                review: r,
                showDelete: isAuthor,
                onDelete: onDeleteReview != null
                    ? () => onDeleteReview!(r)
                    : null,
              ),
            ),
          ),
      ],
    );
  }
}

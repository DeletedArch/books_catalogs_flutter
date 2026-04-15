import 'package:flutter/material.dart';

class StarRating extends StatelessWidget {
  final double rating;
  final double size;
  final bool interactive;
  final void Function(double)? onRatingChanged;

  const StarRating({
    super.key,
    required this.rating,
    this.size = 20,
    this.interactive = false,
    this.onRatingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (index) {
        final filled = index < rating.floor();
        final half = !filled && index < rating;
        return GestureDetector(
          onTap: interactive ? () => onRatingChanged?.call(index + 1.0) : null,
          child: Icon(
            filled
                ? Icons.star
                : half
                ? Icons.star_half
                : Icons.star_border,
            color: (filled || half)
                ? const Color(0xFFFFC107)
                : const Color(0xFFCCCCCC),
            size: size,
          ),
        );
      }),
    );
  }
}

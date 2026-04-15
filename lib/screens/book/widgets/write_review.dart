import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'star_rating.dart';

class WriteReviewSection extends StatefulWidget {
  final bool isSeries;
  final void Function(double rating, String content)? onSubmit;

  const WriteReviewSection({super.key, this.isSeries = false, this.onSubmit});

  @override
  State<WriteReviewSection> createState() => _WriteReviewSectionState();
}

class _WriteReviewSectionState extends State<WriteReviewSection> {
  final _controller = TextEditingController();
  double _selectedRating = 0;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    if (_controller.text.trim().isEmpty) return;
    widget.onSubmit?.call(_selectedRating, _controller.text.trim());
    _controller.clear();
    setState(() => _selectedRating = 0);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Write a Review',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        StarRating(
          rating: _selectedRating,
          size: 28,
          interactive: true,
          onRatingChanged: (r) => setState(() => _selectedRating = r),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: TextField(
            controller: _controller,
            maxLines: 5,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText:
                  'Share your thoughts about this ${widget.isSeries ? "series" : "book"}...',
              hintStyle: const TextStyle(
                color: Color(0xFFAAAAAA),
                fontSize: 13,
              ),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(14),
            ),
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _handleSubmit,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.black,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'Submit Review',
              style: TextStyle(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme.dart';

// Shown only when isAuthor == true
class AuthorActionBar extends StatelessWidget {
  final VoidCallback? onDelete;
  final VoidCallback? onEdit;

  const AuthorActionBar({super.key, this.onDelete, this.onEdit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _DeleteButton(onTap: onDelete),
        const SizedBox(width: 8),
        _EditButton(onTap: onEdit),
      ],
    );
  }
}

class _DeleteButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _DeleteButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFFFCDD2),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFEF9A9A)),
        ),
        child: const Text(
          'Delete',
          style: TextStyle(
            color: Color(0xFFC62828),
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

class _EditButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _EditButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCCCCCC)),
        ),
        child: const Text(
          'Edit',
          style: TextStyle(
            color: AppTheme.black,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import 'settings_card.dart';

// Only rendered when user.isAuthor == true
class ManagementSection extends StatelessWidget {
  final VoidCallback? onAddBook;

  const ManagementSection({super.key, this.onAddBook});

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Management',
      child: SizedBox(
        width: double.infinity,
        height: 48,
        child: ElevatedButton(
          onPressed: onAddBook,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppTheme.black,
            foregroundColor: AppTheme.white,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: const Text(
            'Add Book',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    );
  }
}

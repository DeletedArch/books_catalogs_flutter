import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class BookActionButtons extends StatelessWidget {
  final VoidCallback? onRead;
  final VoidCallback? onDownload;

  const BookActionButtons({super.key, this.onRead, this.onDownload});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _ReadButton(onTap: onRead)),
        const SizedBox(width: 12),
        Expanded(child: _DownloadButton(onTap: onDownload)),
      ],
    );
  }
}

class _ReadButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _ReadButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppTheme.black,
          borderRadius: BorderRadius.circular(6),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.menu_book, color: AppTheme.white, size: 16),
            SizedBox(width: 8),
            Text(
              'Read',
              style: TextStyle(
                color: AppTheme.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DownloadButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _DownloadButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 46,
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCCCCCC)),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.download, color: AppTheme.black, size: 16),
            SizedBox(width: 8),
            Text(
              'Download',
              style: TextStyle(
                color: AppTheme.black,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

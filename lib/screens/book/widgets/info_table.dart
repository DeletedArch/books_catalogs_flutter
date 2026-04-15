import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class InfoTable extends StatelessWidget {
  final String title;
  final List<InfoRow> rows;

  const InfoTable({super.key, required this.title, required this.rows});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: const Color(0xFFE0E0E0)),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: rows.asMap().entries.map((entry) {
              final isLast = entry.key == rows.length - 1;
              return _TableRow(row: entry.value, isLast: isLast);
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class InfoRow {
  final String label;
  final String value;

  const InfoRow(this.label, this.value);
}

class _TableRow extends StatelessWidget {
  final InfoRow row;
  final bool isLast;

  const _TableRow({required this.row, required this.isLast});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: isLast
            ? null
            : const Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          Container(
            width: 130,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Text(
              row.label,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.black,
              ),
            ),
          ),
          Container(width: 1, height: 44, color: const Color(0xFFEEEEEE)),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              child: Text(
                row.value,
                style: const TextStyle(fontSize: 13, color: AppTheme.textGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

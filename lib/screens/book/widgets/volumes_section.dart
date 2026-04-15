import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/volume.dart';

class VolumesSection extends StatefulWidget {
  final List<Volume> volumes;
  final void Function(Volume)? onRead;
  final void Function(Volume)? onDownload;

  const VolumesSection({
    super.key,
    required this.volumes,
    this.onRead,
    this.onDownload,
  });

  @override
  State<VolumesSection> createState() => _VolumesSectionState();
}

class _VolumesSectionState extends State<VolumesSection> {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: const Color(0xFFE0E0E0)),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          _Header(
            count: widget.volumes.length,
            expanded: _expanded,
            onToggle: () => setState(() => _expanded = !_expanded),
          ),
          if (_expanded)
            ...widget.volumes.map(
              (v) => _VolumeRow(
                volume: v,
                onRead: widget.onRead != null ? () => widget.onRead!(v) : null,
                onDownload: widget.onDownload != null
                    ? () => widget.onDownload!(v)
                    : null,
              ),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final int count;
  final bool expanded;
  final VoidCallback onToggle;

  const _Header({
    required this.count,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onToggle,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: const BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Volumes ($count)',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
            Icon(
              expanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class _VolumeRow extends StatelessWidget {
  final Volume volume;
  final VoidCallback? onRead;
  final VoidCallback? onDownload;

  const _VolumeRow({required this.volume, this.onRead, this.onDownload});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: Color(0xFFEEEEEE))),
      ),
      child: Row(
        children: [
          // Mini cover
          Container(
            width: 40,
            height: 54,
            decoration: BoxDecoration(
              color: AppTheme.cardGrey,
              borderRadius: BorderRadius.circular(4),
            ),
            alignment: Alignment.center,
            child: Text(
              'Vol\n${volume.number}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 9,
                color: AppTheme.textGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Volume ${volume.number}: ${volume.title}',
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '${volume.pages} pages',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppTheme.textGrey,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _SmallButton(
                label: 'Read',
                icon: Icons.menu_book,
                filled: true,
                onTap: onRead,
              ),
              const SizedBox(width: 6),
              _SmallButton(
                label: 'Download',
                icon: Icons.download,
                filled: false,
                onTap: onDownload,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SmallButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback? onTap;

  const _SmallButton({
    required this.label,
    required this.icon,
    required this.filled,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: filled ? AppTheme.black : AppTheme.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: filled ? AppTheme.black : const Color(0xFFCCCCCC),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 12,
              color: filled ? AppTheme.white : AppTheme.black,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: filled ? AppTheme.white : AppTheme.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

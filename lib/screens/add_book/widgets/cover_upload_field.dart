import 'package:flutter/material.dart';
import '../../../core/theme.dart';

class CoverUploadField extends StatefulWidget {
  final void Function(String? imagePath) onImageSelected;

  const CoverUploadField({super.key, required this.onImageSelected});

  @override
  State<CoverUploadField> createState() => _CoverUploadFieldState();
}

class _CoverUploadFieldState extends State<CoverUploadField> {
  String? _previewPath;

  void _handleTap() {
    // TODO: Use image_picker package for real implementation:
    // final picker = ImagePicker();
    // final file = await picker.pickImage(source: ImageSource.gallery);
    // if (file != null) { setState(() => _previewPath = file.path); }
    // widget.onImageSelected(file?.path);

    // Mock: just show picked state
    setState(() => _previewPath = 'mock_selected');
    widget.onImageSelected('mock_cover_path');

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text(
          'Image picker not configured — add image_picker package.',
        ),
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _handleClear() {
    setState(() => _previewPath = null);
    widget.onImageSelected(null);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Book Cover',
          style: TextStyle(fontSize: 13, color: AppTheme.black),
        ),
        const SizedBox(height: 6),
        GestureDetector(
          onTap: _handleTap,
          child: Container(
            width: double.infinity,
            height: 140,
            decoration: BoxDecoration(
              color: AppTheme.cardGrey,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFDDDDDD)),
            ),
            alignment: Alignment.center,
            child: _previewPath != null
                ? Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 40,
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: GestureDetector(
                          onTap: _handleClear,
                          child: Container(
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            padding: const EdgeInsets.all(4),
                            child: const Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 14,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                : const Text(
                    'Upload Cover Image',
                    style: TextStyle(color: AppTheme.textGrey, fontSize: 13),
                  ),
          ),
        ),
      ],
    );
  }
}

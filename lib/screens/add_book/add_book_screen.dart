import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/add_book_request.dart';
import '../../models/user.dart';
import '../../repositories/catalog_repository.dart';
import '../../services/catalog_service.dart';
import '../../widgets/app_navbar.dart';
import '../../widgets/app_footer.dart';
import 'widgets/form_field_pair.dart';
import 'widgets/cover_upload_field.dart';

class AddBookScreen extends StatefulWidget {
  final AppUser currentUser;
  final VoidCallback? onCancel;
  final VoidCallback? onBookAdded;
  final VoidCallback? onCharts;
  final VoidCallback? onAI;
  final VoidCallback? onAccount;
  final VoidCallback? onBrandTap; // ADD THIS

  const AddBookScreen({
    super.key,
    required this.currentUser,
    this.onCancel,
    this.onBookAdded,
    this.onCharts,
    this.onAI,
    this.onAccount,
    this.onBrandTap, // ADD THIS
  });

  @override
  State<AddBookScreen> createState() => _AddBookScreenState();
}

class _AddBookScreenState extends State<AddBookScreen> {
  final _searchController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final CatalogRepository _catalogRepo = MockCatalogService();

  // Controllers
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _yearController = TextEditingController();
  final _publisherController = TextEditingController();
  final _pagesController = TextEditingController();
  final _languageController = TextEditingController();
  final _isbnController = TextEditingController();
  final _genreController = TextEditingController();

  String? _coverPath;
  bool _isLoading = false;
  List<String> _errors = [];

  @override
  void dispose() {
    _searchController.dispose();
    _titleController.dispose();
    _authorController.dispose();
    _descriptionController.dispose();
    _yearController.dispose();
    _publisherController.dispose();
    _pagesController.dispose();
    _languageController.dispose();
    _isbnController.dispose();
    _genreController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _isLoading = true;
      _errors = [];
    });

    final request = AddBookRequest(
      title: _titleController.text,
      author: _authorController.text,
      description: _descriptionController.text,
      publishedYear: _yearController.text,
      publisher: _publisherController.text,
      pages: int.tryParse(_pagesController.text) ?? 0,
      language: _languageController.text,
      isbn: _isbnController.text,
      genre: _genreController.text,
      coverUrl: _coverPath,
    );

    final response = await _catalogRepo.addBook(request);

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (response.isOk) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Book added successfully!')));
      widget.onBookAdded?.call();
    } else {
      setState(() {
        _errors = response.errors.isNotEmpty
            ? response.errors
            : [response.message ?? 'Failed to add book.'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EE),
      body: Column(
        children: [
          AppNavbar(
            searchController: _searchController,
            currentUser: widget.currentUser,
            onCharts: widget.onCharts,
            onAI: widget.onAI,
            onAccount: widget.onAccount,
            onBrandTap: widget.onBrandTap, // ADD THIS
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: Column(
                children: [
                  const Text(
                    'Add Book',
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 28),

                  // Form card
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: AppTheme.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Row 1: Title + Author
                          FormFieldPair(
                            leftLabel: 'Title *',
                            leftController: _titleController,
                            rightLabel: 'Author *',
                            rightController: _authorController,
                          ),
                          const SizedBox(height: 16),

                          // Description full width
                          SingleFormField(
                            label: 'Description *',
                            controller: _descriptionController,
                            maxLines: 4,
                          ),
                          const SizedBox(height: 16),

                          // Row 2: Year + Publisher
                          FormFieldPair(
                            leftLabel: 'Published Year *',
                            leftController: _yearController,
                            rightLabel: 'Publisher *',
                            rightController: _publisherController,
                            leftKeyboard: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // Row 3: Pages + Language
                          FormFieldPair(
                            leftLabel: 'Pages *',
                            leftController: _pagesController,
                            rightLabel: 'Language *',
                            rightController: _languageController,
                            leftKeyboard: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // Row 4: ISBN + Genre
                          FormFieldPair(
                            leftLabel: 'ISBN *',
                            leftController: _isbnController,
                            rightLabel: 'Genre *',
                            rightController: _genreController,
                          ),
                          const SizedBox(height: 16),

                          // Cover upload
                          CoverUploadField(
                            onImageSelected: (path) => _coverPath = path,
                          ),

                          // Errors
                          if (_errors.isNotEmpty) ...[
                            const SizedBox(height: 12),
                            ..._errors.map(
                              (e) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  '• $e',
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ),
                          ],

                          const SizedBox(height: 24),

                          // Action buttons
                          Row(
                            children: [
                              _SubmitButton(
                                isLoading: _isLoading,
                                onTap: _handleSubmit,
                              ),
                              const SizedBox(width: 12),
                              _CancelButton(onTap: widget.onCancel),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _SubmitButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
          color: AppTheme.black,
          borderRadius: BorderRadius.circular(6),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: AppTheme.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Add Book',
                style: TextStyle(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

class _CancelButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _CancelButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 13),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCCCCCC)),
        ),
        child: const Text(
          'Cancel',
          style: TextStyle(
            color: AppTheme.black,
            fontWeight: FontWeight.w500,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}

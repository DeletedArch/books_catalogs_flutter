import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/book_detail.dart';
import '../../models/review.dart';
import '../../models/user.dart';
import '../../repositories/book_repository.dart';
import '../../services/book_service.dart';
import '../../widgets/app_navbar.dart';
import '../../widgets/app_footer.dart';
import 'widgets/book_cover.dart';
import 'widgets/star_rating.dart';
import 'widgets/author_action_bar.dart';
import 'widgets/action_buttons.dart';
import 'widgets/volumes_section.dart';
import 'widgets/info_table.dart';
import 'widgets/ratings_section.dart';
import 'widgets/reviews_section.dart';
import 'widgets/write_review.dart';

class BookDetailScreen extends StatefulWidget {
  final String bookId;
  final AppUser currentUser;
  final VoidCallback? onBack;
  final VoidCallback? onCharts;
  final VoidCallback? onAI;
  final VoidCallback? onAccount;
  final VoidCallback? onBrandTap; // ADD THIS

  const BookDetailScreen({
    super.key,
    required this.bookId,
    required this.currentUser,
    this.onBack,
    this.onCharts,
    this.onAI,
    this.onAccount,
    this.onBrandTap, // ADD THIS
  });

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  final _searchController = TextEditingController();

  // Inject repository — swap MockBookService for RemoteBookService later
  final BookRepository _bookRepo = MockBookService();

  BookDetail? _book;
  bool _isAuthor = false;
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadBook();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadBook() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });

      final book = await _bookRepo.getBookById(widget.bookId);
      final isAuthor = await _bookRepo.isAuthor(
        bookId: widget.bookId,
        username: widget.currentUser.username,
      );

      if (!mounted) return;
      setState(() {
        _book = book;
        _isAuthor = isAuthor;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDeleteReview(Review review) async {
    await _bookRepo.deleteReview(bookId: widget.bookId, reviewId: review.id);
    await _loadBook();
  }

  Future<void> _handleSubmitReview(double rating, String content) async {
    final review = Review(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      username: widget.currentUser.username,
      rating: rating,
      content: content,
      date: DateTime.now(),
    );
    await _bookRepo.submitReview(bookId: widget.bookId, review: review);
    await _loadBook();

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Review submitted!')));
    }
  }

  Future<void> _handleDeleteBook() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete Book'),
        content: const Text('Are you sure you want to delete this book?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _bookRepo.deleteBook(widget.bookId);
      if (mounted) widget.onBack?.call();
    }
  }

  void _handleEdit() {
    // TODO: Navigate to edit screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Edit screen coming soon')));
  }

  void _handleAddToList() {
    // TODO: Show add to list sheet
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add to List coming soon')));
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
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? _ErrorView(error: _error!, onRetry: _loadBook)
                : _BookContent(
                    book: _book!,
                    isAuthor: _isAuthor,
                    onDelete: _handleDeleteBook,
                    onEdit: _handleEdit,
                    onAddToList: _handleAddToList,
                    onDeleteReview: _handleDeleteReview,
                    onSubmitReview: _handleSubmitReview,
                  ),
          ),
        ],
      ),
    );
  }
}

// ─── Main content — separated for clarity ────────────────────────────────────

class _BookContent extends StatelessWidget {
  final BookDetail book;
  final bool isAuthor;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final VoidCallback onAddToList;
  final void Function(Review) onDeleteReview;
  final void Function(double, String) onSubmitReview;

  const _BookContent({
    required this.book,
    required this.isAuthor,
    required this.onDelete,
    required this.onEdit,
    required this.onAddToList,
    required this.onDeleteReview,
    required this.onSubmitReview,
  });

  List<InfoRow> _buildInfoRows() {
    final rows = <InfoRow>[];
    if (book.publishedYear != null)
      rows.add(InfoRow('Published Year', book.publishedYear!));
    if (book.publisher != null) rows.add(InfoRow('Publisher', book.publisher!));
    if (!book.isSeries && book.pages != null)
      rows.add(InfoRow('Pages', '${book.pages}'));
    if (book.language != null) rows.add(InfoRow('Language', book.language!));
    if (book.isSeries) rows.add(InfoRow('Volumes', '${book.volumes.length}'));
    if (!book.isSeries && book.isbn != null)
      rows.add(InfoRow('ISBN', book.isbn!));
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top action row
                if (isAuthor)
                  AuthorActionBar(onDelete: onDelete, onEdit: onEdit)
                else
                  Align(
                    alignment: Alignment.centerRight,
                    child: _AddToListButton(onTap: onAddToList),
                  ),

                const SizedBox(height: 16),

                // Cover
                BookCover(coverUrl: book.coverUrl, isSeries: book.isSeries),

                const SizedBox(height: 20),

                // Title & author
                Center(
                  child: Text(
                    book.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Center(
                  child: Text(
                    book.author,
                    style: const TextStyle(
                      fontSize: 15,
                      color: AppTheme.textGrey,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                const Center(child: StarRating(rating: 0, interactive: false)),

                const SizedBox(height: 24),

                // Description
                const Text(
                  'Description',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  book.description,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 1.6,
                    color: AppTheme.textGrey,
                  ),
                ),

                const SizedBox(height: 20),

                // Read / Download buttons
                BookActionButtons(onRead: () {}, onDownload: () {}),

                const SizedBox(height: 24),

                // Volumes (series only)
                if (book.isSeries && book.volumes.isNotEmpty) ...[
                  VolumesSection(volumes: book.volumes),
                  const SizedBox(height: 24),
                ],

                // Info table
                InfoTable(
                  title: book.isSeries
                      ? 'Series Information'
                      : 'Book Information',
                  rows: _buildInfoRows(),
                ),

                const SizedBox(height: 24),

                // Ratings
                RatingsSection(
                  averageRating: book.averageRating,
                  ratingCount: book.ratingCount,
                ),

                const SizedBox(height: 24),

                // Reviews
                ReviewsSection(
                  reviews: book.reviews,
                  isAuthor: isAuthor,
                  onDeleteReview: onDeleteReview,
                ),

                const SizedBox(height: 24),

                // Write review
                WriteReviewSection(
                  isSeries: book.isSeries,
                  onSubmit: onSubmitReview,
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }
}

class _AddToListButton extends StatelessWidget {
  final VoidCallback? onTap;
  const _AddToListButton({this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFCCCCCC)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.add, size: 14, color: AppTheme.black),
            SizedBox(width: 4),
            Text(
              'Add to List',
              style: TextStyle(fontSize: 13, color: AppTheme.black),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String error;
  final VoidCallback onRetry;

  const _ErrorView({required this.error, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text(error, textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}

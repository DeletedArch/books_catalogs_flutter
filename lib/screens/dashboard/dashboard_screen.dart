import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/mock_data.dart';
import '../../models/book.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_navbar.dart';
import '../../widgets/app_footer.dart';
import '../../widgets/book_card.dart';
import '../book/book_detail_screen.dart';
import '../search/search_screen.dart';
import '../charts/charts_screen.dart';
import '../account/account_settings_screen.dart';
import '../add_book/add_book_screen.dart';

class DashboardScreen extends StatefulWidget {
  final AppUser user;
  final VoidCallback? onLogout;
  final void Function(Book book)? onBookTap;
  final VoidCallback? onCharts;
  final VoidCallback? onAI;
  final VoidCallback? onAccount;
  final void Function(String query)? onSearch;
  final VoidCallback? onBrandTap; // ADD THIS

  const DashboardScreen({
    super.key,
    required this.user,
    this.onLogout,
    this.onBookTap,
    this.onCharts,
    this.onAI,
    this.onAccount,
    this.onSearch,
    this.onBrandTap, // ADD THIS
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();
  final _authService = AuthService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleBookTap(Book book) {
    widget.onBookTap?.call(book);
  }

  void _handleLogout() {
    _authService.logout();
    widget.onLogout?.call();
  }

  void _handleCharts() {
    widget.onCharts?.call();
  }

  void _handleAI() {
    widget.onAI?.call();
  }

  void _handleAccount() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AccountSheet(
        user: widget.user,
        onSettings: () {
          Navigator.pop(context);
          widget.onAccount?.call();
        },
        onLogout: () {
          Navigator.pop(context);
          _handleLogout();
        },
      ),
    );
  }

  void _handleSearch(String query) {
    widget.onSearch?.call(query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: Column(
        children: [
          AppNavbar(
            searchController: _searchController,
            currentUser: widget.user,
            onCharts: _handleCharts,
            onAI: _handleAI,
            onAccount: _handleAccount,
            onSearch: _handleSearch,
            onBrandTap: widget.onBrandTap, // ADD THIS
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _BookRowSection(
                    title: 'Recently Added',
                    books: MockData.recentlyAdded,
                    onBookTap: _handleBookTap,
                  ),
                  const _Divider(),
                  _BookRowSection(
                    title: 'Recommended for You',
                    books: MockData.recommended,
                    onBookTap: _handleBookTap,
                  ),
                  const _Divider(),
                  _BookRowSection(
                    title: 'Popular This Week',
                    books: MockData.popularThisWeek,
                    onBookTap: _handleBookTap,
                  ),
                  const _Divider(),
                  _BookRowSection(
                    title: 'New Releases',
                    books: MockData.newReleases,
                    onBookTap: _handleBookTap,
                  ),
                  const AppFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _BookRowSection extends StatelessWidget {
  final String title;
  final List<Book> books;
  final void Function(Book)? onBookTap;

  const _BookRowSection({
    required this.title,
    required this.books,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTheme.sectionTitle),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: books.length,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) => BookCard(
                book: books[index],
                onTap: onBookTap != null
                    ? () => onBookTap!(books[index])
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1, thickness: 1, color: Color(0xFFEEEEEE));
  }
}

class _AccountSheet extends StatelessWidget {
  final AppUser user;
  final VoidCallback onSettings;
  final VoidCallback onLogout;

  const _AccountSheet({
    required this.user,
    required this.onSettings,
    required this.onLogout,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 36,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFDDDDDD),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Avatar
          const CircleAvatar(
            radius: 32,
            backgroundColor: AppTheme.black,
            child: Icon(Icons.person, color: AppTheme.white, size: 32),
          ),
          const SizedBox(height: 12),

          // Username
          Text(
            user.username,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),

          // Email
          Text(user.email, style: const TextStyle(color: AppTheme.textGrey)),

          // Author badge
          if (user.isAuthor) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF9C4),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFF9A825)),
              ),
              child: const Text(
                'Author',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFF57F17),
                ),
              ),
            ),
          ],

          const SizedBox(height: 24),

          // Account Settings button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onSettings,
              icon: const Icon(Icons.settings, size: 16),
              label: const Text('Account Settings'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppTheme.black,
                side: const BorderSide(color: Color(0xFFCCCCCC)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 10),

          // Log Out button
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: onLogout,
              icon: const Icon(Icons.logout, size: 16),
              label: const Text('Log Out'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: const BorderSide(color: Colors.red),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

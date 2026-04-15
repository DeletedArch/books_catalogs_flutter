import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../data/mock_data.dart';
import '../../models/book.dart';
import '../../models/user.dart';
import '../../services/auth_service.dart';
import '../../widgets/app_navbar.dart';
import '../../widgets/app_footer.dart';
import 'sections/book_row_section.dart';
import '../book/book_detail_screen.dart';
import '../account/account_settings_screen.dart';

class DashboardScreen extends StatefulWidget {
  final AppUser user;
  final VoidCallback? onLogout;

  const DashboardScreen({super.key, required this.user, this.onLogout});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final _searchController = TextEditingController();
  final _authService = AuthService();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Add bookId map to MockData or use title as temp key
  void _handleBookTap(Book book) {
    final idMap = {
      'To Kill a Mockingbird': 'tkam',
      'The Lord of the Rings': 'lotr',
    };
    final bookId = idMap[book.title];
    if (bookId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No detail page for: ${book.title}')),
      );
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => BookDetailScreen(
          bookId: bookId,
          currentUser: widget.user,
          onBack: () => Navigator.pop(context),
          onCharts: _handleCharts,
          onAI: _handleAI,
          onAccount: _handleAccount,
        ),
      ),
    );
  }

  void _handleLogout() {
    _authService.logout();
    widget.onLogout?.call();
  }

  void _handleCharts() {
    // TODO: Navigate to charts screen
  }

  void _handleAI() {
    // TODO: Navigate to AI assistant screen
  }

 void _handleAccount() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => _AccountSheet(
        user: widget.user,
        onSettings: () {
          Navigator.pop(context); // close sheet first
          _goToSettings();
        },
        onLogout: _handleLogout,
      ),
    );
  }

  void _goToSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AccountSettingsScreen(
          user: widget.user,
          onUserUpdated: (updatedUser) {
            // Bubble updated user back up if needed
            // For now just update local state via setState
            setState(() {});
          },
          onCharts: _handleCharts,
          onAI: _handleAI,
          onAccount: _handleAccount,
          onAddBook: () {
            // TODO: Navigate to Add Book screen
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Add Book screen coming soon')),
            );
          },
        ),
      ),
    );
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
          ),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  BookRowSection(
                    title: 'Recently Added',
                    books: MockData.recentlyAdded,
                    onBookTap: _handleBookTap,
                  ),
                  const _Divider(),
                  BookRowSection(
                    title: 'Recommended for You',
                    books: MockData.recommended,
                    onBookTap: _handleBookTap,
                  ),
                  const _Divider(),
                  BookRowSection(
                    title: 'Popular This Week',
                    books: MockData.popularThisWeek,
                    onBookTap: _handleBookTap,
                  ),
                  const _Divider(),
                  BookRowSection(
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
    return Padding(
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

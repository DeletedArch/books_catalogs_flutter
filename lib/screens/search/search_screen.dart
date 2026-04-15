import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/book_detail.dart';
import '../../models/user.dart';
import '../../repositories/catalog_repository.dart';
import '../../services/catalog_service.dart';
import '../../widgets/app_footer.dart';
import 'widgets/search_result_tile.dart';

class SearchScreen extends StatefulWidget {
  final AppUser currentUser;
  final String initialQuery;
  final void Function(BookDetail book)? onBookTap;
  final VoidCallback? onCharts;
  final VoidCallback? onAI;
  final VoidCallback? onAccount;
  final VoidCallback? onBrandTap; // ADD THIS

  const SearchScreen({
    super.key,
    required this.currentUser,
    this.initialQuery = '',
    this.onBookTap,
    this.onCharts,
    this.onAI,
    this.onAccount,
    this.onBrandTap, // ADD THIS
  });

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;
  final CatalogRepository _catalogRepo = MockCatalogService();

  List<BookDetail> _results = [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    if (widget.initialQuery.isNotEmpty) {
      _performSearch(widget.initialQuery);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _hasSearched = true;
    });

    final response = await _catalogRepo.searchBooks(query: query);

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (response.isOk) {
        _results = response.data ?? [];
      } else {
        _errorMessage = response.errors.isNotEmpty
            ? response.errors.first
            : response.message;
        _results = [];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EE),
      body: Column(
        children: [
          // Navbar with active search
          _SearchNavbar(
            controller: _searchController,
            currentUser: widget.currentUser,
            onSearch: _performSearch,
            onCharts: widget.onCharts,
            onAI: widget.onAI,
            onAccount: widget.onAccount,
            onBrandTap: widget.onBrandTap, // ADD THIS
          ),
          Expanded(child: _buildBody()),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Text(
          _errorMessage!,
          style: const TextStyle(color: AppTheme.textGrey),
        ),
      );
    }

    if (!_hasSearched) {
      return const Center(
        child: Text(
          'Search for books by title or author.',
          style: TextStyle(color: AppTheme.textGrey, fontSize: 14),
        ),
      );
    }

    if (_results.isEmpty) {
      return Center(
        child: Text(
          'No results for "${_searchController.text}"',
          style: const TextStyle(color: AppTheme.textGrey, fontSize: 14),
        ),
      );
    }

    return ListView.builder(
      itemCount: _results.length,
      itemBuilder: (context, index) => SearchResultTile(
        book: _results[index],
        onTap: widget.onBookTap != null
            ? () => widget.onBookTap!(_results[index])
            : null,
      ),
    );
  }
}

// Navbar variant with search submission on keyboard action
class _SearchNavbar extends StatelessWidget {
  final TextEditingController controller;
  final AppUser currentUser;
  final void Function(String) onSearch;
  final VoidCallback? onCharts;
  final VoidCallback? onAI;
  final VoidCallback? onAccount;
  final VoidCallback? onBrandTap; // ADD THIS

  const _SearchNavbar({
    required this.controller,
    required this.currentUser,
    required this.onSearch,
    this.onCharts,
    this.onAI,
    this.onAccount,
    this.onBrandTap, // ADD THIS
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBrandTap,
            child: const Text('Catalogs', style: AppTheme.navBrand),
          ),
          // const Text('Catalogs', style: AppTheme.navBrand),
          const SizedBox(width: 12),
          Expanded(
            child: Container(
              height: 38,
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextField(
                controller: controller,
                autofocus: true,
                style: const TextStyle(color: AppTheme.white, fontSize: 13),
                textInputAction: TextInputAction.search,
                onSubmitted: onSearch,
                decoration: InputDecoration(
                  hintText: 'Search for books...',
                  hintStyle: const TextStyle(
                    color: Color(0xFF666666),
                    fontSize: 13,
                  ),
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.search,
                      color: Color(0xFF888888),
                      size: 16,
                    ),
                    onPressed: () => onSearch(controller.text),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          _NavBtn(label: 'Charts', icon: Icons.bar_chart, onTap: onCharts),
          const SizedBox(width: 6),
          _NavBtn(label: 'AI', icon: Icons.auto_awesome, onTap: onAI),
          const SizedBox(width: 6),
          _NavBtn(label: 'Account', icon: Icons.person, onTap: onAccount),
        ],
      ),
    );
  }
}

class _NavBtn extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _NavBtn({required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFF444444)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: AppTheme.white, size: 14),
            const SizedBox(width: 4),
            Text(
              label,
              style: const TextStyle(color: AppTheme.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}

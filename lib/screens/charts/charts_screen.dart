import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/chart_entry.dart';
import '../../models/user.dart';
import '../../repositories/catalog_repository.dart';
import '../../services/catalog_service.dart';
import '../../widgets/app_navbar.dart';
import '../../widgets/app_footer.dart';
import 'widgets/chart_entry_tile.dart';

class ChartsScreen extends StatefulWidget {
  final AppUser currentUser;
  final void Function(String bookId)? onBookTap;
  final VoidCallback? onCharts;
  final VoidCallback? onAI;
  final VoidCallback? onAccount;

  const ChartsScreen({
    super.key,
    required this.currentUser,
    this.onBookTap,
    this.onCharts,
    this.onAI,
    this.onAccount,
  });

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  final _searchController = TextEditingController();
  final CatalogRepository _catalogRepo = MockCatalogService();

  List<ChartEntry> _entries = [];
  bool _isLoading = true;
  String? _error;

  // Filter options — extend for backend later
  static const List<String> _filters = ['All Time', 'This Month', 'This Week'];
  String _selectedFilter = 'All Time';

  @override
  void initState() {
    super.initState();
    _loadCharts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadCharts() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    // TODO: pass filter as query param to backend
    final response = await _catalogRepo.getCharts(limit: 10);

    if (!mounted) return;
    setState(() {
      _isLoading = false;
      if (response.isOk) {
        _entries = response.data ?? [];
      } else {
        _error = response.message ?? 'Failed to load charts.';
      }
    });
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
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? _ErrorView(error: _error!, onRetry: _loadCharts)
                : _ChartsBody(
                    entries: _entries,
                    filters: _filters,
                    selectedFilter: _selectedFilter,
                    onFilterChanged: (f) {
                      setState(() => _selectedFilter = f);
                      _loadCharts(); // re-fetch with new filter later
                    },
                    onBookTap: widget.onBookTap,
                  ),
          ),
          const AppFooter(),
        ],
      ),
    );
  }
}

class _ChartsBody extends StatelessWidget {
  final List<ChartEntry> entries;
  final List<String> filters;
  final String selectedFilter;
  final void Function(String) onFilterChanged;
  final void Function(String bookId)? onBookTap;

  const _ChartsBody({
    required this.entries,
    required this.filters,
    required this.selectedFilter,
    required this.onFilterChanged,
    this.onBookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header row
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Book Charts',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              // Filter dropdown
              _FilterDropdown(
                filters: filters,
                selected: selectedFilter,
                onChanged: onFilterChanged,
              ),
            ],
          ),
        ),
        // List
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: AppTheme.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE0E0E0)),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ListView.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) => ChartEntryTile(
                  entry: entries[index],
                  onTap: onBookTap != null
                      ? () => onBookTap!(entries[index].bookId)
                      : null,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _FilterDropdown extends StatelessWidget {
  final List<String> filters;
  final String selected;
  final void Function(String) onChanged;

  const _FilterDropdown({
    required this.filters,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: AppTheme.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selected,
          dropdownColor: AppTheme.black,
          style: const TextStyle(color: AppTheme.white, fontSize: 13),
          icon: const Icon(
            Icons.keyboard_arrow_down,
            color: AppTheme.white,
            size: 18,
          ),
          items: filters
              .map((f) => DropdownMenuItem(value: f, child: Text(f)))
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
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

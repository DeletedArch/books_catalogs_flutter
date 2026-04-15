import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'models/user.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
import 'screens/search/search_screen.dart';
import 'screens/charts/charts_screen.dart';
import 'screens/add_book/add_book_screen.dart';
import 'screens/book/book_detail_screen.dart';
import 'screens/account/account_settings_screen.dart';
import 'services/auth_service.dart';

class CatalogsApp extends StatelessWidget {
  const CatalogsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catalogs',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      home: const _RootNavigator(),
    );
  }
}

class _RootNavigator extends StatefulWidget {
  const _RootNavigator();

  @override
  State<_RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<_RootNavigator> {
  _Screen _current = _Screen.home;
  AppUser? _user;

  // Search state
  String _pendingSearchQuery = '';

  // Book detail state
  String? _pendingBookId;

  void _goTo(_Screen screen) => setState(() => _current = screen);

  void _onLoginSuccess(AppUser user) =>
      setState(() {
        _user = user;
        _current = _Screen.dashboard;
      });

  void _onLogout() =>
      setState(() {
        _user = null;
        _current = _Screen.home;
      });

  void _onUserUpdated(AppUser user) =>
      setState(() => _user = user);

  // ── Shared nav callbacks ───────────────────────────────────────────────

  void _goCharts() => _goTo(_Screen.charts);
  void _goAI() {
    // TODO: AI screen
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('AI coming soon')));
  }

  void _goAccount() {
    if (_user == null) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => _buildAccountSettings(),
      ),
    );
  }

  void _goSearch(String query) {
    setState(() {
      _pendingSearchQuery = query;
      _current = _Screen.search;
    });
  }

  void _goBookDetail(String bookId) {
    if (_user == null) return;
    setState(() {
      _pendingBookId = bookId;
      _current = _Screen.bookDetail;
    });
  }

  void _goAddBook() => _goTo(_Screen.addBook);

  // ── Screen builders ───────────────────────────────────────────────────

  Widget _buildAccountSettings() {
    return _AccountSettingsWrapper(
      user: _user!,
      onUserUpdated: _onUserUpdated,
      onLogout: _onLogout,
      onCharts: _goCharts,
      onAI: _goAI,
      onAddBook: _goAddBook,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (_current) {
      case _Screen.home:
        return HomeScreen(
          onLogin: () => _goTo(_Screen.login),
          onSignUp: () => _goTo(_Screen.signUp),
        );

      case _Screen.login:
        return LoginScreen(
          onSignUpTap: () => _goTo(_Screen.signUp),
          onLoginSuccess: () =>
              _onLoginSuccess(AuthService().currentUser!),
        );

      case _Screen.signUp:
        return SignUpScreen(
          onLoginTap: () => _goTo(_Screen.login),
          onSignUpSuccess: () =>
              _onLoginSuccess(AuthService().currentUser!),
        );

      case _Screen.dashboard:
        return DashboardScreen(
          user: _user!,
          onLogout: _onLogout,
          onBookTap: (book) => _goBookDetail(book.title),
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
          onSearch: _goSearch,
        );

      case _Screen.search:
        return SearchScreen(
          currentUser: _user!,
          initialQuery: _pendingSearchQuery,
          onBookTap: (book) => _goBookDetail(book.id),
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
        );

      case _Screen.charts:
        return ChartsScreen(
          currentUser: _user!,
          onBookTap: _goBookDetail,
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
        );

      case _Screen.addBook:
        return AddBookScreen(
          currentUser: _user!,
          onCancel: () => _goTo(_Screen.dashboard),
          onBookAdded: () => _goTo(_Screen.dashboard),
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
        );

      case _Screen.bookDetail:
        return BookDetailScreen(
          bookId: _pendingBookId ?? 'tkam',
          currentUser: _user!,
          onBack: () => _goTo(_Screen.dashboard),
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
        );
    }
  }
}

enum _Screen {
  home,
  login,
  signUp,
  dashboard,
  search,
  charts,
  addBook,
  bookDetail,
}

// Thin wrapper to avoid importing account screen directly in app.dart
class _AccountSettingsWrapper extends StatelessWidget {
  final AppUser user;
  final void Function(AppUser) onUserUpdated;
  final VoidCallback onLogout;
  final VoidCallback? onCharts;
  final VoidCallback? onAI;
  final VoidCallback? onAddBook;

  const _AccountSettingsWrapper({
    required this.user,
    required this.onUserUpdated,
    required this.onLogout,
    this.onCharts,
    this.onAI,
    this.onAddBook,
  });

  @override
  Widget build(BuildContext context) {
    return AccountSettingsScreen(
      user: user,
      onUserUpdated: onUserUpdated,
      onCharts: onCharts,
      onAI: onAI,
      onAccount: () => Navigator.pop(context),
      onAddBook: onAddBook,
    );
  }
}

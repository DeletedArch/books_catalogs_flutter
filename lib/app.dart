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
import 'screens/ai/ai_screen.dart';
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

  void _goHome() {
    print('Going home');
    print(_user?.username);
    setState(() => _current = _Screen.home);
  }

  void _goDashboard() {
    setState(() => _current = _Screen.dashboard);
  }

  void _goTo(_Screen screen) => setState(() => _current = screen);

  void _onLoginSuccess(AppUser user) => setState(() {
    _user = user;
    _current = _Screen.dashboard;
  });

  void _onLogout() => setState(() {
    _user = null;
    _current = _Screen.home;
  });

  void _onUserUpdated(AppUser user) => setState(() => _user = user);

  // ── Shared nav callbacks ───────────────────────────────────────────────

  void _goCharts() => _goTo(_Screen.charts);
  void _goAI() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AIScreen(
          currentUser: _user!,
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
          onBrandTap: _goDashboard,
        ),
      ),
    );
  }

  void _goAccount() {
    if (_user == null) return;
    setState(() => _current = _Screen.account);
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

  @override
  Widget build(BuildContext context) {
    switch (_current) {
      case _Screen.home:
        return HomeScreen(
          onLogin: () => _goTo(_Screen.login),
          onSignUp: () => _goTo(_Screen.signUp),
          onBrandTap: _goHome, // ADD THIS
        );

      case _Screen.login:
        return LoginScreen(
          onSignUpTap: () => _goTo(_Screen.signUp),
          onLoginSuccess: () => _onLoginSuccess(AuthService().currentUser!),
          onBrandTap: _goHome, // ADD THIS
        );

      case _Screen.signUp:
        return SignUpScreen(
          onLoginTap: () => _goTo(_Screen.login),
          onSignUpSuccess: () => _onLoginSuccess(AuthService().currentUser!),
          onBrandTap: _goHome, // ADD THIS
        );

      case _Screen.dashboard:
        return DashboardScreen(
          user: _user!,
          onLogout: _onLogout,
          onBookTap: (book) {
            final idMap = {
              'To Kill a Mockingbird': 'tkam',
              '1984': '1984',
              'Pride and Prejudice': 'pap',
              'The Great Gatsby': 'tgg',
              'Moby Dick': 'md',
              'The Catcher in the Rye': 'citr',
              'Brave New World': 'bnw',
              'The Hobbit': 'hobbit',
              "Harry Potter and the Sorcerer's Stone": 'hp1',
              'The Lord of the Rings': 'lotr',
              'Animal Farm': 'af',
            };
            final bookId = idMap[book.title] ?? book.title;
            _goBookDetail(bookId);
          },
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
          onSearch: _goSearch,
          onBrandTap: _goDashboard, // ADD THIS
        );

      case _Screen.search:
        return SearchScreen(
          currentUser: _user!,
          initialQuery: _pendingSearchQuery,
          onBookTap: (book) => _goBookDetail(book.id),
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
          onBrandTap: _user != null ? _goDashboard : _goHome, // ADD THIS
        );

      case _Screen.charts:
        return ChartsScreen(
          currentUser: _user!,
          onBookTap: _goBookDetail,
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
          onBrandTap: _user != null ? _goDashboard : _goHome, // ADD THIS
        );

      case _Screen.addBook:
        return AddBookScreen(
          currentUser: _user!,
          onCancel: () => _goTo(_Screen.dashboard),
          onBookAdded: () => _goTo(_Screen.dashboard),
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
          onBrandTap: _goDashboard, // ADD THIS (author only)
        );

      case _Screen.bookDetail:
        return BookDetailScreen(
          bookId: _pendingBookId ?? 'tkam',
          currentUser: _user!,
          onBack: () => _goTo(_Screen.dashboard),
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goAccount,
          onBrandTap: _user != null ? _goDashboard : _goHome, // ADD THIS
        );
      case _Screen.account:
        return AccountSettingsScreen(
          user: _user!,
          onUserUpdated: _onUserUpdated,
          onCharts: _goCharts,
          onAI: _goAI,
          onAccount: _goDashboard,
          onAddBook: _goAddBook,
          onBrandTap: _goDashboard,
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
  account,
}

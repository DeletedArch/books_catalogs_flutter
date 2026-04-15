import 'package:flutter/material.dart';
import 'core/theme.dart';
import 'models/user.dart';
import 'screens/home/home_screen.dart';
import 'screens/auth/login_screen.dart';
import 'screens/auth/signup_screen.dart';
import 'screens/dashboard/dashboard_screen.dart';
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

// Manages which screen is shown based on auth state
// Replace with a proper router (go_router) or state management later
class _RootNavigator extends StatefulWidget {
  const _RootNavigator();

  @override
  State<_RootNavigator> createState() => _RootNavigatorState();
}

class _RootNavigatorState extends State<_RootNavigator> {
  _Screen _current = _Screen.home;
  AppUser? _user;

  void _goTo(_Screen screen) => setState(() => _current = screen);

  void _onLoginSuccess(AppUser user) {
    setState(() {
      _user = user;
      _current = _Screen.dashboard;
    });
  }

  void _onLogout() {
    setState(() {
      _user = null;
      _current = _Screen.home;
    });
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
          onLoginSuccess: () {
            final user = AuthService().currentUser!;
            _onLoginSuccess(user);
          },
        );
      case _Screen.signUp:
        return SignUpScreen(
          onLoginTap: () => _goTo(_Screen.login),
          onSignUpSuccess: () {
            final user = AuthService().currentUser!;
            _onLoginSuccess(user);
          },
        );
      case _Screen.dashboard:
        return DashboardScreen(user: _user!, onLogout: _onLogout);
    }
  }
}

enum _Screen { home, login, signUp, dashboard }

import 'package:flutter/material.dart';
import '../core/theme.dart';
import '../models/user.dart';

class AppNavbar extends StatelessWidget {
  final TextEditingController searchController;
  final AppUser? currentUser;

  // Guest callbacks
  final VoidCallback? onLogin;
  final VoidCallback? onSignUp;

  // Logged-in callbacks
  final VoidCallback? onCharts;
  final VoidCallback? onAI;
  final VoidCallback? onAccount;

  // Search submission
  final void Function(String query)? onSearch;

  // Brand/logo tap — goes to home or dashboard based on login
  final VoidCallback? onBrandTap;

  const AppNavbar({
    super.key,
    required this.searchController,
    this.currentUser,
    this.onLogin,
    this.onSignUp,
    this.onCharts,
    this.onAI,
    this.onAccount,
    this.onSearch,
    this.onBrandTap,
  });

  bool get _isLoggedIn => currentUser != null;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppTheme.black,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Brand — tap to go home/dashboard
          GestureDetector(
            onTap: onBrandTap,
            child: const Text('Catalogs', style: AppTheme.navBrand),
            // child: const Text('Catalogs', style: AppTheme.navBrand),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _SearchBar(controller: searchController, onSearch: onSearch),
          ),
          const SizedBox(width: 8),
          if (_isLoggedIn) ...[
            _NavButton(label: 'Charts', icon: Icons.bar_chart, onTap: onCharts),
            const SizedBox(width: 6),
            _NavButton(label: 'AI', icon: Icons.auto_awesome, onTap: onAI),
            const SizedBox(width: 6),
            _NavButton(label: 'Account', icon: Icons.person, onTap: onAccount),
          ] else ...[
            _NavButton(label: 'Log In', icon: Icons.login, onTap: onLogin),
            const SizedBox(width: 6),
            _NavButton(
              label: 'Sign Up',
              icon: Icons.person_add,
              onTap: onSignUp,
            ),
          ],
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  final TextEditingController controller;
  final void Function(String query)? onSearch;

  const _SearchBar({required this.controller, this.onSearch});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 38,
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(8),
      ),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: AppTheme.white, fontSize: 13),
        textInputAction: TextInputAction.search,
        onSubmitted: onSearch,
        decoration: InputDecoration(
          hintText: 'Search for books...',
          hintStyle: const TextStyle(color: Color(0xFF666666), fontSize: 13),
          // REMOVED prefixIcon — only keep suffix search button
          suffixIcon: IconButton(
            icon: const Icon(Icons.search, color: Color(0xFF888888), size: 16),
            onPressed: () => onSearch?.call(controller.text),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  const _NavButton({required this.label, required this.icon, this.onTap});

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

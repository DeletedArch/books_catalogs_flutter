import 'package:flutter/material.dart';
import '../../core/theme.dart';
import '../../models/user.dart';
import '../../widgets/app_navbar.dart';
import '../../widgets/app_footer.dart';
import 'widgets/information_section.dart';
import 'widgets/password_section.dart';
import 'widgets/management_section.dart';

class AccountSettingsScreen extends StatefulWidget {
  final AppUser user;
  final void Function(AppUser updatedUser) onUserUpdated;
  final VoidCallback? onCharts;
  final VoidCallback? onAI;
  final VoidCallback? onAccount;
  final VoidCallback? onAddBook;
  final VoidCallback? onBrandTap; // ADD THIS

  const AccountSettingsScreen({
    super.key,
    required this.user,
    required this.onUserUpdated,
    this.onCharts,
    this.onAI,
    this.onAccount,
    this.onAddBook,
    this.onBrandTap, // ADD THIS
  });

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _searchController = TextEditingController();
  late AppUser _user;

  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _handleUserUpdated(AppUser updatedUser) {
    setState(() => _user = updatedUser);
    widget.onUserUpdated(updatedUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F3EE),
      body: Column(
        children: [
          AppNavbar(
            searchController: _searchController,
            currentUser: _user,
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
                  // Title
                  const Text(
                    'Account Settings',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.black,
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Information card
                  InformationSection(
                    user: _user,
                    onUpdated: _handleUserUpdated,
                  ),

                  const SizedBox(height: 16),

                  // Password card
                  PasswordSection(user: _user),

                  // Management card — author only
                  if (_user.isAuthor) ...[
                    const SizedBox(height: 16),
                    ManagementSection(onAddBook: widget.onAddBook),
                  ],

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

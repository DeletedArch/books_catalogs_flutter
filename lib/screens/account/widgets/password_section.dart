import 'package:flutter/material.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/auth_text_field.dart';
import 'settings_card.dart';

class PasswordSection extends StatefulWidget {
  final AppUser user;

  const PasswordSection({super.key, required this.user});

  @override
  State<PasswordSection> createState() => _PasswordSectionState();
}

class _PasswordSectionState extends State<PasswordSection> {
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final UserRepository _userRepo = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void dispose() {
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final result = await _userRepo.updatePassword(
      currentUsername: widget.user.username,
      currentPassword: _currentPasswordController.text,
      newPassword: _newPasswordController.text,
      confirmNewPassword: _confirmPasswordController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      setState(() => _successMessage = 'Password updated successfully.');
    } else {
      setState(() => _errorMessage = result.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Password',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTextField(
            label: 'Current Password',
            controller: _currentPasswordController,
            isPassword: true,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            label: 'New Password',
            controller: _newPasswordController,
            isPassword: true,
          ),
          const SizedBox(height: 16),
          AuthTextField(
            label: 'Confirm New Password',
            controller: _confirmPasswordController,
            isPassword: true,
          ),
          if (_errorMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ],
          if (_successMessage != null) ...[
            const SizedBox(height: 8),
            Text(
              _successMessage!,
              style: const TextStyle(color: Colors.green, fontSize: 12),
            ),
          ],
          const SizedBox(height: 16),
          _UpdateButton(isLoading: _isLoading, onTap: _handleUpdate),
        ],
      ),
    );
  }
}

class _UpdateButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onTap;

  const _UpdateButton({required this.isLoading, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF0A0A0A),
          borderRadius: BorderRadius.circular(6),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: Color(0xFFFFFFFF),
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Update',
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

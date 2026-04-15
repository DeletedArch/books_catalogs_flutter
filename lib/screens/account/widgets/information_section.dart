import 'package:flutter/material.dart';
import '../../../core/theme.dart';
import '../../../models/user.dart';
import '../../../repositories/user_repository.dart';
import '../../../services/auth_service.dart';
import '../../../widgets/auth_text_field.dart';
import 'settings_card.dart';

class InformationSection extends StatefulWidget {
  final AppUser user;
  final void Function(AppUser updatedUser) onUpdated;

  const InformationSection({
    super.key,
    required this.user,
    required this.onUpdated,
  });

  @override
  State<InformationSection> createState() => _InformationSectionState();
}

class _InformationSectionState extends State<InformationSection> {
  late final TextEditingController _nameController;
  final UserRepository _userRepo = AuthService();

  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.username);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdate() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    final result = await _userRepo.updateName(
      currentUsername: widget.user.username,
      newName: _nameController.text,
    );

    if (!mounted) return;
    setState(() => _isLoading = false);

    if (result.isSuccess) {
      setState(() => _successMessage = 'Name updated successfully.');
      widget.onUpdated(result.updatedUser!);
    } else {
      setState(() => _errorMessage = result.errorMessage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SettingsCard(
      title: 'Information',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthTextField(label: 'Name:', controller: _nameController),
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
          color: AppTheme.black,
          borderRadius: BorderRadius.circular(6),
        ),
        child: isLoading
            ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                  color: AppTheme.white,
                  strokeWidth: 2,
                ),
              )
            : const Text(
                'Update',
                style: TextStyle(
                  color: AppTheme.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
      ),
    );
  }
}

import '../models/user.dart';
import '../repositories/user_repository.dart';
import '../services/book_service.dart';

class AuthService implements UserRepository {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // ── Login ────────────────────────────────────────────────────────────────

  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email.isEmpty || password.isEmpty) {
      return AuthResult.failure('Please fill in all fields.');
    }

    // Mock author account
    if (email == kMockAuthorEmail && password == kMockAuthorPassword) {
      _currentUser = AppUser(
        username: kMockAuthorUsername,
        email: email,
        isAuthor: true,
      );
      return AuthResult.success(_currentUser!);
    }

    if (!email.contains('@')) {
      return AuthResult.failure('Please enter a valid email.');
    }
    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters.');
    }

    _currentUser = AppUser(
      username: email.split('@').first,
      email: email,
      isAuthor: false,
    );
    return AuthResult.success(_currentUser!);
  }

  // ── Sign Up ──────────────────────────────────────────────────────────────

  Future<AuthResult> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (username.isEmpty || email.isEmpty || password.isEmpty) {
      return AuthResult.failure('Please fill in all fields.');
    }
    if (!email.contains('@')) {
      return AuthResult.failure('Please enter a valid email.');
    }
    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters.');
    }
    if (password != confirmPassword) {
      return AuthResult.failure('Passwords do not match.');
    }

    _currentUser = AppUser(username: username, email: email, isAuthor: false);
    return AuthResult.success(_currentUser!);
  }

  // ── Update Name ──────────────────────────────────────────────────────────

  @override
  Future<UpdateResult> updateName({
    required String currentUsername,
    required String newName,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // TODO: PATCH /users/:username/name
    if (newName.trim().isEmpty) {
      return UpdateResult.failure('Name cannot be empty.');
    }
    if (newName.trim().length < 3) {
      return UpdateResult.failure('Name must be at least 3 characters.');
    }

    _currentUser = _currentUser?.copyWith(username: newName.trim());
    return UpdateResult.success(_currentUser!);
  }

  // ── Update Password ──────────────────────────────────────────────────────

  @override
  Future<UpdateResult> updatePassword({
    required String currentUsername,
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));

    // TODO: PATCH /users/:username/password
    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmNewPassword.isEmpty) {
      return UpdateResult.failure('Please fill in all fields.');
    }
    if (currentPassword.length < 6) {
      return UpdateResult.failure('Current password is incorrect.');
    }
    if (newPassword.length < 6) {
      return UpdateResult.failure(
        'New password must be at least 6 characters.',
      );
    }
    if (newPassword != confirmNewPassword) {
      return UpdateResult.failure('New passwords do not match.');
    }

    return UpdateResult.success(_currentUser!);
  }

  // ── Logout ───────────────────────────────────────────────────────────────

  void logout() {
    _currentUser = null;
  }
}

// ── Result wrapper ───────────────────────────────────────────────────────────

class AuthResult {
  final bool isSuccess;
  final String? errorMessage;
  final AppUser? user;

  const AuthResult._({required this.isSuccess, this.errorMessage, this.user});

  factory AuthResult.success(AppUser user) =>
      AuthResult._(isSuccess: true, user: user);

  factory AuthResult.failure(String message) =>
      AuthResult._(isSuccess: false, errorMessage: message);
}

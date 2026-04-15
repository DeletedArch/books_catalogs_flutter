import '../models/user.dart';

// Swap the internals for real API calls later
// All screens talk to this service only — never to raw http directly

const String kMockAuthorUsername = 'author_account';
const String kMockAuthorEmail = 'author@catalogs.com';
const String kMockAuthorPassword = 'author123';

class AuthService {
  // Singleton so one instance is shared across the app
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;
  bool get isLoggedIn => _currentUser != null;

  // --- Mock Auth (replace bodies with http calls later) ---

Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    if (email.isEmpty || password.isEmpty) {
      return AuthResult.failure('Please fill in all fields.');
    }

    // Mock author account check
    if (email == kMockAuthorEmail && password == kMockAuthorPassword) {
      _currentUser = AppUser(username: kMockAuthorUsername, email: email);
      return AuthResult.success(_currentUser!);
    }

    if (!email.contains('@')) {
      return AuthResult.failure('Please enter a valid email.');
    }
    if (password.length < 6) {
      return AuthResult.failure('Password must be at least 6 characters.');
    }

    _currentUser = AppUser(username: email.split('@').first, email: email);
    return AuthResult.success(_currentUser!);
  }

  Future<AuthResult> signUp({
    required String username,
    required String email,
    required String password,
    required String confirmPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 800));

    // TODO: Replace with real API call

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

    _currentUser = AppUser(username: username, email: email);
    return AuthResult.success(_currentUser!);
  }

  void logout() {
    _currentUser = null;
  }
}

// Clean result wrapper — avoids throwing exceptions for expected failures
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

import '../models/user.dart';

// Swap internals for HTTP later — screens never call http directly
abstract class UserRepository {
  Future<UpdateResult> updateName({
    required String currentUsername,
    required String newName,
  });

  Future<UpdateResult> updatePassword({
    required String currentUsername,
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  });
}

class UpdateResult {
  final bool isSuccess;
  final String? errorMessage;
  final AppUser? updatedUser;

  const UpdateResult._({
    required this.isSuccess,
    this.errorMessage,
    this.updatedUser,
  });

  factory UpdateResult.success(AppUser user) =>
      UpdateResult._(isSuccess: true, updatedUser: user);

  factory UpdateResult.failure(String message) =>
      UpdateResult._(isSuccess: false, errorMessage: message);
}

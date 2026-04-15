class AppUser {
  final String username;
  final String email;
  final bool isAuthor; // controls Management section visibility

  const AppUser({
    required this.username,
    required this.email,
    this.isAuthor = false,
  });

  AppUser copyWith({String? username, String? email, bool? isAuthor}) =>
      AppUser(
        username: username ?? this.username,
        email: email ?? this.email,
        isAuthor: isAuthor ?? this.isAuthor,
      );

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    username: json['username'] as String,
    email: json['email'] as String,
    isAuthor: json['isAuthor'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'isAuthor': isAuthor,
  };
}

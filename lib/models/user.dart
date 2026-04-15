class AppUser {
  final String username;
  final String email;

  const AppUser({required this.username, required this.email});

  // Ready for JSON parsing from backend
  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
    username: json['username'] as String,
    email: json['email'] as String,
  );

  Map<String, dynamic> toJson() => {'username': username, 'email': email};
}

class Review {
  final String id;
  final String username;
  final double rating;
  final String content;
  final DateTime date;

  const Review({
    required this.id,
    required this.username,
    required this.rating,
    required this.content,
    required this.date,
  });

  // Ready for backend
  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json['id'] as String,
    username: json['username'] as String,
    rating: (json['rating'] as num).toDouble(),
    content: json['content'] as String,
    date: DateTime.parse(json['date'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'rating': rating,
    'content': content,
    'date': date.toIso8601String(),
  };
}

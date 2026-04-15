class Book {
  final String title;
  final String author;
  final String? coverUrl; // null = show placeholder

  const Book({required this.title, required this.author, this.coverUrl});
}

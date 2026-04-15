// Mirrors the C# AddBookRequest DTO sent to POST /api/books
class AddBookRequest {
  final String title;
  final String author;
  final String description;
  final String publishedYear;
  final String publisher;
  final int pages;
  final String language;
  final String isbn;
  final String genre;
  final String? coverUrl;
  final bool isSeries;

  const AddBookRequest({
    required this.title,
    required this.author,
    required this.description,
    required this.publishedYear,
    required this.publisher,
    required this.pages,
    required this.language,
    required this.isbn,
    required this.genre,
    this.coverUrl,
    this.isSeries = false,
  });

  // Serialize to send as HTTP body
  Map<String, dynamic> toJson() => {
    'title': title,
    'author': author,
    'description': description,
    'publishedYear': publishedYear,
    'publisher': publisher,
    'pages': pages,
    'language': language,
    'isbn': isbn,
    'genre': genre,
    'coverUrl': coverUrl,
    'isSeries': isSeries,
  };

  // Validate before sending — mirrors FluentValidation rules
  List<String> validate() {
    final errors = <String>[];
    if (title.trim().isEmpty) errors.add('Title is required.');
    if (author.trim().isEmpty) errors.add('Author is required.');
    if (description.trim().isEmpty) errors.add('Description is required.');
    if (publishedYear.trim().isEmpty) errors.add('Published year is required.');
    if (publisher.trim().isEmpty) errors.add('Publisher is required.');
    if (pages <= 0) errors.add('Pages must be greater than 0.');
    if (language.trim().isEmpty) errors.add('Language is required.');
    if (isbn.trim().isEmpty) errors.add('ISBN is required.');
    if (genre.trim().isEmpty) errors.add('Genre is required.');
    return errors;
  }
}

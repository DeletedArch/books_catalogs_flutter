import '../models/book_detail.dart';
import '../models/review.dart';
import '../models/volume.dart';
import '../repositories/book_repository.dart';

// MOCK AUTHOR — has edit access to all books
// To add a real author system, replace isAuthor() with an API call
const String kMockAuthorUsername = 'author_account';
const String kMockAuthorEmail = 'author@catalogs.com';
const String kMockAuthorPassword = 'author123';

class MockBookService implements BookRepository {
  // Singleton
  static final MockBookService _instance = MockBookService._internal();
  factory MockBookService() => _instance;
  MockBookService._internal();

  // In-memory store (replace with HTTP later)
  final Map<String, BookDetail> _books = {
    'tkam': BookDetail(
      id: 'tkam',
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      authorUsername: kMockAuthorUsername,
      description:
          "The unforgettable novel of a childhood in a sleepy Southern town "
          "and the crisis of conscience that rocked it. 'To Kill A Mockingbird' "
          "became both an instant bestseller and a critical success when it was "
          "first published in 1960. It went on to win the Pulitzer Prize in 1961 "
          "and was later made into an Academy Award-winning film, also a classic.",
      publishedYear: '1960',
      publisher: 'J.B. Lippincott & Co.',
      pages: 324,
      language: 'English',
      isbn: '978-0-06-112008-4',
      averageRating: 3.5,
      ratingCount: 1234,
      isSeries: false,
      reviews: [
        Review(
          id: 'r1',
          username: 'BookLover42',
          rating: 5,
          content:
              'An absolute masterpiece! This book changed my perspective on so many things.',
          date: DateTime(2026, 3, 1),
        ),
        Review(
          id: 'r2',
          username: 'ReaderJane',
          rating: 4,
          content:
              'Beautifully written with unforgettable characters. A must-read classic.',
          date: DateTime(2026, 2, 28),
        ),
        Review(
          id: 'r3',
          username: 'ClassicFan',
          rating: 5,
          content:
              'One of the best books I\'ve ever read. The themes are still relevant today.',
          date: DateTime(2026, 2, 25),
        ),
      ],
    ),
    'lotr': BookDetail(
      id: 'lotr',
      title: 'The Lord of the Rings',
      author: 'J.R.R. Tolkien',
      authorUsername: kMockAuthorUsername,
      description:
          'An epic high-fantasy novel written by English author and scholar '
          'J. R. R. Tolkien. The story began as a sequel to Tolkien\'s 1937 '
          'fantasy novel The Hobbit, but eventually developed into a much larger '
          'work. Written in stages between 1937 and 1949, The Lord of the Rings '
          'is one of the best-selling novels ever written.',
      publishedYear: '1954-1955',
      publisher: 'Allen & Unwin',
      language: 'English',
      averageRating: 4.5,
      ratingCount: 5678,
      isSeries: true,
      volumes: [
        Volume(number: 1, title: 'The Fellowship of the Ring', pages: 423),
        Volume(number: 2, title: 'The Two Towers', pages: 352),
        Volume(number: 3, title: 'The Return of the King', pages: 416),
      ],
      reviews: [
        Review(
          id: 'r4',
          username: 'FantasyFan',
          rating: 5,
          content:
              "The greatest fantasy series ever written. Tolkien's world-building is unmatched.",
          date: DateTime(2026, 3, 5),
        ),
        Review(
          id: 'r5',
          username: 'EpicReader',
          rating: 5,
          content:
              'A timeless masterpiece that has influenced countless works of fantasy.',
          date: DateTime(2026, 3, 3),
        ),
      ],
    ),
  };

  @override
  Future<BookDetail> getBookById(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final book = _books[bookId];
    if (book == null) throw Exception('Book not found: $bookId');
    return book;
  }

  @override
  Future<bool> isAuthor({
    required String bookId,
    required String username,
  }) async {
    // TODO: Replace with GET /books/:bookId/authorship?username=username
    await Future.delayed(const Duration(milliseconds: 200));
    final book = _books[bookId];
    if (book == null) return false;
    return book.authorUsername == username;
  }

  @override
  Future<void> submitReview({
    required String bookId,
    required Review review,
  }) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // TODO: POST /books/:bookId/reviews
    final book = _books[bookId];
    if (book == null) return;
    final updated = List<Review>.from(book.reviews)..insert(0, review);
    _books[bookId] = BookDetail(
      id: book.id,
      title: book.title,
      author: book.author,
      authorUsername: book.authorUsername,
      description: book.description,
      averageRating: book.averageRating,
      ratingCount: book.ratingCount,
      coverUrl: book.coverUrl,
      publishedYear: book.publishedYear,
      publisher: book.publisher,
      pages: book.pages,
      language: book.language,
      isbn: book.isbn,
      fileUrl: book.fileUrl,
      isSeries: book.isSeries,
      volumes: book.volumes,
      reviews: updated,
    );
  }

  @override
  Future<void> deleteReview({
    required String bookId,
    required String reviewId,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    // TODO: DELETE /books/:bookId/reviews/:reviewId
    final book = _books[bookId];
    if (book == null) return;
    final updated = book.reviews.where((r) => r.id != reviewId).toList();
    _books[bookId] = BookDetail(
      id: book.id,
      title: book.title,
      author: book.author,
      authorUsername: book.authorUsername,
      description: book.description,
      averageRating: book.averageRating,
      ratingCount: book.ratingCount,
      coverUrl: book.coverUrl,
      publishedYear: book.publishedYear,
      publisher: book.publisher,
      pages: book.pages,
      language: book.language,
      isbn: book.isbn,
      fileUrl: book.fileUrl,
      isSeries: book.isSeries,
      volumes: book.volumes,
      reviews: updated,
    );
  }

  @override
  Future<void> deleteBook(String bookId) async {
    await Future.delayed(const Duration(milliseconds: 400));
    // TODO: DELETE /books/:bookId
    _books.remove(bookId);
  }
}

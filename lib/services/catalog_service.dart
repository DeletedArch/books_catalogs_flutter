import '../models/api_response.dart';
import '../models/book_detail.dart';
import '../models/chart_entry.dart';
import '../models/add_book_request.dart';
import '../repositories/catalog_repository.dart';

// Mock .NET-style database
// All methods return ApiResponse<T> exactly as a real controller would

class MockCatalogService implements CatalogRepository {
  static final MockCatalogService _instance = MockCatalogService._internal();
  factory MockCatalogService() => _instance;
  MockCatalogService._internal();

  // ── Mock DB ───────────────────────────────────────────────────────────────

  static final List<BookDetail> _db = [
    _book(
      id: 'tkam',
      title: 'To Kill a Mockingbird',
      author: 'Harper Lee',
      description:
          "The unforgettable novel of a childhood in a sleepy Southern town and the crisis of conscience that rocked it.",
      year: '1960',
      publisher: 'J.B. Lippincott & Co.',
      pages: 324,
      language: 'English',
      isbn: '978-0-06-112008-4',
      genre: 'Fiction',
      rating: 3.5,
      ratingCount: 1234,
    ),
    _book(
      id: '1984',
      title: '1984',
      author: 'George Orwell',
      description:
          'A dystopian novel set in a totalitarian society ruled by Big Brother.',
      year: '1949',
      publisher: 'Secker & Warburg',
      pages: 328,
      language: 'English',
      isbn: '978-0-45-228423-4',
      genre: 'Dystopian',
      rating: 4.5,
      ratingCount: 5678,
    ),
    _book(
      id: 'pap',
      title: 'Pride and Prejudice',
      author: 'Jane Austen',
      description:
          'A romantic novel following the emotional development of Elizabeth Bennet.',
      year: '1813',
      publisher: 'T. Egerton',
      pages: 432,
      language: 'English',
      isbn: '978-0-14-143951-8',
      genre: 'Romance',
      rating: 4.0,
      ratingCount: 3456,
    ),
    _book(
      id: 'tgg',
      title: 'The Great Gatsby',
      author: 'F. Scott Fitzgerald',
      description: 'A novel about the American Dream set in the Jazz Age.',
      year: '1925',
      publisher: 'Charles Scribner\'s Sons',
      pages: 180,
      language: 'English',
      isbn: '978-0-74-326182-1',
      genre: 'Fiction',
      rating: 3.8,
      ratingCount: 2890,
    ),
    _book(
      id: 'md',
      title: 'Moby Dick',
      author: 'Herman Melville',
      description:
          'The saga of Captain Ahab\'s obsessive quest to hunt the white whale.',
      year: '1851',
      publisher: 'Harper & Brothers',
      pages: 635,
      language: 'English',
      isbn: '978-0-14-243723-7',
      genre: 'Adventure',
      rating: 3.5,
      ratingCount: 1567,
    ),
    _book(
      id: 'citr',
      title: 'The Catcher in the Rye',
      author: 'J.D. Salinger',
      description:
          'A coming-of-age story narrated by teenage Holden Caulfield.',
      year: '1951',
      publisher: 'Little, Brown and Company',
      pages: 277,
      language: 'English',
      isbn: '978-0-31-676948-0',
      genre: 'Fiction',
      rating: 3.7,
      ratingCount: 2100,
    ),
    _book(
      id: 'bnw',
      title: 'Brave New World',
      author: 'Aldous Huxley',
      description:
          'A dystopian novel set in a futuristic World State of genetically modified citizens.',
      year: '1932',
      publisher: 'Chatto & Windus',
      pages: 311,
      language: 'English',
      isbn: '978-0-06-085052-4',
      genre: 'Dystopian',
      rating: 4.1,
      ratingCount: 3200,
    ),
    _book(
      id: 'hobbit',
      title: 'The Hobbit',
      author: 'J.R.R. Tolkien',
      description:
          'The adventure of Bilbo Baggins who journeys to reclaim treasure from the dragon Smaug.',
      year: '1937',
      publisher: 'Allen & Unwin',
      pages: 310,
      language: 'English',
      isbn: '978-0-54-792822-7',
      genre: 'Fantasy',
      rating: 4.6,
      ratingCount: 6789,
    ),
    _book(
      id: 'hp1',
      title: "Harry Potter and the Sorcerer's Stone",
      author: 'J.K. Rowling',
      description:
          'A young wizard discovers his magical heritage on his 11th birthday.',
      year: '1997',
      publisher: 'Bloomsbury',
      pages: 309,
      language: 'English',
      isbn: '978-0-43-970818-8',
      genre: 'Fantasy',
      rating: 4.8,
      ratingCount: 12345,
    ),
    _book(
      id: 'lotr',
      title: 'The Lord of the Rings',
      author: 'J.R.R. Tolkien',
      description:
          'An epic high-fantasy novel about the quest to destroy the One Ring.',
      year: '1954',
      publisher: 'Allen & Unwin',
      pages: 1178,
      language: 'English',
      isbn: '978-0-61-834399-7',
      genre: 'Fantasy',
      rating: 4.9,
      ratingCount: 15678,
      isSeries: true,
    ),
    _book(
      id: 'af',
      title: 'Animal Farm',
      author: 'George Orwell',
      description:
          'An allegorical novella reflecting events leading up to the Russian Revolution.',
      year: '1945',
      publisher: 'Secker & Warburg',
      pages: 112,
      language: 'English',
      isbn: '978-0-45-228424-1',
      genre: 'Political Satire',
      rating: 4.2,
      ratingCount: 4500,
    ),
  ];

  // ── Helper to build BookDetail quickly ───────────────────────────────────

  static BookDetail _book({
    required String id,
    required String title,
    required String author,
    required String description,
    required String year,
    required String publisher,
    required int pages,
    required String language,
    required String isbn,
    required String genre,
    required double rating,
    required int ratingCount,
    bool isSeries = false,
  }) => BookDetail(
    id: id,
    title: title,
    author: author,
    authorUsername: 'author_account',
    description: description,
    publishedYear: year,
    publisher: publisher,
    pages: pages,
    language: language,
    isbn: isbn,
    averageRating: rating,
    ratingCount: ratingCount,
    isSeries: isSeries,
    reviews: [],
  );

  // ── Chart data (rank + readerCount) ──────────────────────────────────────

  static final List<_ChartMeta> _chartMeta = [
    _ChartMeta('tkam', 45300),
    _ChartMeta('1984', 42100),
    _ChartMeta('pap', 38900),
    _ChartMeta('tgg', 35700),
    _ChartMeta('citr', 33200),
    _ChartMeta('hobbit', 31600),
    _ChartMeta('hp1', 29900),
    _ChartMeta('lotr', 28400),
    _ChartMeta('af', 26100),
    _ChartMeta('bnw', 24900),
  ];

  // ── CatalogRepository impl ───────────────────────────────────────────────

  @override
  Future<ApiResponse<List<BookDetail>>> searchBooks({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    // Simulates GET /api/books/search?q=query&page=1&pageSize=20
    await Future.delayed(const Duration(milliseconds: 400));

    if (query.trim().isEmpty) {
      return ApiResponse.badRequest(['Search query cannot be empty.']);
    }

    final q = query.toLowerCase().trim();
    final results = _db.where((b) {
      return b.title.toLowerCase().contains(q) ||
          b.author.toLowerCase().contains(q);
    }).toList();

    // Basic pagination
    final start = (page - 1) * pageSize;
    if (start >= results.length) {
      return ApiResponse.ok(<BookDetail>[]);
    }
    final paged = results.skip(start).take(pageSize).toList();

    return ApiResponse.ok(paged);
  }

  @override
  Future<ApiResponse<List<ChartEntry>>> getCharts({int limit = 10}) async {
    // Simulates GET /api/charts?limit=10
    await Future.delayed(const Duration(milliseconds: 400));

    final entries = <ChartEntry>[];
    for (int i = 0; i < _chartMeta.length && i < limit; i++) {
      final meta = _chartMeta[i];
      final book = _db.firstWhere(
        (b) => b.id == meta.bookId,
        orElse: () => throw Exception('Chart book not found'),
      );
      entries.add(
        ChartEntry(
          rank: i + 1,
          bookId: meta.bookId,
          title: book.title,
          author: book.author,
          readerCount: meta.readerCount,
        ),
      );
    }

    return ApiResponse.ok(entries);
  }

  @override
  Future<ApiResponse<BookDetail>> addBook(AddBookRequest request) async {
    // Simulates POST /api/books
    await Future.delayed(const Duration(milliseconds: 600));

    final errors = request.validate();
    if (errors.isNotEmpty) {
      return ApiResponse.badRequest(errors);
    }

    final newBook = BookDetail(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: request.title,
      author: request.author,
      authorUsername: 'author_account',
      description: request.description,
      publishedYear: request.publishedYear,
      publisher: request.publisher,
      pages: request.pages,
      language: request.language,
      isbn: request.isbn,
      averageRating: 0,
      ratingCount: 0,
      isSeries: request.isSeries,
      reviews: [],
    );

    _db.add(newBook);
    return ApiResponse.created(newBook);
  }
}

class _ChartMeta {
  final String bookId;
  final int readerCount;
  const _ChartMeta(this.bookId, this.readerCount);
}

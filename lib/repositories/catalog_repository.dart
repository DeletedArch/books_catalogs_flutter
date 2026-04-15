import '../models/api_response.dart';
import '../models/book_detail.dart';
import '../models/chart_entry.dart';
import '../models/add_book_request.dart';

// One unified abstract layer for all catalog operations
// Replace MockCatalogService with RemoteCatalogService later

abstract class CatalogRepository {
  // GET /api/books/search?q=query&page=1&pageSize=20
  Future<ApiResponse<List<BookDetail>>> searchBooks({
    required String query,
    int page = 1,
    int pageSize = 20,
  });

  // GET /api/charts?limit=10
  Future<ApiResponse<List<ChartEntry>>> getCharts({int limit = 10});

  // POST /api/books
  Future<ApiResponse<BookDetail>> addBook(AddBookRequest request);
}

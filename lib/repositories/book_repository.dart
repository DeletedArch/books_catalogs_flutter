import '../models/book_detail.dart';
import '../models/review.dart';

// Abstract contract — swap mock for real HTTP implementation
// without touching any screen

abstract class BookRepository {
  Future<BookDetail> getBookById(String bookId);
  Future<void> submitReview({required String bookId, required Review review});
  Future<void> deleteReview({required String bookId, required String reviewId});
  Future<void> deleteBook(String bookId);

  // Check if a user is the author of a book
  // Backend version: GET /books/:id/authorship?username=x
  Future<bool> isAuthor({required String bookId, required String username});
}

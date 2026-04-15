import 'review.dart';
import 'volume.dart';

class BookDetail {
  final String id;
  final String title;
  final String author;
  final String? coverUrl;
  final String description;
  final String? publishedYear;
  final String? publisher;
  final int? pages;
  final String? language;
  final String? isbn;
  final double averageRating;
  final int ratingCount;
  final List<Review> reviews;
  final String? fileUrl;

  // Series-specific — null means it's a standalone book
  final bool isSeries;
  final List<Volume> volumes;

  // Author control
  final String authorUsername; // matched against logged-in user

  const BookDetail({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
    required this.averageRating,
    required this.ratingCount,
    required this.reviews,
    required this.authorUsername,
    this.coverUrl,
    this.publishedYear,
    this.publisher,
    this.pages,
    this.language,
    this.isbn,
    this.fileUrl,
    this.isSeries = false,
    this.volumes = const [],
  });

  factory BookDetail.fromJson(Map<String, dynamic> json) => BookDetail(
    id: json['id'] as String,
    title: json['title'] as String,
    author: json['author'] as String,
    description: json['description'] as String,
    averageRating: (json['averageRating'] as num).toDouble(),
    ratingCount: json['ratingCount'] as int,
    authorUsername: json['authorUsername'] as String,
    coverUrl: json['coverUrl'] as String?,
    publishedYear: json['publishedYear'] as String?,
    publisher: json['publisher'] as String?,
    pages: json['pages'] as int?,
    language: json['language'] as String?,
    isbn: json['isbn'] as String?,
    fileUrl: json['fileUrl'] as String?,
    isSeries: json['isSeries'] as bool? ?? false,
    reviews: (json['reviews'] as List<dynamic>? ?? [])
        .map((r) => Review.fromJson(r as Map<String, dynamic>))
        .toList(),
    volumes: (json['volumes'] as List<dynamic>? ?? [])
        .map((v) => Volume.fromJson(v as Map<String, dynamic>))
        .toList(),
  );
}

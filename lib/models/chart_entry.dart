class ChartEntry {
  final int rank;
  final String bookId;
  final String title;
  final String author;
  final String? coverUrl;
  final int readerCount;

  const ChartEntry({
    required this.rank,
    required this.bookId,
    required this.title,
    required this.author,
    required this.readerCount,
    this.coverUrl,
  });

  // .NET JSON shape: { "rank": 1, "bookId": "tkam", ... }
  factory ChartEntry.fromJson(Map<String, dynamic> json) => ChartEntry(
    rank: json['rank'] as int,
    bookId: json['bookId'] as String,
    title: json['title'] as String,
    author: json['author'] as String,
    readerCount: json['readerCount'] as int,
    coverUrl: json['coverUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'rank': rank,
    'bookId': bookId,
    'title': title,
    'author': author,
    'readerCount': readerCount,
    'coverUrl': coverUrl,
  };

  String get formattedReaderCount {
    if (readerCount >= 1000) {
      return '${(readerCount / 1000).toStringAsFixed(1)}K readers';
    }
    return '$readerCount readers';
  }
}

class Volume {
  final int number;
  final String title;
  final int pages;
  final String? fileUrl;

  const Volume({
    required this.number,
    required this.title,
    required this.pages,
    this.fileUrl,
  });

  factory Volume.fromJson(Map<String, dynamic> json) => Volume(
    number: json['number'] as int,
    title: json['title'] as String,
    pages: json['pages'] as int,
    fileUrl: json['fileUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'number': number,
    'title': title,
    'pages': pages,
    'fileUrl': fileUrl,
  };
}

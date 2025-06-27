import '../../domain/entities/book.dart';

class BookModel extends Book {
  BookModel({
    required super.title,
    required super.author,
    required super.coverUrl,
    required super.olid,
  });

  // Add this method:
  Map<String, dynamic> toMap() => {
    'olid': olid,
    'title': title,
    'author': author,
    'coverUrl': coverUrl,
  };

  factory BookModel.fromJson(Map<String, dynamic> json) {
    return BookModel(
      title: json['title'] ?? '',
      author: (json['author_name'] as List?)?.join(', ') ?? '',
      coverUrl: json['cover_i'] != null
          ? "https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg"
          : '',
      olid: (json['key'] as String?)?.replaceAll('/works/', '') ?? '',
    );
  }

  factory BookModel.fromMap(Map<String, dynamic> map) {
    return BookModel(
      olid: map['olid'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      coverUrl: map['coverUrl'] ?? '',
    );
  }
}


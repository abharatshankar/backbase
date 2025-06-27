import '../entities/book.dart';

abstract class BookRepository {
  /// Searches books from remote if online, otherwise from local database.
  Future<List<Book>> searchBooks(String query, int page);
  Future<void> saveBook(Book book);
  Future<List<Book>> getSavedBooks();
}

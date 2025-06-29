import 'package:flutter/material.dart';
import '../../domain/entities/book.dart';
import '../../domain/repositories/book_repository.dart';

class BookProvider extends ChangeNotifier {
  final BookRepository repository;
  List<Book> books = [];
  bool isLoading = false;
  bool isFetchingMore = false;
  int currentPage = 1;
  bool hasMore = true;
  String errorMessage = '';

  BookProvider(this.repository);

  Future<void> searchBooks(String query, {bool isRefresh = false}) async {
    if (isLoading && !isRefresh) return;
    
    isLoading = true;
    errorMessage = '';
    if (isRefresh) {
      books = [];
      currentPage = 1;
      hasMore = true;
    }
    notifyListeners();
    
    try {
      final results = await repository.searchBooks(query, currentPage);
      if (results.isEmpty) {
        hasMore = false;
        if (books.isEmpty) {
          errorMessage = 'No books found.';
        }
      }
      books.addAll(results);
      currentPage++;
    } catch (e) {
      errorMessage = e.toString();
      if (errorMessage.contains('Network error')) {
        errorMessage = 'Check your internet connection and try again.';
      } else if (errorMessage.contains('No books found')) {
        errorMessage = 'No books found. Try a different search term.';
      }
      books = [];
      hasMore = false;
    }
    
    isLoading = false;
    notifyListeners();
  }

  Future<void> refresh(String query) async {
    return searchBooks(query, isRefresh: true);
  }
}
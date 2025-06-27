import 'package:backbase/presentation/screens/book_title.dart';
import 'package:backbase/presentation/screens/shimmer_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/book_provider.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();
  String currentQuery = '';

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BookProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Book Finder")),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(12),
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                labelText: 'Search Books',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    currentQuery = _controller.text;
                    provider.refresh(currentQuery);
                  },
                ),
              ),
              onSubmitted: (value) {
                currentQuery = value;
                provider.refresh(currentQuery);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ElevatedButton.icon(
                  icon: Icon(Icons.storage),
                  label: Text('Show Local Books'),
                  onPressed: () async {
                    provider.isLoading = true;
                    provider.notifyListeners();
                    try {
                      final localBooks = await provider.repository.getSavedBooks();
                      provider.books = localBooks;
                      provider.errorMessage = '';
                      provider.hasMore = false;
                    } catch (e) {
                      provider.errorMessage = 'Failed to load local books';
                      provider.books = [];
                      provider.hasMore = false;
                    }
                    provider.isLoading = false;
                    provider.notifyListeners();
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                provider.refresh(currentQuery);
              },
              child:
                  provider.isLoading && provider.books.isEmpty
                      ? ShimmerList() // Show shimmer loading
                      : provider.errorMessage.isNotEmpty
                      ? Center(child: Text(provider.errorMessage))
                      : ListView.builder(
                        itemCount:
                            provider.books.length + (provider.hasMore ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == provider.books.length &&
                              provider.hasMore) {
                            // Trigger fetch safely AFTER the current build completes
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!provider.isLoading) {
                                provider.searchBooks(currentQuery);
                              }
                            });
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child: CircularProgressIndicator(),
                              ),
                            );
                          }
                          return BookTile(book: provider.books[index]);
                        },
                      ),
            ),
          ),
        ],
      ),
    );
  }
}
